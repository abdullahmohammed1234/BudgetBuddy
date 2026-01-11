class Category {
  final String name;
  final double amount;

  Category({
    required this.name,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'],
      amount: json['amount'],
    );
  }
}

class Budget {
  final double income;
  final List<Category> categories;
  final List<String> labels;
  final List<double> data;

  Budget({
    required this.income,
    required this.categories,
    required this.labels,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'income': income,
      'categories': categories.map((c) => c.toJson()).toList(),
      'labels': labels,
      'data': data,
    };
  }

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      income: json['income'],
      categories: (json['categories'] as List)
          .map((c) => Category.fromJson(c))
          .toList(),
      labels: List<String>.from(json['labels']),
      data: List<double>.from(json['data']),
    );
  }
}