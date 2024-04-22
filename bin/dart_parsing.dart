import 'package:dart_parsing/dart_parsing.dart' as dart_parsing;

Future<void> main(List<String> arguments) async {
  final resust = await dart_parsing.getGPSs('assets/test.MP4');
  if (resust.isNotEmpty) {
    for (var element in resust) {
      print(element);
    }
  }
}
