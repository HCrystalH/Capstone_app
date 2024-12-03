import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_android_app/Widget/snack_bar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as https;
// ignore: must_be_immutable
class PowerConsumptionScreen extends StatefulWidget{
  String brokerUserName,brokerUserKey;
  PowerConsumptionScreen({super.key,required this.brokerUserName,required this.brokerUserKey});

  @override
  State<PowerConsumptionScreen> createState() => _ScreenState();
}

class _ScreenState extends State<PowerConsumptionScreen>{
  final List<ChartData> _chartData = [];
  DateTime? startDate;
  DateTime? endDate= DateTime.now();

  @override
  void initState() {
    super.initState();
    startDate = endDate?.subtract(const Duration(days: 1));
    Timer(const Duration(seconds: 5),supportFunction);
    genData();
  }

  void genData(){
    for(int i = 0 ; i < 5; i++){
      DateTime date = DateTime.now().subtract(Duration(days: 30 - i));
      if(i < 10) {_chartData.add(ChartData(date,(20-i)));}
      else if(i >= 10 && i < 20) {_chartData.add(ChartData(date,(20+i)));}
      else {_chartData.add(ChartData(date,(27)));}
    }
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child:Column(
        children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height*0.8,
              child:  SfCartesianChart(
                tooltipBehavior: TooltipBehavior(enable: true),
                title: ChartTitle(
                  text: 'Power Consumption',
                  textStyle: TextStyle(
                    fontSize: MediaQuery.sizeOf(context).width*0.04,
                    fontWeight: FontWeight.bold
                  )
                ),
                primaryYAxis: const NumericAxis(
                  labelFormat: '{value}kWh',
                  minimum: 0,maximum: 100, interval: 5
                  ),
                primaryXAxis:  DateTimeAxis(
                  minimum: startDate,
                  maximum: endDate,
                //   title:  const AxisTitle(
                //     // text: 'Time',
                //     alignment: ChartAlignment.far,  
                // ),
                ),
                series: <CartesianSeries>[
                  ColumnSeries<ChartData,DateTime>(
                    dataSource: _chartData,
                    xValueMapper: (ChartData data, _) => data.date,
                    yValueMapper: (ChartData data, _) => data.value,
                    markerSettings: const MarkerSettings(
                      isVisible: true,
                    ),
                    name: 'Power Consumption'
                  ),
                ],     
           
              ),
            ),
          ),
          
          const SizedBox(height: 20,),
          SizedBox(
            width: MediaQuery.of(context).size.width *0.65,
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
        ],
      ),
      ),
    );
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
    final String url = 'https://io.adafruit.com/api/v2/$username/feeds/$feedName/data';
    try{
      final response = await https.get(
        Uri.parse('$url?start=$startDate&end=$endDate'),
        headers: {
          'X-AIO-Key': userkey
        },
      );
      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON.
        final data = jsonDecode(response.body);
        _chartData.clear();
        
        // extract data and add to the lists
        for(var item in data){
          var valueParts = item['value'].toString().split(','); // 'value': 1,1,1,1,
          // debugPrint("Values:" + valueParts.toString());
          double? power;
          for(int i = 0; i<valueParts.length;i++){
            // i == 0 : current , 1: voltage,  2: power consumption
            if(i == 2 ){ power = double.tryParse(valueParts[i]);}
            
          }
          DateTime createdAt = DateTime.parse(item['created_at']).toLocal(); // Parse created_at to DateTime
          _chartData.add(ChartData(createdAt, power));
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

  void supportFunction(){
    fetchHistoryOfFeed("topic5", startDate!, endDate!);
    debugPrint("Function loaded");
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