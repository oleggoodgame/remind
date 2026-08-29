import 'package:flutter/material.dart';
import 'package:remind/core/schedule/presentation/widgets/card_week_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remind/core/schedule/presentation/bloc/week_bloc.dart';

class WeekWidget extends StatelessWidget {
  const WeekWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<WeekBloc, WeekState>(
      builder: (context, state) {
        if (state is WeekLoading || state is WeekInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is WeekError) {
          return const Text('Помилка завантаження тижня');
        }

        final loaded = state as WeekLoaded;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: IconButton(
                      onPressed: () =>
                          context.read<WeekBloc>().add(MinusWeek()),
                      icon: const Icon(Icons.arrow_left_sharp),
                      iconSize: 40,
                    ),
                  ),
                  Center(
                    child: Text(
                      loaded.month,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      onPressed: () =>
                          context.read<WeekBloc>().add(PlusWeek()),
                      icon: const Icon(Icons.arrow_right_sharp),
                      iconSize: 40,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 80,
              child: ListView.builder(
                itemCount: loaded.weekList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final week = loaded.weekList[index];
                  final isSelected = loaded.selectedDay == week.day;
                  final Color displayColor;
                  if (isSelected) {
                    displayColor = isDark
                        ? Colors.blueGrey.shade600
                        : Colors.blueGrey.shade900;
                  } else if (week.color != null) {
                    displayColor = week.color!;
                  } else {
                    displayColor = isDark ? Colors.black : Colors.white;
                  }

                  return GestureDetector(
                    onTap: () {
                      context.read<WeekBloc>().add(SelectDay(day: week.day));
                    },
                    child: CardWeekWidget(week.name, week.day, displayColor),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}