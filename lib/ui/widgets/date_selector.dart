import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nba_go/blocs/blocs.dart';

enum WeekDays { Mon, Tue, Wed, Thu, Fri, Sat, Sun }

enum Months { Jan, Feb, Mar, Apr, May, Jun, Jul, Ago, Sep, Oct, Nov, Dec }

class DateSelector extends StatefulWidget {

  final DateTime currentDate;

  DateSelector(this.currentDate)
    : assert(currentDate != null);

  @override
  State<StatefulWidget> createState() => DateSelectorState(currentDate);
}

class DateSelectorState extends State<DateSelector> {
  
  DateTime _currentDate;
  DateTime _bottomLimit;
  DateTime _topLimit;
  ScrollController scrollController;
  static const double DATE_ITEM_WIDTH = 60.0;
  static const int GAMES_DATE_OFFSET = 30;
  static const Color SELECTED_COLOR = Colors.white;

  DateSelectorState(this._currentDate)
    : assert(_currentDate != null);
  
  @override 
  void initState() {
    this.scrollController = ScrollController();
    this._topLimit = this._currentDate.add(Duration(days: GAMES_DATE_OFFSET));
    this._bottomLimit = this._currentDate.subtract(Duration(days: GAMES_DATE_OFFSET));
    super.initState();
    // This will scroll the ListView to the currentDate/SelectedDate
    WidgetsBinding.instance
     .addPostFrameCallback((_) => scrollController.jumpTo(_calculateSelectedItemOffset()));
  }

  @override
  Widget build(BuildContext context) {
  return Material(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        controller: scrollController,
        itemCount: this._topLimit.difference(this._bottomLimit).inDays,
        itemBuilder: (BuildContext context, int index) {
          DateTime dateItem = this._bottomLimit.add(new Duration(days: index));
          String weekDay = WeekDays.values[dateItem.weekday-1].toString().split('.').last;
          String month = Months.values[dateItem.month-1].toString().split('.').last;
          return InkWell(
            child: Container(
              child: Stack(
                children: <Widget>[
                  Align(
                    child: Container(
                      child: Text(month, style: Theme.of(context).textTheme.subtitle),
                      margin: EdgeInsets.only(top: 7.0),
                    ),
                    alignment: Alignment.topCenter,
                  ),
                  Align(
                    child: Container(
                      child: Text(dateItem.day.toString(), style: Theme.of(context).textTheme.display1),
                      margin: EdgeInsets.only(top: 30.0),
                      ),
                    alignment: Alignment.center,
                  ),
                  Align(
                    child: Container(
                      child: Text(weekDay, style: Theme.of(context).textTheme.subhead),
                      margin: EdgeInsets.only(top: 20.0),
                      ),
                    alignment: Alignment.topCenter,  
                  ),
                  (dateItem.isAtSameMomentAs(this._currentDate))
                  ? Align(
                    child: Container(
                      height: 3.0,
                      width: 35.0,
                      color: SELECTED_COLOR,
                    ),
                    alignment: Alignment.bottomCenter,
                  )
                  : Container()
                ],
              ),
              width: DATE_ITEM_WIDTH,
              height: 80.0,
              color: (this._currentDate.isAtSameMomentAs(dateItem))
                ? Theme.of(context).toggleableActiveColor
                : Theme.of(context).primaryColor,
            ),
            onTap: () {
              this.setState(() {
                  this._currentDate = dateItem;
                  this.scrollController.animateTo(
                    _calculateSelectedItemOffset(), 
                    duration: Duration(seconds: 1), 
                    curve: Curves.bounceOut);
                  BlocProvider.of<GameListBloc>(context).dispatch(RefreshGameList(refreshDate: this._currentDate));
                });
            },
          );
        },
      ),
      elevation: 12.0
    );
  }

   // We substract 2 days as an offset to center the date in screen
  double _calculateSelectedItemOffset() => (this._currentDate.difference(this._bottomLimit).inDays - 2) * DATE_ITEM_WIDTH;
}