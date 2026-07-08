import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Usecases & Repository
import '../../data/datasource/profile_local_datasource.dart';
import '../../data/repository/profile_repository_impl.dart';
import '../../domain/usecases/get_profile_data_usecase.dart';

// BLoC
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

// Common Widgets
import '../widgets/common/section_title.dart';
import '../widgets/common/preference_card.dart';
import '../widgets/common/support_card.dart';
import '../widgets/common/logout_card.dart';
import '../widgets/common/information_card.dart';

// Guest Widgets
import '../widgets/profile_guest/guest_header.dart';
import '../widgets/profile_guest/guest_benefits_card.dart';
import '../widgets/profile_guest/guest_feature_card.dart';
import '../widgets/profile_guest/guest_sync_card.dart';
import '../widgets/profile_guest/guest_activity_card.dart';

// User Widgets
import '../widgets/profile_user/user_header.dart';
import '../widgets/profile_user/membership_card.dart';
import '../widgets/profile_user/quick_action_card.dart';
import '../widgets/profile_user/reward_card.dart';
import '../widgets/profile_user/activity_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiate repository and usecases directly for standalone setup
    final localDataSource = ProfileLocalDataSourceImpl();
    final repository = ProfileRepositoryImpl(localDataSource: localDataSource);

    return BlocProvider(
      create: (_) => ProfileBloc(
        getProfileData: GetProfileData(repository),
        signInUseCase: SignInUseCase(repository),
        logoutUseCase: LogoutUseCase(repository),
        updateProfilePreferences: UpdateProfilePreferences(repository),
      )..add(const LoadProfile()),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF7FF), // surface
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        scrolledUnderElevation: 1.0,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 20.0, // title-lg
            fontWeight: FontWeight.bold,
            color: Color(0xFF1D1A25), // on-surface
          ),
        ),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF6100D6)),
                onPressed: () => Navigator.maybePop(context),
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Color(0xFF4A4456)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications screen is not implemented.')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF4A4456)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings dashboard is not implemented.')),
              );
            },
          ),
          const SizedBox(width: 8.0),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading || state is ProfileInitial) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6100D6)),
              ),
            );
          }

          if (state is ProfileError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64.0, color: Color(0xFFBA1A1A)),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Failed to load Profile',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1A25),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      state.errorMessage,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14.0,
                        color: Color(0xFF4A4456),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProfileBloc>().add(const LoadProfile());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6100D6),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is GuestProfileLoaded) {
            return RefreshIndicator(
              color: const Color(0xFF6100D6),
              onRefresh: () async {
                context.read<ProfileBloc>().add(const RefreshProfile());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16.0),
                    // 1. Guest Hero Welcome Section
                    const GuestHeader(),
                    const SizedBox(height: 32.0),
                    // 2. Unlock More benefits grid
                    const GuestBenefitsCard(),
                    const SizedBox(height: 32.0),
                    // 3. Explore without signing in
                    const GuestFeatureCard(),
                    const SizedBox(height: 32.0),
                    // 4. Saved locally details + Offline details
                    const GuestSyncCard(),
                    const SizedBox(height: 32.0),
                    // 5. Recent Activity
                    const GuestActivityCard(),
                    const SizedBox(height: 32.0),
                    // 6. Support Info Card
                    const SectionTitle(title: 'Support'),
                    const SupportCard(),
                    const SizedBox(height: 16.0),
                    // 7. Footer Version Card
                    const InformationCard(
                      versionText: 'Version 1.0.42 • Visitor App',
                      showLogoAndCallIcon: true,
                    ),
                    const SizedBox(height: 120.0), // spacer offset bottom navigation height
                  ],
                ),
              ),
            );
          }

          if (state is UserProfileLoaded) {
            final user = state.userProfile;
            return RefreshIndicator(
              color: const Color(0xFF6100D6),
              onRefresh: () async {
                context.read<ProfileBloc>().add(const RefreshProfile());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16.0),
                    // 1. Member Profile Header Card
                    UserHeader(userProfile: user),
                    const SizedBox(height: 32.0),
                    // 2. Membership QR Card
                    MembershipCard(userProfile: user),
                    const SizedBox(height: 32.0),
                    // 3. Quick Access shortcuts
                    QuickActionCard(userProfile: user),
                    const SizedBox(height: 32.0),
                    // 4. Rewards Card
                    const RewardCard(),
                    const SizedBox(height: 32.0),
                    // 5. Points Activity history Card
                    const ActivityCard(),
                    const SizedBox(height: 32.0),
                    // 6. Preferences Card
                    const SectionTitle(title: 'Preferences'),
                    PreferenceCard(
                      language: user.preferences.language,
                      pushNotificationsEnabled: user.preferences.pushNotificationsEnabled,
                      accessibility: user.preferences.accessibility,
                      onLanguageTap: () => _showLanguageSelector(context),
                      onNotificationChanged: (val) {
                        context.read<ProfileBloc>().add(
                              ToggleNotification(pushNotificationsEnabled: val),
                            );
                      },
                      onAccessibilityTap: () => _showAccessibilitySelector(context),
                    ),
                    const SizedBox(height: 32.0),
                    // 7. Support Card
                    const SectionTitle(title: 'Support'),
                    const SupportCard(),
                    const SizedBox(height: 32.0),
                    // 8. Logout Card
                    LogoutCard(
                      onTap: () {
                        context.read<ProfileBloc>().add(const LogoutPressed());
                      },
                    ),
                    const SizedBox(height: 16.0),
                    // 9. Footer Info Card
                    const InformationCard(
                      versionText: 'Version 1.0.42-Stable',
                      subtitle: 'Powered by Smart Mall Platform',
                      showLogoAndCallIcon: false,
                    ),
                    const SizedBox(height: 120.0),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showLanguageSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (diagContext) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          title: const Text(
            'Select Language',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            SimpleDialogOption(
              onPressed: () {
                context.read<ProfileBloc>().add(const ChangeLanguage(language: 'English'));
                Navigator.pop(diagContext);
              },
              child: const Text('English', style: TextStyle(fontSize: 16.0)),
            ),
            SimpleDialogOption(
              onPressed: () {
                context.read<ProfileBloc>().add(const ChangeLanguage(language: 'Español'));
                Navigator.pop(diagContext);
              },
              child: const Text('Español', style: TextStyle(fontSize: 16.0)),
            ),
            SimpleDialogOption(
              onPressed: () {
                context.read<ProfileBloc>().add(const ChangeLanguage(language: 'Français'));
                Navigator.pop(diagContext);
              },
              child: const Text('Français', style: TextStyle(fontSize: 16.0)),
            ),
            SimpleDialogOption(
              onPressed: () {
                context.read<ProfileBloc>().add(const ChangeLanguage(language: 'العربية'));
                Navigator.pop(diagContext);
              },
              child: const Text('العربية', style: TextStyle(fontSize: 16.0)),
            ),
          ],
        );
      },
    );
  }

  void _showAccessibilitySelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (diagContext) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          title: const Text(
            'Accessibility Options',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            SimpleDialogOption(
              onPressed: () {
                context.read<ProfileBloc>().add(
                      const ChangeAccessibility(accessibility: 'High Contrast'),
                    );
                Navigator.pop(diagContext);
              },
              child: const Text('High Contrast', style: TextStyle(fontSize: 16.0)),
            ),
            SimpleDialogOption(
              onPressed: () {
                context.read<ProfileBloc>().add(
                      const ChangeAccessibility(accessibility: 'Screen Reader Friendly'),
                    );
                Navigator.pop(diagContext);
              },
              child: const Text('Screen Reader Friendly', style: TextStyle(fontSize: 16.0)),
            ),
            SimpleDialogOption(
              onPressed: () {
                context.read<ProfileBloc>().add(
                      const ChangeAccessibility(accessibility: 'Standard'),
                    );
                Navigator.pop(diagContext);
              },
              child: const Text('Standard', style: TextStyle(fontSize: 16.0)),
            ),
          ],
        );
      },
    );
  }
}
