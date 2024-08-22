

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter/material.dart';

// key = aio_Urvv98tocEDOmtPAMqsPnWt6onBo
 /*If cannot use log => debugdebugPrint instead*/ 

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
    client.autoReconnect = true;
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
      debugPrint("Connecting....");
      client.keepAlivePeriod = 60;
      await client.connect();
      
    } on NoConnectionException catch (e) {
      debugPrint('Client exception: $e');
      client.disconnect();
    }

    if (isConnected()) {
      debugPrint('Adafruit connected');
    } else {
      debugPrint('Client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
    }
  }
/// The pre auto re connect callback
void onAutoReconnect() {
  debugPrint('Client auto reconnection sequence will start');
}

/// The post auto re connect callback
void onAutoReconnected() {
  debugPrint('Client auto reconnection sequence has completed');
}
  void mqttSubscribe(String subTopic) async{
    //  const subTopic = 'HCrystalH/feeds/humidity';
    debugPrint('Subscribing to the $subTopic topic');
    await MqttUtilities.asyncSleep(1);
    if( isConnected()){
      debugPrint('Connected! to Subscribe');
      client.subscribe(subTopic, MqttQos.atMostOnce);
      client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
        final recMess = c![0].payload as MqttPublishMessage;
        final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        debugPrint('Received message: topic is ${c[0].topic}, payload is $pt');
      });

      client.published!.listen((MqttPublishMessage message) {
        debugPrint('Published topic: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
      });
    }else{
      debugPrint("Not connected! to Subscribe feed");
    }

  }

  void mqttPublish (String pubTopic, String data)  async{
    // const pubTopic = 'HCrystalH/feeds/humidity';
    await MqttUtilities.asyncSleep(2);
    if(isConnected()){
      debugPrint("connected to publish data");
      final builder = MqttClientPayloadBuilder();
      builder.addString(data);

      debugPrint('Subscribing to the $pubTopic topic');
      client.subscribe(pubTopic, MqttQos.exactlyOnce);

      debugPrint('Publishing our topic');
      client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload!);
    }else{ debugPrint("not connected to publish data");}
  }

  void unSubscribe (String subTopic, String pubTopic)async {
    debugPrint('Sleeping....');
    await MqttUtilities.asyncSleep(80);

    debugPrint('Unsubscribing');
    client.unsubscribe(subTopic);
    client.unsubscribe(pubTopic);

    await MqttUtilities.asyncSleep(2);
    debugPrint('Disconnecting');
    client.disconnect();
  }
  
  bool isConnected(){
    return  client.connectionStatus!.state == MqttConnectionState.connected;
  }
  /// The subscribed callback
  void onSubscribed(String topic) {
    debugPrint('Subscription confirmed for topic $topic');
  }

  // The successful connect callbacki
  void onConnected() {
    debugPrint('OnConnected client callback - Client connection was sucessful');
  }

  /// Pong callback
  void pong() {
    debugPrint('Ping response client callback invoked');
  }
  void onDisconnected(){
    debugPrint("OnDisconnected client callback - Client disconnection");
     if (client.connectionStatus!.disconnectionOrigin ==
      MqttDisconnectionOrigin.solicited) {
        debugPrint('OnDisconnected callback is solicited, this is correct');
    }
  }
  String getData() {
     
    if(isConnected()){
      debugPrint("connected successfully to get data");
      String data ="";
      client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
          final recMess = c![0].payload as MqttPublishMessage;
          final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        
          data = pt;
          // debugPrint('Received message: topic is ${c[0].topic}, payload is $pt');
          // debugPrint('$pt');
        });
      return data;
    }else{
      return "not connected";
    }
  }
}
