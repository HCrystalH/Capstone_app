

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
// import 'package:flutter/material.dart';

// key = aio_Urvv98tocEDOmtPAMqsPnWt6onBo
 /*If cannot use log => debugprint instead*/ 

class MqttHelper {
  final String _serverAddress;  // for example : io.adafruit.com
  final String _userName, _userKey;
  
  late MqttClient client;
  
  MqttHelper({
    required String serverAddress,
    required String userName,
    required String userKey
  }) : _serverAddress = serverAddress, _userName = userName, _userKey = userKey{
    client  = MqttServerClient(_serverAddress, '1883');
  }
  
  // Methods
  void mqttConnect() async{
    client.logging(on: false);
    client.keepAlivePeriod = 60;
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;
    client.pongCallback = pong;
    // client.autoReconnect = true;
    // client.onAutoReconnect = onAutoReconnect;
    // client.onAutoReconnected = onAutoReconnected;

    final connMess = MqttConnectMessage()
      .authenticateAs(_userName, _userKey)
      .withClientIdentifier('FLUTTER_CLIENT')
      .withWillTopic('willtopic') 
      .withWillMessage('My Will message')
      .startClean() 
      .withWillQos(MqttQos.atLeastOnce);
    
    client.connectionMessage = connMess;

    try {
      print("Connecting....");
      client.keepAlivePeriod = 60;
      await client.connect();
      
    } on NoConnectionException catch (e) {
      print('Client exception: $e');
      client.disconnect();
    }

    if (isConnected()) {
      print('Adafruit connected');
    } else {
      print('Client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
    }
  }
/// The pre auto re connect callback
void onAutoReconnect() {
  print('Client auto reconnection sequence will start');
}

/// The post auto re connect callback
void onAutoReconnected() {
  print('Client auto reconnection sequence has completed');
}
  void mqttSubscribe(String subTopic) async{
    //  const subTopic = 'HCrystalH/feeds/humidity';
    print('Subscribing to the $subTopic topic');
    await MqttUtilities.asyncSleep(2);
    if( isConnected()){
      print('Connected! to Subscribe');
      client.subscribe(subTopic, MqttQos.atMostOnce);
      client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
        final recMess = c![0].payload as MqttPublishMessage;
        final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        print('Received message: topic is ${c[0].topic}, payload is $pt');
      });

      client.published!.listen((MqttPublishMessage message) {
        print('Published topic: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
      });
      // client.onMessage = (topic,message){
      //   final recMess = message.payload as MqttPublishMessage;
      //   final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      //   print('Received message: topic is $topic, payload is $pt');
      // }
    }else{
      print("Not connected! to Subscribe feed");
    }

  }

  void mqttPublish (String pubTopic, String data)  async{
    // const pubTopic = 'HCrystalH/feeds/humidity';
    // await MqttUtilities.asyncSleep(1);
    if(isConnected()){
      print("connected to publish data");
      final builder = MqttClientPayloadBuilder();
      builder.addString(data);

      print('Subscribing to the $pubTopic topic');
      client.subscribe(pubTopic, MqttQos.exactlyOnce);

      print('Publishing our topic');
      client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload!);
    }else{ print("not connected to publish data");}
  }

  void unSubscribe (String subTopic, String pubTopic)async {
    print('Sleeping....');
    await MqttUtilities.asyncSleep(80);

    print('Unsubscribing');
    client.unsubscribe(subTopic);
    client.unsubscribe(pubTopic);

    await MqttUtilities.asyncSleep(2);
    print('Disconnecting');
    client.disconnect();
  }
  
  bool isConnected(){
    return  client.connectionStatus!.state == MqttConnectionState.connected;
  }
  /// The subscribed callback
  void onSubscribed(String topic) {
    print('Subscription confirmed for topic $topic');
  }

  // The successful connect callbacki
  void onConnected() {
    print('OnConnected client callback - Client connection was sucessful');
  }

  /// Pong callback
  void pong() {
    print('Ping response client callback invoked');
  }
  void onDisconnected(){
    print("OnDisconnected client callback - Client disconnection");
     if (client.connectionStatus!.disconnectionOrigin ==
      MqttDisconnectionOrigin.solicited) {
        print('OnDisconnected callback is solicited, this is correct');
    }
  }
 

 
}

// void main()async{
//   MqttHelper user = MqttHelper(serverAddress: 'io.adafruit.com', userName: 'HVVH', userKey: 'aio_Urvv98tocEDOmtPAMqsPnWt6onBo');

//   user.mqttConnect();
//   user.mqttSubscribe('HVVH/feeds/data');
//   await MqttUtilities.asyncSleep(1);
    
// }