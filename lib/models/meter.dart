class Reading {
  int value;
  DateTime date;

  Reading({required this.value, required this.date});

  Map<String, dynamic> toJson() => {
        'value': value,
        'date': date.toIso8601String(),
      };

  static Reading fromJson(Map<String, dynamic> json) {
    return Reading(
      value: json['value'],
      date: DateTime.parse(json['date']),
    );
  }
}

class Meter {
  String name;
  String number;
  List<Reading> readings;
  int? baseline;

  // Ensure readings is initialized as an empty list
  Meter({required this.name, required this.number, this.readings = const [], this.baseline});

  Map<String, dynamic> toJson() => {
        'name': name,
        'number': number,
        'readings': readings.map((reading) => reading.toJson()).toList(),
        'baseline': baseline,
      };

  static Meter fromJson(Map<String, dynamic> json) {
    return Meter(
      name: json['name'],
      number: json['number'],
      readings: (json['readings'] as List).map((reading) => Reading.fromJson(reading)).toList(),
      baseline: json['baseline'],
    );
  }
}
