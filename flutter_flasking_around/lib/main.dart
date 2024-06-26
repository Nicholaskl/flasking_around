import 'package:flutter_flasking_around/providers/transaction_provider.dart';
import 'package:flutter_flasking_around/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:flutter_flasking_around/screens/transactions_page.dart';
import 'package:flutter_flasking_around/screens/settings_page.dart';
import 'package:flutter_flasking_around/screens/upload_page.dart';
import 'package:flutter_flasking_around/widgets/transactions.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:system_theme/system_theme.dart';
import 'package:url_launcher/link.dart';
import 'package:window_manager/window_manager.dart';

import 'package:flutter_flasking_around/theme.dart';

const String appTitle = 'Nickyyy';
final _appTheme = AppTheme();

/// Checks if the current environment is a desktop environment.
bool get isDesktop {
  if (kIsWeb) return false;
  return [
    TargetPlatform.windows,
    TargetPlatform.linux,
    TargetPlatform.macOS,
  ].contains(defaultTargetPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // if it's not on the web, windows or android, load the accent color
  if (!kIsWeb &&
      [
        TargetPlatform.windows,
        TargetPlatform.android,
      ].contains(defaultTargetPlatform)) {
    SystemTheme.accentColor.load();
  }

  if (isDesktop) {
    await flutter_acrylic.Window.initialize();
    await flutter_acrylic.Window.hideWindowControls();
    await WindowManager.instance.ensureInitialized();
    windowManager.waitUntilReadyToShow().then((_) async {
      await windowManager.setTitleBarStyle(
        TitleBarStyle.hidden,
        windowButtonVisibility: false,
      );
      await windowManager.setMinimumSize(const Size(500, 600));
      await windowManager.show();
      await windowManager.setPreventClose(true);
      await windowManager.setSkipTaskbar(false);
    });
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppTheme()),
        ChangeNotifierProvider(create: (context) => TransactionProvider()),
      ],
      builder: (context, child) {
        final appTheme = context.watch<AppTheme>();
        return MaterialApp.router(
          title: appTitle,
          debugShowCheckedModeBanner: false,
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            // accentColor: appTheme.color,
            visualDensity: VisualDensity.standard,
            // focusTheme: FocusThemeData(
            //   glowFactor: is10footScreen(context) ? 2.0 : 0.0,
            // ),
          ),
          locale: appTheme.locale,
          builder: (context, child) {
            return Directionality(
              textDirection: appTheme.textDirection,
              child: Theme(
                data: ThemeData(
                  colorScheme: appTheme.colorScheme,
                  backgroundColor: appTheme.windowEffect !=
                          flutter_acrylic.WindowEffect.disabled
                      ? const Color.fromRGBO(255, 255, 255, 0.0)
                      : null,
                ),
                child: child!,
              ),
            );
          },
          routerConfig: router,
          // routeInformationParser: router.routeInformationParser,
          // routerDelegate: router.routerDelegate,
          // routeInformationProvider: router.routeInformationProvider,
        );
      },
      );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.child,
    required this.shellContext,
  });

  final Widget child;
  final BuildContext? shellContext;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WindowListener {
  bool value = false;

  // int index = 0;

  final viewKey = GlobalKey(debugLabel: 'Navigation View Key');
  final searchKey = GlobalKey(debugLabel: 'Search Bar Key');
  final searchFocusNode = FocusNode();
  final searchController = TextEditingController();

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final localizations = FluentLocalizations.of(context);

    final appTheme = context.watch<AppTheme>();
    final theme = Theme.of(context);
    // if (widget.shellContext != null) {
    //   if (router.canPop() == false) {
    //     setState(() {});
    //     print("MEOW");
    //   }
    // }

    return Scaffold(
      body: Row(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 240),
            child: NavDrawer()
          ),
          Flexible(
            child: widget.child,
          ),
      ],
      )
    );

  }

}

class NavDrawer extends StatefulWidget{
  const NavDrawer({super.key});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  String _selected = "/";
  List<List> menuItems = [
    [Icons.home, "Home", ('/')],
    [Icons.table_chart, "Transactions", ('/transactions')],
    [Icons.settings, "Settings", ('/settings')],
  ];

  @override
  Widget build(BuildContext context) {
    // Set the current route as a nav bar selection
    setState(() {
      _selected= (GoRouter.of(context).routeInformationProvider.value.uri).toString();
    });
    return Container(
        color: Colors.grey.shade800,
        child: Column(
          children: [
            buildHeader(context),
            buildMenuItems(context)
          ],
        ),
      );
  }

    Widget buildHeader(BuildContext context) => Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      )
    );

    Widget buildMenuItems(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: menuItems.map((e) => menuItem(context, e[0], e[1], e[2])).toList(),
      )
    );

    Widget menuItem(BuildContext context, IconData icon, String text, String route) => Container(
      margin: const EdgeInsets.only(bottom: 6),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: _selected == route ? _appTheme.colorScheme.primary: _appTheme.colorScheme.onPrimary,
          backgroundColor: _selected == route? _appTheme.colorScheme.onPrimary: Colors.transparent,
          textStyle: _selected == route ? _appTheme.menuFontActive: _appTheme.menuFont,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0)
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        ),
        child: Row(
          children: [
            Icon(icon),
            Container(
              padding: const EdgeInsets.only(left: 8),
              child: Text(text))
          ],),
          onPressed: () { 
            context.go(route);
            setState(() {
              _selected = route;
            });
          },
      )
    );  
}

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
final router = GoRouter(
  navigatorKey: rootNavigatorKey, 
  initialLocation: '/',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MyHomePage(
          shellContext: _shellNavigatorKey.currentContext,
          child: child,
        );
      },
      routes: [
        /// Home
        GoRoute(path: '/', builder: (context, state) => const HomePage()),
        GoRoute(path: '/transactions', builder: (context, state) => const TransactionsPage()),
        GoRoute(path: '/settings', builder: (context, state) => const SettingsPage()),
        GoRoute(path: '/upload', builder: (context, state) => const UploadPage()),
      ],
    ),
  ] 
);
