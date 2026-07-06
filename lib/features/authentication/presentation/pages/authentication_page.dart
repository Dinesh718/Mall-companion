import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visitor_mall/features/authentication/presentation/widgets/gradient_button.dart';
import 'package:visitor_mall/features/onboarding/presentation/widgets/floating_widget.dart';
import 'package:visitor_mall/features/onboarding/presentation/widgets/glass_card.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/otp_input.dart';

// --- Premium Gradient Text Helper ---
class GradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final List<Color> colors;

  const GradientText({
    super.key,
    required this.text,
    this.style,
    this.colors = const [Color(0xFF7B2FF7), Color(0xFF3B82F6)],
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(
        text,
        style:
            style?.copyWith(color: Colors.white) ??
            const TextStyle(color: Colors.white),
      ),
    );
  }
}

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  late final TextEditingController _phoneController;
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  String _enteredOtp = '';

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthenticationBloc(),
      child: BlocConsumer<AuthenticationBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.success) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          }

          if (state.status == AuthStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: const Color(0xFFBA1A1A),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state.status == AuthStatus.loading;

          return Scaffold(
            backgroundColor: const Color(0xFFF8F9FF),
            body: Stack(
              children: [
                // Blurred background glow elements
                _buildBackgroundDecorations(state.currentScreen),

                SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 16.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: _buildActiveView(context, state, isLoading),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActiveView(
    BuildContext context,
    AuthState state,
    bool isLoading,
  ) {
    switch (state.currentScreen) {
      case AuthScreen.welcome:
        return _WelcomeView(
          isLoading: isLoading,
          onGuestPress: () => context.read<AuthenticationBloc>().add(
            const ContinueAsGuestEvent(),
          ),
          onLoginPress: () => context.read<AuthenticationBloc>().add(
            const ShowPhoneInputEvent(),
          ),
        );
      case AuthScreen.phoneInput:
        return _PhoneInputView(
          controller: _phoneController,
          isLoading: isLoading,
          onBack: () =>
              context.read<AuthenticationBloc>().add(const ShowWelcomeEvent()),
          onContinue: (phone) =>
              context.read<AuthenticationBloc>().add(SendOtpEvent(phone)),
        );
      case AuthScreen.otpVerification:
        return _OtpVerificationView(
          phoneNumber: state.phoneNumber ?? '',
          countdown: state.timerCountdown,
          isTimerActive: state.isTimerActive,
          isLoading: isLoading,
          onBack: () => context.read<AuthenticationBloc>().add(
            const ShowPhoneInputEvent(),
          ),
          onOtpChanged: (otp) => _enteredOtp = otp,
          onVerify: () => context.read<AuthenticationBloc>().add(
            VerifyOtpEvent(_enteredOtp),
          ),
          onResend: () =>
              context.read<AuthenticationBloc>().add(const ResendOtpEvent()),
        );
      case AuthScreen.completeProfile:
        return _CompleteProfileView(
          nameController: _nameController,
          emailController: _emailController,
          isLoading: isLoading,
          onContinue: (name, email) => context.read<AuthenticationBloc>().add(
            CompleteProfileEvent(fullName: name, email: email),
          ),
        );
    }
  }

  Widget _buildBackgroundDecorations(AuthScreen screen) {
    return Positioned.fill(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
        child: Stack(
          children: [
            Positioned(
              top: -80,
              left: -80,
              width: 280,
              height: 280,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF7B2FF7).withOpacity(0.05),
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              right: -100,
              width: 300,
              height: 300,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF3B82F6).withOpacity(0.06),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 1. WELCOME VIEW
// ==========================================
class _WelcomeView extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onGuestPress;
  final VoidCallback onLoginPress;

  const _WelcomeView({
    required this.isLoading,
    required this.onGuestPress,
    required this.onLoginPress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('WelcomeView'),
      children: [
        // Skip Button on Top-Right
        Align(
          alignment: Alignment.topRight,
          child: TextButton(
            onPressed: isLoading ? null : onGuestPress,
            child: const Text(
              'Skip',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6100D6),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8.0),

        // Illustration Container
        SizedBox(
          width: 280,
          height: 280,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF6100D6).withOpacity(0.05),
                  ),
                ),
              ),
              // Main visuals card
              Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.0),
                  border: Border.all(color: Colors.white, width: 4.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 24.0,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(36.0),
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuDy9a-VTVI9oRRfh7Jz2Oc5fVFC4Cw2oFUKbd_9lJMLBnxp2BZONRO3wsEiGbSnZuYk1Rh_5Z5EQ8fT5BujEAova35FRHka4Wn0cJQxXP-kt3rLPiqXBl47ZzBiLgmtfnXgoSFuIP5zAnXiWylALAqs8MLAOSPb7B4qhLgjzmMZITBrLcsyV5dLmdQwn7SkNwjem6XNOj6u6vTSlx7D0Keze7HMbhg92sydAJs38j0Wg76_SgXg7t6AgpcXmfUwSTtiDqoAAWiqjA',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Floating Badge 1
              Positioned(
                top: 20.0,
                left: -12.0,
                child: FloatingWidget(
                  delayFraction: 0.0,
                  offset: 8.0,
                  child: GlassCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 6.0,
                    ),
                    borderRadius: 12.0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.local_mall,
                          color: Color(0xFF6100D6),
                          size: 14.0,
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          'Luxury Brands',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11.0,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF6100D6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Floating Badge 2
              Positioned(
                bottom: 40.0,
                right: -12.0,
                child: FloatingWidget(
                  delayFraction: 0.2,
                  offset: 8.0,
                  child: GlassCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 6.0,
                    ),
                    borderRadius: 12.0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.explore,
                          color: Color(0xFF0058BE),
                          size: 14.0,
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          'Step-by-step',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11.0,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0058BE),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24.0),

        // Welcome Text
        const Text(
          'Welcome to',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 4.0),
        const GradientText(
          text: 'Mall Companion',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 32.0,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.64,
          ),
        ),
        const SizedBox(height: 12.0),
        const Text(
          'Navigate smarter, discover more, and enjoy a seamless shopping experience.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 15.0,
            fontWeight: FontWeight.w400,
            height: 1.5,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 32.0),

        // Guest Action
        Container(
          width: double.infinity,
          height: 56.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            gradient: const LinearGradient(
              colors: [Color(0xFF7B2FF7), Color(0xFF3B82F6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7B2FF7).withOpacity(0.24),
                blurRadius: 16.0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: isLoading ? null : onGuestPress,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.explore, color: Colors.white, size: 20.0),
                SizedBox(width: 8.0),
                Text(
                  'Continue as Guest',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6.0),
        const Text(
          'Perfect for quick navigation and exploring the mall.',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12.0,
            fontStyle: FontStyle.italic,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 20.0),

        // Divider
        Row(
          children: [
            Expanded(
              child: Divider(
                color: const Color(0xFFCCC3D9).withOpacity(0.4),
                height: 1,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'OR',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF7B7488),
                  letterSpacing: 1.5,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: const Color(0xFFCCC3D9).withOpacity(0.4),
                height: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20.0),

        // Secondary Action Buttons
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 60.0,
                child: OutlinedButton(
                  onPressed: isLoading ? null : onLoginPress,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: const Color(0xFFCCC3D9).withOpacity(0.4),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.account_circle,
                        color: Color(0xFF6100D6),
                        size: 20.0,
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'Sign In',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6100D6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: SizedBox(
                height: 60.0,
                child: OutlinedButton(
                  onPressed: isLoading ? null : onLoginPress,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: const Color(0xFFCCC3D9).withOpacity(0.4),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.person_add,
                        color: Color(0xFF6100D6),
                        size: 20.0,
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'Create Account',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6100D6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 28.0),

        // Benefits Container Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: Colors.white, width: 1.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 16.0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Why create an account?',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.0,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF121C2A),
                ),
              ),
              const SizedBox(height: 16.0),
              _buildBenefitRow(
                Icons.favorite,
                Colors.pink.shade50,
                Colors.pink.shade600,
                'Save favourite stores',
              ),
              const SizedBox(height: 12.0),
              _buildBenefitRow(
                Icons.card_giftcard,
                Colors.orange.shade50,
                Colors.orange.shade600,
                'Receive personalised offers',
              ),
              const SizedBox(height: 12.0),
              _buildBenefitRow(
                Icons.local_parking,
                Colors.blue.shade50,
                Colors.blue.shade600,
                'Save parking history',
              ),
            ],
          ),
        ),
        const SizedBox(height: 32.0),

        // Footer
        RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.0,
              height: 1.5,
              color: Color(0xFF6B7280),
            ),
            children: [
              TextSpan(text: 'By continuing, you agree to our \n'),
              TextSpan(
                text: 'Terms & Conditions',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6100D6),
                ),
              ),
              TextSpan(text: ' and '),
              TextSpan(
                text: 'Privacy Policy',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6100D6),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        const Text(
          'VERSION 1.0.0',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10.0,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: Color(0xFF7B7488),
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitRow(
    IconData icon,
    Color bgColor,
    Color iconColor,
    String text,
  ) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 18.0),
        ),
        const SizedBox(width: 12.0),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14.0,
            color: Color(0xFF4A4456),
          ),
        ),
      ],
    );
  }
}

// ==========================================
// 2. ENTER MOBILE NUMBER VIEW
// ==========================================
class _PhoneInputView extends StatefulWidget {
  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onBack;
  final ValueChanged<String> onContinue;

  const _PhoneInputView({
    required this.controller,
    required this.isLoading,
    required this.onBack,
    required this.onContinue,
  });

  @override
  State<_PhoneInputView> createState() => _PhoneInputViewState();
}

class _PhoneInputViewState extends State<_PhoneInputView> {
  String? _error;

  void _validateAndSubmit() {
    final text = widget.controller.text.trim();
    if (text.length != 10) {
      setState(() {
        _error = 'Please enter a valid 10-digit mobile number';
      });
    } else {
      setState(() {
        _error = null;
      });
      widget.onContinue(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: const ValueKey('PhoneInputView'),
      clipBehavior: Clip.none,
      children: [
        Column(
          children: [
            // Custom Visual Section
            SizedBox(
              width: 240,
              height: 240,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF6100D6).withOpacity(0.04),
                      ),
                    ),
                  ),
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32.0),
                      border: Border.all(color: Colors.white, width: 3.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20.0,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28.0),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuBcjcAKGMX-Tgawh1cz70tOajWeKu4_G-P1q9ZMCcyCyLYLd-Cgc6UjOH9l2jo_GZlfgoDr5A9qf9OJ5ahJ2S5hQymGSm41osqvJ45O8d36iuIBOjA2D1KEA-3jJIoVynyMGBdmofnR7xrBnr9mhlHu8HyV2CVrRMUpGNXJco05-bh65W3rKwS2-RG_yqWf3FnDsGO9x73ay3VpxcTH_SI_fHas7GIS7kjQlPvVZeGx66CQuqWIEfCHB_QF1NQwygi2u3z2fVnMTw',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GlassCard(
                              padding: const EdgeInsets.all(6.0),
                              borderRadius: 10.0,
                              child: const Icon(
                                Icons.location_on,
                                color: Color(0xFF6100D6),
                                size: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // Typography Welcome Back Header
            const Text(
              'Welcome Back',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 4.0),
            const GradientText(
              text: 'Mall Companion',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 32.0,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.64,
              ),
            ),
            const SizedBox(height: 32.0),

            // Input Form Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                  child: Text(
                    'Enter your mobile number to continue.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ),
                Row(
                  children: [
                    // Country Picker Box
                    Container(
                      height: 60.0,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF4FF),
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          color: const Color(0xFFCCC3D9).withOpacity(0.4),
                          width: 1.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '+91',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF121C2A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    // Input TextField
                    Expanded(
                      child: Container(
                        height: 60.0,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF4FF),
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            color: _error != null
                                ? const Color(0xFFBA1A1A)
                                : const Color(0xFFCCC3D9).withOpacity(0.4),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.phone_iphone,
                              color: Color(0xFF4A4456),
                              size: 20.0,
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: TextField(
                                controller: widget.controller,
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                onChanged: (val) {
                                  if (_error != null) {
                                    setState(() {
                                      _error = null;
                                    });
                                  }
                                },
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1F2937),
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Mobile Number',
                                  hintStyle: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16.0,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                  border: InputBorder.none,
                                  counterText: '',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (_error != null) ...[
                  const SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      _error!,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.0,
                        color: Color(0xFFBA1A1A),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 28.0),

            // Continue button
            GradientButton(
              text: 'Continue',
              isLoading: widget.isLoading,
              onPressed: _validateAndSubmit,
            ),
            const SizedBox(height: 40.0),

            // Terms Footer
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.0,
                  height: 1.5,
                  color: Color(0xFF6B7280),
                ),
                children: [
                  TextSpan(text: 'By continuing, you agree to our \n'),
                  TextSpan(
                    text: 'Terms of Service',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6100D6),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(text: ' & '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6100D6),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Circular Back Button Top-Left
        Positioned(
          top: 0.0,
          left: 0.0,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFCCC3D9).withOpacity(0.2),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 6.0,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: IconButton(
              onPressed: widget.onBack,
              icon: const Icon(
                Icons.chevron_left,
                color: Color(0xFF1F2937),
                size: 20.0,
              ),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }
}

// ==========================================
// 3. OTP VERIFICATION VIEW
// ==========================================
class _OtpVerificationView extends StatelessWidget {
  final String phoneNumber;
  final int countdown;
  final bool isTimerActive;
  final bool isLoading;
  final VoidCallback onBack;
  final ValueChanged<String> onOtpChanged;
  final VoidCallback onVerify;
  final VoidCallback onResend;

  const _OtpVerificationView({
    required this.phoneNumber,
    required this.countdown,
    required this.isTimerActive,
    required this.isLoading,
    required this.onBack,
    required this.onOtpChanged,
    required this.onVerify,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: const ValueKey('OtpVerificationView'),
      clipBehavior: Clip.none,
      children: [
        Column(
          children: [
            // Visual Scene
            SizedBox(
              width: 240,
              height: 240,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF6100D6).withOpacity(0.04),
                      ),
                    ),
                  ),
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40.0),
                      border: Border.all(color: Colors.white, width: 3.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20.0,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(37.0),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuCvrEc9L815r9ZFvhOagfTQrGeoApDi679jlMcfl7gXMBIaEPS3SCp3-RraJTqJBCIgcXae3qAX-llUXyFwqcZpaaehoDRU2qM1SfPPPKdB2zyX7NvBLdQlF2CHIqmXlmNXKBENaTFqGzVEF0bXjM6wFjR2y17y_5jj4NuGN0UZgLm-ZUcCkfMxP3sV3xdUrWE_eSZkOkDa0CHo-zV6wz6N0r5qdCJrWpG-eBDoV--pVXNW8YQNrVBtekf8rlpp1uPN37QaW5PBZw',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GlassCard(
                              padding: const EdgeInsets.all(6.0),
                              borderRadius: 10.0,
                              child: const Icon(
                                Icons.verified_user,
                                color: Color(0xFF0058BE),
                                size: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // Headers
            const Text(
              'Verify Your Number',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
                color: Color(0xFF121C2A),
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Enter the 6-digit verification code sent to your mobile number.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.0,
                height: 1.4,
                color: Color(0xFF4A4456),
              ),
            ),
            const SizedBox(height: 32.0),

            // OTP Digit row
            OtpInput(
              onCompleted: (otp) {
                onOtpChanged(otp);
                onVerify();
              },
            ),
            const SizedBox(height: 36.0),

            // Timer countdown button
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF4FF),
                borderRadius: BorderRadius.circular(999.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.schedule,
                    color: Color(0xFF7B7488),
                    size: 16.0,
                  ),
                  const SizedBox(width: 6.0),
                  Text(
                    isTimerActive
                        ? '00:${countdown.toString().padLeft(2, '0')}'
                        : 'Expired',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4A4456),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12.0),

            // Resend text links
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Didn't receive the code? ",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.0,
                    color: Color(0xFF4A4456),
                  ),
                ),
                TextButton(
                  onPressed: isTimerActive || isLoading ? null : onResend,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Resend OTP',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: isTimerActive || isLoading
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF6100D6),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 36.0),

            // Verification Button
            GradientButton(
              text: 'Verify OTP',
              isLoading: isLoading,
              onPressed: onVerify,
            ),
          ],
        ),

        // Circular Back Button Top-Left
        Positioned(
          top: 0.0,
          left: 0.0,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFCCC3D9).withOpacity(0.2),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 6.0,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: IconButton(
              onPressed: onBack,
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFF6100D6),
                size: 20.0,
              ),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }
}

// ==========================================
// 4. COMPLETE PROFILE VIEW
// ==========================================
class _CompleteProfileView extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final bool isLoading;
  final void Function(String name, String email) onContinue;

  const _CompleteProfileView({
    required this.nameController,
    required this.emailController,
    required this.isLoading,
    required this.onContinue,
  });

  @override
  State<_CompleteProfileView> createState() => _CompleteProfileViewState();
}

class _CompleteProfileViewState extends State<_CompleteProfileView> {
  final _formKey = GlobalKey<FormState>();

  void _validateAndSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onContinue(
        widget.nameController.text.trim(),
        widget.emailController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        key: const ValueKey('CompleteProfileView'),
        children: [
          // Illustration Visual
          SizedBox(
            width: 240,
            height: 240,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF6100D6).withOpacity(0.04),
                    ),
                  ),
                ),
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFCCC3D9).withOpacity(0.4),
                      width: 4.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 20.0,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(90.0),
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuBUrC3zUez-dyy3OQeR6s0Wfx14PnSdQ3ENGuRXtVjwiAtgz_X1-RyEJ6oD-rGaNyKZusRyp1GYng-l-O1U-4vBqhvCnu6MeexwNFxCV4MgDsp8G6R0H8IZtvoT1G0yQWc6mvMcZjhNqQ8SHadoPKUJ0K_QZtrAyGNojCzzBUh8RgxdkmiqO9EVmaj2IWhmOHXx59UOmL1wqhwBt8RySxhpdBQ2jFRj0vTHvEHOxbECh-tqwXvScPZuMgPKYEjvLDfoTz1pHmtcSA',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Floating element 1: gift box (redeem)
                Positioned(
                  top: 16.0,
                  right: 8.0,
                  child: FloatingWidget(
                    delayFraction: 0.1,
                    offset: 8.0,
                    child: const Icon(
                      Icons.redeem,
                      color: Color(0xFF6100D6),
                      size: 36.0,
                    ),
                  ),
                ),
                // Floating element 2: shopping bag
                Positioned(
                  bottom: 16.0,
                  left: 8.0,
                  child: FloatingWidget(
                    delayFraction: 0.35,
                    offset: 8.0,
                    child: const Icon(
                      Icons.shopping_bag,
                      color: Color(0xFF0058BE),
                      size: 32.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),

          // Headers
          const Text(
            'Complete Your Profile',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 28.0,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.56,
              color: Color(0xFF121C2A),
            ),
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Tell us a little about yourself to personalize your mall experience.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15.0,
              height: 1.45,
              color: Color(0xFF4A4456),
            ),
          ),
          const SizedBox(height: 32.0),

          // Input Form Fields
          TextFormField(
            controller: widget.nameController,
            keyboardType: TextInputType.name,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.0,
              color: Color(0xFF1F2937),
            ),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person, color: Color(0xFF7B7488)),
              hintText: 'Full Name',
              hintStyle: const TextStyle(
                fontFamily: 'Inter',
                color: Color(0xFFCCC3D9),
              ),
              fillColor: const Color(0xFFEFF4FF),
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: BorderSide(
                  color: const Color(0xFFCCC3D9).withOpacity(0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: const BorderSide(
                  color: Color(0xFF6100D6),
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: const BorderSide(
                  color: Color(0xFFBA1A1A),
                  width: 1.0,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: const BorderSide(
                  color: Color(0xFFBA1A1A),
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: widget.emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Please enter your email address';
              }
              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
              if (!emailRegex.hasMatch(val.trim())) {
                return 'Please enter a valid email address';
              }
              return null;
            },
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.0,
              color: Color(0xFF1F2937),
            ),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.mail, color: Color(0xFF7B7488)),
              hintText: 'Email Address',
              hintStyle: const TextStyle(
                fontFamily: 'Inter',
                color: Color(0xFFCCC3D9),
              ),
              fillColor: const Color(0xFFEFF4FF),
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: BorderSide(
                  color: const Color(0xFFCCC3D9).withOpacity(0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: const BorderSide(
                  color: Color(0xFF6100D6),
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: const BorderSide(
                  color: Color(0xFFBA1A1A),
                  width: 1.0,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: const BorderSide(
                  color: Color(0xFFBA1A1A),
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
            ),
          ),
          const SizedBox(height: 36.0),

          // Action Button
          GradientButton(
            text: 'Continue',
            isLoading: widget.isLoading,
            onPressed: _validateAndSubmit,
          ),
          const SizedBox(height: 20.0),

          // Footer Text
          const Text(
            'You can update your profile anytime from Settings.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14.0,
              color: Color(0xFF7B7488),
            ),
          ),
        ],
      ),
    );
  }
}
