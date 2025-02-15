class Vehicle {
  final String id;
  final String userId;
  final String type;
  final String make;
  final String model;
  final String color;
  final int year;
  final String registrationNumber;
  final String? qrCode;

  Vehicle({
    required this.id,
    required this.userId,
    required this.type,
    required this.make,
    required this.model,
    required this.color,
    required this.year,
    required this.registrationNumber,
    this.qrCode,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: json['type'] as String,
      make: json['make'] as String,
      model: json['model'] as String,
      color: json['color'] as String,
      year: json['year'] as int,
      registrationNumber: json['registrationNumber'] as String,
      qrCode: json['qrCode'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'make': make,
      'model': model,
      'color': color,
      'year': year,
      'registrationNumber': registrationNumber,
      if (qrCode != null) 'qrCode': qrCode,
    };
  }
}