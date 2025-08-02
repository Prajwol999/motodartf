// lib/app/constant/api_endpoints.dart

class ApiEndpoints {
  // Private constructor to prevent instantiation.
  ApiEndpoints._();

  // --- Core Network Configuration ---
  static const connectionTimeout = Duration(seconds: 1000);
  static const receiveTimeout = Duration(seconds: 1000);

  // Your local server address.
  static const String serverAddress = "http://192.168.1.8:5050";

  // Base URL for all API calls. Note it ends with a slash.
  static const String baseUrl = "$serverAddress/api/";

  // Base URL for serving uploaded images.
  static const String imageUrl = "$serverAddress/uploads/";

  // --- Feature-Specific Endpoints ---
  // All paths below are relative to the baseUrl and should NOT start with a '/'.

  // ========== Auth ==============
  static const String login = "auth/login";
  static const String register = "auth/register";

  // ========== Booking ==============
  static const String getAllBooking = "user/bookings";
  static const String createBooking = "user/bookings";
  static const String completedBookings = "user/booking/completed";
  // Endpoints with dynamic IDs use a placeholder like ':id' for replacement.
  static const String deleteBooking = "user/bookings/:id";
  static const String updateBooking = "user/bookings/:id";
  static const String bookingById = "user/bookings/:id";

  // ========== Services ==============
  static const String getAllServices = 'user/services';

  // ========== Profile ==============
  static const String userProfile = "user/profile";

  // ========== Notifications ==============
  static const String getNotifications = "user/notifications";
  static const String markNotificationsAsRead = "user/notifications/mark-read";

  // ========== Reviews ==============
  static const String createReview = "user/reviews";
  // Placeholder for the serviceId.
  static const String getReviews = "user/reviews/service/:serviceId";
  
  // ========== Chatbot ==============
  static const String chat = "chat";
}