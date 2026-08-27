import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remind/core/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:remind/core/schedule/presentation/widgets/list_schedule_widget.dart';

class WeekScreen extends StatefulWidget {
  const WeekScreen({super.key});

  @override
  State<WeekScreen> createState() => _WeekScreenState();
}

class _WeekScreenState extends State<WeekScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ScheduleBloc>().add(LoadSchedule());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              print("Pressed the button");
              context.read<ScheduleBloc>().add(NewSchedule());
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: ListScheduleWidget(),
    );
  }
}
