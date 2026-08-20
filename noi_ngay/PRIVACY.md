# Chính sách quyền riêng tư — Nói Ngay

Cập nhật lần cuối: 17 tháng 8 năm 2026

## Tóm tắt trong ba câu

Nói Ngay không thu thập dữ liệu cá nhân. Ứng dụng không có tài khoản, không có
máy chủ và không thực hiện bất kỳ kết nối mạng nào. Tiến độ học nằm trong bộ
nhớ của chính thiết bị bạn và bạn xoá được bất cứ lúc nào.

## Chúng tôi thu thập gì

Không gì cả. Cụ thể, ứng dụng **không** thu thập, **không** lưu trữ trên máy chủ
và **không** chia sẻ với bất kỳ ai:

- tên, email, số điện thoại hay bất kỳ thông tin định danh nào;
- vị trí, danh bạ, ảnh, lịch;
- ghi âm giọng nói — ứng dụng không dùng micrô;
- mã định danh thiết bị, mã quảng cáo hay dữ liệu theo dõi;
- dữ liệu sử dụng, số liệu phân tích hay báo cáo sự cố.

Bảng khai báo quyền riêng tư trên App Store của ứng dụng được đặt ở mức
**Data Not Collected**, đúng với thực tế mô tả ở đây.

## Ứng dụng lưu gì trên máy bạn

Những thứ sau nằm trong bộ nhớ cục bộ của ứng dụng, thông qua thư viện
`shared_preferences` của hệ điều hành:

- mục tiêu số câu mỗi ngày và lựa chọn giao diện sáng hay tối;
- tốc độ đọc bạn đặt cho nút loa;
- trạng thái hộp ôn tập của từng câu, gồm số hộp và ngày đến hạn;
- danh sách câu bạn tự đánh dấu lưu;
- danh sách bài học đã hoàn thành;
- số câu đã ôn theo từng ngày, để vẽ chuỗi ngày và biểu đồ;
- kỷ lục của bốn trò luyện tập.

Dữ liệu này **không rời khỏi thiết bị**. Nó không được đồng bộ, không được sao
lưu lên dịch vụ của chúng tôi, và chúng tôi không có cách nào đọc được nó.

## Xoá dữ liệu

Có hai cách, cả hai đều nằm trong tay bạn:

1. Mở ứng dụng, vào **Cá nhân → Cài đặt → Đặt lại tiến độ**. Thao tác này xoá
   toàn bộ mục liệt kê ở trên.
2. Gỡ ứng dụng. Hệ điều hành xoá luôn toàn bộ vùng lưu trữ của ứng dụng.

Vì không có tài khoản nên không có gì để xoá ở phía máy chủ, và cũng không cần
gửi yêu cầu xoá tài khoản cho chúng tôi.

## Giọng đọc

Nút loa dùng bộ tổng hợp giọng nói có sẵn của hệ điều hành, thông qua thư viện
mã nguồn mở `flutter_tts`. Ứng dụng truyền câu tiếng Anh cần đọc cho hệ điều
hành xử lý ngay trên máy. Ứng dụng không gửi văn bản đó đi đâu và không ghi âm.

Việc hệ điều hành xử lý giọng nói như thế nào thuộc chính sách quyền riêng tư
của Apple hoặc Google, tuỳ nền tảng bạn dùng.

## Trẻ em

Ứng dụng dành cho người học từ mười lăm tuổi trở lên và được xếp hạng 4+ vì
không chứa nội dung nhạy cảm. Vì ứng dụng không thu thập dữ liệu của bất kỳ ai,
nó cũng không thu thập dữ liệu của trẻ em.

## Quảng cáo và thanh toán

Không có quảng cáo, không có mạng lưới quảng cáo, không có mua trong ứng dụng,
không có gói đăng ký và không có bộ xử lý thanh toán nào được tích hợp.

## Thư viện bên thứ ba

Ứng dụng dùng ba gói mã nguồn mở, tất cả đều chạy cục bộ và không gửi dữ liệu
đi đâu:

| Gói | Việc nó làm |
|---|---|
| `provider` | Quản lý trạng thái trong bộ nhớ |
| `shared_preferences` | Đọc ghi vùng lưu trữ khoá giá trị của hệ điều hành |
| `flutter_tts` | Gọi bộ đọc có sẵn của hệ điều hành |

## Thay đổi chính sách

Nếu chính sách này thay đổi, chúng tôi cập nhật ngày ở đầu trang và mô tả thay
đổi ngay trong phần này. Nếu một phiên bản tương lai có thu thập dữ liệu, chúng
tôi sẽ nói rõ trước khi phát hành và sẽ hỏi ý bạn.

## Liên hệ

Mọi câu hỏi về quyền riêng tư xin gửi tới `<EMAIL HỖ TRỢ>`.
