class Task {
  final String id;
  final String name;

  Task({
    required this.id,
    required this.name,
  });

  factory Task.fromJason(Map<String, dynamic> json) {
    return Task(id: json['id'], name: json['name']);
  }
}
