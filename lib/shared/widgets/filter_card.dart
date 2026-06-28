import 'package:flutter/material.dart';

class FilterCard extends StatelessWidget {
  final String filterName;
  final String imageUrl;
  final bool selected;

  const FilterCard({
    super.key,
    required this.filterName,
    required this.imageUrl,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,

      margin: const EdgeInsets.all(8),

      decoration: BoxDecoration(
        border: Border.all(
          color:
              selected
                  ? Colors.blue
                  : Colors.grey,
          width: 2,
        ),

        borderRadius:
            BorderRadius.circular(12),
      ),

      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(10),

              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),

          Padding(
            padding:
                const EdgeInsets.all(4),

            child: Text(
              filterName,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}