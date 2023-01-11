import 'package:absensi/common/my_color.dart';
import 'package:absensi/pages/changepass_page.dart';
import 'package:absensi/pages/splashscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MyAppBar extends StatefulWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  var select;

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 19),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  // Image.network("https://rekreartive.com/wp-content/uploads/2019/03/Logo-Kabupaten-Gorontalo-Utara-INDONESIA-Original.jpg", height: 40,),
                  const Image(
                      image: AssetImage('assets/images/kabgor.png'),
                      height: 40),
                  const Text(
                    ' Kabupaten\n Gorontalo Utara',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: DropdownButtonHideUnderline(
              child: Container(
                width: 70,
                child: DropdownButton(
                  underline: Container(
                    height: 2,
                    color: MyColor.orange1,
                  ),
                  isExpanded: true,
                  hint: Text("Menu"),
                  icon: const Icon(Icons.list),
                  items: [
                    const DropdownMenuItem(value: 'Ubah Password', child: Text('Ubah Password',  overflow: TextOverflow.ellipsis,
                        maxLines: 1)),
                    // const DropdownMenuItem(value: 'Logout', child: Text('Logout',  overflow: TextOverflow.ellipsis,
                    //     maxLines: 1)),

                  ],
                  onChanged: (val) {
                    switch (val) {
                      case 'Ubah Password' :
                        Navigator.of(context, rootNavigator: true)
                            .push(MaterialPageRoute(
                            builder: (context) => ChangePass(),
                            maintainState: false));
                        break;
                      // case 'Logout':
                      //   box.remove('kdUser');
                      //   box.remove('nik');
                      //   Get.off(() => SplashScreen());
                      //   break;
                    }
                  },
                ),
              ),
            ),
          ),

          // IconButton(
          //   icon: Icon(CupertinoIcons.bars, color: MyColor.orange1),
          //   iconSize: 35 ,
          //   onPressed: (){
          //     Navigator.of(context, rootNavigator: false).push(MaterialPageRoute(
          //         builder: (context) => AbsenPage(), maintainState: false));
          //   },
          //
          //
          // ),
        ],
      ),
    );
  }
}
