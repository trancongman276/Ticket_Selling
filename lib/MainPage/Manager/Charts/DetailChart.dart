import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:CoachTicketSelling/Utils/enum.dart';

class DetailChart extends StatefulWidget {
  final ChartQuery chart;
  final Color primaryColor;

  const DetailChart(
      {Key key, @required this.chart, @required this.primaryColor})
      : super(key: key);
  @override
  _DetailChartState createState() => _DetailChartState(chart, primaryColor);
}

class _DetailChartState extends State<DetailChart> {
  final ChartQuery chart;
  final Color primaryColor;
  String name;
  _DetailChartState(this.chart, this.primaryColor);

  ChartView currentView = ChartView.Monthly;

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
  int currentMonth = 10;
  Map<ChartView, List<FlSpot>> listSpot = {
    ChartView.Monthly: [
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
    ],
    ChartView.Yearly: [
      FlSpot(0, 30),
      FlSpot(1, 70),
      FlSpot(2, 20),
      FlSpot(3, 100),
      FlSpot(4, 50),
      FlSpot(5, 170),
      FlSpot(6, 150),
      FlSpot(7, 70),
      FlSpot(8, 90),
      FlSpot(9, 50),
      FlSpot(10, 190),
      FlSpot(11, 170),
    ],
  };
  Map<ChartView, int> max = {
    ChartView.Monthly: -1,
    ChartView.Yearly: -1,
  };
  // List<int> listShowSpot = [3];

  @override
  void initState() {
    super.initState();
    getName();
  }

  void getName() {
    switch (chart) {
      case ChartQuery.Income:
        name = 'Income';
        break;
      case ChartQuery.KPIs:
        name = 'KPIs';
        break;
      case ChartQuery.MostVisited:
        name = 'Most Visited';
        break;
      case ChartQuery.Rating:
        name = 'Rating';
        break;
    }
  }

  void backBt() {
    //Todo: Action on back button
    Navigator.pop(context);
  }

  void sidebarBt(String choice) {
    //Todo: Action on back button
    setState(() {
      currentMonth = monthLS.indexOf(choice) + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    void getMax() {
      listSpot[currentView].forEach((element) {
        if (element.y > max[currentView]) max[currentView] = element.y.toInt();
      });
    }

    final _lineBarsData = [
      LineChartBarData(
        spots: listSpot[currentView],
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
        maxX: currentView == ChartView.Monthly ? 31 : 12,
        minY: 0,
        maxY: max[currentView].toDouble() * 1.3,
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
                if (currentView == ChartView.Monthly) {
                  if (value.toInt() + 1 == 1 ||
                      value.toInt() + 1 == 15 ||
                      value.toInt() + 1 == 30) {
                    return (value.toInt() + 1).toString() +
                        '/' +
                        currentMonth.toString() +
                        '/2020';
                  } else
                    return '';
                } else {
                  if (currentView == ChartView.Yearly) {
                    if (value.toInt() + 1 == 1 ||
                        value.toInt() + 1 == 6 ||
                        value.toInt() + 1 == 12) {
                      return (value.toInt() + 1).toString() + '/2020';
                    } else
                      return '';
                  }
                }
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
              if (value.toInt() == max[currentView] ||
                  value.toInt() == ((max[currentView] / 2) ~/ 10 * 10)) {
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
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipPadding: EdgeInsets.all(5.0),
            tooltipBgColor: Colors.white,
            tooltipRoundedRadius: 8.0,
            getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
              return lineBarsSpot.map((lineBarSpot) {
                return LineTooltipItem(
                  (lineBarSpot.x.toInt() + 1).toString() +
                      (currentView == ChartView.Monthly
                          ? '/' + currentMonth.toString() + '/2020\n'
                          : '/2020\n') +
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
            color: primaryColor,
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
                        name,
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
                    // child: FaIcon(
                    //   FontAwesomeIcons.dollarSign,
                    //   color: Colors.white,
                    //   size: 17.0,
                    // ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                currentView = ChartView.Monthly;
                              });
                            },
                            child: Text(
                              "Monthly",
                              style: TextStyle(
                                  color: currentView == ChartView.Monthly
                                      ? primaryColor
                                      : Colors.white),
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            color: currentView == ChartView.Monthly
                                ? Colors.white
                                : null,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                currentView = ChartView.Yearly;
                              });
                            },
                            child: Text(
                              "Yearly",
                              style: TextStyle(
                                  color: currentView == ChartView.Yearly
                                      ? primaryColor
                                      : Colors.white),
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            color: currentView == ChartView.Yearly
                                ? Colors.white
                                : null,
                          ),
                        ),
                      ],
                    ),
                    // padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      color: Colors.white.withOpacity(0.3),
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
                color: primaryColor,
              ),
              child: LineChart(mainData()),
            ),
          ),
        ],
      );
    }

    Widget buildDetail() {
      var detail = <Widget>[];
      for (var spot in listSpot[currentView]) {
        detail.add(Container(
          color: primaryColor,
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                (spot.x.toInt() + 1).toString() +
                    '/' +
                    currentMonth.toString() +
                    '/2020',
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
