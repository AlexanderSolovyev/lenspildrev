import 'package:s3/features/app/domain/entities/order.dart';

abstract class OrderRepository {
  Stream<List<Order?>> orders();
  Future<void> createOrder(createdOrder);
  Future<void> updateOrder(Order updatedOrder);
  Future<Order?> getOrderById(id);
}
