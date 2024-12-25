class Reading {
  int? id; // Primary Key
  int value;
  DateTime date;
  int meterId; // Foreign Key

  Reading({this.id, required this.value, required this.date, required this.meterId});

  Map<String, dynamic> toJson() => {
    'id': id,
    'value': value,
    'date': date.toIso8601String(),
    'meter_id': meterId,
  };

  static Reading fromJson(Map<String, dynamic> json) {
    return Reading(
      id: json['id'],
      value: json['value'],
      date: DateTime.parse(json['date']),
      meterId: json['meter_id'],
    );
  }
}

class Meter {
  int? id; // Primary Key
  String name;
  String number;
  int? baseline;

  Meter({this.id, required this.name, required this.number, this.baseline});

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'number': number,
    'baseline': baseline,
  };

  static Meter fromJson(Map<String, dynamic> json) {
    return Meter(
      id: json['id'],
      name: json['name'],
      number: json['number'],
      baseline: json['baseline'],
    );
  }
}
