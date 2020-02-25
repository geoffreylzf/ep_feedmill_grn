import 'package:json_annotation/json_annotation.dart';

part 'store.g.dart';

@JsonSerializable()
class Store {
  int id;
  @JsonKey(name: 'store_code')
  String storeCode;
  @JsonKey(name: 'store_name')
  String storeName;

  Store(
    this.id,
    this.storeCode,
    this.storeName,
  );

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);

  Map<String, dynamic> toJson() => _$StoreToJson(this);
}
