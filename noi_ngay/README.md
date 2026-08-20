# Nói Ngay 🎙️

Luyện phản xạ nói tiếng Anh cho người Việt. Giao diện tiếng Việt, một ngôn ngữ
đích duy nhất là tiếng Anh.

> Mỗi câu học theo chiều **Việt → Anh**: thấy nghĩa trước, tự bật ra câu, rồi
> mới lật đáp án. Hiểu và nói được là hai việc khác nhau.

---

## Chạy thử

Dự án chứa mã nguồn (`lib/`, `test/`, `tool/`, `pubspec.yaml`) nhưng **chưa có
thư mục nền tảng**. Sinh chúng bằng một lệnh:

```bash
cd noi_ngay

# Sinh android/ ios/ web/ … mà không ghi đè lib/ và pubspec.yaml
flutter create .

flutter pub get
flutter run
```

Yêu cầu **Flutter 3.32 trở lên** (Dart 3.8+) — bản cũ hơn không có
`Color.withValues()` và `CardThemeData`.

```bash
flutter analyze
flutter test
```

Sinh lại bộ icon:

```bash
pip install pillow
python3 tool/generate_icons.py
dart run flutter_launcher_icons
```

---

## Nội dung

| Loại | Số lượng |
|---|---|
| Chủ đề | 20 |
| Bài học | 60 (3 bài mỗi chủ đề, 8 câu mỗi bài) |
| Câu giao tiếp | 480, câu nào cũng có nghĩa và mẹo dùng |
| Hội thoại mẫu | 20 đoạn, 160 lượt nói |
| Từ vựng | 200 mục kèm IPA, từ loại và ví dụ song ngữ |
| Ngữ pháp | 41 điểm, mỗi điểm có công thức và hai ví dụ |
| Cụm động từ | 60 |
| Thành ngữ | 50 |
| Động từ bất quy tắc | 89 |
| Bảng âm IPA | 44 âm, kèm lỗi người Việt hay mắc |
| Mẹo học | 40, mỗi ngày hiện một mẹo |
| **Tổng** | **1.164 mục** |

Hai mươi chủ đề: chào hỏi, giới thiệu bản thân, một ngày của bạn, số và lịch
hẹn, thời tiết, gia đình, đi lại, mua sắm, đồ ăn, hẹn gặp, gọi điện, nhà cửa,
sức khoẻ, ngân hàng, công sở, họp hành, email, phỏng vấn, cảm xúc, xin lỗi.

---

## Tính năng

| Tính năng | Mô tả |
|---|---|
| **Bốn tab** | Hôm nay · Chủ đề · Luyện tập (badge số câu đến hạn) · Cá nhân. |
| **Không khoá gì cả** | Cả hai mươi chủ đề mở sẵn từ lần mở app đầu tiên. Nhãn cấp độ chỉ để lọc, không để chặn. |
| **Bảng điều khiển** | Vòng mục tiêu ngày, chuỗi ngày, câu của ngày, mẹo của ngày, biểu đồ bảy ngày. |
| **Bài học ngược chiều** | Hiện nghĩa tiếng Việt, người học tự nói, rồi lật đáp án và tự chấm ba mức. |
| **Hộp Leitner năm ngăn** | Lịch cố định: hộp 1 quay lại trong phiên, rồi 1, 3, 7, 16 ngày. Hộp 5 tính là thuộc. |
| **Bốn trò luyện** | Điền từ · Sắp xếp câu · Nghe và chọn · Ghép nghĩa 60 giây. Mỗi trò lưu kỷ lục riêng và nuôi lịch ôn. |
| **Nhại theo** | Đọc chậm từng câu để người học nói theo, tốc độ chỉnh được từ 0.25 tới 0.7. |
| **Sổ tay tra cứu** | Năm mục, mỗi mục có ô lọc riêng. |
| **Tìm kiếm toàn cục** | Một ô tìm ra cả câu, từ vựng và mục sổ tay. |
| **Câu đã lưu** | Đánh dấu câu bất kỳ rồi mở thành một phiên học riêng. |
| **Mười hai cột mốc** | Tính lại từ dữ liệu thật, không lưu riêng nên không bao giờ lệch. |
| **Sáng và tối** | Mặc định tối; đổi trong Cá nhân → Cài đặt. |
| **Ngoại tuyến hoàn toàn** | Không một lệnh gọi mạng nào. Tiến độ nằm trong `SharedPreferences`. |

---

## Cấu trúc mã nguồn

```
lib/
├── main.dart                     # Khởi động, dựng Provider
├── theme/
│   ├── palette.dart              # Màu thương hiệu và bộ màu 20 chủ đề
│   └── app_theme.dart            # ThemeData sáng và tối
├── models/
│   ├── spoken_line.dart          # Một câu giao tiếp
│   ├── lesson.dart               # Một bài tám câu
│   ├── topic.dart                # Chủ đề, kèm enum cấp độ
│   ├── word_card.dart            # Từ vựng kèm IPA
│   ├── conversation.dart         # Hội thoại và từng lượt nói
│   ├── reference.dart            # Mục và nhóm mục sổ tay
│   ├── box_card.dart             # Hộp Leitner năm ngăn
│   └── milestone.dart            # Cột mốc
├── data/
│   ├── parser.dart               # Đọc bảng văn bản thành model
│   ├── pack_a.dart … pack_d.dart # Nội dung 20 chủ đề
│   ├── ref_grammar.dart          # Ngữ pháp
│   ├── ref_lexis.dart            # Cụm động từ và thành ngữ
│   ├── ref_forms.dart            # Động từ bất quy tắc và bảng âm
│   ├── daily_tips.dart           # Mẹo mỗi ngày
│   └── library.dart              # Điểm truy cập nội dung duy nhất
├── services/
│   ├── prefs_store.dart          # Nơi duy nhất chạm vào bộ nhớ máy
│   └── speech.dart               # Bọc flutter_tts, nuốt lỗi nền tảng
├── state/
│   └── learn_state.dart          # ChangeNotifier toàn cục
└── ui/
    ├── app.dart                  # MaterialApp
    ├── shell.dart                # Khung bốn tab, thanh tab kính mờ
    ├── tabs/                     # today · topics · drill · me
    ├── screens/                  # welcome, topic, lesson, conversation,
    │                             # review, reference, search, saved,
    │                             # shadowing, milestones, settings, about
    ├── drills/                   # fill_blank · word_order · listening ·
    │                             # speed_match · drill_common
    └── widgets/                  # aurora_background · glass_card ·
                                  # common · line_tile
```

---

## Nội dung viết dưới dạng bảng

Toàn bộ nội dung là `const List<String>` với các cột ngăn bằng dấu `|`, thay vì
hàng nghìn lời gọi constructor. Một câu chiếm đúng một dòng nên người biên soạn
đọc và sửa như đọc bảng tính, còn phần dựng model gom hết về `data/parser.dart`.

```dart
"#|Mở lời|Bắt chuyện với người mới gặp mà không gượng",
"Is this seat taken?|Ghế này có ai ngồi chưa ạ?|Hỏi trước khi ngồi xuống.",
```

Ba luật khi sửa nội dung:

1. cột ngăn bằng `|`, nội dung không được chứa `|`;
2. chuỗi Dart dùng nháy kép, nên nội dung không dùng nháy kép và không dùng ký
   tự đô-la (viết `dollars` bằng chữ);
3. dòng bắt đầu bằng `#` mở một nhóm mới.

`test/content_test.dart` bắt ngay nếu một bảng thiếu cột, thiếu bài, thiếu IPA
hoặc có id trùng.

---

## Điều hướng

Bốn tab nằm trong một `IndexedStack` nên mỗi tab giữ nguyên vị trí cuộn. Màn
hình con đẩy lên `Navigator` gốc và phủ kín thanh tab, khác với kiểu lồng
Navigator theo từng tab.

Nút back của hệ thống do `PopScope` xử lý: đang ở tab khác thì về tab **Hôm
nay**, đang ở tab Hôm nay mới thoát app. `test/app_test.dart` khoá hành vi này.

---

## Hộp Leitner

`lib/models/box_card.dart`, năm hộp với lịch cố định:

| Hộp | Ôn lại sau |
|---|---|
| 1 | 12 phút — ngay trong phiên |
| 2 | 1 ngày |
| 3 | 3 ngày |
| 4 | 7 ngày |
| 5 | 16 ngày — tính là đã thuộc |

**Nhớ rõ** lên một hộp, **Lơ mơ** lùi một hộp, **Chưa nhớ** rơi thẳng về hộp 1.
Kết quả bốn trò luyện cũng đi vào đúng hệ thống này: đúng thì lên hộp, sai thì
về hộp 1.

Chọn lịch cố định thay vì hệ số dễ động vì người học đoán trước được vì sao một
câu xuất hiện — điều đó quan trọng hơn việc tối ưu thêm vài phần trăm.

---

## Thêm nội dung mới

1. **Thêm câu vào chủ đề có sẵn**: mở `data/pack_*.dart`, thêm dòng vào bảng
   `<code>Lines`. Nhớ giữ đúng tám câu mỗi bài nếu không muốn sửa test.
2. **Thêm chủ đề mới**: tạo ba bảng `<code>Lines`, `<code>Words`,
   `<code>Talk`, rồi thêm một lời gọi `_topic(...)` trong
   `data/library.dart`. Test sẽ báo ngay nếu thiếu bảng nào.
3. **Thêm mục sổ tay**: thêm dòng vào `ref_*.dart`; số mục hiển thị tự cập nhật
   vì giao diện đọc thẳng `entries.length`.

---

## Hồ sơ App Store

Thư mục `store/` chứa mọi thứ cần cho lần nộp đầu:

- `app_review_notes.txt` — dán vào ô Notes, viết sẵn để chặn 2.1;
- `metadata.md` — tên, phụ đề, từ khoá, mô tả, ghi chú điền form;
- `differentiation.md` — bảng đối chiếu với ứng dụng khác cùng tài khoản, dùng
  khi bị hỏi 4.3;
- `submission_checklist.md` — việc phải làm trước khi bấm nộp;
- `review_recording_shotlist.md` — kịch bản quay video màn hình.

---

## Ghi chú về TTS

`flutter_tts` dùng giọng đọc cài sẵn trên máy. Giọng tiếng Anh có trên mọi thiết
bị iOS nên nút loa chạy được ngay. Nếu vì lý do nào đó máy không có giọng, hệ
thống trả về im lặng và app im lặng theo thay vì báo lỗi — trò **Nghe và chọn**
vì thế luôn có sẵn nút *Hiện chữ* để vẫn chơi được.
