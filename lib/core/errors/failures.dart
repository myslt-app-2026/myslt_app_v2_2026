/// Domain-level failure types for the mySLT app.
/// Use these in `Either<Failure, T>` returns from repositories.
sealed class Failure {
  const Failure({required this.message, this.code});

  final String message;
  final int? code;
}

/// No internet connectivity.
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection. Please check your network.',
    super.code,
  });
}

/// Server returned a non-2xx response.
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
  });
}

/// Local cache read/write failure.
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Failed to read local data.',
    super.code,
  });
}

/// Authentication-related failure (invalid credentials, token expired).
class AuthFailure extends Failure {
  const AuthFailure({
    super.message = 'Authentication failed. Please login again.',
    super.code,
  });
}

/// Input validation failure.
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.code});
}

/// Request timed out.
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'Request timed out. Please try again.',
    super.code,
  });
}

/// Unknown or unexpected failure.
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unexpected error occurred.',
    super.code,
  });
}
