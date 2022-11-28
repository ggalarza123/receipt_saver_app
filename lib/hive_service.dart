import 'dart:typed_data';
import 'package:hive/hive.dart';
import 'package:receipt_saver_app/database_adapter.dart';

class HiveService extends DatabaseAdapter {
  // This function will be used to retreive the List of images but not its data
  @override
  Future<List<Uint8List>> getImages() async {
    var box = await Hive.openBox('imageBox');
    List<dynamic> result = box.get('images');
    return result.cast<Uint8List>();
  }

  // The U8list will be stored using this method, as well as create empty lists of data for each image
  @override
  Future<void> storeImage(Uint8List imageBytes) async {
    // This list will hold all images that exist at the end to be saved
    List<Uint8List> images = [];
    var box = await Hive.openBox('imageBox');
    // This list grabs all the images that exist and stores them in a list
    List<dynamic>? allImages = box.get("images");
    if (allImages != null) {
      images.addAll(allImages.cast<Uint8List>());
    }
    images.add(imageBytes);
    box.put("images", images);

    // Creates a second box within Hive and stores an empty string list that will be filled later
    var box2 = await Hive.openBox('imageDetails');
    box2.add(["", "", "", ""]);
  }

  @override
  Future<void> deleteImage(int index) async {
    List<Uint8List> images = [];
    var box = await Hive.openBox('imageBox');
    // This list grabs all the images that exist and stores them in a list
    List<dynamic>? allImages = box.get("images");
    // Remove the current image being deleted
    allImages!.removeAt(index);
    // Adds all current images to the new list
    if (allImages != null) {
      images.addAll(allImages.cast<Uint8List>());
    }
    // Save the new list of images
    box.put("images", images);

    // Open the box containing image details
    var box2 = Hive.box('imageDetails');
    // Delete the details for the image being deleted
    await box2.deleteAt(index);
    // Starting at the current image being deleted, replace it with the imagedetails above
    // Since the deleteAt function above does not auto shrink the list
    for (int i = index; i < box2.length; i++) {
      // If we are not at the end of the list, place the imagedetails one index down
      // Avoids index out of bounds
      if (i + 1 != box2.length) {
        List temp = box2.getAt(i);
        temp = box2.getAt(i + 1);
      }
    }
  }

  @override
  Future<void> storeImageDetails(int index, String date, String amount,
      String category, String notes) async {
    Hive.box('imageDetails').putAt(index, [date, amount, category, notes]);
  }
}
