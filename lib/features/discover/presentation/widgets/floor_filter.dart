import 'package:flutter/material.dart';

class FloorFilter extends StatefulWidget {
  final Function(String) onFloorChanged;

  const FloorFilter({super.key, required this.onFloorChanged});

  @override
  State<FloorFilter> createState() => _FloorFilterState();
}

class _FloorFilterState extends State<FloorFilter> {
  String _selectedFloor = 'All Floors';

  final List<String> _floors = [
    'All Floors',
    'Ground Floor',
    'First Floor',
    'Second Floor',
    'Third Floor',
    'Fourth Floor',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: PopupMenuButton<String>(
          onSelected: (floor) {
            setState(() {
              _selectedFloor = floor;
            });
            widget.onFloorChanged(floor);
          },
          itemBuilder: (context) {
            return _floors.map((floor) {
              return PopupMenuItem<String>(
                value: floor,
                child: Text(
                  floor,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList();
          },
          offset: const Offset(0, 44),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF9F1FF), // surface-container-low
              borderRadius: BorderRadius.circular(8.0), // rounded-lg
              border: Border.all(
                color: const Color(
                  0xFFCCC3D9,
                ).withOpacity(0.2), // outline-variant/20
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 4.0,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _selectedFloor,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600, // label-lg
                    color: Color(0xFF1D1A25), // on-surface
                  ),
                ),
                const SizedBox(width: 8.0),
                const Icon(
                  Icons.expand_more_outlined,
                  color: Color(0xFF4A4456), // on-surface-variant
                  size: 20.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
