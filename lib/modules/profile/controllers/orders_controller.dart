import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/real_firebase_service.dart';
import '../../../data/models/order_model.dart';
class OrdersController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxList<OrderModel> filteredOrders = <OrderModel>[].obs;
  final RxString errorMessage = ''.obs;
  final RxSet<OrderStatus> selectedFilters = <OrderStatus>{}.obs;
  StreamSubscription<List<OrderModel>>? _ordersSubscription;
  static const String fixedUserId = 'Drl8VATGG8swOjJjKmBD';
  @override
  void onInit() {
    super.onInit();
    filteredOrders.value = [];
    loadOrdersRealtime();
  }
  @override
  void onClose() {
    _ordersSubscription?.cancel();
    super.onClose();
  }
  void loadOrdersRealtime() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      String userId = fixedUserId;
      await _createSampleOrdersIfNeeded(userId);
      _ordersSubscription = RealFirebaseService.getUserOrdersStream(userId).listen(
        (ordersList) {
          for (var order in ordersList) {
          }
          orders.value = ordersList;
          _applyFilter(); // Apply current filter when orders update
          isLoading.value = false;
        },
        onError: (error) {
          errorMessage.value = error.toString();
          isLoading.value = false;
          Get.snackbar('Error', 'Failed to load orders: ${error.toString()}');
        },
      );
    } catch (e) {
      errorMessage.value = e.toString();
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to setup orders listener: ${e.toString()}');
    }
  }
  Future<void> _createSampleOrdersIfNeeded(String userId) async {
    try {
      List<OrderModel> existingOrders = await RealFirebaseService.getUserOrders(userId);
      if (existingOrders.isEmpty) {
        await RealFirebaseService.createSampleOrders(userId);
      } else {
      }
    } catch (e) {
    }
  }
  Future<void> refreshOrders() async {
    loadOrdersRealtime();
  }
  void toggleFilter(OrderStatus status) {
    if (selectedFilters.contains(status)) {
      selectedFilters.remove(status);
    } else {
      selectedFilters.add(status);
    }
    _applyFilter();
  }
  void clearFilters() {
    selectedFilters.clear();
    _applyFilter();
  }
  bool isFilterSelected(OrderStatus status) {
    return selectedFilters.contains(status);
  }
  String getFilterText() {
    if (selectedFilters.isEmpty) {
      return 'All Orders';
    }
    if (selectedFilters.length == 1) {
      return getStatusText(selectedFilters.first);
    }
    if (selectedFilters.length == 2) {
      final filters = selectedFilters.toList();
      return '${getStatusText(filters[0])} & ${getStatusText(filters[1])}';
    }
    return '${selectedFilters.length} Filters Selected';
  }
  void _applyFilter() {
    if (selectedFilters.isEmpty) {
      filteredOrders.value = List.from(orders);
    } else {
      filteredOrders.value = orders.where((order) => selectedFilters.contains(order.status)).toList();
    }
  }
  List<OrderStatus> getAvailableStatuses() {
    Set<OrderStatus> statuses = orders.map((order) => order.status).toSet();
    return statuses.toList()..sort((a, b) => a.name.compareTo(b.name));
  }
  int getOrderCountByStatus(OrderStatus status) {
    return orders.where((order) => order.status == status).length;
  }
  String getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.refunded:
        return 'Refunded';
    }
  }
  Color getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return const Color(0xFFF39C12);
      case OrderStatus.confirmed:
        return const Color(0xFF3498DB);
      case OrderStatus.processing:
        return const Color(0xFF9B59B6);
      case OrderStatus.shipped:
        return const Color(0xFF1ABC9C);
      case OrderStatus.delivered:
        return const Color(0xFF27AE60);
      case OrderStatus.cancelled:
        return const Color(0xFFE74C3C);
      case OrderStatus.refunded:
        return const Color(0xFF95A5A6);
    }
  }
}
