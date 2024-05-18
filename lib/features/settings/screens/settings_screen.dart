import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_snappyshop/features/settings/providers/notification_provider.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(notificationProvider.notifier).getNotificationsEnabled();
    });
  }

  @override
  Widget build(BuildContext context) {
    final notificationState = ref.watch(notificationProvider);
    final darkMode = ref.watch(darkModeProvider);

    return Layout1(
      title: 'Settings',
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(
                top: 48,
                right: 24,
                left: 24,
                bottom: 24,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: darkMode
                              ? AppColors.white
                              : AppColors.textCoolBlack,
                          height: 1.1,
                          leadingDistribution: TextLeadingDistribution.even,
                        ),
                      ),
                      const Spacer(),
                      CupertinoSwitch(
                        value: notificationState.notificationsEnabled,
                        onChanged: (value) {
                          ref
                              .read(notificationProvider.notifier)
                              .toggleNotificationsEnabled();
                        },
                        activeColor: AppColors.primaryPearlAqua,
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
