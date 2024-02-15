import 'package:loginusingsharedpref/services/stoppable_service.dart';

class LocationServices extends StoppableService{
  void start()
  {
    super.start();
    print("Location Service Started $serviceStopped");
  }

  void stop(){
    super.stop();
    print("Location Service Stopped $serviceStopped");
  }
}