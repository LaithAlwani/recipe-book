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
      appBar: AppBar(
        title: const Text('Recipe Book'),
        backgroundColor: Colors.blue[500],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Welcome.'),

              // sign up screen
              if (isSignUpForm) const SignUpFrom() else const SignInForm(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isSignUpForm ? "Have an account, " : "Don't have an account, ",
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
      ),
    );
  }
}
