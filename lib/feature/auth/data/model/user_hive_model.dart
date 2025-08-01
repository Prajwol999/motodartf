import 'package:hive/hive.dart';
import 'package:motofix_app/feature/auth/domain/entity/auth_entity.dart';
import 'package:uuid/uuid.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: 1)
class UserHiveModel extends HiveObject {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String fullName;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String password;
  

  UserHiveModel({
    String? userId,
    required this.fullName,

    required this.email,
    required this.password,

  }) : userId = userId ?? const Uuid().v4();

  UserEntity toEntity() => UserEntity(
    userId: userId,
    fullName: fullName,
    email: email,
    password: password,

  );

  factory UserHiveModel.fromEntity(UserEntity entity) => UserHiveModel(
    userId: entity.userId,
    fullName: entity.fullName,
    email: entity.email,
    password: entity.password,

  );
}