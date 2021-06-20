import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:s3/features/app/domain/entities/order.dart';
import 'package:s3/features/app/domain/usecases/get_orders.dart';
import 'package:s3/features/app/domain/usecases/order_create.dart';
import 'package:s3/features/app/domain/usecases/order_update.dart';

part 'order_calendar_event.dart';
part 'order_calendar_state.dart';

class OrderCalendarBloc extends Bloc<OrderCalendarEvent, OrderCalendarState> {
  final GetOrders getOrders;
  final OrderUpdate orderUpdate;
  final OrderCreate orderCreate;
  StreamSubscription? _streamSubscription;

  OrderCalendarBloc(this.getOrders, this.orderUpdate, this.orderCreate)
      : super(OrdersLoading());

  @override
  Stream<OrderCalendarState> mapEventToState(
    OrderCalendarEvent event,
  ) async* {
    if (event is LoadOrders) {
      yield* _mapLoadOrdersState();
    } else if (event is OrdersUpdated) {
      yield* _mapOrdersUpdateToState(event);
    } else if (event is GetOrdersForDay) {
      yield* _mapOrdersForDayState(event.date);
    } else if (event is UpdateOrder) {
      yield* _mapUpdateOrderToState(event.updatedOrder);
    } else if (event is CreateOrder) {
      yield* _mapCreateOrderToState(event.createdOrder);
    }
  }

  Stream<OrderCalendarState> _mapLoadOrdersState() async* {
    _streamSubscription?.cancel();
    _streamSubscription = getOrders().listen(
      (orders) => add(OrdersUpdated(orders)),
    );
  }

  Stream<OrderCalendarState> _mapOrdersUpdateToState(event) async* {
    yield OrdersLoaded(event.orders, event.ordersForDay);
  }

  Stream<OrderCalendarState> _mapOrdersForDayState(DateTime event) async* {
    final currentstate = state;
    if (currentstate is OrdersLoaded) {
      final List<Order?> ordersForDay = currentstate.orders
          .where((order) => (order!.eventDate!.year == event.year &&
              order.eventDate!.month == event.month &&
              order.eventDate!.day == event.day))
          .toList();
      add(OrdersUpdated(currentstate.orders, ordersForDay));
    }
  }

  Stream<OrderCalendarState> _mapUpdateOrderToState(event) async* {
    final Order order = event;
    orderUpdate.call(order);
  }

  Stream<OrderCalendarState> _mapCreateOrderToState(createdOrder) async* {
    final Order order = createdOrder;
    orderCreate.call(order);
  }
}
