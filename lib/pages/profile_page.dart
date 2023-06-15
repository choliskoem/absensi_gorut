import 'package:absensi/common/my_color.dart';
import 'package:absensi/common/my_typhography.dart';
import 'package:absensi/pages/absenteman.dart';
import 'package:absensi/pages/navigasi.dart';
import 'package:absensi/services/gantiprofil/tambah_profil.dart';
import 'package:absensi/widgets/my_button.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';

import '../services/auth/biodata_service.dart';
import '../services/gantiprofil/ganti_profil.dart';

class DropdownModel  {
  DropdownModel(this.kdjenispegawai, this._jenisPegawai);

  String kdjenispegawai;
  String _jenisPegawai;
}


class ProfilePage extends StatefulWidget {
 const  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  DropdownModel selectedModel = new DropdownModel("Mohon tunggu", "Mohon tunggu");
  List<DropdownModel> models = [];

DropdownModel? curentitem  ;
  String? valjenis;

  String? Nama;
  String? Agama;
  String? Tl;
  String? Tgl;
  String? Jk;
  String? Status;
  bool? _button = false;

  void tampil() {
    String nama;
    String agama;
    String tl;
    String tgl;
    String jk;
    bool btn;


    var bio = BiodataService();

    bio.biodata().then((value) {
      nama = value!['namaLengkap'].toString();
      agama = value['agama'].toString();
      tl = value['tempatLahir'].toString();
      tgl = value['tanggalLahir'].toString();
      jk = value['jenisKelamin'].toString();

      setState(() {
        Nama = nama;
        Agama = agama;
        Tl = tl;
        Tgl = tgl;
        Jk = jk;
      });
    });



  }
  Future<void> jenispegawai() async {
    List<DropdownModel> listData = [];
    String status;

    var ganti = GantiProfilService();

    ganti.gantiprofil().then((value){

      status = value!['statusJenisPegawai'].toString();



      if(status == "null"){
        print('1');
        _button = true;
      }else{
        print("2");
        _button = false;
      }


      setState(() {

        Status = status;


      });
    } );

    ganti.jenispegawai().then((value) {
      value!.forEach((element) {
        // Fluttertoast.showToast(msg: "msg");
        DropdownModel data =
        new DropdownModel(element["kdJenisPegawai"], element["jenisPegawai"]);
        listData.add(data);
      });
      setState(() {
        selectedModel = listData[0];
        models = listData;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    tampil();
    jenispegawai();
  }

  @override
  Widget build(BuildContext context) {

    final box = GetStorage();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [

              CustomPaint(
                painter: HeaderCurvedContainer(),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(
                          height: 300,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                'DATA DIRI',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Visibility(
                                    visible: _button!,
                                    child: DropdownButtonHideUnderline(
                                      child:
                                      DropdownButton<DropdownModel>(

                                    hint: Text("Pilih.."),
                                        items: models.map<DropdownMenuItem<DropdownModel>>((value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            child: Text(
                                              value._jenisPegawai,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (DropdownModel? value) {

                                          setState(() {
                                            curentitem = value;

                                          });
                                        },
                                        value: curentitem ,
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: _button!,
                                    child: MyButton(
                                      onTap: () {
                                        String nik = box.read("nik");
                                          var ganti = TambahProfilService();
                                          ganti.ganti(curentitem!.kdjenispegawai, nik ).then((value){

                                            Navigator.of(context, rootNavigator: false)
                                                .pushReplacement(MaterialPageRoute(
                                              builder: (context) => const Navigasi(),
                                            ));

                                          });

                                      },
                                      color: MyColor.orange1,
                                      centerText: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 3),
                                        child:
                                        Text('Simpan'),
                                      ),
                                    ),
                                  )
                                ],
                              ),

                          Card(
                            elevation: 8,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 1)),
                            child:

                            ListTile(
                              title: Text("Status"),
                              subtitle: Text("$Status"),
                            ),
                          ),





                              Card(
                                elevation: 8,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 1)),
                                child: ListTile(
                                  title: Text("NIK"),
                                  subtitle: Text(box.read("nik")),
                                ),
                              ),
                              Card(
                                elevation: 8,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 1)),
                                child: ListTile(
                                  title: Text("NAMA LENGKAP"),
                                  subtitle: Text("$Nama"),
                                ),
                              ),
                              Card(
                                elevation: 8,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 1)),
                                child: ListTile(
                                  title: Text("TEMPAT LAHIR"),
                                  subtitle: Text("$Tl"),
                                ),
                              ),
                              Card(
                                elevation: 8,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 1)),
                                child: ListTile(
                                  title: Text("TANGGAL LAHIR"),
                                  subtitle: Text("$Tgl"),
                                ),
                              ),
                              Card(
                                elevation: 8,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 1)),
                                child: ListTile(
                                  title: Text("GENDER"),
                                  subtitle: Text("$Jk"),
                                ),
                              ),
                              Card(
                                elevation: 8,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 1)),
                                child: ListTile(
                                  title: Text("AGAMA"),
                                  subtitle: Text("$Agama"),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "PROFILE",
                      style: TextStyle(
                        fontSize: 35,
                        letterSpacing: 1.5,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 5),
                      shape: BoxShape.circle,
                      color: Colors.white,
                      image: const DecorationImage(
                        fit: BoxFit.none,
                        image: AssetImage('assets/images/kabgor.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = MyColor.orange1;
    Path path = Path()
      ..relativeLineTo(0, 180)
      ..quadraticBezierTo(size.width / 2, 225, size.width, 180)
      ..relativeLineTo(0, -180)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// return MaterialApp(
//   debugShowCheckedModeBanner: false,
//   home: Scaffold(
//     backgroundColor: Colors.white,
//     body: SafeArea(
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             Stack(
//               clipBehavior: Clip.none,
//               alignment: Alignment.center,
//               children: [
//                 Image(image: AssetImage('assets/images/saronde.jpg')),
//                 Positioned(
//                   bottom: -50.5,
//                   child: CircleAvatar(
//                     backgroundColor: Colors.white38,
//                     radius: 70,
//                     child: ClipRRect(
//                       child: Image.asset('assets/images/kabgor.png'),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             ListTile(
//               title: Text(' Nik'),
//               subtitle: Text(box.read('nik')),
//             ),
//             ListTile(
//               title: Text('Nama Lengkap'),
//               subtitle: Text('$Nama'),
//             ),
//             ListTile(
//               title: Text('Agama'),
//               subtitle: Text('$Agama'),
//             ),
//
//             ListTile(
//               title: Text('Tanggal Lahir'),
//               subtitle: Text('$Tgl'),
//             ),
//             ListTile(
//               title: Text('Tempat Lahir'),
//               subtitle: Text('$Tl'),
//             ),
//             ListTile(
//               title: Text('Gender'),
//               subtitle: Text('$Jk'),
//             ),
//
//
//
//           ],
//         ),
//       ),
//     ),
//   ),
// );
