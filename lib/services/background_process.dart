import 'package:loginusingsharedpref/services/location_service.dart';

class backgroundFetchProcess extends LocationServices{
  void start(){
    super.start();
    print("Background Fetch Process Started $serviceStopped");
  }
  void stop(){
    super.stop();
    print("Background Fetch Process Stopped $serviceStopped");
  }
}