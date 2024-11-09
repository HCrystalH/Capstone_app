import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartScreen extends StatefulWidget{
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  DateTime _startTime = DateTime.now().subtract(Duration(days: 7));
  DateTime _endTime = DateTime.now();
  List<ChartData> _chartData = [];
  List<ChartData> _temperatureData = [];
  @override
  void initState(){
    super.initState();
    genData();
    addTempData();
  }

  void addTempData(){
    for(int i = 0 ; i < 30; i++){
      DateTime date = DateTime.now().subtract(Duration(days: 30 - i));
      if(i < 10) {_temperatureData.add(ChartData(date,(20-i)));}
      else if(i >= 10 && i < 20) {_temperatureData.add(ChartData(date,(20+i)));}
      else {_temperatureData.add(ChartData(date,(27)));}
    }
  }
  void genData(){
    _chartData = List.generate(30, (index){
      DateTime date = DateTime.now().subtract(Duration(days: 30 - index));
      return ChartData(date, (index +1)*100);
    }
    
    );
  }

  void updateDateRange(DateTime start, DateTime end){
    setState(() {
      _startTime = start;
      _endTime = end;
    });
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height*0.3,
              child:  SfCartesianChart(
                tooltipBehavior: TooltipBehavior(enable: true),
                title: const ChartTitle(text: 'Temperature Chart'),
                primaryXAxis: const DateTimeAxis(),
                primaryYAxis: const NumericAxis(minimum: 10,),  
                legend: const Legend(
                  opacity: 2.0,
                  isVisible: true,
                  isResponsive: true,
                ),
                series: <CartesianSeries>[
                  LineSeries<ChartData,DateTime>(
                    dataSource: _temperatureData,
                    xValueMapper: (ChartData data, _) => data.date,
                    yValueMapper: (ChartData data, _) => data.value,
                  ),
                ],     
           
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              
              height: MediaQuery.of(context).size.height*0.3,
              child:  SfCartesianChart(
                tooltipBehavior: TooltipBehavior(enable: true),
                title: const ChartTitle(text: 'Humidity Chart'),
                legend: const Legend(isVisible: true),
                primaryXAxis: const DateTimeAxis(),
                primaryYAxis: const NumericAxis(),  
                series: <CartesianSeries>[
                  LineSeries<ChartData,DateTime>(
                    dataSource: _chartData,
                    xValueMapper: (ChartData data, _) => data.date,
                    yValueMapper: (ChartData data, _) => data.value,
                  ),
                ],      
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Example of updating the date range
              updateDateRange(DateTime.now().subtract(const Duration(days: 20)), DateTime.now());
            },
            child: const Text('Change Date Range'),
          ),
        ],
      ),
    );
  }

}

class ChartData{
  final DateTime date;
  final value;

  ChartData(this.date, this.value);
}