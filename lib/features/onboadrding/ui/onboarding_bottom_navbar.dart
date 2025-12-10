import 'package:flutter/material.dart';
import 'package:recipe_book/theme.dart';

class OnboardingBottomNavbar extends StatelessWidget {
  const OnboardingBottomNavbar({
    super.key,
    required this.totalPages,
    required this.currentPage,
    required this.perviousPage,
    required this.onNextPage,
    required this.isLoading,
  });

  final int totalPages;
  final int currentPage;
  final VoidCallback perviousPage;
  final VoidCallback onNextPage;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: currentPage > 0 ? perviousPage : null,
            style: TextButton.styleFrom(
              foregroundColor: currentPage > 0 ? Colors.blue : Colors.grey,
            ),
            child: const Text("Back"),
          ),

          SizedBox(
            width: 120,
            height: 48,
            child: ElevatedButton(
              onPressed: onNextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      currentPage == totalPages - 1 ? "Submit" : "Next",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
              // child: Text(currentPage == totalPages - 1 ? "Finish" : "Next"),
            ),
          ),
        ],
      ),
    );
  }
}
