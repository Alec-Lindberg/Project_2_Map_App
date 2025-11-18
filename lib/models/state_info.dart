class StateInfo {
  final String code;
  final String name;

  StateInfo({
    required this.code,
    required this.name,
  });

  factory StateInfo.fromJson(Map<String, dynamic> json) {
    return StateInfo(
      code: json['code'] as String,
      name: json['name'] as String,
    );
  }
}
