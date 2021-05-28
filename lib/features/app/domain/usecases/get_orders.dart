import 'package:s3/features/app/domain/entities/order.dart';
import 'package:s3/features/app/domain/repositories/order_repository.dart';

class GetOrders {
  final OrderRepository orderRepository;
  GetOrders(this.orderRepository);

  Stream<List<Order?>> get getOrders => orderRepository.getOrders();
}
