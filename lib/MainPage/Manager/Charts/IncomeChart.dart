import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class IncomeChart extends StatefulWidget {
  @override
  _IncomeChartState createState() => _IncomeChartState();
}

class _IncomeChartState extends State<IncomeChart> {
  List<FlSpot> listSpot = [
    FlSpot(0, 20),
    FlSpot(1, 20),
    FlSpot(2, 50),
    FlSpot(3, 40),
    FlSpot(4, 50),
    FlSpot(5, 50),
    FlSpot(6, 50),
    FlSpot(7, 30),
    FlSpot(8, 20),
    FlSpot(9, 50),
    FlSpot(10, 40),
    FlSpot(11, 50),
    FlSpot(12, 50),
    FlSpot(13, 50),
    FlSpot(14, 40),
    FlSpot(15, 50),
    FlSpot(16, 50),
    FlSpot(17, 50),
    FlSpot(18, 40),
    FlSpot(19, 50),
    FlSpot(20, 50),
    FlSpot(21, 50),
    FlSpot(22, 40),
    FlSpot(23, 50),
    FlSpot(24, 50),
    FlSpot(25, 50),
    FlSpot(26, 40),
    FlSpot(27, 50),
    FlSpot(28, 50),
    FlSpot(29, 50),
    FlSpot(30, 40),
  ];
  int max = -1;
  // List<int> listShowSpot = [3];

  void backBt() {
    //Todo: Action on back button
    Navigator.pop(context);
  }

  void sidebarBt() {
    //Todo: Action on back button
  }

  @override
  Widget build(BuildContext context) {
    void getMax() {
      listSpot.forEach((element) {
        if (element.y > max) max = element.y.toInt();
      });
    }

    final _lineBarsData = [
      LineChartBarData(
        spots: listSpot,
        isCurved: true,
        colors: [Colors.white],
        barWidth: 2.0,
        isStrokeCapRound: true,
        belowBarData: BarAreaData(
          show: true,
          colors: [Colors.white.withOpacity(0.2)],
        ),
        dotData: FlDotData(show: false),
      ),
    ];

    // final LineChartBarData chart1 = _lineBarsData[0];
    LineChartData mainData() {
      return LineChartData(
        minX: -1,
        maxX: 31,
        minY: 0,
        maxY: max.toDouble() * 1.3,
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
              showTitles: true,
              reservedSize: 20,
              getTextStyles: (value) => const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10.0),
              getTitles: (value) {
                if (value.toInt() == 1 ||
                    value.toInt() == 15 ||
                    value.toInt() == 30) {
                  return (value.toInt()).toString() + '/11/2020';
                } else
                  return '';
              },
              margin: 8.0),
          leftTitles: SideTitles(
            showTitles: true,
            reservedSize: 20,
            getTextStyles: (value) => const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10.0),
            getTitles: (value) {
              if (value.toInt() == max || value.toInt() == max / 2) {
                return value.toInt().toString();
              } else
                return '';
            },
          ),
        ),
        borderData: FlBorderData(
            show: true,
            border: Border(
                left: BorderSide(color: Colors.white),
                bottom: BorderSide(color: Colors.white))),
        // showingTooltipIndicators: listShowSpot.map((index) {
        //   return ShowingTooltipIndicators(index, [
        //     LineBarSpot(
        //         chart1, _lineBarsData.indexOf(chart1), chart1.spots[index]),
        //   ]);
        // }).toList(),
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipPadding: EdgeInsets.all(5.0),
            tooltipBgColor: Colors.white,
            tooltipRoundedRadius: 8.0,
            getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
              return lineBarsSpot.map((lineBarSpot) {
                return LineTooltipItem(
                  lineBarSpot.x.toInt().toString() +
                      '/11/2020\n' +
                      '\$' +
                      lineBarSpot.y.toString(),
                  const TextStyle(
                      color: Colors.black,
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold),
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: _lineBarsData,
      );
    }

    Widget buildChart() {
      getMax();
      return Column(
        children: <Widget>[
          Container(
            color: Utils.primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(13),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Income",
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        "Average: .",
                        style: GoogleFonts.nunito(
                            textStyle: TextStyle(color: Colors.white),
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                  child: Container(
                    child: FaIcon(
                      FontAwesomeIcons.dollarSign,
                      color: Colors.white,
                      size: 17.0,
                    ),
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          AspectRatio(
            aspectRatio: 1.5,
            child: Container(
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(10.0),
                color: Utils.primaryColor,
              ),
              child: LineChart(mainData()),
            ),
          ),
        ],
      );
    }

    Widget buildDetail() {
      var detail = <Widget>[];
      for (var spot in listSpot) {
        detail.add(Container(
          color: Utils.primaryColor,
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                spot.x.toInt().toString() + '/11/2020',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                '\$' + spot.y.toString(),
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ));
      }
      return Column(
        children: detail,
      );
    }

    return Scaffold(
      backgroundColor: Utils.primaryColor,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              color: Utils.primaryColor,
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
                    child: GestureDetector(
                      onTap: () => sidebarBt(),
                      child: Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //Chart
            Container(
              padding: EdgeInsets.only(
                top: 10.0,
                bottom: 10.0,
                right: 20.0,
                left: 10.0,
              ),
              child: buildChart(),
            ),

            //Detail
            Expanded(
              child: SingleChildScrollView(
                child: buildDetail(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
