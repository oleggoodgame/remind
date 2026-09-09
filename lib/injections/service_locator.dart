import 'package:get_it/get_it.dart';
import 'package:remind/core/schedule/data/datasource/information_one_day_datasource.dart';
import 'package:remind/core/schedule/data/datasource/schedule_datasorource.dart';
import 'package:remind/core/schedule/data/repository/one_day_repository_implemented.dart';
import 'package:remind/core/schedule/data/repository/schedule_implement_repository.dart';
import 'package:remind/core/schedule/domain/repository/one_day_repository.dart';
import 'package:remind/core/schedule/domain/repository/schedule_repository.dart';
import 'package:remind/core/schedule/presentation/bloc/day_bloc.dart';
import 'package:remind/core/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:remind/core/schedule/presentation/bloc/week_bloc.dart';

final GetIt getIt = GetIt.instance;

class ServiceLocator {
  Future<void> init() async {
    //data && repostiroy
    getIt.registerLazySingleton<ScheduleDatasorource>(
      () => ScheduleImplementedDatasource(),
    );
    getIt.registerLazySingleton<ScheduleRepository>(
      () => ScheduleImplementRepository(scheduleDatasorource: getIt()),
    );
    getIt.registerLazySingleton<InformationOneDayDatasource>(
      () => InformationOneDayDatasourceImplemented(),
    );
    getIt.registerLazySingleton<OneDayRepository>(
      () => OneDayRepositoryImplemented(informationOneDayDatasource: getIt()),
    );
    //bloc
    getIt.registerFactory<ScheduleBloc>(
      () => ScheduleBloc(scheduleRepository: getIt()),
    );
    getIt.registerFactory<WeekBloc>(() => WeekBloc());
    getIt.registerFactory<DayBloc>(() => DayBloc(oneDayRepository: getIt()));
  }
}
