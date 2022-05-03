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
            ? ClientsLoadSucess(orders: orderCalendarBloc.state.orders)
            : ClientsLoadInProgress()) {
    orderCalendarBlocSubscription = orderCalendarBloc.stream.listen((orders) {
      if (orders is OrdersLoaded) {
        emit(ClientsLoadSucess(orders: orders.orders));
      }
    });
  }

  Future<void> filter(filter) async {
    final currentState = state;
    if (currentState is ClientsLoadSucess) {
      final List<Order> filtered = filterOrders(currentState.orders, filter);
    }
  }

  @override
  Future<void> close() {
    orderCalendarBlocSubscription?.cancel();
    return super.close();
  }

  List<Order> filterOrders(orders, filter) {
    return orders.where((element) => element.title != null).toList();
  }
}
