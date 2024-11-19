import 'package:absensi/common/my_color.dart';
import 'package:absensi/common/my_typhography.dart';
import 'package:absensi/services/rekapan/rekapan_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => const RekapAbsen()));
    });
  }

  List<Widget> widgets = [];
  Icon? iconKeluar;
  Icon? iconMasuk;
  IconButton? iconButtonkeluar;
  IconButton? iconButtonmasuk;
  IconButton? iconIzin;
  IconButton? iconSakit;

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

      String st = "";
      print(st.isEmpty);

      if (rekapanAbsen.isEmpty) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  "Perhatian!!",
                  style: TextStyle(color: Colors.red),
                ),
                content: const Text("Anda belum melakukan absensi untuk bulan ini."),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("OK")),
                ],
              );
            });
      } else {
        rekapanAbsen!.forEach((element) {
          String tanggal =
              tahun + "-" + bulan + "-" + element['hari'].toString();
          String jamMasuk = "-";
          String jamKeluar = "-";

          iconButtonkeluar = IconButton(
            iconSize: 50,
            icon: const Icon(
              Icons.dangerous,
              color: Colors.red,
            ),
            onPressed: () {
              Fluttertoast.showToast(msg: 'pindah halaman');
            },
          );

          iconButtonmasuk = IconButton(
            iconSize: 50,
            icon: const Icon(
              Icons.dangerous,
              color: Colors.red,
            ),
            onPressed: () {
              // ...
            },
          );

          if (element['absenKeluar'] != null) {
            switch (element['absenKeluar']['stsValid']) {
              case null:
                iconButtonkeluar = IconButton(
                  iconSize: 50,
                  icon: const Icon(
                    Icons.question_mark_rounded,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    // ...
                  },
                );
                break;
              case true:
                iconButtonkeluar = IconButton(
                  iconSize: 50,
                  icon: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    // ...
                  },
                );
                break;
              case false:
                iconButtonkeluar = IconButton(
                  iconSize: 50,
                  icon: const Icon(
                    Icons.dangerous,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    // ...
                  },
                );
                break;
            }
            jamKeluar = element['absenKeluar']['jam'];
          }
          if (element['izinSakit'] != null) {
            switch (element['izinSakit']['jenisAbsensi']) {
              case 'izin':
                iconButtonkeluar = IconButton(
                  iconSize: 50,
                  icon: const Icon(
                    Icons.warning_rounded,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    // ...
                  },
                );
                break;
              case 'sakit':
                iconButtonkeluar = IconButton(
                  iconSize: 50,
                  icon: const Icon(
                    Icons.local_hospital,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    // ...
                  },
                );
            }
          }

          if (element['absenMasuk'] != null) {
            switch (element['absenMasuk']['stsValid']) {
              case null:
                iconButtonmasuk = IconButton(
                  iconSize: 50,
                  icon: const Icon(
                    Icons.question_mark_rounded,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    // ...
                  },
                );
                break;
              case true:
                iconButtonmasuk = IconButton(
                  iconSize: 50,
                  icon: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    // ...
                  },
                );

                break;
              case false:
                iconButtonmasuk = IconButton(
                  iconSize: 50,
                  icon: const Icon(
                    Icons.dangerous,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    // ...
                  },
                );

                break;
            }
            jamMasuk = element['absenMasuk']['jam'];
          }
          if (element['izinSakit'] != null) {
            switch (element['izinSakit']['jenisAbsensi']) {
              case 'izin':
                iconButtonmasuk = IconButton(
                  iconSize: 50,
                  icon: const Icon(
                    Icons.warning_rounded,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    // ...
                  },
                );
                break;
              case 'sakit':
                iconButtonmasuk = IconButton(
                  iconSize: 50,
                  icon: const Icon(
                    Icons.local_hospital,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    // ...
                  },
                );
            }
          }

          // Fluttertoast.showToast(msg: ['jenisAbsensi']);

          tempWidget.add(Container(
            width: MediaQuery.of(context).size.width,
            height: 160,
            child: Card(
              color: Colors.white,
              shape: const RoundedRectangleBorder(
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
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Masuk"),
                        Text("Keluar"),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        iconButtonmasuk!,
                        Text(tanggal),
                        iconButtonkeluar!,
                      ],
                    ),
                    const SizedBox(
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
          ));
        });
        setState(() {
          widgets = tempWidget;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const MyAppBar2(),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Text('Detail Absen Bulan Ini',
                  style: MyTyphography.headingsplash),
            ),
            const SizedBox(
              height: 10,
            ),
            const Row(
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
                    Row(
                      children: [
                        // Icon(Icons.check_circle, color: Colors.green,),
                        // Text("status absen valid"),
                        Icon(
                          Icons.warning_rounded,
                          color: Colors.green,
                        ),
                        Text(" Izin Valid                 ")
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
                    Row(
                      children: [
                        // Icon(Icons.check_circle, color: Colors.green,),
                        // Text("status absen valid"),
                        Icon(
                          Icons.local_hospital,
                          color: Colors.green,
                        ),
                        Text("Sakit Valid                      ")
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            RefreshIndicator(
              color: Colors.white,
              backgroundColor: Colors.blue,
              onRefresh: _refresh,
              child: Container(
                height: MediaQuery.of(context).size.height / 1.5,
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
