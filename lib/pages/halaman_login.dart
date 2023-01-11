
import 'dart:async';
import 'dart:io' show Platform;

import 'package:absensi/common/my_color.dart';
import 'package:absensi/common/my_typhography.dart';
import 'package:absensi/pages/navigasi.dart';
import 'package:absensi/services/auth/auth_service.dart';
import 'package:absensi/widgets/my_button.dart';
import 'package:camera/camera.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

class HalamanLogin extends StatefulWidget {
  const HalamanLogin({Key? key}) : super(key: key);

  @override
  State<HalamanLogin> createState() => _HalamanLoginState();
}

class _HalamanLoginState extends State<HalamanLogin> {
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
     availableCameras();
  }
  @override
  void initState() {
    super.initState();
    _getId();
    getLocation();
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
                  const Image(
                    image: AssetImage('assets/images/kabgor.png'),
                    height: 100,
                  ),
                  Text(
                    'LOGIN',
                    textAlign: TextAlign.center,
                    style: MyTyphography.headingLarge,
                  ),
                  const SizedBox(height: 48),

                  TextField(
                    onChanged: (text) => setState(() => {
                    _errorMessageEmail = '',
                        _validateEmail = false,
                      _text
                    }),
                    controller: userController,
                    decoration: InputDecoration(
                      errorText: _validateEmail ? _errorMessageEmail : null,
                      labelText: 'Email',
                      hintStyle: MyTyphography.texfield,
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Icon(
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
                  ),

                  const SizedBox(height: 46),
                  TextField(
                    onChanged: (text) => setState(() => {
                      _errorMessagePassword = '',
                      _validatePassword = false,
                      _text
                    }),
                    controller: passwordController,
                    decoration: InputDecoration(
                      errorText: _validatePassword ? _errorMessagePassword : null,
                      labelText: 'Password',
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
                   child: isLoading ? MyButton(
                      onTap: () {
                        setState((){
                          isLoading=false;
                        });
                        var auth = AuthService();
                        auth.authService(userController.text, passwordController.text, "$_deviceId".toString())
                            .then((value) {
                              if (value['status'] == 200)  {

                                Navigator.of(context, rootNavigator: false)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (context) => const Navigasi(),
                                ));
                              }
                              else if (value['status'] == 401){
                                Fluttertoast.showToast(msg: value['body']['message'].toString() );
                              }
                              else if ( value['status'] == 422){
                                // userController.text.isEmpty ? _validate = true : _validate = false;
                                Map<String, dynamic> errors = value['errors'];
                                if(errors.containsKey("email")){
                                  setState(() {
                                    _errorMessageEmail = errors['email'].toString();
                                    _validateEmail = true;
                                  });

                                }
                                if(errors.containsKey("password")){
                                  setState((){
                                    _errorMessagePassword = errors['password'].toString();
                                    _validatePassword = true;
                                  });

                                }
                              }
                              setState((){
                                isLoading=true;
                              });

                            
                        });

                      },

                      color: MyColor.orange1,
                      centerText: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text('Login', style: MyTyphography.buttontypo),
                      ),
                    )
                       : Center(child:CircularProgressIndicator()),
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
