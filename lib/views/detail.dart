import 'dart:math';

import 'package:covid/theme/light_color.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter/material.dart';



enum LegendShape { Circle, Rectangle }

Widget tile(BuildContext context, Color color, String info,String title, String subtitle){
    return ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(13)),
              child: Container(
                height: 55,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: color,
                ),
                child: Align(
                  alignment: Alignment.center,
                                child: Text(info, style: TextStyle(
                    color: Colors.white, 
                    fontSize: 17, 
                    fontWeight: FontWeight.bold,
                  ),
                    ),
                )
              )
              ),
              title: Text(title, style: TextStyle(
                    color: Colors.black, 
                    fontSize: 15, 
                    fontWeight: FontWeight.bold,
                  ),),
                  subtitle: Text(subtitle),
                  trailing: Icon(
            Icons.arrow_downward,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
                  );
  }

class ScreenArguments {
  String country;
    int cases;
    int deaths;
    int recovered;
    int active;
    int critical;
    int totalTests;

  ScreenArguments(
    this.country,
        this.cases,
        this.deaths,
        this.recovered,
        this.active,
        this.critical,
        this.totalTests,
  );
}


class Detail extends StatefulWidget {
  static const routeName = '/detail';
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  
  
  List<Color> colorList = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
  ];

  ChartType _chartType = ChartType.disc;
  bool _showCenterText = true;
  double _ringStrokeWidth = 32;
  double _chartLegendSpacing = 32;

  bool _showLegendsInRow = false;
  bool _showLegends = true;

  bool _showChartValueBackground = true;
  bool _showChartValues = true;
  bool _showChartValuesInPercentage = false;
  bool _showChartValuesOutside = false;

  LegendShape _legendShape = LegendShape.Circle;
  LegendPosition _legendPosition = LegendPosition.right;

  int key = 0;

  Color randomColor() {
    var random = Random();
    final colorList = [
      Theme.of(context).primaryColor,
      LightColor.orange,
      LightColor.green,
      LightColor.grey,
      LightColor.lightOrange,
      LightColor.skyBlue,
      //LightColor.titleTextColor,
      Colors.red,
      //Colors.brown,
      LightColor.purpleExtraLight,
      LightColor.skyBlue,
    ];
    var color = colorList[random.nextInt(colorList.length)];
    return color;
  }

   

  @override
  Widget build(BuildContext context) {
    
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    final String countryName=args.country;
    Map<String, double> dataMap = {
    "Total cases": args.recovered==null|| args.active==null ? 0.0: args.cases+0.0,
    "Deaths": args.recovered==null|| args.active==null ? 0.0: args.deaths+0.0,
    "Recovered": args.recovered==null?0.0 :args.recovered+0.0,
    "Active": args.active==null? 0.0 : args.active+0.0,
  };

  
    final chart = PieChart(
      key: ValueKey(key),
      dataMap: dataMap,
      animationDuration: Duration(milliseconds: 800),
      chartLegendSpacing: _chartLegendSpacing,
      chartRadius: MediaQuery.of(context).size.width / 1.5 > 300
          ? 600
          : MediaQuery.of(context).size.width / 1.5,
      colorList: colorList,
      initialAngleInDegree: 0,
      chartType: _chartType,
      centerText: _showCenterText ? args.country : null,
      legendOptions: LegendOptions(
        showLegendsInRow: _showLegendsInRow,
        legendPosition: _legendPosition,
        showLegends: _showLegends,
        legendShape: _legendShape == LegendShape.Circle
            ? BoxShape.circle
            : BoxShape.rectangle,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: ChartValuesOptions(
        showChartValueBackground: _showChartValueBackground,
        showChartValues: _showChartValues,
        showChartValuesInPercentage: _showChartValuesInPercentage,
        showChartValuesOutside: _showChartValuesOutside,
      ),
      ringStrokeWidth: _ringStrokeWidth,
    );
    return Scaffold(
      appBar: AppBar(
        title: args.recovered==null|| args.active==null ? Text("Null value detected, data misinterpritation"): Text("Pie Chart $countryName")
      ),
      body: LayoutBuilder(
        builder: (_, constraints) {
          if (constraints.maxWidth >= 600) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: chart,
                ),
              ],
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: chart,
                    margin: EdgeInsets.symmetric(
                      vertical: 32,
                    ),
                  ),
                  Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            offset: Offset(4, 4),
            blurRadius: 10,
            color: LightColor.grey.withOpacity(.2),
          ),
          BoxShadow(
            offset: Offset(-3, 0),
            blurRadius: 15,
            color: LightColor.grey.withOpacity(.1),
          )
        ],
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: Column(
                  children:<Widget>[
                    tile(context, Colors.lightBlue, countryName, "",""),
                    SizedBox(height: 10,),
                    tile(context, Colors.red, "Total Cases", args.cases.toString(),args.active.toString()),
                    SizedBox(height: 10,),
                    tile(context, Colors.green, "Recovered", args.recovered.toString(),args.active.toString()),
                    SizedBox(height: 10,),
                    tile(context, Colors.blue, "Deaths", args.deaths.toString(),args.active.toString()),
                    SizedBox(height: 10,),
                    tile(context, Colors.amber, "Active", args.active.toString(),args.active.toString()),
                    SizedBox(height: 10,),
                    tile(context, Colors.pinkAccent, "Critical", args.critical.toString(),args.active.toString()),
                    SizedBox(height: 10,),
                    tile(context, Colors.orange, "Total Tests", args.totalTests.toString(),args.active.toString()),
              ]
        )
          ), 
        ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}