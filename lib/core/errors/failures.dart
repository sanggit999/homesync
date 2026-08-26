/// Lớp cơ sở đại diện cho các lỗi hệ thống trong tầng Domain
abstract class Failure {
  const Failure(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Lỗi phát sinh từ Server / Database / Supabase
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Lỗi kết nối máy chủ hoặc truy vấn cơ sở dữ liệu.']);
}

/// Lỗi xác thực tài khoản / Phiên đăng nhập
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Lỗi xác thực người dùng.']);
}

/// Người dùng chủ động hủy thao tác xác thực (Google / Apple Sign In)
class AuthCanceledFailure extends AuthFailure {
  const AuthCanceledFailure([super.message = 'Đã hủy thao tác liên kết.']);
}

/// Tài khoản Google đã được liên kết với một người dùng khác trước đó (Identity Conflict)
class AuthAccountAlreadyExistsFailure extends AuthFailure {
  const AuthAccountAlreadyExistsFailure([
    super.message = 'Tài khoản Google này đã tồn tại trên hệ thống.',
    this.email,
  ]);

  final String? email;
}

/// Lỗi truy xuất bộ nhớ cục bộ / Caching
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Lỗi truy xuất bộ nhớ đệm.']);
}

/// Lỗi dữ liệu không hợp lệ / Validation
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Dữ liệu đầu vào không hợp lệ.']);
}

/// Lỗi tải tệp / Lưu trữ hình ảnh
class StorageFailure extends Failure {
  const StorageFailure([super.message = 'Lỗi tải lên hoặc lưu trữ tệp.']);
}
