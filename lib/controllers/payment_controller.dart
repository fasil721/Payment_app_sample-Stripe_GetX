// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:payment_app/configs.dart';
import 'package:payment_app/models/payment_intent.dart';

class PaymentController extends GetxController {
  Future<void> makePayment({
    required String amount,
    required String currency,
  }) async {
    try {
      final paymentIntentData = await createPaymentIntent(amount, currency);
      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            applePay: true,
            googlePay: true,
            testEnv: true,
            merchantCountryCode: 'US',
            merchantDisplayName: 'Prospects',
            customerId: paymentIntentData.customer,
            paymentIntentClientSecret: paymentIntentData.clientSecret,
            customerEphemeralKeySecret: paymentIntentData.ephemeralKey,
          ),
        );
        displayPaymentSheet();
      }
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  Future<void> displayPaymentSheet()  async {
    try {
      await Stripe.instance.presentPaymentSheet();
      Get.snackbar(
        'Payment',
        'Payment Successful',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 2),
      );
    } on Exception catch (e) {
      if (e is StripeException) {
        print("Error from Stripe: ${e.error.localizedMessage}");
      } else {
        print("Unforeseen error: $e");
      }
    } catch (e) {
      print("exception:$e");
    }
  }

  Future<PaymentIntentModel?> createPaymentIntent(
    String amount,
    String currency,
  ) async {
    try {
      final Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization': "Bearer ${Configs.secretKey}",
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final data = PaymentIntentModel.fromJson(
          Map<String, dynamic>.from(jsonData as Map),
        );
        return data;
      }
    } on HttpException catch (err) {
      print(err.message);
    } on PlatformException catch (err) {
      print('${err.message}');
    } catch (err) {
      print('$err');
    }
    return null;
  }

  String calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }
}
