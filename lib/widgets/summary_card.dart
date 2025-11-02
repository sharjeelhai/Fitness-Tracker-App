import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'progress_ring.dart';
import 'animated_counter.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final int currentValue;
  final int targetValue;
  final IconData icon;
  final Color color;
  final String unit;
  final VoidCallback? onTap;

  const SummaryCard({
    Key? key,
    required this.title,
    required this.currentValue,
    required this.targetValue,
    required this.icon,
    required this.color,
    this.unit = '',
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = targetValue > 0
        ? (currentValue / targetValue).clamp(0.0, 1.0)
        : 0.0;
    final percentage = (progress * 100).round();
    final withOpacity = color.withOpacity(0.1);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header Row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: withOpacity,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: FaIcon(icon, color: color, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              // Progress Ring
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ProgressRing(
                    progress: progress,
                    size: 90,
                    strokeWidth: 7,
                    color: color,
                    backgroundColor: Colors.grey.shade300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedCounter(
                          value: currentValue,
                          textStyle: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: color,
                                fontSize: 18,
                              ),
                          suffix: unit,
                        ),
                        Text(
                          '$percentage%',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Goal Text
              Text(
                'Goal: $targetValue$unit',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
