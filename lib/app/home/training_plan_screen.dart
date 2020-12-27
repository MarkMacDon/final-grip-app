import 'package:andrea_project/app/home/list_items_builder.dart';
import 'package:andrea_project/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:andrea_project/app/home/models/training_day.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:andrea_project/app/home/training_day_list_tile.dart';
import 'package:andrea_project/app/home/calendar_list_view.dart';

class TrainingPlanScreen extends StatefulWidget {
  TrainingPlanScreen({@required this.database});
  final Database database;
  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TrainingPlanScreen(database: database),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _TrainingPlanScreenState createState() => _TrainingPlanScreenState();
}

class _TrainingPlanScreenState extends State<TrainingPlanScreen> {
  List<dynamic> _selectedEvents = [];
  AnimationController _animationController;
  CalendarController _calendarController;

  void _addTrainingPlan(BuildContext context) {
    try {
      List trainingDays = widget.database.createTrainingDayList();
      widget.database.createTrainingPlan(trainingDays);
      setState(() {
        widget.database.hasPlan();
      });
    } catch (e) {
      print('Failed: $e');
    }
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    print(day);
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  Map<DateTime, List<dynamic>> _events(List<TrainingDay> trainingDays) {
    Map<DateTime, List<dynamic>> events = Map();
    for (TrainingDay day in trainingDays) {
      DateTime parsedDay = DateTime.tryParse(day.day);
      events[parsedDay] = ['THIS IS BORKIN'];
    }
    return events;
  }

  @override
  void initState() {
    super.initState();
    _selectedEvents = [];

    _calendarController = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Made it'),
        ),
        body: _buildStreamBuilder());
  }

  StreamBuilder<List<TrainingDay>> _buildStreamBuilder() {
    return StreamBuilder<List<TrainingDay>>(
      stream: widget.database.trainingDaysStream(),
      builder: (context, snapshot) {
        List<TrainingDay> trainingDays = snapshot.data;
        if (snapshot.hasData) {
          return Column(children: [
            _buildTableCalendar(trainingDays),
            ..._selectedEvents.map((event) => CalendarListView(event)),
            _buildDaysList(snapshot),
          ]);
        }
        //TODO ADD LOADING SCREEN HERE
        return CircularProgressIndicator();
      },
    );
  }

  _buildTableCalendar(List<TrainingDay> trainingDays) {
    return TableCalendar(
      events: _events(trainingDays),
      calendarController: _calendarController,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.deepOrange[400],
        todayColor: Colors.deepOrange[200],
        markersColor: Colors.brown[700],
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Expanded _buildDaysList(AsyncSnapshot<List<TrainingDay>> snapshot) {
    return Expanded(
      child: SizedBox(
        height: 100,
        child: ListItemsBuilder<TrainingDay>(
          snapshot: snapshot,
          itemBuilder: (context, trainingDay) => TrainingDayListTile(
            complete: trainingDay.complete ?? false,
            day: DateTime.parse(trainingDay.day).day.toString(),
            onPressed: () {
              _updateName(trainingDay);
            },
            //todo set day state toggle
            //todo create a new tile with update with or make the tile mutable?
            //todo or change make the job model again
            //* var _selectedTrainingDay = trainingDay.day
            //* in firestore class updateData (trainingDay.day newValues)
            //* firestore.instance.collection(uid).document(trainingDay.day).updateData(newValues)
            title: trainingDay.name,
          ),
        ),
      ),
    );
  }

  void _updateName(TrainingDay trainingDay) async {
    trainingDay;
  }

  // _buildSelectPlanPage(BuildContext context) {
  //   return Column(
  //     children: [
  //       FlatButton(
  //           onPressed: () {
  //             _addTrainingPlan(context);
  //             print('Plan Added');
  //           },
  //           child: Text('Select'))
  //     ],
  //   );
  // }
  //   _printDay() {
  //   final trainingDay = TrainingDay(
  //       day: DateTime.now().toIso8601String(),
  //       trainingTimes: [1, 2, 3],
  //       name: 'Tester',
  //       complete: false);
  //   widget.database.createTrainingDay(trainingDay);
  // }

}
