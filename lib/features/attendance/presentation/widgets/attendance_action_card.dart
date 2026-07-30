import 'package:flutter/material.dart';

class AttendanceActionCard extends StatelessWidget {
  final VoidCallback? onShare;
  final VoidCallback? onPdf;
  final VoidCallback? onPrint;
  final VoidCallback? onEdit;

  const AttendanceActionCard({
    super.key,
    this.onShare,
    this.onPdf,
    this.onPrint,
    this.onEdit,
  });

  Widget _action({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
          child: Column(
            children: [

              CircleAvatar(
                radius: 24,
                backgroundColor: color.withOpacity(.10),
                child: Icon(
                  icon,
                  color: color,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                label,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            const Row(
              children: [

                Icon(Icons.settings),

                SizedBox(width: 8),

                Text(
                  "Actions",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const Divider(height: 24),

            Row(
              children: [

                _action(
                  icon: Icons.share,
                  label: "Share",
                  color: Colors.blue,
                  onTap: onShare,
                ),

                _action(
                  icon: Icons.picture_as_pdf,
                  label: "PDF",
                  color: Colors.red,
                  onTap: onPdf,
                ),

                _action(
                  icon: Icons.print,
                  label: "Print",
                  color: Colors.orange,
                  onTap: onPrint,
                ),

                _action(
                  icon: Icons.edit,
                  label: "Edit",
                  color: Colors.green,
                  onTap: onEdit,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}