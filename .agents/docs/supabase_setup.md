# Hướng Dẫn Chi Tiết Thiết Lập Supabase Cho HomeSync (Supabase Setup Guide)

Tài liệu này cung cấp toàn bộ quy trình thiết lập Backend & Database trên Supabase dành cho dự án **HomeSync**, tuân thủ nghiêm ngặt tài liệu chính thức [Supabase Flutter Documentation](https://supabase.com/docs/guides/getting-started/quickstarts/flutter).

---

## 📌 QUY TRÌNH THỰC HIỆN TỔNG QUAN (FLOWCHART)

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│ 1. Tạo Project trên Supabase Dashboard (Region: Singapore ap-southeast-1)    │
├─────────────────────────────────────────────────────────────────────────────┤
│ 2. Lấy API Credentials (Project URL & Anon/Public API Key)                  │
├─────────────────────────────────────────────────────────────────────────────┤
│ 3. Chạy SQL Script Toàn Diện (Bảng, Triggers, RLS, Presets & Indexes)       │
├─────────────────────────────────────────────────────────────────────────────┤
│ 4. Tạo & Phân quyền Storage Bucket 'receipts' (Lưu ảnh hóa đơn/phiếu BH)    │
├─────────────────────────────────────────────────────────────────────────────┤
│ 5. Cấu hình Supabase Auth (Bật Email Provider, Tùy chỉnh Xác thực)          │
├─────────────────────────────────────────────────────────────────────────────┤
│ 6. Tích hợp SDK vào Ứng dụng Flutter (AppConfig & main.dart)                │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 🔹 BƯỚC 1: Tạo Dự Án Trên Supabase Dashboard

1. Truy cập [https://supabase.com/dashboard](https://supabase.com/dashboard) và đăng nhập tài khoản.
2. Nhấn nút **New Project** và chọn **Organization** của bạn.
3. Điền các thông tin cơ bản:
   - **Name:** `HomeSync`
   - **Database Password:** Đặt mật khẩu an toàn và lưu lại cẩn thận.
   - **Region:** Chọn `Southeast Asia (Singapore) - ap-southeast-1` để có tốc độ truy vấn nhanh nhất và độ trễ thấp nhất cho người dùng tại Việt Nam.
   - **Pricing Plan:** Chọn gói `Free Plan`.
4. Nhấn **Create new project** và đợi khoảng 1–2 phút để cơ sở dữ liệu PostgreSQL khởi tạo xong.

---

## 🔹 BƯỚC 2: Lấy API Credentials

1. Ở thanh menu bên trái, truy cập vào **Project Settings** $\rightarrow$ chọn **API**.
2. Tìm mục **Project API keys** và sao chép 2 giá trị sau:
   - **Project URL:** `https://[your-project-ref].supabase.co`
   - **anon / public key:** Chuỗi JWT dài bắt đầu bằng `eyJhbGciOi...` *(Khóa an toàn để nhúng vào client Flutter)*.

---

## 🔹 BƯỚC 3: Chạy SQL Schema Toàn Diện & Scalable (SQL Editor)

1. Ở menu bên trái, chọn **SQL Editor** $\rightarrow$ bấm **+ New Query**.
2. Dán toàn bộ nội dung SQL chuẩn hóa dưới đây và bấm **RUN**:

```sql
-- =========================================================================
-- HOMESYNC PRODUCTION-READY & SCALABLE DATABASE SCHEMA
-- =========================================================================

-- 1. Kích hoạt Extension UUID
create extension if not exists "uuid-ossp";

-- 2. BẢNG PROFILES (Thông tin người dùng & Cài đặt thông báo)
create table if not exists public.profiles (
  id uuid references auth.users on delete cascade primary key,
  full_name text,
  avatar_url text,
  onesignal_player_id text,
  reminder_days_before integer default 7,
  notify_warranty boolean default true,
  notify_maintenance boolean default true,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 3. BẢNG HOMES (Quản lý Nhà / Căn hộ)
create table if not exists public.homes (
  id uuid default gen_random_uuid() primary key,
  owner_id uuid references public.profiles(id) on delete cascade not null,
  name text not null,                       -- VD: Nhà riêng, Căn hộ chung cư
  address text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 4. BẢNG HOME_MEMBERS (Chia sẻ quyền quản lý gia đình)
create table if not exists public.home_members (
  id uuid default gen_random_uuid() primary key,
  home_id uuid references public.homes(id) on delete cascade not null,
  user_id uuid references public.profiles(id) on delete cascade not null,
  role text default 'member' not null,      -- 'owner', 'editor', 'viewer'
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  unique(home_id, user_id)
);

-- 5. BẢNG CATEGORIES (Danh mục thiết bị)
create table if not exists public.categories (
  id uuid default gen_random_uuid() primary key,
  name text not null,
  icon_name text not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

insert into public.categories (name, icon_name) values
  ('Điện tử', 'tv'),
  ('Gia dụng', 'home'),
  ('Điện lạnh', 'wind'),
  ('Xe cộ', 'car'),
  ('Thiết bị cá nhân', 'smartphone'),
  ('Khác', 'box')
on conflict do nothing;

-- 6. BẢNG MAINTENANCE_PRESETS (Gợi ý chu kỳ bảo trì tự động)
create table if not exists public.maintenance_presets (
  id uuid default gen_random_uuid() primary key,
  category_id uuid references public.categories(id) on delete cascade not null,
  preset_name text not null,
  default_frequency_months integer not null,
  suggested_priority text default 'medium' not null
);

insert into public.maintenance_presets (category_id, preset_name, default_frequency_months, suggested_priority)
select id, 'Vệ sinh lưới lọc bụi', 6, 'medium' from public.categories where name = 'Điện lạnh'
union all
select id, 'Bảo dưỡng & nạp gas định kỳ', 12, 'high' from public.categories where name = 'Điện lạnh'
union all
select id, 'Thay lõi lọc nước thô 1-2-3', 6, 'high' from public.categories where name = 'Gia dụng'
union all
select id, 'Thay màng lọc RO / Nano', 24, 'urgent' from public.categories where name = 'Gia dụng'
union all
select id, 'Thay nhớt & kiểm tra phanh xe', 3, 'high' from public.categories where name = 'Xe cộ';

-- 7. BẢNG ITEMS (Sản phẩm & Thiết bị bảo hành)
create table if not exists public.items (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references public.profiles(id) on delete cascade not null,
  home_id uuid references public.homes(id) on delete set null,
  category_id uuid references public.categories(id) on delete set null,
  
  -- Thông tin sản phẩm
  name text not null,
  brand text,
  model_number text,
  serial_number text,
  location text,
  price numeric(15, 2),
  store_name text,
  status text default 'active' not null,
  is_favorite boolean default false not null,
  tags text[],
  
  -- Thông tin bảo hành
  purchase_date date not null,
  warranty_period_months integer,
  warranty_expiry_date date not null,
  warranty_type text default 'standard',
  support_phone text,
  
  -- Hình ảnh & Tài liệu
  device_image_url text,
  receipt_image_url text,
  warranty_card_image_url text,
  manual_url text,
  notes text,
  
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 8. BẢNG ITEM_DOCUMENTS (Kho tài liệu đính kèm đa tệp)
create table if not exists public.item_documents (
  id uuid default gen_random_uuid() primary key,
  item_id uuid references public.items(id) on delete cascade not null,
  document_type text not null,             -- 'receipt', 'warranty_card', 'manual', 'repair_invoice', 'other'
  file_name text not null,
  file_url text not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 9. BẢNG MAINTENANCE_TASKS (Lịch bảo trì định kỳ & Liên hệ thợ)
create table if not exists public.maintenance_tasks (
  id uuid default gen_random_uuid() primary key,
  item_id uuid references public.items(id) on delete cascade not null,
  task_name text not null,
  frequency_months integer not null,
  last_completed_at date,
  next_due_date date not null,
  is_completed boolean default false not null,
  priority text default 'medium' not null,
  technician_name text,
  technician_phone text,
  estimated_cost numeric(15, 2),
  cost numeric(15, 2),
  notes text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 10. BẢNG SERVICE_LOGS (Lịch sử chi phí sửa chữa / bảo dưỡng)
create table if not exists public.service_logs (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references public.profiles(id) on delete cascade not null,
  item_id uuid references public.items(id) on delete cascade not null,
  task_id uuid references public.maintenance_tasks(id) on delete set null,
  service_type text not null,
  title text not null,
  service_date date not null,
  cost numeric(15, 2) default 0 not null,
  technician_name text,
  technician_phone text,
  receipt_image_url text,
  notes text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- =========================================================================
-- INDEXES TỐI ƯU HIỆU NĂNG TRUY VẤN
-- =========================================================================
create index if not exists idx_items_user_id on public.items(user_id);
create index if not exists idx_items_home_id on public.items(home_id);
create index if not exists idx_items_warranty_expiry on public.items(warranty_expiry_date);
create index if not exists idx_items_category on public.items(category_id);
create index if not exists idx_items_status on public.items(status);
create index if not exists idx_items_favorite on public.items(is_favorite);
create index if not exists idx_item_docs_item on public.item_documents(item_id);
create index if not exists idx_maintenance_item_id on public.maintenance_tasks(item_id);
create index if not exists idx_maintenance_next_due on public.maintenance_tasks(next_due_date);
create index if not exists idx_service_logs_user_date on public.service_logs(user_id, service_date);
create index if not exists idx_service_logs_item on public.service_logs(item_id);

-- =========================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- =========================================================================
alter table public.profiles enable row level security;
alter table public.homes enable row level security;
alter table public.home_members enable row level security;
alter table public.categories enable row level security;
alter table public.maintenance_presets enable row level security;
alter table public.items enable row level security;
alter table public.item_documents enable row level security;
alter table public.maintenance_tasks enable row level security;
alter table public.service_logs enable row level security;

-- Profiles
create policy "Users can view and edit own profile" on public.profiles for all using (auth.uid() = id);

-- Homes & Members
create policy "Users can manage homes they own" on public.homes for all using (auth.uid() = owner_id);
create policy "Users can view homes they are member of" on public.homes for select using (
  exists (select 1 from public.home_members where home_members.home_id = homes.id and home_members.user_id = auth.uid())
);
create policy "Users can view member list" on public.home_members for all using (
  exists (select 1 from public.homes where homes.id = home_members.home_id and homes.owner_id = auth.uid())
  or user_id = auth.uid()
);

-- Categories & Presets
create policy "Categories are readable by all authenticated users" on public.categories for select using (auth.role() = 'authenticated');
create policy "Presets are readable by all authenticated users" on public.maintenance_presets for select using (auth.role() = 'authenticated');

-- Items & Documents
create policy "Users can manage their own items" on public.items for all using (
  auth.uid() = user_id or
  exists (
    select 1 from public.home_members 
    where home_members.home_id = items.home_id 
    and home_members.user_id = auth.uid()
    and home_members.role in ('owner', 'editor')
  )
);

create policy "Users can manage item documents" on public.item_documents for all using (
  exists (select 1 from public.items where items.id = item_documents.item_id and items.user_id = auth.uid())
);

-- Maintenance Tasks & Service Logs
create policy "Users can manage maintenance tasks for their items" on public.maintenance_tasks for all using (
  exists (select 1 from public.items where items.id = maintenance_tasks.item_id and items.user_id = auth.uid())
);

create policy "Users can manage their own service logs" on public.service_logs for all using (auth.uid() = user_id);

-- =========================================================================
-- DATABASE TRIGGERS
-- =========================================================================
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, full_name)
  values (new.id, new.raw_user_meta_data->>'full_name');
  
  -- Tự động tạo 1 ngôi nhà mặc định "Nhà của tôi"
  insert into public.homes (owner_id, name)
  values (new.id, 'Nhà của tôi');
  
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute procedure public.handle_new_user();
```

---

## 🔹 BƯỚC 4: Tạo Storage Bucket Cho Ảnh Hóa Đơn (`receipts`)

1. Ở menu bên trái, chọn **Storage** $\rightarrow$ Bấm **New Bucket**.
2. Đặt tên Bucket: `receipts` $\rightarrow$ Bật **Public bucket** $\rightarrow$ Nhấn **Save**.
3. Vào **SQL Editor**, chạy đoạn phân quyền Storage:

```sql
create policy "Authenticated users can upload receipts" on storage.objects
  for insert with check (bucket_id = 'receipts' and auth.role() = 'authenticated');

create policy "Public can view receipts" on storage.objects
  for select using (bucket_id = 'receipts');

create policy "Users can delete own receipt images" on storage.objects
  for delete using (bucket_id = 'receipts' and auth.role() = 'authenticated');
```

---

## 🔹 BƯỚC 5: Cấu Hình Supabase Authentication & Anonymous Sign-in (Guest Mode)

1. **Bật Email Provider:**
   - Vào **Authentication** $\rightarrow$ **Providers** $\rightarrow$ Đảm bảo **Email** đang ở trạng thái **Enabled**.
2. **Bật Đăng Nhập Ẩn Danh (Allow Anonymous Sign-ins):**
   - Vào **Authentication** $\rightarrow$ **Providers** $\rightarrow$ Bật **"Allow anonymous sign-ins"**.
   - Điều này cho phép app gọi `supabase.auth.signInAnonymously()` để người dùng trải nghiệm tức thì mà không bị chặn ở màn hình đăng nhập.
3. **Cơ chế Nâng Cấp Tài Khoản (Account Linking Flow):**
   - Khi user đang ở chế độ Ẩn danh (`supabase.auth.currentUser?.isAnonymous == true`):
     - **Liên kết Email/Mật khẩu:**
       ```dart
       await supabase.auth.updateUser(
         UserAttributes(
           email: 'user@example.com',
           password: 'securePassword123',
           data: {'full_name': 'Nguyễn Văn A'},
         ),
       );
       ```
     - **Liên kết Google OAuth (Link Identity):**
       ```dart
       await supabase.auth.linkIdentity(OAuthProvider.google);
       ```
   - *Kết quả:* Toàn bộ dữ liệu thiết bị, hóa đơn, lịch bảo dưỡng đã tạo trong chế độ Guest vẫn được giữ nguyên 100%, không bị mất mát!

---

## 🔹 BƯỚC 6: Tích Hợp Vào Mã Nguồn Flutter (`supabase_flutter`)

1. Khai báo trong `pubspec.yaml`:
   ```yaml
   dependencies:
     supabase_flutter: ^2.8.4
   ```

2. Cấu hình tại `lib/core/config/app_config.dart`:
   ```dart
   class AppConfig {
     static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://your-project.supabase.co');
     static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: 'eyJhbGciOi...');
     static const String oneSignalAppId = String.fromEnvironment('ONESIGNAL_APP_ID', defaultValue: 'your-onesignal-app-id');
   }
   ```

3. Khởi tạo tại `lib/main.dart`:
   ```dart
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await Supabase.initialize(url: AppConfig.supabaseUrl, anonKey: AppConfig.supabaseAnonKey);
     runApp(const HomeSyncApp());
   }
   final supabase = Supabase.instance.client;
   ```
