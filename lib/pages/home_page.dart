import 'dart:convert';
import 'dart:io';

import 'package:absensi/common/my_color.dart';
import 'package:absensi/helper/helper.dart';
import 'package:absensi/offline/absen_page_offline.dart';
import 'package:absensi/offline/configpage.dart';
import 'package:absensi/pages/absen_page.dart';
import 'package:absensi/pages/absenteman.dart';
import 'package:absensi/pages/navigasi.dart';
import 'package:absensi/pages/rekap_absen.dart';
import 'package:absensi/pages/scanqrcode.dart';
import 'package:absensi/pages/setlokasi.dart';
import 'package:absensi/pdfview/pdf_view.dart';
import 'package:absensi/services/auth/hak_akses_service.dart';
import 'package:absensi/services/berita/berita_service.dart';
import 'package:absensi/webview/web_view_page.dart';
import 'package:absensi/widgets/my_appbar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> widgets = [];
  List<Widget> widgets2 = [];
  List<Widget> tempkegiatan = [];
  String? _deviceId;
  String? nik;
  String? Kduser;
  String? status;
  File? _filePath;
  bool _filexists = false;
  bool _buttonteman = false;
  bool visibility = false;
  bool visibilitylokasi = false;
  bool visibilityQrCode = false;
  bool ActiveConnection = false;
  bool datakegiatan = true;
  bool? buttondisabled = false;
  bool? buttonvisible = false;
  bool? Ada_gambar = true;

  Future<void> _getId() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;

        setState(() {
          _deviceId = build.version.release;

          var parts = _deviceId!.split('.');
          var prefix = parts[0].trim();
          var myInt = int.parse(prefix);
          assert(myInt is int);
          if (myInt <= 6) {
            buttondisabled = false;
          } else {
            buttondisabled = true;
          }
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


  void tampildataBerita() async {
    List<Widget> tempWidget = [];
    var berita = Berita();

    berita.berita().then((value) {
      List<dynamic> body = value!["body"];

      body.forEach((element) async {
        String UrlGambar = element!["url_gambar"].toString();
        String Waktu = element!["waktu"].toString();
        String Deskripsi = element!["deskripsi"].toString();
        String Judul = element!["judul"].toString();
        String UrlBerita = element!["url_berita"].toString();

        tempWidget.add(
          Container(
            width: 300,
            child: Card(
              color: Colors.white70,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(9),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Image.network(
                    '$UrlGambar',
                    fit: BoxFit.fill,
                    width: 250,
                    height: 110,
                  )
                  ,
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '$Judul',
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          color: MyColor.orange1,
                          fontWeight: FontWeight.w800,
                          fontSize: 10),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '$Deskripsi',
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                      maxLines: 3,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("$Waktu", style: const TextStyle(fontSize: 8)),
                        SizedBox(
                          width: 120,
                          height: 30,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                              backgroundColor: MyColor.orange1,
                            ).copyWith(
                                elevation: ButtonStyleButton.allOrNull(0.0)),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: false)
                                  .push(MaterialPageRoute(
                                  builder: (context) => WebViewExample(
                                    value: UrlBerita,
                                  ),
                                  maintainState: false));
                            },
                            child: const Text(
                              'Selengkapnya',
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w500),
                            ),
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
      });
      setState(() {
        widgets = tempWidget;
      });
    });
  }

  void tampildataKegiatan() {
    List<Widget> _kegiatan = [];
    var kegiatan = Berita();
    kegiatan.kegiatan().then((value) {
      List<dynamic> body = value!["body"];

      body.forEach((element) {
        String Judul = element!["judul"].toString();
        String url = element!["url_pdf"].toString();
        String tst = element!["tst"].toString();
        _kegiatan.add(Container(
          width: 40,
          height: 110,
          color: MyColor.orange1,
          child: GestureDetector(
            onTap: () {
              if (url != '') {
                Navigator.of(context, rootNavigator: false)
                    .push(MaterialPageRoute(
                    builder: (context) => PdfView(
                      value: "$url",
                    ),
                    maintainState: false));
              }
            },
            child: Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(9),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("$tst"),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "$Judul",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
      });

      setState(() {
        tempkegiatan = _kegiatan;
      });
    });
  }

  void HakAksesMobile() {
    var hak = HakAkses();

    hak.hakaksesmobile().then((value) {
      List body = value!["body"];
      if (body.contains("Absensi")) {
        setState(() {
          visibility = true;
        });
      }
      if (body.contains("Setel Lokasi Absen")) {
        setState(() {
          visibilitylokasi = true;
        });
      }
    });
  }

  void HakAksesWeb() {
    var hak = HakAkses();

    hak.hakaksesweb().then((value) {
      List body = value!["body"];
      if (body.contains("Validasi")) {
        setState(() {
          visibilityQrCode = true;
        });
      }
    });
  }

  void _statusabsenteman() {
    var statusabsentmn = HakAkses();
    statusabsentmn.statusabsenteman().then((value) {
      setState(() {
        _buttonteman = value!;
      });
    });
  }

  Future _refresh() async {

    await Helper().read().then((value) {
      setState(() {
        _filexists = value;
      });
    });
    await Future.delayed(const Duration(seconds: 2));
   await Helper().CheckUserConeection().then((value) {
      setState(() {
        ActiveConnection = value!;
      });
    });
    setState(() {
      if (ActiveConnection == true) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => const Navigasi()));
      } else {
        if (_filexists == false && ActiveConnection == false) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const ConfigPage()));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const AbsenPageOffline()));
        }
      }
    });
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future _Helper() async {
    Helper().CheckUserConeection().then((value) {
      setState(() {
        ActiveConnection = value!;
      });
    });
    Helper().checkstatusconfig().then((value) {
      setState(() {
        status = value;
      });
    });
  }

  Future<void> readJson() async {
    final path = await _localPath;
    final storage = GetStorage();
    final file = File('$path/config.json');
    final String response = await file.readAsString();

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String decoded = stringToBase64.decode(response);
    String decoded2 = stringToBase64.decode(decoded);
    final data = await json.decode(decoded2);

    setState(() {
      nik = data["nik"];
      Kduser = data["kdUser"];
      bool isLogin = storage.hasData('kdUser');
      if (!isLogin) {
        storage.write("nik", nik);
        storage.write("kdUser", Kduser);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _statusabsenteman();
    tampildataBerita();
    HakAksesMobile();
    HakAksesWeb();
    tampildataKegiatan();
    _Helper();
    _getId();
    readJson();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: RefreshIndicator(
            color: Colors.white,
            backgroundColor: Colors.blue,
            onRefresh: _refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  const MyAppBar(),
                  const SizedBox(height: 34),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 1,
                          // Shadow position
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: <Widget>[
                        Container(
                            height: 100,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: <Widget>[
                                Visibility(
                                  visible: visibility,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context,
                                          rootNavigator: false)
                                          .push(MaterialPageRoute(
                                          builder: (context) =>
                                          const AbsenPage(),
                                          maintainState: false));
                                    },
                                    child: Ink(
                                      height: 100,
                                      width: 100,
                                      child: const Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(9),
                                          ),
                                        ),
                                        color: MyColor.orange1,
                                        elevation: 8,
                                        shadowColor: Colors.white,
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              FluentIcons
                                                  .calendar_day_24_filled,
                                              size: 30,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              '\nAbsensi',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: visibility,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context,
                                          rootNavigator: false)
                                          .push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                              const RekapAbsen(),
                                              maintainState: false));
                                    },
                                    child: Container(
                                      height: 100,
                                      width: 100,
                                      child: const Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(9),
                                          ),
                                        ),
                                        color: MyColor.orange1,
                                        elevation: 8,
                                        shadowColor: Colors.white,
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              FluentIcons
                                                  .document_text_24_filled,
                                              size: 30,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              'Rekap\nAbsen',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: _buttonteman!,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context,
                                          rootNavigator: false)
                                          .push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AbsenTeman(),
                                              maintainState: false));
                                    },
                                    child: Container(
                                      height: 100,
                                      width: 100,
                                      child: const Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(9),
                                          ),
                                        ),
                                        color: MyColor.orange1,
                                        elevation: 8,
                                        shadowColor: Colors.white,
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              FluentIcons.people_add_24_filled,
                                              size: 30,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              'Absen\nTeman',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: visibilitylokasi,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context,
                                          rootNavigator: false)
                                          .push(MaterialPageRoute(
                                          builder: (context) => const SetLokasi(),
                                          maintainState: false));
                                    },
                                    child: Container(
                                      height: 100,
                                      width: 100,
                                      child: const Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(9),
                                          ),
                                        ),
                                        color: MyColor.orange1,
                                        elevation: 8,
                                        shadowColor: Colors.white,
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              FluentIcons.location_20_filled,
                                              size: 30,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              'Setel\nLokasi',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: buttondisabled!
                                      ? visibilityQrCode
                                      : buttonvisible!,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                        const QrCodePage(),
                                      ));
                                    },
                                    child: Container(
                                      height: 100,
                                      width: 100,
                                      child: const Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(9),
                                          ),
                                        ),
                                        color: MyColor.orange1,
                                        elevation: 8,
                                        shadowColor: Colors.white,
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              FluentIcons.qr_code_24_filled,
                                              size: 30,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              'Login\nQrCode',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: const BoxDecoration(
                      color: MyColor.orange1,
                      // : Colors.orange,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 1,
                          // Shadow position
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: <Widget>[
                        const Text(
                          'Pemberitahuan',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 10),
                        Container(
                            height: 150,
                            child: ListView(
                              scrollDirection: Axis.vertical,
                              children: tempkegiatan,
                            )
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Berita',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        // topLeft: Radius.circular(10),
                        // topRight: Radius.circular(10),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 1,
                          // Shadow position
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: <Widget>[
                        Container(
                            height: 250,
                            child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: widgets)
                        ),
                      ],
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
