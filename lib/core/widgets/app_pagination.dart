import 'package:flutter/material.dart';

class AppPagination extends StatelessWidget {
  const AppPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.center,
      children: [

        IconButton(
          onPressed: currentPage > 1
              ? () => onPageChanged(
            currentPage - 1,
          )
              : null,
          icon: const Icon(
            Icons.chevron_left,
          ),
        ),

        Text(
          '$currentPage / $totalPages',
        ),

        IconButton(
          onPressed:
          currentPage < totalPages
              ? () => onPageChanged(
            currentPage + 1,
          )
              : null,
          icon: const Icon(
            Icons.chevron_right,
          ),
        ),
      ],
    );
  }
}