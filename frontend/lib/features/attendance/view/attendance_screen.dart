import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/features/auth/view/login_screen.dart';
import 'package:frontend/core/utils/app_colors.dart';
import 'package:frontend/features/attendance/controller/attendance_controller.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject the controller
    final AttendanceController controller = Get.put(AttendanceController());

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: Container(
        height: 64,
        width: 64,
        margin: const EdgeInsets.only(top: 30),
        child: FloatingActionButton(
          backgroundColor: AppColors.black,
          elevation: 4,
          shape: const CircleBorder(),
          onPressed: () {},
          child: const Icon(Icons.add, color: AppColors.white, size: 32),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 12,
        color: AppColors.white,
        elevation: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home_filled, color: AppColors.primary, size: 28),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.search, color: AppColors.textSecondary, size: 28),
                onPressed: () {},
              ),
              const SizedBox(width: 48), // Space for FAB
              IconButton(
                icon: const Icon(Icons.calendar_month_outlined, color: AppColors.textSecondary, size: 28),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.person_outline, color: AppColors.textSecondary, size: 28),
                onPressed: () {
                  // For testing, let's keep the logout functionality on the profile icon
                  Get.offAll(() => const LoginScreen());
                },
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header
              Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.primaryLight,
                    child: Icon(Icons.person, color: AppColors.primary, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome,',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const Text(
                        'Priya R.',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Within Geo-fence - Ready to Punch',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              
              // Pulse Button Section
              Center(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 220,
                          height: 220,
                          child: CircularProgressIndicator(
                            value: 0.65,
                            strokeWidth: 16,
                            backgroundColor: AppColors.primaryLight,
                            color: AppColors.primary,
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (!controller.isCheckingIn.value) {
                              controller.checkIn();
                            }
                          },
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 24,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Obx(() => controller.isCheckingIn.value
                                  ? const CircularProgressIndicator(color: AppColors.white)
                                  : const Text(
                                      'Pulse',
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                      ),
                                    )),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      '4h 24m',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Text(
                      '8h 00m Shift',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 36),
              
              // Stats Cards Row
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.schedule,
                      title: 'Daily Status',
                      mainValue: '04:24 AM',
                      subValue: 'Break: 30m',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.cardShadow,
                            blurRadius: 16,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.textSecondary),
                              SizedBox(width: 6),
                              Text(
                                'Shift Plan',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            '09:00 - 17:30',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Mon - Fri',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _buildBar(0.4),
                              _buildBar(0.7),
                              _buildBar(1.0),
                              _buildBar(0.8),
                              _buildBar(0.5),
                              _buildBar(0.3, isLight: true),
                              _buildBar(0.3, isLight: true),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 36),
              
              // Recent Activity Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Recent Activity',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Last 5 punches',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Activity List
              _buildActivityItem(
                isPunchIn: true,
                time: '08:32',
                location: 'Main Gate - Auto',
                date: 'Today',
              ),
              const SizedBox(height: 12),
              _buildActivityItem(
                isPunchIn: false,
                time: '17:30',
                location: 'HQ - Auto',
                date: 'Yesterday',
              ),
              const SizedBox(height: 40), // Extra space for bottom nav
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({required IconData icon, required String title, required String mainValue, required String subValue}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            mainValue,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subValue,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(double heightFactor, {bool isLight = false}) {
    return Container(
      width: 8,
      height: 24 * heightFactor,
      decoration: BoxDecoration(
        color: isLight ? AppColors.primaryLight : AppColors.primary,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildActivityItem({required bool isPunchIn, required String time, required String location, required String date}) {
    final Color iconColor = isPunchIn ? AppColors.primary : const Color(0xFFF59E0B);
    final Color bgColor = isPunchIn ? AppColors.primaryLight : const Color(0xFFFEF3C7);
    final IconData icon = isPunchIn ? Icons.login_rounded : Icons.logout_rounded;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Punch ${isPunchIn ? 'In' : 'Out'} - $time',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  location,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Text(
            date,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
