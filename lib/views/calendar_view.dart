import 'package:activity_management/model/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CalendarView extends StatefulWidget {
  @override
  State<CalendarView> createState() => _CalendarViewState();
}

//idea creare una grid dei giorni
class _CalendarViewState extends State<CalendarView> {
  DateTime now = DateTime.now();
  late DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

// mettere un modo per passare gli eventi inside
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text('Calendario')),
      body: GridView.count(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 7,
          // Generate 100 widgets that display their index in the List.
          children: List.generate(lastDayOfMonth.day, (day) {
            return DayCalendarView(
              dayCalendar: now,
              day: day,
              eventCalendarList: [
                EventOnCalendar(
                    DateTime.now(),
                    DateTime.now().add(Duration(hours: 2)),
                    'descrizione',
                    'Titolo'),
              ],
            );
          })));
}

class DayCalendarView extends StatelessWidget {
  const DayCalendarView({
    super.key,
    required this.dayCalendar,
    required this.day,
    this.eventCalendarList,
  });
  final List<EventOnCalendar>? eventCalendarList;
  final DateTime dayCalendar;
  final int day;
  @override
  Widget build(BuildContext context) {
    var selectedDay = DateTime.now().day - 1 == day;
    var hoverColorCard = Colors.transparent;
    return Card(
        color: selectedDay ? Colors.red : Colors.white60,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        elevation: 2,
        child: Column(children: [
          GestureDetector(
            onTap: () => print('premo solo il titolo'),
            child: ListTile(
              tileColor: Colors.white38,
              title: Text(
                  '${DateFormat('EEEE').format(DateTime(dayCalendar.year, dayCalendar.month, day + 1))} ${day + 1}',
                  style: TextStyle(fontSize: 10)),
            ),
          ),
          //ListView()
          Expanded(
            child: ListView.builder(
              shrinkWrap: true, // questo fa schiantare tutto
              itemCount: eventCalendarList!.length,
              itemBuilder: (context, index) {
                return EventView(eventCalendarList: eventCalendarList![index]);
              },
            ),
          )
        ]));
  }
}

class EventView extends StatefulWidget {
  EventView({
    super.key,
    required this.eventCalendarList,
  });

  final EventOnCalendar eventCalendarList;

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  var hoverColorCard = Colors.transparent;

  void _showPopup() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            content: Text('CIAOOOOOOOOOOOOO'),
          );
        });
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: () => {
            print(
                'sto a fare il print dell evento per giorno ${widget.eventCalendarList.startDate}'),
            _showPopup()
          },
      child: MouseRegion(
          onEnter: (PointerEvent event) => {
                setState(() {
                  hoverColorCard = Colors.yellow;
                })
              },
          onExit: (PointerEvent event) => {
                setState(() {
                  hoverColorCard = Colors.transparent;
                })
              },
          child: Card(
              color: hoverColorCard,
              margin: EdgeInsetsDirectional.all(2),
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(color: Colors.white10),
                        child: Icon(
                          Icons.timer,
                          size: 12,
                        )),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(color: Colors.white10),
                      child: Text(
                          '${widget.eventCalendarList.startDate!.hour}-${widget.eventCalendarList.endDate!.hour}',
                          style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.90,
                      decoration: BoxDecoration(color: Colors.white38),
                      child: const Text('prova'),
                    ),
                  ),
                ],
              ))));
}
