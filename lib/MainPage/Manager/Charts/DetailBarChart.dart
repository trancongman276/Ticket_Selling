import 'package:CoachTicketSelling/Utils/enum.dart';
import 'package:CoachTicketSelling/classes/Implement/BillImpl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartView extends StatefulWidget {
  final ChartQuery chart;
  final Color primaryColor;

  const BarChartView({Key key, this.chart, this.primaryColor})
      : super(key: key);
  @override
  _BarChartViewState createState() => _BarChartViewState(chart, primaryColor);
}

class _BarChartViewState extends State<BarChartView> {
  final ChartQuery chart;
  final Color primaryColor;
  static const double opacity = 0.8;
  List<Color> colorLs = [
    Colors.amberAccent.shade700.withOpacity(opacity),
    Colors.amberAccent.withOpacity(opacity),
    Colors.redAccent.withOpacity(opacity),
    Colors.greenAccent.withOpacity(opacity),
    Colors.green.withOpacity(opacity),
    Colors.cyan.shade300.withOpacity(opacity),
    Colors.cyan.shade900.withOpacity(opacity),
    Colors.deepPurpleAccent.withOpacity(opacity),
    Colors.deepPurple.shade900.withOpacity(opacity),
    Colors.white.withOpacity(opacity),
  ];
  _BarChartViewState(this.chart, this.primaryColor) {
    billImplement = BillImplement.instance;
    getData();
  }
  BillImplement billImplement;

  List<String> monthLS = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  var dataList;
  int currentMonth = DateTime.now().month;
  void getData() {
    switch (chart) {
      case ChartQuery.MostVisited:
        dataList = billImplement.getVisited();
        break;
      case ChartQuery.Rating:
        dataList = billImplement.getRating();
        break;
      default:
        break;
    }
  }

  Widget buildList() {
    return ListView.builder(
      itemCount: dataList[currentMonth - 1].length,
      itemBuilder: (BuildContext context, int index) {
        double size = 50.0;
        return Container(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: index >= colorLs.length
                      ? colorLs[colorLs.length - 1]
                      : colorLs[index],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dataList[currentMonth - 1]
                            .keys
                            .elementAt(index)
                            .toString(),
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                      Text(
                        dataList[currentMonth - 1][dataList[currentMonth - 1]
                                .keys
                                .elementAt(index)]
                            .toString(),
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void backBt() {
    Navigator.pop(context);
  }

  void sidebarBt(String choice) {
    setState(() {
      currentMonth = monthLS.indexOf(choice) + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              color: primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () => backBt(),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Detail chart',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: PopupMenuButton<String>(
                      onSelected: sidebarBt,
                      itemBuilder: (BuildContext context) {
                        return monthLS.map((String month) {
                          bool en = true;
                          if (month == monthLS[currentMonth - 1]) en = false;
                          return PopupMenuItem<String>(
                            value: month,
                            child: Text(month),
                            enabled: en,
                          );
                        }).toList();
                      },
                      child: Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: PieChart(
                      PieChartData(
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 5,
                          centerSpaceRadius: 40,
                          sections: showingSections()),
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.white,
            ),
            Expanded(
              child: buildList(),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(dataList[currentMonth - 1].length, (i) {
      var value = dataList[currentMonth - 1]
          [dataList[currentMonth - 1].keys.elementAt(i)];
      return PieChartSectionData(
          radius: 60.0,
          color: i >= colorLs.length - 1
              ? colorLs[colorLs.length - 1]
              : colorLs[i],
          value: (value.isFinite && value != 00) ? value.toDouble() : 1,
          title: i >= colorLs.length - 1 ? '' : value.toString(),
          titleStyle: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ));
    });
  }
}
