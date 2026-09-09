import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remind/core/schedule/presentation/bloc/day_bloc.dart';

class OneDayWidget extends StatelessWidget {
  const OneDayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<DayBloc, DayState>(
      builder: (context, state) {
        if (state is DayLoading || state is DayInital) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is DayError) {
          return const Text('Error in downloading information');
        }

        final loaded = state as DayLoadded;
        final selectedDay = loaded.selectedDay;
        final data =
            "${selectedDay.day.toString()}/${selectedDay.month.toString()}/${selectedDay.year.toString()}";
        final information = state.information;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.read<DayBloc>().add(MinusDay()),
                    color: Colors.white,
                    icon: const Icon(Icons.arrow_left_sharp),
                    iconSize: 40,
                  ),
                  const Spacer(),
                  Text(
                    loaded.month,
                    style: GoogleFonts.nokora(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => context.read<DayBloc>().add(PlusDay()),
                    color: Colors.white,
                    icon: const Icon(Icons.arrow_right_sharp),
                    iconSize: 40,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: screenWidth / 20,
                horizontal: screenHeight / 14,
              ),
              child: SizedBox(
                height: screenHeight / 2,
                width: screenWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 234, 255, 252),
                    borderRadius: BorderRadius.circular(6.5),
                    border: Border.all(
                      color: const Color.fromARGB(255, 92, 92, 92),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                selectedDay.day.toString(),
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                loaded.name,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                data,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          information,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
