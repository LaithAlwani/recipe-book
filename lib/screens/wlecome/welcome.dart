import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recipe_book/features/auth/auth_provider.dart';
import 'package:recipe_book/features/auth/auth_state.dart';
import 'package:recipe_book/screens/wlecome/signin.dart';
import 'package:recipe_book/screens/wlecome/signup.dart';
import 'package:recipe_book/shared/social_logins.dart';
import 'package:recipe_book/theme.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  bool isSignUpForm = false;

  Future<void> _handleOtherLogins(
    String platformName,
    IconData icon,
    Color color,
  ) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            FaIcon(icon, color: color), // show the icon
            const SizedBox(width: 10),
            Text("$platformName sign-in is not available yet!"),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authVM = ref.read(authNotifierProvider.notifier);
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 130, 16, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/logo.png", height: 180),
            const SizedBox(height: 8),
            Text(
              "My Recipie Book",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryAccent,
              ),
            ),
            // Container(height: 180, color: Colors.red),
            if (isSignUpForm) const SignUpFrom() else const SignInForm(),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isSignUpForm
                      ? "Have an account? "
                      : "Don't have an account? ",
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    setState(() {
                      isSignUpForm = !isSignUpForm;
                    });
                  },
                  child: Text(isSignUpForm ? "Login" : "Register"),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SocialLoginSection(
              onGoogle: authVM.signInWithGoogle,
              onApple: () {},
              onFacebook: () => _handleOtherLogins(
                "Facebook",
                FontAwesomeIcons.facebook,
                Colors.blueAccent,
              ),
              onPintrest: () => _handleOtherLogins(
                "Pinterest",
                FontAwesomeIcons.pinterest,
                Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
