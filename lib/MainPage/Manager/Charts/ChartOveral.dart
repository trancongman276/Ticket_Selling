import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:CoachTicketSelling/Utils/Route.dart';
import 'package:CoachTicketSelling/Utils/enum.dart';
import 'package:CoachTicketSelling/classes/Implement/BillImpl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OveralChartView extends StatefulWidget {
  @override
  _OveralChartViewState createState() => _OveralChartViewState();
}

class _OveralChartViewState extends State<OveralChartView> {
  final Map<ChartQuery, Color> colorLs = <ChartQuery, Color>{
    ChartQuery.Income: Utils.primaryColor,
    ChartQuery.KPIs: Colors.redAccent,
    ChartQuery.MostVisited: Colors.purple,
    ChartQuery.Rating: Colors.blueAccent,
  };
  final List<String> lableLs = [
    'Income',
    'KPIs',
    'Most Visited',
    'User Rating'
  ];
  final List<ChartQuery> typeChartLs = [
    ChartQuery.Income,
    ChartQuery.KPIs,
    ChartQuery.MostVisited,
    ChartQuery.Rating
  ];
  final List<dynamic> iconLs = [
    FaIcon(
      FontAwesomeIcons.dollarSign,
      color: Colors.white,
      size: 17.0,
    ),
    FaIcon(
      FontAwesomeIcons.chartLine,
      color: Colors.white,
      size: 17.0,
    ),
    FaIcon(
      FontAwesomeIcons.landmark,
      color: Colors.white,
      size: 17.0,
    ),
    FaIcon(
      FontAwesomeIcons.solidStar,
      color: Colors.white,
      size: 15.0,
    )
  ];
  final List<FlSpot> listSpot = [
    FlSpot(0, 3),
    FlSpot(2.6, 2),
    FlSpot(4.9, 5),
    FlSpot(6.2, 4),
    FlSpot(7.2, 5),
    FlSpot(8.9, 5),
    FlSpot(13, 5),
  ];
  final List<int> listShowSpot = [9];
  List<int> max = [0, 0];
  BillImplement billImplement = BillImplement.instance;
  List<Widget> overViewWidge = [];
  _OveralChartViewState() {
    _getData();
  }
  List<FlSpot> _spotIncomeList = [];
  List<FlSpot> _spotKpisList = [];
  List<Widget> _barChartList = [];
  var _dataList = [];
  bool _getData() {
    _dataList = billImplement.getAllDailyIncome(DateTime.now().month - 1);
    _spotIncomeList = _dataToSplot();
    getMax(0);
    _dataList = billImplement.getKpis();
    _spotKpisList = _dataToSplot();
    getMax(1);
    _dataList = billImplement.getVisited();
    _barChartList.add(viewMax());
    _dataList = billImplement.getRating();
    _barChartList.add(viewMax());
    return true;
  }

  Widget viewMax() {
    List<Widget> list = [];
    for (int i = 0; i < 3; i++) {
      list.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${i + 1}. ${_dataList[DateTime.now().month - 1].keys.elementAt(i)}',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              _dataList[DateTime.now().month - 1]
                      [_dataList[DateTime.now().month - 1].keys.elementAt(i)]
                  .toString(),
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            'Top 3:',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Column(
            children: list,
          ),
        ],
      ),
    );
  }

  void getMax(int index) {
    List<FlSpot> _spotList = index == 0 ? _spotIncomeList : _spotKpisList;
    _spotList.forEach((element) {
      if (element.isNotNull() &&
          element.y != double.nan &&
          element.y != double.infinity) if (element.y > max[index])
        max[index] = element.y.toInt();
    });
  }

  List<FlSpot> _dataToSplot() {
    List<FlSpot> spotList = [];
    if (_dataList.length != 0)
      for (int index = 0; index < _dataList.length; index++) {
        var value = _dataList[index].toDouble();

        if (value.isNaN || !value.isFinite || value == 0.0)
          spotList.add(FlSpot(index.toDouble(), 0));
        else {
          spotList.add(FlSpot(index.toDouble(), value));
        }
      }
    else
      spotList.add(FlSpot(0, 0));

    return spotList;
  }

  @override
  Widget build(BuildContext context) {
    LineChartBarData lineChartBarData(int index) {
      List<FlSpot> spotLs = index == 0 ? _spotIncomeList : _spotKpisList;
      return LineChartBarData(
        spots: spotLs,
        dotData: FlDotData(
            show: true,
            checkToShowDot: (FlSpot spot, LineChartBarData barData) {
              return spot == spotLs[listShowSpot[0]] ?? true;
            }),
        isCurved: true,
        colors: [Colors.white],
        barWidth: 2.0,
        isStrokeCapRound: true,
        belowBarData: BarAreaData(
          show: true,
          colors: [Colors.white.withOpacity(0.2)],
        ),
      );
    }

    LineChartData mainData(int index) {
      LineChartBarData _lineChartBarData = lineChartBarData(index);

      return LineChartData(
        minX: -1,
        maxX: 31,
        minY: 0,
        maxY: max[index].toDouble() * 2,
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        showingTooltipIndicators: listShowSpot.map((index) {
          return ShowingTooltipIndicators(index, [
            LineBarSpot(
                _lineChartBarData, index, _lineChartBarData.spots[index]),
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
        lineBarsData: [_lineChartBarData],
      );
    }

    return ListView.builder(
      itemCount: colorLs.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              index > 1 ? DetailBarChartViewRoute : DetailIncomeChartViewRoute,
              arguments: DetailedChartArgs(
                  typeChartLs[index], colorLs[typeChartLs[index]]),
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            child: Stack(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: colorLs[typeChartLs[index]],
                    ),
                    child: index < 2
                        ? LineChart(mainData(index))
                        : _barChartList[index - 2],
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
                              lableLs[index],
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
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: iconLs[index],
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
        );
      },
    );
  }
}
