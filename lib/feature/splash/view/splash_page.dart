import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motofix_app/app/service_locator/service_locator.dart';
import 'package:motofix_app/feature/auth/presentation/view/signin_page.dart';
import 'package:motofix_app/feature/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:motofix_app/feature/splash/view_model/spash_view_model.dart';
import 'package:motofix_app/feature/splash/view_model/splash_state.dart';
import 'package:motofix_app/view/dashboard_screen.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide the Cubit to the widget tree
    return BlocProvider(
      create: (context) => serviceLocator<SplashCubit>(),
      child: const SplashView(),
    );
  }
}

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _progressAnimation;
  double _progressValue = 0.0;

  // Define theme colors
  final Color _primaryColor = const Color(0xFF2A4759);
  final Color _complementaryColor = const Color(0xFFB08A67);
  final Color _accentColor = const Color(0xFFE8C19A);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    )..addListener(() {
        setState(() {
          _progressValue = _progressAnimation.value;
        });
      });

    // When the animation is complete, trigger the authentication check
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        context.read<SplashCubit>().checkAuthentication();
      }
    });

    _controller.forward();
  }

  void _navigateToDashboard() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MotoFixDashboard()),
    );
  }

  void _navigateToSignIn() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: serviceLocator<LoginViewModel>(),
          child: const SignInPage(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen for state changes to handle navigation
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashAuthenticated) {
          _navigateToDashboard();
        } else if (state is SplashUnauthenticated) {
          _navigateToSignIn();
        }
      },
      child: Scaffold(
        body: Container(
          color: _primaryColor,
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/motofix_logo.png',
                    height: 150,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.error,
                        color: Colors.redAccent,
                        size: 60),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 200,
                    child: LinearProgressIndicator(
                      value: _progressValue,
                      backgroundColor: _complementaryColor.withOpacity(0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(_accentColor),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "MotoFix",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Your trusted partner for 2-wheeler vehicle care",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
