import 'package:absensi/common/my_color.dart';
import 'package:absensi/spt/sptdepan.dart';
import 'package:absensi/widgets/my_appbar2.dart';
import 'package:camera/camera.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class SptPage extends StatefulWidget {
  const SptPage({Key? key}) : super(key: key);

  @override
  State<SptPage> createState() => _SptPageState();
}

class _SptPageState extends State<SptPage> {
  var size,height,width;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      body: SafeArea(
        child : SingleChildScrollView(
          child: Column(
            children: [
              const MyAppBar2(),
              const SizedBox(height: 20),
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
                child: Container(
                  height: 100,
                  child:  ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Visibility(

                        child: InkWell(
                          onTap: () async{
                            final cameras = await availableCameras();
                            await availableCameras().then((value) =>
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                           SptDepan(camera: cameras))));
                          },
                          child: Ink(
                            height: 100,
                            width: 150,
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
                                        .camera_24_filled,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    '\nTampak Depan',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight:
                                        FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(

                        child: InkWell(
                          onTap: () async{
                            final cameras = await availableCameras();
                            await availableCameras().then((value) =>
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            SptDepan(camera: cameras))));
                          },
                          child: Ink(
                            height: 100,
                            width: 150,
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
                                        .camera_24_filled,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    '\nTampak Samping',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight:
                                        FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(

                        child: InkWell(
                          onTap: () async{
                            final cameras = await availableCameras();
                            await availableCameras().then((value) =>
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            SptDepan(camera: cameras))));
                          },
                          child: Ink(
                            height: 100,
                            width: 150,
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
                                        .camera_24_filled,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    '\nTampak Jauh',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight:
                                        FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),


                    ],
                  ),




                ),
              ),

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

                child: Container(
                    height: height/2,
                  child:ListView(
                    children: [


                     Center(
                          child: Container(
                            width: width/1.2,

                            padding: const EdgeInsets.all(3),

                            child: const Column(
                              children: [
                                Text("Tampak Depan"),
                                Image(
                                  image:
                                  AssetImage("assets/images/saronde.jpg"), // jangan lupa buat folder assests dan masukkan kedalan pubscpec.yaml
                                  fit: BoxFit.fill,
                                ),
                              ],
                            ),
                          ),
                        ),
                      Center(
                        child: Container(
                          width: width/1.2,

                          padding: const EdgeInsets.all(3),

                          child: const Column(
                            children: [
                              Text("Tampak Samping"),
                              Image(
                                image:
                                AssetImage("assets/images/saronde.jpg"), // jangan lupa buat folder assests dan masukkan kedalan pubscpec.yaml
                                fit: BoxFit.fill,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: width/1.2,

                          padding: const EdgeInsets.all(3),

                          child: const Column(
                            children: [
                              Text("Tampak Jauh"),
                              Image(
                                image:
                                AssetImage("assets/images/saronde.jpg"), // jangan lupa buat folder assests dan masukkan kedalan pubscpec.yaml
                                fit: BoxFit.fill,
                              ),
                            ],
                          ),
                        ),
                      ),



                    ],
                  ),
                ),
              ),





            ],
          ),
        )
      ),
    );
  }
}
