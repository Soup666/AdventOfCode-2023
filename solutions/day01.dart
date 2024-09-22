import '../utils/index.dart';

class Day01 extends GenericDay {
  Day01() : super(1);

  @override
  List<int> parseInput() {
    final lines = input.getPerLine();
    return ParseUtil.stringListToIntList(lines);
  }

  @override
  int solvePart1() {
    final values = input.getBy('\n').map((e) {
      if (e.isEmpty) return 0;
      int f1 = 0;
      int f2 = e.length - 1;

      int? value1;
      int? value2;

      while (value1 == null || value2 == null) {
        if (value1 == null) {
          value1 = int.tryParse(e[f1]);
          f1++;
        }

        if (value2 == null) {
          value2 = int.tryParse(e[f2]);
          f2--;
        }
      }

      return int.parse('$value1$value2');
    }).toList();

    return values.fold(0, (a, b) => a + b);
  }

  @override
  int solvePart2() {
    const List<String> words = [
      'one',
      'two',
      'three',
      'four',
      'five',
      'six',
      'seven',
      'eight',
      'nine',
    ];
    final List<int> values = input.getBy('\n').map((e) {
      if (e.isEmpty) return 0;
      int f1 = 0;
      int f2 = e.length - 1;

      int? value1;
      int? value2;

      while (value1 == null || value2 == null) {
        // Check word first

        if (value1 == null) {
          for (int i = 0; i < words.length; i++) {
            if (e.substring(f1).startsWith(words[i])) {
              value1 = i + 1;
              f1 += words[i].length;
              break;
            }
          }
        }

        if (value2 == null) {
          for (int i = 0; i < words.length; i++) {
            if (e.substring(0, f2 + 1).endsWith(words[i])) {
              value2 = i + 1;
              f2 -= words[i].length;
              break;
            }
          }
        }

        // Check digits

        if (value1 == null) {
          value1 = int.tryParse(e[f1]);
          f1++;
        }

        if (value2 == null) {
          value2 = int.tryParse(e[f2]);
          f2--;
        }
      }

      return int.parse('$value1$value2');
    }).toList();

    return values.fold(0, (a, b) => a + b);
  }
}
