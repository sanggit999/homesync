import 'package:fpdart/fpdart.dart';
import 'package:home_sync/core/errors/failures.dart';

/// Base UseCase Interface cho mọi nghiệp vụ Async trả về `Either<Failure, T>`
abstract class UseCase<T, Params> {
  const UseCase();
  Future<Either<Failure, T>> call(Params params);
}

/// Base StreamUseCase Interface cho các luồng dữ liệu thời gian thực (Realtime Streams)
abstract class StreamUseCase<T, Params> {
  const StreamUseCase();
  Stream<T> call(Params params);
}

/// Base Synchronous UseCase Interface cho các nghiệp vụ xử lý đồng bộ
abstract class SyncUseCase<T, Params> {
  const SyncUseCase();
  T call(Params params);
}

/// Tham số rỗng khi UseCase không yêu cầu tham số đầu vào
class NoParams {
  const NoParams();
}
