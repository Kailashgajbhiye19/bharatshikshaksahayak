import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository());

/// [AuthRepository] defines the interface for authentication operations.
/// In a full production app, this would use a RemoteDataSource (API) and LocalDataSource (Cache).
class AuthRepository {
  /// Attempts to log in a user.
  /// Returns null on success, or a [Failure] on error.
  Future<Failure?> login({required String email, required String password}) async {
    try {
      // -----------------------------------------------------------------------
      // PRODUCTION TIP: 
      // 1. Check connectivity: if (!await networkInfo.isConnected) return NetworkFailure();
      // 2. Call API: await remoteDataSource.login(email, password);
      // 3. Cache token: await localDataSource.saveToken(token);
      // -----------------------------------------------------------------------
      
      await Future.delayed(const Duration(seconds: 1)); // Simulate network
      
      // Basic mock check
      if (email == "error@example.com") {
        return AuthFailure("Invalid credentials. Please try again.");
      }
      
      return null;
    } catch (e) {
      return ServerFailure();
    }
  }

  Future<Failure?> register({required String name, required String email, required String password}) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return null;
    } catch (e) {
      return ServerFailure();
    }
  }
}
