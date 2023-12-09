import 'package:damage_from_beamers/model/reactor.dart';

class Beamer {
  final double multiplier;
  double damage;
  double energy;
  String name;
  double maxDamage;
  double maxEnergy;
  int ticks;
  Reactor? reactor;

  Beamer({
    required this.multiplier,
    required this.damage,
    required this.energy,
    required this.name,
    this.maxDamage = 0,
    this.maxEnergy = 0,
    this.ticks = 0,
    this.reactor,
  });
}
