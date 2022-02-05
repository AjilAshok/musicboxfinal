import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:hive/hive.dart';
import 'package:musicplry/controller/songcontroller.dart';
import 'package:musicplry/favourites.dart';
import 'package:musicplry/homescreen.dart';
import 'package:musicplry/playinfgsc.dart';
import 'package:musicplry/playlistsc.dart';
import 'package:musicplry/playlistscreen.dart';
import 'package:musicplry/settings.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
  bool issearch = false;
  // int crctindex = 0;
  final pages = [
    Homescreen(),
    Playlist(),
    Favourites(),
    const Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:

          // pages[crctindex],

          GetBuilder<Songcontroler>(
        builder: (controller) => Stack(children: [
          Expanded(child: pages[controller.crctindex]),
          Align(
            alignment: Alignment.bottomLeft,
            // child: bottomplayingsc(),
            child:
             Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.08,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blueGrey,),
            child: BottomPlayingsc(),
          ),
            ),
          )
        ],),
      ),
      //  pages[crctindex]
      bottomNavigationBar: GetBuilder<Songcontroler>(
        builder: (controller) => BottomNavigationBar(
            currentIndex: controller.crctindex,
            onTap: (index) {
             
              controller.bootomindex(index);
              
            },
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: Colors.white,
            selectedItemColor: Color(0xFFEF7C8E),
            backgroundColor: Colors.black,
            elevation: 0,
            showUnselectedLabels: true,
            // ignore: prefer_const_literals_to_create_immutables
            items: [
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.playlist_add), label: 'Playlist'),
              const BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.heart), label: 'Favourites'),
              const BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.cog), label: 'Settings'),
            ]),
      ),
    );
  }
}
