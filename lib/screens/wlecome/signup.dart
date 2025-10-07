import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe_book/services/auth_service.dart';

class SignUpFrom extends StatefulWidget {
  const SignUpFrom({super.key});

  @override
  State<SignUpFrom> createState() => _SignUpFromState();
}

class _SignUpFromState extends State<SignUpFrom> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //intro text
            const Center(child: Text("signup for a new account")),
            const SizedBox(height: 16),

            //email address
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: "Email"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "please enter your email";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            //password
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "please enter a passowrd";
                }
                if (value.length < 8) {
                  return "Password must be 8 characters in length";
                }
                return null;
              },
            ),
            //error feedback
            const SizedBox(height: 16),

            //submit button
            FilledButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final email = _emailController.text.trim();
                  final password = _passwordController.text.trim();

                  final user = await AuthService.signUp(email, password);
                  print(user);
                }

                //errorr feedback
                
              },
              child: Text("Signup"),
            ),
          ],
        ),
      ),
    );
  }
}
