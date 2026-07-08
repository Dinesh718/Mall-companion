import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/profile_bloc.dart';
import '../../bloc/profile_event.dart';

class GuestHeader extends StatelessWidget {
  const GuestHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F1FF), // bg-surface-container-low
        borderRadius: BorderRadius.circular(32.0), // rounded-card
        border: Border.all(
          color: const Color(
            0xFF7B2FF7,
          ).withOpacity(0.1), // primary-container/10
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Guest Avatar
          Container(
            width: 96.0,
            height: 96.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10.0,
                  offset: const Offset(0, 4),
                ),
              ],
              image: const DecorationImage(
                image: NetworkImage(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuDBOmoLXeuRojxZ_0sGd-y4eS6W7--qsX-AePflK5R6nmjnEk_C7H0uEk5zotqQqwm_fPoohwPsUZK9pib2g6M7YZqDyfrni0FwYO4hNiFIfNQU8Z8a0ng-ERNKHWj5rBd91yGOxYLtw6oprKt4kmk2Wujel6IPO7LKfNgIhEhCVTY0GIVQquNNlus5YlekoVB2NtIanDiAJDid6VzKTEBJDXCirv5itriJryZKejR1YIiBdjMTbQYxHdMvYF9B0hTs71aHRikvqUo',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          // Guest Mode Active Indicator
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 4.0,
            ),
            decoration: BoxDecoration(
              color: const Color(
                0xFF7B2FF7,
              ).withOpacity(0.1), // primary-container/10
              borderRadius: BorderRadius.circular(9999.0), // rounded-full
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6.0,
                  height: 6.0,
                  decoration: const BoxDecoration(
                    color: Color(0xFF6100D6), // primary
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6.0),
                const Text(
                  'Guest Mode Active',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12.0, // label-lg
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6100D6), // primary
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12.0),
          const Text(
            'Welcome, Guest',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 24.0, // headline-md
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D1A25), // on-surface
            ),
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Explore everything the mall has to offer without creating an account.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14.0, // body-md
              color: Color(0xFF4A4456), // on-surface-variant
              height: 1.4,
            ),
          ),
          const SizedBox(height: 32.0),
          // Action Buttons
          Column(
            children: [
              // Sign In Button
              GestureDetector(
                onTap: () {
                  context.read<ProfileBloc>().add(const SignInPressed());
                },
                child: Container(
                  width: double.infinity,
                  height: 56.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9999.0), // rounded-full
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7B2FF7), Color(0xFF3B82F6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16.0, // title-lg (16-18)
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              // Create Account Button
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Registration flow is not implemented in this demo.',
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 56.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9999.0), // rounded-full
                    border: Border.all(
                      color: const Color(0xFFCCC3D9), // outline-variant
                      width: 2.0,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D1A25), // on-surface
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
