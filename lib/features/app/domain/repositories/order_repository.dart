import 'package:s3/features/app/domain/entities/order.dart';

abstract class OrderRepository {
  Stream<List<Order?>> getOrders();
  Future<void> createOrder(item);
  Future<void> updateOrder(id, item);
  Future<Order?> getOrderById(id);
}
