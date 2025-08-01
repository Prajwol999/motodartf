import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motofix_app/app/service_locator/service_locator.dart';
import 'package:motofix_app/feature/notification/presentation/view/notification_screen.dart';
import 'package:motofix_app/feature/notification/presentation/view_model/notification_event.dart';
import 'package:motofix_app/feature/notification/presentation/view_model/notification_state.dart';
import 'package:motofix_app/feature/notification/presentation/view_model/notification_view_model.dart';

class NotificationIconWidget extends StatelessWidget {
  const NotificationIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<NotificationViewModel>()..add(FetchNotifications()),
      child: BlocBuilder<NotificationViewModel, NotificationState>(
        builder: (context, state) {
          int unreadCount = 0;
          if (state is NotificationLoaded) {
            unreadCount = state.notifications.where((n) => !n.read).length;
          }

          return InkWell(
            onTap: () {
              // Mark as read when tapped
              context.read<NotificationViewModel>().add(MarkNotificationsAsRead());
              
              // Navigate to the notifications screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationScreen()),
              );
            },
            borderRadius: BorderRadius.circular(50),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: 30,
                ),
                if (unreadCount > 0)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        '$unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}