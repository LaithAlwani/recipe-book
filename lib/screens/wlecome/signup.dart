import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/features/auth/auth_provider.dart';

class SignUpFrom extends ConsumerStatefulWidget {
  const SignUpFrom({super.key});

  @override
  ConsumerState<SignUpFrom> createState() => _SignUpFromState();
}

class _SignUpFromState extends ConsumerState<SignUpFrom> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final authVM = ref.read(authNotifierProvider.notifier);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //intro text
            const Center(
              child: Text(
                "Signup for a new account",
                style: TextStyle(fontSize: 18),
              ),
            ),
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
                // if (value.length < 8) {
                //   return "Password must be 8 characters in length";
                // }
                return null;
              },
            ),
            //error feedback
            const SizedBox(height: 16),
            if (authState.errorMessage != null)
              Text(
                authState.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            //submit button
            FilledButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    authState.copyWith(errorMessage: "Please check input");
                  });
                  final email = _emailController.text.trim();
                  final password = _passwordController.text.trim();

                  await authVM.register(email, password);
                }

                //errorr feedback
              },
              child: authState.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
