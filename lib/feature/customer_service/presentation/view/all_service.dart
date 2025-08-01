// lib/features/service/presentation/view/all_services_screen.dart

import 'package:flutter/material.dart';

import '../../../../core/common/app_colors.dart';
import '../../domain/entity/service_entity.dart';


class AllServicesScreen extends StatelessWidget {
  final List<ServiceEntity> services;

  const AllServicesScreen({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        title: const Text('All Services'),
        backgroundColor: AppColors.cardBackground,
        foregroundColor: AppColors.textWhite,
      ),
      body: ListView.builder(
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return ListTile(
            title: Text(service.name, style: const TextStyle(color: AppColors.textWhite)),
            subtitle: Text('Rs. ${service.price.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.accentGreen)),
            onTap: () {
              // Handle service selection
              print('${service.name} selected');
            },
          );
        },
      ),
    );
  }
}