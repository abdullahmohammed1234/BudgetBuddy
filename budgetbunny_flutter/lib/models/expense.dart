class Expense {
  final double amount;
  final String category;
  final String date;
  final String notes;

  Expense({
    required this.amount,
    required this.category,
    required this.date,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'category': category,
      'date': date,
      'notes': notes,
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      amount: json['amount'],
      category: json['category'],
      date: json['date'],
      notes: json['notes'],
    );
  }
}