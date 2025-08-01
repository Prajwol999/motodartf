class ApiEndpoints {
  ApiEndpoints._();

  // Timeouts
  static const connectionTimeout = Duration(seconds: 1000);
  static const receiveTimeout = Duration(seconds: 1000);
  
  // For Android Emulator/Physical Device on the same Wi-Fi
  // Updated with your Mac's IP address
  static const String serverAddress = "http://192.168.1.2:5050";

  static const String baseUrl = "$serverAddress/api/";
  static const String imageUrl = "$serverAddress/uploads/";

  //============== Auth ==============
  static const String login = "auth/login";
  static const String register = "auth/register";

  // ========== booking =======
  static const String getAllBooking = "/user/bookings";
  static const String createBooking = '/user/bookings';

  static const String deleteBooking = 'user/bookings/:id';
  static const String updateBooking = 'user/bookings/:id';

  // ========== services =======
  static const String getAllServices = '/user/services';
  
  // ========== profile =======
  static const String userProfile = "user/profile";

  // ========== notifications (NEW) =======
  static const String getNotifications = "user/notifications";
  static const String markNotificationsAsRead = "user/notifications/mark-read";
}