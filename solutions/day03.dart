import '../utils/index.dart';

typedef Char = String;

class Day03 extends GenericDay {
  Day03() : super(3);

  @override
  List<String> parseInput() => input.getPerLine();

  bool isNumeric(Char character) =>
      character.codeUnits.first >= 48 && character.codeUnits.first <= 57;

  bool isNotNumeric(Char character) => !isNumeric(character);

  @override
  int solvePart1() {
    final List<String> lines = parseInput();

    final List<List<String>> matrix = [];

    for (final line in lines) {
      matrix.add(line.split(''));
    }

    final List<String> parts = [];

    int currentX = 0;
    int currentY = 0;

    while (currentY < lines.length) {
      while (true) {
        while (lines[currentY][currentX] == '.' &&
            currentX < lines[currentY].length - 1) {
          currentX++;
        }

        if (currentX > lines[currentY].length - 1) break;

        int endOfBlock = currentX;
        while (endOfBlock < lines[currentY].length &&
            lines[currentY][endOfBlock] != '.' &&
            lines[currentY][endOfBlock].codeUnits.first >= 48 &&
            lines[currentY][endOfBlock].codeUnits.first <= 57) {
          endOfBlock++;
        }

        final String currentBlock =
            lines[currentY].substring(currentX, endOfBlock);

        final List<String> block = [];

        for (int x = -1; x < currentBlock.length + 1; x++) {
          final int tempX = currentX + x;
          final int tempY = currentY - 1;
          final bool outOfBounds = tempY < 0 ||
              tempY >= lines.length ||
              tempX < 0 ||
              tempX >= lines[tempY].length;
          block.add(outOfBounds ? '.' : matrix[tempY][tempX]);
        }

        block
          ..add(currentX - 1 < 0 ? '.' : matrix[currentY][currentX - 1])
          ..add(
            (currentX + currentBlock.length) > lines[currentY].length - 1
                ? '.'
                : lines[currentY][currentX + currentBlock.length],
          );

        for (int x = -1; x < currentBlock.length + 1; x++) {
          final int tempX = currentX + x;
          final int tempY = currentY + 1;
          final bool outOfBounds = tempY < 0 ||
              tempY >= lines.length ||
              tempX < 0 ||
              tempX >= lines[tempY].length;
          block.add(outOfBounds ? '.' : matrix[tempY][tempX]);
        }

        // Check for symbols
        final bool skippable = block.any(
              (c) =>
                  c != '.' ||
                  (c.codeUnits.first >= 48 && c.codeUnits.first <= 57),
            ) &&
            block.isNotEmpty;

        if (skippable && currentBlock.isNotEmpty) {
          parts.add(currentBlock);
        }

        currentX = currentX + (currentBlock.isEmpty ? 1 : currentBlock.length);
        if (currentX > lines[currentY].length - 1) break;
      }
      currentX = 0;
      currentY++;
    }

    // filter out symbols
    final int total = parts.fold(
      0,
      (previousValue, element) => previousValue + int.parse(element),
    );

    return total;
  }

  @override
  int solvePart2() {
    final lines = parseInput();

    int currentX = 0;
    int currentY = 0;

    int total = 0;

    while (currentY < lines.length) {
      while (currentX < lines[currentY].length) {
        if (lines[currentY][currentX] == '*') {
          // Found *

          final List<int> parts = [];

          // Search rows
          int x = -1;
          int y = -1;
          while (y <= 1) {
            while (x <= 1) {
              // baseline for out of range
              // if (y > lines[currentY].length - 1 ||
              //     x > lines[currentY][currentX].length - 1) {
              //   x = 1000;
              //   continue;
              // }

              if ((y == 0 && x == 0) ||
                  isNotNumeric(lines[currentY + y][currentX + x])) {
                x++;
                continue;
              }

              // Found number
              int foundX = currentX + x;
              final int foundY = currentY + y;

              // Find left most of number, search right
              while (foundX > 0 && isNumeric(lines[foundY][foundX - 1])) {
                foundX--;
              }
              int endOfFoundX = foundX;

              while (endOfFoundX < lines[foundY].length &&
                  isNumeric(lines[foundY][endOfFoundX])) {
                endOfFoundX++;
              }

              late int foundNumber;

              if (foundX == endOfFoundX) {
                foundNumber = int.parse(lines[foundY][foundX]);
                x++;
              } else {
                foundNumber =
                    int.parse(lines[foundY].substring(foundX, endOfFoundX));
                x += endOfFoundX - (currentX + x);
              }
              parts.add(foundNumber);
            }
            y++;
            x = -1;
          }

          if (parts.length == 2) {
            total += parts[0] * parts[1];
          }
        }
        currentX++;
      }

      currentY++;
      currentX = 0;
    }

    return total;
  }
}
