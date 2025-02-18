import 'package:absensi/common/my_color.dart';
import 'package:absensi/pages/qrlokasi.dart';
import 'package:absensi/services/setlokasi/setlokasiservice.dart';
import 'package:absensi/widgets/my_appbar2.dart';
import 'package:absensi/widgets/my_button.dart';
import 'package:camera/camera.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SetLokasi extends StatefulWidget {
  const SetLokasi({Key? key}) : super(key: key);

  @override
  State<SetLokasi> createState() => _SetLokasiState();
}

class _SetLokasiState extends State<SetLokasi> {
  bool? _isButtonDisabled = false;
  String? message;

  Future _refresh() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => super.widget));
    });
  }

  void status() async {
    var service = SetelLokasi();

    service.statuslokasi().then((value) {
      setState(() {
        _isButtonDisabled = value!;
      });
    });
  }

  void set() {
    var service = SetelLokasi();
    String? _message;
    service.setellokasi().then((value) {
      _message = value["message"].toString();

      Fluttertoast.showToast(msg: "$_message");
    });
  }

  @override
  void initState() {
 
    super.initState();
    status();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              child: Column(
                children: [
                  const MyAppBar2(),
                  const SizedBox(
                    height: 250,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 38),
                    child: Container(
                      width: 300,
                      decoration:  BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          40
                            // topLeft: Radius.circular(10),
                            // topRight: Radius.circular(10),
                            ),
                        boxShadow: const [
                          BoxShadow(
                            color: MyColor.orange1,
                            blurRadius: 1,
                            // Shadow position
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      child: Column(
                        children: <Widget>[
                          const Icon(
                            FluentIcons.location_20_filled,
                            size: 100,
                            color: MyColor.orange1,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "SET LOKASI",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: 170,
                            child: _isButtonDisabled!
                                ? MyButton(
                                    onTap: () async {
                                      if (_isButtonDisabled!) {
                                        final cameras =
                                            await availableCameras();
                                        final firstCamera = cameras.first;

                                        Navigator.of(context,
                                                rootNavigator: false)
                                            .push(MaterialPageRoute(
                                                builder: (context) => QrLokasi(
                                                    camera: firstCamera),
                                                maintainState: false));
                                      }
                                    },
                                    color: MyColor.orange1,
                                    centerText: const Text("Set"),
                                  )
                                : const Center(
                                    child: Text(
                                    "Lokasi Anda Sudah Di Set",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  )),
                          ),
                        ],
                      ),
                    ),
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
