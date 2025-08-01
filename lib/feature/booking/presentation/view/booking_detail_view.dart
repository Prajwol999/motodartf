// // feature/booking/presentation/view/booking_detail_view.dart

// import 'package:flutter/material.dart';
// import '../../domain/entity/booking_entity.dart';
// import 'package:intl/intl.dart';

// class BookingDetailView extends StatelessWidget {
//   final BookingEntity booking;

//   const BookingDetailView({super.key, required this.booking});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(booking.serviceType.toString()),
//         backgroundColor: const Color(0xFF2A4759),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Card(
//           elevation: 4,
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _buildDetailRow(
//                   context,
//                   icon: Icons.motorcycle,
//                   label: 'Bike Model',
//                   value: booking.bikeModel.toString(),
//                 ),
//                 const Divider(),
//                 _buildDetailRow(
//                   context,
//                   icon: Icons.build,
//                   label: 'Service Type',
//                   value: booking.serviceType.toString(),
//                 ),
//                 const Divider(),
//                 // _buildDetailRow(
//                 //   context,
//                 //   icon: Icons.calendar_today,
//                 //   label: 'Date',
//                 //   value: DateFormat.yMMMd().format(booking?.date.day),
//                 // ),
//                 const Divider(),
//                 _buildDetailRow(
//                   context,
//                   icon: Icons.note,
//                   label: 'Notes',
//                   value: booking.notes.toString().isNotEmpty ? booking.notes.toString() : 'No notes provided.',
//                   isMultiline: true,
//                 ),
//                 const Divider(),
//                 _buildStatusChip(context, booking.status.toString()),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(BuildContext context, {required IconData icon, required String label, required String value, bool isMultiline = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
//         children: [
//           Icon(icon, color: Theme.of(context).primaryColor),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   value,
//                   style: const TextStyle(fontSize: 16),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatusChip(BuildContext context, String status) {
//     Color chipColor;
//     switch (status.toLowerCase()) {
//       case 'pending':
//         chipColor = Colors.orange;
//         break;
//       case 'confirmed':
//         chipColor = Colors.green;
//         break;
//       case 'cancelled':
//         chipColor = Colors.red;
//         break;
//       default:
//         chipColor = Colors.grey;
//     }

//     return Align(
//       alignment: Alignment.centerRight,
//       child: Chip(
//         label: Text(
//           status,
//           style: const TextStyle(color: Colors.white),
//         ),
//         backgroundColor: chipColor,
//       ),
//     );
//   }
// }

// feature/booking/presentation/view/booking_detail_view.dart

import 'package:flutter/material.dart';
import '../../domain/entity/booking_entity.dart';
import 'package:intl/intl.dart';

class BookingDetailView extends StatelessWidget {
  final BookingEntity booking;

  const BookingDetailView({super.key, required this.booking});

  // Helper method to determine color based on status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFF6B35); // Orange
      case 'confirmed':
        return const Color(0xFF238636); // Green
      case 'in_progress':
        return const Color(0xFF0969DA); // Blue
      case 'completed':
        return const Color(0xFF8B5CF6); // Purple
      case 'cancelled':
        return const Color(0xFFDA3633); // Red
      default:
        return const Color(0xFF7D8590); // Grey
    }
  }

  // Helper method to get an icon based on status
  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.schedule;
      case 'confirmed':
        return Icons.check_circle;
      case 'in_progress':
        return Icons.build_circle;
      case 'completed':
        return Icons.verified;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                color: Color(0xFFFF6B35),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Service Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF161B22),
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF161B22),
                Color(0xFF21262D),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF21262D),
                const Color(0xFF161B22),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF30363D),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              _buildDivider(),
              _buildDetailRow(
                icon: Icons.motorcycle_outlined,
                label: 'Bike Model',
                value: booking.bikeModel.toString(),
              ),
              _buildDivider(),
              _buildDetailRow(
                icon: Icons.miscellaneous_services_outlined,
                label: 'Service Type',
                value: booking.serviceType.toString(),
              ),
              _buildDivider(),
              _buildDetailRow(
                icon: Icons.calendar_today_outlined,
                label: 'Date',
                // Assuming `booking.date` is a DateTime object.
                // The previous code had `booking?.date.day` which is incorrect.
                value: DateFormat.yMMMMd().format(booking.date!.toUtc()),
              ),
              _buildDivider(),
              _buildDetailRow(
                icon: Icons.notes_outlined,
                label: 'Notes',
                value: booking.notes.toString().isNotEmpty
                    ? booking.notes.toString()
                    : 'No notes provided.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // A custom divider that matches the theme
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        height: 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              const Color(0xFF30363D),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  // A styled header section
  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                booking.serviceType.toString().toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(width: 16),
            _buildStatusBadge(context, booking.status.toString()),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          booking.bikeModel.toString(),
          style: const TextStyle(
            color: Color(0xFF7D8590),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // A widget to display each detail item with styling
  Widget _buildDetailRow(
      {required IconData icon, required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF0969DA).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF0969DA), size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF7D8590),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // The styled status badge from the BookingView
  Widget _buildStatusBadge(BuildContext context, String status) {
    final statusColor = _getStatusColor(status);
    final statusIcon = _getStatusIcon(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 16, color: statusColor),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}