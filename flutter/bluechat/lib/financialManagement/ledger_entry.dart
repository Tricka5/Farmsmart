class LedgerEntry {
  final int id;
  final String type;
  final String description;
  final double amount;  // Changed to double to handle decimal values (e.g., for currency)
  final String date;

  // Constructor to initialize the fields
  LedgerEntry({
    required this.id,
    required this.type,
    required this.description,
    required this.amount,
    required this.date,
  });

  // Factory constructor to create LedgerEntry object from JSON
  factory LedgerEntry.fromJson(Map<String, dynamic> json) {
    return LedgerEntry(
      id: json['id'] ?? 0,  // Default to 0 if 'id' is missing
      type: json['type'] ?? 'unknown',  // Default type to 'unknown' if missing
      description: json['description'] ?? '',  // Default to empty string if description is missing
      amount: (json['amount'] != null)
          ? double.tryParse(json['amount'].toString()) ?? 0.0  // Parse 'amount' safely, default to 0.0
          : 0.0,
      date: json['date'] ?? '',  // Default to empty string if 'date' is missing
    );
  }

  // Optionally override equality and hashCode if you want to compare LedgerEntry objects
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LedgerEntry &&
        other.id == id &&
        other.type == type &&
        other.description == description &&
        other.amount == amount &&
        other.date == date;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    type.hashCode ^
    description.hashCode ^
    amount.hashCode ^
    date.hashCode;
  }

  // Optionally, a toJson method to convert LedgerEntry to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'description': description,
      'amount': amount,
      'date': date,
    };
  }
}
