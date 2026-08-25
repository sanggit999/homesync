# Kiến Trúc Điều Hướng & Danh Mục Màn Hình (Navigation & Screen Map) - HomeSync

Tài liệu này định nghĩa chi tiết kiến trúc điều hướng (Navigation Architecture), hệ thống 4 Tabs chính, danh mục toàn bộ các màn hình (Screen Catalog), luồng trải nghiệm người dùng (User Flows) và cơ chế chuyển đổi Guest Mode $\rightarrow$ Account Linking.

---

## 📌 1. Cấu Trúc Điều Hướng Cốt Lõi (4 Tabs Architecture)

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                      HOMESYNC BOTTOM NAVIGATION BAR                         │
│                                                                             │
│   [ 🏠 Tổng quan ]   [ 📱 Thiết bị ]   [ 🔧 Bảo trì ]   [ 👤 Cá nhân ]      │
│      (Dashboard)        (Assets)       (Maintenance)       (Profile)        │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 📱 2. Chi Tiết Từng Tab & Danh Mục Màn Hình

### 🏠 TAB 1: TỔNG QUAN (DASHBOARD)
* **Màn hình chính:** `HomeScreen`
  * **Radar Sức Khỏe Thiết Bị:** Thẻ tổng hợp 3 chỉ số quan trọng (Tổng số thiết bị & giá trị tài sản, Số thiết bị sắp hết hạn < 30 ngày, Công việc cần bảo trì trong tuần).
  * **Smart Nudge Banner:** Hiển thị khi ở chế độ Khách (Guest Mode) nhắc người dùng liên kết tài khoản để bảo vệ dữ liệu vĩnh viễn trên Cloud.
  * **Widget Thống Kê Chi Tiêu:** Tổng tiền sửa chữa/bảo dưỡng theo Tuần / Tháng / Năm.
  * **Phím Tắt Nhanh (Quick Actions):** *Quét hóa đơn mới (OCR)*, *Xuất PDF bảo hiểm*, *Thêm lịch bảo trì*.
  * **Danh Sách Khẩn Cấp:** Thẻ cuộn ngang các thiết bị sắp hết hạn bảo hành.
* **Màn hình phụ:** `PdfPreviewScreen` (Xem trước, in và chia sẻ file PDF báo cáo tài sản).

---

### 📱 TAB 2: THIẾT BỊ & BẢO HÀNH (ASSETS & WARRANTIES)
* **Màn hình chính:** `ItemListScreen`
  * **Thanh Tìm Kiếm Tức Thì (Instant Search):** Tìm theo Tên, Hãng, Số Serial, Vị trí phòng.
  * **Bộ Lọc Danh Mục (Category Chips):** Tất cả, Điện lạnh, Điện tử, Gia dụng, Xe cộ, Cá nhân.
  * **Bộ Lọc Trạng Thái:** Đang dùng, Sắp hết hạn (< 30 ngày), Đã hết hạn, Đang sửa chữa.
  * **Thẻ Thiết Bị (`ItemCard`):** Icon danh mục, Tên máy, Hãng, Vị trí phòng, Badge trạng thái và thanh tiến độ thời gian bảo hành `WarrantyProgressBar`.
* **Màn hình chi tiết:** `ItemDetailScreen`
  * Ảnh thực tế thiết bị + Ảnh hóa đơn + Ảnh phiếu bảo hành có mộc đỏ.
  * Hotline bảo hành hãng (Bấm 1 chạm để gọi điện ngay).
  * Số Serial / Model No (Nút sao chép 1 chạm).
  * Sách hướng dẫn sử dụng & tra cứu mã lỗi (`manual_url`).
  * Lịch sử bảo trì & tổng chi phí đã chi cho riêng thiết bị này.
* **Màn hình thêm/sửa thiết bị:** `AddEditItemScreen`
  * 3 chế độ nhập liệu: *Chụp quét hóa đơn OCR*, *Quét Barcode/Serial*, *Nhập thủ công*.
  * Gợi ý tự động chu kỳ bảo trì mẫu theo danh mục.
* **Màn hình xem ảnh:** `ReceiptViewerScreen` (Xem ảnh hóa đơn chất lượng cao, Zoom & Pan).

---

### 🔧 TAB 3: BẢO TRÌ & SỬA CHỮA (MAINTENANCE & EXPENSE LOGS)
* **Màn hình chính:** `MaintenanceListScreen`
  * **Segmented Control (2 Chế độ xem):**
    1. *Lịch bảo trì định kỳ:* Danh sách các công việc sắp tới kèm mức độ ưu tiên (`Low`, `Medium`, `High`, `Urgent`), nút gọi thợ 1 chạm, nút *"Thêm vào Lịch điện thoại (Calendar)"*.
    2. *Nhật ký chi phí đã làm:* Danh sách các lần sửa chữa/thay linh kiện trong quá khứ kèm số tiền và ảnh phiếu thu.
  * **Nút Hoàn Thành Nhanh:** Bấm tick $\rightarrow$ Mở dialog xác nhận số tiền chi trả $\rightarrow$ Tự động lưu 1 bản ghi vào `service_logs` và tự động dời ngày bảo trì tiếp theo theo chu kỳ.
* **Màn hình / Dialog:** `AddMaintenanceDialog` (Tạo lịch bảo trì mới kèm thư viện Presets gợi ý).
* **Màn hình:** `AddServiceLogScreen` (Ghi nhận lần sửa chữa / bảo dưỡng đột xuất).

---

### 👤 TAB 4: CÁ NHÂN & CÀI ĐẶT (PROFILE & SETTINGS)
* **Màn hình chính:** `ProfileScreen`
  * Thông tin tài khoản & Trạng thái (Chế độ Khách / Đã liên kết Google/Email).
  * **Nút "Xuất Báo Cáo Tài Sản (PDF)"** chuẩn hồ sơ bảo hiểm.
  * **Quản lý Nhà & Chia Sẻ Gia Đình:** Xem danh sách nhà và mã QR chia sẻ cho người thân.
  * **Cài Đặt Thông Báo:** Bật/tắt OneSignal Push và tùy chọn số ngày nhắc trước (7, 14, 30 ngày).
  * **Cài Đặt Giao Diện:** Chế độ Sáng / Tối (Light / Dark Theme).
* **Màn hình phụ:**
  * `FamilyMembersScreen`: Quản lý danh sách thành viên gia đình và phân quyền (`owner`, `editor`, `viewer`).
  * `QrScannerScreen`: Quét mã QR để tham gia vào nhà người thân chia sẻ.

---

## 🔐 3. Luồng Xác Thực Tinh Giản 100% (Google Sign-In & Đăng Nhập Nhanh)

Loại bỏ hoàn toàn các form đăng ký / quên mật khẩu rườm rà. Quy trình đăng nhập gói gọn trong 1 màn hình duy nhất:

* `AuthWelcomeScreen`: Màn hình chào đón & xác thực 1 chạm:
  1. **⚡ Nút "Bắt đầu sử dụng ngay" (Đăng nhập nhanh - Guest Mode):** Vào thẳng app trong 1 giây qua `signInAnonymously()`. Không cần nhập bất kỳ thông tin nào.
  2. **🔵 Nút "Tiếp tục với Google" (Google Sign-In 1 chạm):** Đăng nhập an toàn qua tài khoản Google.
  3. **🔗 Cơ chế Liên kết Tài khoản (Account Linking):** Khi user đang ở Guest Mode, chỉ cần bấm *"Liên kết với Google"* $\rightarrow$ Toàn bộ dữ liệu thiết bị đã nhập được tự động đồng bộ vĩnh viễn lên Cloud.

---

## 📊 4. Bảng Tổng Hợp Danh Mục Màn Hình Của Dự Án

| STT | Tên Màn Hình (Screen Name) | Vị Trí / Tab | Chức Năng Chính |
| :---: | :--- | :--- | :--- |
| 1 | `AuthWelcomeScreen` | Auth Flow | **100% Đăng nhập nhanh (Guest Mode) + Google Sign-In 1 chạm** |
| 2 | `AppShellScreen` | App Core | Khung Bottom Navigation Bar 4 tabs |
| 3 | `HomeScreen` | Tab 1 (Tổng quan) | Radar sức khỏe, chi tiêu, cảnh báo khẩn cấp, Banner nhắc liên kết Google |
| 4 | `PdfPreviewScreen` | Tab 1 / Action | Xem trước & xuất báo cáo PDF tài sản bảo hiểm |
| 5 | `ItemListScreen` | Tab 2 (Thiết bị) | Danh sách thiết bị, tìm kiếm tức thì, lọc category/phòng |
| 6 | `ItemDetailScreen` | Tab 2 (Chi tiết) | Thông tin máy, gọi hotline 1 chạm, số serial, lịch sử sửa chữa |
| 7 | `AddEditItemScreen` | Tab 2 (Thêm/Sửa) | Form nhập liệu (3 chế độ: Scan OCR, Scan Barcode, Nhập tay) |
| 8 | `ReceiptViewerScreen` | Tab 2 (Media) | Xem ảnh hóa đơn/phiếu BH Full HD (Zoom/Pan) |
| 9 | `MaintenanceListScreen`| Tab 3 (Bảo trì) | Lịch bảo trì, nút gọi thợ 1 chạm, thêm vào Calendar, tick hoàn thành |
| 10 | `AddServiceLogScreen` | Tab 3 (Chi phí) | Ghi nhận chi phí sửa chữa / thay linh kiện đột xuất |
| 11 | `ProfileScreen` | Tab 4 (Cá nhân) | Hồ sơ, **Nút "Liên kết với Google để lưu Cloud"**, xuất PDF, cài đặt OneSignal |
| 12 | `FamilyMembersScreen`| Tab 4 (Gia đình) | Quản lý thành viên & Mã QR chia sẻ nhà |
