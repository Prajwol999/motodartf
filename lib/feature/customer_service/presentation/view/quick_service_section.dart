import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:motofix_app/core/common/app_colors.dart';
// Add this import to access the CreateBookingScreen
import 'package:motofix_app/feature/booking/presentation/view/create_booking.dart';
// Add this import to access the BookingViewModel
import 'package:motofix_app/feature/booking/presentation/view_model/booking_view_model.dart';

import 'package:motofix_app/feature/customer_service/domain/entity/service_entity.dart';
import 'package:motofix_app/feature/customer_service/presentation/view/all_service.dart';
import 'package:motofix_app/feature/customer_service/presentation/view_model/service_event.dart';
import 'package:motofix_app/feature/customer_service/presentation/view_model/service_state.dart';
import 'package:motofix_app/feature/customer_service/presentation/view_model/service_view_model.dart';

class QuickServicesSection extends StatelessWidget {
  const QuickServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    // ... no changes in the build method ...
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 15),
        SizedBox(
          height: 160,
          child: BlocBuilder<ServiceViewModel, ServiceState>(
            builder: (context, state) {
              switch (state.status) {
                case ServiceStatus.loading:
                case ServiceStatus.initial:
                  return _buildServiceLoadingState();
                case ServiceStatus.failure:
                  return _buildServiceErrorState(context);
                case ServiceStatus.success:
                  if (state.services.isEmpty) {
                    return _buildEmptyServicesState();
                  }
                  final homeScreenServices = state.services.take(5).toList();
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: homeScreenServices.length,
                    itemBuilder: (context, index) => _buildServiceItem(
                      context: context,
                      service: homeScreenServices[index],
                    ),
                  );
              }
            },
          ),
        ),
      ],
    );
  }

  // ... no other changes needed in helper widgets except _onServiceTap ...

  Widget _buildHeader(BuildContext context) {
    return BlocBuilder<ServiceViewModel, ServiceState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Quick Services',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textWhite,
              ),
            ),
            if (state.status == ServiceStatus.success && state.services.isNotEmpty)
              TextButton(
                onPressed: () {
                  // This part for 'View All' remains the same and is correct.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllServicesScreen(services: state.services),
                    ),
                  );
                },
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: AppColors.accentBlue,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildServiceItem({required BuildContext context, required ServiceEntity service}) {
    return GestureDetector(
      onTap: () => _onServiceTap(context, service),
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.accentBlue.withOpacity(0.2), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppColors.accentBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Icon(_getIconForService(service.name), size: 24, color: AppColors.accentBlue),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textWhite), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(service.duration ?? 'N/A', style: const TextStyle(fontSize: 12, color: AppColors.textWhite70), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Rs. ${service.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 14, color: AppColors.accentGreen, fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.accentBlue.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                  child: const Text('Book', style: TextStyle(fontSize: 10, color: AppColors.accentBlue, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- THIS IS THE MODIFIED METHOD ---
  void _onServiceTap(BuildContext context, ServiceEntity service) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(_getIconForService(service.name), color: AppColors.accentBlue, size: 24),
            const SizedBox(width: 12),
            Expanded(child: Text(service.name, style: const TextStyle(color: AppColors.textWhite, fontSize: 18, fontWeight: FontWeight.bold))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildServiceDetailRow('Description', service.description),
            const SizedBox(height: 12),
            _buildServiceDetailRow('Duration', service.duration ?? 'N/A'),
            const SizedBox(height: 12),
            _buildServiceDetailRow('Price', 'Rs. ${service.price.toStringAsFixed(0)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close', style: TextStyle(color: AppColors.textWhite70)),
          ),
          ElevatedButton(
            // --- THIS IS THE CHANGED PART ---
            onPressed: () {
              // 1. Close the details dialog first.
              Navigator.pop(dialogContext);

              // 2. Navigate to the CreateBookingScreen.
              Navigator.push(
                context, // Use the main build context which has the providers
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    // 3. Provide the existing BookingViewModel to the new screen.
                    //    context.read<T>() finds the nearest provider of type T up the tree.
                    value: context.read<BookingViewModel>(),
                    // 4. Instantiate the booking screen, passing the selected service.
                    child: CreateBookingScreen(service: service),
                  ),
                ),
              );
            },
            // --- END OF CHANGED PART ---
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentBlue, foregroundColor: AppColors.textWhite),
            child: const Text('Book Now'),
          ),
        ],
      ),
    );
  }

  // Helper functions remain unchanged
  IconData _getIconForService(String serviceName) {
    final lowerCaseName = serviceName.toLowerCase();
    if (lowerCaseName.contains('engine')) return FontAwesomeIcons.gears;
    if (lowerCaseName.contains('chain')) return FontAwesomeIcons.link;
    if (lowerCaseName.contains('brake')) return FontAwesomeIcons.carBurst;
    if (lowerCaseName.contains('wash')) return FontAwesomeIcons.soap;
    if (lowerCaseName.contains('tire') || lowerCaseName.contains('tyre')) return FontAwesomeIcons.solidCircleDot;
    if (lowerCaseName.contains('oil')) return FontAwesomeIcons.oilCan;
    if (lowerCaseName.contains('full service') || lowerCaseName.contains('general')) return FontAwesomeIcons.motorcycle;
    if (lowerCaseName.contains('electrical')) return FontAwesomeIcons.bolt;
    if (lowerCaseName.contains('clutch')) return FontAwesomeIcons.circle;
    if (lowerCaseName.contains('suspension')) return FontAwesomeIcons.arrowsUpDown;
    return FontAwesomeIcons.wrench; // Default
  }

  Widget _buildServiceDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textWhite70, fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: AppColors.textWhite, fontSize: 16, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildServiceLoadingState() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          width: 140,
          margin: const EdgeInsets.only(right: 15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(width: 30, height: 30, decoration: BoxDecoration(color: AppColors.textWhite70.withOpacity(0.3), borderRadius: BorderRadius.circular(6))),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 80, height: 12, decoration: BoxDecoration(color: AppColors.textWhite70.withOpacity(0.3), borderRadius: BorderRadius.circular(6))),
                  const SizedBox(height: 6),
                  Container(width: 60, height: 10, decoration: BoxDecoration(color: AppColors.textWhite70.withOpacity(0.3), borderRadius: BorderRadius.circular(6))),
                ],
              ),
              Container(width: 50, height: 12, decoration: BoxDecoration(color: AppColors.accentGreen.withOpacity(0.3), borderRadius: BorderRadius.circular(6))),
            ],
          ),
        );
      },
    );
  }

  Widget _buildServiceErrorState(BuildContext context) {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(15)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(FontAwesomeIcons.triangleExclamation, color: Colors.redAccent, size: 25),
        const SizedBox(height: 12),
        const Text('Failed to load services', style: TextStyle(color: AppColors.textWhite, fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => context.read<ServiceViewModel>().add(GetAllServicesEvent()),
          child: const Text('Try Again', style: TextStyle(color: AppColors.accentBlue, fontSize: 14, fontWeight: FontWeight.w600)),
        ),
      ]),
    );
  }

  Widget _buildEmptyServicesState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(15)),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FontAwesomeIcons.wrench, color: AppColors.textWhite70, size: 32),
          SizedBox(height: 12),
          Text('No services available', style: TextStyle(color: AppColors.textWhite70, fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}