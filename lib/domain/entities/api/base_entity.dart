abstract class BaseEntity {
  Map<String, dynamic> toJson();

  const BaseEntity({
    required this.id
  });

  final String id;
}
