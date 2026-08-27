import 'package:get_it/get_it.dart';
import 'package:remind/core/schedule/data/datasource/schedule_datasorource.dart';
import 'package:remind/core/schedule/data/repository/schedule_implement_repository.dart';
import 'package:remind/core/schedule/domain/repository/schedule_repository.dart';
import 'package:remind/core/schedule/presentation/bloc/schedule_bloc.dart';

final GetIt getIt = GetIt.instance;

class ServiceLocator {
  Future<void> init() async {
    getIt.registerLazySingleton<ScheduleDatasorource>(
      () => ScheduleImplementedDatasource(),
    );
    getIt.registerLazySingleton<ScheduleRepository>(
      () => ScheduleImplementRepository(scheduleDatasorource: getIt()),
    );
    getIt.registerFactory<ScheduleBloc>(
      () => ScheduleBloc(scheduleRepository: getIt()),
    );
  }
}
