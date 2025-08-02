// feature/booking/presentation/view/booking_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/service_locator/service_locator.dart';
import '../../domain/entity/booking_entity.dart';
import '../view_model/booking_event.dart';
import '../view_model/booking_view_model.dart';
import '../view_model/booking_state.dart';
import 'booking_detail_view.dart'; // Import the new detail view

class BookingView extends StatefulWidget {
  const BookingView({super.key});

  @override
  State<BookingView> createState() => _BookingViewState();
}

class _BookingViewState extends State<BookingView> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    final bookingViewModel = context.read<BookingViewModel>();
    if (bookingViewModel.state is BookingInitial) {
      bookingViewModel.add(LoadUserBookingsEvent());
    }
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFF6B35);
      case 'confirmed':
        return const Color(0xFF238636);
      case 'in_progress':
        return const Color(0xFF0969DA);
      case 'completed':
        return const Color(0xFF8B5CF6);
      case 'cancelled':
        return const Color(0xFFDA3633);
      default:
        return const Color(0xFF7D8590);
    }
  }

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
                Icons.assignment,
                color: Color(0xFFFF6B35),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Service History',
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D1117),
              Color(0xFF161B22),
            ],
          ),
        ),
        child: BlocConsumer<BookingViewModel, BookingState>(
          listener: (context, state) {
            if (state is BookingLoadSuccess && state.successMessage != null) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              state.successMessage!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    backgroundColor: const Color(0xFF238636),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(16),
                  ),
                );
            } else if (state is BookingFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.error_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              state.message,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    backgroundColor: const Color(0xFFDA3633),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(16),
                  ),
                );
            }
          },
          buildWhen: (previous, current) => current is! BookingActionSuccess,
          builder: (context, state) {
            if (state is BookingLoading || state is BookingInitial) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF21262D),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF30363D),
                          width: 1,
                        ),
                      ),
                      child: const CircularProgressIndicator(
                        color: Color(0xFFFF6B35),
                        strokeWidth: 3,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Loading service records...',
                      style: TextStyle(
                        color: Color(0xFF7D8590),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }
            
            if (state is BookingLoadSuccess) {
              if (state.bookings.isEmpty) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: const Color(0xFF21262D).withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF30363D),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.assignment_outlined,
                            size: 64,
                            color: Color(0xFF7D8590),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'No Service Records',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Your service history will appear here\nonce you book your first service.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF7D8590),
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              
              return FadeTransition(
                opacity: _fadeAnimation,
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<BookingViewModel>().add(LoadUserBookingsEvent());
                  },
                  color: const Color(0xFFFF6B35),
                  backgroundColor: const Color(0xFF21262D),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    itemCount: state.bookings.length,
                    itemBuilder: (context, index) {
                      final booking = state.bookings[index];
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 200 + (index * 100)),
                        curve: Curves.easeOutCubic,
                        child: _buildBookingItem(context, booking, index),
                      );
                    },
                  ),
                ),
              );
            }
            
            if (state is BookingFailure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: const Color(0xFF21262D).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFDA3633).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Color(0xFFDA3633),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Connection Error',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Failed to load service records:\n${state.message}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF7D8590),
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFFF6B35),
                              const Color(0xFFE55A2B),
                            ],
                          ),
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context
                                .read<BookingViewModel>()
                                .add(LoadUserBookingsEvent());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(
                            Icons.refresh,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Try Again',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            
            return const Center(
              child: Text(
                "An unknown error occurred.",
                style: TextStyle(
                  color: Color(0xFF7D8590),
                  fontSize: 16,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBookingItem(BuildContext context, BookingEntity booking, int index) {
    final statusColor = _getStatusColor(booking.status.toString());
    final statusIcon = _getStatusIcon(booking.status.toString());
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookingDetailView(booking: booking , bookingId: booking.id.toString(),),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B35).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.build,
                        color: Color(0xFFFF6B35),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.serviceType.toString().toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            booking.bikeModel.toString(),
                            style: const TextStyle(
                              color: Color(0xFF7D8590),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
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
                          Icon(
                            statusIcon,
                            size: 16,
                            color: statusColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            booking.status.toString(),
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Divider
                Container(
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
                
                const SizedBox(height: 20),
                
                // Action Row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0969DA).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF0969DA).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.visibility,
                              size: 16,
                              color: Color(0xFF0969DA),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'VIEW DETAILS',
                              style: TextStyle(
                                color: Color(0xFF0969DA),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFDA3633).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFDA3633).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        onPressed: () => _showDeleteDialog(context, booking),
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Color(0xFFDA3633),
                          size: 20,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 44,
                          minHeight: 44,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, BookingEntity booking) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF21262D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: Color(0xFF30363D),
            width: 1,
          ),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFDA3633),
              size: 24,
            ),
            SizedBox(width: 12),
            Text(
              'Delete Service Record',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to permanently delete this service record? This action cannot be undone.',
          style: TextStyle(
            color: const Color(0xFF7D8590),
            fontSize: 16,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Color(0xFF7D8590),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFDA3633),
                  const Color(0xFFB91C1C),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton(
              onPressed: () {
                context
                    .read<BookingViewModel>()
                    .add(DeleteBookingEvent(bookingId: booking.id.toString()));
                Navigator.of(dialogContext).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}