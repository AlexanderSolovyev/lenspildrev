import 'package:equatable/equatable.dart';

enum StatusValues { uncorfimed, call, look, work, completed }

class Order extends Equatable {
  final String? estimate;
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

  Order({
    this.id,
    this.startDay,
    this.endTime,
    this.price,
    this.allDay,
    this.title,
    this.description,
    this.eventDate,
    this.phone,
    this.status,
    this.name,
    this.estimate,
  });

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
        name,
        estimate,
      ];
  Order copyWith({
    final String? id,
    final String? startDay,
    final DateTime? endTime,
    final int? price,
    final bool? allDay,
    final String? title,
    final String? description,
    final DateTime? eventDate,
    final String? phone,
    final StatusValues? status,
    final String? name,
    final String? estimate,
  }) {
    return Order(
      id: id ?? this.id,
      startDay: startDay ?? this.startDay,
      endTime: endTime ?? this.endTime,
      price: price ?? this.price,
      allDay: allDay ?? this.allDay,
      title: title ?? this.title,
      description: description ?? this.description,
      eventDate: eventDate ?? this.eventDate,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      name: name ?? this.name,
      estimate: estimate ?? this.estimate,
    );
  }
}
