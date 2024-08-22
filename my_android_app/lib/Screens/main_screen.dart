// import '../services/mqtt_service.dart';
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:http/http.dart' as https;
import 'package:mqtt_client/mqtt_client.dart';
import '../services/mqtt_service.dart';
class MainScreen extends StatefulWidget{
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{
  
  bool buttonRelay1 = false;
  bool buttonRelay2 = true;
  bool buttonRelay3 = true;
  bool buttonRelay4 = false;
  // Hard code
  String server = 'io.adafruit.com';
  String username = 'HVVH';
  String userkey = 'aio_Urvv98tocEDOmtPAMqsPnWt6onBo';
 
  MqttHelper? user;
  //
  List<String> values = [];
  String humidData ='';
  String tempData ='';
  String energyData ='';
  
  @override
  void initState() {
    super.initState();
    fetchData("data").then((data) => setState( (){
      values = data.split(",");
      humidData = values[0];
      energyData = values[1];
      tempData = values[2];
    }
    ));
    
    fetchAllRelayData(buttonRelay1, 'relay1');
    fetchAllRelayData(buttonRelay2, 'relay2');
    fetchAllRelayData(buttonRelay3, 'relay3');
    fetchAllRelayData(buttonRelay4, 'relay4');

    user = MqttHelper(serverAddress: server, userName: username, userKey: userkey);
    user!.mqttConnect();
    user!.mqttSubscribe('$username/feeds/relay1');
    user!.mqttSubscribe('$username/feeds/relay2');
    user!.mqttSubscribe('$username/feeds/relay3');
    user!.mqttSubscribe('$username/feeds/relay4');
  }

  @override
  Widget build(BuildContext context){
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child:SizedBox(
          
        child: Padding(
          
          padding: const EdgeInsets.only(left: 10,right:10),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hey, Crystal 👋',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(color: Colors.white , borderRadius: BorderRadius.circular(25)),
                  padding:const EdgeInsets.only(left: 20,right: 25),
                  child:  Row(
                  
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Motion card
                    dataCard("Humidity","$humidData %",const Icon(Icons.water_drop_outlined)),
                    // Energy card
                    dataCard("Energy", "$energyData kWh",const Icon(Icons.bolt)),
                    // Temperature card
                    dataCard("Temp", "$tempData°C",const Icon(Icons.thermostat)),
                  ],
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
                  
                  functionCard(context,"Smart Lightning","Bedroom",'relay1',Icons.lightbulb_outline, Colors.white,Colors.blue, buttonRelay1), 

                  const SizedBox(width: 10),
                  functionCard(context, "Air Condition", "Living Room",'relay2', Icons.air_outlined, Colors.black,const Color.fromARGB(255, 4, 223, 243),buttonRelay2),
                
                ],),

                SizedBox(height:  MediaQuery.sizeOf(context).height/30),
                Row(children: [
                  functionCard(context,"Monitor Sensor","Kitchen",'relay3',Icons.thermostat, Colors.orangeAccent,Colors.white,buttonRelay3), 

                  const SizedBox(width: 10),
                  functionCard(context, "Air Condition", "Bed Room", 'relay4',Icons.air_outlined, Colors.white,const Color.fromARGB(255, 109, 4, 125),buttonRelay4),
                
                ],), 
            
              ],
      
          ),
          
        ),
              
      )
      
    );
  }
  Container functionCard(BuildContext context, content, room,String feedName, IconData icon,  Color iconColor, Color backgroundColor, bool isSwitch){
    Color textColor = Colors.white;
    if(room =="Living Room"|| room == "Kitchen"){
      textColor = Colors.black;
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
            LiteRollingSwitch(
              width: 100,
              onTap: () async{
                debugPrint("Tap to upload data");
                await MqttUtilities.asyncSleep(1);
                if(isSwitch == false){
                  user!.mqttPublish('$username/feeds/$feedName', '0');
                }else {user!.mqttPublish('$username/feeds/$feedName', '1');}
              },
              onDoubleTap: (){},
              onSwipe: (){},
              value: isSwitch,
              textOn: "ON",
              textOff: "OFF",
              colorOn: Colors.greenAccent,
              colorOff: Colors.redAccent,
              iconOn: Icons.done,
              iconOff: Icons.alarm_off,
              textSize: 14,
              onChanged: (bool position) async{
                isSwitch = position;
              }
            ),
           
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
              Text(data),
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

  Future<String> fetchData(String feedName) async{
    final String url = 'https://io.adafruit.com/api/v2/HVVH/feeds/$feedName';
    final headers ={
      'Authorization':'HVVH aio_Urvv98tocEDOmtPAMqsPnWt6onBo'
    };

    try{
      debugPrint("Before post");
      final response = await https.get(Uri.parse(url),headers: headers);
      if(response.statusCode == 200){
        debugPrint("GETTING");
        final json =jsonDecode(response.body);
        String data = json['last_value'];
        debugPrint(data.toString());
        return data;
      }
    }catch (e){
      debugPrint(e.toString());
      return "null"; 
    }
    return "Failed to fetch Data";
  }

  void fetchAllRelayData(bool buttonControl, String feedName){
    fetchData(feedName).then((data) => setState( (){
      if(data =="0"){
        debugPrint("check condition");
        buttonControl =false;
        }
      else{ buttonControl =true;}
    }
    ));
    debugPrint("$feedName  has button Control relay is: $buttonControl");
  }
}

