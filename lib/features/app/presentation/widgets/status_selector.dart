import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s3/features/app/domain/entities/order.dart';
import 'package:s3/features/app/presentation/bloc/order_calendar_bloc.dart';
import 'package:s3/features/app/presentation/widgets/status_icon_color_select.dart';

class StatusSelector extends StatefulWidget {
  final Order? event;
  const StatusSelector({Key? key, this.event}) : super(key: key);

  @override
  _StatusSelector createState() => _StatusSelector(order: event!);
}

class _StatusSelector extends State<StatusSelector>
    with StatusIconColorTextSelect {
  //final UpdateOrder updateOrder;
  Order? order;
  StatusValues? _status;
  TextEditingController? _price = TextEditingController();
  _StatusSelector({this.order})
      : _status = order!.status,
        super();

  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListView.builder(
              shrinkWrap: true,
              itemCount: StatusValues.values.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                    title: statusText(StatusValues.values[index]),
                    leading: Radio(
                      activeColor: statusIconColor(StatusValues.values[index]),
                      value: StatusValues.values[index],
                      groupValue: _status,
                      onChanged: (StatusValues? value) async {
                        if (value == StatusValues.completed) {
                          await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                      title: Text('Итого'),
                                      content: TextFormField(
                                        controller: _price,
                                        validator: (value) => (value!.isEmpty)
                                            ? "Пожалуйста, введите цену"
                                            : null,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        keyboardType: TextInputType.number,
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              if (_price!.text == '') {
                                                Navigator.of(context).pop();
                                              }
                                              _dispatchUpdateOrderStatus(value,
                                                  price:
                                                      int.parse(_price!.text));
                                              Navigator.of(context).pop();
                                              setState(() {
                                                _status = value;
                                              });
                                            },
                                            child: Text('ok'))
                                      ]));
                        } else {
                          _dispatchUpdateOrderStatus(value);
                          setState(() {
                            _status = value;
                          });
                        }
                      },
                    ));
              }),
        ],
      ),
    );
  }

  void _dispatchUpdateOrderStatus(value, {price}) {
    BlocProvider.of<OrderCalendarBloc>(context)
        .add(UpdateOrder(order!.copyWith(status: value, price: price)));
  }
}
