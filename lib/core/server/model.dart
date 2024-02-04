class ServerModel {
  final int id;
  final String remark;

  ServerModel({required this.id, required this.remark});

  @override
  String toString() => remark;
}
