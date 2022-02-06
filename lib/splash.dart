import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:hive/hive.dart';
import 'package:musicplry/controller/songcontroller.dart';
import 'package:musicplry/database.dart';
import 'package:musicplry/home.dart';

class Splash extends StatelessWidget {
  Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(Songcontroler());
    return GetBuilder<Songcontroler>(
      initState: (state) async{
         await Future.delayed(const Duration(milliseconds: 3000), () {});
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => const Home()));
    Get.off(Home());
      },
      
      builder: (controller) => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 200),
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  // ignore: prefer_const_constructors
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/38533148948342036b1f9c9027735ce1.jpg'),
                  ),
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 200,
              ),
              Container(
                child: Text(
                  'MUSICBOX',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w400),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  navigatetohome() async {
    await Future.delayed(const Duration(milliseconds: 3000), () {});
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => const Home()));
    Get.off(Home());
   Songcontroler().update();
  }
}
