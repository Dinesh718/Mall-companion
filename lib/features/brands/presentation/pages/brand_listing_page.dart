import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasource/brand_local_datasource.dart';
import '../../data/repository/brand_repository_impl.dart';
import '../../domain/usecases/get_brands.dart';
import '../bloc/brand_bloc.dart';
import '../bloc/brand_event.dart';
import '../bloc/brand_state.dart';
import '../widgets/brand_card.dart';
import '../widgets/brand_section_title.dart';
import '../widgets/featured_brand_card.dart';
import 'brand_details_page.dart';

class BrandListingPage extends StatelessWidget {
  const BrandListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final datasource = BrandLocalDataSourceImpl();
    final repository = BrandRepositoryImpl(localDataSource: datasource);

    return BlocProvider(
      create: (_) => BrandBloc(
        getBrandsUseCase: GetBrandsUseCase(repository),
        getBrandDetailsUseCase: GetBrandDetailsUseCase(repository),
        getBrandProductsUseCase: GetBrandProductsUseCase(repository),
        getBrandStoresUseCase: GetBrandStoresUseCase(repository),
        getBrandCollectionsUseCase: GetBrandCollectionsUseCase(repository),
        getBrandReviewsUseCase: GetBrandReviewsUseCase(repository),
        getBrandOffersUseCase: GetBrandOffersUseCase(repository),
        toggleBrandFavoriteUseCase: ToggleBrandFavoriteUseCase(repository),
        toggleBrandFollowUseCase: ToggleBrandFollowUseCase(repository),
      )..add(const LoadBrands()),
      child: const _BrandListingPageBody(),
    );
  }
}

class _BrandListingPageBody extends StatefulWidget {
  const _BrandListingPageBody();

  @override
  State<_BrandListingPageBody> createState() => _BrandListingPageBodyState();
}

class _BrandListingPageBodyState extends State<_BrandListingPageBody> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _floors = [
    'All Floors',
    'Ground',
    'First Floor',
    'Second Floor',
    'Dining Deck',
  ];

  final List<String> _categories = [
    'All Categories',
    'Fashion',
    'Luxury',
    'Electronics',
    'Dining',
    'Beauty',
    'Sports',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF7FF),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF6100D6)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Brands',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.bold,
                color: Color(0xFF6100D6),
                fontSize: 20.0,
              ),
            ),
            Text(
              'Explore premium mall collections',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                color: Color(0xFF7B7488),
                fontSize: 11.0,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF7B7488),
            ),
            onPressed: () {},
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18.0,
              backgroundImage: NetworkImage(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuBfK4KgjLrThr5hg-0dGI6IN8M0L48LCHEHdQrnMx5HBMWp5oBMlUq2QJoh2Zd1MSye5iRYgT27oyzlPPjGQ7TgPiCsnii4pTbvHbwLjNeW0A8UHjD7E4cGcgB8-ZGdoHdCYKamti7fYTmLnO5qeZUV3hEYUvKq-epC2ZFweCyyBYawd7hFCS2cZuD1_T2filoWxiN-8ztHG3yetb5ksRG71ESGDoYHpWFRdGFIwYmbbTd5v_vvdmK0gEgT7uQ2pAiaBCrweYGE9A',
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<BrandBloc, BrandState>(
        builder: (context, state) {
          if (state is BrandLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF6100D6)),
            );
          }

          if (state is BrandsLoaded) {
            final nike = state.allBrands.firstWhere(
              (element) => element.id == 'nike',
            );

            return RefreshIndicator(
              onRefresh: () async {
                context.read<BrandBloc>().add(const RefreshBrands());
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
                      controller: _searchController,
                      onChanged: (val) {
                        context.read<BrandBloc>().add(SearchBrands(query: val));
                      },
                      decoration: InputDecoration(
                        hintText: 'Search brands, items, or floors...',
                        hintStyle: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14.0,
                          color: Color(0xFF7B7488),
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFF7B7488),
                        ),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.mic,
                                color: Color(0xFF6100D6),
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.qr_code_scanner,
                                color: Color(0xFF6100D6),
                              ),
                              onPressed: () {},
                            ),
                          ],
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

                    // Floor Filter (Horizontal scroll list of rounded gradient buttons)
                    SizedBox(
                      height: 40.0,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _floors.length,
                        itemBuilder: (context, index) {
                          final f = _floors[index];
                          final isSelected = state.selectedFloor == f;

                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                context.read<BrandBloc>().add(
                                  FilterBrandsByFloor(floor: f),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                  vertical: 8.0,
                                ),
                                decoration: BoxDecoration(
                                  gradient: isSelected
                                      ? const LinearGradient(
                                          colors: [
                                            Color(0xFF7B2FF7),
                                            Color(0xFF3B82F6),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )
                                      : null,
                                  color: isSelected
                                      ? null
                                      : const Color(0xFFF9F1FF),
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  f,
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF4A4456),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12.0),

                    // Categories Filter (Horizontal scroll list of category chips)
                    SizedBox(
                      height: 36.0,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final cat = _categories[index];
                          final isSelected = state.selectedCategory == cat;

                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                context.read<BrandBloc>().add(
                                  FilterBrandsByCategory(category: cat),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF6100D6).withOpacity(0.1)
                                      : const Color(0xFFF9F1FF),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  cat == 'All Categories' ? 'All' : cat,
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 12.0,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? const Color(0xFF6100D6)
                                        : const Color(0xFF4A4456),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32.0),

                    // Hero Banner Card (Nike Performance)
                    FeaturedBrandCard(
                      brand: nike,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BrandDetailsPage(brandId: nike.id),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32.0),

                    // Popular Brands Round Avatars List
                    const BrandSectionTitle(title: 'Popular Brands'),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      height: 110.0,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.allBrands.length,
                        itemBuilder: (context, index) {
                          final brand = state.allBrands[index];

                          return Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        BrandDetailsPage(brandId: brand.id),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: 72.0,
                                    height: 72.0,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.04),
                                          blurRadius: 15.0,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                      border: Border.all(
                                        color: const Color(
                                          0xFFE8DFEF,
                                        ).withOpacity(0.5),
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(12.0),
                                    child: Image.network(
                                      brand.logoUrl,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    brand.name.split(' ').first,
                                    style: const TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1D1A25),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24.0),

                    // Curated List of Brands Grid
                    const BrandSectionTitle(title: 'Curated For You'),
                    const SizedBox(height: 16.0),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.filteredBrands.length,
                      itemBuilder: (context, index) {
                        final b = state.filteredBrands[index];
                        final promo = b.id == 'gucci'
                            ? 'Flat 30% OFF'
                            : (b.id == 'bose' ? 'New Arrival' : null);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: BrandCard(
                            brand: b,
                            promoTag: promo,
                            onNavigateTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Starting navigation to ${b.name}...',
                                  ),
                                ),
                              );
                            },
                            onExploreTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      BrandDetailsPage(brandId: b.id),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is BrandError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
