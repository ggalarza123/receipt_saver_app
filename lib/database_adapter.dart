import 'dart:typed_data';

abstract class DatabaseAdapter {
  Future<void> storeImage(Uint8List imageBytes);

  Future<List<Uint8List>> getImages();

  Future<void> deleteImage(int index);

  Future<void> storeImageDetails(
      int index, String date, String amount, String category, String notes);
}
