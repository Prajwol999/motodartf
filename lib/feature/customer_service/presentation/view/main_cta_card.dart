// lib/feature/home/presentation/widgets/main_cta_card.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motofix_app/core/common/app_colors.dart'; // Adjust path

class MainCtaCard extends StatelessWidget {
  const MainCtaCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), spreadRadius: 2, blurRadius: 10)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(FontAwesomeIcons.motorcycle, color: AppColors.accentBlue, size: 28),
              SizedBox(width: 12),
              Text('Your Bike', style: TextStyle(fontSize: 18, color: AppColors.textWhite70)),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Royal Enfield Classic 350', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textWhite)),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => print('Schedule Pickup Tapped'),
              icon: const Icon(Icons.event_seat_rounded),
              label: const Text('Schedule a Pickup & Drop'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentBlue,
                foregroundColor: AppColors.textWhite,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}