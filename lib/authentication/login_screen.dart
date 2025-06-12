import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unibites/pages/main_page.dart';
import 'package:unibites/resources/color.dart';
import 'package:unibites/resources/dimension.dart';
import 'package:unibites/resources/string.dart';
import 'package:unibites/authentication/signup_screen.dart';
import 'package:unibites/screens/privacy_policy.dart';
import 'package:unibites/screens/terms_of_use.dart';
import '../widgets/agreement_dialog.dart';
import '../widgets/loading_widget.dart';
import 'auth.dart';
import 'email_verification_login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isChecked = false;
  bool _obscureText = true;
  bool _isLoading = false;

  // Add the Auth instance here
  final Auth _auth = Auth();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Method to save login state
  // Method to save login state
  Future<bool> _saveLoginState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('loggedin', true);
      // Save the email address
      await prefs.setString('userEmail', _emailController.text.trim());
      if (kDebugMode) {
        print('Login state and email saved to SharedPreferences');
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error saving login state: $e');
      }
      // Show error to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save login state. Please try again.')),
        );
      }
      return false;
    }
  }

  // New method to handle login process
  Future<void> _handlePressed() async {
    // Hide keyboard first
    _dismissKeyboard();

    // Validate form first
    if (!_formKey.currentState!.validate()) {
      // Form has errors, don't proceed
      return;
    }

    // Check terms agreement
    if (!_isChecked) {
      showCustomAlertDialog(
        context,
        [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _isChecked = !_isChecked;
              });
              // Call login again after user agrees to terms
              if (_isChecked) {
                _handlePressed();
              }
            },
            child: Text('Agree',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),),
          ),
        ],
      );
      return;
    }

    // Show loading dialog only after all validations pass
    if (mounted) {
      LottieDialogExtensions.showLoading(context);
    }

    // Set loading state
    setState(() {
      _isLoading = true;
    });

    try {
      // Use Firebase auth to sign in
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Check if email is verified
      if (_auth.currentUser != null) {
        // First save login state
        bool saveSuccess = await _saveLoginState();

        if (!saveSuccess) {
          // If we couldn't save the login state, dismiss dialog and stop here
          if (mounted) {
            Navigator.of(context).pop(); // Dismiss loading dialog
          }
          return;
        }

        // Then check email verification and navigate accordingly
        if (_auth.currentUser!.emailVerified) {
          // Email is verified, navigate to MainPage
          if (mounted) {
            Navigator.of(context).pop(); // Dismiss loading dialog
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const MainPage()),
            );
          }
        } else {
          // Email is not verified, navigate to EmailVerification page
          if (mounted) {
            Navigator.of(context).pop(); // Dismiss loading dialog
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const VerifyEmailLogin()),
            );
          }
        }
      }
    } catch (e) {
      // Always dismiss the loading dialog first in case of error
      if (mounted) {
        Navigator.of(context).pop(); // Dismiss loading dialog
      }

      // Handle login errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account not found!'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }

      if (kDebugMode) {
        print('Login error: $e');
      }
    } finally {
      // Reset loading state
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide'); // Add this line
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimension.paddingDefault * 2),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 90),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimension.paddingDefault),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 14.0, right: 12),
                        child: SvgPicture.asset('assets/icons/icon-svg.svg',
                        height: 48,
                        width: 48,
                        color: Color(0xFFFFD634),),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: Text(
                              AppStrings.appName,
                              style: TextStyle(
                                  fontSize: 32,
                                  color: Colors.white,
                                fontFamily: 'Transforma Sans_Trial SemiBold',
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          Text(
                            'Enjoy Your Favourite Meal.',
                            style: TextStyle(
                                fontSize: 14,
                                height: 0.1,
                                color: Colors.white,
                                fontFamily: 'Transforma Sans_Trial',
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 75),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimension.paddingDefault),
                  child: Row(
                    children: [
                      Text(
                        'Welcome Back,',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Transforma Sans_Trial SemiBold',
                          height: 1.1,
                          fontSize: 24,
                        ),
                      )
                    ],
                  ),
                ),

                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimension.paddingDefault),
                      child: Text(
                        textAlign: TextAlign.left,
                        AppStrings.loginGuide,
                        style: TextStyle(
                          color: AppColors.textSilver,
                          fontFamily: 'Transforma Sans_Trial',
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Email/Phone text field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimension.paddingDefault),
                  child: TextFormField(
                    controller: _emailController,
                    style: TextStyle(
                        color: Colors.white,
                      fontFamily: 'Transforma Sans_Trial',
                    ),
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      labelStyle: TextStyle(
                        fontFamily: 'Transforma Sans_Trial',
                        color: AppColors.textSilver
                      ),
                      hintText: 'Email Address',
                      hintStyle: const TextStyle(color: AppColors.hintTextSilver),
                      prefixIcon: const Icon(Icons.send_outlined, color: AppColors.iconSilver),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFFFD634)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email address is required';
                      }
                      // Basic email validation
                      if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16),
                // Password text field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimension.paddingDefault),
                  child: TextFormField(
                    controller: _passwordController,
                    style: TextStyle(
                        color: Colors.white,
                      fontFamily: 'Transforma Sans_Trial',
                    ),
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        fontFamily: 'Transforma Sans_Trial',
                        color: AppColors.textSilver
                      ),
                      hintText: 'Password',
                      hintStyle: TextStyle(color: AppColors.hintTextSilver),
                      prefixIcon: Icon(Icons.lock_outline, color: AppColors.iconSilver),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: AppColors.iconSilver,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFFFD634)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimension.paddingDefault + 5),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isChecked = !_isChecked;
                          });
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _isChecked ? Color(0xFFFFD634) : Colors.grey,
                              width: 1.5,
                            ),
                          ),
                          child: _isChecked
                              ? const Icon(
                            Icons.check,
                            size: 14,
                            color: Color(0xFFFFD634),
                          )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: AppColors.textSilver, fontSize: 13),
                            children: [
                              TextSpan(
                                  text: 'I confirm that I have read, consent and agree to UniBites\' ',
                                  style: TextStyle(
                                    fontFamily: 'Transforma Sans_Trial',
                                    height: 1.1
                                  )
                              ),
                              TextSpan(
                                text: 'Terms of Use',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontFamily: 'Transforma Sans_Trial',
                                  height: 1.1,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => const TermsOfUseScreen()),
                                    );
                                    if (kDebugMode) {
                                      print('Terms of Use tapped!');
                                    }
                                  },
                              ),
                              TextSpan(text: ' and ', style: TextStyle(
                                  fontFamily: 'Transforma Sans_Trial',
                                  height: 1
                              )),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    fontFamily: 'Transforma Sans_Trial',
                                    height: 1.1
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                                    );
                                    // Handle the tap event, e.g., navigate to another page
                                    if (kDebugMode) {
                                      print('Terms of Use tapped!');
                                    }
                                  },
                              ),
                              TextSpan(text: '.'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Login button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimension.paddingDefault),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handlePressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFD634),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isLoading
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: Lottie.asset(
                              'assets/animations/splash_anim.json',
                              width: 18, // Increased from 16 to be more visible
                              height: 18, // Increased from 16 to be more visible
                              fit: BoxFit.contain,
                              repeat: true,
                              animate: true, // Explicitly set animation to true
                              delegates: LottieDelegates(
                                  values: [
                                    // You can add value delegates here if needed
                                    ValueDelegate.color(['**'], value: Colors.white),
                                  ]
                              ),
                            )
                          ),
                          SizedBox(width: 15),
                          Text(
                            'Log in',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Transforma Sans_Trial SemiBold',
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                          : Text(
                        'Log in',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Transforma Sans_Trial SemiBold',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                // Forgot password and sign up
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.only(left: AppDimension.paddingDefault * 0.1),
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Transforma Sans_Trial SemiBold',
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: AppDimension.paddingDefault * 0.1),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => const SignupScreen()),
                          );
                        },
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Transforma Sans_Trial SemiBold',
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}