import 'dart:async';
import 'package:dio/dio.dart';
import 'package:args/args.dart';


const api = 'https://derpibooru.org/api/v1/json/search/images';

Future<void> main(List<String> arguments) async {
  var dio = Dio();
  var parser = ArgParser();

  // Parser config
  parser.addOption('key', abbr: 'K', help: 'Your API key from Derpibooru');
  parser.addOption('limit', abbr: 'L', help: 'The amount of pages to parse', defaultsTo: '1');
  var options = parser.parse(arguments);
  var key = options['key'];
  var limit = int.parse(options['limit']);
  var search = options.rest.join(' ');

  // Initial vars
  var images = [[],[],[],[],[]];
  var res;

  var idx = 1;
  var list_idx = 0;

  // Fetch pages until the URL either returns 404 or limit is reached
  do {
    res = await dio.get(api, queryParameters: {
      'key': key,
      'q': search,
      'page': idx++
    }).catchError((e) => print(e));

    // Divide fetched URLs amongst 5 lists
    for (var img in res.data['images']) {
      images[list_idx].add(img['view_url']);

      if (list_idx >= 4) {
        list_idx = 0;
      } else {
        list_idx++;
      }

    }
  } while (res.statusCode == 200 && idx <= limit);

  // Download 5 images at once, one per list at a time
  for (var lst in images) {
    for (String i in lst) {
      await dio.download(i, './dl/' + i.split('/').last);
    }
  }
}
