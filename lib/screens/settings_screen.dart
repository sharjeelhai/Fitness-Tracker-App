import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/fitness_provider.dart';
import '../models/user_goals.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info
            _buildUserInfoCard(context),

            const SizedBox(height: 24),

            // Goals Section
            Text(
              'Fitness Goals',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildGoalsCard(context),

            const SizedBox(height: 24),

            // App Settings
            Text(
              'App Settings',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildAppSettingsCard(context),

            const SizedBox(height: 24),

            // Data Management
            Text(
              'Data Management',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildDataManagementCard(context),

            const SizedBox(height: 24),

            // About
            Text(
              'About',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildAboutCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).primaryColor,
              child: const Text(
                'SH',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'sharjeelhai',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Fitness Enthusiast',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Active User',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalsCard(BuildContext context) {
    return Consumer<FitnessProvider>(
      builder: (context, provider, child) {
        final goals = provider.userGoals;

        return Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Daily Goals',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    TextButton(
                      onPressed: () => _editGoals(context, goals),
                      child: const Text('Edit'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildGoalRow(context, Icons.directions_walk, 'Steps',
                    '${goals.stepsGoal}', Colors.green),
                _buildGoalRow(context, Icons.local_fire_department, 'Calories',
                    '${goals.caloriesGoal.toInt()}', Colors.orange),
                _buildGoalRow(context, Icons.timer, 'Workout',
                    '${goals.workoutGoal} min', Colors.purple),
                _buildGoalRow(context, Icons.route, 'Distance',
                    '${goals.distanceGoal} km', Colors.blue),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGoalRow(BuildContext context, IconData icon, String title,
      String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppSettingsCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSettingRow(
              context,
              Icons.palette,
              'Theme',
              'Change app appearance',
              () => _showThemeDialog(context),
            ),
            const Divider(),
            _buildSettingRow(
              context,
              Icons.notifications,
              'Notifications',
              'Manage notification settings',
              () => _showNotificationSettings(context),
            ),
            const Divider(),
            _buildSettingRow(
              context,
              Icons.language,
              'Language',
              'English',
              () => _showLanguageSettings(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataManagementCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSettingRow(
              context,
              Icons.backup,
              'Export Data',
              'Export your fitness data',
              () => _exportData(context),
            ),
            const Divider(),
            _buildSettingRow(
              context,
              Icons.restore,
              'Import Data',
              'Import fitness data',
              () => _importData(context),
            ),
            const Divider(),
            _buildSettingRow(
              context,
              Icons.delete_forever,
              'Clear All Data',
              'Delete all fitness data',
              () => _clearAllData(context),
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSettingRow(
              context,
              Icons.info,
              'App Version',
              AppConstants.appVersion,
              null,
            ),
            const Divider(),
            _buildSettingRow(
              context,
              Icons.help,
              'Help & Support',
              'Get help and support',
              () => _showHelp(context),
            ),
            const Divider(),
            _buildSettingRow(
              context,
              Icons.privacy_tip,
              'Privacy Policy',
              'Read our privacy policy',
              () => _showPrivacyPolicy(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingRow(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback? onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : Theme.of(context).primaryColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : null,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(subtitle),
      trailing:
          onTap != null ? const Icon(Icons.arrow_forward_ios, size: 16) : null,
      onTap: onTap,
    );
  }

  void _editGoals(BuildContext context, UserGoals currentGoals) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _GoalsEditDialog(currentGoals: currentGoals);
      },
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return AlertDialog(
              title: const Text('Choose Theme'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<ThemeMode>(
                    title: const Text('Light'),
                    value: ThemeMode.light,
                    // ignore: deprecated_member_use
                    groupValue: themeProvider.themeMode,
                    // ignore: deprecated_member_use
                    onChanged: (ThemeMode? value) {
                      if (value != null) {
                        themeProvider.setThemeMode(value);
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('Dark'),
                    value: ThemeMode.dark,
                    // ignore: deprecated_member_use
                    groupValue: themeProvider.themeMode,
                    // ignore: deprecated_member_use
                    onChanged: (ThemeMode? value) {
                      if (value != null) {
                        themeProvider.setThemeMode(value);
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('System'),
                    value: ThemeMode.system,
                    // ignore: deprecated_member_use
                    groupValue: themeProvider.themeMode,
                    // ignore: deprecated_member_use
                    onChanged: (ThemeMode? value) {
                      if (value != null) {
                        themeProvider.setThemeMode(value);
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showNotificationSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification settings coming soon!')),
    );
  }

  void _showLanguageSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Language settings coming soon!')),
    );
  }

  void _exportData(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data export feature coming soon!')),
    );
  }

  void _importData(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data import feature coming soon!')),
    );
  }

  void _clearAllData(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear All Data'),
          content: const Text(
              'Are you sure you want to delete all your fitness data? This action cannot be undone.'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Delete All',
                  style: TextStyle(color: Colors.red.shade600)),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await Provider.of<FitnessProvider>(context, listen: false)
                      .clearAllData();
                  if (mounted) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('All data cleared successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error clearing data: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Help & Support'),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'How to use Fitness Tracker App:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('1. Add activities using the "Add Activity" tab'),
                Text('2. View your progress on the Dashboard'),
                Text('3. Set your fitness goals in Settings'),
                Text('4. Track daily summaries on the Home screen'),
                SizedBox(height: 16),
                Text(
                  'Need more help?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Contact: support@fitnesstracker.com'),
                Text('Version: 1.0.0'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Privacy Policy'),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Data Collection:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('• All data is stored locally on your device'),
                Text('• No data is sent to external servers'),
                Text('• Your privacy is completely protected'),
                SizedBox(height: 16),
                Text(
                  'Data Usage:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('• Data is used only for app functionality'),
                Text('• No analytics or tracking'),
                Text('• You have full control over your data'),
                SizedBox(height: 16),
                Text(
                  'Data Security:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('• SQLite database encryption'),
                Text('• Local storage only'),
                Text('• No cloud synchronization'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}

// Goals Edit Dialog
class _GoalsEditDialog extends StatefulWidget {
  final UserGoals currentGoals;

  const _GoalsEditDialog({required this.currentGoals});

  @override
  State<_GoalsEditDialog> createState() => _GoalsEditDialogState();
}

class _GoalsEditDialogState extends State<_GoalsEditDialog> {
  late TextEditingController _stepsController;
  late TextEditingController _caloriesController;
  late TextEditingController _workoutController;
  late TextEditingController _distanceController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _stepsController =
        TextEditingController(text: widget.currentGoals.stepsGoal.toString());
    _caloriesController = TextEditingController(
        text: widget.currentGoals.caloriesGoal.toString());
    _workoutController =
        TextEditingController(text: widget.currentGoals.workoutGoal.toString());
    _distanceController = TextEditingController(
        text: widget.currentGoals.distanceGoal.toString());
  }

  @override
  void dispose() {
    _stepsController.dispose();
    _caloriesController.dispose();
    _workoutController.dispose();
    _distanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Goals'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _stepsController,
                decoration: const InputDecoration(
                  labelText: 'Daily Steps Goal',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.directions_walk),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a goal';
                  }
                  final steps = int.tryParse(value);
                  if (steps == null || steps <= 0) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _caloriesController,
                decoration: const InputDecoration(
                  labelText: 'Daily Calories Goal',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.local_fire_department),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a goal';
                  }
                  final calories = double.tryParse(value);
                  if (calories == null || calories <= 0) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _workoutController,
                decoration: const InputDecoration(
                  labelText: 'Daily Workout Goal (minutes)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.timer),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a goal';
                  }
                  final workout = int.tryParse(value);
                  if (workout == null || workout <= 0) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _distanceController,
                decoration: const InputDecoration(
                  labelText: 'Daily Distance Goal (km)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.route),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a goal';
                  }
                  final distance = double.tryParse(value);
                  if (distance == null || distance <= 0) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: const Text('Save'),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final newGoals = UserGoals(
                stepsGoal: int.parse(_stepsController.text),
                caloriesGoal: double.parse(_caloriesController.text),
                workoutGoal: int.parse(_workoutController.text),
                distanceGoal: double.parse(_distanceController.text),
              );

              try {
                await Provider.of<FitnessProvider>(context, listen: false)
                    .updateGoals(newGoals);
                if (mounted) {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Goals updated successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error updating goals: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            }
          },
        ),
      ],
    );
  }
}
