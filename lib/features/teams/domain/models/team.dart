class Team {
  /// Unique identifier for the team.
  final int id;

  /// Name of the team.
  final String name;

  Team({required this.id, required this.name});

  // Для удобства сравнения команд
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Team &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;

  Team copyWith({
    int? id,
    String? name,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}