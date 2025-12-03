import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialLoginSection extends StatelessWidget {
  final VoidCallback onGoogle;
  final VoidCallback onApple;
  final VoidCallback onPintrest;
  final VoidCallback onFacebook;

  const SocialLoginSection({
    super.key,
    required this.onGoogle,
    required this.onApple,
    required this.onFacebook,
    required this.onPintrest,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ---- Divider with text ----
        Row(
          children: [
            const Expanded(child: Divider(thickness: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "or sign in with",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Expanded(child: Divider(thickness: 1)),
          ],
        ),

        const SizedBox(height: 32),

        // ---- Social Buttons ----
        Row(
          spacing: 32,
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            // Google Button
            _socialButton(
              icon: FontAwesomeIcons.facebook,
              onTap: onFacebook,
              color: Colors.blueAccent,
            ),
            _socialButton(
              icon: FontAwesomeIcons.google,
              onTap: onGoogle,
              color: Colors.redAccent,
            ),
            _socialButton(
              icon: FontAwesomeIcons.pinterest,
              onTap: onPintrest,
              color: Colors.redAccent,
            ),

            if (Platform.isIOS) const SizedBox(width: 80),

            // Apple Button
            if (Platform.isIOS)
              _socialButton(icon: FontAwesomeIcons.apple, onTap: onApple),
          ],
        ),
      ],
    );
  }

  // Reusable Social Button
  Widget _socialButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      // borderRadius: BorderRadius.circular(40),
      child: FaIcon(icon, size: 48, color: color ?? Colors.black),
    );
  }
}
