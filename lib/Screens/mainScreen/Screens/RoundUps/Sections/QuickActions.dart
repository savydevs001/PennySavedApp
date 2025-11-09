import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart'; // For better icons

class QuickActions extends StatefulWidget {
  const QuickActions({super.key});

  @override
  State<QuickActions> createState() => _QuickActionsState();
}

class _QuickActionsState extends State<QuickActions> {
  bool roundUpsEnabled = true;
  String multiplier = "No Multiplier";
  String investingFrequency = "Daily";
  bool isMinimized = false; // Toggle for minimizing

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(36, 36, 51, 1), // Dark card background
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with "Quick Actions" and minimize button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Quick Actions",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => isMinimized = !isMinimized),
                  child: Text(
                    isMinimized ? "Expand" : "Minimize",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            if (!isMinimized) ...[
              const SizedBox(height: 16),

              // Enable Round-Ups Switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(LucideIcons.settings,
                          color: Color.fromRGBO(133, 187, 101, 1)),
                      SizedBox(width: 8),
                      Text(
                        "Enable Round - Ups",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                  Switch(
                    value: roundUpsEnabled,
                    onChanged: (value) =>
                        setState(() => roundUpsEnabled = value),
                    activeColor: const Color.fromRGBO(133, 187, 101, 1),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Round-Up Multiplier Dropdown
              _buildDropdownRow(
                icon: LucideIcons.signal,
                title: "Round-Up Multiplier",
                value: multiplier,
                items: ["No Multiplier", "2x", "3x"],
                onChanged: (value) => setState(() => multiplier = value!),
              ),
              const SizedBox(height: 10),

              // Investing Frequency Dropdown
              _buildDropdownRow(
                icon: LucideIcons.trendingUp,
                title: "Investing Frequency",
                value: investingFrequency,
                items: ["Daily", "Weekly", "Monthly"],
                onChanged: (value) =>
                    setState(() => investingFrequency = value!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Custom dropdown widget with an icon
  Widget _buildDropdownRow({
    required IconData icon,
    required String title,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            const Spacer(),
            const Icon(Icons.info_outline, color: Colors.grey, size: 18),
          ],
        ),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: const Color.fromRGBO(36, 36, 51, 1),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: const Color.fromRGBO(153, 156, 166, 1),
                  ),
                  borderRadius: BorderRadius.circular(20)),
              child: DropdownButton<String>(
                value: value,
                dropdownColor: const Color.fromRGBO(36, 36, 51, 1),
                style: const TextStyle(color: Colors.white),
                isExpanded: true,
                items: items.map((e) {
                  return DropdownMenuItem(value: e, child: Text(e));
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
