class NotesModel {
  String? title;
  String? details;
  int? time;
  int? id;

  NotesModel({this.title, this.details, this.time, this.id});

  NotesModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    details = json['details'];
    time = json['time'];
    id= json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = this.title;
    data['details'] = this.details;
    data['time'] = this.time;
    data['id'] = this.id;
    return data;
  }
}
