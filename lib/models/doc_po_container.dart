import 'package:json_annotation/json_annotation.dart';

part 'doc_po_container.g.dart';

@JsonSerializable()
class DocPoContainer {
  @JsonKey(name: 'container_id')
  int containerId;
  @JsonKey(name: 'container_code')
  String containerCode;
  @JsonKey(name: 'container_name')
  String containerName;

  DocPoContainer({
    this.containerId,
    this.containerCode,
    this.containerName,
  });

  factory DocPoContainer.fromJson(Map<String, dynamic> json) => _$DocPoContainerFromJson(json);

  Map<String, dynamic> toJson() => _$DocPoContainerToJson(this);
}
