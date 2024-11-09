import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
class PowerConsumptionScreen extends StatefulWidget{
  const PowerConsumptionScreen({super.key});

  @override
  State<PowerConsumptionScreen> createState() => _ScreenState();
}

class _ScreenState extends State<PowerConsumptionScreen>{
  List<ChartData> _chartData = [];
  @override
  void initState() {
    super.initState();
    addTempData();
  }
   void addTempData(){
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
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height*0.3,
              child:  SfCartesianChart(
                tooltipBehavior: TooltipBehavior(enable: true),
                title: const ChartTitle(text: 'Power Consumption'),
                primaryYAxis: const NumericAxis(
                  title: AxisTitle(
                    text:"Power",textStyle: TextStyle(
                    color: Colors.blue,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto'
                  ),)
                  ,minimum: 0,maximum: 50, interval: 10
                  ),
                primaryXAxis: const DateTimeAxis(name:"Date"),
                series: <CartesianSeries>[
                  ColumnSeries<ChartData,DateTime>(
                    dataSource: _chartData,
                    xValueMapper: (ChartData data, _) => data.date,
                    yValueMapper: (ChartData data, _) => data.value,
                  ),
                ],     
           
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChartData{
  final DateTime date;
  dynamic value;

  ChartData(this.date, this.value);
}