import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:frontend/features/auth/view/login_screen.dart';
import 'package:frontend/core/utils/app_colors.dart';
import 'package:frontend/features/attendance/controller/attendance_controller.dart';
import 'package:frontend/core/widgets/swipe_button.dart';
import 'package:intl/intl.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final AttendanceController controller = Get.put(AttendanceController());
  
  // Example company coordinates (Nashik Road, Maharashtra)
  final LatLng companyLocation = const LatLng(19.9535, 73.8340); 
  
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // 1. Full Screen Map
          FlutterMap(
            options: MapOptions(
              initialCenter: companyLocation,
              initialZoom: 16.5,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.geopunch',
              ),
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: companyLocation,
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderColor: AppColors.primary,
                    borderStrokeWidth: 2,
                    useRadiusInMeter: true,
                    radius: 100, // 100 meters geo-fence radius
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  // Company Marker
                  Marker(
                    point: companyLocation,
                    width: 60,
                    height: 60,
                    child: const Icon(
                      Icons.location_on,
                      color: AppColors.primary,
                      size: 48,
                    ),
                  ),
                  // User Location mock marker (simulating nearby location)
                  Marker(
                    point: const LatLng(19.9538, 73.8342),
                    width: 24,
                    height: 24,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // 2. Top Bar Overlay
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.offAll(() => const LoginScreen());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.logout, color: AppColors.black),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Within Range',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // 3. Bottom Sheet Overlay
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                bottom: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Live Time Clock could be implemented here, static for now
                    Text(
                      DateFormat('hh:mm a').format(DateTime.now()),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        color: AppColors.black,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('EEEE, dd MMMM').format(DateTime.now()),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: Obx(() => _buildTimeStat(
                            'Punch In', 
                            controller.checkInTime.value != null 
                                ? DateFormat('hh:mm a').format(controller.checkInTime.value!) 
                                : '--:--', 
                            Icons.login
                          )),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.grey[200],
                        ),
                        Expanded(
                          child: Obx(() => _buildTimeStat(
                            'Punch Out', 
                            controller.checkOutTime.value != null 
                                ? DateFormat('hh:mm a').format(controller.checkOutTime.value!) 
                                : '--:--', 
                            Icons.logout
                          )),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Obx(
                      () => SwipeButton(
                        text: controller.isCheckingIn.value 
                            ? 'Processing...' 
                            : (controller.isPunchedIn.value ? 'Swipe to Punch Out' : 'Swipe to Punch In'),
                        isLoading: controller.isCheckingIn.value,
                        onSwipe: () {
                          if (controller.isPunchedIn.value) {
                            controller.checkOut();
                          } else {
                            controller.checkIn();
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: BottomNavigationBar(
              elevation: 0,
              backgroundColor: AppColors.white,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.textSecondary.withValues(alpha: 0.6),
              selectedFontSize: 12,
              unselectedFontSize: 12,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, height: 1.5),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, height: 1.5),
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  activeIcon: Icon(Icons.home_rounded, size: 26),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month_rounded),
                  activeIcon: Icon(Icons.calendar_month_rounded, size: 26),
                  label: 'Calendar',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications_rounded),
                  activeIcon: Icon(Icons.notifications_rounded, size: 26),
                  label: 'Alerts',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_rounded),
                  activeIcon: Icon(Icons.person_rounded, size: 26),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeStat(String label, String time, IconData icon) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          time,
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
