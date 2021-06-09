import 'package:image_picker/image_picker.dart';

Future<String> takeImageFromGallery() async {
  final ImagePicker imagePicker = ImagePicker();
  PickedFile image =
      await imagePicker.getImage(source: ImageSource.gallery, imageQuality: 50);

  return image.path;
}
