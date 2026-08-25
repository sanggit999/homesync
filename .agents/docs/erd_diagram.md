# Sơ Đồ Quan Hệ Cơ Sở Dữ Liệu Toàn Diện & Khả Năng Mở Rộng Cao (Scalable ERD) - HomeSync

Tài liệu này mô tả toàn diện hệ thống cơ sở dữ liệu quan hệ (PostgreSQL / Supabase) của dự án **HomeSync**, được thiết kế để **Scale** từ người dùng cá nhân đến mô hình hộ gia đình (Family Sharing), lưu trữ đa tài liệu (Document Vault), phân tích chi tiêu tài chính (Spending Analytics) và tự động hóa bảo trì.

---

## 📊 1. Sơ Đồ Thực Thể Quan Hệ (Mermaid ERD)

```mermaid
erDiagram
    AUTH_USERS ||--|| PROFILES : "1 : 1 (id = auth.users.id)"
    PROFILES ||--o{ HOMES : "1 : N (owner_id -> profiles.id)"
    HOMES ||--o{ HOME_MEMBERS : "1 : N (home_id -> homes.id)"
    PROFILES ||--o{ HOME_MEMBERS : "1 : N (user_id -> profiles.id)"
    
    HOMES ||--o{ ITEMS : "1 : N (home_id -> homes.id)"
    PROFILES ||--o{ ITEMS : "1 : N (user_id -> profiles.id)"
    CATEGORIES ||--o{ ITEMS : "1 : N (category_id -> categories.id)"
    
    ITEMS ||--o{ ITEM_DOCUMENTS : "1 : N (item_id -> items.id)"
    ITEMS ||--o{ MAINTENANCE_TASKS : "1 : N (item_id -> items.id)"
    ITEMS ||--o{ SERVICE_LOGS : "1 : N (item_id -> items.id)"
    PROFILES ||--o{ SERVICE_LOGS : "1 : N (user_id -> profiles.id)"
    MAINTENANCE_TASKS ||--o{ SERVICE_LOGS : "0..1 : N (task_id -> maintenance_tasks.id)"
    CATEGORIES ||--o{ MAINTENANCE_PRESETS : "1 : N (category_id -> categories.id)"

    AUTH_USERS {
        uuid id PK "Supabase Auth ID"
        text email "Email đăng nhập"
    }

    PROFILES {
        uuid id PK, FK "References auth.users.id"
        text full_name "Họ và tên người dùng"
        text avatar_url "Link ảnh đại diện"
        text onesignal_player_id "Player ID / Push Subscription"
        int reminder_days_before "Số ngày nhắc trước (Mặc định: 7)"
        boolean notify_warranty "Bật/Tắt nhắc bảo hành"
        boolean notify_maintenance "Bật/Tắt nhắc bảo trì"
        timestamptz updated_at "Thời gian cập nhật"
    }

    HOMES {
        uuid id PK "Khóa chính UUID tự sinh"
        uuid owner_id FK "Chủ nhà (profiles.id)"
        text name "Tên nhà (Nhà riêng, Căn hộ Vinhomes...)"
        text address "Địa chỉ"
        timestamptz created_at "Thời gian tạo"
    }

    HOME_MEMBERS {
        uuid id PK "Khóa chính UUID tự sinh"
        uuid home_id FK "References homes.id"
        uuid user_id FK "References profiles.id"
        text role "Vai trò ('owner', 'editor', 'viewer')"
        timestamptz created_at "Thời gian tham gia"
    }

    CATEGORIES {
        uuid id PK "Khóa chính UUID tự sinh"
        text name "Tên danh mục (Điện tử, Điện lạnh...)"
        text icon_name "Tên icon Lucide/Material"
        timestamptz created_at "Thời gian tạo"
    }

    MAINTENANCE_PRESETS {
        uuid id PK "Khóa chính UUID tự sinh"
        uuid category_id FK "Danh mục tương ứng"
        text preset_name "Tên mẫu (Vệ sinh lưới lọc điều hòa)"
        int default_frequency_months "Chu kỳ mặc định (tháng)"
        text suggested_priority "Mức ưu tiên đề xuất"
    }

    ITEMS {
        uuid id PK "Khóa chính UUID tự sinh"
        uuid user_id FK "Người tạo (profiles.id)"
        uuid home_id FK "Thuộc nhà (homes.id, nullable)"
        uuid category_id FK "Danh mục (categories.id)"
        text name "Tên thiết bị (Bắt buộc)"
        text brand "Hãng sản xuất"
        text model_number "Mã Model"
        text serial_number "Số Serial máy"
        text location "Vị trí trong nhà (Phòng khách, Bếp...)"
        numeric price "Giá mua thiết bị (VND)"
        text store_name "Nơi mua (Điện Máy Xanh, Shopee...)"
        text status "Trạng thái ('active', 'in_repair', 'disposed')"
        boolean is_favorite "Ghim yêu thích"
        text_array tags "Tag phân loại"
        date purchase_date "Ngày mua"
        int warranty_period_months "Thời hạn BH (tháng)"
        date warranty_expiry_date "Ngày hết hạn bảo hành"
        text warranty_type "Loại gói BH ('standard', 'extended', 'applecare')"
        text support_phone "Hotline bảo hành chính hãng"
        text device_image_url "Ảnh chụp thiết bị"
        text receipt_image_url "Ảnh chụp hóa đơn chính"
        text warranty_card_image_url "Ảnh phiếu bảo hành mộc đỏ"
        text manual_url "Link PDF HDSD / Bảng mã lỗi"
        text notes "Ghi chú thêm"
        timestamptz created_at "Thời gian tạo"
    }

    ITEM_DOCUMENTS {
        uuid id PK "Khóa chính UUID tự sinh"
        uuid item_id FK "References items.id"
        text document_type "Loại ('receipt', 'warranty_card', 'manual', 'repair_invoice', 'other')"
        text file_name "Tên tài liệu"
        text file_url "Link Supabase Storage"
        timestamptz created_at "Thời gian upload"
    }

    MAINTENANCE_TASKS {
        uuid id PK "Khóa chính UUID tự sinh"
        uuid item_id FK "References items.id"
        text task_name "Tên việc cần làm"
        int frequency_months "Chu kỳ lặp lại (tháng)"
        date last_completed_at "Ngày hoàn thành gần nhất"
        date next_due_date "Ngày đến hạn tiếp theo"
        boolean is_completed "Trạng thái hoàn thành"
        text priority "Mức ưu tiên ('low', 'medium', 'high', 'urgent')"
        text technician_name "Tên thợ quen / Đơn vị sửa chữa"
        text technician_phone "Số điện thoại thợ (Bấm gọi ngay)"
        numeric estimated_cost "Chi phí dự trù"
        numeric cost "Chi phí lần làm trước"
        text notes "Ghi chú vật tư/phụ tùng"
        timestamptz created_at "Thời gian tạo"
    }

    SERVICE_LOGS {
        uuid id PK "Khóa chính UUID tự sinh"
        uuid user_id FK "Người chi trả (profiles.id)"
        uuid item_id FK "Thiết bị (items.id)"
        uuid task_id FK "Lịch bảo trì gốc (nullable)"
        text service_type "Loại ('maintenance', 'repair', 'replacement', 'warranty_claim')"
        text title "Tên công việc (Thay lõi lọc nước, nạp ga...)"
        date service_date "Ngày thực hiện"
        numeric cost "Số tiền thanh toán thực tế (VND)"
        text technician_name "Tên thợ / Cửa hàng thực hiện"
        text technician_phone "SĐT liên hệ"
        text receipt_image_url "Ảnh hóa đơn thanh toán / Phiếu thu"
        text notes "Ghi chú phụ tùng mới thay"
        timestamptz created_at "Thời gian tạo"
    }
```

---

## 🗃️ 2. Mô Tả Chi Tiết Hệ Thống Bảng & Nghiệp Vụ

1. **`profiles`**: Quản lý thông tin mở rộng của người dùng và các thiết lập thông báo đẩy qua OneSignal.
2. **`homes` & `home_members`**: Cho phép chia sẻ thiết bị trong gia đình (Multi-tenancy Family Sharing). Vợ/chồng/con cái cùng xem và cập nhật lịch bảo dưỡng của các thiết bị trong nhà.
3. **`categories`**: Danh mục phân loại chuẩn (Điện tử, Điện lạnh, Gia dụng, Xe cộ, Thiết bị cá nhân, Khác).
4. **`maintenance_presets`**: Thư viện đề xuất bảo dưỡng tự động. Khi người dùng chọn thiết bị, hệ thống tự động gợi ý lịch bảo trì chuẩn của chuyên gia.
5. **`items`**: Bảng trung tâm lưu trữ toàn bộ dữ liệu thiết bị, số serial, thông tin bảo hành, hotline hỗ trợ hãng, ảnh chụp và vị trí phòng.
6. **`item_documents`**: Kho lưu trữ đa tệp đính kèm (hóa đơn VAT, phiếu bảo hành mộc đỏ, file PDF hướng dẫn sử dụng, ảnh tem máy).
7. **`maintenance_tasks`**: Lịch bảo trì định kỳ có nhắc việc, lưu số điện thoại thợ để bấm gọi ngay.
8. **`service_logs`**: Nhật ký chi phí tài chính cho phép thống kê tổng số tiền đã chi bảo trì/sửa chữa theo **Tuần**, **Tháng**, **Năm**.

---

## 🔒 3. Bảo Mật Dữ Liệu Tuyệt Đối (Row Level Security - RLS)

Mỗi bảng đều được áp dụng chính sách RLS ở tầng Database Engine của Supabase để đảm bảo người dùng chỉ xem và quản lý dữ liệu thuộc quyền sở hữu của mình hoặc các nhà (Homes) mà mình được chia sẻ.
