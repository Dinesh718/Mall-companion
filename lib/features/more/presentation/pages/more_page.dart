import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/more_bloc.dart';
import '../bloc/more_event.dart';
import '../bloc/more_state.dart';
import '../widgets/more_header.dart';
import '../widgets/more_profile_card.dart';
import '../widgets/more_shortcut_card.dart';
import '../widgets/more_menu_tile.dart';
import '../widgets/more_menu_section.dart';
import '../widgets/settings_tile.dart';
import '../widgets/theme_tile.dart';
import '../widgets/language_selector.dart';
import '../widgets/feedback_card.dart';
import '../widgets/logout_dialog.dart';
import '../widgets/section_title.dart';
import 'parking_details_page.dart';
import 'amenities_details_page.dart';

import '../../data/datasource/more_local_datasource.dart';
import '../../data/repository/more_repository_impl.dart';
import '../../domain/usecases/get_more_data.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final datasource = MoreLocalDataSourceImpl();
    final repository = MoreRepositoryImpl(localDataSource: datasource);

    return BlocProvider(
      create: (_) => MoreBloc(
        getUserProfileUseCase: GetUserProfileUseCase(repository),
        getQuickActionsUseCase: GetQuickActionsUseCase(repository),
        getMallServicesUseCase: GetMallServicesUseCase(repository),
        getPopularServicesUseCase: GetPopularServicesUseCase(repository),
        getParkingFloorsUseCase: GetParkingFloorsUseCase(repository),
        getAmenitiesUseCase: GetAmenitiesUseCase(repository),
        submitFeedbackUseCase: SubmitFeedbackUseCase(repository),
      )..add(const LoadMoreData()),
      child: const _MorePageBody(),
    );
  }
}

class _MorePageBody extends StatelessWidget {
  const _MorePageBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF7FF),
      body: BlocBuilder<MoreBloc, MoreState>(
        builder: (context, state) {
          if (state is MoreLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF6100D6)),
            );
          }

          if (state is MoreDataLoaded) {
            return Column(
              children: [
                MoreHeader(
                  title: 'More',
                  avatarUrl: state.userProfile.avatarUrl,
                  onMenuTap: () {},
                  onNotificationsTap: () {},
                  onProfileTap: () {},
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<MoreBloc>().add(const RefreshMoreData());
                    },
                    color: const Color(0xFF6100D6),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 24.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Search Bar
                          TextField(
                            decoration: InputDecoration(
                              hintText:
                                  'Search services, facilities or info...',
                              hintStyle: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 14.0,
                                color: Color(0xFF7B7488),
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Color(0xFF7B7488),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 14.0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24.0),

                          // Visitor Assistance Concierge banner
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Connecting to Concierge Desk...',
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 180.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24.0),
                                image: const DecorationImage(
                                  image: NetworkImage(
                                    'https://lh3.googleusercontent.com/aida-public/AB6AXuDTMThXyn7_49nr0cXvuYHmeu8mVhdTe5uK3A49xuoYe_supZrA_0pQaUGN0iz3mPDXBPZJABBgCsPEROFrSirYC5tMoYSIdeMYFF4D9W_NphLH7CF7_bO0M2CLL0W2oy0YHOOjp7-R637E27tLKzBfdimFNaL5lISmVaoU_fn7Lm5InuNpaptsCWZbnsvMD-6GQIMvUkI7fs6qIXl-C6oEseccZixylaRG66_grIoW_6f2lhY1pN2sKEqNTaRXRtB9R2DmnMP9Vg',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24.0),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.black.withOpacity(0.6),
                                          Colors.transparent,
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 24.0,
                                    bottom: 24.0,
                                    right: 24.0,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'CONCIERGE SERVICES',
                                          style: TextStyle(
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white.withOpacity(
                                              0.9,
                                            ),
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                        const SizedBox(height: 6.0),
                                        const Text(
                                          'Visitor Assistance',
                                          style: TextStyle(
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        const Text(
                                          'Expert help for your ultimate shopping journey.',
                                          style: TextStyle(
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontSize: 12.0,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    right: 20.0,
                                    bottom: 20.0,
                                    child: Container(
                                      width: 36.0,
                                      height: 36.0,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Colors.white,
                                        size: 20.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 32.0),

                          // Quick Actions section
                          const SectionTitle(title: 'Quick Actions'),
                          const SizedBox(height: 12.0),
                          Column(
                            children: state.quickActions.map((action) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: MoreShortcutCard(
                                  action: action,
                                  onTap: () {
                                    if (action.type == 'parking') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const ParkingDetailsPage(),
                                        ),
                                      );
                                    } else if (action.type == 'atm') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const AmenitiesDetailsPage(),
                                        ),
                                      );
                                    } else if (action.type == 'emergency') {
                                      _showEmergencyDialog(context);
                                    }
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 32.0),

                          // Mall Services Bento Grid
                          const SectionTitle(title: 'Mall Services'),
                          const SizedBox(height: 12.0),
                          // Let's lay out Bento manually using Column and Rows for pixel perfection!
                          Column(
                            children: [
                              // Full width directory card
                              MallServiceBentoCard(
                                service: state.mallServices.firstWhere(
                                  (s) => s.id == 'directory',
                                ),
                                isLarge: true,
                                onTap: () {},
                              ),
                              const SizedBox(height: 16.0),
                              // 2x2 grid below
                              Row(
                                children: [
                                  Expanded(
                                    child: MallServiceBentoCard(
                                      service: state.mallServices.firstWhere(
                                        (s) => s.id == 'parking_availability',
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const ParkingDetailsPage(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16.0),
                                  Expanded(
                                    child: MallServiceBentoCard(
                                      service: state.mallServices.firstWhere(
                                        (s) => s.id == 'amenities_dir',
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const AmenitiesDetailsPage(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16.0),
                              Row(
                                children: [
                                  Expanded(
                                    child: MallServiceBentoCard(
                                      service: state.mallServices.firstWhere(
                                        (s) => s.id == 'offers_hub',
                                      ),
                                      onTap: () {},
                                    ),
                                  ),
                                  const SizedBox(width: 16.0),
                                  Expanded(
                                    child: MallServiceBentoCard(
                                      service: state.mallServices.firstWhere(
                                        (s) => s.id == 'gift_cards',
                                      ),
                                      onTap: () {},
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 32.0),

                          // Popular Services scroll
                          const SectionTitle(title: 'Popular Services'),
                          const SizedBox(height: 12.0),
                          PopularServicesSection(
                            popularServices: state.popularServices,
                            onItemTap: (service) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Connected to ${service.title}',
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 32.0),

                          // Feedback card
                          FeedbackBentoCard(
                            onSubmit: (stars, comments) {
                              context.read<MoreBloc>().add(
                                SubmitUserFeedback(
                                  rating: stars,
                                  comments: comments,
                                ),
                              );
                            },
                            isSubmitted: state.feedbackSubmitted,
                          ),
                          const SizedBox(height: 32.0),

                          // About and version details
                          const Center(
                            child: Column(
                              children: [
                                Text(
                                  'Mall Companion',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF7B7488),
                                  ),
                                ),
                                SizedBox(height: 2.0),
                                Text(
                                  'Version 2.4.0',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 11.0,
                                    color: Color(0xFF7B7488),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          if (state is MoreError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showEmergencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.0),
          ),
          backgroundColor: const Color(0xFFFEF7FF),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFBA1A1A)),
              SizedBox(width: 8.0),
              Text(
                'Emergency Security',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D1A25),
                ),
              ),
            ],
          ),
          content: const Text(
            'This action will place an immediate mock connection call to Lumina Mall Command center. Proceed?',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14.0,
              color: Color(0xFF4A4456),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Mock security call connected.'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBA1A1A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0),
                ),
                elevation: 0,
              ),
              child: const Text('Connect Now'),
            ),
          ],
        );
      },
    );
  }
}
