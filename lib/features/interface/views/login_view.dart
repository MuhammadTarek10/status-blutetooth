import 'package:flutter/material.dart';
import 'package:status_bluetooth/config/routes.dart';
import 'package:status_bluetooth/core/utils/app_colors.dart';
import 'package:status_bluetooth/core/utils/app_strings.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey _emailKey = GlobalKey();
  final GlobalKey _passwordKey = GlobalKey();

  late final TextEditingController _emailEditingController;
  late final TextEditingController _passwordEditingController;

  @override
  void initState() {
    super.initState();
    _emailEditingController = TextEditingController();
    _passwordEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              key: _emailKey,
              controller: _emailEditingController,
              decoration: const InputDecoration(
                hintText: AppStrings.emailHintText,
              ),
            ),
            TextFormField(
              key: _passwordKey,
              controller: _passwordEditingController,
              decoration: const InputDecoration(
                hintText: AppStrings.passwordHintText,
              ),
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.statusRoute);
                },
                child: const Text(
                  AppStrings.loginButton,
                  style: TextStyle(
                    color: AppColors.primaryColor,
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
