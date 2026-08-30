import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remind/common/widgets/circe_button_widget.dart';
import 'package:remind/core/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:remind/core/schedule/presentation/widgets/schedule_widget.dart';

class ListScheduleWidget extends StatefulWidget {
  const ListScheduleWidget({super.key});

  @override
  State<ListScheduleWidget> createState() => _ListScheduleWidgetState();
}

class _ListScheduleWidgetState extends State<ListScheduleWidget> {
  bool showActions = false;
  final List<Widget> widgets = [
    CircleButtonWidget(
      color: Colors.redAccent.shade400,
      icon: Icons.delete,
      onPressed: () {},
    ),
    CircleButtonWidget(
      color: Colors.redAccent.shade100,
      icon: Icons.remove,
      onPressed: () {},
    ),
    CircleButtonWidget(
      color: Colors.grey,
      icon: Icons.delete,
      onPressed: () {},
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        if (state is ScheduleLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ScheduleLoaded) {
          return Expanded(
            child: ListView.builder(
              itemCount: state.schedules.length,
              itemBuilder: (context, index) {
                final schedule = state.schedules[index];
                final isNew = schedule.description.isEmpty;
                return GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.velocity.pixelsPerSecond.dx > 0) {
                      setState(() => showActions = false);
                    } else {
                      setState(() => showActions = true);
                    }
                  },
                  onTap: () => setState(() => showActions = !showActions),
                  child: Stack(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        transform: Matrix4.translationValues(
                          showActions
                              ? ((widgets.length.toDouble() * 80))
                              : 0, //-
                          0,
                          0,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 80,
                              width: 80,
                              child: Center(
                                child: Text(
                                  index.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            ScheduleWidget(
                              key: ValueKey(schedule.index),
                              scheduleEntity: schedule,
                              created: isNew,
                            ),
                          ],
                        ),
                      ),
                      if (showActions)
                        SizedBox(
                          width: widgets.length.toDouble() * 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: widgets,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
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
