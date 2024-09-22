///
/// Represents current authenticated user
/// - Refers to the table Customer
class AppUser {
  final String id;
  final String name;
  ///
  /// Creates new AppUser insatance
  AppUser({
    required this.id,
    required this.name,
  });
}