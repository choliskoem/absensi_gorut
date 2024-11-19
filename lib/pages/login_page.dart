import 'dart:io';

import 'package:absensi/common/my_color.dart';
import 'package:absensi/common/my_typhography.dart';
import 'package:absensi/offline/widget/configcontainer.dart';
import 'package:absensi/pages/navigasi.dart';
import 'package:absensi/services/auth/auth_service.dart';
import 'package:absensi/widgets/my_button.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _text = '';
  bool isLoading = true;
  bool _validateEmail = false;
  bool _validatePassword = false;
  String _errorMessageEmail = '';
  String _errorMessagePassword = '';
  bool obsecureText = true;
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  String? _deviceId;
  String? _deviceId1;
  String email = "";
  String password = "";
  List? parts;
  String? _versionapp;

  void package() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String versionapp = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    setState(() {
      _versionapp = versionapp;
    });
  }

  Future<void> _getId() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;

        setState(() {
          _deviceId = build.id;
        });
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;

        setState(() {
          _deviceId = data.identifierForVendor!;
        });
      }
    } on PlatformException {
      Fluttertoast.showToast(msg: "error");
    }
  }

  // if there is no error text

  void getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();
  }

  // ignore: non_constant_identifier_names
  Widget UsernameText() {
    return TextField(
      onChanged: (text) => setState(
          () => {_errorMessageEmail = '', _validateEmail = false, _text}),
      controller: userController,
      decoration: InputDecoration(
        errorText: _validateEmail ? _errorMessageEmail : null,
        labelText: 'Email',
        hintStyle: MyTyphography.texfield,
        fillColor: Colors.white,
        filled: true,
        prefixIcon: const Icon(
          FluentIcons.person_20_regular,
          color: MyColor.orange1,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: MyColor.orange1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: MyColor.orange1),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget PasswordText() {
    return TextField(
      onChanged: (text) => setState(
          () => {_errorMessagePassword = '', _validatePassword = false, _text}),
      controller: passwordController,
      decoration: InputDecoration(
        errorText: _validatePassword ? _errorMessagePassword : null,
        labelText: 'Password',
        // hintStyle: MyTyphography.texfield,
        fillColor: Colors.white,
        filled: true,
        prefixIcon: const Icon(
          FluentIcons.lock_closed_20_regular,
          color: MyColor.orange1,
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              obsecureText = !obsecureText;
            });
          },
          child: Icon(obsecureText
              ? FluentIcons.eye_16_regular
              : FluentIcons.eye_off_16_regular),
        ),
        // hintText: 'Password',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: MyColor.orange1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: MyColor.orange1),
        ),
      ),
      obscureText: obsecureText,
    );
  }

  // ignore: non_constant_identifier_names
  Widget LoginButton() {
    return SizedBox(
      width: 193,
      child: isLoading
          ? MyButton(
              onTap: () {
                setState(() {
                  isLoading = false;
                });
                var auth = AuthService();
                auth
                    .authService(userController.text, passwordController.text,
                        "$_deviceId".toString())
                    .then((value) {
                  if (value['status'] == 200) {
                    Navigator.of(context, rootNavigator: false)
                        .pushReplacement(MaterialPageRoute(
                      builder: (context) => const Navigasi(),
                    ));
                  } else if (value['status'] == 401) {
                    Fluttertoast.showToast(
                        msg: value['body']['message'].toString());
                  } else if (value['status'] == 422) {
                    // userController.text.isEmpty ? _validate = true : _validate = false;
                    Map<String, dynamic> errors = value['errors'];
                    if (errors.containsKey("email")) {
                      setState(() {
                        _errorMessageEmail = errors['email'].toString();
                        _validateEmail = true;
                      });
                    }
                    if (errors.containsKey("password")) {
                      setState(() {
                        _errorMessagePassword = errors['password'].toString();
                        _validatePassword = true;
                      });
                    }
                  }
                  setState(() {
                    isLoading = true;
                  });
                });
              },
              color: MyColor.orange1,
              centerText: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text('Login', style: MyTyphography.buttontypo),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void initState() {
    super.initState();
    _getId();
    getLocation();
    package();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: height,
          child: Stack(
            children: [
              Positioned(
                  height: MediaQuery.of(context).size.height / 2,
                  child: const SigninContainer()),
              const SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          SizedBox(height: height * .55),
                          UsernameText(),
                          const SizedBox(height: 20),
                          PasswordText(),
                          const SizedBox(height: 30),
                          LoginButton(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: const TextSpan(
                                  text: "SI-ABON",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: '  online',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.blue)),
                                  ],
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Text("Version : $_versionapp")
                            ],
                          ),
                          SizedBox(height: height * .050),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
