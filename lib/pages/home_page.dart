import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_header.dart';
import '../widgets/sidebar_navigation.dart';
import '../widgets/vehicle_registration_modal.dart';
import '../providers/user_provider.dart';
import '../models/vehicle.dart';
import '../services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ApiService _apiService = ApiService();
  List<Vehicle> _vehicles = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadVehicles();
      }
    });
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _closeDrawer() {
    Navigator.of(context).pop();
  }

  Future<void> _loadVehicles() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final userId = context.read<UserProvider>().username ?? '';
      final vehicles = await _apiService.getVehicles(userId);
      if (!mounted) return;
      
      setState(() {
        _vehicles = vehicles;
      });
    } catch (e) {
      if (!mounted) return;
      _showError('Failed to load vehicles');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showVehicleRegistrationModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => VehicleRegistrationModal(
        onRegister: (vehicleData) async {
          try {
            final userId = context.read<UserProvider>().username ?? '';
            await _apiService.registerVehicle(userId, vehicleData);
            
            if (!mounted) return;
            Navigator.pop(context);
            _showSuccess('Vehicle registered successfully');
            _loadVehicles();
          } catch (e) {
            if (!mounted) return;
            _showError('Failed to register vehicle');
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  Future<void> _deleteVehicle(String vehicleId) async {
    try {
      await _apiService.deleteVehicle(vehicleId);
      if (!mounted) return;
      _showSuccess('Vehicle deleted successfully');
      _loadVehicles();
    } catch (e) {
      if (!mounted) return;
      _showError('Failed to delete vehicle');
    }
  }

  Widget _buildVehicleCard(Vehicle vehicle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  vehicle.type == '2-wheeler' 
                      ? Icons.motorcycle 
                      : Icons.directions_car,
                  size: 32,
                  color: Colors.blue,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${vehicle.make} ${vehicle.model}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        vehicle.registrationNumber,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.red,
                  onPressed: () => _showDeleteConfirmation(vehicle),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.palette_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      vehicle.color,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Text(
                  'Year: ${vehicle.year}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            if (vehicle.qrCode != null) ...[
              const Divider(height: 24),
              Center(
                child: Image.memory(
                  Uri.parse(vehicle.qrCode!).data!.contentAsBytes(),
                  height: 100,
                  width: 100,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Vehicle vehicle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Vehicle'),
        content: Text(
          'Are you sure you want to delete ${vehicle.make} ${vehicle.model} (${vehicle.registrationNumber})?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteVehicle(vehicle.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomHeader(
        onMenuPressed: _openDrawer,
      ),
      drawer: SidebarNavigation(
        onClose: _closeDrawer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${context.select((UserProvider p) => p.username ?? "User")}!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Vehicles',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _showVehicleRegistrationModal,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Vehicle'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _vehicles.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.directions_car_outlined,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No vehicles registered yet',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Click the "Add Vehicle" button to register your first vehicle',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: _vehicles.length,
                          itemBuilder: (context, index) => _buildVehicleCard(_vehicles[index]),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}