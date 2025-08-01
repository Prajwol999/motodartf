import 'package:flutter/foundation.dart';

@immutable
abstract class SplashState {}

// The initial state before any check has been performed
class SplashInitial extends SplashState {}

// State indicating the auth check is complete and the user is authenticated
class SplashAuthenticated extends SplashState {}

// State indicating the auth check is complete and the user is NOT authenticated
class SplashUnauthenticated extends SplashState {}
