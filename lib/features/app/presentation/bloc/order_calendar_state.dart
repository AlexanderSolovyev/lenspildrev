part of 'order_calendar_bloc.dart';

abstract class OrderCalendarState extends Equatable {
  final List<Order?> orders;
  final List<Order?> ordersForDay;
  final DateTime? selectedDay;
  OrderCalendarState(
      [this.orders = const [], this.ordersForDay = const [], DateTime? temp])
      : this.selectedDay = temp ?? DateTime.now();
  List<Object> get props => [];
}

class OrdersLoading extends OrderCalendarState {}

class OrdersLoaded extends OrderCalendarState {
  final List<Order?> orders;
  final List<Order?> ordersForDay;

  OrdersLoaded([
    this.orders = const [],
    this.ordersForDay = const [],
  ]);

  @override
  List<Object> get props => [orders, ordersForDay];
}
