import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:hive/hive.dart';
import 'package:musicplry/bottomsheet.dart';
import 'package:musicplry/controller/songcontroller.dart';
import 'package:musicplry/database.dart';
import 'package:musicplry/playlistscreen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Playlist extends StatelessWidget {
   Playlist({Key? key}) : super(key: key);

//   @override
//   State<Playlist> createState() => _PlaylistState();
// }

// class _PlaylistState extends State<Playlist> {
  final TextEditingController createcontroler = TextEditingController();
  String music = '';
  List<SongModel> playList = [];
  List allplaylist = [];

  final box = Hive.box("muciss");

  @override
  Widget build(BuildContext context) {
     Get.put(Songcontroler());
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Playlist',
          style: TextStyle(fontSize: 26),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF20002c), Color(0xFFE779B8)])),
        child: ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (context, Box value, child) {
            // if (allplaylist.isEmpty) {
            //   return Center(
            //     child: Text("no Results"),
            //   );
              
            // }
            
            
            List keys = box.keys.toList();
            keys.remove("allSongs");
            keys.remove("fav");
            List playlistkey = keys;
            return GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(15),
                  child: InkWell(
                    onTap: () => 
                 
                    Get.to(playlistscreen(titleName: playlistkey[index])),
                    onLongPress: () {
                      // box.delete("allSongs");
                      Get.defaultDialog(
                          title: "Delete",
                          middleText: "Are you sure",
                          textCancel: "No",
                          textConfirm: "Yes",
                          onCancel: () {
                            // Navigator.pop(context);
                            Get.back();
                          },
                          onConfirm: () {
                            box.delete(playlistkey[index]);
                            // Navigator.pop(context);
                            Get.back();
                          },
                          cancelTextColor: Colors.black,
                          confirmTextColor: Colors.black);
                    },
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      color: Colors.white,
                      child: Stack(
                        children: [
                          Center(
                            child: Image(
                                image: const AssetImage('assets/download.png'),
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                width: 100),
                          ),
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * 0.1),
                              child: Text(playlistkey[index].toString(),style: TextStyle(overflow: TextOverflow.ellipsis),),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: playlistkey.length,

              //
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GetBuilder<Songcontroler>(
        builder: (controller) => 
         Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.1),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.transparent,
            elevation: 0,
            onPressed: () {
              opendilogue(controller,context);
            },
            label: const Text(
              'Create a playlist',
              style: TextStyle(color: Colors.black),
            ),
            icon: const Icon(
              Icons.add,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Future opendilogue(Songcontroler controler,cntx) {
    final _formKey = GlobalKey<FormState>();
    return showDialog(
        context: cntx,
        builder: (context) => AlertDialog(
              title: const Text('New Playlist'),
              content: Form(
                key: _formKey,
                child: TextFormField(
                  controller: createcontroler,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter the playlist name";
                    }
                  },
                  onChanged: (value) {
                    
                    controler.playlistcreate(value);
                    
                      
                  },
                  decoration:
                      const InputDecoration(hintText: 'Create a playlist'),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)))),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await box.put(controler.music, allplaylist);
                            // Navigator.pop(context);
                            Get.back();
                            createcontroler.clear();
                            
                          }
                        },
                        child: const Text(
                          'Add',
                          style: TextStyle(color: Colors.black),
                        )),
                    ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)))),
                        onPressed: () {
                          // Navigator.pop(context);
                          Get.back();
                          createcontroler.clear();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black),
                        )),
                  ],
                )
              ],
            ));
  }
}
