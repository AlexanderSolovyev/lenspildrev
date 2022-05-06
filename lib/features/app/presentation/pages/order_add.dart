import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s3/features/app/domain/entities/order.dart';
import 'package:s3/features/app/presentation/bloc/order_calendar_bloc.dart';
import 'package:s3/features/app/presentation/widgets/date_picker_widget.dart';
import 'package:s3/features/app/presentation/widgets/status_icon_color_select.dart';
import 'package:intl/intl.dart';

class AddEventPage extends StatefulWidget {
  final bool newOrder;
  final Order? note;
  final DateTime? selectedDay;

  const AddEventPage(
      {Key? key, this.note, this.selectedDay, required this.newOrder})
      : super(key: key);

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage>
    with StatusIconColorTextSelect {
  TextStyle style = TextStyle(fontFamily: 'Robboto', fontSize: 16.0);
  TextEditingController? _price;
  TextEditingController? _title;
  TextEditingController? _description;
  TextEditingController? _phone;
  TextEditingController? _name;
  TextEditingController? _estimate;
  DateTime? _eventDate;
  StatusValues? _status;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  bool processing = false;

  _AddEventPageState();

  @override
  void initState() {
    super.initState();
    _price = TextEditingController(
        text: widget.note != null ? widget.note!.price.toString() : "0");
    _title = TextEditingController(
        text: widget.note != null ? widget.note!.title : "");
    _description = TextEditingController(
        text: widget.note != null ? widget.note!.description : "");
    _phone = TextEditingController(
        text: widget.note != null ? widget.note!.phone : "");
    _name = TextEditingController(
        text: widget.note != null ? widget.note!.name : "");
    _eventDate =
        widget.note != null ? widget.note!.eventDate : widget.selectedDay;
    _status = (widget.note != null ? widget.note!.status : StatusValues.work)!;
    _estimate = TextEditingController(
        text: widget.note != null ? widget.note!.estimate : "");

    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    String languageCode = Localizations.localeOf(context).languageCode;

    return WillPopScope(
      onWillPop: _willPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              !widget.newOrder ? "Изменить детали заказа" : "Добавить заказ"),
        ),
        key: _key,
        body: Form(
          key: _formKey,
          child: Container(
            alignment: Alignment.center,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 5.0),
                  child: TextFormField(
                    controller: _title,
                    validator: (value) =>
                        (value!.isEmpty) ? "Пожалуйста, укажите место" : null,
                    style: style,
                    decoration: InputDecoration(
                        labelText: "Где",
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 5.0),
                  child: TextFormField(
                    controller: _description,
                    validator: (value) => (value!.isEmpty)
                        ? "Пожалуйста, напишите о заказе"
                        : null,
                    style: style,
                    decoration: InputDecoration(
                        filled: true,
                        labelText: "Что",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                //const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 5.0),
                  child: TextFormField(
                    //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: _estimate,
                    validator: (value) => (value!.isEmpty)
                        ? "Пожалуйста, введите предварительную цену"
                        : null,
                    style: style,
                    decoration: InputDecoration(
                        filled: true,
                        labelText: "Оценка",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                ListTile(
                    contentPadding: EdgeInsets.only(left: 26.0, right: 26.0),
                    title: Text(
                      "Дата",
                      style: TextStyle(fontSize: 12.0),
                    ),
                    subtitle: Text(
                      //"${_eventDate!.day} - ${_eventDate!.month} - ${_eventDate!.year}",
                      DateFormat("d MMMM yyyy", languageCode)
                          .format(_eventDate!),
                      style: TextStyle(fontSize: 20.0),
                    ),
                    trailing: !widget.newOrder
                        ? IconButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddEventPage(
                                  note: widget.note,
                                  newOrder: true,
                                ),
                              ),
                            ),
                            icon: Icon(Icons.copy),
                          )
                        : Container(
                            height: 10.0,
                            width: 10.0,
                          ),
                    onTap: () =>
                        _showDialog() /*  () async {
                    DateTime? picked = await showDatePicker(
                        locale: const Locale('ru', 'RU'),
                        cancelText: 'ОТМЕНА',
                        context: context,
                        initialDate: _eventDate!,
                        firstDate: DateTime(_eventDate!.year - 5),
                        lastDate: DateTime(_eventDate!.year + 5));
                    if (picked != null) {
                      setState(() {
                        _eventDate = picked;
                      });
                    }
                  }, */
                    ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 5.0),
                  child: TextFormField(
                    controller: _phone,
                    validator: (value) => (value!.isEmpty)
                        ? "Пожалуйста, запишите телефон"
                        : null,
                    style: style,
                    decoration: InputDecoration(
                        filled: true,
                        labelText: "Телефон",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 5.0),
                  child: TextFormField(
                    controller: _name,
                    validator: (value) =>
                        (value!.isEmpty) ? "Пожалуйста, уточните имя" : null,
                    style: style,
                    decoration: InputDecoration(
                        filled: true,
                        labelText: "Имя",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 5.0),
                  child: statusSelector(context),
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDialog() async {
    return showDialog<void>(
      useSafeArea: true,
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          title: const Text('Выберите дату'),
          content: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              child: DatePickerWidget(eventDate: (value) {
                setState(() {
                  _eventDate = value;
                });
              })),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget statusSelector(BuildContext context) {
    return Card(
      child: ListView.builder(
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
                      _status = value!;
                    });
                  },
                ));
          }),
    );
  }

  @override
  void dispose() {
    _title!.dispose();
    _description!.dispose();
    super.dispose();
  }

  void _dispatchCreateOrder(order) {
    BlocProvider.of<OrderCalendarBloc>(context).add(CreateOrder(order));
  }

  void _dispatchUdateOrder(order) {
    BlocProvider.of<OrderCalendarBloc>(context).add(UpdateOrder(order));
  }

  Future<bool> _willPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Покидаем страницу'),
            content: new Text('Записать заказ ?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Нет'),
              ),
              TextButton(
                onPressed: () async {
                  if (!widget.newOrder) {
                    final updatedOrder = Order(
                      id: widget.note!.id!,
                      startDay: "01-01-2020",
                      price: int.parse(_price?.text ?? '0'),
                      allDay: false,
                      title: _title!.text,
                      description: _description!.text,
                      eventDate: _eventDate ?? DateTime.now(),
                      endTime: _eventDate,
                      phone: _phone!.text,
                      status: _status,
                      name: _name!.text,
                      estimate: _estimate!.text,
                    );
                    _dispatchUdateOrder(updatedOrder);
                  } else {
                    final newOrder = Order(
                        startDay: "01-01-2020",
                        price: int.parse(_price?.text ?? '0'),
                        allDay: false,
                        title: _title!.text,
                        description: _description!.text,
                        eventDate: _eventDate ?? DateTime.now(),
                        endTime: _eventDate,
                        phone: _phone!.text,
                        status: _status,
                        name: _name!.text,
                        estimate: _estimate!.text);
                    _dispatchCreateOrder(newOrder);
                  }
                  Navigator.of(context).pop(true);
                },
                child: new Text('Да'),
              ),
            ],
          ),
        )) ??
        false;
  }
}
