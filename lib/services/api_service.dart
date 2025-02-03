import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String mobileNumber,
  }) async {
    try {
      debugPrint('Making registration request with data:');
      debugPrint('Name: $name');
      debugPrint('Email: $email');
      debugPrint('Mobile: $mobileNumber');
      debugPrint('Password length: ${password.length}');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/signup'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
          'mobileNumber': mobileNumber,
        }),
      );

      debugPrint('\nAPI Response:');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      final responseData = json.decode(response.body);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('\nRegistration successful:');
        debugPrint(json.encode(responseData));
        return responseData;
      } else {
        final errorMessage = responseData['message'] ?? responseData['error'] ?? 'Registration failed';
        debugPrint('\nRegistration failed:');
        debugPrint('Error: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('\nException occurred:');
      debugPrint(e.toString());
      if (e is FormatException) {
        throw Exception('Invalid server response');
      }
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}