# Tài Liệu Quy Trình Triển Khai Chi Tiết Các Giai Đoạn (Project Phases Documentation) - HomeSync

Dự án **HomeSync** được triển khai theo mô hình Clean Architecture kết hợp Feature-First, tuân thủ nghiêm ngặt các quy chuẩn kỹ thuật từ bộ kỹ năng (`frontend-design`, `code-review-skill`, `security-review`, `test-driven-development`, `verification-before-completion`, `karpathy-guidelines`).

---

## 📌 QUY TẮC BẮT BUỘC: ĐỌC VÀ TUÂN THỦ SKILLS TRONG MỖI PHASE

> [!IMPORTANT]
> **Quy định bất khả xâm phạm:** Trước khi thực hiện bất kỳ Phase nào, bắt buộc phải đọc nội dung hướng dẫn chuyên sâu (`SKILL.md` và các tài liệu tham chiếu) trong thư mục [`.agents/skills/`](file:///D:/Flutter/HomeSync/.agents/skills) để áp dụng chính xác các best practices, tránh sai sót kiến trúc và đảm bảo code đạt chuẩn cao nhất.

| Giai đoạn (Phase) | Kỹ năng bắt buộc đọc trước khi code |
| :--- | :--- |
| **Phase 1: Nền tảng & Code Generator** | `flutter-apply-architecture-best-practices`, `flutter-implement-json-serialization`, `karpathy-guidelines` |
| **Phase 2: Design Tokens & Core Services** | `frontend-design`, `flutter-use-http-package`, `security-review` |
| **Phase 3: TDD Domain, Freezed Models & Mappers** | `test-driven-development`, `dart-add-unit-test`, `flutter-implement-json-serialization` |
| **Phase 4: Repositories & Cubits State** | `code-review-skill` (Dart section), `flutter-apply-architecture-best-practices` |
| **Phase 5: Giao Diện UI 4 Tabs & 14 Màn Hình** | `frontend-design`, `flutter-setup-declarative-routing`, `flutter-build-responsive-layout`, `flutter-fix-layout-issues` |
| **Phase 6: Verification & Quality Gate** | `verification-before-completion`, `code-review-skill`, `security-review`, `systematic-debugging` |

---

## 📌 BẢNG TỔNG QUAN CÁC GIAI ĐOẠN (ROADMAP OVERVIEW)

```text
[ Phase 1: Nền Tảng & Build Runner ] ──► [ Phase 2: Design System & Core Config ]
                                                         │
                                                         ▼
[ Phase 4: Repositories & Cubits ]   ◄── [ Phase 3: TDD Domain, Freezed & Mappers ]
               │
               ▼
[ Phase 5: Giao Diện UI & 5 Tính Năng ] ─► [ Phase 6: Testing, Security & Verification ]
```

---

## 🚀 CHI TIẾT TỪNG GIAI ĐOẠN (DETAILED PHASES)

### 🔹 PHASE 1: Khởi Tạo Nền Tảng, Dependencies & Bộ Sinh Mã (Code Generation)

#### 🎯 Mục tiêu
Thiết lập toàn bộ thư viện cần thiết trong `pubspec.yaml`, đảm bảo không xung đột phiên bản, cấu hình sẵn môi trường sinh mã tự động với `build_runner`.

#### 📋 Danh mục công việc chi tiết
1. Cấu hình `pubspec.yaml`:
   - **State Management:** `flutter_bloc: ^9.1.1`
   - **Backend & Database:** `supabase_flutter: ^2.8.4`
   - **Push Notifications:** `onesignal_flutter: ^5.3.4`
   - **Routing:** `go_router: ^14.8.1`
   - **UI & Typography:** `google_fonts: ^6.2.1`, `lucide_icons: ^0.257.0`
   - **Image & Caching:** `image_picker: ^1.1.2`, `cached_network_image: ^3.4.1`
   - **Báo Cáo & PDF Export:** `pdf: ^3.11.1`, `printing: ^5.13.2`, `path_provider: ^2.1.5`
   - **Đồng Bộ Lịch & Chia Sẻ QR:** `add_2_calendar: ^3.0.1`, `qr_flutter: ^4.1.0`
   - **Formatters & Call:** `intl: ^0.20.2`, `shared_preferences: ^2.5.3`, `url_launcher: ^6.3.1`
   - **Freezed & JSON:** `freezed_annotation: ^2.4.4`, `json_annotation: ^4.9.0`
   - **Networking:** `http: ^1.3.0`
   - **Dev & Test:** `build_runner: ^2.4.15`, `freezed: ^2.5.8`, `json_serializable: ^6.9.4`, `bloc_test: ^10.0.0`, `mocktail: ^1.0.4`.
2. Chạy lệnh `flutter pub get` để tải và đồng bộ các gói phụ thuộc.
3. Thiết lập cấu trúc thư mục chuẩn mực (`lib/core`, `lib/data`, `lib/domain`, `lib/features`).

#### 📦 Kết quả bàn giao (Deliverables)
- File `pubspec.yaml` hoàn chỉnh, tương thích 100% với Flutter 3.47 / Dart 3.13.
- Cấu trúc thư mục dự án sẵn sàng.

---

### 🔹 PHASE 2: Thiết Kế Hệ Thống UI/UX Tokens, Theme & Dịch Vụ Cốt Lõi (Core Services)

#### 🎯 Mục tiêu
Xây dựng Design Tokens chuẩn Minimalist (phong cách Apple) và cấu hình các lớp kết nối Supabase, OneSignal, Calendar và PDF Generator.

#### 📋 Danh mục công việc chi tiết
1. **Design System & Tokens (`lib/core/constants/` & `lib/core/theme/`):**
   - `AppColors`: Primary `#2563EB`, Good `#10B981`, Warning `#F59E0B`, Danger `#EF4444`, Background `#F8FAFC`, Surface `#FFFFFF`.
   - `AppTextStyles`: Cấu hình Google Fonts (Plus Jakarta Sans/Inter) với các kích thước chuẩn.
   - `AppTheme`: Thiết lập `ThemeData` Material 3 (CardTheme bo góc 14px, shadow dịu mắt, InputDecorations tinh tế).
2. **Core Configuration & Services (`lib/core/config/` & `lib/core/services/`):**
   - `AppConfig`: Quản lý Supabase URL, Anon Key, OneSignal App ID.
   - **Tài liệu hướng dẫn Supabase:** Xem chi tiết tại [supabase_setup.md](file:///D:/Flutter/HomeSync/.agents/docs/supabase_setup.md).
   - `OneSignalService`: Khởi tạo SDK, đồng bộ `onesignal_player_id`.
   - `StorageService`: Xử lý upload ảnh hóa đơn/phiếu bảo hành/tài liệu lên Supabase Storage bucket `receipts`.
   - `PdfExportService`: Dịch vụ tạo và xuất file PDF báo cáo tài sản bảo hiểm.
   - `CalendarService`: Dịch vụ đồng bộ lịch bảo dưỡng vào Google/Apple Calendar.
   - `DateFormatter` & `WarrantyCalculator`: Bộ công cụ xử lý ngày tháng chuẩn quốc tế và Việt Nam.

#### 📦 Kết quả bàn giao (Deliverables)
- Hệ thống Theme & Typography sẵn sàng cho toàn app.
- Toàn bộ các dịch vụ nền tảng (Storage, Push, PDF, Calendar) hoạt động độc lập.

---

### 🔹 PHASE 3: TDD - Domain Logic, Freezed Data Models & Bộ Chuyển Đổi (Mappers)

#### 🎯 Mục tiêu
Xây dựng tầng Domain và Data theo phương pháp Test-Driven Development (TDD): Viết Unit Tests trước, định nghĩa Data Models với Freezed (`abstract class ... with _$Model`) và các lớp Mappers 2 chiều độc lập.

#### 📋 Danh mục công việc chi tiết
1. **Unit Tests cho Logic Bảo Hành (`test/domain/warranty_calculator_test.dart`):**
   - Kiểm tra tính toán số ngày còn lại (`daysRemaining`).
   - Kiểm tra phân loại trạng thái: Còn bảo hành (`isGood`), Sắp hết hạn trong 30 ngày (`isExpiringSoon`), Đã hết hạn (`isExpired`).
   - Kiểm tra tính ngày đến hạn bảo trì kế tiếp (`calculateNextDueDate`).
2. **Domain Entities (`lib/domain/entities/`):**
   - `ItemEntity` (Sản phẩm/Thiết bị kèm getter logic).
   - `CategoryEntity` (Danh mục: Điện tử, Điện lạnh, Gia dụng...).
   - `HomeEntity` & `HomeMemberEntity` (Quản lý nhà & Thành viên chia sẻ).
   - `MaintenancePresetEntity` (Mẫu gợi ý bảo trì thông minh).
   - `MaintenanceTaskEntity` (Lịch bảo trì).
   - `ServiceLogEntity` (Nhật ký chi phí sửa chữa).
   - `ProfileEntity` (Thông tin người dùng).
3. **Data Models (`lib/data/models/`):**
   - Khởi tạo `@freezed abstract class ItemModel with _$ItemModel` + `@JsonKey` + `fromJson`.
   - Khởi tạo `CategoryModel`, `HomeModel`, `MaintenancePresetModel`, `MaintenanceTaskModel`, `ServiceLogModel`, `ProfileModel`.
   - Chạy lệnh `dart run build_runner build --delete-conflicting-outputs` sinh code `.freezed.dart` và `.g.dart`.
4. **Data Mappers (`lib/data/mappers/`):**
   - `ItemMapper`: `toEntity(ItemModel)` $\leftrightarrow$ `toModel(ItemEntity)`.
   - `CategoryMapper`, `MaintenanceTaskMapper`, `ServiceLogMapper`, `ProfileMapper`.
   - Viết Unit Tests kiểm tra tính toàn vẹn khi chuyển đổi qua lại giữa Model và Entity.

#### 📦 Kết quả bàn giao (Deliverables)
- Bộ Unit Tests vượt qua 100%.
- Các file generated code hoàn chỉnh, không có lỗi linter.

---

### 🔹 PHASE 4: Tầng Repositories & Quản Lý Trạng Thái (Cubits + Freezed Sealed States)

#### 🎯 Mục tiêu
Hiện thực hóa các Repository kết nối trực tiếp với Supabase PostgreSQL / Storage và các Cubit quản lý State theo kiến trúc Freezed Sealed Union States.

#### 📋 Danh mục công việc chi tiết
1. **Domain Interfaces & Repositories (`lib/domain/repositories/` & `lib/data/repositories/`):**
   - `AuthRepository`: `signIn()`, `signUp()`, `signInAnonymously()`, `linkEmailAccount()`, `linkGoogleAccount()`, `signOut()`, `getCurrentUser()`, `isAnonymous()`, `updatePlayerId()`.
   - `ItemRepository`: `getItems()`, `getItemById()`, `addItem()`, `updateItem()`, `deleteItem()`, `searchItems()`.
   - `CategoryRepository` & `PresetRepository`: `getCategories()`, `getPresetsByCategory()`.
   - `MaintenanceRepository`: `getTasks()`, `addTask()`, `markTaskCompleted()`, `deleteTask()`.
   - `ServiceLogRepository`: `getLogs()`, `addLog()`, `getTotalCostByPeriod(week/month/year)`.
   - `HomeRepository`: `getHomes()`, `getMembers()`, `shareHome()`.
2. **Cubits & States (`lib/features/.../cubit/`):**
   - `AuthCubit` + `AuthState` (`initial`, `loading`, `authenticated(user, isAnonymous)`, `unauthenticated`, `error`).
   - `DashboardCubit` + `DashboardState` (Thống kê tổng quan, tài chính chi tiêu, cảnh báo sắp hết hạn, công việc cần làm).
   - `ItemListCubit` + `ItemListState` (Tải danh sách, lọc theo danh mục, vị trí phòng, trạng thái, **Tìm kiếm nhanh tức thì**).
   - `ItemFormCubit` + `ItemFormState` (Validate form, upload ảnh hóa đơn/phiếu BH, gợi ý chu kỳ bảo dưỡng mẫu).
   - `MaintenanceCubit` + `MaintenanceState` (Danh sách nhiệm vụ, hoàn thành & tự động ghi nhận vào `service_logs`).
   - `ServiceLogCubit` + `ServiceLogState` (Quản lý lịch sử chi phí sửa chữa, biểu đồ chi tiêu).
3. **Bloc Tests (`test/features/.../`):**
   - Sử dụng `bloc_test` và `mocktail` để kiểm thử luồng phát sinh state khi gọi phương thức repository.

#### 📦 Kết quả bàn giao (Deliverables)
- Tầng Logic & State hoàn chỉnh, độc lập với UI.
- Toàn bộ Bloc Tests chạy thành công.

---

### 🔹 PHASE 5: Xây Dựng Giao Diện Người Dùng & 5 Tính Năng Đắt Giá

#### 🎯 Mục tiêu
Hiện thực hóa toàn bộ **14 màn hình** theo kiến trúc **4 Tabs** chuẩn phong cách Minimalist Card-based (Apple-like), đáp ứng tiêu chuẩn `frontend-design`.
*(Chi tiết toàn bộ 14 màn hình xem tại [navigation_and_pages.md](file:///D:/Flutter/HomeSync/.agents/docs/navigation_and_pages.md))*.

#### 📋 5 Tính Năng Nổi Bật Được Tích Hợp:
1. **📄 1. Xuất Báo Cáo Tài Sản (Insurance & Warranty PDF Export):**
   - Nút bấm *"Xuất Báo Cáo PDF"* trên trang chủ hoặc trang cá nhân $\rightarrow$ Tạo file PDF chuẩn hồ sơ bảo hiểm gồm đầy đủ ảnh hóa đơn, số serial, giá tiền và thông tin bảo hành.
2. **💡 2. Gợi Ý Chu Kỳ Bảo Trì Tự Động (Smart Maintenance Presets):**
   - Khi thêm thiết bị mới hoặc chọn danh mục $\rightarrow$ App tự động gợi ý lịch bảo trì chuẩn (VD: Điều hòa $\rightarrow$ Vệ sinh lọc bụi 6 tháng).
3. **📅 3. Đồng Bộ Lịch Điện Thoại (Add to Calendar):**
   - Trên mỗi thẻ bảo trì, có nút *"Thêm vào Lịch điện thoại"* đồng bộ thẳng vào Google / Apple Calendar.
4. **👨‍👩‍👧‍👦 4. Chia Sẻ Thiết Bị Trong Gia Đình (Family / QR Sharing):**
   - Tạo mã QR hoặc mã mời để vợ/chồng cùng quét mã và đồng bộ danh mục thiết bị trong nhà.
5. **🔍 5. Tra Cứu Nhanh & Lọc Đa Tiêu Chí (Instant Global Search):**
   - Thanh tìm kiếm thông minh tìm theo: Tên máy, Hãng, Số Serial, Vị trí phòng, Nơi mua.

#### 📱 Danh Sách Các Màn Hình Chi Tiết:
- `AuthWelcomeScreen`: Màn hình khởi đầu 1 chạm gồm **Nút "Bắt đầu sử dụng ngay" (Đăng nhập nhanh - Guest Mode)** và **Nút "Tiếp tục với Google" (Google Sign-In)**.
- `HomeScreen` (Tab 1): Radar sức khỏe thiết bị, Thống kê chi tiêu tuần/tháng/năm, danh sách sắp hết hạn, nút Xuất PDF, **Smart Nudge Banner** nhắc nhở liên kết tài khoản khi đang ở chế độ Guest.
- `PdfPreviewScreen`: Xem trước & chia sẻ/in file PDF báo cáo tài sản.
- `ItemListScreen` (Tab 2): Tìm kiếm tức thì, lọc theo Category & Phòng, thẻ `ItemCard` kèm `WarrantyProgressBar`.
- `AddEditItemScreen` (Tab 2): Form nhập liệu thông minh (3 chế độ: Scan OCR, Scan Barcode, Nhập tay), gợi ý chu kỳ bảo trì mẫu.
- `ItemDetailScreen` (Tab 2): Chi tiết máy, số serial, hotline gọi hãng 1 chạm, xem ảnh hóa đơn Full HD, lịch sử sửa chữa của máy.
- `ReceiptViewerScreen` (Tab 2): Xem ảnh hóa đơn Full HD (Zoom/Pan).
- `MaintenanceListScreen` (Tab 3): Phân nhóm công việc & nhật ký chi phí, nút gọi thợ 1 chạm, tick hoàn thành tự động nhảy chu kỳ và lưu chi phí.
- `AddServiceLogScreen` (Tab 3): Danh sách nhật ký sửa chữa & chi phí đột xuất.
- `ProfileScreen` (Tab 4): Quản lý tài khoản, **Nút "Liên kết với Google để lưu Cloud"** khi ở chế độ Guest, mã QR chia sẻ nhà, cài đặt thông báo.
- `FamilyMembersScreen` (Tab 4): Quản lý danh sách thành viên trong nhà & phân quyền.

#### 📦 Kết quả bàn giao (Deliverables)
- Giao diện hoàn chỉnh, phản hồi mượt mà, chuẩn Minimalist Apple.

---

### 🔹 PHASE 6: Testing Toàn Diện, Rà Soát Bảo Mật & Nghiệm Thu Chất Lượng

#### 🎯 Mục tiêu
Kiểm tra toàn diện trước khi bàn giao theo nguyên tắc **Verification-Before-Completion** và **Security Review**.

#### 📋 Danh mục công việc chi tiết
1. **Kiểm tra Phân tích Mã nguồn (Static Analysis):**
   - Chạy lệnh `flutter analyze` — Đảm bảo 0 errors, 0 warnings, 0 lints.
2. **Kiểm tra Toàn bộ Test Suite:**
   - Chạy lệnh `flutter test` — Đảm bảo 100% Unit Tests và Bloc Tests đều Passed.
3. **Audit An ninh & Mã nguồn (Code & Security Review):**
   - Rà soát các chính sách RLS trên Supabase.
   - Kiểm tra an toàn bộ nhớ (Disposal của controllers, cancel stream subscriptions).
   - Kiểm tra `context.mounted` an toàn sau các tác vụ bất đồng bộ.
4. **Tổng kết & Bàn giao:**
   - Tạo file `walkthrough.md` tổng kết toàn bộ thành quả dự án kèm hướng dẫn khởi chạy.

---

## 📊 BẢNG THEO DÕI TIẾN ĐỘ (PROGRESS TRACKER)

| Giai đoạn | Nội dung cốt lõi | Trạng thái |
| :--- | :--- | :--- |
| **Phase 1** | Dependencies, Pubspec & Build Runner Setup | 🟡 Sẵn sàng thực hiện |
| **Phase 2** | Design Tokens, Theme M3, Core Services (PDF, Calendar, Storage) | ⚪ Chờ Phase 1 |
| **Phase 3** | TDD Domain Logic, Freezed Models & Mappers | ⚪ Chờ Phase 2 |
| **Phase 4** | Repositories Implementation & Cubit State Machines | ⚪ Chờ Phase 3 |
| **Phase 5** | UI Screens (Minimalist Apple-like) & 5 Tính Năng Cốt Lõi | ⚪ Chờ Phase 4 |
| **Phase 6** | Full Test Suite, Security Audit & Verification Gate | ⚪ Chờ Phase 5 |
