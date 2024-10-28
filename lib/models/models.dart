import 'package:cloud_firestore/cloud_firestore.dart';

class CarOperatorModel {
  final String id; // Unique Firestore document ID
  final String fullName;
  final String phoneNumber;
  final String? areaOfOperation;
  final String? vehicleImageUrl;
  final String? driverImageUrl;

  CarOperatorModel({
    required this.id, // ID is required
    required this.fullName,
    required this.phoneNumber,
    this.areaOfOperation,
    this.vehicleImageUrl,
    this.driverImageUrl,
  });

  // Convert the instance to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Include id in toMap
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'areaOfOperation': areaOfOperation,
      'vehicleImageUrl': vehicleImageUrl,
      'driverImageUrl': driverImageUrl,
    };
  }

  // Static method to create an instance from a map
  static CarOperatorModel fromMap(Map<String, dynamic> data, String id) {
    return CarOperatorModel(
      id: id, // Set the Firestore document ID
      fullName: data['fullName'] ?? '', // Provide defaults where necessary
      phoneNumber: data['phoneNumber'] ?? '',
      areaOfOperation: data['areaOfOperation'],
      vehicleImageUrl: data['vehicleImageUrl'],
      driverImageUrl: data['driverImageUrl'],
    );
  }
}

class LorryOperatorModel {
  final String fullName;
  final String phoneNumber;
  final String areaOfOperation;
  final String? vehicleImageUrl;
  final String? driverImageUrl;

  LorryOperatorModel({
    required this.fullName,
    required this.phoneNumber,
    required this.areaOfOperation,
    this.vehicleImageUrl,
    this.driverImageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'areaOfOperation': areaOfOperation,
      'vehicleImageUrl': vehicleImageUrl,
      'driverImageUrl': driverImageUrl,
    };
  }

  factory LorryOperatorModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return LorryOperatorModel(
      fullName: data['fullName'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      areaOfOperation: data['areaOfOperation'] ?? '',
      vehicleImageUrl: data['vehicleImageUrl'],
      driverImageUrl: data['driverImageUrl'],
    );
  }
}

class MechanicOperatorModel {
  String fullName;
  String phoneNumber;
  String areaOfOperation;
  String? garageImageUrl;

  MechanicOperatorModel({
    required this.fullName,
    required this.phoneNumber,
    required this.areaOfOperation,
    this.garageImageUrl,
  });

  factory MechanicOperatorModel.fromMap(Map<String, dynamic> data) {
    return MechanicOperatorModel(
      fullName: data['fullName'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      areaOfOperation: data['areaOfOperation'] ?? '',
      garageImageUrl: data['garageImageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'areaOfOperation': areaOfOperation,
      'garageImageUrl': garageImageUrl,
    };
  }

  static MechanicOperatorModel fromFirestore(
      QueryDocumentSnapshot<Object?> doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MechanicOperatorModel.fromMap(data);
  }
}

class MotorbikeOperatorModel {
  final String fullName;
  final String phoneNumber;
  final String? areaOfOperation; // Added areaOfOperation
  final String? motorbikeImageUrl;
  final String? driverImageUrl;

  MotorbikeOperatorModel({
    required this.fullName,
    required this.phoneNumber,
    this.areaOfOperation, // Added areaOfOperation
    this.motorbikeImageUrl,
    this.driverImageUrl,
  });

  factory MotorbikeOperatorModel.fromMap(Map<String, dynamic> map) {
    return MotorbikeOperatorModel(
      fullName: map['fullName'],
      phoneNumber: map['phoneNumber'],
      areaOfOperation: map['areaOfOperation'], // Added areaOfOperation
      motorbikeImageUrl: map['motorbikeImageUrl'],
      driverImageUrl: map['driverImageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'areaOfOperation': areaOfOperation, // Added areaOfOperation
      'motorbikeImageUrl': motorbikeImageUrl,
      'driverImageUrl': driverImageUrl,
    };
  }
}

class PickupOperatorModel {
  final String fullName;
  final String phoneNumber;
  final String areaOfOperation;
  final String? vehicleImageUrl;
  final String? driverImageUrl;

  PickupOperatorModel({
    required this.fullName,
    required this.phoneNumber,
    required this.areaOfOperation,
    this.vehicleImageUrl,
    this.driverImageUrl,
  });

  factory PickupOperatorModel.fromMap(Map<String, dynamic> map) {
    return PickupOperatorModel(
      fullName: map['fullName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      areaOfOperation: map['areaOfOperation'] ?? '',
      vehicleImageUrl: map['vehicleImageUrl'],
      driverImageUrl: map['driverImageUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'areaOfOperation': areaOfOperation,
      'vehicleImageUrl': vehicleImageUrl,
      'driverImageUrl': driverImageUrl,
    };
  }
}

class TractorOperatorModel {
  final String fullName;
  final String phoneNumber;
  final String areaOfOperation;
  final String vehicleNumber;
  final String plate;
  final String? vehicleImageUrl;
  final String? driverImageUrl;

  TractorOperatorModel({
    required this.fullName,
    required this.phoneNumber,
    required this.areaOfOperation,
    required this.vehicleNumber,
    required this.plate,
    this.vehicleImageUrl,
    this.driverImageUrl,
  });

  factory TractorOperatorModel.fromMap(Map<String, dynamic> map) {
    return TractorOperatorModel(
      fullName: map['fullName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      areaOfOperation: map['areaOfOperation'] ?? '',
      vehicleNumber: map['vehicleNumber'] ?? '',
      plate: map['plate'] ?? '',
      vehicleImageUrl: map['vehicleImageUrl'],
      driverImageUrl: map['driverImageUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'areaOfOperation': areaOfOperation,
      'vehicleNumber': vehicleNumber,
      'plate': plate,
      'vehicleImageUrl': vehicleImageUrl,
      'driverImageUrl': driverImageUrl,
    };
  }
}

class TaxiOperatorModel {
  final String fullName;
  final String phoneNumber;
  final String? areaOfOperation;
  final String? vehicleImageUrl;
  final String? driverImageUrl;

  TaxiOperatorModel({
    required this.fullName,
    required this.phoneNumber,
    this.areaOfOperation,
    this.vehicleImageUrl,
    this.driverImageUrl,
  });

  // Factory method to create an instance from a map
  factory TaxiOperatorModel.fromMap(Map<String, dynamic> map) {
    return TaxiOperatorModel(
      fullName: map['fullName'],
      phoneNumber: map['phoneNumber'],
      areaOfOperation: map['areaOfOperation'],
      vehicleImageUrl: map['vehicleImageUrl'],
      driverImageUrl: map['driverImageUrl'],
    );
  }

  // Method to convert the instance to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'areaOfOperation': areaOfOperation,
      'vehicleImageUrl': vehicleImageUrl,
      'driverImageUrl': driverImageUrl,
    };
  }
}

class PsvOperatorModel {
  final String fullName;
  final String phoneNumber;
  final String? areaOfOperation;
  final String? vehicleImageUrl;
  final String? driverImageUrl;

  PsvOperatorModel({
    required this.fullName,
    required this.phoneNumber,
    this.areaOfOperation,
    this.vehicleImageUrl,
    this.driverImageUrl,
  });

  // Factory method to create an instance from a map
  factory PsvOperatorModel.fromMap(Map<String, dynamic> map) {
    return PsvOperatorModel(
      fullName: map['fullName'],
      phoneNumber: map['phoneNumber'],
      areaOfOperation: map['areaOfOperation'],
      vehicleImageUrl: map['vehicleImageUrl'],
      driverImageUrl: map['driverImageUrl'],
    );
  }

  // Method to convert the instance to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'areaOfOperation': areaOfOperation,
      'vehicleImageUrl': vehicleImageUrl,
      'driverImageUrl': driverImageUrl,
    };
  }
}

// message_model.dart
class Message {
  String senderId;
  String messageText;
  DateTime timestamp;

  Message({
    required this.senderId,
    required this.messageText,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'messageText': messageText,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  static Message fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'],
      messageText: map['messageText'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
