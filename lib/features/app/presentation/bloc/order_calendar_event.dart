part of 'order_calendar_bloc.dart';

abstract class OrderCalendarEvent extends Equatable {
  const OrderCalendarEvent();

  @override
  List<Object> get props => [];
}

class LoadOrders extends OrderCalendarEvent {}

class OrdersUpdated extends OrderCalendarEvent {
  final List<Order?> orders;
  final List<Order?> ordersForDay;

  OrdersUpdated(this.orders, [this.ordersForDay = const []]);

  @override
  List<Object> get props => [orders, ordersForDay];
}

class GetOrdersForDay extends OrderCalendarEvent {
  final date;

  GetOrdersForDay(this.date);
}

class UpdateOrder extends OrderCalendarEvent {
  final Order? updatedOrder;

  UpdateOrder(this.updatedOrder);
}

class CreateOrder extends OrderCalendarEvent {
  final Order? createdOrder;
  CreateOrder(this.createdOrder);
}
