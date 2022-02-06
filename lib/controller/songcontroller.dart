import 'package:flutter/foundation.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'package:hive/hive.dart';
import 'package:musicplry/database.dart';
import 'package:musicplry/home.dart';
import 'package:musicplry/homescreen.dart';
import 'package:musicplry/splash.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Songcontroler extends GetxController {
  // final OnAudioQuery audioQuery = OnAudioQuery();
  final box = Hive.box("muciss");
  // List<SongModel> fechsongsall = [];
  
  // List<musicList> hivelist = [];
  bool search = true;
  String isSearch = '';
  String music = '';
  String mus = '';
  int crctindex = 0;
  bool visible = false;


  

  changeSearch(value) {
    isSearch = value;
    update();
  }

  showSearch() {
    search = !search;
    update();
  }

  playlistcreate(value) {
    music = value;
    update();
  }

  bottomplaylist(value) {
    mus = value;
    update();
  }

  bootomindex(index) {
    crctindex = index;
    update();
  }

  visilblity() {
    visible;
    update();
  }

  
  
}

class songbinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(Songcontroler());
  }
}
