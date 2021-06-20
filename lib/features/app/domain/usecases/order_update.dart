import 'package:s3/features/app/domain/entities/order.dart';
import 'package:s3/features/app/domain/repositories/order_repository.dart';

class OrderUpdate {
  final OrderRepository orderRepository;

  OrderUpdate(this.orderRepository);
  Future<void> call(updatedOrder) {
    return orderRepository.updateOrder(updatedOrder);
  }
}
