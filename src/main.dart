import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:args/args.dart';
import 'package:path/path.dart' show dirname, join;


const api = 'https://derpibooru.org/api/v1/json/search/images';

Future<void> main(List<String> arguments) async {
  var dio = Dio();
  var parser = ArgParser();
  var cfg = File(trimLeading('/', join(dirname(Platform.script.path), 'derpidl.cfg')));

  // Parser config
  parser.addOption('key', abbr: 'K', help: 'Your API key from Derpibooru');
  parser.addOption('limit', abbr: 'L', help: 'The amount of pages to parse', defaultsTo: '0');
  var options = parser.parse(arguments);
  var key = options['key'];
  var limit = int.parse(options['limit']);
  var search = options.rest.join(' ');

  // Config
  if (await cfg.exists()) {
    key = await cfg.readAsString();
  } else {
    await cfg.create();
  }
  await cfg.writeAsString(key);

  // Initial vars
  var images = [[],[],[],[],[]];
  var res;

  var idx = 1;
  var list_idx = 0;

  // Fetch pages until the URL either returns 404 or limit is reached
  print('Downloading [${search}] with key ${key}');
  print('Collecting pages...');
  do {
    print('Collecting page ${idx}');
    res = await dio.get(api, queryParameters: {
      'key': key,
      'q': search,
      'page': idx++
    }).catchError((e) => print(e));
    if (res.data['images'].length <= 0) break;

    // Divide fetched URLs amongst 5 lists
    for (var img in res.data['images']) {

      images[list_idx].add(img['view_url']);

      if (list_idx >= 4) {
        list_idx = 0;
      } else {
        list_idx++;
      }

    }
  } while (res.statusCode == 200 && (idx <= limit || limit == 0));

  print('Collected all pages.');
  print('Downloading images...');

  // Download 5 images at once, one per list at a time
  for (var lst in images) {
    for (String i in lst) {
      await dio.download(i, './dl/' + i.split('/').last)
          .then((_) => { print('Downloaded ${i}') });
    }
  }

  print('All images downloaded.');
}

String trimLeading(String pattern, String from) {
  var i = 0;
  while (from.startsWith(pattern, i)) {
    i += pattern.length;
  }
  return from.substring(i);
}
