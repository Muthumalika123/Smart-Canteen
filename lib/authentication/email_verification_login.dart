import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unibites/authentication/login_screen.dart';
import 'package:unibites/pages/main_page.dart';
import 'package:unibites/resources/drawable.dart';
import '../resources/color.dart';
import '../resources/dimension.dart';
import '../resources/string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this import

class VerifyEmailLogin extends StatefulWidget {
  const VerifyEmailLogin({super.key});

  @override
  State<VerifyEmailLogin> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmailLogin> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _emailSent = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Start checking email verification status when widget initializes
    _checkEmailVerified();

    // Automatically send verification email when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendVerificationEmail();
    });
  }

  @override
  void dispose() {
    // Cancel timer when widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  // Setup timer to check email verification status
  void _checkEmailVerified() {
    User? user = _auth.currentUser;

    if (user == null) {
      // Navigate to login if no user
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
      return;
    }

    // Check verification status every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      // Reload user data to get current verification status
      await _auth.currentUser?.reload();
      final user = _auth.currentUser;

      if (user != null && user.emailVerified) {
        _timer?.cancel();

        // Save verification status in SharedPreferences
        await _saveEmailVerificationStatus();

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email verified successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate to login screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainPage()),
          );
        }
      }
    });
  }

  // New method to save email verification status
  Future<void> _saveEmailVerificationStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('emailverified', true);
      if (kDebugMode) {
        print('Email verification status saved to SharedPreferences');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving email verification status: $e');
      }
    }
  }

  Future<void> _sendVerificationEmail() async {
    setState(() {
      _isLoading = true;
    });

    try {
      User? user = _auth.currentUser;

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        setState(() {
          _emailSent = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification email sent! Please check your inbox.'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No user logged in. Please log in again.'),
            backgroundColor: Colors.red,
          ),
        );

        // Navigate to login screen if no user is logged in
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else if (user.emailVerified) {
        // Also save the verification status here in case user is already verified
        await _saveEmailVerificationStatus();

        // Navigate to login screen if email is already verified
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending verification email: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xFF1A1A1A),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimension.paddingDefault * 2),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimension.paddingDefault),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    AppImages.splashLogo,
                    width: 50,
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimension.paddingDefault),
                    child: Text(
                      AppStrings.appName,
                      style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimension.paddingDefault),
              child: Row(
                children: [
                  Text(
                    "Please Verify Your\nDigital Identity",
                    style: TextStyle(
                      color: Colors.white,
                      height: 1.1,
                      fontSize: 24,
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimension.paddingDefault),
                  child: Text(
                      textAlign: TextAlign.justify,
                      AppStrings.emailVerficationGuide,
                      style: TextStyle(
                        color: AppColors.textSilver,
                        height: 1.2,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),

            // Status indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimension.paddingDefault),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: _emailSent ? Colors.green : Colors.orange,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _emailSent
                          ? "Verification email sent. Once verified, you'll be redirected to login."
                          : "Click the button below to send a verification email.",
                      style: TextStyle(
                        color: _emailSent ? Colors.green : Colors.orange,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimension.paddingDefault),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _sendVerificationEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD634),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : Text(
                    _emailSent ? 'Resend Verification Email' : 'Send Verification Email',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}