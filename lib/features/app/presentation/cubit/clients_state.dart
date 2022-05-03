part of 'clients_cubit.dart';

abstract class ClientsState extends Equatable {
  const ClientsState();

  @override
  List<Object> get props => [];
}

class ClientsLoadInProgress extends ClientsState {}

class ClientsLoadSucess extends ClientsState {
  final List<Order> orders;
  final List<Order> filteredOrders;

  ClientsLoadSucess({orders, filteredOrders})
      : orders = orders ?? [],
        filteredOrders = filteredOrders ?? [];

  @override
  List<Object> get props => [orders, filteredOrders];
}
