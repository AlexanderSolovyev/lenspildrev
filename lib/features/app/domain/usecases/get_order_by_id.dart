import 'package:s3/features/app/domain/entities/order.dart';
import 'package:s3/features/app/domain/repositories/order_repository.dart';

class GetOrderById {
  final OrderRepository orderRepository;

  GetOrderById(this.orderRepository);
  Future<Order?> call(id) async {
    return await orderRepository.getOrderById(id);
  }
}
