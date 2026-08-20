# Checklist trước khi nộp

Chia theo đúng hai điều khoản hay bị vướng nhất: 2.1 và 4.3.

## Trước hết: đổi thông tin dự án

- [ ] `flutter create .` để sinh `android/`, `ios/`, `web/`.
- [ ] Mở `ios/Runner.xcodeproj`, đổi `PRODUCT_BUNDLE_IDENTIFIER` từ
      `com.example.noiNgay` sang mã định danh thật của bạn. Bundle id còn chữ
      `com.example` là bị từ chối ngay vòng đầu.
- [ ] Đổi `applicationId` trong `android/app/build.gradle` cho khớp.
- [ ] `ios/Runner/Info.plist`: đặt `CFBundleDisplayName` là `Nói Ngay`.
- [ ] `android/app/src/main/AndroidManifest.xml`: đặt `android:label` là
      `Nói Ngay`.
- [ ] `python3 tool/generate_icons.py` rồi `dart run flutter_launcher_icons`.
- [ ] `flutter analyze` sạch, `flutter test` xanh.

## Chống 2.1 Information Needed

Điều khoản này bật khi người duyệt không tự trả lời được app làm gì, dùng thế
nào, lấy dữ liệu ở đâu. Cách chặn là trả lời trước tất cả trong Notes.

- [ ] Dán toàn bộ `store/app_review_notes.txt` vào ô **App Review Information →
      Notes**. Thay `<MODEL>` và `<VERSION>` bằng máy thật đã thử.
- [ ] Ghi rõ ngay dòng đầu: **không cần tài khoản**. Bỏ trống ô Sign-in
      required, không điền tài khoản demo giả.
- [ ] Nêu rõ **không có nội dung nào bị khoá**. Đây chính là điểm app cũ từng
      làm người duyệt tưởng app hỏng; app này bỏ hẳn cơ chế mở khoá theo chặng.
- [ ] Điền **Privacy questionnaire** là Data Not Collected và giữ nguyên sự
      thật đó: app không có mạng.
- [ ] `Support URL` và `Privacy Policy URL` phải mở được, không chuyển hướng về
      trang chủ trống, không chặn theo quốc gia.
- [ ] Nếu bị hỏi lại, đính kèm một video quay màn hình theo
      `store/review_recording_shotlist.md`.
- [ ] Kiểm tra app chạy được ở chế độ máy bay, vì bạn đã khai là ngoại tuyến.
- [ ] Kiểm tra trên iPad nếu bật hỗ trợ iPad. Nếu không định hỗ trợ thì tắt hẳn
      trong Xcode chứ đừng để bật mà giao diện vỡ.

## Chống 4.3 Spam

Điều khoản này bật khi hai app cùng tài khoản trông như bản sao đổi vỏ.

- [ ] Đọc lại `store/differentiation.md` và giữ file đó sẵn để dán vào Resolution
      Center nếu bị hỏi.
- [ ] Bundle id **không** dùng chung tiền tố sản phẩm với app cũ.
- [ ] Tên app, phụ đề và từ khoá không lặp cụm từ với app cũ.
- [ ] Mô tả viết mới hoàn toàn. Không sao chép đoạn nào, kể cả phần quyền riêng tư.
- [ ] Ảnh chụp màn hình chụp mới, khác bố cục và khác bảng màu.
- [ ] Icon khác hẳn: app này là sóng âm trắng trên gradient tím hồng.
- [ ] Không nộp hai app trong cùng một ngày. Giãn ít nhất một tuần.
- [ ] Nếu app cũ có bản cập nhật đang chờ duyệt thì chờ nó xong rồi hãy nộp app này.

## Những thứ khai là không có, phải đúng là không có

Người duyệt sẽ đối chiếu Notes với binary. Chỉ cần một mục sai là mất vòng nữa.

- [ ] Không có `NSMicrophoneUsageDescription`, `NSCameraUsageDescription`,
      `NSPhotoLibraryUsageDescription`, `NSLocationWhenInUseUsageDescription`,
      `NSUserTrackingUsageDescription` trong `Info.plist`. App không xin quyền
      nào nên không được khai quyền nào.
- [ ] Không có SDK quảng cáo, không có analytics, không có Firebase.
- [ ] Không có `In-App Purchase` nào được cấu hình.
- [ ] Không có tính năng đăng nhập bằng mạng xã hội, nên không cần Sign in with
      Apple.
- [ ] Tìm trong dự án xem còn sót lệnh gọi mạng nào không:
      `grep -rn "http" lib/` phải không trả về lời gọi thật nào.

## Sau khi nộp

- [ ] Nếu bị 2.1, trả lời trong Resolution Center bằng đúng bảy mục mà Apple
      liệt kê, kèm video màn hình. Đừng chỉ viết "app không cần tài khoản".
- [ ] Nếu bị 4.3, dán bảng đối chiếu trong `store/differentiation.md`, nhấn vào
      ba điểm: đối tượng khác, phương pháp khác, và không dùng chung một câu nội
      dung nào.
