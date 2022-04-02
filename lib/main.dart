import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:payment_app/configs.dart';
import 'package:payment_app/pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = Configs.publishableKey;
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      transitionDuration: const Duration(milliseconds: 500),
      defaultTransition: Transition.fadeIn,
      getPages: [
        GetPage(
          name: '/',
          page: () => const HomePage(),
        ),
      ],
    ),
  );
}
