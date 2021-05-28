import 'package:flutter/material.dart';
import 'package:s3/features/app/domain/entities/order.dart';
import 'package:s3/features/app/domain/usecases/update_order.dart';
import 'package:s3/features/app/presentation/widgets/status_icon_color_select.dart';

import '../../../../injection_container.dart';

class StatusSelector extends StatefulWidget {
  final Order? event;
  const StatusSelector({Key? key, this.event}) : super(key: key);

  @override
  _StatusSelector createState() => _StatusSelector(sl(), event: event!);
}

class _StatusSelector extends State<StatusSelector>
    with StatusIconColorTextSelect {
  final UpdateOrder updateOrder;
  Order? event;
  StatusValues? _status;
  _StatusSelector(this.updateOrder, {this.event})
      : _status = event!.status,
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
                      onChanged: (StatusValues? value) {
                        setState(() {
                          _status = value;
                          //eventDBS.updateData(widget.event!.id!, {
                          updateOrder(widget.event!.id!, {
                            // "status": event!.status.toString().split('.')[1]
                            "status": value.toString().split('.')[1]
                          });
                        });
                      },
                    ));
              }),
        ],
      ),
    );
  }
}
