class Sura {
  final String name;
  final int number;
  final String info;

  Sura({
    required this.name,
    required this.number,
    required this.info,
  });

  factory Sura.fromJson(Map<String, dynamic> json) {
    return Sura(
      name: json['name'] ?? '',
      number: json['number'] ?? 0,
      info: json['info'] ?? '',
    );
  }
}