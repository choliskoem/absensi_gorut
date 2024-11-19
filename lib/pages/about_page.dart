import 'package:absensi/widgets/my_appbar2.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// List<AssetImage> list = [const AssetImage(('assets/images/saronde.jpg'))];

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const MyAppBar2(),
                const SizedBox(
                  height: 10,
                ),
                CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                  ),
                  items: [
                    Image.asset('assets/images/saronde.jpg'),
                    Image.asset('assets/images/diyonumo.jfif'),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),

                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Text(
                                      'INFORMASI',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    GestureDetector(
                                      onDoubleTap: (){
                                        Fluttertoast.showToast(msg: "msg");
                                      },
                                      child: Card(
                                        elevation: 8,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 5),
                                        shape: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: Colors.white, width: 1)),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          child: Text(
                                            'Aplikasi Pemerintah Kabupaten Gorontalo Utara Berbasis Mobile yang di  beri nama Absensi Mobile, ini merupakan aplikasi yang dikembangkan oleh pemerintah Kabupaten Gorontalo Utara pada tahun 2022.',
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                            textAlign: TextAlign.justify,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 7,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Card(
                                      elevation: 8,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 5),
                                      shape: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.white, width: 1)),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: Text(
                                          'Aplikasi Absensi berbasis Mobile ini meliputi Absen Harian, Absen Tugas Luar, Absen Teman, dan Absen Sakit. Absensi Mobile bertujuan sebagai sarana untuk meningkatkan tingkat kedisiplinan pegawai. ',
                                          style: TextStyle(fontSize: 15),
                                          textAlign: TextAlign.justify,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 5,
                                        ),
                                      ),
                                    ),
                                    Card(
                                      elevation: 8,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 5),
                                      shape: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.white, width: 1)),
                                      child: const Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 15),
                                            child: Center(
                                              child: Image(
                                                  image: AssetImage(
                                                      'assets/images/kabgornew.png'),
                                                  height: 50),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Center(
                                              child: Text(
                                                  "Pemerintah Kabupaten Gorontalo Utara"),
                                            ),
                                          ),
                                        ],
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
                  ],
                ),
                // Container(
                //   width: 370,
                //   height: 150,
                //   decoration: const BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.only(
                //       topLeft: Radius.circular(12),
                //       topRight: Radius.circular(12),
                //       bottomLeft: Radius.circular(12),
                //       bottomRight: Radius.circular(12),
                //     ),
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.grey,
                //         blurRadius: 1,
                //         // Shadow position
                //       ),
                //     ],
                //   ),
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: <Widget>[
                //       Padding(
                //         padding:
                //             EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                //         child: Container(
                //           width: 345,
                //           height: 110,
                //           child: Text(
                //             'Aplikasi Pemerintah Kabupaten Gorontalo Utara Berbasis Mobile yang di  beri nama Absensi Mobile, ini merupakan aplikasi yang dikembangkan oleh pemerintah Kabupaten Gorontalo Utara pada tahun 2022.',
                //             style: TextStyle(
                //               fontSize: 15,
                //             ),
                //             textAlign: TextAlign.justify,
                //             overflow: TextOverflow.ellipsis,
                //             maxLines: 7,
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(
                //   height: 10,
                // ),
                // Container(
                //   width: 370,
                //   height: 150,
                //   decoration: const BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.only(
                //       topLeft: Radius.circular(12),
                //       topRight: Radius.circular(12),
                //       bottomLeft: Radius.circular(12),
                //       bottomRight: Radius.circular(12),
                //     ),
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.grey,
                //         blurRadius: 1,
                //         // Shadow position
                //       ),
                //     ],
                //   ),
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: <Widget>[
                //       Padding(
                //         padding:
                //             EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                //         child: Container(
                //           width: 345,
                //           height: 90,
                //           child: Text(
                //             'Aplikasi Absensi berbasis Mobile ini meliputi Absen Harian, Absen Tugas Luar, Absen Teman, dan Absen Sakit. Absensi Mobile bertujuan sebagai sarana untuk meningkatkan tingkat kedisiplinan pegawai. ',
                //             style: TextStyle(fontSize: 15),
                //             textAlign: TextAlign.justify,
                //             overflow: TextOverflow.ellipsis,
                //             maxLines: 5,
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(
                //    height: 10,
                //  ) ,
                //  Container(
                //    width: 370,
                //    height: 130,
                //    decoration: const BoxDecoration(
                //      color: Colors.white,
                //      borderRadius: BorderRadius.only(
                //        topLeft: Radius.circular(12),
                //        topRight: Radius.circular(12),
                //        bottomLeft: Radius.circular(12),
                //        bottomRight: Radius.circular(12),
                //      ),
                //      boxShadow: [
                //        BoxShadow(
                //          color: Colors.grey,
                //          blurRadius: 1,
                //          // Shadow position
                //        ),
                //      ],
                //    ),
                //    child: Column(
                //      children: [
                //        Padding(
                //          padding: const EdgeInsets.symmetric(vertical: 15),
                //          child: Center(
                //            child: Image(
                //                image: AssetImage('assets/images/kabgor.png'),
                //                height: 50),
                //          ),
                //        ),
                //        Center(
                //          child: Text("Pemerintah Kabupaten Gorontalo Utara"),
                //        ),
                //      ],
                //    ),
                //  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
