import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyAppBar2 extends StatefulWidget {
  const MyAppBar2({Key? key}) : super(key: key);

  @override
  State<MyAppBar2> createState() => _MyAppBar2State();
}

class _MyAppBar2State extends State<MyAppBar2> {
  var select;

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 19),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Image(
                      image: AssetImage('assets/images/kabgornew.png'),
                      height: 40),
                  Text(
                    ' Kabupaten\n Gorontalo Utara',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
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
