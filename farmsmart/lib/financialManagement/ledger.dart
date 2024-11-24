class Ledger {
  final int id;
  final String transactor;
  final String itemname;
  final String type;
  final String date;

  Ledger({
    required this.id,
    required this.transactor,
    required this.itemname,
    required this.type,
    required this.date,
  });

  // Factory constructor to create Ledger object from JSON
  factory Ledger.fromJson(Map<String, dynamic> json) {
    return Ledger(
      id: json['ledgerAccountid'],
      transactor: json['transactor'],
      itemname: json['itemname'],
      type: json['type'],
      date: json['date'],
    );
  }
}
