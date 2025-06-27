import 'package:get/get.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profile/views/edit_profile_view.dart';
import '../modules/profile/views/my_orders_view.dart';

class AppRoutes {
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String myOrders = '/my-orders';

  static List<GetPage> pages = [
    GetPage(
      name: profile,
      page: () => const ProfileView(),
    ),
    GetPage(
      name: editProfile,
      page: () => const EditProfileView(),
    ),
    GetPage(
      name: myOrders,
      page: () => const MyOrdersView(),
    ),
  ];
}
