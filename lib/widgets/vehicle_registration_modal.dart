import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VehicleRegistrationModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onRegister;

  const VehicleRegistrationModal({
    super.key,
    required this.onRegister,
  });

  @override
  State<VehicleRegistrationModal> createState() => _VehicleRegistrationModalState();
}

class _VehicleRegistrationModalState extends State<VehicleRegistrationModal> {
  final _formKey = GlobalKey<FormState>();
  String _selectedType = '4-wheeler';
  final _registrationNumberController = TextEditingController();
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _colorController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _registrationNumberController.dispose();
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final vehicleData = {
        'type': _selectedType,
        'registrationNumber': _registrationNumberController.text.toUpperCase(),
        'make': _makeController.text,
        'model': _modelController.text,
        'year': int.parse(_yearController.text),
        'color': _colorController.text,
      };

      widget.onRegister(vehicleData);
    }
  }

  String? _validateRegistrationNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Registration number is required';
    }
    if (!RegExp(r'^[A-Z]{2}[0-9]{2}[A-Z]{1,2}[0-9]{4}$').hasMatch(value.toUpperCase())) {
      return 'Enter valid format (e.g., KA01AB1234)';
    }
    return null;
  }

  String? _validateYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'Year is required';
    }
    final year = int.tryParse(value);
    if (year == null) {
      return 'Enter a valid year';
    }
    if (year < 1900 || year > DateTime.now().year) {
      return 'Enter a valid year between 1900 and ${DateTime.now().year}';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Register Vehicle',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Vehicle Type',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.directions_car),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: '2-wheeler',
                      child: Text('2 Wheeler'),
                    ),
                    DropdownMenuItem(
                      value: '4-wheeler',
                      child: Text('4 Wheeler'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedType = value;
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select vehicle type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _registrationNumberController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    labelText: 'Registration Number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.badge),
                    hintText: 'e.g., KA01AB1234',
                  ),
                  validator: _validateRegistrationNumber,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _makeController,
                  decoration: const InputDecoration(
                    labelText: 'Make',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.business),
                    hintText: 'e.g., Toyota',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Make is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _modelController,
                  decoration: const InputDecoration(
                    labelText: 'Model',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.directions_car),
                    hintText: 'e.g., Camry',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Model is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _yearController,
                  decoration: const InputDecoration(
                    labelText: 'Year',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                    hintText: 'e.g., 2023',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  validator: _validateYear,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _colorController,
                  decoration: const InputDecoration(
                    labelText: 'Color',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.palette),
                    hintText: 'e.g., Silver',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Color is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Register Vehicle'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}