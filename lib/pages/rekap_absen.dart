import 'package:absensi/common/my_color.dart';
import 'package:absensi/common/my_typhography.dart';
import 'package:absensi/services/rekapan/rekapan_service.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../widgets/my_appbar2.dart';

class RekapAbsen extends StatefulWidget {
  const RekapAbsen({Key? key}) : super(key: key);

  @override
  State<RekapAbsen> createState() => _RekapAbsenState();
}

class _RekapAbsenState extends State<RekapAbsen> {
  final box = GetStorage();

  Future _refresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => RekapAbsen()));
    });
  }

  List<Widget> widgets = [];
  late Icon iconKeluar;
  late Icon iconMasuk;

  @override
  void initState() {
    super.initState();

    _asyncMethod2();
  }

  void _asyncMethod2() {
    List<Widget> tempWidget = [];
    var rekapan = Rekapan();
    rekapan.rekapan().then((value) {
      String tahun = value!['tahun'].toString();
      String bulan = value!['bulan'].toString();
      List<dynamic> rekapanAbsen = value['rekapanAbsen'];

      rekapanAbsen!.forEach((element) {
        String tanggal = tahun + "-" + bulan + "-" + element['hari'].toString();
        String jamMasuk = "-";
        String jamKeluar = "-";

        iconKeluar = Icon(
          Icons.dangerous,
          size: 50,
          color: Colors.red,
        );
        iconMasuk = Icon(
          Icons.dangerous,
          size: 50,
          color: Colors.red,
        );
        if (element['absenKeluar'] != null) {
          switch (element['absenKeluar']['stsValid']) {
            case null:
              iconKeluar = Icon(
                Icons.question_mark_rounded,
                size: 50,
                color: Colors.grey,
              );
              break;
            case true:
              iconKeluar = Icon(
                Icons.check_circle,
                size: 50,
                color: Colors.green,
              );
              break;
            case false:
              iconKeluar = Icon(
                Icons.dangerous,
                size: 50,
                color: Colors.green,
              );
              break;
          }
          jamKeluar = element['absenKeluar']['jam'];
        }
        if (element['absenMasuk'] != null) {
          switch (element['absenMasuk']['stsValid']) {
            case null:
              iconMasuk = Icon(
                Icons.question_mark_rounded,
                size: 50,
                color: Colors.grey,
              );
              break;
            case true:
              iconMasuk = Icon(
                Icons.check_circle,
                size: 50,
                color: Colors.green,
              );
              break;
            case false:
              iconMasuk = Icon(
                Icons.dangerous,
                size: 50,
                color: Colors.green,
              );
              break;
          }
          jamMasuk = element['absenMasuk']['jam'];
        }
        // Fluttertoast.showToast(msg: ['jenisAbsensi']);
        tempWidget.add(
          Container(
            width: MediaQuery.of(context).size.width,
            height: 160,
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: MyColor.orange1,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(9),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Masuk"),
                        Text("Keluar"),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        iconMasuk,
                        Text(tanggal),
                        iconKeluar,
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(jamMasuk),
                        Text(jamKeluar),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
      setState(() {
        widgets = tempWidget;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  MyAppBar2(),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text('Detail Absen Bulan Ini',
                        style: MyTyphography.headingsplash),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.dangerous,
                                color: Colors.green,
                              ),
                              Text(" Absen Tidak Valid "),
                              // Icon(Icons.question_mark_rounded, color: Colors.grey,),
                              // Text("Absen Belum Divalidasi")
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                              Text(" Status absen valid"),
                              // Icon(Icons.dangerous, color: Colors.red,),
                              // Text("tidak absen")
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              // Icon(Icons.dangerous, color: Colors.green,),
                              // Text("Absen Tidak Valid"),
                              Icon(
                                Icons.question_mark_rounded,
                                color: Colors.grey,
                              ),
                              Text(" Absen Belum Divalidasi")
                            ],
                          ),
                          Row(
                            children: [
                              // Icon(Icons.check_circle, color: Colors.green,),
                              // Text("status absen valid"),
                              Icon(
                                Icons.dangerous,
                                color: Colors.red,
                              ),
                              Text(" Tidak absen                  ")
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RefreshIndicator(
                    color: Colors.white,
                    backgroundColor: Colors.blue,
                    onRefresh: _refresh,
                    child: Container(
                      height: MediaQuery.of(context).size.height/1.5,
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: widgets,
                        ),

                    ),
                  ),
                ],
              ),
            ),



    );
  }
}
