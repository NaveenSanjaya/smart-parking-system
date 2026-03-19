import 'package:flutter/material.dart';
import 'dart:async';

import 'package:mobile/constants/app_colors.dart';

class LogoScreen extends StatelessWidget {
  const LogoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // navigate to login screen after 3 seconds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 3), () {
        if (context.mounted) {
          Navigator.of(context).pushReplacementNamed('/signIn');
        }
      });
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                border: Border.fromBorderSide(
                  BorderSide(color: Color.fromARGB(255, 112, 112, 112), width: 1.5),
                ),
              ),
              child: Icon(Icons.directions_car, size: 48, color: AppColors.primaryColor),
            ),

            SizedBox(height: 12),

            Text(
              'SmartPark',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),

            Text(
              'Your Parking Solution',
              style: TextStyle(color: Color.fromARGB(255, 112, 112, 112)),
            ),
          ],
        ),
      ),
    );
  }
}
