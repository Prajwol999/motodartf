import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:motofix_app/app/service_locator/service_locator.dart';
import 'package:motofix_app/feature/notification/presentation/view_model/notification_event.dart';
import 'package:motofix_app/feature/notification/presentation/view_model/notification_state.dart';
import 'package:motofix_app/feature/notification/presentation/view_model/notification_view_model.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<NotificationViewModel>()..add(FetchNotifications()),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Notifications'),
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        body: BlocBuilder<NotificationViewModel, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading || state is NotificationInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NotificationError) {
              return Center(child: Text(state.message, style: const TextStyle(color: Colors.white)));
            } else if (state is NotificationLoaded) {
              if (state.notifications.isEmpty) {
                return const Center(
                  child: Text('You have no notifications yet.', style: TextStyle(color: Colors.white70)),
                );
              }
              return ListView.builder(
                itemCount: state.notifications.length,
                itemBuilder: (context, index) {
                  final notification = state.notifications[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border(
                        left: BorderSide(
                          color: notification.read ? Colors.transparent : Colors.blueAccent,
                          width: 4,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.message,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          DateFormat('MMM d, yyyy  h:mm a').format(notification.createdAt),
                          style: const TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}