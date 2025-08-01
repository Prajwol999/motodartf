import 'package:flutter/material.dart';
import 'package:motofix_app/core/common/app_colors.dart';
import 'package:motofix_app/feature/notification/presentation/widget/notification_icon_widget.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.neutralDark,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Hello, Dipendra', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                SizedBox(height: 4),
                Text('Ready for a smooth ride?', style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
              ],
            ),
          ),
          const NotificationIconWidget(),
          const SizedBox(width: 16),
          const CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(
              'https://cdn.britannica.com/35/238335-050-2CB2EB8A/Lionel-Messi-Argentina-Netherlands-World-Cup-Qatar-2022.jpg',
            ),
            backgroundColor: AppColors.statusInfo,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90); // adjusted height
}
