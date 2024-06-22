import 'package:chatw8me/features/auth/data/auth_provider.dart';
import 'package:chatw8me/features/auth/presentation/screen/login.dart';
import 'package:chatw8me/features/auth/presentation/screen/registration.dart';
import 'package:chatw8me/features/chat/presentation/screen/chat_screen.dart';
import 'package:chatw8me/features/chat/presentation/screen/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:go_router/go_router.dart';

class ChatApp extends ConsumerWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final authState = ref.watch(authStateProvider);
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => authState.when(
            data: (user) => user != null ? UsersScreen() : Login(),
            loading: () => CircularProgressIndicator(),
            error: (error, stack) => Text('Error: $error'),
          )
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => Registration(),
        ),
        GoRoute(
          path: '/chat/:chatRoomId/:currentUserId/:otherUserId',
          builder: (context, state) {
            final chatRoomId = state.pathParameters['chatRoomId']!;
            final currentUserId = state.pathParameters['currentUserId']!;
            final otherUserId = state.pathParameters['otherUserId']!;
            return ChatScreen(
              chatRoomId: chatRoomId,
              currentUserId: currentUserId,
              otherUserId: otherUserId,
            );
          },
        ),
      ],
    );
    return FlutterSizer(builder: (context, orientation, screenType) {
      return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'ChatApp',
        theme: _lightThemeData(),
        darkTheme: _dartThemeData(),
        themeMode: ThemeMode.system,
        routerConfig: router,
      );
    });
  }

  ThemeData _lightThemeData() {
    return ThemeData(
      brightness: Brightness.light,
      inputDecorationTheme: const InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.lightPrimary)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.lightPrimary)),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryPurple)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryPurple)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            fixedSize: const Size.fromWidth(double.maxFinite),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: AppColors.lightPrimary,
            foregroundColor: Colors.white),
      ),
      expansionTileTheme: ExpansionTileThemeData(
          shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(8),
      )),
    );
  }

  ThemeData _dartThemeData() {
    return ThemeData(
        brightness: Brightness.dark,
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: AppColors.lightPrimary)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: AppColors.lightPrimary)),
          errorBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          focusedErrorBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              fixedSize: const Size.fromWidth(double.maxFinite),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              // backgroundColor: Colors.purple,
              backgroundColor: AppColors.lightPrimary,
              foregroundColor: Colors.white),
        ),
        expansionTileTheme: ExpansionTileThemeData(
            shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(8),
        )),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
              iconColor:
                  MaterialStateColor.resolveWith((states) => Colors.white)),
        ));
  }
}

class AppColors {
  static const Color lightPrimary = Colors.green;
  static const Color darkPrimary = Colors.black;
  static const Color lightAccent = Color.fromARGB(255, 137, 211, 240);
  static const Color lightBG = Color(0xfffcfcff);
  static const Color darkBG = Colors.black;
  static const Color primaryPurple = Color(0xFF6334DC);
  static const Color textGrey = Color(0xFF808080);
  static const Color primaryWhiteSmoke = Color(0xFFF5F5F5);
  static const Color mediumYellow = Color(0xffFDB846);
  static const Color darkYellow = Color(0xffE99E22);
  static const Color bPrimaryColor = Color(0xFFFFC61F);
  static const Color bgPrimaryColor = Color(0xffffd31d);
  static const Color lightGrey = Color(0xFFD0D0D0);
  static const Color nestBlue = Color(0xFF0757AC);
  static const Color white = Color(0xffffffff);

  static Color getShade(Color color, {bool darker = false, double value = .1}) {
    assert(value >= 0 && value <= 1, 'shade values must be between 0 and 1');
    final HSLColor hsl = HSLColor.fromColor(color);
    final HSLColor hslDark = hsl.withLightness(
      (darker ? (hsl.lightness - value) : (hsl.lightness + value))
          .clamp(0.0, 1.0),
    );

    return hslDark.toColor();
  }

  /// Returns a [MaterialColor] from a [Color] object
  static MaterialColor getMaterialColorFromColor(Color color) {
    final Map<int, Color> colorShades = <int, Color>{
      50: getShade(color, value: 0.5),
      100: getShade(color, value: 0.4),
      200: getShade(color, value: 0.3),
      300: getShade(color, value: 0.2),
      400: getShade(color),
      500: color,
      600: getShade(color, darker: true),
      700: getShade(color, value: 0.15, darker: true),
      800: getShade(color, value: 0.2, darker: true),
      900: getShade(color, value: 0.25, darker: true),
    };
    return MaterialColor(color.value, colorShades);
  }
}