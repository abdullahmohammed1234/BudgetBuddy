class Reminder {
  final String type;
  final String date;
  final String message;

  Reminder({
    required this.type,
    required this.date,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'date': date,
      'message': message,
    };
  }

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      type: json['type'],
      date: json['date'],
      message: json['message'],
    );
  }
}