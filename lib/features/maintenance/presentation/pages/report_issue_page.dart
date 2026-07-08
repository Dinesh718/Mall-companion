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
import '../widgets/maintenance_hero_card.dart';
import '../widgets/issue_category_grid.dart';
import '../widgets/priority_selector.dart';
import '../widgets/location_card.dart';
import '../widgets/photo_attachment_card.dart';

// Pages
import 'ticket_created_page.dart';

class ReportIssuePage extends StatelessWidget {
  const ReportIssuePage({super.key});

  @override
  Widget build(BuildContext context) {
    final localDataSource = MaintenanceLocalDataSourceImpl();
    final repository = MaintenanceRepositoryImpl(localDataSource: localDataSource);

    return BlocProvider(
      create: (_) => MaintenanceBloc(
        loadReportsUseCase: LoadReportsUseCase(repository),
        submitIssueUseCase: SubmitIssueUseCase(repository),
        getTicketUseCase: GetTicketUseCase(repository),
      )..add(const LoadMaintenance()),
      child: const _ReportIssueView(),
    );
  }
}

class _ReportIssueView extends StatefulWidget {
  const _ReportIssueView();

  @override
  State<_ReportIssueView> createState() => _ReportIssueViewState();
}

class _ReportIssueViewState extends State<_ReportIssueView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MaintenanceBloc, MaintenanceState>(
      listener: (context, state) {
        if (state is IssueSubmitted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => TicketCreatedPage(ticket: state.ticket),
            ),
          );
        } else if (state is MaintenanceError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: const Color(0xFFBA1A1A), // error
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FF), // background
        appBar: AppBar(
          backgroundColor: const Color(0xFFF8F9FF).withOpacity(0.6),
          elevation: 0,
          scrolledUnderElevation: 1.0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF6100D6)),
            onPressed: () => Navigator.maybePop(context),
          ),
          title: const Text(
            'Report an Issue',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B1C30),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: Color(0xFF4A4456)),
              onPressed: () {},
            ),
          ],
        ),
        body: BlocBuilder<MaintenanceBloc, MaintenanceState>(
          builder: (context, state) {
            if (state is MaintenanceLoading || state is SubmittingIssue) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6100D6)),
                ),
              );
            }

            if (state is MaintenanceLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Flow Timeline Header
                    _buildFlowTimeline(),
                    const SizedBox(height: 32.0),
                    // 2. Maintenance Hero banner
                    MaintenanceHeroCard(
                      onStartTap: () {
                        // Scroll to categories or focus category grid
                      },
                    ),
                    const SizedBox(height: 32.0),
                    // 3. Category Grid Selector
                    const Text(
                      'Select Issue Category',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18.0, // title-lg
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0B1C30), // on-surface
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    IssueCategoryGrid(
                      selectedCategory: state.category,
                      onCategorySelected: (catName) {
                        context.read<MaintenanceBloc>().add(SelectCategory(category: catName));
                      },
                    ),
                    const SizedBox(height: 32.0),
                    // 4. Details TextFields Card
                    const Text(
                      'Issue Details',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0B1C30),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 20.0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title Input
                          const Text(
                            'Issue Title',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4A4456),
                            ),
                          ),
                          const SizedBox(height: 6.0),
                          TextField(
                            controller: _titleController,
                            onChanged: (val) {
                              context.read<MaintenanceBloc>().add(UpdateIssueTitle(title: val));
                            },
                            maxLength: 50,
                            decoration: InputDecoration(
                              hintText: 'e.g. Water leak near North Entrance',
                              fillColor: const Color(0xFFEFF4FF),
                              filled: true,
                              counterText: '',
                              border: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF6100D6), width: 2.0),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                '${state.title.length} / 50',
                                style: const TextStyle(fontSize: 10.0, color: Color(0xFF7B7488)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          // Description Input
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4A4456),
                            ),
                          ),
                          const SizedBox(height: 6.0),
                          TextField(
                            controller: _descController,
                            onChanged: (val) {
                              context.read<MaintenanceBloc>().add(UpdateDescription(description: val));
                            },
                            maxLength: 250,
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: 'Please provide more details about the issue...',
                              fillColor: const Color(0xFFEFF4FF),
                              filled: true,
                              counterText: '',
                              border: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF6100D6), width: 2.0),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                '${state.description.length} / 250',
                                style: const TextStyle(fontSize: 10.0, color: Color(0xFF7B7488)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32.0),
                    // 5. Evidence Photo upload Card
                    const Text(
                      'Evidence',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0B1C30),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    PhotoAttachmentCard(
                      photoPath: state.photoPath,
                      onCameraTap: () {
                        // Simulate Camera Selection
                        context.read<MaintenanceBloc>().add(const AttachPhoto(
                            photoPath: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&q=80&w=600'));
                      },
                      onGalleryTap: () {
                        // Simulate Gallery Selection
                        context.read<MaintenanceBloc>().add(const AttachPhoto(
                            photoPath: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&q=80&w=600'));
                      },
                      onRemoveTap: () {
                        context.read<MaintenanceBloc>().add(const RemovePhoto());
                      },
                    ),
                    const SizedBox(height: 32.0),
                    // 6. Location Card
                    const Text(
                      'Location',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0B1C30),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    LocationCard(
                      location: state.location,
                      nearestLandmark: state.nearestLandmark,
                      status: state.locationStatus,
                      onRefresh: () {
                        context.read<MaintenanceBloc>().add(const FetchCurrentLocation());
                      },
                    ),
                    const SizedBox(height: 32.0),
                    // 7. Priority Level selection
                    const Text(
                      'Priority Level',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0B1C30),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    PrioritySelector(
                      selectedPriority: state.priority,
                      onPrioritySelected: (pri) {
                        context.read<MaintenanceBloc>().add(UpdatePriority(priority: pri));
                      },
                    ),
                    const SizedBox(height: 40.0),
                    // 8. Summary & Submission Card
                    _buildSubmitSection(context, state),
                    const SizedBox(height: 24.0),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildFlowTimeline() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildTimelineStepNode(1, 'Report', true),
          _buildTimelineDivider(),
          _buildTimelineStepNode(2, 'Category', false, opacity: 0.7),
          _buildTimelineDivider(),
          _buildTimelineStepNode(3, 'Photo', false, opacity: 0.5),
          _buildTimelineDivider(),
          _buildTimelineStepNode(4, 'Location', false, opacity: 0.3),
          _buildTimelineDivider(),
          _buildTimelineStepNode(5, 'Submit', false, opacity: 0.2),
        ],
      ),
    );
  }

  Widget _buildTimelineStepNode(int index, String label, bool isActive, {double opacity = 1.0}) {
    return Opacity(
      opacity: isActive ? 1.0 : opacity,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32.0,
            height: 32.0,
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF6100D6) : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive ? const Color(0xFF6100D6) : const Color(0xFFCCC3D9),
                width: 1.0,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              index.toString(),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.white : const Color(0xFF0B1C30),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10.0,
              fontWeight: FontWeight.bold,
              color: isActive ? const Color(0xFF6100D6) : const Color(0xFF0B1C30),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineDivider() {
    return Container(
      width: 32.0,
      height: 1.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      color: const Color(0xFFCCC3D9),
    );
  }

  Widget _buildSubmitSection(BuildContext context, MaintenanceLoaded state) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: const Color(0xFFE5EEFF), // surface-container
        borderRadius: BorderRadius.circular(28.0),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Category',
                style: TextStyle(fontSize: 12.0, color: Color(0xFF4A4456)),
              ),
              Text(
                state.category.isEmpty ? 'Not Selected' : state.category,
                style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Color(0xFF0B1C30)),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Priority',
                style: TextStyle(fontSize: 12.0, color: Color(0xFF4A4456)),
              ),
              Text(
                state.priority,
                style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Color(0xFF6100D6)),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          const Divider(height: 1.0, thickness: 1.0, color: Color(0xFFCCC3D9)),
          const SizedBox(height: 16.0),
          GestureDetector(
            onTap: () {
              context.read<MaintenanceBloc>().add(const SubmitIssue());
            },
            child: Container(
              width: double.infinity,
              height: 56.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28.0),
                gradient: const LinearGradient(
                  colors: [Color(0xFF7B2FF7), Color(0xFF3B82F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7B2FF7).withOpacity(0.2),
                    blurRadius: 15.0,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Text(
                'Submit Report',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'By submitting, you agree to our Terms of Service. Your data will be used to improve mall operations.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.0,
              color: Color(0xFF7B7488),
            ),
          ),
        ],
      ),
    );
  }
}
