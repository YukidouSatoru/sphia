class ServerModelLite {
  final int id;
  final String remark;

  ServerModelLite({required this.id, required this.remark});

  @override
  String toString() => remark;
}
