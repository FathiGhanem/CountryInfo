class CountryModel {
  final String name;
  final String flag;
  final double pop;
  final double area;

  CountryModel({
    required this.area,
    required this.flag,
    required this.name,
    required this.pop,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      name: json['name']['common'],
      flag: json['flags']['png'],
      pop: (json['population'] as num).toDouble(),
      area: (json['area'] as num).toDouble(),
    );
  }
}
