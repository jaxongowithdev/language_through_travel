import 'package:flutter/material.dart';

import '../models/conversation.dart';
import '../models/lesson.dart';
import '../models/reference.dart';
import '../models/spoken_line.dart';
import '../models/topic.dart';
import '../models/word_card.dart';
import '../theme/palette.dart';
import 'daily_tips.dart';
import 'pack_a.dart';
import 'pack_b.dart';
import 'pack_c.dart';
import 'pack_d.dart';
import 'parser.dart';
import 'ref_forms.dart';
import 'ref_grammar.dart';
import 'ref_lexis.dart';

/// Một mẹo ngắn hiển thị trên tab Hôm nay.
@immutable
class DailyTip {
  const DailyTip(this.title, this.body);
  final String title;
  final String body;
}

/// Điểm truy cập duy nhất tới toàn bộ nội dung của app.
///
/// Nội dung là hằng số biên dịch vào trong binary, nên [Library] chỉ dựng model
/// một lần rồi giữ trong bộ nhớ. Không có mạng, không có tệp ngoài, không có
/// bước tải nào ở lần mở app đầu tiên.
class Library {
  Library._();

  static final Library instance = Library._();

  List<Topic>? _topics;
  List<RefSection>? _reference;
  List<DailyTip>? _tips;
  Map<String, SpokenLine>? _lineIndex;

  // --- Chủ đề ------------------------------------------------------------

  List<Topic> get topics => _topics ??= _buildTopics();

  Topic topic(String code) =>
      topics.firstWhere((Topic t) => t.code == code, orElse: () => topics.first);

  /// Toàn bộ câu của mọi chủ đề, giữ nguyên thứ tự học.
  List<SpokenLine> get allLines => <SpokenLine>[
        for (final Topic t in topics) ...t.lines,
      ];

  List<WordCard> get allWords => <WordCard>[
        for (final Topic t in topics) ...t.words,
      ];

  List<Conversation> get allConversations => <Conversation>[
        for (final Topic t in topics) ...t.conversations,
      ];

  Map<String, SpokenLine> get _index =>
      _lineIndex ??= <String, SpokenLine>{
        for (final SpokenLine line in allLines) line.id: line,
      };

  SpokenLine? lineById(String id) => _index[id];

  Lesson? lessonById(String id) {
    final String code = id.split('.').first;
    for (final Lesson lesson in topic(code).lessons) {
      if (lesson.id == id) return lesson;
    }
    return null;
  }

  /// Tìm kiếm không phân biệt hoa thường trên cả ba trường của câu.
  List<SpokenLine> searchLines(String query) {
    final String q = query.trim().toLowerCase();
    if (q.isEmpty) return const <SpokenLine>[];
    return allLines
        .where((SpokenLine l) =>
            l.english.toLowerCase().contains(q) ||
            l.vietnamese.toLowerCase().contains(q) ||
            l.tip.toLowerCase().contains(q))
        .toList();
  }

  List<WordCard> searchWords(String query) {
    final String q = query.trim().toLowerCase();
    if (q.isEmpty) return const <WordCard>[];
    return allWords
        .where((WordCard w) =>
            w.word.toLowerCase().contains(q) ||
            w.vietnamese.toLowerCase().contains(q))
        .toList();
  }

  // --- Sổ tay ------------------------------------------------------------

  List<RefSection> get reference => _reference ??= _buildReference();

  RefSection refSection(String id) => reference.firstWhere(
        (RefSection s) => s.id == id,
        orElse: () => reference.first,
      );

  List<RefEntry> searchReference(String query) {
    final String q = query.trim().toLowerCase();
    if (q.isEmpty) return const <RefEntry>[];
    return <RefEntry>[
      for (final RefSection section in reference)
        ...section.entries.where((RefEntry e) =>
            e.headword.toLowerCase().contains(q) ||
            e.meaning.toLowerCase().contains(q) ||
            e.formula.toLowerCase().contains(q)),
    ];
  }

  // --- Mẹo mỗi ngày ------------------------------------------------------

  List<DailyTip> get tips => _tips ??= <DailyTip>[
        for (final String row in dailyTipRows)
          if (row.isNotEmpty)
            DailyTip(row.split('|').first.trim(),
                row.split('|').length > 1 ? row.split('|')[1].trim() : ''),
      ];

  /// Mẹo của ngày [date], chọn theo số thứ tự ngày trong năm nên ổn định trong
  /// suốt một ngày và không cần lưu gì cả.
  DailyTip tipFor(DateTime date) {
    final int dayOfYear =
        date.difference(DateTime(date.year, 1, 1)).inDays;
    return tips[dayOfYear % tips.length];
  }

  // --- Thống kê nội dung, dùng cho tab Cá nhân và cho test ---------------

  int get lineCount => allLines.length;
  int get wordCount => allWords.length;
  int get conversationTurnCount {
    int total = 0;
    for (final Conversation c in allConversations) {
      total += c.turns.length;
    }
    return total;
  }

  int get referenceCount {
    int total = 0;
    for (final RefSection s in reference) {
      total += s.entryCount;
    }
    return total;
  }

  /// Tổng số mục nội dung trong app, hiển thị ở màn hình giới thiệu.
  int get totalItemCount =>
      lineCount + wordCount + conversationTurnCount + referenceCount + tips.length;

  // --- Dựng dữ liệu ------------------------------------------------------

  static Topic _topic({
    required String code,
    required String title,
    required String subtitle,
    required String emoji,
    required IconData icon,
    required int tintIndex,
    required SpeakLevel level,
    required List<String> lineRows,
    required List<String> wordRows,
    required List<String> talkRows,
  }) {
    return Topic(
      code: code,
      title: title,
      subtitle: subtitle,
      emoji: emoji,
      icon: icon,
      tint: Palette.tintFor(tintIndex),
      level: level,
      lessons: ContentParser.lessons(code, lineRows),
      words: ContentParser.words(code, wordRows),
      conversations: ContentParser.conversations(code, talkRows),
    );
  }

  static List<Topic> _buildTopics() {
    return <Topic>[
      _topic(
        code: 'smalltalk',
        title: 'Chào hỏi & bắt chuyện',
        subtitle: 'Mở lời với người lạ và giữ mạch câu chuyện',
        emoji: '👋',
        icon: Icons.waving_hand_rounded,
        tintIndex: 0,
        level: SpeakLevel.starter,
        lineRows: smalltalkLines,
        wordRows: smalltalkWords,
        talkRows: smalltalkTalk,
      ),
      _topic(
        code: 'selfintro',
        title: 'Giới thiệu bản thân',
        subtitle: 'Ba mươi giây nói về bạn mà không lắp bắp',
        emoji: '🙋',
        icon: Icons.badge_rounded,
        tintIndex: 1,
        level: SpeakLevel.starter,
        lineRows: selfintroLines,
        wordRows: selfintroWords,
        talkRows: selfintroTalk,
      ),
      _topic(
        code: 'daily',
        title: 'Một ngày của bạn',
        subtitle: 'Kể lại nếp sinh hoạt từ sáng tới tối',
        emoji: '☀️',
        icon: Icons.wb_sunny_rounded,
        tintIndex: 2,
        level: SpeakLevel.starter,
        lineRows: dailyLines,
        wordRows: dailyWords,
        talkRows: dailyTalk,
      ),
      _topic(
        code: 'numbers',
        title: 'Số, giờ & lịch hẹn',
        subtitle: 'Đọc số cho đúng và chốt lịch không hiểu nhầm',
        emoji: '🔢',
        icon: Icons.tag_rounded,
        tintIndex: 3,
        level: SpeakLevel.starter,
        lineRows: numbersLines,
        wordRows: numbersWords,
        talkRows: numbersTalk,
      ),
      _topic(
        code: 'weather',
        title: 'Thời tiết & mùa',
        subtitle: 'Chủ đề an toàn nhất để bắt chuyện với bất kỳ ai',
        emoji: '🌤',
        icon: Icons.cloud_rounded,
        tintIndex: 4,
        level: SpeakLevel.starter,
        lineRows: weatherLines,
        wordRows: weatherWords,
        talkRows: weatherTalk,
      ),
      _topic(
        code: 'family',
        title: 'Gia đình & bạn bè',
        subtitle: 'Kể về người thân và những mối quan hệ quanh bạn',
        emoji: '🏡',
        icon: Icons.diversity_3_rounded,
        tintIndex: 5,
        level: SpeakLevel.starter,
        lineRows: familyLines,
        wordRows: familyWords,
        talkRows: familyTalk,
      ),
      _topic(
        code: 'transport',
        title: 'Đi lại trong thành phố',
        subtitle: 'Xe buýt, xe công nghệ, gửi xe và hỏi đường',
        emoji: '🚌',
        icon: Icons.directions_bus_rounded,
        tintIndex: 6,
        level: SpeakLevel.everyday,
        lineRows: transportLines,
        wordRows: transportWords,
        talkRows: transportTalk,
      ),
      _topic(
        code: 'shopping',
        title: 'Mua sắm & đổi trả',
        subtitle: 'Hỏi cỡ, hỏi giá và xử lý khi hàng có vấn đề',
        emoji: '🛍',
        icon: Icons.shopping_bag_rounded,
        tintIndex: 7,
        level: SpeakLevel.everyday,
        lineRows: shoppingLines,
        wordRows: shoppingWords,
        talkRows: shoppingTalk,
      ),
      _topic(
        code: 'food',
        title: 'Đồ ăn & khẩu vị',
        subtitle: 'Nói về món bạn thích, chuyện bếp núc và rủ nhau ăn',
        emoji: '🍜',
        icon: Icons.ramen_dining_rounded,
        tintIndex: 8,
        level: SpeakLevel.everyday,
        lineRows: foodLines,
        wordRows: foodWords,
        talkRows: foodTalk,
      ),
      _topic(
        code: 'coffee',
        title: 'Hẹn gặp & rủ rê',
        subtitle: 'Mời, nhận lời, từ chối và giữ nhịp buổi gặp',
        emoji: '☕',
        icon: Icons.local_cafe_rounded,
        tintIndex: 9,
        level: SpeakLevel.everyday,
        lineRows: coffeeLines,
        wordRows: coffeeWords,
        talkRows: coffeeTalk,
      ),
      _topic(
        code: 'phone',
        title: 'Gọi điện & nhắn tin',
        subtitle: 'Nghe máy tự tin và nhắn tin đúng mực',
        emoji: '📞',
        icon: Icons.call_rounded,
        tintIndex: 10,
        level: SpeakLevel.everyday,
        lineRows: phoneLines,
        wordRows: phoneWords,
        talkRows: phoneTalk,
      ),
      _topic(
        code: 'home',
        title: 'Nhà cửa & thuê nhà',
        subtitle: 'Thuê nhà, báo hỏng và sống chung hoà thuận',
        emoji: '🏠',
        icon: Icons.home_work_rounded,
        tintIndex: 11,
        level: SpeakLevel.everyday,
        lineRows: homeLines,
        wordRows: homeWords,
        talkRows: homeTalk,
      ),
      _topic(
        code: 'health',
        title: 'Sức khoẻ & đi khám',
        subtitle: 'Mô tả triệu chứng và mua thuốc cho đúng',
        emoji: '🩺',
        icon: Icons.health_and_safety_rounded,
        tintIndex: 12,
        level: SpeakLevel.everyday,
        lineRows: healthLines,
        wordRows: healthWords,
        talkRows: healthTalk,
      ),
      _topic(
        code: 'money',
        title: 'Ngân hàng & chi tiêu',
        subtitle: 'Giao dịch ở ngân hàng và nói chuyện tiền nong',
        emoji: '💳',
        icon: Icons.account_balance_rounded,
        tintIndex: 13,
        level: SpeakLevel.everyday,
        lineRows: moneyLines,
        wordRows: moneyWords,
        talkRows: moneyTalk,
      ),
      _topic(
        code: 'work',
        title: 'Công sở & đồng nghiệp',
        subtitle: 'Báo tiến độ, nhờ vả và xin nghỉ phép',
        emoji: '💼',
        icon: Icons.work_rounded,
        tintIndex: 14,
        level: SpeakLevel.everyday,
        lineRows: workLines,
        wordRows: workWords,
        talkRows: workTalk,
      ),
      _topic(
        code: 'meeting',
        title: 'Họp & trình bày ý kiến',
        subtitle: 'Mở họp, nêu quan điểm và chốt việc',
        emoji: '📊',
        icon: Icons.groups_rounded,
        tintIndex: 15,
        level: SpeakLevel.confident,
        lineRows: meetingLines,
        wordRows: meetingWords,
        talkRows: meetingTalk,
      ),
      _topic(
        code: 'email',
        title: 'Email & tin nhắn công việc',
        subtitle: 'Viết thư ngắn, rõ và đúng mực',
        emoji: '✉️',
        icon: Icons.mail_rounded,
        tintIndex: 16,
        level: SpeakLevel.confident,
        lineRows: emailLines,
        wordRows: emailWords,
        talkRows: emailTalk,
      ),
      _topic(
        code: 'interview',
        title: 'Phỏng vấn xin việc',
        subtitle: 'Trả lời câu khó và thương lượng lương',
        emoji: '🎯',
        icon: Icons.psychology_rounded,
        tintIndex: 17,
        level: SpeakLevel.confident,
        lineRows: interviewLines,
        wordRows: interviewWords,
        talkRows: interviewTalk,
      ),
      _topic(
        code: 'feelings',
        title: 'Cảm xúc & động viên',
        subtitle: 'Gọi tên cảm xúc và an ủi người khác',
        emoji: '💛',
        icon: Icons.favorite_rounded,
        tintIndex: 18,
        level: SpeakLevel.confident,
        lineRows: feelingsLines,
        wordRows: feelingsWords,
        talkRows: feelingsTalk,
      ),
      _topic(
        code: 'apology',
        title: 'Xin lỗi & từ chối',
        subtitle: 'Nhận lỗi, nói không và gỡ hiểu lầm',
        emoji: '🤝',
        icon: Icons.handshake_rounded,
        tintIndex: 19,
        level: SpeakLevel.confident,
        lineRows: apologyLines,
        wordRows: apologyWords,
        talkRows: apologyTalk,
      ),
    ];
  }

  static List<RefSection> _buildReference() {
    return <RefSection>[
      RefSection(
        id: 'grammar',
        title: 'Ngữ pháp bỏ túi',
        subtitle: 'Điểm ngữ pháp cần nhất cho việc nói',
        icon: Icons.rule_rounded,
        tint: Palette.violet,
        entries: ContentParser.refEntries('grammar', grammarRows),
      ),
      RefSection(
        id: 'phrasal',
        title: 'Cụm động từ',
        subtitle: 'Cụm động từ gặp hằng ngày',
        icon: Icons.merge_type_rounded,
        tint: Palette.cyan,
        entries: ContentParser.refEntries('phrasal', phrasalRows),
      ),
      RefSection(
        id: 'idiom',
        title: 'Thành ngữ thông dụng',
        subtitle: 'Thành ngữ dùng được trong công việc',
        icon: Icons.auto_awesome_rounded,
        tint: Palette.amber,
        entries: ContentParser.refEntries('idiom', idiomRows),
      ),
      RefSection(
        id: 'irregular',
        title: 'Động từ bất quy tắc',
        subtitle: 'Động từ bất quy tắc theo nhóm dễ nhớ',
        icon: Icons.change_circle_rounded,
        tint: Palette.mint,
        entries: ContentParser.refEntries('irregular', irregularRows),
      ),
      RefSection(
        id: 'sound',
        title: 'Bảng âm IPA',
        subtitle: 'Bảng âm kèm lỗi người Việt hay mắc',
        icon: Icons.graphic_eq_rounded,
        tint: Palette.fuchsia,
        entries: ContentParser.refEntries('sound', soundRows),
      ),
    ];
  }
}
