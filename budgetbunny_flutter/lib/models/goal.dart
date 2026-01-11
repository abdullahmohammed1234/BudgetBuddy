class Goal {
  final int id;
  final String name;
  final double target;
  double current;

  Goal({
    required this.id,
    required this.name,
    required this.target,
    this.current = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'target': target,
      'current': current,
    };
  }

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      name: json['name'],
      target: json['target'],
      current: json['current'],
    );
  }
}