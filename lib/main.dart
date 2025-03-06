import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_ai_task/app.dart';
import 'package:package_ai_task/config/theme.dart';
import 'package:package_ai_task/screens/events_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: const PackageAiTask()));
}

class PackageAiTask extends StatelessWidget {
  const PackageAiTask({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Package AI Task',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      home: EventsApp(),
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
