// ignore_for_file: file_names, prefer_const_constructors

import 'package:CateringAdmin/screens/order_summary_screen.dart';
import 'package:CateringAdmin/utils/constant.dart';
import 'package:CateringAdmin/widgets/drawer-widget.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: const Text("Orders Overview"),
      ),
      drawer: DrawerWidget(),
      body: MealOrderDetailsScreen(),
    );
  }
}
