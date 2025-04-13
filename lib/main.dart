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
                        const SizedBox(width: 8),
                        Text('${(beamer.maxEnergy / (beamer.reactor?.energy ?? 0) * 100).round().toStringAsFixed(0)}%',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white24,
                            )),
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
    int currentLayer = 20;
    double differenceOfColors = 13.043682;
    double differenceOfLayers = 24.812926;
    List<Reactor> reactors = [
      Reactor(energy: 581582, name: 'Реактор'),
      Reactor(energy: 492107, name: 'Реактор "Пульс"'),
      Reactor(energy: 402633, name: 'Реактор "Свеча"'),
      Reactor(energy: 984215, name: 'Реактор "Звезда"'),
      Reactor(energy: 894741, name: 'Реактор "Атлет"'),
      Reactor(energy: 447370, name: 'Реактор "Малыш"'),
      Reactor(energy: 671056, name: 'Реактор "Котёл"'),
    ];

    List<Beamer> beamers = [
      Beamer(multiplier: 2, damage: 96972, energy: 36082, name: '#Green Лучемёт'),
      Beamer(multiplier: 2.25, damage: 112758, energy: 39691, name: '#Green Лучемёт "Резак"'),
      Beamer(multiplier: 2, damage: 75548, energy: 44652, name: '#Green Лучемёт "Сверло"'),
      Beamer(multiplier: 2, damage: 97423, energy: 43299, name: '#Green Лучемёт "Пика"'),
      Beamer(multiplier: 2.25, damage: 121779, energy: 47809, name: '#Green Лучемёт "Смерч"'),
      Beamer(multiplier: 3, damage: 162372, energy: 54124, name: '#Green Лучемёт "Игла"'),
      Beamer(multiplier: 1.33, damage: 60889, energy: 31572, name: '#Green Лучемёт "Колос"'),
      Beamer(multiplier: 2, damage: 108022, energy: 28866, name: '#Green Лучемёт "Стилет"'),
    ];

    double maxDamage = 0.0;
    Beamer? maxBeamer;
    Reactor? maxReactor;
    List<Beamer> greenBeamers = [];
    List<Beamer> blueBeamers = [];
    List<Beamer> purpleBeamers = [];
    setState(() {
      for (var item in beamers) {
        //prev
        greenBeamers.add(Beamer(
          damage: item.damage / 100 * (100 - differenceOfLayers),
          energy: item.energy / 100 * (100 - differenceOfLayers),
          name: (currentLayer - 1).toString() + ' ' + item.name,
          multiplier: item.multiplier,
        ));
        //current
        greenBeamers.add(Beamer(
          damage: item.damage,
          energy: item.energy,
          name: currentLayer.toString() + ' ' + item.name,
          multiplier: item.multiplier,
        ));
        //next
        greenBeamers.add(Beamer(
          damage: item.damage / 100 * (100 + differenceOfLayers),
          energy: item.energy / 100 * (100 + differenceOfLayers),
          name: (currentLayer + 1).toString() + ' ' + item.name,
          multiplier: item.multiplier,
        ));
        item.damage = item.damage / 100 * (100 + differenceOfColors);
        item.energy = item.energy / 100 * (100 + differenceOfColors);
        item.name = item.name.replaceAll('Green', 'Blue');
        blueBeamers.add(Beamer(
          damage: item.damage / 100 * (100 - differenceOfLayers),
          energy: item.energy / 100 * (100 - differenceOfLayers),
          name: (currentLayer - 1).toString() + ' ' + item.name,
          multiplier: item.multiplier,
        ));
        blueBeamers.add(Beamer(
          damage: item.damage,
          energy: item.energy,
          name: currentLayer.toString() + ' ' + item.name,
          multiplier: item.multiplier,
        ));
        blueBeamers.add(Beamer(
          damage: item.damage,
          energy: item.energy,
          name: (currentLayer + 1).toString() + ' ' + item.name,
          multiplier: item.multiplier,
        ));
        item.damage = item.damage / 100 * (100 + differenceOfColors);
        item.energy = item.energy / 100 * (100 + differenceOfColors);
        item.name = item.name.replaceAll('Blue', 'Purple');
        purpleBeamers.add(Beamer(
          damage: item.damage / 100 * (100 - differenceOfLayers),
          energy: item.energy / 100 * (100 - differenceOfLayers),
          name: (currentLayer - 1).toString() + ' ' + item.name,
          multiplier: item.multiplier,
        ));
        purpleBeamers.add(Beamer(
          damage: item.damage,
          energy: item.energy,
          name: currentLayer.toString() + ' ' + item.name,
          multiplier: item.multiplier,
        ));
        purpleBeamers.add(Beamer(
          damage: item.damage / 100 * (100 + differenceOfLayers),
          energy: item.energy / 100 * (100 + differenceOfLayers),
          name: (currentLayer + 1).toString() + ' ' + item.name,
          multiplier: item.multiplier,
        ));
      }

      greenBeamers.addAll(blueBeamers);
      greenBeamers.addAll(purpleBeamers);

      for (var reactor in reactors) {
        for (var beamer in greenBeamers) {
          var (x, y, z) = getDamage(reactor, beamer);
          double damage = x;
          double energy = y;
          int ticks = z;
          if (damage > beamer.maxDamage) {
            beamer.maxDamage = damage;
            beamer.maxEnergy = energy;
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

(double, double, int) getDamage(Reactor reactor, Beamer beamer) {
  int ticks = 0;
  double energy = beamer.energy;
  double damage = beamer.damage;
  double maxDamage = 0;
  double maxEnergy = 0;
  for (var i = 1; maxEnergy < reactor.energy; i++) {
    if (i == 1) {
      damage = damage;
      energy = energy;
    } else if (i == 2) {
      damage = damage * beamer.multiplier;
      energy = energy;
    } else {
      if (i < 5) {
        damage = damage + beamer.damage;
      }
      energy = maxEnergy + beamer.energy * beamer.multiplier;
    }

    maxDamage = maxDamage + damage;
    maxEnergy = maxEnergy + energy;
    print('damage ${damage - beamer.damage}');
    print('energy ${energy - beamer.energy}');
    ticks = i;
  }
  print(maxDamage);
  return (maxDamage, energy - beamer.energy, ticks);
}

//double getDamage(double reactor, double beamer, double beamerD) {
//  double energy = beamer;
//  double damage = beamerD;
//  double maxDamage = 0;
//  double maxEnergy = 0;
//  for (var i = 1; maxEnergy < reactor; i++) {
//    if (i==1){
//      damage = damage;
//      energy = energy;
//    }else if (i==2){
//      damage = damage*3;
//      energy = energy;
//    }else{
//      if(i<5) {
//        damage = damage + beamerD;
//      }
//      energy = maxEnergy + beamer*3;
//    }
//
//    maxDamage = maxDamage + damage-beamerD;
//    maxEnergy = maxEnergy + energy - beamer;
//    print('damage ${damage-beamerD}');
//    print('energy ${energy-beamer}');
//    print('$i');
//  }
//  print(maxDamage);
//  print(energy-beamer);
//  return maxDamage;
//}
