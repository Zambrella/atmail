import 'package:atmail/auth/domain/auth_repository.dart';

class MockAuthRepositoryImpl implements AuthRepository {
  @override
  Future<void> addAvailableAtsign(String atsign) {
    // TODO: implement addAvailableAtsign
    throw UnimplementedError();
  }

  @override
  Future<List<String>> getAvailableAtsigns() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ['@alice', '@bob', '@charlie'];
  }

  @override
  Future<String?> lastUsedAtsign() {
    // TODO: implement lastUsedAtsign
    throw UnimplementedError();
  }

  @override
  Future<void> removeAvailableAtsign(String atsign) {
    // TODO: implement removeAvailableAtsign
    throw UnimplementedError();
  }

  @override
  Future<void> updateLastUsedAtsign(String atsign) {
    // TODO: implement updateLastUsedAtsign
    throw UnimplementedError();
  }
}
