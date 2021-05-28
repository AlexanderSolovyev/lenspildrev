import 'package:s3/features/app/domain/entities/user_details.dart';
import 'package:meta/meta.dart';

class UserDetailsModel extends UserDetails {
  UserDetailsModel({
    @required String? name,
    @required String? userUID,
  }) : super(
          name: name,
          userUID: userUID,
        );

  factory UserDetailsModel.fromDS(Map<String, dynamic> data) {
    return UserDetailsModel(name: data['name'], userUID: data['id']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'user': userUID,
    };
  }
}

//DatabaseService<UserModel> eventDBS = DatabaseService<UserModel>("users",
//   fromDS: (id, data) => UserModel.fromDS(id, data!));
//toMap: (event) => event.toMap());
