import 'package:equatable/equatable.dart';

enum StatusValues { uncorfimed, call, look, work, completed }

class Order extends Equatable {
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
  final StatusValues? status;

  Order(
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

  @override
  List<Object?> get props => [
        id,
        startDay,
        endTime,
        price,
        allDay,
        title,
        description,
        eventDate,
        phone,
        status,
        name
      ];
}
