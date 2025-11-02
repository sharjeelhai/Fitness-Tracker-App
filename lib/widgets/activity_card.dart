import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/fitness_activity.dart';
import '../utils/helpers.dart';

class ActivityCard extends StatelessWidget {
  final FitnessActivity activity;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  // ignore: use_super_parameters
  const ActivityCard({
    Key? key,
    required this.activity,
    this.onTap,
    this.onDelete,
    this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = AppHelpers.getExerciseColor(activity.exerciseType);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildExerciseIcon(color),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity.exerciseType,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          AppHelpers.formatDate(activity.date),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  if (onEdit != null)
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: onEdit,
                      color: Colors.grey.shade600,
                    ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20),
                      onPressed: () => _showDeleteDialog(context),
                      color: Colors.red.shade400,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              _buildMetricsGrid(context),
              if (activity.notes.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.notes, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          activity.notes,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseIcon(Color color) {
    IconData iconData = _getExerciseIconData(activity.exerciseType);

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: FaIcon(
          iconData,
          color: color,
          size: 20,
        ),
      ),
    );
  }

  IconData _getExerciseIconData(String exerciseType) {
    switch (exerciseType.toLowerCase()) {
      case 'running':
        return FontAwesomeIcons.personRunning;
      case 'cycling':
        return FontAwesomeIcons.bicycle;
      case 'swimming':
        return FontAwesomeIcons.personSwimming;
      case 'gym workout':
        return FontAwesomeIcons.dumbbell;
      case 'yoga':
        return FontAwesomeIcons.spa;
      case 'walking':
        return FontAwesomeIcons.personWalking;
      case 'dancing':
        return FontAwesomeIcons.music;
      case 'football':
        return FontAwesomeIcons.futbol;
      case 'basketball':
        // ignore: deprecated_member_use
        return FontAwesomeIcons.basketballBall;
      case 'tennis':
        return FontAwesomeIcons.baseballBatBall;
      case 'hiking':
        return FontAwesomeIcons.mountain;
      case 'boxing':
        return FontAwesomeIcons.handFist;
      case 'rowing':
        return FontAwesomeIcons.water;
      case 'climbing':
        return FontAwesomeIcons.mountain;
      default:
        return FontAwesomeIcons.heartPulse;
    }
  }

  Widget _buildMetricsGrid(BuildContext context) {
    final metrics = <Widget>[];

    if (activity.steps > 0) {
      metrics.add(_buildMetric(
        context,
        Icons.directions_walk,
        '${activity.steps}',
        'steps',
        Colors.green,
      ));
    }

    if (activity.caloriesBurned > 0) {
      metrics.add(_buildMetric(
        context,
        Icons.local_fire_department,
        AppHelpers.formatCalories(activity.caloriesBurned),
        'cal',
        Colors.orange,
      ));
    }

    if (activity.workoutDuration > 0) {
      metrics.add(_buildMetric(
        context,
        Icons.timer,
        AppHelpers.formatDuration(activity.workoutDuration),
        '',
        Colors.purple,
      ));
    }

    if (activity.distanceKm > 0) {
      metrics.add(_buildMetric(
        context,
        Icons.route,
        AppHelpers.formatNumber(activity.distanceKm),
        'km',
        Colors.blue,
      ));
    }

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: metrics,
    );
  }

  Widget _buildMetric(
    BuildContext context,
    IconData icon,
    String value,
    String unit,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(
            '$value $unit'.trim(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Activity'),
          content: Text(
              'Are you sure you want to delete this ${activity.exerciseType.toLowerCase()} activity?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child:
                  Text('Delete', style: TextStyle(color: Colors.red.shade600)),
              onPressed: () {
                Navigator.of(context).pop();
                onDelete?.call();
              },
            ),
          ],
        );
      },
    );
  }
}
