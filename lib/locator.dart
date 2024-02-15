import 'package:get_it/get_it.dart';
import 'package:loginusingsharedpref/services/background_process.dart';
import 'package:loginusingsharedpref/services/location_service.dart';

GetIt Locator = GetIt.instance;

void setupLocator(){
  Locator.registerLazySingleton(() => LocationServices());
  Locator.registerLazySingleton(() => backgroundFetchProcess());
}

