import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/fitness_provider.dart';
import '../widgets/summary_card.dart';
import '../widgets/activity_card.dart';
import '../utils/helpers.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Fitness Tracker App'),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                context.read<FitnessProvider>().loadData();
              },
            ),
          ],
        ),
        body: Consumer<FitnessProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading your fitness data...'),
                  ],
                ),
              );
            }

            if (provider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading data',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      provider.error!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        provider.clearError();
                        provider.loadData();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final todaySummary = provider.todaySummary;
            final todayActivities = provider.todayActivities;
            final userGoals = provider.userGoals;

            return RefreshIndicator(
              onRefresh: provider.loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWelcomeMessage(context),
                      const SizedBox(height: 24),

                      // Today's Progress
                      Text(
                        'Today\'s Progress',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      _buildSummaryGrid(context, todaySummary, userGoals),

                      const SizedBox(height: 32),

                      // Today's Activities
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Today\'s Activities',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          if (todayActivities.isNotEmpty)
                            TextButton(
                              onPressed: () {
                                // Navigate to all activities view
                              },
                              child: const Text('View All'),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      if (todayActivities.isEmpty)
                        _buildEmptyState(context)
                      else
                        _buildActivitiesList(
                          context,
                          todayActivities,
                          provider,
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWelcomeMessage(BuildContext context) {
    final now = DateTime.now();
    final hour = now.hour;
    String greeting = 'Good Morning';

    if (hour >= 12 && hour < 17) {
      greeting = 'Good Afternoon';
    } else if (hour >= 17) {
      greeting = 'Good Evening';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$greeting, Sharjeel!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Let\'s track your fitness journey today',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppHelpers.formatDate(now),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.fitness_center, color: Colors.white, size: 36),
        ],
      ),
    );
  }

  Widget _buildSummaryGrid(
    BuildContext context,
    dynamic todaySummary,
    dynamic userGoals,
  ) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.9, // adjusted for better fit
      children: [
        SummaryCard(
          title: 'Steps',
          currentValue: todaySummary.totalSteps,
          targetValue: userGoals.stepsGoal,
          icon: FontAwesomeIcons.shoePrints,
          color: Colors.green,
        ),
        SummaryCard(
          title: 'Calories',
          currentValue: todaySummary.totalCalories.toInt(),
          targetValue: userGoals.caloriesGoal.toInt(),
          icon: FontAwesomeIcons.fire,
          color: Colors.orange,
          unit: ' cal',
        ),
        SummaryCard(
          title: 'Workout',
          currentValue: todaySummary.totalWorkoutMinutes,
          targetValue: userGoals.workoutGoal,
          icon: FontAwesomeIcons.dumbbell,
          color: Colors.purple,
          unit: ' min',
        ),
        SummaryCard(
          title: 'Distance',
          currentValue: todaySummary.totalDistance.toInt(),
          targetValue: userGoals.distanceGoal.toInt(),
          icon: FontAwesomeIcons.route,
          color: Colors.blue,
          unit: ' km',
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(Icons.fitness_center, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No activities logged today',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Start tracking your fitness journey by adding your first activity!',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to add activity screen
            },
            icon: const Icon(Icons.add),
            label: const Text('Add First Activity'),
          ),
        ],
      ),
    );
  }

  Widget _buildActivitiesList(
    BuildContext context,
    List activities,
    FitnessProvider provider,
  ) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return ActivityCard(
          activity: activity,
          onTap: () {
            // Navigate to activity details
          },
          onEdit: () {
            // Navigate to edit activity screen
          },
          onDelete: () => provider.deleteActivity(activity.id),
        );
      },
    );
  }
}
