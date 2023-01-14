import 'dart:core';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:healthcareapp/chart_file.dart';
import 'package:healthcareapp/theme/app_color.dart';
import 'package:healthcareapp/api/stat_api.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import 'package:intl/intl.dart';

class ChartScreen extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  ChartScreen({Key? key}) : super(key: key);

  @override
  ChartScreenState createState() => ChartScreenState();
}

class ChartScreenState extends State<ChartScreen> {

  List<_StepsData> StepsData = [
    _StepsData("63971062df459f5415893c0b", 1000, "2022-12-12"),
    _StepsData("63971062df459f5415893c0b", 1200, "2022-11-12"),
    _StepsData("63971062df459f5415893c0b", 100, "2022-15-12"),
  ];

  List<StepsDataModel> StepsData1 = [
    StepsDataModel("63971062df459f5415893c0b", 1000, "2022-12-12"),
    StepsDataModel("63971062df459f5415893c0b", 1200, "2022-11-12"),
    StepsDataModel("63971062df459f5415893c0b", 100, "2022-15-12"),
  ];
  List<ChartData> ChartData2 = [
    ChartData('Jan', 5, 9),
    ChartData('Feb', 0, 11),
    ChartData('Mar', 0, 13),
    ChartData('Apr', 0, 17),
    ChartData('May', 0, 50),
  ];
  List<ChartData> ChartData1 = [];
  List<ChartData> ChartData3 = [];
  List<StepsDataModel> StepsDataList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future<List<dynamic>> future = StatApi.getNumberOfSteps();
    Future<List<dynamic>> futureFrequency = StatApi.getFrequency();
    futureFrequency.then((value) {
      print(value);
      print("FREQ");
      for (int i = 0; i < value.length; i++) {
        print("value[i]");
        print(value[i]['freqValue']);
        DateTime dt = DateTime.parse(value[i]['date']);
        String cleanDate = DateFormat('yyyy-MM-dd').format(dt);
        StepsDataList.add(StepsDataModel(
            value[i]['_id'], double.parse(value[i]['freqValue']), cleanDate));
      }
    });

    future.then((value) {
      print("@@@@@@@@@@");
      // for (int i = 0; i < 50; i++) {
      //   // print("value[i]");
      //   // print(value[i]['_id']);
      //   DateTime dt = DateTime.parse(value[i]['date']);
      //   String cleanDate = DateFormat('yyyy-MM-dd').format(dt);
      //   StepsDataList.add(StepsDataModel(value[i]['_id'],
      //       double.parse(value[i]['NumberOfSteps']), cleanDate));
      // }
      for (int i = 0; i < value.length; i++) {
        // print("value[i]");
        // print(value[i]['_id']);
        DateTime dt = DateTime.parse(value[i]['date']);
        String cleanDate = DateFormat('yyyy-MM-dd').format(dt);
        ChartData3.add(
            ChartData(cleanDate, 0, double.parse(value[i]['NumberOfSteps'])));
      }
      //  value.forEach((element) {
      //   DateTime dt = DateTime.parse(element['date']);
      //   String cleanDate = DateFormat('yyyy-MM-dd').format(dt);
      //   StepsDataList.add(StepsDataModel(element['_id'], double.parse(element['NumberOfSteps']), cleanDate));
      // });
      // _id: String
      // NumberOfSteps: String
      // date: String
      // value.map((e) =>
      //     //print(e)
      //     // ChartData3.add(
      //     //   ChartData(
      //     //       e._id, double.parse(e.NumberOfSteps), double.parse(e.date)),
      //     // )
      //
      // );
      //ChartData3.addAll(value.map((e) => ChartData(e._id, double.parse(e.NumberOfSteps), double.parse(e.date))));
      // print(value.map((e) =>
      //     //print(e)
      //     ChartData(e._id, e.NumberOfSteps, e.date)));
      // StepsDataList.addAll(value.map(
      //   (e) => StepsDataModel(e._id, double.parse(e.NumberOfSteps), e.date),
      // ));a
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leadingWidth: 100,
          backgroundColor: Color(0xFFE8E8E8),
          automaticallyImplyLeading: false,
          leading: ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            label: const Text(
              "Back",
              style: TextStyle(color: Color(0xFFE8E8E8)),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
              elevation: 0,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Statistic 📈",
                  style: TextStyle(color: kAccentColor, fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "👣 Steps statistics",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  series: <ChartSeries>[
                    RangeColumnSeries<ChartData, String>(
                      dataSource: ChartData3,
                      xValueMapper: (ChartData data, _) => data.x,
                      lowValueMapper: (ChartData data, _) => data.low,
                      highValueMapper: (ChartData data, _) => data.high,
                      color: Color(0xFFFF4646),
                    )
                  ]),

              Padding(
                padding: const EdgeInsets.all(10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "💓 Frequency statistics",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),

              SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  // Chart title
                  title: ChartTitle(text: ''),
                  // Enable legend
                  legend: Legend(isVisible: false),
                  // Enable tooltip
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <ChartSeries<StepsDataModel, String>>[
                    LineSeries<StepsDataModel, String>(
                        width: 2,
                        dataSource: StepsDataList,
                        xValueMapper: (StepsDataModel sales, _) => sales.date,
                        yValueMapper: (StepsDataModel sales, _) =>
                            sales.NumberOfSteps,
                        color: Color(0x3230475E),
                        //name: 'Sales',
                        // Enable data label
                        dataLabelSettings: DataLabelSettings(isVisible: true))
                  ]),
            ]),
          ),
        ));
  }
}

class _StepsData {
  _StepsData(this._id, this.NumberOfSteps, this.date);

  final String _id;
  final double NumberOfSteps;
  final String date;

  Map<String, dynamic> toMap(void Function(dynamic e) param0) {
    return {
      '_id': _id,
      'NumberOfSteps': NumberOfSteps,
      'date': date,
    };
  }
}

class StepsDataModel {
  StepsDataModel(this._id, this.NumberOfSteps, this.date);

  final String _id;
  final double NumberOfSteps;
  final String date;
}

class ChartData {
  ChartData(this.x, this.high, this.low);
  final String x;
  final double high;
  final double low;
}
