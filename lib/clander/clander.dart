import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventData {
  final String title;
  final String description;

  EventData(this.title, this.description);
}

class CalendarPage extends StatelessWidget {
  final List<EventData> _events = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Calendar Page'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Month View'),
              Tab(text: 'Week View'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildCalendarView(CalendarView.month),
            _buildCalendarView(CalendarView.week),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarView(CalendarView view) {
    DateTime now = DateTime.now();
    return Column(
      children: [
        Expanded(
          child: SfCalendar(
            view: view,
            dataSource: _getCalendarDataSource(),
            initialDisplayDate: now,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Event Title',
                ),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Event Description',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _addEvent();
                },
                child: const Text('Add Event'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _DataSource _getCalendarDataSource() {
    List<Appointment> appointments = [];

    for (var event in _events) {
      appointments.add(Appointment(
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 1)),
        subject: event.title,
        notes: event.description,
      ));
    }

    return _DataSource(appointments);
  }

  void _addEvent() {
    String title = _titleController.text;
    String description = _descriptionController.text;

    if (title.isNotEmpty && description.isNotEmpty) {
      EventData newEvent = EventData(title, description);
      _events.add(newEvent);
      _titleController.clear();
      _descriptionController.clear();
    }
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}