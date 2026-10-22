import 'package:dartz/dartz.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';

abstract interface class UseCase<T, P> {
  Future<Either<Failure, T>> call(P params);
}

/// For pure in-memory operations. It is synchronous so that a Cubit can read
/// its state, run the operation and emit without an await in between, which
/// rules out two rapid actions working on the same stale state.
abstract interface class SyncUseCase<T, P> {
  Either<Failure, T> call(P params);
}

class NoParams {
  const NoParams();
}
