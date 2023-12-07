import 'package:found_adoption_application/models/pet.dart';
import 'package:found_adoption_application/models/pet_center.dart';
import 'package:found_adoption_application/models/user.dart';

class Adopt {
  final String id;
  final User? userId;
  final PetCenter? petCenterId;
  final Pet? petId;
  final String? descriptionAdoption;
  final String? cancelledReasonCenter;
  final String? cancelledReasonUser;
  final String statusAdopt;

  Adopt(
      {required this.id,
      required this.userId,
      required this.petCenterId,
      required this.petId,
      required this.descriptionAdoption,
      required this.cancelledReasonCenter,
      required this.cancelledReasonUser,
      required this.statusAdopt});

  factory Adopt.fromJson(Map<String, dynamic> json) {
    return Adopt(
        id: json['_id'] as String,
        userId: json['userId'] != null
            ? User(
                id: json['userId']['_id'] as String,
                firstName: json['userId']['firstName'] as String,
                lastName: json['userId']['lastName'] as String,
                avatar: json['userId']['avatar'] as String,
                address: json['userId']['address'] as String,
                phoneNumber: json['userId']['phoneNumber'] as String)
            : null,
        petCenterId: json['centerId'] != null
            ? PetCenter(
                id: json['centerId']['_id'] as String,
                name: json['centerId']['name'] as String,
                avatar: json['centerId']['avatar'] as String,
                address: json['centerId']['address'] as String,
                phoneNumber: json['centerId']['phoneNumber'] as String)
            : null,
        petId: json['petId'] != null
            ? Pet(
                id: json['_id'],
                centerId: json['petId']['centerId'],
                namePet: json['petId']['namePet'],
                petType: json['petId']['petType'],
                breed: json['petId']['breed'],
                gender: json['petId']['gender'],
                age: json['petId']['age'] as int,
                color: json['petId']['color'],
                description: json['petId']['description'],
                images: json['petId']['images'] as List<dynamic>,
                level: json['petId']['level'],
              )
            : null,
        descriptionAdoption: json['descriptionAdoption'] as String,
        cancelledReasonCenter: json['cancelledReasonCenter'] as String,
        cancelledReasonUser: json['cancelledReasonUser'] as String,
        statusAdopt: json['statusAdopt'] as String);
  }
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'userId': userId?.toMap(), // Đảm bảo cũng có hàm toMap trong class User
      'centerId': petCenterId
          ?.toMap(), // Đảm bảo cũng có hàm toMap trong class PetCenter
      // 'petId': petId?.toMap(),
      'descriptionAdoption': descriptionAdoption,
      'cancelledReasonCenter': cancelledReasonCenter,
      'cancelledReasonUser': cancelledReasonUser,
      'statusAdopt': statusAdopt
    };
  }
}