import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:s3/features/app/data/models/order_model.dart';
import 'package:s3/features/app/domain/entities/order.dart';

abstract class OrderRemoteDataSource {
  // Stream<List<OrderModel?>> get getOrders;
  Stream<List<OrderModel>> orders();
  Future<void> createOrder(createdOrder);
  Future<void> updateOrder(Order updatedOrder);
  Future<OrderModel?> getOrderById(id);
}

class OrderRemoteDataSourceImpl extends OrderRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;

  OrderRemoteDataSourceImpl(this.firebaseFirestore);

  late final orderCollection = firebaseFirestore.collection('events');
  @override
  //Stream<List<OrderModel?>> get getOrders => eventDBS.streamList();
  Stream<List<OrderModel>> orders() {
    return orderCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => OrderModel.fromDS(doc.id, doc.data()))
        .toList());
  }

  /* DatabaseService<OrderModel?> eventDBS = DatabaseService<OrderModel>("events",
      fromDS: (id, data) => OrderModel.fromDS(id, data!),
      toMap: (event) => event.toMap()); */

  @override
  Future<void> createOrder(createdOrder) {
    final OrderModel updatedOrderModel = OrderModel.fromEntity(createdOrder);
    return orderCollection.doc().set(updatedOrderModel.toMap());
    //return eventDBS.create(item);
  }

  @override
  Future<void> updateOrder(Order updatedOrder) {
    final OrderModel updatedOrderModel = OrderModel.fromEntity(updatedOrder);
    return orderCollection
        .doc(updatedOrderModel.id)
        .update(updatedOrderModel.toMap());
    //return eventDBS.updateData(id, item);
  }

  @override
  Future<OrderModel?> getOrderById(id) async {
    final doc = await orderCollection.doc(id).get();
    return OrderModel.fromDS(doc.id, doc.data()!);
    //return eventDBS.getSingle(id);
  }
}
