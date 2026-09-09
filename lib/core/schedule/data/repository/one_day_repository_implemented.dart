import 'package:remind/core/schedule/data/datasource/information_one_day_datasource.dart';
import 'package:remind/core/schedule/domain/repository/one_day_repository.dart';

class OneDayRepositoryImplemented implements OneDayRepository {
  final InformationOneDayDatasource informationOneDayDatasource;
  const OneDayRepositoryImplemented({
    required this.informationOneDayDatasource,
  });
  @override
  Future<String> fetchOnThisDayFact(DateTime date) async {
    try{  
      return await informationOneDayDatasource.fetchOnThisDayFact(date);
    }catch(e){
      print(e);
      throw("Happen exxeption");
    }
  }
}
