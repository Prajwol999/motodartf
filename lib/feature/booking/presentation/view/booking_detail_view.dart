// feature/booking/presentation/view/booking_detail_view.dart

import 'package:flutter/material.dart';
import '../../domain/entity/booking_entity.dart';
import 'package:intl/intl.dart';

class BookingDetailView extends StatelessWidget {
  final BookingEntity booking;

  const BookingDetailView({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(booking.serviceType.toString()),
        backgroundColor: const Color(0xFF2A4759),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow(
                  context,
                  icon: Icons.motorcycle,
                  label: 'Bike Model',
                  value: booking.bikeModel.toString(),
                ),
                const Divider(),
                _buildDetailRow(
                  context,
                  icon: Icons.build,
                  label: 'Service Type',
                  value: booking.serviceType.toString(),
                ),
                const Divider(),
                // _buildDetailRow(
                //   context,
                //   icon: Icons.calendar_today,
                //   label: 'Date',
                //   value: DateFormat.yMMMd().format(booking?.date.day),
                // ),
                const Divider(),
                _buildDetailRow(
                  context,
                  icon: Icons.note,
                  label: 'Notes',
                  value: booking.notes.toString().isNotEmpty ? booking.notes.toString() : 'No notes provided.',
                  isMultiline: true,
                ),
                const Divider(),
                _buildStatusChip(context, booking.status.toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, {required IconData icon, required String label, required String value, bool isMultiline = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    Color chipColor;
    switch (status.toLowerCase()) {
      case 'pending':
        chipColor = Colors.orange;
        break;
      case 'confirmed':
        chipColor = Colors.green;
        break;
      case 'cancelled':
        chipColor = Colors.red;
        break;
      default:
        chipColor = Colors.grey;
    }

    return Align(
      alignment: Alignment.centerRight,
      child: Chip(
        label: Text(
          status,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: chipColor,
      ),
    );
  }
}