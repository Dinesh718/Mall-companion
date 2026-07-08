import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/more_bloc.dart';
import '../bloc/more_event.dart';
import '../bloc/more_state.dart';
import '../../data/datasource/more_local_datasource.dart';
import '../../data/repository/more_repository_impl.dart';
import '../../domain/usecases/get_more_data.dart';

class AmenitiesDetailsPage extends StatelessWidget {
  const AmenitiesDetailsPage({super.key});

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
      )..add(const LoadAmenitiesData()),
      child: Scaffold(
        backgroundColor: const Color(0xFFFEF7FF),
        appBar: AppBar(
          backgroundColor: Colors.white.withOpacity(0.8),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF6100D6)),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Amenities',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D1A25),
              fontSize: 20.0,
            ),
          ),
        ),
        body: BlocBuilder<MoreBloc, MoreState>(
          builder: (context, state) {
            if (state is MoreLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF6100D6)),
              );
            }

            if (state is AmenitiesDetailsLoaded) {
              final amenities = state.amenities;

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero Image Banner
                    Container(
                      height: 180.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.0),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuCGzzaFQsI4iJz03hogIxrVaSzY6reAdiYUnACmGEzSn8mO34Zy0mnH0kWjAWXCKrLD1DRkEd7exuyu_ydgR5WpNA5sJXEUOsZ2YeHBSKWdS0KgINx4HJxWOdTXrKfIcAkuAQIPM1X8E1qgETn71SMGJ5SfzuiiFYGdvQTujN6I7Twq0XbVX4M-65utaxWHKTx1yPs7hNWmHssDBemvnqeOfniok-sZRg0IwXhibxOBR-O3iSOcme3SRJBbirLy0JQAf0NRYx4ufw',
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
                                colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                          const Positioned(
                            bottom: 16.0,
                            left: 16.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Essential Services',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 10.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                SizedBox(height: 6.0),
                                Text(
                                  'At Your Service',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24.0),

                    // Search Bar
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for amenities...',
                        hintStyle: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14.0,
                          color: Color(0xFF7B7488),
                        ),
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF7B7488)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
                      ),
                    ),
                    const SizedBox(height: 32.0),

                    // Bento Grid of Amenities
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: amenities.length,
                      itemBuilder: (context, index) {
                        final item = amenities[index];

                        IconData getIconData(String name) {
                          switch (name) {
                            case 'wc':
                              return Icons.wc_rounded;
                            case 'atm':
                              return Icons.atm_rounded;
                            case 'chair':
                              return Icons.chair_rounded;
                            case 'info':
                              return Icons.info_rounded;
                            default:
                              return Icons.grid_view_rounded;
                          }
                        }

                        Color getAccentColor(String name) {
                          if (name == 'wc') return const Color(0xFF6100D6);
                          if (name == 'atm') return const Color(0xFF0058BE);
                          if (name == 'info') return const Color(0xFF6100D6);
                          return const Color(0xFF813800);
                        }

                        final accentColor = getAccentColor(item.iconName);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 20.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 15.0,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(color: const Color(0xFFE8DFEF).withOpacity(0.3)),
                          ),
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 44.0,
                                    height: 44.0,
                                    decoration: BoxDecoration(
                                      color: accentColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      getIconData(item.iconName),
                                      color: accentColor,
                                      size: 24.0,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEDE5F5),
                                      borderRadius: BorderRadius.circular(100.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                                    child: Text(
                                      item.status,
                                      style: TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.bold,
                                        color: accentColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16.0),
                              Text(
                                item.title,
                                style: const TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1D1A25),
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                item.description,
                                style: const TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 12.0,
                                  color: Color(0xFF4A4456),
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Row(
                                children: [
                                  Icon(Icons.location_on_rounded, color: accentColor, size: 16.0),
                                  const SizedBox(width: 6.0),
                                  Text(
                                    item.locationText,
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                      color: accentColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16.0),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  height: 48.0,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [accentColor, accentColor.withOpacity(0.8)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.directions_rounded, color: Colors.white, size: 18.0),
                                      SizedBox(width: 8.0),
                                      Text(
                                        'Navigate',
                                        style: TextStyle(
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }

            if (state is MoreError) {
              return Center(child: Text(state.message));
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
