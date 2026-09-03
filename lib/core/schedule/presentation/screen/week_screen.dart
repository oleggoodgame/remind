import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remind/core/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:remind/core/schedule/presentation/bloc/week_bloc.dart';
import 'package:remind/core/schedule/presentation/widgets/list_schedule_widget.dart';
import 'package:remind/core/schedule/presentation/widgets/week_widget.dart';

class WeekScreen extends StatefulWidget {
  const WeekScreen({super.key});

  @override
  State<WeekScreen> createState() => _WeekScreenState();
}

class _WeekScreenState extends State<WeekScreen> {
  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    final todayDateOnly = DateTime(today.year, today.month, today.day);

    // context.read<ScheduleBloc>().add(
    //   LoadSchedule(day: todayDateOnly.toString()),
    // );
    context.read<WeekBloc>().add(GetWeeks());
    context.read<WeekBloc>().add(SelectDay(day: todayDateOnly));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WeekBloc, WeekState>(
      listenWhen: (previous, current) {
        if (previous is WeekLoaded && current is WeekLoaded) {
          return previous.selectedDay != current.selectedDay;
        }
        return current is WeekLoaded;
      },
      listener: (context, state) {
        if (state is WeekLoaded) {
          context.read<ScheduleBloc>().add(
            LoadSchedule(day: state.selectedDay.toString()),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(235, 10, 10, 10),
          actions: [
            IconButton.outlined(
              splashRadius: 15,
              color: Colors.white,
              style: ButtonStyle(),
              onPressed: () => context.read<ScheduleBloc>().add(NewSchedule()),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: const Column(children: [WeekWidget(), ListScheduleWidget()]),
      ),
    );
  }
}
