import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player_x/utils/controllers/theme_controller.dart';
import 'package:player_x/utils/theme/theme.dart';

import 'package:player_x/utils/views/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final ThemeController themeController = Get.put(ThemeController());
  await themeController.initTheme();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Theme Switcher',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: Get.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(),
    );
  }
}
