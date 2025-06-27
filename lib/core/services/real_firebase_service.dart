import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../data/models/order_model.dart';
class RealFirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final ImagePicker _picker = ImagePicker();
  static const String usersCollection = 'user'; // Changed from 'users' to 'user'
  static const String ordersCollection = 'orders';
  static Future<UserModel?> getUser(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(usersCollection).doc(userId).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return UserModel.fromMap(data, doc.id);
      } else {
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
  }
  static Future<void> createUser(String userId, UserModel user) async {
    try {
      await _firestore.collection(usersCollection).doc(userId).set(user.toMap());
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }
  static Future<void> updateUser(String userId, UserModel user) async {
    try {
      await _firestore.collection(usersCollection).doc(userId).update(
        user.copyWith(updatedAt: DateTime.now()).toMap(),
      );
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }
  static Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection(usersCollection).doc(userId).delete();
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }
  static Future<XFile?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80, // Reduce quality for better compatibility
      );
      return image;
    } catch (e) {
      throw Exception('Failed to pick image from camera: $e');
    }
  }
  static Future<XFile?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80, // Reduce quality for better compatibility
      );
      return image;
    } catch (e) {
      throw Exception('Failed to pick image from gallery: $e');
    }
  }
  static Future<String> uploadImage(File imageFile, String userId, {
    Function(double)? onProgress,
  }) async {
    try {
      if (!await imageFile.exists()) {
        throw Exception('Image file does not exist');
      }
      int fileSizeInBytes = await imageFile.length();
      if (fileSizeInBytes > 5 * 1024 * 1024) {
        throw Exception('Image file is too large. Please select an image smaller than 5MB.');
      }
      String fileName = 'profile_images/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageRef = _storage.ref().child(fileName);
      SettableMetadata metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'uploadedBy': userId,
          'uploadTime': DateTime.now().toIso8601String(),
        },
      );
      UploadTask uploadTask = storageRef.putFile(imageFile, metadata);
      if (onProgress != null) {
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          double progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        });
      }
      TaskSnapshot snapshot = await uploadTask;
      String downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
  static Future<void> deleteImage(String imageUrl) async {
    try {
      Reference imageRef = _storage.refFromURL(imageUrl);
      await imageRef.delete();
    } catch (e) {
    }
  }
  static Future<List<OrderModel>> getUserOrders(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(ordersCollection)
          .where('userId', isEqualTo: userId)
          .get();
      List<OrderModel> orders = querySnapshot.docs
          .map((doc) {
            return OrderModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          })
          .toList();
      orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
      return orders;
    } catch (e) {
      throw Exception('Failed to get orders: $e');
    }
  }
  static Stream<List<OrderModel>> getUserOrdersStream(String userId) {
    try {
      return _firestore
          .collection(ordersCollection)
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((querySnapshot) {
        List<OrderModel> orders = querySnapshot.docs
            .map((doc) {
              return OrderModel.fromMap(doc.data(), doc.id);
            })
            .toList();
        orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
        return orders;
      });
    } catch (e) {
      throw Exception('Failed to get orders stream: $e');
    }
  }
  static Future<void> createOrder(OrderModel order) async {
    try {
      await _firestore.collection(ordersCollection).add(order.toMap());
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }
  static Future<void> updateOrder(String orderId, OrderModel order) async {
    try {
      await _firestore.collection(ordersCollection).doc(orderId).update(order.toMap());
    } catch (e) {
      throw Exception('Failed to update order: $e');
    }
  }
  static Future<void> deleteOrder(String orderId) async {
    try {
      await _firestore.collection(ordersCollection).doc(orderId).delete();
    } catch (e) {
      throw Exception('Failed to delete order: $e');
    }
  }
  static String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }
  static Future<User?> signInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      return result.user;
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }
  static Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }
  static Future<void> createSampleOrders(String userId) async {
    try {
      List<Map<String, dynamic>> sampleOrders = [
        {
          'id': 'demo_1',
          'userId': userId,
          'orderNumber': 'ORD-001',
          'totalAmount': 7.5,
          'status': 'delivered',
          'orderDate': DateTime(2024, 6, 12).toIso8601String(),
          'deliveryAddress': '123 Main St, City, State 12345',
          'items': [
            {
              'productId': 'prod1',
              'productName': 'Serenity Nightstand',
              'price': 7.5,
              'quantity': 1,
              'imageUrl': 'https://example.com/nightstand.jpg'
            }
          ]
        },
        {
          'id': 'demo_2',
          'userId': userId,
          'orderNumber': 'ORD-002',
          'totalAmount': 50.0,
          'status': 'cancelled',
          'orderDate': DateTime(2024, 6, 19).toIso8601String(),
          'deliveryAddress': '123 Main St, City, State 12345',
          'items': [
            {
              'productId': 'prod2',
              'productName': 'Blue Table Lamp',
              'price': 25.0,
              'quantity': 2,
              'imageUrl': 'https://example.com/lamp.jpg'
            }
          ]
        },
        {
          'id': 'demo_3',
          'userId': userId,
          'orderNumber': 'ORD-003',
          'totalAmount': 285.0,
          'status': 'delivered',
          'orderDate': DateTime(2024, 6, 9).toIso8601String(),
          'deliveryAddress': '123 Main St, City, State 12345',
          'items': [
            {
              'productId': 'prod3',
              'productName': 'Bedroom Dresser',
              'price': 285.0,
              'quantity': 1,
              'imageUrl': 'https://example.com/dresser.jpg'
            }
          ]
        },
        {
          'id': 'demo_4',
          'userId': userId,
          'orderNumber': 'ORD-004',
          'totalAmount': 570.0,
          'status': 'processing',
          'orderDate': DateTime(2024, 6, 15).toIso8601String(),
          'deliveryAddress': '123 Main St, City, State 12345',
          'items': [
            {
              'productId': 'prod4',
              'productName': 'Green Bed',
              'price': 285.0,
              'quantity': 2,
              'imageUrl': 'https://example.com/bed.jpg'
            }
          ]
        },
        {
          'id': 'demo_5',
          'userId': userId,
          'orderNumber': 'ORD-005',
          'totalAmount': 570.0,
          'status': 'delivered',
          'orderDate': DateTime(2024, 6, 15).toIso8601String(),
          'deliveryAddress': '123 Main St, City, State 12345',
          'items': [
            {
              'productId': 'prod5',
              'productName': 'Wood Shelves',
              'price': 285.0,
              'quantity': 2,
              'imageUrl': 'https://example.com/shelves.jpg'
            }
          ]
        }
      ];
      for (var orderData in sampleOrders) {
        String orderId = orderData['id'];
        orderData.remove('id'); // Remove id from data since it will be the document ID
        await _firestore
            .collection(ordersCollection)
            .doc(orderId)
            .set(orderData);
      }
    } catch (e) {
      throw Exception('Failed to create sample orders: $e');
    }
  }
  static void showImageSourceBottomSheet(
    BuildContext context, {
    required VoidCallback onCameraSelected,
    required VoidCallback onGallerySelected,
  }) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Image Source',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                    onCameraSelected();
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 30,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text('Camera'),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                    onGallerySelected();
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.photo_library,
                          size: 30,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text('Gallery'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
