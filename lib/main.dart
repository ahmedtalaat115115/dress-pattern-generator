import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'providers/pattern_provider.dart';
import 'screens/home_screen.dart';
import 'l10n/app_ar.arb';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PatternProvider()),
      ],
      child: MaterialApp(
        title: 'مولّد باترونات الفساتين',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          useMaterial3: true,
          fontFamily: 'Cairo',
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ar', 'SA'),
          Locale('en', 'US'),
        ],
        locale: const Locale('ar', 'SA'),
        home: const HomeScreen(),
      ),
    );
  }
}
