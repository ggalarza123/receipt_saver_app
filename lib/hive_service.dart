import 'dart:typed_data';import 'package:hive/hive.dart';
import 'package:receipt_saver_app/database_adapter.dart';

class HiveService extends DatabaseAdapter{
  @override
  Future<List<Uint8List>> getImages() async {
    var box = await Hive.openBox('imageBox');
    List<dynamic> result = box.get('images');

    return result.cast<Uint8List>();
    throw UnimplementedError();
  }

  // we will store the U8list here
  @override
  Future<void> storeImage(Uint8List imageBytes) async{
    List<Uint8List> images = [];

    var box = await Hive.openBox('imageBox');

    List<dynamic>? allImages = box.get("images");

    if(allImages != null) {
      images.addAll(allImages.cast<Uint8List>());
    }

    images.add(imageBytes);
    box.put("images", images);

    throw UnimplementedError();
  }



}