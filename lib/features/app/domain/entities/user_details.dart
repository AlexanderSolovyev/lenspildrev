import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class UserDetails extends Equatable {
  final String? name;
  final String? userUID;

  UserDetails({@required this.name, @required this.userUID});

  @override
  List<Object?> get props => [name, userUID];
}
