import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remind/common/widgets/circe_button_widget.dart';
import 'package:remind/common/widgets/text_controller_widget.dart';
import 'package:remind/core/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:remind/core/schedule/presentation/bloc/week_bloc.dart';
import 'package:remind/core/schedule/presentation/widgets/schedule_widget.dart';

class ListScheduleWidget extends StatefulWidget {
  const ListScheduleWidget({super.key});

  @override
  State<ListScheduleWidget> createState() => _ListScheduleWidgetState();
}

class _ListScheduleWidgetState extends State<ListScheduleWidget> {
  bool showActions = false;
  static const int widgetsCount = 3;

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
                final weekState = context.read<WeekBloc>().state;
                final day = weekState is WeekLoaded
                    ? weekState.selectedDay.toString()
                    : DateTime.now().toString();

                return GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.velocity.pixelsPerSecond.dx < 0) {
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
                              ? ((widgetsCount.toDouble() * 80))
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
                                  "${++index}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ScheduleWidget(
                                key: ValueKey(schedule.index),
                                scheduleEntity: schedule,
                                created: isNew,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (showActions)
                        Padding(
                          padding: const EdgeInsetsGeometry.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                          child: SizedBox(
                            width: widgetsCount.toDouble() * 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CircleButtonWidget(
                                  color: Colors.redAccent.shade400,
                                  icon: Icons.delete,
                                  onPressed: () {
                                    context.read<ScheduleBloc>().add(
                                      DeleteShedule(day: day, index: index),
                                    );
                                  },
                                ),
                                CircleButtonWidget(
                                  color: Colors.redAccent.shade100,
                                  icon: Icons.remove,
                                  onPressed: () {
                                    _showDialog(
                                      context,
                                      "Why u didin't do it?",
                                      day,
                                      index,
                                    );
                                  },
                                ),
                                CircleButtonWidget(
                                  color: Colors.grey,
                                  icon: Icons.edit,
                                  onPressed: () {
                                    context.read<ScheduleBloc>().add(
                                      StartEditing(index: schedule.index),
                                    );
                                  },
                                ),
                                CircleButtonWidget(
                                  color: Colors.green.shade400,
                                  icon: Icons.edit,
                                  onPressed: () {
                                    context.read<ScheduleBloc>().add(
                                      CompleteSchedule(day: day, index: index),
                                    );
                                  },
                                ),
                              ],
                            ),
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

  void _showDialog(
    BuildContext context,
    String whatToDo,
    String day,
    int index,
  ) {
    final textController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.grey.shade400,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  whatToDo,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),
                TextControllerWidget(
                  controller: textController,
                  label: 'Enter text',
                  hint: 'end',
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Please enter something';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  style: ButtonStyle(),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      context.read<ScheduleBloc>().add(
                        CanceledSchedule(
                          reason: textController.text,
                          day: day,
                          index: index,
                        ),
                      );
                    }
                  },
                  child: Text("Press"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
