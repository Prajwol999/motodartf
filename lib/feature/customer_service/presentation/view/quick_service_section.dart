// lib/feature/home/presentation/widgets/home_screen_content.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motofix_app/core/common/app_colors.dart';
import 'package:motofix_app/feature/booking/presentation/view/create_booking.dart';
import 'package:motofix_app/feature/booking/presentation/view_model/booking_view_model.dart';
import 'package:motofix_app/feature/customer_service/domain/entity/service_entity.dart';
import 'package:motofix_app/feature/customer_service/presentation/view/all_service.dart';
import 'package:motofix_app/feature/customer_service/presentation/view_model/service_event.dart';
import 'package:motofix_app/feature/customer_service/presentation/view_model/service_state.dart';
import 'package:motofix_app/feature/customer_service/presentation/view_model/service_view_model.dart';

/// A widget that combines the main CTA card and the quick services section.
class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          MainCtaCard(),
          SizedBox(height: 32),
          QuickServicesSection(),
        ],
      ),
    );
  }
}


// --- Main Call-to-Action Card ---
class MainCtaCard extends StatelessWidget {
  const MainCtaCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.neutralDarkGrey,
            AppColors.neutralDark,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.neutralLightGrey),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(FontAwesomeIcons.motorcycle, color: AppColors.brandPrimary, size: 28),
              SizedBox(width: 16),
              Text(
                'Your Bike',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Royal Enfield Classic 350',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          // Themed Button
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.brandPrimary, AppColors.brandDark],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.brandPrimary.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () => print('Schedule Pickup Tapped'),
              icon: const Icon(Icons.event_available_outlined, color: AppColors.textPrimary),
              label: const Text('Schedule Pickup & Drop'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: AppColors.textPrimary,
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

// --- Quick Services Section ---
class QuickServicesSection extends StatelessWidget {
  const QuickServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: BlocBuilder<ServiceViewModel, ServiceState>(
            builder: (context, state) {
              switch (state.status) {
                case ServiceStatus.loading:
                case ServiceStatus.initial:
                  return _buildServiceLoadingState();
                case ServiceStatus.failure:
                  return _buildServiceErrorState(context, state.errorMessage ?? 'Unknown error');
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

  Widget _buildHeader(BuildContext context) {
    return BlocBuilder<ServiceViewModel, ServiceState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Quick Services',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            if (state.status == ServiceStatus.success && state.services.isNotEmpty)
              TextButton(
                onPressed: () {
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
                    color: AppColors.brandPrimary,
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
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.neutralDarkGrey,
              AppColors.neutralDark,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.neutralLightGrey, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppColors.brandPrimary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(_getIconForService(service.name), size: 24, color: AppColors.brandPrimary),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(service.duration ?? 'N/A', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
            Text('Rs. ${service.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 14, color: AppColors.statusSuccess, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _onServiceTap(BuildContext context, ServiceEntity service) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.neutralDarkGrey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppColors.neutralLightGrey)),
        title: Row(
          children: [
            Icon(_getIconForService(service.name), color: AppColors.brandPrimary, size: 24),
            const SizedBox(width: 12),
            Expanded(child: Text(service.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold))),
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
            child: const Text('Close', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<BookingViewModel>(),
                    child: CreateBookingScreen(service: service),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandPrimary,
              foregroundColor: AppColors.textPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Book Now'),
          ),
        ],
      ),
    );
  }

  IconData _getIconForService(String serviceName) {
    final lowerCaseName = serviceName.toLowerCase();
    if (lowerCaseName.contains('engine')) return FontAwesomeIcons.gears;
    if (lowerCaseName.contains('chain')) return FontAwesomeIcons.link;
    if (lowerCaseName.contains('brake')) return FontAwesomeIcons.carBurst;
    if (lowerCaseName.contains('wash')) return FontAwesomeIcons.soap;
    if (lowerCaseName.contains('tire') || lowerCaseName.contains('tyre')) return FontAwesomeIcons.solidCircleDot;
    if (lowerCaseName.contains('oil')) return FontAwesomeIcons.oilCan;
    if (lowerCaseName.contains('full') || lowerCaseName.contains('general')) return FontAwesomeIcons.motorcycle;
    if (lowerCaseName.contains('electrical')) return FontAwesomeIcons.bolt;
    if (lowerCaseName.contains('clutch')) return FontAwesomeIcons.circle;
    if (lowerCaseName.contains('suspension')) return FontAwesomeIcons.arrowsUpDown;
    return FontAwesomeIcons.wrench;
  }

  Widget _buildServiceDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16)),
      ],
    );
  }

  Widget _buildServiceLoadingState() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          width: 140,
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.neutralDark,
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }

  Widget _buildServiceErrorState(BuildContext context, String error) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.neutralDark, borderRadius: BorderRadius.circular(15)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(FontAwesomeIcons.triangleExclamation, color: AppColors.statusError, size: 25),
        const SizedBox(height: 12),
        Text('Failed to load services', style: const TextStyle(color: AppColors.textPrimary, fontSize: 16)),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => context.read<ServiceViewModel>().add(GetAllServicesEvent()),
          child: const Text('Try Again', style: TextStyle(color: AppColors.brandPrimary, fontWeight: FontWeight.w600)),
        ),
      ]),
    );
  }

  Widget _buildEmptyServicesState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.neutralDark, borderRadius: BorderRadius.circular(15)),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.wrench, color: AppColors.textSecondary, size: 32),
            SizedBox(height: 12),
            Text('No services available', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
