# 📋 HomeSync - Lưu Ý Vận Hành & Lộ Trình Nâng Cấp (Roadmap)

Tài liệu này tổng hợp toàn bộ các lưu ý kỹ thuật quan trọng khi triển khai hệ thống xác thực, bảo mật và kế hoạch mở rộng tính năng cho các giai đoạn (phases) tiếp theo của dự án **HomeSync**.

---

## 🏛️ I. Tổng Quan Kiến Trúc Đã Đạt Được (Current Status)

- **Clean Architecture & Feature-First:** Tách biệt rõ rệt 3 tầng: `Data` (Supabase, Google Sign-In SDK), `Domain` (UseCases, Entities, Failures), `Presentation` (BLoC/Cubit, Pages, Widgets).
- **100% Type-Safe Exception Handling:** Xử lý triệt để mã lỗi từ `GoogleSignInException`, `PlatformException` (12501, canceled) và `SupabaseAuthStatusCodes` mà không dùng chuỗi hardcode.
- **Bảo mật OWASP & Chống Account Enumeration:** Hộp thoại thông báo khi trùng tài khoản Google được thiết kế trung tính, bảo vệ dữ liệu người dùng.
- **Root UI Utilities:** Hệ thống `AppSnackBar` và `showAppDialog` bọc Root Messenger/Navigator toàn cục.

---

## 📌 II. Các Lưu Ý Kỹ Thuật Quan Trọng (Production Notes)

### 1. Cấu hình Google Cloud Console & Keystore
- **Debug Keystore:** SHA-1 hiện tại (`D6:60:32:BE:77:44:08:88:68:E6:0A:DF:E3:50:09:87:0C:39:41:34`) dành riêng cho môi trường Debug trên Android.
- **Release Keystore:** Khi build bản phát hành (`flutter build apk --release` hoặc App Bundle cho Google Play), bắt buộc phải trích xuất SHA-1 từ file `release-key.jks` và thêm vào Google Cloud Console (loại Android Client ID).
- **Web Client ID:** Luôn sử dụng Web Client ID làm `serverClientId` cho Google Sign-In SDK và cấu hình trên Supabase Dashboard.

### 2. Đồng bộ Database trên Supabase (Trigger & RLS)
- Đảm bảo trigger PostgreSQL đã được kích hoạt trên bảng `auth.users` để tự động cập nhật `is_anonymous = false`, `full_name`, `avatar_url` sang bảng `public.profiles` khi liên kết Google:
```sql
create or replace function public.handle_user_update()
returns trigger as $$
begin
  update public.profiles
  set
    full_name = coalesce(new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'name', profiles.full_name),
    avatar_url = coalesce(new.raw_user_meta_data->>'avatar_url', new.raw_user_meta_data->>'picture', profiles.avatar_url),
    is_anonymous = coalesce(new.is_anonymous, false),
    updated_at = now()
  where id = new.id;
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_updated on auth.users;
create trigger on_auth_user_updated
  after update on auth.users
  for each row execute function public.handle_user_update();
```

### 3. Dọn dẹp tài khoản ẩn danh mồ côi (Orphaned Anonymous Data Cleanup)
- Khi người dùng dùng thử rồi chọn "Đăng nhập tài khoản cũ", phiên Guest cũ sẽ bị hủy.
- **Khuyến nghị:** Thiết lập một Cronjob (pg_cron) hoặc Supabase Edge Function chạy hàng tuần để xóa các anonymous user không hoạt động quá 30 ngày để tiết kiệm dung lượng database:
```sql
delete from auth.users 
where is_anonymous = true 
  and last_sign_in_at < now() - interval '30 days';
```

---

## 🚀 III. Lộ Trình Phát Triển Các Phase Tiếp Theo (Next Phases Roadmap)

### 🔹 Phase 2: Xác thực sinh trắc học & Khóa ứng dụng (Biometrics App Lock)
- **Mục tiêu:** Bảo vệ dữ liệu nhạy cảm (hóa đơn VAT, giá trị tài sản, giấy bảo hành).
- **Triển khai:**
  - Tích hợp package `local_auth`.
  - Thêm tùy chọn *"Bật khóa ứng dụng bằng FaceID / Vân tay"* trong `ProfilePage`.
  - Kiểm tra sinh trắc học khi app chuyển từ background sang foreground.

### 🔹 Phase 3: Hỗ trợ Apple Sign-In (Cho nền tảng iOS)
- **Mục tiêu:** Đáp ứng điều khoản bắt buộc của Apple App Store (Guideline 4.8).
- **Triển khai:**
  - Tích hợp `sign_in_with_apple`.
  - Cấu hình Apple Developer Team ID, Service ID và Key ID trên Supabase Auth.
  - Bổ sung `signInWithApple()` và `linkWithApple()` vào `AuthRepository`.

### 🔹 Phase 4: Gộp dữ liệu tùy chọn khi trùng tài khoản (Selective Data Merge)
- **Mục tiêu:** Cho phép người dùng chọn giữ lại các món đồ vừa tạo lúc dùng thử khi chuyển sang tài khoản Google cũ.
- **Triển khai:**
  - Viết Supabase Database RPC function:
    ```sql
    create or replace function public.merge_anonymous_data(guest_id uuid, target_user_id uuid)
    returns void as $$
    begin
      update public.items set user_id = target_user_id where user_id = guest_id;
      update public.service_logs set user_id = target_user_id where user_id = guest_id;
    end;
    $$ language plpgsql security definer;
    ```
  - Bổ sung tùy chọn `[Gộp dữ liệu vào tài khoản cũ]` trên Hộp thoại xác nhận.

### 🔹 Phase 5: Chia sẻ tài sản gia đình & Đồng bộ nhóm (Family Sharing & Roles)
- **Mục tiêu:** Cho phép nhiều thành viên trong gia đình cùng theo dõi và cập nhật thiết bị.
- **Triển khai:**
  - Tạo bảng `homes` và `home_members` (với các Role: `Owner`, `Editor`, `Viewer`).
  - Nâng cấp RLS policies trên Supabase để cho phép các thành viên trong cùng một `home_id` xem và chỉnh sửa thiết bị.
  - Tạo mã QR tham gia gia đình với mã mời có thời hạn (Expiring Invitation Token).

### 🔹 Phase 6: Sao lưu ngoại tuyến & Mã hóa đầu cuối (Offline First & Encryption)
- **Mục tiêu:** Xem và tạo thiết bị ngay cả khi không có mạng (Offline Mode) và tự động đồng bộ khi có Internet trở lại.
- **Triển khai:**
  - Tích hợp `drift` (SQLite) hoặc `hive` làm local database cache.
  - Hàng đợi đồng bộ (Sync Queue) tự động xử lý conflict resolution (Last-Write-Wins).

---

*Tài liệu được cập nhật tự động vào ngày 27/08/2026 bởi HomeSync Engineering Team.*
