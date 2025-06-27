abstract interface class AuthRepository {
  /// Returns a list of atsigns which are available for use on the device.
  Future<List<String>> getAvailableAtsigns();

  /// Adds an atsign to the list of available atsigns.
  Future<void> addAvailableAtsign(String atsign);

  /// Removes an atsign from the list of available atsigns.
  Future<void> removeAvailableAtsign(String atsign);

  /// Returns the last used atsign.
  Future<String?> lastUsedAtsign();

  /// Updates the last used atsign.
  Future<void> updateLastUsedAtsign(String atsign);
}
