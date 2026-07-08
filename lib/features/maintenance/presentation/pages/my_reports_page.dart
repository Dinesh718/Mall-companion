import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Usecases & Repository
import '../../data/datasource/maintenance_local_datasource.dart';
import '../../data/repository/maintenance_repository_impl.dart';
import '../../domain/usecases/maintenance_usecases.dart';

// BLoC
import '../bloc/maintenance_bloc.dart';
import '../bloc/maintenance_event.dart';
import '../bloc/maintenance_state.dart';

// Reusable Widgets
import '../widgets/statistics_card.dart';
import '../widgets/login_prompt_card.dart';
import '../widgets/report_card.dart';

// Pages
import 'ticket_created_page.dart';

class MyReportsPage extends StatelessWidget {
  const MyReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localDataSource = MaintenanceLocalDataSourceImpl();
    final repository = MaintenanceRepositoryImpl(
      localDataSource: localDataSource,
    );

    return BlocProvider(
      create: (_) => MaintenanceBloc(
        loadReportsUseCase: LoadReportsUseCase(repository),
        submitIssueUseCase: SubmitIssueUseCase(repository),
        getTicketUseCase: GetTicketUseCase(repository),
      )..add(const LoadReports()),
      child: const _MyReportsView(),
    );
  }
}

class _MyReportsView extends StatefulWidget {
  const _MyReportsView();

  @override
  State<_MyReportsView> createState() => _MyReportsViewState();
}

class _MyReportsViewState extends State<_MyReportsView> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF), // surface
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FF).withOpacity(0.6),
        elevation: 0,
        scrolledUnderElevation: 1.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF6100D6)),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'My Reports',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6100D6),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF6100D6),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8.0),
          // User Avatar on right of TopAppBar
          Container(
            width: 32.0,
            height: 32.0,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF4FF),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFCCC3D9), width: 1.0),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuAbmuQ6C0XMx_kQEySHFGLSkNkenGKRHJJ84OZ75o42HnpTuMCLyxj0UdqOWqFGKSBnvUQLVqcP2IfJZza_Urrtb-gJdzFv5fT_iinaV3HPjVSnZppV0joueMf_HGgTjEVKNA4muzwIHf5YzoeQKHYSxfZUcdBJ4AQNiUrt0Ogl9sBBh97eUkiiLF1HS6mZIgi8ckNvGcgmn7p_gfeKMrwsPGKya0rIXWTK4aVIPo0tluZ-aY6yXoa4kMCXWZhrXfmHA6aDidZFiQ',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16.0),
        ],
      ),
      body: BlocBuilder<MaintenanceBloc, MaintenanceState>(
        builder: (context, state) {
          if (state is MaintenanceLoading || state is MaintenanceInitial) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6100D6)),
              ),
            );
          }

          if (state is MaintenanceError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64.0,
                      color: Color(0xFFBA1A1A),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Failed to load reports',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0B1C30),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      state.errorMessage,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Color(0xFF4A4456),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: () {
                        context.read<MaintenanceBloc>().add(
                          const LoadReports(),
                        );
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

          if (state is GuestMaintenanceState) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Track the status of your maintenance requests.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.0,
                      color: Color(0xFF4A4456),
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  // Premium Login Card for Guests
                  LoginPromptCard(
                    onLoginTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please navigate to the Profile tab to sign in.',
                          ),
                        ),
                      );
                    },
                    onContinueAsGuestTap: () {
                      Navigator.maybePop(context);
                    },
                  ),
                ],
              ),
            );
          }

          if (state is LoggedInMaintenanceState) {
            // Calculate stats dynamically
            final total = state.reports.length;
            final resolved = state.reports
                .where((r) => r.status == 'Resolved')
                .length;
            final inProgress = state.reports
                .where(
                  (r) =>
                      r.status == 'Assigned' ||
                      r.status == 'Repairing' ||
                      r.status == 'In Progress',
                )
                .length;
            final pending = state.reports
                .where((r) => r.status == 'Submitted')
                .length;

            // Apply search & pill filters
            var filteredReports = state.reports.where((r) {
              final matchesQuery =
                  r.ticketId.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ||
                  r.category.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ||
                  r.title.toLowerCase().contains(_searchQuery.toLowerCase());

              if (!matchesQuery) return false;

              if (_selectedFilter == 'All') return true;
              if (_selectedFilter == 'Open') return r.status != 'Resolved';
              if (_selectedFilter == 'Resolved') return r.status == 'Resolved';
              if (_selectedFilter == 'Pending') return r.status == 'Submitted';
              if (_selectedFilter == 'High Priority')
                return r.priority == 'High' || r.priority == 'Urgent';

              return true;
            }).toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Track the status of your maintenance requests.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.0, // body-lg
                      color: Color(0xFF4A4456), // on-surface-variant
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  // 1. Statistics Cards
                  StatisticsCard(
                    totalReports: total,
                    resolved: resolved,
                    inProgress: inProgress,
                    pending: pending,
                    avgTime: '3.2h',
                  ),
                  const SizedBox(height: 32.0),
                  // 2. Filter Pills Bar
                  _buildFilterBar(),
                  const SizedBox(height: 20.0),
                  // 3. Search Bar Input
                  _buildSearchBar(),
                  const SizedBox(height: 24.0),
                  // 4. History List of report cards
                  if (filteredReports.isEmpty)
                    _buildEmptyState()
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredReports.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16.0),
                      itemBuilder: (context, index) {
                        final report = filteredReports[index];
                        return ReportCard(
                          report: report,
                          onViewDetails: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Details: ${report.description}'),
                                duration: const Duration(seconds: 4),
                              ),
                            );
                          },
                          onTrackStatus: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    TicketCreatedPage(ticket: report),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  const SizedBox(height: 32.0),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildFilterBar() {
    final filters = ['All', 'Open', 'Resolved', 'Pending', 'High Priority'];
    return SizedBox(
      height: 40.0,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8.0),
        itemBuilder: (context, index) {
          final filterName = filters[index];
          final isSelected = filterName == _selectedFilter;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = filterName;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF6100D6)
                    : Colors.white, // primary : white
                borderRadius: BorderRadius.circular(9999.0),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF6100D6)
                      : const Color(0xFFCCC3D9), // primary : outline-variant
                  width: 1.0,
                ),
              ),
              child: Text(
                filterName,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.0, // label-lg
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : const Color(0xFF4A4456),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FF), // bg-surface-container-low
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) {
          setState(() {
            _searchQuery = val;
          });
        },
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.search, color: Color(0xFF4A4456)),
          hintText: 'Search Ticket ID or Category',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14.0),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: Column(
          children: [
            Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                color: const Color(0xFF6100D6).withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_outlined,
                color: Color(0xFF6100D6),
                size: 36.0,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'No Reports Found',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B1C30),
              ),
            ),
            const SizedBox(height: 4.0),
            const Text(
              'Try searching for another category or ticket.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.0,
                color: Color(0xFF4A4456),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
