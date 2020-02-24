import 'package:json_annotation/json_annotation.dart';

part 'doc_po_detail.g.dart';

@JsonSerializable()
class DocPODetail {
  @JsonKey(name: 'doc_detail_id')
  int docDetailId;
  @JsonKey(name: 'item_packing_id')
  int itemPackingId;
  @JsonKey(name: 'sku_code')
  String skuCode;
  @JsonKey(name: 'sku_name')
  String skuName;
  @JsonKey(name: 'uom_code')
  String uomCode;
  @JsonKey(name: 'uom_desc')
  String uomDesc;
  double factor;
  double qty;
  double weight;
  @JsonKey(name: 'grn_qty')
  double grnQty;
  @JsonKey(name: 'grn_weight')
  double grnWeight;
  @JsonKey(name: 'bal_qty')
  double balQty;
  @JsonKey(name: 'bal_weight')
  double balWeight;

  DocPODetail({
    this.docDetailId,
    this.itemPackingId,
    this.skuCode,
    this.skuName,
    this.uomCode,
    this.uomDesc,
    this.factor,
    this.qty,
    this.weight,
    this.grnQty,
    this.grnWeight,
    this.balQty,
    this.balWeight,
  });

  factory DocPODetail.fromJson(Map<String, dynamic> json) => _$DocPODetailFromJson(json);

  Map<String, dynamic> toJson() => _$DocPODetailToJson(this);
}
