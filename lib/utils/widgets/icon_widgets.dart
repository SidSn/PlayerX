import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player_x/utils/controllers/theme_controller.dart';

class ThemeToggleButton extends StatelessWidget {
  ThemeToggleButton({super.key});
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => IconButton(
          icon: Icon(themeController.themeIcon.value),
          onPressed: () {
            themeController.toggleTheme();
          },
        ));
  }
}
