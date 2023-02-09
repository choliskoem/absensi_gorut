import 'dart:async';
import 'dart:io' show Platform;

import 'package:absensi/common/my_color.dart';
import 'package:absensi/common/my_typhography.dart';
import 'package:absensi/pages/navigasi.dart';
import 'package:absensi/services/auth/auth_service.dart';
import 'package:absensi/widgets/my_button.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangePass extends StatefulWidget {
  const ChangePass({Key? key}) : super(key: key);

  @override
  State<ChangePass> createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  var _text = '';
  bool isLoading = true;
  bool _validatePasswordLama = false;
  bool _validatePasswordBaru = false;
  String _errorMessagePasswordLama = '';
  String _errorMessagePasswordBaru = '';
  Timer? t;
  bool obsecureText = true;
  bool obsecureText2 = true;
  final passwordlamaController = TextEditingController();
  final passwordbaruController = TextEditingController();
  String deviceId = "";
  String passwordalama = "";
  String passwordbaru = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 37),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FluentIcons.person_lock_20_filled,
                    size: 100,
                    color: MyColor.orange1,
                  ),
                  Text(
                    'Ubah Password',
                    textAlign: TextAlign.center,
                    style: MyTyphography.headingLarge,
                  ),
                  const SizedBox(height: 48),
                  TextField(
                    onChanged: (text) => setState(() => {
                          _errorMessagePasswordLama = '',
                          _validatePasswordLama = false,
                          _text
                        }),
                    controller: passwordlamaController,
                    decoration: InputDecoration(
                      errorText: _validatePasswordLama
                          ? _errorMessagePasswordLama
                          : null,
                      labelText: 'Password Lama',
                      // hintStyle: MyTyphography.texfield,
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Icon(
                        FluentIcons.lock_closed_20_regular,
                        color: MyColor.orange1,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            obsecureText2 = !obsecureText2;
                          });
                        },
                        child: Icon(obsecureText2
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
                    obscureText: obsecureText2,
                  ),
                  const SizedBox(height: 46),
                  TextField(
                    onChanged: (text) => setState(() => {
                          _errorMessagePasswordBaru = '',
                          _validatePasswordBaru = false,
                          _text
                        }),
                    controller: passwordbaruController,
                    decoration: InputDecoration(
                      errorText: _validatePasswordBaru
                          ? _errorMessagePasswordBaru
                          : null,
                      labelText: 'Password Baru',
                      // hintStyle: MyTyphography.texfield,
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Icon(
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
                  ),
                  const SizedBox(height: 56),
                  SizedBox(
                    width: 193,
                    child: isLoading
                        ? MyButton(
                            onTap: () {
                              setState(() {
                                isLoading = false;
                              });
                              var auth = AuthService();
                              auth
                                  .ubahpassword(passwordlamaController.text,
                                      passwordbaruController.text)
                                  .then((value) {
                                if (value['status'] == 200) {
                                  Fluttertoast.showToast(
                                      msg: value['body']['message'].toString());
                                  Navigator.pop(context);
                                } else if (value['status'] == 401) {
                                  // Fluttertoast.showToast(
                                  //     msg: value['body']['message'].toString());
                                } else if (value['status'] == 422) {
                                  // userController.text.isEmpty ? _validate = true : _validate = false;
                                  Map<String, dynamic> errors = value['errors'];
                                  if (errors.containsKey("passwordLama")) {
                                    setState(() {
                                      _errorMessagePasswordLama =
                                          errors['passwordLama'].toString();
                                      _validatePasswordLama = true;
                                    });
                                  }
                                  if (errors.containsKey("passwordBaru")) {
                                    setState(() {
                                      _errorMessagePasswordBaru =
                                          errors['passwordBaru'].toString();
                                      _validatePasswordBaru = true;
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
                              child:
                                  Text('Ubah', style: MyTyphography.buttontypo),
                            ),
                          )
                        : Center(child: CircularProgressIndicator()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
