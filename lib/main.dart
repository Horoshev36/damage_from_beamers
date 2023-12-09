import 'package:damage_from_beamers/model/beamer.dart';
import 'package:damage_from_beamers/model/reactor.dart';
import 'package:flutter/material.dart';

List<Beamer> beamersList = [];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Лучемёты',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurpleAccent,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Лучемёты'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: buildText(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _calculate,
        tooltip: 'Calculate',
        child: const Icon(Icons.calculate_outlined),
      ),
    );
  }

  Widget buildText(BuildContext context) {
    if (beamersList.isNotEmpty) {
      return ListView.builder(
        itemCount: beamersList.length,
        itemBuilder: (context, index) {
          Beamer beamer = beamersList[index];
          return Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, (beamersList.length - 1 == index ? 100 : 0)),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      beamer.name,
                      style: TextStyle(
                          fontSize: 18,
                          color: beamer.name.contains('#G')
                              ? Colors.green
                              : beamer.name.contains('#B')
                                  ? Colors.blue
                                  : Colors.purple),
                    ),
                    Row(
                      children: [
                        Text(
                          beamer.reactor?.name ?? '',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Spacer(),
                        Text(
                          'Тиков: ${beamer.ticks}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Максимальный урон: ',
                          style: TextStyle(fontSize: 18),
                        ),
                        const Spacer(),
                        Text(
                          beamer.maxDamage.toStringAsFixed(2),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Нажми на кнопку чтоб просчитать',
        ),
      ],
    );
  }

  void _calculate() {
    beamersList = [];
    List<Reactor> reactors = [
      Reactor(energy: 185867.953, name: 'Реактор'),
      Reactor(energy: 157272.891, name: 'Реактор "Пульс"'),
      Reactor(energy: 128677.82, name: 'Реактор "Свеча"'),
      Reactor(energy: 314545.781, name: 'Реактор "Звезда"'),
      Reactor(energy: 285950.688, name: 'Реактор "Атлет"'),
      Reactor(energy: 142975.344, name: 'Реактор "Малыш"'),
      Reactor(energy: 214463.031, name: 'Реактор "Котёл"'),
    ];

    List<Beamer> beamers = [
      Beamer(multiplier: 2, damage: 30991.508, energy: 11531.724, name: '#Green Лучемёт'),
      Beamer(multiplier: 2.25, damage: 36036.637, energy: 12684.896, name: '#Green Лучемёт "Резак"'),
      Beamer(multiplier: 2, damage: 24144.547, energy: 14270.508, name: '#Green Лучемёт "Сверло"'),
      Beamer(multiplier: 2, damage: 31135.653, energy: 13838.068, name: '#Green Лучемёт "Пика"'),
      Beamer(multiplier: 2.25, damage: 38919.566, energy: 15279.534, name: '#Green Лучемёт "Смерч"'),
      Beamer(multiplier: 3, damage: 51892.758, energy: 17297.586, name: '#Green Лучемёт "Игла"'),
      Beamer(multiplier: 2, damage: 19459.783, energy: 10090.258, name: '#Green Лучемёт "Колос"'),
      Beamer(multiplier: 2, damage: 34523.098, energy: 9225.379, name: '#Green Лучемёт "Стилет"'),
    ];

    double maxDamage = 0.0;
    Beamer? maxBeamer;
    Reactor? maxReactor;
    List<Beamer> greenBeamers = [];
    List<Beamer> blueBeamers = [];
    List<Beamer> purpleBeamers = [];
    setState(() {
      for (var item in beamers) {
        greenBeamers.add(Beamer(
          damage: item.damage,
          energy: item.energy,
          name: item.name,
          multiplier: item.multiplier,
        ));
        item.damage = item.damage / 100 * 115;
        item.energy = item.energy / 100 * 115;
        item.name = item.name.replaceAll('Green', 'Blue');
        blueBeamers.add(Beamer(
          damage: item.damage,
          energy: item.energy,
          name: item.name,
          multiplier: item.multiplier,
        ));
        item.damage = item.damage / 100 * 115;
        item.energy = item.energy / 100 * 115;
        item.name = item.name.replaceAll('Blue', 'Purple');
        purpleBeamers.add(Beamer(
          damage: item.damage,
          energy: item.energy,
          name: item.name,
          multiplier: item.multiplier,
        ));
      }

      greenBeamers.addAll(blueBeamers);
      greenBeamers.addAll(purpleBeamers);

      for (var reactor in reactors) {
        for (var beamer in greenBeamers) {
          double damage = getDamage(reactor, beamer).$1;
          int ticks = getDamage(reactor, beamer).$2;
          if (damage > beamer.maxDamage) {
            beamer.maxDamage = damage;
            beamer.reactor = reactor;
            beamer.ticks = ticks;
          }
          if (damage > maxDamage) {
            maxDamage = damage;
            maxBeamer = beamer;
            maxReactor = reactor;
          }
        }
      }

      print('======================TOP===========================');
      print('${maxBeamer?.name}\n${maxReactor?.name}\n${maxDamage.toStringAsFixed(2)}\n');
      print('======================TOP===========================');

      greenBeamers.sort((b, a) => a.maxDamage.compareTo(b.maxDamage));
      for (var beamer in greenBeamers) {
        print('${beamer.name}\n${beamer.maxDamage.toStringAsFixed(2)}\n${beamer.reactor?.name}\n');
        print('**************************************************');
      }

      beamersList.addAll(greenBeamers);
    });
  }
}

(double, int) getDamage(Reactor reactor, Beamer beamer) {
  double energy = beamer.energy;
  double damage = beamer.damage;
  for (var i = 1; energy < reactor.energy; i++) {
    energy = energy + energy * 2;
    if (reactor.energy < energy) {
      return (damage, i);
    } else {
      if (i <= 3) {
        damage = damage + damage * 2;
      }

      print('damage $damage ${beamer.name}');
    }
    print('energy $energy');
  }
  return (damage, 1);
}

//double getDamage(Reactor reactor, Beamer beamer) {
//  double energy = beamer.energy;
//  double damage = beamer.damage;
//  for (var i = 1; energy < reactor.energy; i++) {
//    if (reactor.energy < energy) {
//      return damage;
//    } else {
//      damage = damage * damage;
//    }
//    energy = energy + energy;
//  }
//  return 0;
//}
