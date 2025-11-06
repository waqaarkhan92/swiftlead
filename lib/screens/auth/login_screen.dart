import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../theme/tokens.dart';
import '../main_navigation.dart';
import '../onboarding/onboarding_screen.dart';

/// Login Screen - User authentication
/// This screen will be shown when user is not authenticated
/// Currently uses mock authentication for testing
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Smooth page route transitions
  PageRoute _createPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // TODO: Replace with real authentication when backend is ready
      // For now, accept any email/password for testing
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        // Mark user as authenticated
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('user_authenticated', true);
        
        // Check if onboarding is needed
        final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
        
        // Navigate to onboarding or main app
        Navigator.of(context).pushReplacement(
          _createPageRoute(
            onboardingCompleted
                ? const MainNavigation()
                : const OnboardingScreen(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: ${e.toString()}'),
            backgroundColor: const Color(SwiftleadTokens.errorRed),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Welcome Back',
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: SwiftleadTokens.spaceXL),
              
              // Logo/App Name
              Text(
                'Swiftlead',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(SwiftleadTokens.primaryTeal),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: SwiftleadTokens.spaceS),
              Text(
                'Sign in to continue',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: SwiftleadTokens.spaceXXL),
              
              // Email Field
              FrostedContainer(
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'your@email.com',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              
              // Password Field
              FrostedContainer(
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceS),
              
              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Password reset - Feature coming soon')),
                    );
                  },
                  child: const Text('Forgot Password?'),
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceL),
              
              // Login Button
              PrimaryButton(
                label: _isLoading ? 'Signing in...' : 'Sign In',
                onPressed: _isLoading ? null : _handleLogin,
                icon: Icons.login,
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              
              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sign up - Feature coming soon')),
                      );
                    },
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
              
              const SizedBox(height: SwiftleadTokens.spaceL),
              
              // Demo Note
              Container(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                decoration: BoxDecoration(
                  color: const Color(SwiftleadTokens.infoBlue).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Color(SwiftleadTokens.infoBlue),
                      size: 20,
                    ),
                    const SizedBox(width: SwiftleadTokens.spaceS),
                    Expanded(
                      child: Text(
                        'For testing: Any email/password will work',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(SwiftleadTokens.infoBlue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

