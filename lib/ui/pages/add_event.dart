import 'package:s3/model/event.dart';
import 'package:flutter/material.dart';
import 'package:s3/res/event_firestore_service.dart';
import 'package:flutter/services.dart';

class AddEventPage extends StatefulWidget {
  final EventModel note;

  const AddEventPage({Key key, this.note}) : super(key: key);

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  TextStyle style = TextStyle(fontFamily: 'Robboto', fontSize: 16.0);
  TextEditingController _price;
  TextEditingController _title;
  TextEditingController _description;
  TextEditingController _phone;
  TextEditingController _name;
  DateTime _eventDate;
  StatusValues _status;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  bool processing;

  @override
  void initState() {
    super.initState();
    _price = TextEditingController(
        text: widget.note != null ? widget.note.price.toString() : "");
    _title = TextEditingController(
        text: widget.note != null ? widget.note.title : "");
    _description = TextEditingController(
        text: widget.note != null ? widget.note.description : "");
    _phone = TextEditingController(
        text: widget.note != null ? widget.note.phone : "");
    _name = TextEditingController(
        text: widget.note != null ? widget.note.name : "");
    _eventDate = DateTime.now();
    _status = widget.note != null ? widget.note.status : StatusValues.work;
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.note != null ? "Изменить детали заказа" : "Добавить заказ"),
      ),
      key: _key,
      body: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment.center,
          child: ListView(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                child: TextFormField(
                  controller: _title,
                  validator: (value) =>
                      (value.isEmpty) ? "Пожалуйста, укажите место" : null,
                  style: style,
                  decoration: InputDecoration(
                      labelText: "Где",
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                child: TextFormField(
                  controller: _description,
                  validator: (value) =>
                      (value.isEmpty) ? "Пожалуйста, напишите о заказе" : null,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                child: TextFormField(
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  controller: _price,
                  validator: (value) =>
                      (value.isEmpty) ? "Пожалуйста, введите цену" : null,
                  style: style,
                  decoration: InputDecoration(
                      filled: true,
                      labelText: "Цена",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.only(left: 26.0),
                title: Text(
                  "Дата",
                  style: TextStyle(fontSize: 12.0),
                ),
                subtitle: Text(
                  "${_eventDate.day} - ${_eventDate.month} - ${_eventDate.year}",
                  style: TextStyle(fontSize: 20.0),
                ),
                onTap: () async {
                  DateTime picked = await showDatePicker(
                      locale: const Locale('ru', 'RU'),
                      cancelText: 'ОТМЕНА',
                      context: context,
                      initialDate: _eventDate,
                      firstDate: DateTime(_eventDate.year - 5),
                      lastDate: DateTime(_eventDate.year + 5));
                  if (picked != null) {
                    setState(() {
                      _eventDate = picked;
                    });
                  }
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                child: TextFormField(
                  controller: _phone,
                  validator: (value) =>
                      (value.isEmpty) ? "Пожалуйста, запишите телефон" : null,
                  style: style,
                  decoration: InputDecoration(
                      filled: true,
                      labelText: "Телефон",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                child: TextFormField(
                  controller: _name,
                  validator: (value) =>
                      (value.isEmpty) ? "Пожалуйста, уточните имя" : null,
                  style: style,
                  decoration: InputDecoration(
                      filled: true,
                      labelText: "Имя",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              SizedBox(height: 10.0),
              processing
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(10.0),
                        color: Theme.of(context).primaryColor,
                        child: MaterialButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                processing = true;
                              });
                              if (widget.note != null) {
                                await eventDBS.updateData(widget.note.id, {
                                  'endTime': _eventDate,
                                  "price": int.parse(_price.text),
                                  "title": _title.text,
                                  "description": _description.text,
                                  //"startTime": widget.note.eventDate,
                                  "startTime": _eventDate,
                                  "phone": _phone.text,
                                  "name": _name.text,
                                  //"status": _status
                                });
                              } else {
                                await eventDBS.createItem(EventModel(
                                    startDay: "01-01-2020",
                                    price: int.parse(_price.text),
                                    allDay: false,
                                    title: _title.text,
                                    description: _description.text,
                                    eventDate: _eventDate,
                                    endTime: _eventDate,
                                    phone: _phone.text,
                                    status: _status,
                                    name: _name.text));
                              }
                              Navigator.pop(context);
                              setState(() {
                                processing = false;
                              });
                            }
                          },
                          child: Text(
                            "Записать",
                            style: style.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }
}
