import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/map_entities.dart';
import '../bloc/map_bloc.dart';
import '../bloc/map_event.dart';
import '../bloc/map_state.dart';

class ShopSearchResults extends StatelessWidget {
  const ShopSearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MapBloc, MapState, (List<ShopEntity>?, String?)>(
      selector: (state) {
        if (state is MapLoaded) {
          return (state.searchResults, state.searchQuery);
        }
        return (null, null);
      },
      builder: (context, searchState) {
        final (results, query) = searchState;

        if (query == null || query.trim().isEmpty) {
          return const SizedBox.shrink();
        }

        return Card(
          elevation: 4.0,
          margin: const EdgeInsets.only(top: 4.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          color: const Color(0xFFFEF7FF), // Surface background color
          child: Container(
            constraints: const BoxConstraints(maxHeight: 280.0),
            child: results == null || results.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "No results found for '$query'",
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        color: Color(0xFF79747E),
                        fontSize: 14.0,
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    itemCount: results.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1.0, color: Color(0xFFCAC4D0)),
                    itemBuilder: (context, index) {
                      final shop = results[index];
                      return ListTile(
                        dense: true,
                        title: Text(
                          shop.name,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            color: Color(0xFF1D1B20),
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0,
                          ),
                        ),
                        subtitle: Text(
                          shop.category,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            color: Color(0xFF49454F),
                            fontSize: 13.0,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 14.0,
                          color: Color(0xFF4A4456),
                        ),
                        onTap: () {
                          final bloc = context.read<MapBloc>();
                          // Dispatch selection flow
                          bloc.add(SelectShop(shop.id));
                          // Dismiss the search overlay
                          bloc.add(const ClearSearch());
                        },
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
