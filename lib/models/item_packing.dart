import 'package:json_annotation/json_annotation.dart';

part 'item_packing.g.dart';

@JsonSerializable()
class ItemPacking {
  int id;
  @JsonKey(name: 'sku_code')
  String skuCode;
  @JsonKey(name: 'sku_name')
  String skuName;
  @JsonKey(name: 'uom_desc')
  String uomDesc;
  @JsonKey(name: 'uom_code')
  String uomCode;
  double factor;

  ItemPacking({
    this.id,
    this.skuCode,
    this.skuName,
    this.uomDesc,
    this.uomCode,
    this.factor,
  });

  factory ItemPacking.fromJson(Map<String, dynamic> json) => _$ItemPackingFromJson(json);

  Map<String, dynamic> toJson() => _$ItemPackingToJson(this);
}
