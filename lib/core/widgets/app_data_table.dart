import 'package:flutter/material.dart';

class AppDataColumn {
  const AppDataColumn({
    required this.label,
  });

  final String label;
}

class AppDataRow {
  const AppDataRow({
    required this.cells,
    this.onTap,
  });

  final List<Widget> cells;
  final VoidCallback? onTap;
}

class AppDataTable extends StatelessWidget {
  const AppDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.minWidth = 900,
  });

  final List<AppDataColumn> columns;
  final List<AppDataRow> rows;
  final double minWidth;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: minWidth,
          ),
          child: DataTable(
            headingRowHeight: 56,
            dataRowMinHeight: 60,
            dataRowMaxHeight: 60,
            columns: columns
                .map(
                  (column) => DataColumn(
                label: Text(
                  column.label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
                .toList(),
            rows: rows
                .map(
                  (row) => DataRow(
                onSelectChanged: (_) {
                  row.onTap?.call();
                },
                cells: row.cells
                    .map(
                      (cell) => DataCell(cell),
                )
                    .toList(),
              ),
            )
                .toList(),
          ),
        ),
      ),
    );
  }
}