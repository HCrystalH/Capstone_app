import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as https;
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ChartScreen extends StatefulWidget{
  String brokerUserName,brokerUserKey;
  ChartScreen({super.key,required this.brokerUserName,required this.brokerUserKey});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {

  // ignore: prefer_final_fields
  List<ChartData> _humiData = [];
  // ignore: prefer_final_fields
  List<ChartData> _temperatureData = [];
  // String username ='', userkey = '';
  // DateTime startDate = DateTime.parse('2024-11-04T00:00:00Z'); // Start date
  // DateTime endDate = DateTime.parse('2024-12-24T23:59:59Z'); 
  DateTime? startDate;
  DateTime? endDate= DateTime.now();
  // List<ChartData> _chartData = [];
  bool showAsDate = false;
  @override
  void initState(){
    startDate = endDate?.subtract(const Duration(days: 1));
    // Timer(const Duration(seconds: 5),supportFunction);
    // Timer.periodic(const Duration(seconds: 60), fetchHistoryOfFeed);
  

    super.initState();
    genData();
    addTempData();
  }
  void addTempData(){
    for(int i = 0 ; i < 30; i++){
      DateTime date = DateTime.now().subtract(const Duration(days: 1));
      date = date.add(Duration(hours: i));
      if(i < 10) {_temperatureData.add(ChartData(date,(20-i)));}
      else if(i >= 10 && i < 20) {_temperatureData.add(ChartData(date,(20+i)));}
      else {_temperatureData.add(ChartData(date,(27)));}
    }
  }
  void genData(){
    _humiData = List.generate(30, (index){
      DateTime date = DateTime.now().subtract(const Duration(days: 1));
      return ChartData(date, (index +1)*100);
    }
    
    );
  }

  void supportFunction(){
    fetchHistoryOfFeed("topic0", startDate!, endDate!);
    debugPrint("Function loaded");
  }  
  
  Future<void> selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now()
      ),
      currentDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
    }
  }

  Future<void> fetchHistoryOfFeed(String feedName, DateTime startDate, DateTime endDate) async{
    // final String url = 'https://io.adafruit.com/api/v2/$username/feeds/$feedName';
    String username =  widget.brokerUserName;
    String userkey = widget.brokerUserKey;
    
    debugPrint("username to fetch : $username");
    debugPrint("userkey to fetch : $userkey");
    final String url = 'https://io.adafruit.com/api/v2/$username/feeds/$feedName/data';
    final response = await https.get(
      Uri.parse('$url?start=$startDate&end=$endDate'),
      //  Uri.parse('$url?start=$startDate&end=$endDate'),
      headers: {
        'X-AIO-Key': userkey
      },
    );
  // "X-AIO-Key: {io_key}" "https://io.adafruit.com/api/v2/{username}/feeds/{feed_key}/data?limit=1&end_time=2019-05-05T00:00Z"
  //"X-AIO-Key: {io_key}" "https://io.adafruit.com/api/v2/{username}/feeds/{feed_key}/data?limit=1&end_time=2019-05-05T00:00Z"
  // debugPrint(response.statusCode.toString());
  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, parse the JSON.
    final data = jsonDecode(response.body);
    // final len = data;
    // debugPrint("json size: $len");
    _temperatureData.clear();
    _humiData.clear();
    // debugPrint(data.toString());
    // extract data and add to the lists
    for(var item in data){
      var valueParts = item['value'].toString().split(','); // 'value': 30,80
      // debugPrint("Values:" + valueParts.toString());
      double? temp;
      double? humi;
      for(int i = 0; i<valueParts.length;i++){
        if(i == 0 ){ temp = double.tryParse(valueParts[0]);}
        else if(i == 1){humi  = double.tryParse(valueParts[1]);}
      }
      DateTime createdAt = DateTime.parse(item['created_at']); // Parse created_at to DateTime
      // debugPrint("Time :" + createdAt.toString());
      _temperatureData.add(ChartData(createdAt, temp));
      _humiData.add(ChartData(createdAt, humi));
    }
    // debugPrint(data.toString());
  } else {
    // If the server did not return a 200 OK response, throw an exception.
    throw Exception('Failed to load data from Adafruit IO');
  }
  }
  
  Color getColor(dynamic value, String type) {
    if(type == "temperature"){
      if (value >= 30) {
        return Colors.red;
      } else if (value <= 20) {
        return Colors.green; 
      } else{
        return Colors.blue;
      }
    }else{
      if(value > 40 && value < 60){
        return Colors.blue;
      }else if(value > 60){
        return Colors.red;

      }else{
        return Colors.green;
      }
    }
  }


@override
Widget build(BuildContext context) {
  return Scaffold(
    resizeToAvoidBottomInset: false,
    body: SingleChildScrollView(
      child: Column(
        children: [
          SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          // Temperature Chart
          child:SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.5,
            child: SfCartesianChart(
              tooltipBehavior: TooltipBehavior(enable: true),
              title: const ChartTitle(
                text: 'Temperature Chart',
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              primaryXAxis: 
                 DateTimeAxis(
                    title: const AxisTitle(
                      text: 'Time',
                      alignment: ChartAlignment.far,
                    ),
                    minimum: startDate,
                    maximum: endDate,
                    interval: 1.5,
                    dateFormat: DateFormat.Hm(),
                  ),
               
              enableAxisAnimation: true,
              enableMultiSelection: true,
              primaryYAxis: const NumericAxis(
                title: AxisTitle(
                  text: '°C',
                  alignment: ChartAlignment.far,
                ),
                minimum: 0,
                maximum: 100,
              ),
              series: <CartesianSeries>[
                LineSeries<ChartData, DateTime>(
                  dataSource: _temperatureData,
                  // dataSource: _chartData,
                  xValueMapper: (ChartData data, _) => data.date,
                  yValueMapper: (ChartData data, _) => data.value,
                  // pointColorMapper: (ChartData data, _) => getColor(data.value, "temperature"),
                  markerSettings: const MarkerSettings(
                    isVisible: true,
                  ),
                ),
              ],
            ),
          ),
          ),
          
          // Humidity Chart
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.5,
            child: SfCartesianChart(
              tooltipBehavior: TooltipBehavior(enable: true),
              title: const ChartTitle(
                text: 'Humidity Chart',
                textStyle: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              primaryXAxis: DateTimeAxis(
                title: const AxisTitle(
                  text: 'Time',
                  alignment: ChartAlignment.far,
                ),
                minimum: startDate,
                maximum: endDate,
                interval: 1.5,
                dateFormat: DateFormat.Hm(),
              ),
              primaryYAxis: const NumericAxis(
                maximum: 100, 
                minimum: 0,
                title: const AxisTitle(
                  alignment: ChartAlignment.far
                ),
              ),
              series: <CartesianSeries>[
                LineSeries<ChartData, DateTime>(
                  dataSource: _humiData,
                  xValueMapper: (ChartData data, _) => data.date,
                  yValueMapper: (ChartData data, _) => data.value,
                  pointColorMapper: (ChartData data, _) => getColor(data.value, "humidity"),
                  markerSettings: const MarkerSettings(isVisible: true),
                ),
              ],
            ),
          ),
          ),
          // Date Range TextField
          SizedBox(
            width: MediaQuery.of(context).size.width *0.8,
            child: TextField(
              textAlign: TextAlign.left,
              readOnly: true,
              style: const TextStyle(
                color: Colors.red,
              ),
              decoration: InputDecoration(
                hintText: (startDate == null && endDate == null)
                    ? 'Select a date range'
                    : '\tFrom: ${startDate != null ? startDate!.toLocal().toString().split(' ')[0] : ''} '
                      '\tTo: ${endDate != null ? endDate!.toLocal().toString().split(' ')[0] : ''}',
                hintStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Colors.green,
                    width: 5.0
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Colors.green, // Color when enabled
                    width: 5.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Colors.blue, // Color when focused
                    width: 2.0,
                  ),
                ),
                contentPadding: const EdgeInsets.fromLTRB(30, 15, 0, 15),
              ),
              
              onTap: () => selectDateRange(context),
            ),
          ),
          // Apply Button
          ElevatedButton(
            onPressed: () {
              debugPrint(startDate.toString());
              debugPrint(endDate.toString());
            },
            child: const Text('Apply change'),
          ),
        ],
      ),
    ),
  );
}

}

class ChartData{
  final DateTime date;
  dynamic value;

  ChartData(this.date, this.value);
}