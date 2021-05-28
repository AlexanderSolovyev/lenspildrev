import 'package:s3/features/app/domain/repositories/order_repository.dart';

class UpdateOrder {
  final OrderRepository orderRepository;

  UpdateOrder(this.orderRepository);
  Future<void> call(id, item) {
    return orderRepository.updateOrder(id, item);
  }
}
