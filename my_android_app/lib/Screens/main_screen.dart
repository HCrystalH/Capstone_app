import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:vibration/vibration.dart';
import 'package:my_android_app/services/database.dart';
import '../services/mqtt_service.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class MainScreen extends StatefulWidget{
  String uid,brokerServer,brokerUserName,brokerUserKey;
  MainScreen({super.key,required this.uid, required this.brokerServer,required this.brokerUserName, required this.brokerUserKey});

  @override
  State<MainScreen> createState() => _MainScreenState();
}
class _MainScreenState extends State<MainScreen> {
  
  /*____________________ Declaring Variables  _____________________*/ 
 
  // bool buttonRelay1=false,buttonRelay2= false,buttonRelay3=false,buttonRelay4=false;
  // Hard code
  late String server ="",username ="",userkey ="";
  // String server ='io.adafruit.com';
  // // String username = 'kienpham';
  // String username = 'HVVH';
  // String userkey = 'aio_Urvv98tocEDOmtPAMqsPnWt6onBo';
  
  // String userkey = "aio_Tnpj47d84kbmMCIu8SLNsBAaNdEZ";
  // List<String> topics = ["data","relay1","relay2","relay3","relay4"];
  final topics = ["topic0","topic1","topic2","topic3","topic4","topic5"];
  MqttHelper? user;
  List<String> values = [];
  List<String> listOfData = [];
  String humidData ='',tempData ='',energyData ='',currentData = '',voltageData = '', heatIndex ='';
  String notification = '';
  Timer? timer;
  bool isConnected = false , isGetData = false, isNormal = false;
  bool _isLoading = true;  // using for loading page
  bool isFetchDataSuccess = false;
  // bool _isLoading = false;
  //[0] : buttonRelay1 , [1]: buttonRelay2 ,...
  List<bool> listOfButtonRelay = [false,false,false,false];
  // final Completer<void> _connectionCompleter = Completer<void>();
  
  SupportedUser? gotuser;

  /*____________________ Declaring Variables END HERE _____________________*/ 
  //*****************************************************************\\
  // Call this one to avoid error setState() called after dispose
  @override
  void setState(fn) {
    if(mounted) {super.setState(fn);}
  }
  
  
  @override
  void initState() {
    super.initState();
    fetchUserDataFromFirebase();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    /*Connect and subscribe to feeds in Mqtt server */ 
    Timer(const Duration(seconds: 5), handleToSubscribe);
    if(isFetchDataSuccess == false){
      // If fail fetch again
      Timer(const Duration(seconds: 2), fetchUserDataFromFirebase);
      Timer(const Duration(seconds: 3), handleToSubscribe);
      getState();
    }
  }


  @override
  Widget build(BuildContext context){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child:SizedBox(
        
      child: _isLoading? const Center(child:  CircularProgressIndicator()) 
      : SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
        padding: const EdgeInsets.only(left: 10,right:10),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Text(
              //   'Hey, Crystal 👋',
              //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              // ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(color: Colors.white , borderRadius: BorderRadius.circular(25)),
                // padding:const EdgeInsets.only(left:8, right: 15),
                child:  
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // mainAxisSize: MainAxisSize.max,
                  children: [
                    // Motion card
                    dataCard("Humidity","$humidData %",const Icon(Icons.water_drop_outlined)),
              
                    // Temperature card
                    dataCard("Temp", "$tempData°C",const Icon(Icons.thermostat)),

                    // Power consumption card
                    dataCard("Power", "$energyData kWh",const Icon(Icons.energy_savings_leaf)),
                  ],
                ),
              ),
              ),
              SizedBox(height:  MediaQuery.sizeOf(context).height/60),

              // Notification 
              SafeArea(
                maintainBottomViewPadding: true,
                child: Container(
                decoration: (notification =='Normal')  ? BoxDecoration(
                  color: const Color.fromRGBO(211, 237, 218, 1),
                  borderRadius: BorderRadius.circular(25),
                  
                )  : BoxDecoration(
                  color: const Color.fromRGBO(248, 215, 218, 1),
                  borderRadius: BorderRadius.circular(25),
                ),
                padding:const EdgeInsets.only(left: 20,top: 10,right: 30,bottom: 10) ,
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height/13,
                child:  Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'The perceived temperature: ',
                          style: TextStyle(
                            fontSize: MediaQuery.sizeOf(context).width * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),  
                        Text(
                          '$heatIndex°C',
                          style: TextStyle(
                            fontSize: MediaQuery.sizeOf(context).width * 0.04,
                            fontWeight: FontWeight.bold,
                            color:(notification == 'Normal') ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Status: ',
                          style: TextStyle(
                          fontSize: MediaQuery.sizeOf(context).width * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                        ),    
                        Text(
                          notification,
                          style: TextStyle(
                            fontSize: MediaQuery.sizeOf(context).width * 0.04,
                            fontWeight: FontWeight.bold,
                            color: (notification == 'Normal') ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ) 
              ),
              ),
              SizedBox(height:  MediaQuery.sizeOf(context).height/60),
              SafeArea(
                child: Row(
                children: [
                functionCard(context,"Smart Lightning","Bedroom",'relay1',Icons.lightbulb_outline, Colors.black,const Color.fromRGBO(255, 110, 182, 0.4)), 
                SizedBox(width: MediaQuery.sizeOf(context).width/30),
                functionCard(context, "Air Conditioner", "Living Room",'relay2', Icons.air_outlined, Colors.black,const Color.fromARGB(255, 4, 223, 243)),
              ],
              ),
              ),
              SizedBox(height:  MediaQuery.sizeOf(context).height/30),
              SafeArea(
                child: Row(children: [
                functionCard(context,"Monitor Sensor","Kitchen",'relay3',Icons.thermostat, Colors.white,const Color.fromRGBO(246, 130, 69, 1)), 

                SizedBox(width: MediaQuery.sizeOf(context).width/30),
                functionCard(context, "Air Conditioner", "Bed Room", 'relay4',Icons.air_outlined, Colors.white,const Color.fromARGB(255, 109, 4, 125)),
              ],
              ),
              ),
              SizedBox(height:  MediaQuery.sizeOf(context).height/30),
            ],
          
        ),
        
      ),
      )       
    )
    );
  }

  Container functionCard(BuildContext context, content, room,String feedName, IconData icon,  Color iconColor, Color backgroundColor) {
    Switch switchName = relay("relay1");
    Color textColor = Colors.white;
    if(room =="Living Room"|| room == "Bedroom"){
      textColor = Colors.black;
    }
    if(feedName == 'relay1'){
    switchName = relay("relay1");
    }else if(feedName == 'relay2'){
      switchName = relay("relay2");
    }else if(feedName == 'relay3'){
      switchName = relay("relay3");
    }else if(feedName == 'relay4'){
      switchName = relay("relay4");
    }
    return  Container(
      width: MediaQuery.sizeOf(context).width / 2.2,
      height: MediaQuery.sizeOf(context).height/3.5,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30), // Adjust radius as needed
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
          [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: iconColor),
                Icon(Icons.wifi, color: iconColor),
              ],
            ),
          SizedBox(height: (MediaQuery.sizeOf(context).height/3.8)*0.15 ),
          Center(
            child:Text(
            content,  
            textAlign: TextAlign.center,
            style:  TextStyle(
              fontSize: MediaQuery.sizeOf(context).width * 0.04,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          ),
          Center(
            child:Text(
              room,
              style: TextStyle(
                fontSize: MediaQuery.sizeOf(context).width * 0.04,
                color: textColor,
              ),
          ),
          ),
          SizedBox(height: (MediaQuery.sizeOf(context).height/3.8)*0.25),
          Center(

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Text
              (
                "State",
                style:  TextStyle(
                  fontSize: MediaQuery.sizeOf(context).width * 0.04,
                  color: textColor,
                ),
              ),
              switchName,
            ],
          ),
          ),
        ],
      ),
    ),
    
  );
  } 

  SizedBox dataCard(name,data,Icon icon){ 
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            icon,
            SizedBox(width: MediaQuery.sizeOf(context).width*0.01,),
            Column(
              children:[
            Text(
              name,
              style: TextStyle(
                fontSize: MediaQuery.sizeOf(context).width*0.035,
                fontWeight: FontWeight.bold,
              )
            ),
            Text(data,
            style: TextStyle(
              fontSize: MediaQuery.sizeOf(context).width*0.04,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 12, 219, 67),
            ),),
              ]
            )
          ],
        ),
      ),
    );
  }
  
  Switch relay(String button){
    int index =0;
    if(button == "relay1") {index =0;}
    else if(button == "relay2"){ index =1;}
    else if(button == "relay3"){ index =2;}
    else if(button =="relay4") {index =3;}

    return Switch.adaptive(
      value:listOfButtonRelay[index], 
      onChanged: (bool value) async {
        listOfButtonRelay[index] = value;
        // await MqttUtilities.asyncSleep(1);
        if(mounted == true){
          setState(() {
            listOfButtonRelay[index] = value;
          // buttonRelay1 = value;
          // user!.mqttConnect();
          // user!.mqttSubscribe('$username/feeds/${topics[1]}');
          if(listOfButtonRelay[index] == false){
            
            user!.mqttPublish('$username/feeds/${topics[index+1]}', '0');
          }else {user!.mqttPublish('$username/feeds/${topics[index+1]}', '1');}
        });
      }},
      activeColor: Colors.white,
      activeTrackColor: Colors.green,
      inactiveTrackColor: const Color.fromRGBO(255, 0, 0, 1) ,
      inactiveThumbColor: Colors.white,
    );
  }

  Future<String> fetchData(String feedName) async{
    final String url = 'https://io.adafruit.com/api/v2/$username/feeds/$feedName';
    final headers ={
      'Authorization':'$username $userkey'
    };

    try{
      // debugPrint("Before post");
      final response = await https.get(Uri.parse(url),headers: headers).timeout(const Duration(seconds: 60));
      // debugPrint(response.statusCode.toString());
      if(response.statusCode == 200){
        // debugPrint("GETTING");
        final json =jsonDecode(response.body);
        String data = json['last_value'];
        // debugPrint(data.toString());
        return data;
      }else{
        return "Failed to fetch Data";
      }
    } on TimeoutException catch (_) {
      debugPrint("Request timed out");
      return "Request timed out"; 
    }// Handle timeout
    catch (e){
      debugPrint(e.toString());
      return "null"; 
    }
  }
 
  void subscribeToFeeds() async{
    
    // using if condition to avoid null check operator
    if(isFetchDataSuccess){
      String clientID = widget.uid.substring(1,11);
      // user = MqttHelper(serverAddress: server, userName: username, userKey: userkey);
      user = MqttHelper(serverAddress: widget.brokerServer, userName: widget.brokerUserName, userKey: widget.brokerUserKey);
      user!.mqttConnect(clientID);
      user!.mqttSubscribe('$username/feeds/${topics[0]}');
      user!.mqttSubscribe('$username/feeds/${topics[1]}');
      user!.mqttSubscribe('$username/feeds/${topics[2]}');
      user!.mqttSubscribe('$username/feeds/${topics[3]}');
      user!.mqttSubscribe('$username/feeds/${topics[4]}');
      user!.mqttSubscribe('$username/feeds/${topics[5]}');
      setState(() {isConnected = true;}); 
      handleToGetState();
    }else{
      setState(() {isConnected = false;}); 
      debugPrint("Fail to subscribe!!!");
    }
  }
 
  /*
    Function to fetch data from MQTT server
      Duration: adjustable , default: 500ms
      Listen any changes from MQTT server and update button 
  */ 
  void getState(){
    if(mounted== true && !isGetData && isFetchDataSuccess){
      user!.client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
        final recMess = c![0].payload as MqttPublishMessage;
        final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        if(c[0].topic=='$username/feeds/${topics[0]}'){
          // debugPrint(pt.toString());
          values = pt.split(',');
          for(int i=0; i < values.length;i++){
            listOfData.add(values[i]);
            setState(() {
              if(i==0) {tempData = values[i];}
              else if(i == 1) {humidData = values[i];}
              else if(i == 2) {heatIndex = values[i];}
              else if(i == 3) {
                if(values[i] == '0'){ notification = 'Normal';}
                else if(values[i] == '1'){
                  notification = 'Abnormal';
                  Vibration.vibrate(duration: 500);
                }
              }
            });
          }
          debugPrint("temp: $tempData" );
          debugPrint("Humi: $humidData" );
        }
        else if(c[0].topic=='$username/feeds/${topics[1]}'){
          if(pt == '0' && listOfButtonRelay[0] != false){
            setState(() => listOfButtonRelay[0] = false);
          }
          else if(pt == '1' && listOfButtonRelay[0] != true){ setState(() => listOfButtonRelay[0] = true);}
        }
        else if(c[0].topic=='$username/feeds/${topics[2]}'){
          if(pt == '0' && listOfButtonRelay[1] != false){  setState(() => listOfButtonRelay[1] = false);}
          else if(pt == '1' && listOfButtonRelay[1] != true){ setState(() => listOfButtonRelay[1] = true);}
        }
        else if(c[0].topic=='$username/feeds/${topics[3]}'){
          if(pt == '0' && listOfButtonRelay[2] != false){  setState(() => listOfButtonRelay[2] = false);}
          else if(pt == '1' && listOfButtonRelay[2] != true){  setState(() => listOfButtonRelay[2] = true);}
        }
        else if(c[0].topic=='$username/feeds/${topics[4]}'){
          if(pt == '0' && listOfButtonRelay[3] != false){  {setState(() => listOfButtonRelay[3] = false);}}
          else if(pt == '1' && listOfButtonRelay[3] != true){ {setState(() => listOfButtonRelay[3] = true);}
        }
        }
        else if(c[0].topic=='$username/feeds/${topics[5]}'){
          values = pt.split(',');
          debugPrint(values.toString());
          for(int i=0; i< values.length;i++){
            if(i == 2){
              setState(() =>energyData = values[i]);
            }
          }
          debugPrint("Power Consumption: $energyData");
        }
    }
    ); 
  }
}  

  Future<void> getStateOneTime() async {
  // await _connectionCompleter.future; // Wait for the connection to be established

    for (int i = 0; i <= 5; i++) {
      String data =  await fetchData(topics[i]);
      debugPrint(data);
      setState(() {
        if(data != "Failed to fetch Data"){
          if(i == 0){
            // Topic 0
            values = data.split(',');
            for(int j = 0; j<values.length; j++){
              if(j == 0) {tempData = values[0];}
              else if(j == 1){humidData = values[1];}
              else if(j == 2){heatIndex = values[2];}
              else if(j == 3){
                if(values[3] == '0') {notification = 'Normal';}
                else {notification = 'Abnormal';}
              }
            }
          }
          else if(i ==5){
            // Topic 5
            values = data.split(',');
            energyData = values[2];
            debugPrint("Power Consumption: $energyData");
          }
        }
        if (data == '0') {
          switch (i) {
            case 1:
              // buttonRelay1 = false;
              listOfButtonRelay[0] = false;
              break;
            case 2:
              // buttonRelay2 = false;
              listOfButtonRelay[1] = false;
              break;
            case 3:
              // buttonRelay3 = false;
              listOfButtonRelay[2] = false;
              break;
            case 4:
              // buttonRelay4 = false;
              listOfButtonRelay[3] = false;
              break;
          }
        } else if (data == '1') {
          switch (i) {
            case 1:
              // buttonRelay1 = true;
              listOfButtonRelay[0] = true;
              break;
            case 2:
              // buttonRelay2 = true;
              listOfButtonRelay[1] = true;
              break;
            case 3:
              // buttonRelay3 = true;
              listOfButtonRelay[2] = true;
              break;
            case 4:
              // buttonRelay4 = true;
              listOfButtonRelay[3] = true;
              break;
          }
        }
      });
      // debugPrint(listOfButtonRelay[i-1].toString());
    }
    
    setState(() {_isLoading = false;});
}
  
  void handleToGetState() async {
    if(isConnected){
      getStateOneTime();
      getState();
    }else{
      debugPrint("Not connected to get Data!!!");
    }
  }
  void handleToSubscribe(){

    // Data passed from HomeScreen
    if(widget.brokerServer != "" && widget.brokerUserName != '' && widget.brokerUserKey != ''){ 
      setState(() {isFetchDataSuccess = true;}); 
      subscribeToFeeds();
    }
  
  }
 
  Future<void> fetchUserDataFromFirebase( ) async{
    
    try{
      gotuser = SupportedUser(widget.uid);
      gotuser!.getUserInfor( 'userName').then((String result){
        if(result != "Do not have certain data!!!") {
          setState( () {
            username = result;
            widget.brokerUserName = result;
          }); 
        }
      }); // add cast to avoid incompatible type String != Future<String>
      gotuser!.getUserInfor( 'userKey').then((String result){
        // debugPrint(result);
          if(result != "Do not have certain data!!!"){ 
            setState( () {
              userkey = result;
              widget.brokerUserKey = userkey;
            }); 

          }
      });
      gotuser!.getUserInfor( 'server').then((String result){
        // debugPrint(result);
          if(result != "Do not have certain data!!!") {setState( () {
            server = result;
            widget.brokerServer = server;
          }); }
      });
    }catch (e){
      debugPrint(e.toString());
    }
  }
  
  @override
  void dispose() { 
    super.dispose();
    timer?.cancel();

  }
  
}

