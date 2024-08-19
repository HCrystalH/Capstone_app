import 'package:flutter/material.dart';

import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSwitch = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(253, 230, 235, 243),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Manage Home'),
       
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {},
          ),
        ],
      ),
      body: SizedBox(
        
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
                  dataCard("Humidity","75%",const Icon(Icons.water_drop_outlined)),
                  // Energy card
                  dataCard("Energy", "60kWh",const Icon(Icons.bolt)),
                  // Temperature card
                  dataCard("Temp", "27°C",const Icon(Icons.thermostat)),
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
                
                functionCard(context,"Smart Lightning","Bedroom",Icons.lightbulb_outline, Colors.white,Colors.blue), 

                const SizedBox(width: 10),
                functionCard(context, "Air Condition", "Living Room", Icons.air_outlined, Colors.black,const Color.fromARGB(255, 4, 223, 243)),
              
              ],),

              SizedBox(height:  MediaQuery.sizeOf(context).height/30),
              Row(children: [
                functionCard(context,"Monitor Sensor","Kitchen",Icons.thermostat, Colors.orangeAccent,Colors.white), 

                const SizedBox(width: 10),
                functionCard(context, "Air Condition", "Bed Room", Icons.air_outlined, Colors.white,Color.fromARGB(255, 109, 4, 125)),
              
              ],), 
            ],
     
        ),
        
      ),
            
      )
    );
  }


  Container functionCard(BuildContext context, content, room, IconData icon,  Color iconColor, Color backgroundColor){
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
              onTap: (){},
              onDoubleTap: (){},
              onSwipe: (){},
              value:isSwitch,
              textOn: "ON",
              textOff: "OFF",
              colorOn: Colors.greenAccent,
              colorOff: Colors.redAccent,
              iconOn: Icons.done,
              iconOff: Icons.alarm_off,
              textSize: 14,
              onChanged: (bool position){
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
}