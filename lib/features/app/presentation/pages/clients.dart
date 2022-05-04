import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s3/features/app/presentation/cubit/clients_cubit.dart';
import 'package:s3/features/app/presentation/widgets/event_tile.dart';
import 'package:s3/features/app/presentation/widgets/message_handler.dart';

import '../../domain/entities/order.dart';

class ClientsPage extends StatefulWidget {
  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  TextEditingController _searchController = TextEditingController();
  late List<Order> _filteredOrders;

  List<String> statuses = [
    "Все",
    "Отмена",
    'Звонить',
    'Смотреть',
    'Работать',
    'Илья молодец'
  ];
  late String status;
  @override
  void initState() {
    super.initState();
    status = 'Все';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientsCubit, ClientsState>(
      builder: (context, state) {
        if (state is ClientsLoadInProgress) {
          return CircularProgressIndicator();
        } else if (state is ClientsLoadSucess) {
          //  if (_searchController.text.length > 0 && status != 'Все') {
          _filteredOrders = state.filteredOrders;
          print('ds= ' + _filteredOrders.length.toString());
          //  } else { */
          // _filteredOrders = state.orders;
          // }
          _filteredOrders.sort((a, b) => b!.eventDate.compareTo(a!.eventDate));
        }
        return Column(
          children: [
            DropdownButton(
                value: status,
                items: statuses.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                      child: Text(value), value: value);
                }).toList(),
                onChanged: (newValue) => changeStatus(newValue)),
            ListTile(
              leading: Icon(Icons.search),
              title: TextField(
                controller: _searchController,
                onChanged: (_) => BlocProvider.of<ClientsCubit>(context)
                    .filter(_searchController.text),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  MessageHandler(),
                  ..._filteredOrders.map((event) => EventTile(event: event)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  changeStatus(newValue) {
    BlocProvider.of<ClientsCubit>(context).changeStatus(newValue);
    setState(() {
      print(newValue);
      status = newValue;
    });
  }
}
