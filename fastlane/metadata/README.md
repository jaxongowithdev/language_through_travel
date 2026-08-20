# Metadata App Store

Cấu trúc theo chuẩn `fastlane deliver`, nên nộp được bằng một lệnh:

```bash
cd language_through_travel
fastlane deliver --skip_binary_upload --skip_screenshots
```

Trước khi nộp, chạy bộ đếm ký tự:

```bash
python3 tool/check_metadata.py
```

App Store Connect từ chối **cả bản nộp** nếu một trường vượt hạn mức, mà thông
báo lỗi lại không nói rõ trường nào. Đếm trước ở máy rẻ hơn nhiều.

---

## Các trường và hạn mức

| File | Hạn mức | Ghi chú |
|---|---:|---|
| `name.txt` | 30 | Tên hiển thị dưới icon. Apple đánh chỉ mục tìm kiếm cho trường này. |
| `subtitle.txt` | 30 | Dòng dưới tên. Cũng được đánh chỉ mục — đừng lặp chữ đã có trong `name`. |
| `keywords.txt` | 100 | Ngăn bằng dấu phẩy, **không có dấu cách sau dấu phẩy** (mỗi dấu cách ăn mất một ký tự). |
| `promotional_text.txt` | 170 | Sửa được **không cần duyệt lại app**. Đây là chỗ gần nhất với "short description" của Google Play — Apple không có trường đó. |
| `description.txt` | 4000 | Chỉ 2–3 dòng đầu hiện trước nút "more", nên dồn ý mạnh lên đầu. |
| `release_notes.txt` | 4000 | Ghi chú phiên bản. |
| `support_url.txt` | 255 | **Bắt buộc.** |
| `privacy_url.txt` | 255 | **Bắt buộc.** Đang trỏ tới `PRIVACY.md` ở gốc repo. |
| `marketing_url.txt` | 255 | Không bắt buộc. |

Ba URL trên đang để placeholder `your-account` — đổi thành đường dẫn thật
trước khi nộp, nếu không App Review sẽ chặn ngay ở bước metadata.

---

## Vì sao chọn những chữ này

**Không lặp từ khoá.** Apple gộp `name` + `subtitle` + `keywords` thành một
kho chỉ mục chung. Chữ nào đã xuất hiện ở tên hoặc phụ đề thì bỏ khỏi
`keywords.txt` — lặp lại chỉ tốn ký tự chứ không tăng thứ hạng. Vì vậy bản
tiếng Anh có `language`, `travel`, `airport`, `taxi` trong tên và phụ đề rồi
nên `keywords.txt` không nhắc lại chúng.

**Không cần dạng số nhiều.** Apple tự khớp số ít/số nhiều, nên chỉ cần
`flashcards`, không cần thêm `flashcard`.

**Phụ đề nói việc, không nói cảm xúc.** "Sân bay → taxi · 4 ngôn ngữ" cho
người xem biết ngay app làm gì trong 27 ký tự; "Học ngoại ngữ thật dễ" thì
không nói được gì.

**Câu mở đầu `description` là câu bán hàng.** App Store cắt phần còn lại sau
khoảng ba dòng, phần lớn người xem không bấm "more".

---

## Ảnh chụp màn hình

`fastlane/screenshots/<locale>/` đang rỗng. `deliver` sắp xếp ảnh theo tên file
nên đặt tiền tố số:

```
fastlane/screenshots/vi/
├── 01_hanh_trinh.png
├── 02_so_tay.png
├── 03_luyen_tap.png
├── 04_cam_nang.png
└── 05_tien_do.png
```

Kích thước bắt buộc hiện nay: **6.9"** (1320×2868) và **6.5"** (1242×2688) cho
iPhone, **13"** (2064×2752) nếu có bản iPad. Chụp bằng simulator:

```bash
flutter run -d "iPhone 16 Pro Max"
xcrun simctl io booted screenshot 01_hanh_trinh.png
```

---

## Google Play

Nếu sau này nộp cả Play Store, cấu trúc khác hẳn: Play có `short_description`
(80 ký tự) và `full_description` (4000), không có `subtitle` hay `keywords`.
Nội dung trong `promotional_text.txt` rút gọn còn 80 ký tự là dùng được làm
short description.
