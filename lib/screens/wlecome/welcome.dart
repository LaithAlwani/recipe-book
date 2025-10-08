import 'package:flutter/material.dart';
import 'package:recipe_book/screens/wlecome/signin.dart';
import 'package:recipe_book/screens/wlecome/signup.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isSignUpForm = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.fromLTRB(16,0,16,0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // sign up screen
              if (isSignUpForm) const SignUpFrom() else const SignInForm(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isSignUpForm
                        ? "Have an account, "
                        : "Don't have an account, ",
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
            ],
          ),
       
      ),
    );
  }
}
