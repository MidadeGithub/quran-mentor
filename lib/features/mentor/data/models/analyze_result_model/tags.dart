class Tags {
  final Map<String, int> values;

  Tags(this.values);

  // Factory method لتحويل JSON إلى كائن Tags بشكل ديناميك
  factory Tags.fromJson(Map<String, dynamic> json) {
    return Tags(
      json.map((key, value) => MapEntry(key, value as int)),
    );
  }

  // تحويل كائن Tags إلى JSON
  Map<String, dynamic> toJson() => values;
}