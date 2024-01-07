import 'package:activity_management/model/Interfaces/i_calendar.dart';

class EventOnCalendar extends IEventOnCalendar {
  EventOnCalendar(
      DateTime startDate, DateTime endDate, String description, String title) {
    eventName = title;
    this.description = description;
    this.startDate = startDate;
    this.endDate = endDate;
  }
}
