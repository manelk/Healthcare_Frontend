import 'dart:core';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthcareapp/api/stat_api.dart';
import 'package:healthcareapp/theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:convert';
import 'package:healthcareapp/weekly_chart.dart';
import 'package:healthcareapp/chart_file.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({Key? key}) : super(key: key);

  @override
  _DashboardWidgetState createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  late List<String> listOfTopics = [
    "hcApp/temp",
    "hcApp/freq",
    "hcApp/BO",
    "hcApp/BloodPressure",
    "hcApp/steps"
  ];
  late String temprature = "0";
  //(double.parse(temprature)%100)*100
  late String frequency = "0";
  late String BO = "0";
  late String BloodPressure = "0";
  late String steps = "0";
  late double kilometre = 0;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<ChartData> ChartData1 = [];
  List<ChartData> ChartData3 = [];
  List<StepsDataModel> StepsDataList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("###########");
    //published("20");
    connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   automaticallyImplyLeading: false,
      //   leading: IconButton(
      //     // borderColor: Colors.transparent,
      //     // borderRadius: 30,
      //     // borderWidth: 1,
      //     // buttonSize: 60,
      //     icon: Icon(
      //       Icons.arrow_back_rounded,
      //       color: Colors.black,
      //       size: 30,
      //     ),
      //     onPressed: () {
      //       print('IconButton pressed ...');
      //     },
      //   ),
      //   title: Text(
      //     'Dashboard',
      //     style: TextStyle(
      //       fontFamily: 'Poppins',
      //       color: Colors.black,
      //       fontSize: 22,
      //     ),
      //   ),
      //   actions: [],
      //   centerTitle: true,
      //   elevation: 2,
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Personal Dashboard',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
//                            print(kilometre = int.parse(steps)/1312)
                          ],
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      primary: Color(0xFFE8E8E8),
                      onPrimary: Color(0xFFFF8585),
                      onSurface: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        fetchData();
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NeumorphicTheme(
                              theme: neumorphicTheme, child: ChartScreen()),
                        ),
                      );
                    },
                    child: Text('Check Your Statistics'),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  20, 20, 20, 20),
                              child: Card(
                                elevation: 10,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: Color(0xFFE1F0F4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.all(20),
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF0056CD),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(10, 10, 10, 10),
                                              child: FaIcon(
                                                FontAwesomeIcons.shoePrints,
                                                color: Colors.white,
                                                size: 24,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            'New Challenge! 🔥',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                          child: Wrap(
                                            children: [
                                              Icon(
                                                Icons.directions_walk,
                                                size: 50,
                                                color: Color(0xFF4FF7CF),
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    (int.parse(steps) /
                                                            1312.3359)
                                                        .toStringAsFixed(2),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 25),
                                                  ),
                                                  Text(
                                                    "KM",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 23),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            //"steps: "+steps,
                                            steps,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 23,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  /** Card for heart rate */
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4,
                                    color: Color(0x37000000),
                                    offset: Offset(0, 1),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: InkWell(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 16, 0, 0),
                                      child: Icon(
                                        Icons.monitor_heart_outlined,
                                        color: Colors.white,
                                        size: 44,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 8, 0, 0),
                                      child: AutoSizeText(
                                        'Heart rate',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            8, 4, 8, 0),
                                        child: Text(
                                          frequency,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            // 'Lexend Deca',
                                            color: Colors.black,
                                            fontSize: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Container(
                  //   color: Colors.red,
                  //   child: Column(
                  //     children: [
                  //       Row(
                  //         children: [
                  //           Text(
                  //             "Blood Pressure",
                  //             style: TextStyle(
                  //               fontFamily: 'Poppins',
                  //               fontSize: 15,
                  //             ),
                  //           ),
                  //           Text(
                  //             BloodPressure,
                  //             style: TextStyle(
                  //               fontFamily: 'Poppins',
                  //               fontSize: 15,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       Row(
                  //         children: [
                  //           Text(
                  //             "Frequency",
                  //             style: TextStyle(
                  //               fontFamily: 'Poppins',
                  //               fontSize: 15,
                  //             ),
                  //           ),
                  //           Text(
                  //             frequency,
                  //             style: TextStyle(
                  //               fontFamily: 'Poppins',
                  //               fontSize: 15,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  //                  color: Colors.black87,
                  // Generated code for this Container Widget...
                  // Cards for
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: 150,
                              decoration: BoxDecoration(
                                color: Color(0xFF0056CD),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4,
                                    color: Color(0x37000000),
                                    offset: Offset(0, 1),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: InkWell(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 16, 0, 0),
                                      child: Icon(
                                        Icons.bloodtype_outlined,
                                        color: Colors.white,
                                        size: 44,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 8, 0, 0),
                                      child: AutoSizeText(
                                        'Blood Pressure',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            8, 4, 8, 0),
                                        child: Text(
                                          BloodPressure,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            // 'Lexend Deca',
                                            fontSize: 25,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: 150,
                              decoration: BoxDecoration(
                                color: Color(0xFF0056CD),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 3,
                                    color: Color(0x39000000),
                                    offset: Offset(0, 1),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 16, 0, 0),
                                    child: Icon(
                                      Icons.show_chart,
                                      color: Colors.white,
                                      size: 44,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 8, 0, 0),
                                    child: AutoSizeText(
                                      'Blood Oxygen',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Poppins TextStyle',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          8, 4, 8, 0),
                                      child: Text(
                                        //'Current Status\n30m until full',
                                        BO,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white60,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4,
                            color: Color(0x1F000000),
                            offset: Offset(0, 2),
                          )
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: const Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                                child: Text(
                                  'Temperature',
                                  style: TextStyle(
                                    fontFamily: 'Outfit',
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                            Divider(
                              height: 24,
                              thickness: 1,
                              color: Color(0xFF6AA3B8),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.thermostat_outlined,
                                    size: 90,
                                    color: Color(0xFF4FF7CF),
                                  ),
                                  Text(
                                    //(int.parse(temprature) / 100).toString(),
                                    int.parse(temprature).toString(),
                                    style: TextStyle(
                                        fontSize: 70,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<MqttServerClient> connect() async {
    print("!!!");
    //listOfTopics.forEach((v) => print(v));
    MqttServerClient client = MqttServerClient.withPort(
        'broker.mqttdashboard.com', 'flutter_client', 1883);
    client.logging(on: true);
    client.onConnected = onConnected;

    try {
      await client.connect();
    } catch (e) {
      print("!!!!!!!!!!!!!!!!!");
      print('Exception: $e');
      client.disconnect();
    }
    listOfTopics.forEach((v) => client.subscribe(v, MqttQos.atMostOnce));
    print('EXAMPLE::Subscribing to the hcApp/freq topic');
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print(
          'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
      print("#################################");
      print(c[0].topic);
      print("#################################");
      setState(() {
        switch (c[0].topic) {
          case "hcApp/BloodPressure":
            {
              BloodPressure = MqttPublishPayload.bytesToStringAsString(
                  recMess.payload.message);
            }
            break;
          case "hcApp/steps":
            {
              steps = MqttPublishPayload.bytesToStringAsString(
                  recMess.payload.message);
              int.parse(steps);
              print(steps);
            }
            break;
          case "hcApp/BO":
            {
              BO = MqttPublishPayload.bytesToStringAsString(
                  recMess.payload.message);
            }
            break;
          case "hcApp/freq":
            {
              frequency = MqttPublishPayload.bytesToStringAsString(
                  recMess.payload.message);
            }
            break;
          case "hcApp/temp":
            {
              temprature = MqttPublishPayload.bytesToStringAsString(
                  recMess.payload.message);
              int.parse(temprature);
              print(temprature);
            }
        }
      });
      print('');
    });

    //final builder = MqttClientPayloadBuilder();
    //  builder.addString(msg);
    /// Publish it
    //print('EXAMPLE::Publishing our topic');
    //client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
    /// End publish it
    return client;
  }

  // connection succeeded
  void onConnected() {
    print('*****************************************');
    print('Connected');
  }

  void fetchData() {
    Future<List<dynamic>> future = StatApi.getNumberOfSteps();
    // ChartData3.add(ChartData("x", 20, 50));
    future.then((value) {
      print("@@@@@@@@@@");
      for (int i = 0; i < 50; i++) {
        print("value[i]");
        print(value[i]['_id']);
        DateTime dt = DateTime.parse(value[i]['date']);
        String cleanDate = DateFormat('yyyy-MM-dd').format(dt);
        StepsDataList.add(StepsDataModel(value[i]['_id'],
            double.parse(value[i]['NumberOfSteps']), cleanDate));
      }

      for (int i = 0; i < value.length; i++) {
        print("value[i]");
        print(value[i]['_id']);
        DateTime dt = DateTime.parse(value[i]['date']);
        String cleanDate = DateFormat('yyyy-MM-dd').format(dt);
        ChartData3.add(
            ChartData(cleanDate, 0, double.parse(value[i]['NumberOfSteps'])));
      }
      print("@@@@@@@@@@ StepsDataList");
      print(StepsDataList.map((e) => print(e)));
    });
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
