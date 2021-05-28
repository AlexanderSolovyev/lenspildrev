import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:s3/features/app/data/models/order_model.dart';

abstract class OrderRemoteDataSource {
  Stream<List<OrderModel?>> get getOrders;
  Future<void> createOrder(item);
  Future<void> updateOrder(id, item);
  Future<OrderModel?> getOrderById(id);
}

class OrderRemoteDataSourceImpl extends OrderRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;

  OrderRemoteDataSourceImpl(this.firebaseFirestore);

  @override
  Stream<List<OrderModel?>> get getOrders => eventDBS.streamList();

  DatabaseService<OrderModel?> eventDBS = DatabaseService<OrderModel>("events",
      fromDS: (id, data) => OrderModel.fromDS(id, data!),
      toMap: (event) => event.toMap());

  @override
  Future<void> createOrder(item) {
    return eventDBS.create(item);
  }

  @override
  Future<void> updateOrder(id, item) {
    return eventDBS.updateData(id, item);
  }

  @override
  Future<OrderModel?> getOrderById(id) {
    return eventDBS.getSingle(id);
  }
}
