import 'package:s3/features/app/domain/repositories/order_repository.dart';

class CreateOrder {
  final OrderRepository orderRepository;

  CreateOrder(this.orderRepository);
  Future<void> call(item) async {
    return await orderRepository.createOrder(item);
  }
}
