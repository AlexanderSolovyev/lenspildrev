import 'package:s3/features/app/domain/repositories/order_repository.dart';

class OrderCreate {
  final OrderRepository orderRepository;

  OrderCreate(this.orderRepository);
  Future<void> call(createdOrder) async {
    return await orderRepository.createOrder(createdOrder);
  }
}
