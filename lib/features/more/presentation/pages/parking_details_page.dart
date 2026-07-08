import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/more_bloc.dart';
import '../bloc/more_event.dart';
import '../bloc/more_state.dart';
import '../../data/datasource/more_local_datasource.dart';
import '../../data/repository/more_repository_impl.dart';
import '../../domain/usecases/get_more_data.dart';

class ParkingDetailsPage extends StatefulWidget {
  const ParkingDetailsPage({super.key});

  @override
  State<ParkingDetailsPage> createState() => _ParkingDetailsPageState();
}

class _ParkingDetailsPageState extends State<ParkingDetailsPage> with SingleTickerProviderStateMixin {
  late AnimationController _blinkController;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

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
      )..add(const LoadParkingData()),
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
            'Parking Information',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D1A25),
              fontSize: 20.0,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share_outlined, color: Color(0xFF4A4456)),
              onPressed: () {},
            ),
          ],
        ),
        body: BlocBuilder<MoreBloc, MoreState>(
          builder: (context, state) {
            if (state is MoreLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF6100D6)),
              );
            }

            if (state is ParkingDetailsLoaded) {
              final floors = state.parkingFloors;

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
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuB2ovl8y_4O8rj13Tz_Vo79CUzlDFYxwthJOinvYeuozXnkT1SuRFTD5K3WlJ_XY7fLB_2OctaDrRBI51Bp7f3Wuka0A1rR4Ms4o4FvUTLoOvDy_Slgpc3jIsRxXXnRpqAKJ8DbOFDSH0154oXmukFOj5l1wJIn_LDJe4kUeIoRnbqvUOfEFzKG89K42GOajj4egxaTk4i7vimrDrXoVoakgxgLFCM8Km2Wn7rc2YNIIT-12YPU90CnsjVsJYsPC3wJHDmkCuMjcQ',
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
                                colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 16.0,
                            left: 16.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF6100D6).withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.verified_rounded, color: Colors.white, size: 12.0),
                                      SizedBox(width: 4.0),
                                      Text(
                                        'Premium Secured Parking',
                                        style: TextStyle(
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontSize: 10.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6.0),
                                const Text(
                                  'Central Wing Garage',
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
                    const SizedBox(height: 32.0),

                    // Availability header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Real-time Availability',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D1A25),
                          ),
                        ),
                        Row(
                          children: [
                            AnimatedBuilder(
                              animation: _blinkController,
                              builder: (context, child) {
                                return Opacity(
                                  opacity: _blinkController.value,
                                  child: Container(
                                    width: 8.0,
                                    height: 8.0,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF16A34A),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 6.0),
                            const Text(
                              'Live Now',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF16A34A),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),

                    // Level status grid
                    Column(
                      children: floors.map((floor) {
                        final isFull = floor.status == 'Full';
                        final isFast = floor.status == 'Filling Fast';
                        final percent = floor.occupiedSlots / floor.totalSlots;

                        Color progressColor = const Color(0xFF6100D6);
                        Color textColor = const Color(0xFF1D1A25);

                        if (isFull) {
                          progressColor = const Color(0xFF7B7488);
                          textColor = const Color(0xFF7B7488);
                        } else if (isFast) {
                          progressColor = const Color(0xFF813800);
                          textColor = const Color(0xFF813800);
                        }

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          decoration: BoxDecoration(
                            color: isFull ? const Color(0xFFF3EBFA) : Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(color: const Color(0xFFEDE5F5).withOpacity(0.5)),
                          ),
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    floor.level,
                                    style: const TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4A4456),
                                    ),
                                  ),
                                  Text(
                                    isFull ? 'Full' : '${floor.totalSlots - floor.occupiedSlots} slots left',
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12.0),
                              Container(
                                height: 8.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEDE5F5),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                alignment: Alignment.centerLeft,
                                child: FractionallySizedBox(
                                  widthFactor: percent,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: progressColor,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32.0),

                    // Find My Car
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F1FF),
                        borderRadius: BorderRadius.circular(24.0),
                        border: Border.all(
                          color: const Color(0xFF7B7488).withOpacity(0.3),
                          style: BorderStyle.solid,
                        ),
                      ),
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 56.0,
                                height: 56.0,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFEADDFF),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.directions_car_rounded,
                                  color: Color(0xFF6100D6),
                                  size: 28.0,
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Find My Car',
                                      style: TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1D1A25),
                                      ),
                                    ),
                                    SizedBox(height: 4.0),
                                    Text(
                                      'Registered Parking Location:\nLevel B2 • Row F • Spot 104',
                                      style: TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 12.0,
                                        color: Color(0xFF4A4456),
                                      ),
                                    ),
                                  ],
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
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF6100D6), Color(0xFF7B2FF7)],
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
                                    'Navigate to Car',
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
