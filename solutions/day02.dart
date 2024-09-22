import '../utils/index.dart';

class Game {
  const Game({required this.id, required this.rounds});
  factory Game.fromString(String line) {
    if (line.isEmpty) {
      return const Game(id: -1, rounds: []);
    }

    int offset = 0;

    while (line[5 + offset] != ':') {
      if (offset > 10) {
        throw Exception("Couldn't determine offset");
      }
      offset++;
    }

    final _id = int.parse(line.split(':').first.split(' ').last);
    final _rounds = line
        .substring(line.indexOf(':') + 1, line.length)
        .split(';')
        .map((e) => Round.fromString(e.trim()))
        .toList();

    return Game(id: _id, rounds: _rounds);
  }
  final int id;
  final List<Round> rounds;

  bool isValid(int red, int green, int blue) {
    return !rounds.any((e) => e.isNotValid(red, green, blue));
  }

  List<int> getLowest() {
    return [
      rounds.fold(0, (a, b) => a > b.highestRed ? a : b.highestRed),
      rounds.fold(0, (a, b) => a > b.highestGreen ? a : b.highestGreen),
      rounds.fold(0, (a, b) => a > b.highestBlue ? a : b.highestBlue),
    ];
  }

  int getPower() {
    final lowest = getLowest();
    return lowest[0] * lowest[1] * lowest[2];
  }

  bool isNotValid(int red, int green, int blue) => !isValid(red, green, blue);

  @override
  String toString() => 'Game(id: $id, rounds: $rounds)';
}

class Round {
  factory Round.fromString(String segment) {
    final List<String> _grabs =
        segment.split(',').map((e) => e.trim()).toList();
    final List<Grab> _parsedGrabs = _grabs.map(Grab.fromString).toList();

    return Round(grabs: _parsedGrabs);
  }
  const Round({required this.grabs});
  final List<Grab> grabs;

  List<Grab> get red =>
      grabs.where((e) => e.color.toLowerCase() == 'red').toList();
  List<Grab> get green =>
      grabs.where((e) => e.color.toLowerCase() == 'green').toList();
  List<Grab> get blue =>
      grabs.where((e) => e.color.toLowerCase() == 'blue').toList();

  int get redTotal => red.fold(0, (a, b) => a + b.amount);
  int get blueTotal => blue.fold(0, (a, b) => a + b.amount);
  int get greenTotal => green.fold(0, (a, b) => a + b.amount);

  int get highestRed => red.fold(0, (a, b) => a > b.amount ? a : b.amount);
  int get highestGreen => green.fold(0, (a, b) => a > b.amount ? a : b.amount);
  int get highestBlue => blue.fold(0, (a, b) => a > b.amount ? a : b.amount);

  bool isValid(int red, int green, int blue) =>
      redTotal <= red && greenTotal <= green && blueTotal <= blue;

  bool isNotValid(int red, int green, int blue) => !isValid(red, green, blue);

  @override
  String toString() => 'Round(grabs: $grabs)';
}

class Grab {
  const Grab({required this.amount, required this.color});
  factory Grab.fromString(String line) {
    return Grab(
      amount: int.parse(line.split(' ').first),
      color: line.split(' ').last.trim(),
    );
  }
  final int amount;
  final String color;

  @override
  String toString() => 'Grab(amount: $amount, color: $color)';
}

class Day02 extends GenericDay {
  Day02() : super(2);

  @override
  List<Game> parseInput() {
    return input.getPerLine().map(Game.fromString).toList();
  }

  @override
  int solvePart1() {
    return parseInput()
        .where((e) => e.isValid(12, 13, 14))
        .toList()
        .fold(0, (a, b) => a + b.id);
  }

  @override
  int solvePart2() {
    return parseInput().fold(0, (a, b) => a + b.getPower());
  }
}
