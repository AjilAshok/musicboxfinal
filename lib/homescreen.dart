// ignore_for_file: prefer_const_construc

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplry/bottomsheet.dart';
import 'package:musicplry/controller/songcontroller.dart';
import 'package:musicplry/database.dart';
import 'package:musicplry/favourites.dart';
import 'package:musicplry/playinfgsc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:on_audio_query/on_audio_query.dart';

List<Audio> newlis = [];
List<musicList> hivelist = [];

final assetsAudioPlayer = AssetsAudioPlayer.withId("1");

class Homescreen extends StatelessWidget {
  Homescreen({
    Key? key,
  }) : super(key: key);

  bool issearch = false;
  String search = "";
  String Searchtext = "";

  final box = Hive.box("muciss");
  // List<SongModel> fechsongsall = [];
  List favourites = [];
  
  List<SongModel> fechsongsall = [];
  final OnAudioQuery audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
  final control=  Get.put(Songcontroler());

    List _keys = box.keys.toList();
    if (_keys.where((element) => element == "fav").isNotEmpty) {
      favourites = box.get("fav");
    }
    return GetBuilder<Songcontroler>(
        initState: (state) async {
          bool permissionStatus = await audioQuery.permissionsStatus();
          if (!permissionStatus) {
            await audioQuery.permissionsRequest();

            List<SongModel> allfechsong = await audioQuery.querySongs();
            fechsongsall = allfechsong;
            // control.update();
            
            hivelist = fechsongsall
                .map((e) => musicList(
                    title: e.title,
                    uri: e.uri.toString(),
                    id: e.id,
                    duration: e.duration!.toInt()))
                .toList();
            await box.put("allSongs", hivelist);

            // addsonglist(Songcontroler());
            control.update();
          } else {
            List<SongModel> allfechsongs = await audioQuery.querySongs();
            fechsongsall = allfechsongs;
            // control.update();
            hivelist = fechsongsall
                .map((e) => musicList(
                    title: e.title,
                    uri: e.uri.toString(),
                    id: e.id,
                    duration: e.duration!.toInt()))
                .toList();
            await box.put("allSongs", hivelist);
            control.update();

            //   // addsonglist(Songcontroler());

          }
        },
        builder: (controller) => Scaffold(
              backgroundColor: Colors.grey[200],
              appBar: buildAppBar(controller),
              body: Scrollbar(
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFF41F4E), Colors.black])),
                  child: GetBuilder<Songcontroler>(
                    builder: (controller) => FutureBuilder<List<SongModel>>(
                      future: audioQuery.querySongs(),
                      builder: (context, item) {
                        if (item.data == null) {
                          return Center(child: SpinKitCircle(color: Colors.white,));
                        }
                        if (item.data!.isEmpty) {
                          return const Center(
                            child:  SpinKitCircle(color: Color.fromARGB(255, 184, 25, 25),)
                            // Text("No songs"),
                          );
                        }

                        List<SongModel> songlist = item.data!;
                        var songlists = controller.isSearch.isEmpty
                            ? hivelist.toList()
                            : hivelist
                                .where((element) => element.title
                                    .toLowerCase()
                                    .contains(controller.isSearch
                                        .toLowerCase()
                                        .toString()))
                                .toList();

                        if (songlists.isEmpty) {
                          return Center(
                            child: DefaultTextStyle(
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                ),
                                child: AnimatedTextKit(
                                  isRepeatingAnimation: true,
                                  totalRepeatCount: 10,
                                  animatedTexts: [
                                    // ScaleAnimatedText('No'),
                                    WavyAnimatedText('No Results'),
                                  ],
                                )),
                          );
                        }

                        return Column(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                  itemBuilder: (BuildContext cntx, int index) {
                                    List<String> searchTerms = [];
                                    for (var item in songlist) {
                                      searchTerms.add(item.title);
                                    }

                                    final songINdex = searchTerms
                                        .indexOf(songlists[index].title);

                                    return Container(
                                      margin: EdgeInsets.only(
                                          top: 30, right: 5, left: 5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: Colors.white60),
                                      child: ListTile(
                                          onTap: () {
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            for (var list in songlist) {
                                              newlis.add(Audio.file(
                                                  list.uri.toString(),
                                                  metas: Metas(
                                                    title: list.title,
                                                    id: list.id.toString(),
                                                  )));
                                            }
                                            controller.visible = true;
                                            Get.to(Playingsc(
                                              newMus: newlis,
                                              index: songINdex,
                                            ));
                                          },
                                          leading:
                                              buildLeading(songlist, songINdex),
                                          title: Row(children: [
                                            Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                child: Text(
                                                  songlists[index].title,
                                                  style: TextStyle(
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                )),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
                                            ),
                                            Text(
                                              getTimeString(songlist[songINdex]
                                                  .duration!
                                                  .toInt()),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
                                            ),
                                            PopupMenuButton(
                                                itemBuilder: (context) => [
                                                      PopupMenuItem(
                                                        child: InkWell(
                                                          onTap: () {
                                                            Get.back();
                                                            Get.bottomSheet(
                                                                Bottomsheet(
                                                              ind: index,
                                                            ));
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Icon(Icons.add),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text(
                                                                  'Add to playlist')
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      PopupMenuItem(
                                                        //                                             // child: Text('Add to favorites')
                                                        child: InkWell(
                                                          onTap: () async {
                                                            // Navigator.pop(context);
                                                            if (favourites
                                                                .where((element) =>
                                                                    element.id
                                                                        .toString() ==
                                                                    hivelist[
                                                                            index]
                                                                        .id
                                                                        .toString())
                                                                .isEmpty) {
                                                              favourites.add(
                                                                  hivelist[
                                                                      index]);
                                                              await box.put(
                                                                  "fav",
                                                                  favourites);
                                                              Get.back();
                                                              Get.snackbar(
                                                                  "Added to favourites",
                                                                  "",
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  colorText:
                                                                      Colors
                                                                          .white,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .green,
                                                                  animationDuration:
                                                                      const Duration(
                                                                          milliseconds:
                                                                              50),
                                                                  duration:
                                                                      const Duration(
                                                                          milliseconds:
                                                                              600));
                                                            } else {
                                                              Get.back();
                                                              print(
                                                                  "songe inside");

                                                              Get.snackbar(
                                                                  "Already add to Favourites",
                                                                  "",
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  colorText:
                                                                      Colors
                                                                          .white,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  animationDuration:
                                                                      const Duration(
                                                                          milliseconds:
                                                                              50),
                                                                  duration:
                                                                      const Duration(
                                                                          milliseconds:
                                                                              600));
                                                            }
                                                          },
                                                          child: Row(
                                                            children: const [
                                                              Icon(
                                                                FontAwesomeIcons
                                                                    .heart,
                                                                size: 20,
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text(
                                                                  'Add to Favourites')
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ]),
                                          ])),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext cntx, int index) =>
                                          // ignore: prefer_const_constructors
                                          SizedBox(
                                            height: 1,
                                          ),
                                  itemCount: songlists.length),
                            ),
                            Visibility(
                              visible: controller.visible,
                              child: SizedBox(
                                // color: Colors.amber,
                                height: 80,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ));
  }

  AppBar buildAppBar(Songcontroler controller) {
    return AppBar(
      title: controller.search
          ? Text(
              'Home',
              style: TextStyle(fontSize: 30),
            )
          : TextFormField(
              style: TextStyle(color: Colors.red),
              decoration: InputDecoration(
                hintText: "Search Songs",
                hintStyle: const TextStyle(color: Colors.white),
              ),
              onChanged: (value) {
                controller.changeSearch(value);
              },
            ),
      backgroundColor: Colors.black,
      leading: Image(
          image: AssetImage('assets/38533148948342036b1f9c9027735ce1.jpg')),
      actions: [
        GetBuilder<Songcontroler>(
          builder: (controller) => IconButton(
              onPressed: () {
                controller.showSearch();
                // setState(() {
                //   this.issearch = !this.issearch;
                // });
              },
              icon: const Icon(Icons.search)),
        )
      ],
    );
  }

  Container buildLeading(List<SongModel> songlist, int index) {
    return Container(
      height: 45,
      width: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(250),
        child: QueryArtworkWidget(
          id: songlist[index].id,
          type: ArtworkType.AUDIO,
          // prin
          nullArtworkWidget: Image(
            image: AssetImage('assets/download.jpeg'),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  getTimeString(int milisec) {
    if (milisec == null) milisec = 0;
    String min =
        "${(milisec / 60000).floor() < 10 ? 0 : ''}${(milisec / 60000).floor()}";

    String sce =
        "${(milisec / 1000).floor() % 60 < 10 ? 0 : ''}${(milisec / 1000).floor() % 60}";

    return "$min:$sce";
  }
// addsonglist(Songcon) async {
//     hivelist = fechsongsall
//         .map((e) => musicList(
//             title: e.title,
//             uri: e.uri.toString(),
//             id: e.id,
//             duration: e.duration!.toInt()))
//         .toList();
//     await box.put("allSongs", hivelist);

  // print(box);
}
