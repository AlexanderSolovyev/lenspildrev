import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s3/features/app/presentation/cubit/clients_cubit.dart';
import 'package:s3/features/app/presentation/widgets/event_tile.dart';
import 'package:s3/features/app/presentation/widgets/message_handler.dart';

class ClientsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var orders = [];
    return BlocBuilder<ClientsCubit, ClientsState>(
      builder: (context, state) {
        if (state is ClientsLoadInProgress) {
          return CircularProgressIndicator();
        } else if (state is ClientsLoadSucess) {
          orders = state.orders;
        }
        return Column(
          children: [
            ListTile(
              leading: Icon(Icons.search),
              title: TextField(),
            ),
            Expanded(
              child: ListView(
                children: [
                  MessageHandler(),
                  ...orders.map((event) => EventTile(event: event)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
