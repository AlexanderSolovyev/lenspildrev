import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:s3/features/app/domain/entities/order.dart';
import 'package:s3/features/app/presentation/bloc/order_calendar_bloc.dart';

part 'clients_state.dart';

class ClientsCubit extends Cubit<ClientsState> {
  final OrderCalendarBloc orderCalendarBloc;
  StreamSubscription? orderCalendarBlocSubscription;

  ClientsCubit(this.orderCalendarBloc)
      : super(orderCalendarBloc.state is OrdersLoaded
            ? ClientsLoadSucess(
                orders: orderCalendarBloc.state.orders,
                filteredOrders: orderCalendarBloc.state.orders)
            : ClientsLoadInProgress()) {
    orderCalendarBlocSubscription = orderCalendarBloc.stream.listen((orders) {
      if (orders is OrdersLoaded) {
        orders.orders.sort((a, b) => b!.eventDate.compareTo(a!.eventDate));
        emit(ClientsLoadSucess(
            orders: orders.orders, filteredOrders: orders.orders));
      }
    });
  }

  Future<void> filter(filter) async {
    print("_____");
    final currentState = state;
    if (currentState is ClientsLoadSucess) {
      final List<Order> orders = currentState.orders;
      List<Order> filtered;
      if (filter != '') {
        filtered = filterOrders(currentState.orders, filter);
      } else {
        filtered = orders;
      }
      orders.sort((a, b) => b!.eventDate.compareTo(a!.eventDate));
      emit(ClientsLoadSucess(filteredOrders: filtered, orders: orders));
    }
  }

  @override
  Future<void> close() {
    orderCalendarBlocSubscription?.cancel();
    return super.close();
  }

  List<Order> filterOrders(List<Order> orders, String filter) {
    List<Order> filOrders = orders
        .where((element) =>
            element.name!.toLowerCase().contains(filter.toLowerCase()) ||
            element.description!.toLowerCase().contains(filter.toLowerCase()) ||
            element.phone!.toLowerCase().contains(filter.toLowerCase()) ||
            element.title!.toLowerCase().contains(filter.toLowerCase()))
        .toList();
    filOrders.sort((a, b) => b.eventDate.compareTo(a.eventDate));
    return filOrders;
  }

  Future<void> changeStatus(status) async {
    final currentState = state;
    final stat = mapingStatuses(status);
    if (currentState is ClientsLoadSucess) {
      final List<Order> orders = currentState.orders;
      List<Order> statusFiltered = currentState.orders
          .where((element) => element.status == stat)
          .toList();
      if (statusFiltered.length == 0) statusFiltered = orders;
      statusFiltered.sort((a, b) => b.eventDate.compareTo(a.eventDate));
      orders.sort((a, b) => b.eventDate.compareTo(a.eventDate));
      print(statusFiltered.length);
      emit(ClientsLoadInProgress());
      await Future.delayed(Duration(microseconds: 100));
      emit(ClientsLoadSucess(filteredOrders: statusFiltered, orders: orders));
    }
  }

  mapingStatuses(status) {
    switch (status) {
      case 'Отмена':
        return StatusValues.uncorfimed;
      case 'Звонить':
        return StatusValues.call;
      case 'Смотреть':
        return StatusValues.look;
      case 'Работать':
        return StatusValues.work;
      case 'Илья молодец':
        return StatusValues.completed;
    }
  }
}
