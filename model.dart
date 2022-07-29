import 'dart:ffi';

class ImageDetails{
  late String path;
  late List<FaceDetails> faceDetails;

}
class FaceDetails{
  late String atsign;
  late String email;
  late String phone;
  late FaceCoordinates coordinates;
}
class FaceCoordinates{
  late double x1,y1,x2,y2;
}
