import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remind/core/schedule/presentation/widgets/card_week_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remind/core/schedule/presentation/bloc/week_bloc.dart';

class WeekWidget extends StatelessWidget {
  const WeekWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;

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
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.read<WeekBloc>().add(MinusWeek()),
                    color: Colors.white,
                    icon: Icon(Icons.arrow_left_sharp),
                    iconSize: 40,
                  ),
                  Spacer(),
                  Center(
                    child: Text(
                      loaded.month,
                      style: GoogleFonts.nokora(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () => context.read<WeekBloc>().add(PlusWeek()),
                    color: Colors.white,
                    icon: Icon(Icons.arrow_right_sharp),
                    iconSize: 40,
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
                    displayColor = const Color.fromARGB(255, 182, 219, 236);
                  } else if (week.color != null) {
                    displayColor = week.color!;
                  } else {
                    displayColor = Colors.white;
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
