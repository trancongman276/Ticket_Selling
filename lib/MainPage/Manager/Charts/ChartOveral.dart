import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:CoachTicketSelling/Utils/Route.dart';
import 'package:CoachTicketSelling/Utils/enum.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class OveralChartView extends StatelessWidget {
  final Map<ChartQuery, Color> colorLs = <ChartQuery, Color>{
    ChartQuery.Income: Utils.primaryColor,
    ChartQuery.KPIs: Colors.redAccent,
    ChartQuery.MostVisited: Colors.purple,
    ChartQuery.Rating: Colors.blueAccent,
  };

  final double avgIncome = 2884.3;

  final List<FlSpot> listSpot = [
    FlSpot(0, 3),
    FlSpot(2.6, 2),
    FlSpot(4.9, 5),
    FlSpot(6.2, 4),
    FlSpot(7.2, 5),
    FlSpot(8.9, 5),
    FlSpot(13, 5),
  ];

  final List<int> listShowSpot = [3];

  @override
  Widget build(BuildContext context) {
    final _lineBarsData = [
      LineChartBarData(
        spots: listSpot,
        dotData: FlDotData(
            show: true,
            checkToShowDot: (FlSpot spot, LineChartBarData barData) {
              return spot == listSpot[listShowSpot[0]] ?? true;
            }),
        isCurved: true,
        colors: [Colors.white],
        barWidth: 2.0,
        isStrokeCapRound: true,
        belowBarData: BarAreaData(
          show: true,
          colors: [Colors.white.withOpacity(0.2)],
        ),
      ),
    ];

    final LineChartBarData chart1 = _lineBarsData[0];
    LineChartData mainData() {
      return LineChartData(
        minX: 0,
        maxX: 10,
        minY: 0,
        maxY: 10,
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        showingTooltipIndicators: listShowSpot.map((index) {
          return ShowingTooltipIndicators(index, [
            LineBarSpot(
                chart1, _lineBarsData.indexOf(chart1), chart1.spots[index]),
          ]);
        }).toList(),
        lineTouchData: LineTouchData(
          enabled: false,
          touchTooltipData: LineTouchTooltipData(
            tooltipPadding: EdgeInsets.all(5.0),
            tooltipBgColor: Colors.white,
            tooltipRoundedRadius: 8.0,
            getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
              return lineBarsSpot.map((lineBarSpot) {
                return LineTooltipItem(
                  lineBarSpot.y.toString(),
                  const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: _lineBarsData,
      );
    }

    var chartLs = <Widget>[
      GestureDetector(
        // Income Chart
        onTap: () {
          Navigator.pushNamed(
            context,
            DetailIncomeChartViewRoute,
            arguments: DetailedChartArgs(
                ChartQuery.Income, colorLs[ChartQuery.Income]),
          );
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
          child: Stack(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1.7,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Utils.primaryColor,
                  ),
                  child: LineChart(mainData()),
                ),
              ),
              Container(
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
                            "Average: \$$avgIncome.",
                            style: GoogleFonts.nunito(
                                textStyle: TextStyle(color: Colors.white),
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 12.0),
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
            ],
          ),
        ),
      ),
      GestureDetector(
        // KPIs chart
        onTap: () {
          Navigator.pushNamed(
            context,
            DetailIncomeChartViewRoute,
            arguments:
                DetailedChartArgs(ChartQuery.KPIs, colorLs[ChartQuery.KPIs]),
          );
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
          child: Stack(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1.7,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: colorLs[ChartQuery.KPIs],
                  ),
                  child: LineChart(mainData()),
                ),
              ),
              Container(
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
                            "KPIs",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            "Average: \$$avgIncome.",
                            style: GoogleFonts.nunito(
                                textStyle: TextStyle(color: Colors.white),
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 12.0),
                      child: Container(
                        child: FaIcon(
                          FontAwesomeIcons.chartLine,
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
            ],
          ),
        ),
      ),
      GestureDetector(
        //Most visited
        onTap: () {
          Navigator.pushNamed(
            context,
            DetailIncomeChartViewRoute,
            arguments: DetailedChartArgs(
                ChartQuery.MostVisited, colorLs[ChartQuery.MostVisited]),
          );
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
          child: Stack(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1.7,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: colorLs[ChartQuery.MostVisited],
                  ),
                  child: LineChart(mainData()),
                ),
              ),
              Container(
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
                            "Most Visited",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 12.0),
                      child: Container(
                        child: FaIcon(
                          FontAwesomeIcons.landmark,
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
            ],
          ),
        ),
      ),
      GestureDetector(
        // User Rating
        onTap: () {
          Navigator.pushNamed(
            context,
            DetailIncomeChartViewRoute,
            arguments: DetailedChartArgs(
                ChartQuery.Rating, colorLs[ChartQuery.Rating]),
          );
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
          child: Stack(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1.7,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: colorLs[ChartQuery.Rating],
                  ),
                  child: LineChart(mainData()),
                ),
              ),
              Container(
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
                            "User rating",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 12.0),
                      child: Container(
                        child: Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 22.0,
                        ),
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ];

    return SingleChildScrollView(
      child: Column(
        children: chartLs,
      ),
    );
  }
}
