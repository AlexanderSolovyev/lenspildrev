enum StatusValues { uncorfimed, call, look, work, completed }

class EventModel {
  final String? startDay;
  final int? price;
  final bool? allDay;
  final String? id;
  final String? title;
  final String? description;
  final DateTime? eventDate;
  final DateTime? endTime;
  final String? phone;
  final String? name;
  StatusValues? status;

  EventModel(
      {this.id,
      this.startDay,
      this.endTime,
      this.price,
      this.allDay,
      this.title,
      this.description,
      this.eventDate,
      this.phone,
      this.status,
      this.name});

  factory EventModel.fromMap(Map data) {
    return EventModel(
      startDay: data["startDay"],
      endTime: data['startTime'],
      price: data['price'],
      allDay: false,
      title: data['title'],
      description: data['description'],
      eventDate: data['startTime'],
      phone: data['phone'],
      name: data['name'],
      status: StatusValues.values.firstWhere(
          (element) => element.toString().split('.')[1] == data['status']),
    );
  }

  factory EventModel.fromDS(String id, Map<String, dynamic> data) {
    return EventModel(
      startDay: data['startDay'],
      endTime: data['startTime'].toDate(),
      price: (data['price'] == null || data['price'].runtimeType != int)
          ? 0
          : data['price'],
      //price: data['price'],
      allDay: false,
      id: id,
      title: data['title'],
      description: data['description'],
      eventDate: data['startTime'].toDate(),
      phone: data['phone'],
      name: data['name'],
      status: StatusValues.values.firstWhere(
          (element) => element.toString().split('.')[1] == data['status']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "startDay": startDay,
      'endTime': eventDate,
      "price": price,
      "allDay": false,
      "title": title,
      "description": description,
      "startTime": eventDate,
      "id": id,
      "phone": phone,
      "name": name,
      'status': status.toString().split('.')[1],
    };
  }
}
