import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'app_theme.dart';
import 'providers/settings_provider.dart';
import 'providers/history_provider.dart';
import 'providers/scenario_provider.dart';
import 'providers/game_provider.dart';
import 'services/notification_service.dart';
import 'views/home_view.dart';
import 'views/module_selection_view.dart';
import 'views/simulation_view.dart';
import 'views/feedback_view.dart';
import 'views/end_view.dart';
import 'views/trends_view.dart';
import 'views/history_view.dart';
import 'views/curriculum_view.dart';
import 'views/settings_view.dart';
import 'widgets/phishing_logo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Transparent status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  // Lock to portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize real system notification plugin
  await NotificationService.instance.init();

  runApp(const SafeStepApp());
}

class SafeStepApp extends StatelessWidget {
  const SafeStepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ChangeNotifierProvider(create: (_) => ScenarioProvider()),
        ChangeNotifierProvider(create: (_) => GameProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProv, _) {
          return MaterialApp(
            title: 'SafeStep AI',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.buildLightTheme(),
            darkTheme: AppTheme.buildDarkTheme(),
            themeMode: settingsProv.themeMode,
            home: const AppBootstrap(),
          );
        },
      ),
    );
  }
}

/// Bootstrap widget: loads data from storage, then renders the app shell.
class AppBootstrap extends StatefulWidget {
  const AppBootstrap({super.key});

  @override
  State<AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<AppBootstrap> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final scenProv = Provider.of<ScenarioProvider>(context, listen: false);
    final histProv = Provider.of<HistoryProvider>(context, listen: false);
    final settingsProv = Provider.of<SettingsProvider>(context, listen: false);

    await Future.wait([
      scenProv.loadScenarios(),
      histProv.loadHistory(),
      settingsProv.loadSettings(),
    ]);

    if (mounted) {
      setState(() => _initialized = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return Scaffold(
        backgroundColor: AppColors.canvasOf(context),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SafeStepSplashLogo(),
              SizedBox(height: 28),
              CircularProgressIndicator(
                color: AppColors.emerald,
                strokeWidth: 3,
              ),
              SizedBox(height: 16),
              Text(
                'Memuatkan data selamat...',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return const AppShell();
  }
}

/// Main app shell — state-driven view router.
/// Real system notifications are handled by NotificationService;
/// the in-app overlay has been removed.
class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvasOf(context),
      body: const _ViewRouter(),
    );
  }
}

/// Routes between views based on game state string.
class _ViewRouter extends StatelessWidget {
  const _ViewRouter();

  @override
  Widget build(BuildContext context) {
    final gameState = context.select<GameProvider, String>((g) => g.gameState);

    switch (gameState) {
      case 'menu':
        return const HomeView();
      case 'choose_category':
        return const ModuleSelectionView();
      case 'playing':
        return const SimulationView();
      case 'feedback':
        return const FeedbackView();
      case 'end':
        return const EndView();
      case 'trends':
        return const TrendsView();
      case 'history':
        return const HistoryView();
      case 'manage_sim':
        return const CurriculumView();
      case 'settings':
        return const SettingsView();
      default:
        return const HomeView();
    }
  }
}

/// Animated splash logo for loading screen.
class _SafeStepSplashLogo extends StatelessWidget {
  const _SafeStepSplashLogo();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        PhishingLogo(size: 84),
        SizedBox(height: 14),
        Text(
          'SafeStep AI',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Perisai Digital Warga Malaysia',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 10,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
