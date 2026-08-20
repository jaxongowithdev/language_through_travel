import '../models/conversation.dart';
import '../models/lesson.dart';
import '../models/reference.dart';
import '../models/spoken_line.dart';
import '../models/word_card.dart';

/// Bộ đọc nội dung.
///
/// Toàn bộ nội dung của app được viết dưới dạng bảng văn bản ngăn bằng dấu `|`
/// thay vì hàng nghìn lời gọi constructor. Lý do rất thực tế: một câu chiếm
/// đúng một dòng, nên người biên soạn đọc và sửa nội dung như đọc bảng tính,
/// còn phần dựng model thì gom về một chỗ duy nhất là file này.
///
/// Quy ước chung cho mọi bảng:
///   * Dòng bắt đầu bằng `#` mở một nhóm mới (bài học hoặc hội thoại).
///   * Các cột ngăn nhau bằng `|`, không có khoảng trắng thừa quanh dấu ngăn.
///   * Cột cuối có thể bỏ trống nếu không cần.
///   * Nội dung tuyệt đối không chứa ký tự `|`.
class ContentParser {
  const ContentParser._();

  static List<String> _cols(String row) =>
      row.split('|').map((String c) => c.trim()).toList();

  static String _at(List<String> cols, int index) =>
      index < cols.length ? cols[index] : '';

  /// Số thứ tự hai chữ số cho id: 1 → `01`.
  static String _pad(int n) => n.toString().padLeft(2, '0');

  // --- Bài học -----------------------------------------------------------

  /// Đọc bảng câu của một chủ đề thành danh sách bài học.
  ///
  /// Dòng nhóm:  `#|Tiêu đề bài|Mục tiêu của bài`
  /// Dòng câu:   `Câu tiếng Anh|Nghĩa tiếng Việt|Mẹo dùng (tuỳ chọn)`
  static List<Lesson> lessons(String topicCode, List<String> rows) {
    final List<Lesson> result = <Lesson>[];
    String title = '';
    String goal = '';
    List<SpokenLine> buffer = <SpokenLine>[];
    int lessonIndex = 0;

    void flush() {
      if (title.isEmpty) return;
      result.add(
        Lesson(
          id: '$topicCode.l$lessonIndex',
          title: title,
          goal: goal,
          lines: List<SpokenLine>.unmodifiable(buffer),
        ),
      );
    }

    for (final String row in rows) {
      if (row.isEmpty) continue;
      final List<String> cols = _cols(row);
      if (cols.first == '#') {
        flush();
        lessonIndex += 1;
        title = _at(cols, 1);
        goal = _at(cols, 2);
        buffer = <SpokenLine>[];
        continue;
      }
      if (title.isEmpty) continue; // Bỏ qua dòng lạc trước nhóm đầu tiên.
      buffer.add(
        SpokenLine(
          id: '$topicCode.l$lessonIndex.${_pad(buffer.length + 1)}',
          english: cols.first,
          vietnamese: _at(cols, 1),
          tip: _at(cols, 2),
        ),
      );
    }
    flush();
    return List<Lesson>.unmodifiable(result);
  }

  // --- Từ vựng -----------------------------------------------------------

  /// Dòng: `từ|IPA|từ loại|nghĩa|ví dụ|dịch ví dụ`
  static List<WordCard> words(String topicCode, List<String> rows) {
    final List<WordCard> result = <WordCard>[];
    for (final String row in rows) {
      if (row.isEmpty) continue;
      final List<String> cols = _cols(row);
      result.add(
        WordCard(
          id: '$topicCode.w${_pad(result.length + 1)}',
          word: cols.first,
          ipa: _at(cols, 1),
          partOfSpeech: _at(cols, 2),
          vietnamese: _at(cols, 3),
          example: _at(cols, 4),
          exampleVi: _at(cols, 5),
        ),
      );
    }
    return List<WordCard>.unmodifiable(result);
  }

  // --- Hội thoại ---------------------------------------------------------

  /// Dòng nhóm: `#|Tiêu đề|Bối cảnh`
  /// Dòng nói:  `Vai|Câu tiếng Anh|Nghĩa tiếng Việt`
  /// Vai bắt đầu bằng `>` là lượt của người học.
  static List<Conversation> conversations(
    String topicCode,
    List<String> rows,
  ) {
    final List<Conversation> result = <Conversation>[];
    String title = '';
    String setting = '';
    List<ConversationTurn> buffer = <ConversationTurn>[];
    int index = 0;

    void flush() {
      if (title.isEmpty) return;
      result.add(
        Conversation(
          id: '$topicCode.c$index',
          title: title,
          setting: setting,
          turns: List<ConversationTurn>.unmodifiable(buffer),
        ),
      );
    }

    for (final String row in rows) {
      if (row.isEmpty) continue;
      final List<String> cols = _cols(row);
      if (cols.first == '#') {
        flush();
        index += 1;
        title = _at(cols, 1);
        setting = _at(cols, 2);
        buffer = <ConversationTurn>[];
        continue;
      }
      if (title.isEmpty) continue;
      final String rawSpeaker = cols.first;
      final bool isLearner = rawSpeaker.startsWith('>');
      buffer.add(
        ConversationTurn(
          speaker: isLearner ? rawSpeaker.substring(1).trim() : rawSpeaker,
          english: _at(cols, 1),
          vietnamese: _at(cols, 2),
          isLearner: isLearner,
        ),
      );
    }
    flush();
    return List<Conversation>.unmodifiable(result);
  }

  // --- Sổ tay tra cứu ----------------------------------------------------

  /// Dòng: `tiêu đề|công thức|nghĩa|giải thích|ví dụ EN 1|ví dụ VI 1|ví dụ EN 2|ví dụ VI 2`
  ///
  /// Hai ví dụ cuối là tuỳ chọn; để trống thì mục chỉ có một ví dụ.
  static List<RefEntry> refEntries(String prefix, List<String> rows) {
    final List<RefEntry> result = <RefEntry>[];
    for (final String row in rows) {
      if (row.isEmpty) continue;
      final List<String> cols = _cols(row);
      final List<RefExample> examples = <RefExample>[];
      for (int i = 4; i + 1 < cols.length; i += 2) {
        if (cols[i].isEmpty) continue;
        examples.add(RefExample(cols[i], cols[i + 1]));
      }
      result.add(
        RefEntry(
          id: '$prefix.${_pad(result.length + 1)}',
          headword: cols.first,
          formula: _at(cols, 1),
          meaning: _at(cols, 2),
          explain: _at(cols, 3),
          examples: List<RefExample>.unmodifiable(examples),
        ),
      );
    }
    return List<RefEntry>.unmodifiable(result);
  }
}
