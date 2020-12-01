import 'package:CoachTicketSelling/Utils/GlobalValues.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:CoachTicketSelling/Utils/Route.dart';

class ManagerMainView extends StatefulWidget {
  @override
  _ManagerMainViewState createState() => _ManagerMainViewState();
}

class _ManagerMainViewState extends State<ManagerMainView>
    with AutomaticKeepAliveClientMixin {
  int year = 2000;
  final monthObjectSize = 76.0;
  List<String> monthLs = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  List<Icon> iconLs = <Icon>[
    Icon(Icons.show_chart),
    Icon(Icons.add),
    Icon(Icons.list_alt),
  ];

  List<bool> monthState = List<bool>.generate(12, (index) => false);
  List<bool> bottomAppState = List<bool>.generate(3, (index) => false);
  int currentMonthState = -1;
  int currentBABState = -1;
  ScrollController _scrollController = ScrollController();

  double avgIncome = 2884.3;

  List<FlSpot> listSpot = [
    FlSpot(0, 3),
    FlSpot(2.6, 2),
    FlSpot(4.9, 5),
    FlSpot(6.2, 4),
    FlSpot(7.2, 5),
    FlSpot(8.9, 5),
    FlSpot(13, 5),
  ];

  List<int> listShowSpot = [3];

  void refactorYear(int dif) {
    setState(() {
      year = year + dif;
    });
  }

  void monthAnimate(int index) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      double pos = 0;
      if (index <= 2) {
        pos = 0;
      } else {
        pos = (index - 2) * monthObjectSize;
      }
      _scrollController.animateTo(pos,
          curve: Curves.easeIn, duration: Duration(milliseconds: 500));
      currentMonthState = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentDayOnClick();
    bottomAppBarOnClick(0);
  }

  void notificationOnClick() {
    // TODO: Create Route
  }

  void currentDayOnClick() {
    // TODO: Create Animation
    DateTime now = DateTime.now();
    print("Now time: Month: ${now.month} | Year: ${now.year}");
    if ((year == now.year) && (currentMonthState == now.month)) {
      return;
    }
    print("Current month $currentMonthState");
    print("Current month $monthState");
    setState(() {
      // refactorYear(now.year - yearLs[1]);
      year = now.year;
      monthOnClick(now.month - 1);
    });
  }

  void monthOnClick(int month) {
    // TODO: Action OnClick
    if (currentMonthState == -1) {
      currentMonthState = month;
    } else {
      if (currentMonthState == month) {
        return;
      } else {
        monthState[currentMonthState] = false;
      }
    }
    setState(() {
      monthState[month] = true;
      monthAnimate(month);
    });
  }

  void bottomAppBarOnClick(int index) {
    //TODO: func
    if (currentBABState == -1) {
      currentBABState = index;
    } else {
      if (currentBABState == index) {
        return;
      } else {
        bottomAppState[currentBABState] = false;
        currentBABState = index;
      }
    }
    setState(() {
      bottomAppState[index] = true;
    });
  }

  List<Widget> buildMonth() {
    List<Widget> _monthLs = List<Widget>();
    for (int i = 0; i < monthLs.length; i++) {
      _monthLs.add(Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: FlatButton(
            minWidth: 30.0,
            shape: StadiumBorder(),
            color: monthState[i] ? Utils.primaryColor : null,
            textColor: monthState[i] ? Colors.white : Colors.black,
            onPressed: () => monthOnClick(i),
            child: Text(monthLs[i])),
      ));
    }
    return _monthLs;
  }

  List<Widget> buildBottomAppBar() {
    List<Widget> _buttonLs = List<Widget>();
    for (int i = 0; i < iconLs.length; i++) {
      _buttonLs.add(Container(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
        child: FlatButton(
          minWidth: 30.0,
          shape: CircleBorder(),
          color: bottomAppState[i]
              ? Utils.primaryColor
              : Utils.primaryColor.withOpacity(0.5),
          textColor: Colors.white,
          child: iconLs[i],
          onPressed: () => bottomAppBarOnClick(i),
        ),
      ));
    }
    return _buttonLs;
  }

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
          //Todo: add func to change view/animation
          Navigator.pushNamed(context, DetailIncomeChartViewRoute);
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
          //Todo: add func to change view/animation
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
                    color: Colors.redAccent,
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
          //Todo: add func to change view/animation
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
                    color: Colors.blueAccent,
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
          //Todo: add func to change view/animation
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
                    color: Colors.amberAccent.shade400,
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

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              // Header
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
              child: Stack(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        // Notification
                        onTap: notificationOnClick,
                        child: Icon(
                          Icons.notifications,
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: currentDayOnClick,
                        child: Text(
                          "Today",
                          style: TextStyle(color: Utils.primaryColor),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Text("Data Report", style: TextStyle(fontSize: 20)),
                  )
                ],
              ),
            ), // Title
            // Container(
            //   // Appbar
            //   padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: <Widget>[
            //       FlatButton(
            //           minWidth: 10.0,
            //           shape: StadiumBorder(),
            //           onPressed: () => refactorYear(-1),
            //           child: Text(
            //             (year - 1).toString(),
            //             style: TextStyle(color: Colors.black38),
            //           )),
            //       Text(
            //         year.toString(),
            //         style: TextStyle(color: Utils.primaryColor),
            //       ),
            //       FlatButton(
            //           minWidth: 10.0,
            //           shape: StadiumBorder(),
            //           onPressed: () => refactorYear(1),
            //           child: Text(
            //             (year + 1).toString(),
            //             style: TextStyle(color: Colors.black38),
            //           )),
            //     ],
            //   ),
            // ), // Year
            // SingleChildScrollView(
            //   scrollDirection: Axis.horizontal,
            //   controller: _scrollController,
            //   padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            //   child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //       children: buildMonth()),
            // ), // Month
            Divider(
              color: Colors.black38,
            ),
            Expanded(
              //Chart view
              child: SingleChildScrollView(
                child: Column(
                  children: chartLs,
                ),
              ),
            ),
            Align(
              // bottom app bar
              alignment: Alignment.bottomCenter,
              child: BottomAppBar(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: buildBottomAppBar(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
