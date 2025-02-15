import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/vehicle.dart';

class ApiService {
  static const String baseUrl = 'https://api.example.com'; // Replace with actual API URL
  // Simulate in-memory storage for testing
  static final List<Vehicle> _vehicles = [];

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String mobileNumber,
  }) async {
    try {
      // TODO: Implement actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      return {
        'id': '123',
        'name': name,
        'email': email,
      };
    } catch (e) {
      debugPrint('Registration error in service: $e');
      throw 'Registration failed. Please try again.';
    }
  }

  Future<List<Vehicle>> getVehicles(String userId) async {
    try {
      // TODO: Implement actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Return vehicles from in-memory storage
      return _vehicles.where((v) => v.userId == userId).toList();
    } catch (e) {
      debugPrint('Get vehicles error: $e');
      throw 'Failed to load vehicles. Please try again.';
    }
  }

  Future<Vehicle> registerVehicle(String userId, Map<String, dynamic> vehicleData) async {
    try {
      // TODO: Implement actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      final vehicle = Vehicle(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        type: vehicleData['type'],
        make: vehicleData['make'],
        model: vehicleData['model'],
        color: vehicleData['color'],
        year: vehicleData['year'],
        registrationNumber: vehicleData['registrationNumber'],
        qrCode: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==', // Sample QR code
      );
      
      // Add to in-memory storage
      _vehicles.add(vehicle);
      return vehicle;
    } catch (e) {
      debugPrint('Register vehicle error: $e');
      throw 'Failed to register vehicle. Please try again.';
    }
  }

  Future<void> deleteVehicle(String vehicleId) async {
    try {
      // TODO: Implement actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Remove from in-memory storage
      _vehicles.removeWhere((v) => v.id == vehicleId);
    } catch (e) {
      debugPrint('Delete vehicle error: $e');
      throw 'Failed to delete vehicle. Please try again.';
    }
  }
}