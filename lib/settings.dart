import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:musicplry/controller/songcontroller.dart';

bool isSwitched = true;

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Settings',
          style: TextStyle(fontSize: 26),
        ),
        centerTitle: true,
      ),
      body: GetBuilder<Songcontroler>(
        id: "Switch",
        builder: (_controle) => Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF30E8BF), Color(0xFFFF8235)])),
          padding: EdgeInsets.only(top: 30, left: 10),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(FontAwesomeIcons.bell),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Notification ',
                    style: const TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                  ),
                  Switch(
                    value: isSwitched,
                    onChanged: (value)  {
                      if (isSwitched == false) {
                        isSwitched = true;

                        Get.snackbar("Notification ", "Turned on",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.white,
                            backgroundColor: Colors.green,
                            animationDuration: const Duration(milliseconds: 50),
                            duration: const Duration(milliseconds: 600));
                            _controle.update(["Switch"]);
                      } else {
                        isSwitched = false;

                        Get.snackbar("Notification", "Turned off",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.white,
                            backgroundColor: Colors.red[200],
                            animationDuration: Duration(milliseconds: 50),
                            duration: const Duration(milliseconds: 600));
                             _controle.update(["Switch"]);
                      }
                     
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 25),
                child: Row(
                  children: [
                    Icon(FontAwesomeIcons.stickyNote),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Terms and Conditions',
                      style: const TextStyle(fontSize: 20),
                    ),
                    // SizedBox(
                    //   width: 150
                    // ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: InkWell(
                  onTap: () {
                    Get.to(() => Theme(
                          data: ThemeData.dark().copyWith(
                              appBarTheme: AppBarTheme(
                            color: Colors.black,
                            elevation: 0,
                          )),
                          child: LicensePage(
                            applicationIcon: Image(
                              image: AssetImage(
                                "assets/38533148948342036b1f9c9027735ce1.jpg",
                              ),
                              width: 150,
                              height: 150,
                            ),
                            applicationName: "Musicbox",
                          ),
                        ));
                  },
                  child: Row(
                    children: [
                      Icon(FontAwesomeIcons.user),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'About',
                        style: const TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.black,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: Row(
                  children: [
                    Icon(FontAwesomeIcons.appStoreIos),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Privacy and policy',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),

                    Container(
                        child: Text(
                      'Version',
                      style: const TextStyle(fontSize: 20),
                    )),
                    // ignore: prefer_const_constructors
                    Container(
                        margin: const EdgeInsets.only(
                          right: 25,
                        ),
                        child: Text(
                          '1.0.0',
                          style: const TextStyle(fontSize: 10),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
