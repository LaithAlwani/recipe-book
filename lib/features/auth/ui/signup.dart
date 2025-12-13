import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/features/auth/auth_provider.dart';
import 'package:recipe_book/l10n/app_localizations.dart';

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
    final appLocal = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //intro text
            Center(
              child: Text(
                appLocal.auth_signup_title,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),

            //email address
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: appLocal.auth_email_label),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return appLocal.auth_email_error;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            //password
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: appLocal.auth_password_lable,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return appLocal.auth_password_error;
                }
                if (value.length < 8) {
                  return appLocal.auth_password_length;
                }
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
                    authState.copyWith(errorMessage: appLocal.auth_check_input);
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
                  : Text(appLocal.auth_register),
            ),
          ],
        ),
      ),
    );
  }
}
