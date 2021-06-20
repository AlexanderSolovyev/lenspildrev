import 'package:s3/features/app/data/data_source/order_remote_data_source.dart';
import 'package:s3/features/app/domain/entities/order.dart';
import 'package:s3/features/app/domain/repositories/order_repository.dart';

class OrderRepositoryImpl extends OrderRepository {
  final OrderRemoteDataSource orderRemoteDataSource;

  OrderRepositoryImpl(this.orderRemoteDataSource);

  @override
  Stream<List<Order?>> orders() => orderRemoteDataSource.orders();

  @override
  Future<void> createOrder(createdOrder) {
    return orderRemoteDataSource.createOrder(createdOrder);
  }

  @override
  Future<void> updateOrder(Order updatedOrder) {
    return orderRemoteDataSource.updateOrder(updatedOrder);
  }

  @override
  Future<Order?> getOrderById(id) {
    return orderRemoteDataSource.getOrderById(id);
  }
}
