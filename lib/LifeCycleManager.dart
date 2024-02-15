import 'package:flutter/material.dart';
import 'package:loginusingsharedpref/locator.dart';
import 'package:loginusingsharedpref/services/background_process.dart';
import 'package:loginusingsharedpref/services/location_service.dart';
import 'package:loginusingsharedpref/services/stoppable_service.dart';

class LifeCycleManager extends StatefulWidget {
  final Widget child;
  const LifeCycleManager({super.key, required this.child});

  @override
  State<LifeCycleManager> createState() => _LifeCycleManagerState();
}

class _LifeCycleManagerState extends State<LifeCycleManager> with WidgetsBindingObserver{

  //Get all Services

  List<StoppableService> servicesToManage = [
    Locator<LocationServices>(),
    Locator<backgroundFetchProcess>(),
  ];
  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose(){
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    servicesToManage.forEach((service) {
      if(service== AppLifecycleState.resumed){
        service.start();
      }
      else{
        service.stop();
      }
    });
    print('state = $state');
    //if background stop
    //if foreground start
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
    );
  }
}
