import 'dart:async';

import 'package:delivery/components/items/custom_button.dart';
import 'package:delivery/components/items/custom_richtext.dart';
import 'package:delivery/controller/alert_dialog.dart';
import 'package:delivery/controller/auth_controller.dart';
import 'package:delivery/styles/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  VerifyEmailState createState() => VerifyEmailState();
}

class VerifyEmailState extends State<VerifyEmail> {
  late bool _isEmailVerified;
  late User _user;

  bool _isVerifyingEmail = false;
  bool _canResendVerification = true;
  late Timer _resendTimer;
  Timer? _verificationCheckTimer;
  int _start = 60;

  @override
  void initState() {
    super.initState();
    _user = widget._user;
    _isEmailVerified = _user.emailVerified;
    _startVerificationCheckTimer();
    if (!_isEmailVerified) {
      _startResendTimer();
    }
  }

  @override
  void dispose() {
    _resendTimer.cancel();
    _verificationCheckTimer?.cancel();
    super.dispose();
  }

  void _startVerificationCheckTimer() {
    _verificationCheckTimer =
        Timer.periodic(const Duration(seconds: 1), (_) async {
      await _checkEmailVerified();
    });
  }

  Future<void> _checkEmailVerified() async {
    await _user.reload();
    final updatedUser = FirebaseAuth.instance.currentUser;
    if (updatedUser != null && updatedUser.emailVerified) {
      setState(() {
        _isEmailVerified = true;
      });
      _verificationCheckTimer?.cancel();
    }
  }

  void _startResendTimer() {
    setState(() {
      _canResendVerification = false;
      _start = 60;
    });

    const oneSec = Duration(seconds: 1);
    _resendTimer = Timer.periodic(oneSec, (timer) {
      if (_start == 0) {
        setState(() {
          _canResendVerification = true;
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  Future<void> _sendVerificationEmail() async {
    setState(() {
      _isVerifyingEmail = true;
      _canResendVerification = false;
    });

    try {
      await AuthController().sendEmailVerificationLink();
    } catch (e) {
      showPersonalizedAlert(
          context, "Error sending verification email", AlertMessageType.error);
    }

    setState(() {
      _isVerifyingEmail = false;
    });

    _startResendTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(225, 227, 226, 1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 1.0),
              Image.asset(
                "assets/email.png",
                height: 300,
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Email Verification',
                style: TextStyle(
                    color: AppColors.firebaseNavy,
                    fontSize: 26,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                "We already sent a verification link to ${_user.email}, please check your inbox.",
                style: const TextStyle(
                  color: AppColors.darker,
                  fontSize: 17,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 24.0),
              Text(
                _isEmailVerified
                    ? 'Email is verified'
                    : 'Email is not verified',
                style: TextStyle(
                  color:
                      _isEmailVerified ? Colors.greenAccent : Colors.redAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14.0),
              if (_isEmailVerified)
                AuthButton(
                    onTap: () {
                      AuthController().retrieveSession(context);
                    },
                    text: "Continue")
              else
                AuthButton(
                    onTap: () {
                      _verificationCheckTimer?.cancel();
                      _resendTimer.cancel();
                      AuthController().signOut(context);
                    },
                    text: "Sign Out"),
              _buildResendEmailVerification(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResendEmailVerification() {
    return _isVerifyingEmail || !_canResendVerification
        ? Column(
            children: [
              Text(
                "Try again in $_start seconds",
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
              ),
            ],
          )
        : CustomRichText(
            discription: "Didn't receive the verification link? ",
            text: "Resend",
            onTap: () {
              _sendVerificationEmail();
            },
          );
  }
}
