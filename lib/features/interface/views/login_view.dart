import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:status_bluetooth/core/utils/app_colors.dart';
import 'package:status_bluetooth/core/utils/app_constants.dart';
import 'package:status_bluetooth/core/utils/app_strings.dart';
import 'package:http/http.dart' as http;
import 'package:status_bluetooth/features/data/api/end_points.dart';
import 'package:status_bluetooth/features/data/models/models.dart';
import 'package:status_bluetooth/features/interface/views/status_view.dart';

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

  Future<String> _login() async {
    AuthLogin authLogin = AuthLogin(key: AppStrings.authKey);
    ConditionList emailConditionList = ConditionList(
      reading: "email",
      condition: "e",
      value: _emailEditingController.text,
    );

    ConditionList passwordConditionList = ConditionList(
      reading: "password",
      condition: "e",
      value: _passwordEditingController.text,
    );

    List<ConditionList> conditionList = [
      emailConditionList,
      passwordConditionList
    ];

    LoginModel loginModel = LoginModel(
      appId: AppStrings.appID,
      limit: AppStrings.limit,
      conditionList: conditionList,
      auth: authLogin,
    );
    http.Client client = http.Client();
    final Uri url = Uri.parse(EndPoints.loginAPI);
    final response = await client.post(
      url,
      body: json.encode(
        loginModel.toJson(),
      ),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    try {
      var id = json.decode(response.body)["Result"][0]["ParticipantID"];
      log(id.toString());
      return id;
    } catch (e) {
      return "BAD";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.loginView),
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey.shade200,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                ),
                child: TextFormField(
                  key: _emailKey,
                  controller: _emailEditingController,
                  decoration: const InputDecoration(
                    hintText: AppStrings.emailHintText,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey.shade200),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                ),
                child: TextFormField(
                  key: _passwordKey,
                  controller: _passwordEditingController,
                  decoration: const InputDecoration(
                    hintText: AppStrings.passwordHintText,
                  ),
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                ),
              ),
            ),
            Divider(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final id = await _login();
                  if (id != "BAD") {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StatusView(id: id),
                      ),
                    );
                  } else {
                    AppConstants.showToast(message: AppStrings.loginFailed);
                  }
                },
                child: const Text(
                  AppStrings.loginButton,
                  style: TextStyle(
                    color: AppColors.buttonColor,
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
