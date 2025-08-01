// lib/feature/home/presentation/widgets/recent_activity_section.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motofix_app/core/common/app_colors.dart'; // Adjust path

// Dummy data moved here to make the widget self-contained
final List<Map<String, dynamic>> _recentActivities = [
  {'id': '1', 'title': 'Full Service', 'date': '2024-07-28', 'icon': FontAwesomeIcons.motorcycle, 'status': 'Completed'},
  {'id': '2', 'title': 'Chain Lubrication', 'date': '2024-07-25', 'icon': FontAwesomeIcons.link, 'status': 'Completed'},
  {'id': '3', 'title': 'Brake Pad Check', 'date': '2024-07-20', 'icon': FontAwesomeIcons.carBurst, 'status': 'Pending Payment'},
  {'id': '4', 'title': 'Wash & Polish', 'date': '2024-07-18', 'icon': FontAwesomeIcons.soap, 'status': 'Canceled'},
];

class RecentActivitySection extends StatelessWidget {
  const RecentActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recent Activity', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textWhite)),
        const SizedBox(height: 15),
        Column(
          children: _recentActivities.map((activity) => _buildActivityItem(activity)).toList(),
        ),
      ],
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    Color statusColor;
    switch (activity['status']) {
      case 'Completed':
        statusColor = AppColors.accentGreen;
        break;
      case 'Pending Payment':
        statusColor = Colors.orangeAccent;
        break;
      case 'Canceled':
        statusColor = Colors.redAccent;
        break;
      default:
        statusColor = AppColors.textWhite70;
    }

    return GestureDetector(
      onTap: () => print('${activity['title']} tapped'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Icon(activity['icon'] as IconData?, color: AppColors.accentBlue, size: 24),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(activity['title'] ?? '', style: const TextStyle(fontSize: 16, color: AppColors.textWhite, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Text(activity['date'] ?? '', style: const TextStyle(fontSize: 13, color: AppColors.textWhite70)),
                ],
              ),
            ),
            Text(activity['status'] ?? '', style: TextStyle(fontSize: 13, color: statusColor, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}