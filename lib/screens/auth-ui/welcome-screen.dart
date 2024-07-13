import 'sign-in-screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../controllers/google-sign-in-controller.dart';
import '../../utils/constant.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final GoogleSignInController _googleSignInController =
      Get.put(GoogleSignInController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppConstant.appScendoryColor,
        title: Text(
          "Daffodil Catering",
          style: TextStyle(color: AppConstant.appTextColor),
        ),
      ),
      body: Stack(
        children: [
          // Lottie animation
          Lottie.asset('assets/images/splash-icon.json'),
          // Content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  SizedBox(height: 190),
                  Text(
                    "Order your meal online",
                    style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      
                    ),
                  ),
                  SizedBox(height: 90),
                  Container(
                    width: Get.width / 1.2,
                    height: Get.height / 12,
                    decoration: BoxDecoration(
                      color: AppConstant.appScendoryColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: TextButton.icon(
                      icon: Image.asset(
                        'assets/images/final-google-logo.png',
                        width: Get.width / 12,
                        height: Get.height / 12,
                      ),
                      label: Text(
                        "Sign in with Google",
                        style: TextStyle(color: AppConstant.appTextColor),
                      ),
                      onPressed: () {
                        _googleSignInController.signInWithGoogle();
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: Get.width / 1.2,
                    height: Get.height / 12,
                    decoration: BoxDecoration(
                      color: AppConstant.appScendoryColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: TextButton.icon(
                      icon: Icon(
                        Icons.email,
                        color: AppConstant.appTextColor,
                      ),
                      label: Text(
                        "Sign in with Email",
                        style: TextStyle(color: AppConstant.appTextColor),
                      ),
                      onPressed: () {
                        Get.to(() => SignInScreen());
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
