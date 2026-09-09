import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:remind/core/schedule/presentation/bloc/day_bloc.dart';
import 'package:remind/core/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:remind/core/schedule/presentation/bloc/week_bloc.dart';
import 'package:remind/core/schedule/presentation/provider/filter_provider.dart';
import 'package:remind/core/schedule/presentation/screen/week_screen.dart';
import 'package:remind/firebase_options.dart';
import 'package:remind/injections/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await ServiceLocator().init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<FilterProvider>(create: (_) => FilterProvider()),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => WeekBloc()),
        BlocProvider(create: (_) => ScheduleBloc(scheduleRepository: getIt())),
        BlocProvider(create: (_) => DayBloc(oneDayRepository: getIt())),
      ],
      child: MaterialApp(home: WeekScreen()),
    );
  }
}
