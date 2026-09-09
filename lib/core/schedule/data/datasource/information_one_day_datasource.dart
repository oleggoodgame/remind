import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

abstract class InformationOneDayDatasource {
  Future<String> fetchOnThisDayFact(DateTime date);
}

class InformationOneDayDatasourceImplemented
    implements InformationOneDayDatasource {
  @override
  Future<String> fetchOnThisDayFact(DateTime date) async {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final url = Uri.parse(
      'https://en.wikipedia.org/api/rest_v1/feed/onthisday/events/$month/$day',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final events = data['events'] as List;
      if (events.isNotEmpty) {
        final random = events[Random().nextInt(events.length)];
        return "${random['year']}: ${random['text']}";
      }
    }
    return '';
  }
}
