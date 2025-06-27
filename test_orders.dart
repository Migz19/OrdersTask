import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'lib/core/services/real_firebase_service.dart';
import 'lib/firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    const String userId = 'Drl8VATGG8swOjJjKmBD';
    await RealFirebaseService.createSampleOrders(userId);
    final orders = await RealFirebaseService.getUserOrders(userId);
    for (var order in orders) {
    }
  } catch (e) {
  }
}
