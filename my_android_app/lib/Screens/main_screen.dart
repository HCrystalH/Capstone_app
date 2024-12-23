// import '../services/mqtt_service.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:provider/provider.dart';
import '../services/mqtt_service.dart';


class MainScreen extends StatefulWidget{
  
  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}
class _MainScreenState extends State<MainScreen>{
  
  bool buttonRelay1=false,buttonRelay2= false,buttonRelay3=false,buttonRelay4=false;
  // Hard code
  String server ='io.adafruit.com';
  String username = 'kienpham';
  // String userkey = "";
  String userkey = "";
  // List<String> topics = ["data","relay1","relay2","relay3","relay4"];
  final topics = ["topic0","topic1","topic2","topic3","topic4"];
  MqttHelper? user;
  //
  List<String> values = [];
  String humidData ='',tempData ='',energyData ='',currentData = '',voltageData = '';
  Timer? timer;
  bool isConnected = false , isGetData = false;
  // bool _isLoading = true;  // using for loading page
  bool _isLoading = false;
  List<bool> listOfInitState = [false,false,false,false,false];
  // final Completer<void> _connectionCompleter = Completer<void>();

  // Call this one to avoid error setState() called after dispose
  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
  @override
  void initState() {
    super.initState();
    /*Oneshot task - Update lastest data*/
    
    /*Connect and subscribe to feeds in Mqtt server */ 
    // if(isConnected == false && mounted){
    //   subscribeToFeeds();
    //   isConnected = true;
    // }
    /* 1shot task ENDS here*/
    // Future.delayed(const Duration(seconds: 3), () {
    //   setState(() {
    //     isConnected = true; // Change the connection state
    //   });
    //   _connectionCompleter.complete(); // Complete the completer
    //   getStateOneTime();  // Call this after the connection is established
    // });
    // getStateOneTime();
  
    /* Periodically update data from server*/   
    // if(mounted== true && !isGetData){
    //   Timer?.periodic(const Duration(microseconds: 500), (timer){
    //     fetchData(topics[0]).then((data) => setState( (){
    //       if(data != "Failed to fetch Data" && data != "null"){

    //         values = data.split(",");
    //         // debugPrint(data.toString());
    //         // debugPrint(values.toString());
    //         tempData = values[0];
    //         humidData = values[1];
    //         // energyData = values[2];
    //       }
    //     }
    //     ));
    //     user!.client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
    //       final recMess = c![0].payload as MqttPublishMessage;
    //       final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    //       if(c[0].topic=='$username/feeds/${topics[1]}'){
    //         if(pt == '0' && buttonRelay1 != false){
    //           setState(() => buttonRelay1 = false);
    //         }
    //         else if(pt == '1' && buttonRelay1 != true){ setState(() => buttonRelay1 = false);}
    //       }
    //       else if(c[0].topic=='$username/feeds/${topics[2]}'){
    //         if(pt == '0' && buttonRelay2 != false){  setState(() => buttonRelay2 = false);}
    //         else if(pt == '1' && buttonRelay2 != true){ setState(() => buttonRelay2 = true);}
    //       }
    //       else if(c[0].topic=='$username/feeds/${topics[3]}'){
    //         if(pt == '0' && buttonRelay3 != false){  setState(() => buttonRelay3 = false);}
    //         else if(pt == '1' && buttonRelay3 != true){  setState(() => buttonRelay3 = true);}
    //       }
    //       else if(c[0].topic=='$username/feeds/${topics[4]}'){
    //         if(pt == '0' && buttonRelay4 != false){  {setState(() => buttonRelay4 = false);}}
    //         else if(pt == '1' && buttonRelay4 != true){ {setState(() => buttonRelay4 = true);}
    //       }
    //     }}); 
    //   });
    // }
    /* ENDS here*/
  }

 

  @override
  Widget build(BuildContext context){
  
    // return AnimatedBuilder(
    //   animation: _animationController, 
    //   builder: (context,child)
    // {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child:SizedBox(
          
        child: _isLoading? const Center(child:  CircularProgressIndicator()) 
        : Padding(
          
          padding: const EdgeInsets.only(left: 10,right:10),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hey, Crystal 👋',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                // Container(
                //   decoration: BoxDecoration(color: Colors.white , borderRadius: BorderRadius.circular(25)),
                //   padding:const EdgeInsets.only(left: 20,right: 25),
                //   child:  Row(
                  
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                   
                //     // Motion card
                //     dataCard("Humidity","$humidData %",const Icon(Icons.water_drop_outlined)),
                //     // Energy card
                //     dataCard("Energy", "$energyData kWh",const Icon(Icons.bolt)),
                //     // Temperature card
                //     dataCard("Temp", "$tempData°C",const Icon(Icons.thermostat)),
                //   ],
                // ),
                
                // ),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white , borderRadius: BorderRadius.circular(25)),
                    padding:const EdgeInsets.only(left: 20,right: 35),
                    child:  
                    Row(
                      
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                    
                        // Motion card
                        dataCard("Humidity","$humidData %",const Icon(Icons.water_drop_outlined)),
                        const SizedBox(width: 10,),
                        // Energy card
                        dataCard("Power", "$energyData kWh",const Icon(Icons.energy_savings_leaf)),
                        const SizedBox(width: 10,),
                        // Temperature card
                        dataCard("Temp", "$tempData°C",const Icon(Icons.thermostat)),
                        const SizedBox(width: 10,),
                        // Voltage card
                        dataCard("Voltage", "$voltageData V",const Icon(Icons.bolt)),
                        const SizedBox(width: 10,),
                        // Current card
                        dataCard("Current", "$currentData A",const Icon(Icons.amp_stories)),
                      ],
                    ),
                  ),
                ),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(children: [
                      screens("All devices"),
                      const SizedBox(width: 8),
                      screens("Bed room"),
                      const SizedBox(width: 8),
                      screens("Living room"), 
                      
                      const SizedBox(width: 8),
                      screens("Kitchen"),
                    
                    ],)
                  ),
                ),
                
                SizedBox(height:  MediaQuery.sizeOf(context).height/30),

                Row(children: [
                  
                  
                  functionCard(context,"Smart Lightning","Bedroom",'relay1',Icons.lightbulb_outline, Colors.white,Colors.blue), 
                  const SizedBox(width: 10),
                  functionCard(context, "Air Condition", "Living Room",'relay2', Icons.air_outlined, Colors.black,const Color.fromARGB(255, 4, 223, 243)),
                
                ],),

                SizedBox(height:  MediaQuery.sizeOf(context).height/30),
                Row(children: [
                  functionCard(context,"Monitor Sensor","Kitchen",'relay3',Icons.thermostat, Colors.orangeAccent,Colors.white), 

                  const SizedBox(width: 10),
                  functionCard(context, "Air Condition", "Bed Room", 'relay4',Icons.air_outlined, Colors.white,const Color.fromARGB(255, 109, 4, 125)),
                
                ],), 
            
              ],
      
          ),
          
        ),
              
      )
      
    );
    // );
  }

  Container functionCard(BuildContext context, content, room,String feedName, IconData icon,  Color iconColor, Color backgroundColor) {
    Switch switchName = relay1();
    Color textColor = Colors.white;
    if(room =="Living Room"|| room == "Kitchen"){
      textColor = Colors.black;
    }
    if(feedName == 'relay1'){
      switchName = relay1();
    }else if(feedName == 'relay2'){
      switchName = relay2();
    }else if(feedName == 'relay3'){
      switchName = relay3();
    }else if(feedName == 'relay4'){
      switchName = relay4();
    }
    return  Container(
      // width: MediaQuery.sizeOf(context).width/4, // Adjust width as needed
      // height: MediaQuery.sizeOf(context).height/4, // Adjust height as needed
      width: 190,
      height: 250,
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
          SizedBox(height: MediaQuery.sizeOf(context).height/20),
          Text(
            content,
            
            textAlign: TextAlign.center,
            style:  TextStyle(
              
              fontSize: 20,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            room,
            style: TextStyle(
              fontSize: 16,
              color: textColor,
            ),
          ),
          const Spacer(),
         
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Text
              (
                "State",
                style:  TextStyle(
                  fontSize: 16,
                  color: textColor,
                ),
              ),
              switchName,
          
            
            ],
          ),
        ],
      ),
    ),
    
  );
  } 

  SizedBox dataCard(name,data,Icon icon){
    return SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              icon,
              Column(
                children:[
              Text(name),
              Text(data,
              style: const TextStyle(
                color: Color.fromARGB(255, 12, 219, 67),
              ),),
                ]
              )
            ],
          ),
        ),
    );
  }
  Container screens(name){
    return Container(
      height: 40,
      width: 100,
      // padding: const EdgeInsets.only(top: 25),
      padding: const EdgeInsetsDirectional.all(10),
      decoration: BoxDecoration(color: const Color.fromRGBO(14, 0, 0, 0.49), borderRadius: BorderRadius.circular(20)),
      child: Text(name,textAlign: TextAlign.center,style: const TextStyle(color:  Color.fromARGB(255, 5, 246, 222)))
    );
}

  Switch relay1(){
    return Switch.adaptive(
      value: buttonRelay1, 
      onChanged: (bool value) async {
        buttonRelay1 = value;
        // await MqttUtilities.asyncSleep(1);
        if(mounted == true){
          setState(() {
          // buttonRelay1 = value;
          // user!.mqttConnect();
          // user!.mqttSubscribe('$username/feeds/${topics[1]}');
          if(buttonRelay1 == false){
            
            user!.mqttPublish('$username/feeds/${topics[1]}', '0');
          }else {user!.mqttPublish('$username/feeds/${topics[1]}', '1');}
        });
      }},
      activeColor: Colors.white,
      activeTrackColor: Colors.green,
      inactiveTrackColor: Colors.redAccent ,
      inactiveThumbColor: Colors.white,
    );
  }
  Switch relay2(){
    return Switch.adaptive(
      value: buttonRelay2, 
      onChanged: (bool value) async{
        if(mounted == true){
          setState(() {
            buttonRelay2 = value;
          });
        }
        await MqttUtilities.asyncSleep(1);
        if(buttonRelay2 == false){
          user!.mqttPublish('$username/feeds/${topics[2]}', '0');
        }else {user!.mqttPublish('$username/feeds/${topics[2]}', '1');}
        if(mounted == true){
          setState(() {
            buttonRelay2 = value;
          });
        }
      },
      activeColor: Colors.white,
      activeTrackColor: Colors.green,
      inactiveTrackColor: Colors.redAccent ,
      inactiveThumbColor: Colors.white,
    );
  }
  Switch relay3(){
    return Switch.adaptive(
      value: buttonRelay3, 
      onChanged: (bool value) async {
        if(mounted == true){
          setState(() {
            buttonRelay3 = value;
          });
        }
        await MqttUtilities.asyncSleep(1);
        if(buttonRelay3 == false){
          user!.mqttPublish('$username/feeds/${topics[3]}', '0');
        }else {user!.mqttPublish('$username/feeds/${topics[3]}', '1');}
       
      },
      activeColor: Colors.white,
      activeTrackColor: Colors.green,
      inactiveTrackColor: Colors.redAccent ,
      inactiveThumbColor: Colors.white,
    );
  }
  Switch relay4(){
    return Switch.adaptive(
      value: buttonRelay4, 
      onChanged: (bool value) async{
        if(mounted == true){
          setState(() {
            buttonRelay4 = value;
          });
        }
        await MqttUtilities.asyncSleep(1);
        if(buttonRelay4 == false){
          user!.mqttPublish('$username/feeds/${topics[4]}', '0');
        }else {user!.mqttPublish('$username/feeds/${topics[4]}', '1');}
       
      },
      activeColor: Colors.white,
      activeTrackColor: Colors.green,
      inactiveTrackColor: Colors.redAccent ,
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
 
  void subscribeToFeeds(){
    user = MqttHelper(serverAddress: server, userName: username, userKey: userkey);
    user!.mqttConnect();
    user!.mqttSubscribe('$username/feeds/${topics[1]}');
    user!.mqttSubscribe('$username/feeds/${topics[2]}');
    user!.mqttSubscribe('$username/feeds/${topics[3]}');
    user!.mqttSubscribe('$username/feeds/${topics[4]}');
  }
 

  Future<void> getStateOneTime() async {
  // await _connectionCompleter.future; // Wait for the connection to be established

    for (int i = 1; i <= 4; i++) {
      String data =  await fetchData(topics[i]);
      // debugPrint(data);
      setState(() {
        if (data == '0') {
          switch (i) {
            case 1:
              buttonRelay1 = false;
              break;
            case 2:
              buttonRelay2 = false;
              break;
            case 3:
              buttonRelay3 = false;
              break;
            case 4:
              buttonRelay4 = false;
              break;
          }
        } else if (data == '1') {
          switch (i) {
            case 1:
              buttonRelay1 = true;
              break;
            case 2:
              buttonRelay2 = true;
              break;
            case 3:
              buttonRelay3 = true;
              break;
            case 4:
              buttonRelay4 = true;
              break;
          }
        }
      });
    }
    
    setState(() {_isLoading = false;});
}
  @override
  void dispose() { 
    super.dispose();
    timer?.cancel();
  }
  
}

