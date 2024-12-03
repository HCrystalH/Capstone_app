import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_android_app/Widget/snack_bar.dart';
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
  DateTime? startDate;
  DateTime? endDate= DateTime.now();

  @override
  void initState(){
    startDate = endDate?.subtract(const Duration(days: 1));
    Timer(const Duration(seconds: 5),supportFunction);
    // Timer.periodic(const Duration(seconds: 60), fetchHistoryOfFeed);
    super.initState();
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
    String username =  widget.brokerUserName;
    String userkey = widget.brokerUserKey;
    // debugPrint("username to fetch : $username");
    // debugPrint("userkey to fetch : $userkey");
    final String url = 'https://io.adafruit.com/api/v2/$username/feeds/$feedName/data';
    try{
    final response = await https.get(
      Uri.parse('$url?start=$startDate&end=$endDate'),
      headers: {
        'X-AIO-Key': userkey
      },
    );
    //"X-AIO-Key: {io_key}" "https://io.adafruit.com/api/v2/{username}/feeds/{feed_key}/data?limit=1&end_time=2019-05-05T00:00Z"
    // debugPrint(response.statusCode.toString());
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      final data = jsonDecode(response.body);
      // final len = data;
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
        DateTime createdAt = DateTime.parse(item['created_at']).toLocal(); // Parse created_at to DateTime
        // createdAt = createdAt.add( const Duration(hours: 7));
        // debugPrint("Time :" + createdAt.toString());
        _temperatureData.add(ChartData(createdAt, temp));
        _humiData.add(ChartData(createdAt, humi));
      }
      // debugPrint(data.toString());
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load data from Adafruit IO');
    }
    }catch (error){
      debugPrint(error.toString());
      // ignore: use_build_context_synchronously
      showSnackBar(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    resizeToAvoidBottomInset: false,
    body: SingleChildScrollView(
      child: Column(
        children: [
          // Temperature Chart
          SingleChildScrollView(
          scrollDirection: Axis.horizontal,
        
          child:SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 450,
            child: SfCartesianChart(
              
              tooltipBehavior: TooltipBehavior(enable: true),
              title: const ChartTitle(
                text: 'Temperature Chart',
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              primaryXAxis: DateTimeAxis(
                title:  const AxisTitle(
                  text: 'Time',
                  alignment: ChartAlignment.far,
                  
                ),
                minimum: startDate?.add(const Duration(hours:7)),
                maximum: endDate?.add(const Duration(hours:7)),
                // initialVisibleMinimum: startDate,
                interval: 3,
                edgeLabelPlacement: EdgeLabelPlacement.shift,
                dateFormat: DateFormat('HH:mm')
              ),
               
              enableAxisAnimation: true,
              enableMultiSelection: true,
              primaryYAxis: const NumericAxis(
                labelFormat: '{value}°C',
                title: AxisTitle(
                  // text: '°C',
                  textStyle: TextStyle(
                    color: Colors.red
                  ),
                  alignment: ChartAlignment.far,
                ),
                minimum: 0,
                maximum: 50,
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
                  name: 'Temperature',
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
            height: 450,
            child: SfCartesianChart(
              
              tooltipBehavior: TooltipBehavior(enable: true),
              title: const ChartTitle(
                text: 'Relative Humidity Chart',
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
                interval: 1,
                dateFormat: DateFormat.Hm(),
              ),
              primaryYAxis:  const NumericAxis(
                labelFormat: '{value}%',
                maximum: 100, 
                minimum: 0,
                title: AxisTitle(
                  // text:'%',
                  textStyle: TextStyle(
                    color: Colors.blue
                  ),
                  alignment: ChartAlignment.far
                ),
              ),
              series: <CartesianSeries>[
                LineSeries<ChartData, DateTime>(
                  dataSource: _humiData,
                  xValueMapper: (ChartData data, _) => data.date,
                  yValueMapper: (ChartData data, _) => data.value,
                  // pointColorMapper: (ChartData data, _) => getColor(data.value, "humidity"),
                  markerSettings: const MarkerSettings(isVisible: true),
                  name: 'Humidity',
                ),
              ],
            ),
          ),
          ),
          // Date Range TextField
          SizedBox(
            width: MediaQuery.of(context).size.width *0.65,
            // height: MediaQuery.of(context).size.height*0.2,
            child: Center(
            child: TextField(
              
              textAlign: TextAlign.center,
              readOnly: true,
              style: TextStyle(
                color: Colors.red,
                fontSize: MediaQuery.sizeOf(context).width*0.05,
                height: MediaQuery.sizeOf(context).height*0.001
              ),
              decoration: InputDecoration(
                hintText: (startDate == null && endDate == null)
                    ? 'Select a date range'
                    : '\tFrom: ${startDate != null ? startDate!.toLocal().toString().split(' ')[0] : ''} '
                      '\tTo: ${endDate != null ? endDate!.toLocal().toString().split(' ')[0] : ''}',
                hintStyle: TextStyle(
                  fontSize: MediaQuery.of(context).size.width*0.03,
                  color: Colors.green,
                  // fontWeight: FontWeight.bold,
                ),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: Colors.green,
                    width: MediaQuery.sizeOf(context).width*0.1
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Colors.blue, // Color when focused
                    width: 2.0,
                  ),
                ),
                contentPadding: const EdgeInsets.fromLTRB(10, 20, 20, 15),
              ),
              onTap: () => selectDateRange(context),
            ),
          ),
          ),
          SizedBox(height:MediaQuery.sizeOf(context).height*0.02),
        ],
      ),
    ),
  );
}
  @override
  void dispose(){
    super.dispose();
    
  }
}



class ChartData{
  final DateTime date;
  dynamic value;
  
  ChartData(this.date, this.value);
  
}