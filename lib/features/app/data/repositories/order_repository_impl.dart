import 'package:s3/features/app/data/data_source/order_remote_data_source.dart';
import 'package:s3/features/app/domain/entities/order.dart';
import 'package:s3/features/app/domain/repositories/order_repository.dart';

class OrderRepositoryImpl extends OrderRepository {
  final OrderRemoteDataSource orderRemoteDataSource;

  OrderRepositoryImpl(this.orderRemoteDataSource);

  @override
  Stream<List<Order?>> getOrders() => orderRemoteDataSource.getOrders;

  @override
  Future<void> createOrder(item) {
    return orderRemoteDataSource.createOrder(item);
  }

  @override
  Future<void> updateOrder(id, item) {
    return orderRemoteDataSource.updateOrder(id, item);
  }

  @override
  Future<Order?> getOrderById(id) {
    return orderRemoteDataSource.getOrderById(id);
  }
}
