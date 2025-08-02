// import 'package:flutter/material.dart';
// import 'package:motofix_app/core/common/app_colors.dart';
// import '../../domain/entity/service_entity.dart';

// class AllServicesScreen extends StatelessWidget {
//   final List<ServiceEntity> services;

//   const AllServicesScreen({super.key, required this.services});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.neutralBlack,
//       appBar: AppBar(
//         backgroundColor: AppColors.neutralDark,
//         elevation: 0,
//         automaticallyImplyLeading: true,
//         iconTheme: const IconThemeData(color: AppColors.textPrimary),
//         title: const Text(
//           'All Services',
//           style: TextStyle(
//             color: AppColors.textPrimary,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [AppColors.neutralBlack, AppColors.neutralDark],
//           ),
//         ),
//         child: services.isEmpty
//             ? _buildEmptyState()
//             : ListView.builder(
//                 padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//                 itemCount: services.length,
//                 itemBuilder: (context, index) {
//                   final service = services[index];
//                   return _buildServiceCard(context, service);
//                 },
//               ),
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(32),
//             decoration: BoxDecoration(
//               color: AppColors.neutralDarkGrey.withOpacity(0.5),
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(color: AppColors.neutralLightGrey, width: 1),
//             ),
//             child: const Icon(Icons.settings_outlined, size: 64, color: AppColors.textSecondary),
//           ),
//           const SizedBox(height: 24),
//           const Text(
//             'No Services Available',
//             style: TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 12),
//           const Text(
//             'Services offered will appear here once they are added.',
//             textAlign: TextAlign.center,
//             style: TextStyle(color: AppColors.textSecondary, fontSize: 16, height: 1.5),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildServiceCard(BuildContext context, ServiceEntity service) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [AppColors.neutralDarkGrey, AppColors.neutralDark],
//         ),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppColors.neutralLightGrey, width: 1),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 15,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(16),
//           onTap: () {
//             ScaffoldMessenger.of(context)
//               ..hideCurrentSnackBar()
//               ..showSnackBar(SnackBar(
//                 content: Text('${service.name} selected.'),
//                 backgroundColor: AppColors.statusInfo,
//                 behavior: SnackBarBehavior.floating,
//               ));
//           },
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: AppColors.brandPrimary.withOpacity(0.15),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: const Icon(Icons.build_circle_outlined, color: AppColors.brandPrimary, size: 24),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(service.name,
//                           style: const TextStyle(
//                               color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 6),
//                       Text('Rs. ${service.price.toStringAsFixed(0)}',
//                           style: const TextStyle(
//                               color: AppColors.statusSuccess, fontSize: 14, fontWeight: FontWeight.w600)),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textSecondary, size: 18),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }





// lib/feature/customer_service/presentation/view/all_service.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motofix_app/core/common/app_colors.dart';
import 'package:motofix_app/feature/booking/presentation/view/create_booking.dart';
import 'package:motofix_app/feature/booking/presentation/view_model/booking_view_model.dart';
import 'package:motofix_app/feature/customer_service/domain/entity/service_entity.dart';

class AllServicesScreen extends StatelessWidget {
  final List<ServiceEntity> services;

  const AllServicesScreen({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralBlack,
      appBar: AppBar(
        backgroundColor: AppColors.neutralDark,
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: const Text(
          'All Services',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.neutralBlack, AppColors.neutralDark],
          ),
        ),
        child: services.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return _buildServiceCard(context, service);
                },
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.neutralDarkGrey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.neutralLightGrey, width: 1),
            ),
            child: const Icon(Icons.settings_outlined,
                size: 64, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Services Available',
            style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'Services will appear here once they are added.',
            textAlign: TextAlign.center,
            style:
                TextStyle(color: AppColors.textSecondary, fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, ServiceEntity service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.neutralDarkGrey, AppColors.neutralDark],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neutralLightGrey, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _onServiceTap(context, service),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.brandPrimary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(_getIconForService(service.name),
                      color: AppColors.brandPrimary, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(service.name,
                          style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text('Rs. ${service.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                              color: AppColors.statusSuccess,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.arrow_forward_ios_rounded,
                    color: AppColors.textSecondary, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onServiceTap(BuildContext context, ServiceEntity service) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.neutralDarkGrey,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.neutralLightGrey)),
        title: Row(
          children: [
            Icon(_getIconForService(service.name),
                color: AppColors.brandPrimary, size: 24),
            const SizedBox(width: 12),
            Expanded(
                child: Text(service.name,
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold))),
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
            _buildServiceDetailRow(
                'Price', 'Rs. ${service.price.toStringAsFixed(0)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close',
                style: TextStyle(color: AppColors.textSecondary)),
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
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
    if (lowerCaseName.contains('tire') || lowerCaseName.contains('tyre'))
      return FontAwesomeIcons.solidCircleDot;
    if (lowerCaseName.contains('oil')) return FontAwesomeIcons.oilCan;
    if (lowerCaseName.contains('full') || lowerCaseName.contains('general'))
      return FontAwesomeIcons.motorcycle;
    return FontAwesomeIcons.wrench;
  }

  Widget _buildServiceDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 16)),
      ],
    );
  }
}