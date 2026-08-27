import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remind/core/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:remind/core/schedule/presentation/widgets/schedule_widget.dart';

class ListScheduleWidget extends StatelessWidget {
  const ListScheduleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        if (state is ScheduleLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ScheduleLoaded) {
          return ListView.builder(
            itemCount: state.schedules.length,
            itemBuilder: (context, index) {
              final schedule = state.schedules[index];
              final isNew = schedule
                  .description
                  .isEmpty;
              return ScheduleWidget(
                key: ValueKey(schedule.index), // ← дуже важливо, дивись пункт 4
                scheduleEntity: schedule,
                created: isNew,
              );
            },
          );
        }
        if (state is ScheduleError) {
          return Text('Помилка: ${state.message}');
        }
        return const Center(child: Text("There is Noting"));
      },
    );
  }
}
