# Khác biệt so với ứng dụng khác cùng tài khoản nhà phát triển

Tài liệu này để trả lời nhanh nếu App Review nêu **Guideline 4.3 (Design - Spam)**,
tức nghi ngờ hai ứng dụng của cùng một nhà phát triển là bản sao đổi vỏ của nhau.
Bảng bên dưới đối chiếu **Nói Ngay** với **Language Through Travel**.

Nguyên tắc chung: 4.3 nhìn vào *bản chất* ứng dụng, không nhìn màu sắc. Vì vậy
điểm mạnh cần nhấn không phải là icon khác hay nền tối, mà là **đối tượng khác,
ngôn ngữ dạy khác, phương pháp khác, kiến trúc nội dung khác và toàn bộ chữ đều
được viết mới**.

## Bảng đối chiếu

| Hạng mục | Language Through Travel | Nói Ngay |
|---|---|---|
| Bài toán giải quyết | Chuẩn bị cho một chuyến đi nước ngoài sắp tới | Nói tiếng Anh trong sinh hoạt và công việc lặp lại hằng tuần |
| Ngôn ngữ đích | Bốn ngôn ngữ: Anh, Nhật, Hàn, Thái | Một ngôn ngữ duy nhất: tiếng Anh |
| Cách tổ chức nội dung | Bốn chặng hành trình: sân bay, khách sạn, nhà hàng, taxi | Hai mươi chủ đề đời sống và công sở, mỗi chủ đề ba bài |
| Chiều học | Lật thẻ hai chiều, có thể chỉ đọc hiểu | Luôn Việt sang Anh, buộc bật ra câu trước khi lật đáp án |
| Mở khoá | Chặng sau mở khi chặng trước đạt 50 phần trăm | Không khoá gì cả, mọi chủ đề mở từ giây đầu tiên |
| Thuật toán ôn tập | Biến thể SM-2 với hệ số dễ động | Hộp Leitner năm ngăn, lịch cố định 0, 1, 3, 7, 16 ngày |
| Các trò luyện | Nối cặp, nghe đoán, đúng sai, thử thách 60 giây | Điền từ vào chỗ trống, sắp xếp trật tự từ, nghe và chọn, ghép nghĩa 60 giây |
| Chế độ riêng | Không có | Nhại theo với thanh chỉnh tốc độ đọc |
| Sổ tra cứu | Sáu chủ đề cẩm nang du lịch | Năm mục: ngữ pháp, cụm động từ, thành ngữ, động từ bất quy tắc, bảng âm IPA |
| Từ vựng kèm IPA | Không có | 200 mục, mỗi mục có IPA, từ loại và ví dụ song ngữ |
| Điều hướng | Năm tab, mỗi tab một Navigator lồng nhau | Bốn tab, một Navigator gốc, thanh tab kính mờ trôi trên nội dung |
| Giao diện | Material 3 mặc định, nền sáng, seed xanh biển #0EA5E9 | Tối trước, nền cực quang, thẻ kính mờ, gradient tím sang hồng |
| Biểu tượng | Máy bay giấy trong bong bóng hội thoại, nền xanh | Sóng âm năm cột trắng, nền gradient tím hồng |
| Kiến trúc nội dung | Hằng số Dart gọi constructor cho từng câu | Bảng văn bản ngăn bằng dấu sổ, một bộ đọc dựng model |
| Số mục nội dung | 192 câu và mục cẩm nang | 1.164 mục, không câu nào trùng với app kia |

## Ba câu trả lời ngắn nếu bị hỏi

1. **Hai app có dùng chung nội dung không?**
   Không một câu nào. Nói Ngay có 480 câu, 160 lượt hội thoại, 200 từ vựng và
   284 mục tra cứu, tất cả viết mới cho chủ đề đời sống và công sở. Language
   Through Travel dạy bốn ngôn ngữ theo bốn chặng du lịch.

2. **Hai app có dùng chung mã nguồn không?**
   Hai dự án Flutter riêng, tên gói riêng, mã định danh gói riêng. Mô hình dữ
   liệu, thuật toán ôn tập, khung điều hướng và toàn bộ lớp giao diện đều được
   viết lại. Điểm chung chỉ là Flutter và ba gói mã nguồn mở phổ biến:
   provider, shared_preferences, flutter_tts.

3. **Vì sao cần hai app thay vì gộp một?**
   Hai nhóm người dùng khác nhau và không giao nhau nhiều. Người sắp đi Nhật
   cần đúng bốn chặng của chuyến đi bằng tiếng Nhật, học trong hai tuần rồi
   thôi. Người đi làm cần tiếng Anh cho họp hành và email, học đều mỗi ngày
   trong nhiều tháng. Gộp lại sẽ tạo ra một app mà cả hai nhóm đều phải lội qua
   phần không dành cho mình.

## Việc cần làm trước khi nộp

- [ ] Đổi `PRODUCT_BUNDLE_IDENTIFIER` sang mã định danh riêng, **không** dùng
      chung tiền tố sản phẩm với app cũ và **không** để `com.example`.
- [ ] Tên hiển thị trên App Store không chứa từ khoá trùng lặp với app cũ.
- [ ] Ảnh chụp màn hình chụp mới hoàn toàn, không tái sử dụng ảnh app cũ.
- [ ] Phần mô tả và từ khoá viết mới, không sao chép đoạn nào từ app cũ.
- [ ] Điền Notes cho App Review bằng nội dung trong `store/app_review_notes.txt`.
