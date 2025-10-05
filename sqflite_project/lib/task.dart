class Task {
  String title;
  String desc;
  String date;
  int id;

  Task({
    required this.title,
    required this.desc,
    required this.date,
    this.id = 0,
  });

  Map toMap() {
    return ({"titile": title, "desc": desc, "date": date});
  }
}
