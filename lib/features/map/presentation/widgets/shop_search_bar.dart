import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/map_bloc.dart';
import '../bloc/map_event.dart';
import '../bloc/map_state.dart';

class ShopSearchBar extends StatefulWidget {
  const ShopSearchBar({super.key});

  @override
  State<ShopSearchBar> createState() => _ShopSearchBarState();
}

class _ShopSearchBarState extends State<ShopSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MapBloc, MapState>(
      listenWhen: (previous, current) {
        if (previous is MapLoaded && current is MapLoaded) {
          // Clear text controller if search state is cleared programmatically
          return previous.searchQuery != null && current.searchQuery == null;
        }
        return false;
      },
      listener: (context, state) {
        _controller.clear();
      },
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.0),
        ),
        color: const Color(0xFFFEF7FF), // Surface background color
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const Icon(Icons.search, color: Color(0xFF4A4456)),
              const SizedBox(width: 12.0),
              Expanded(
                child: TextField(
                  controller: _controller,
                  onChanged: (query) {
                    if (query.isEmpty) {
                      context.read<MapBloc>().add(const ClearSearch());
                    } else {
                      context.read<MapBloc>().add(SearchShops(query));
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search shops or categories...',
                    hintStyle: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      color: Color(0xFF79747E),
                      fontSize: 16.0,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 14.0),
                  ),
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    color: Color(0xFF1D1B20),
                    fontSize: 16.0,
                  ),
                ),
              ),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _controller,
                builder: (context, value, _) {
                  if (value.text.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF4A4456)),
                    onPressed: () {
                      _controller.clear();
                      context.read<MapBloc>().add(const ClearSearch());
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
