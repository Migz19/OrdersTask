import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/services/real_firebase_service.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    const String userId = 'Drl8VATGG8swOjJjKmBD';
    await RealFirebaseService.createSampleOrders(userId);
  } catch (e) {
  }
}
