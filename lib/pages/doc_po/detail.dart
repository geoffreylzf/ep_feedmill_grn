import 'package:ep_grn/models/doc_po_detail.dart';
import 'package:ep_grn/models/grn_detail.dart';
import 'package:ep_grn/notifiers/doc_po_view_notifier.dart';
import 'package:ep_grn/pages/doc_po/physical_check_radio_btn.dart';
import 'package:ep_grn/utils/table.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DocPoDetailPage extends StatefulWidget {
  final DocPoViewNotifier poViewNotifier;

  const DocPoDetailPage(this.poViewNotifier);

  @override
  _DocPoDetailPageState createState() => _DocPoDetailPageState();
}

class _DocPoDetailPageState extends State<DocPoDetailPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.poViewNotifier,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Purchase Order Detail"),
        ),
        body: ListView(children: [DetailInfo(), Container(height: 8), DetailEntry()]),
      ),
    );
  }
}

class DetailInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dt = Provider.of<DocPoViewNotifier>(context).selectedDocPODetail;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(dt.skuName, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
          Text(dt.skuCode, style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
          Text(dt.uomDesc, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          Container(height: 8),
          Table(
            border: TableBorder.all(color: Colors.grey[300]),
            columnWidths: {
              0: FractionColumnWidth(0.2),
              1: FractionColumnWidth(0.4),
              2: FractionColumnWidth(0.4),
            },
            children: [
              TableRow(children: [
                TableHeaderCell(''),
                TableHeaderCell('Qty (${dt.uomCode})'),
                TableHeaderCell('Weight (Kg)'),
              ]),
              TableRow(children: [
                TableDetailCell("Ordered"),
                TableDetailCell(dt.qty.toString(), textAlign: TextAlign.right),
                TableDetailCell(dt.weight.toString(), textAlign: TextAlign.right),
              ]),
              TableRow(children: [
                TableDetailCell("Received"),
                TableDetailCell(dt.grnQty.toString(), textAlign: TextAlign.right),
                TableDetailCell(dt.grnWeight.toString(), textAlign: TextAlign.right),
              ]),
              TableRow(
                decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.black))),
                children: [
                  TableDetailCell("Bal."),
                  TableDetailCell(dt.balQty.toString(), textAlign: TextAlign.right),
                  TableDetailCell(dt.balWeight.toString(), textAlign: TextAlign.right),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

class DetailEntry extends StatefulWidget {
  @override
  _DetailEntryState createState() => _DetailEntryState();
}

class _DetailEntryState extends State<DetailEntry> {
  final _formKey = GlobalKey<FormState>();
  final dateFormat = DateFormat('yyyy-MM-dd');

  final tecQty = TextEditingController();
  final tecWeight = TextEditingController();
  final tecManufactureDate = TextEditingController();
  final tecExpireDate = TextEditingController();
  final tecSampleBagTtl = TextEditingController();
  final tecPcRemark = TextEditingController();
  var pcOdour = 0;
  var pcColour = 0;
  var pcSew = 0;
  var pcLabel = 0;
  var pcAppear = 0;

  DocPoDetail dt;

  @override
  void initState() {
    super.initState();
    tecQty.addListener(() {
      final qty = double.tryParse(tecQty.text);
      if (qty != null && dt != null) {
        tecWeight.text = (qty * dt.factor).toString();
      } else {
        tecWeight.text = "";
      }
    });
  }

  @override
  void dispose() {
    tecQty.dispose();
    tecWeight.dispose();
    tecManufactureDate.dispose();
    tecExpireDate.dispose();
    tecSampleBagTtl.dispose();
    tecPcRemark.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dt = Provider.of<DocPoViewNotifier>(context).selectedDocPODetail;

    final grnDt = Provider.of<DocPoViewNotifier>(context).getGrnDetail(dt);

    if (grnDt != null) {
      tecQty.text = grnDt.qty.toString();
      tecWeight.text = grnDt.weight.toString();
      tecManufactureDate.text = grnDt.manufactureDate.toString();
      tecExpireDate.text = grnDt.expireDate.toString();
      tecSampleBagTtl.text = grnDt.sampleBagTtl.toString();

      pcOdour = grnDt.pcOdour;
      pcColour = grnDt.pcColour;
      pcSew = grnDt.pcSew;
      pcLabel = grnDt.pcLabel;
      pcAppear = grnDt.pcAppear;
      tecPcRemark.text = grnDt.pcRemark;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: tecQty,
                    autofocus: true,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Received Qty",
                      contentPadding: EdgeInsets.all(16),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Cannot blank";
                      }
                      if (double.tryParse(value) == null) {
                        return "Number only";
                      }
                      return null;
                    },
                  ),
                ),
                Container(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: tecWeight,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Received Weight",
                      contentPadding: EdgeInsets.all(16),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Cannot blank";
                      }
                      if (double.tryParse(value) == null) {
                        return "Number only";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            Container(height: 8),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now().add(Duration(days: -3650)),
                        lastDate: DateTime.now().add(Duration(days: 3650)),
                      );

                      if (selectedDate != null) {
                        tecManufactureDate.text = dateFormat.format(selectedDate);
                      }
                    },
                    child: TextFormField(
                      controller: tecManufactureDate,
                      enabled: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Manufacture Date",
                        contentPadding: EdgeInsets.all(16),
                        errorStyle: TextStyle(
                          color: Theme.of(context).errorColor, // or any other color
                        ),
                      ),
                    ),
                  ),
                ),
                Container(width: 8),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now().add(Duration(days: -3650)),
                        lastDate: DateTime.now().add(Duration(days: 3650)),
                      );

                      if (selectedDate != null) {
                        tecExpireDate.text = dateFormat.format(selectedDate);
                      }
                    },
                    child: TextFormField(
                      controller: tecExpireDate,
                      enabled: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Expire Date",
                        contentPadding: EdgeInsets.all(16),
                        errorStyle: TextStyle(
                          color: Theme.of(context).errorColor, // or any other color
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: tecSampleBagTtl,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Total Sample Qty",
                      contentPadding: EdgeInsets.all(16),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Cannot blank";
                      }
                      if (int.tryParse(value) == null) {
                        return "Number only";
                      }
                      return null;
                    },
                  ),
                ),
                Container(width: 8),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
            Container(height: 8),
            Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  color: Colors.grey[700],
                  height: 24,
                  child: Center(
                    child: Text(
                      "Physical Check",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey[700]),
                  ),
                  child: Column(
                    children: <Widget>[
                      IntrinsicHeight(
                        child: Row(children: [
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                PhysicalCheckRadioBtn(
                                  title: "Odour",
                                  defaultValue: pcOdour,
                                  callback: (v) => pcOdour = v,
                                ),
                                Divider(color: Colors.grey[700], height: 1),
                                PhysicalCheckRadioBtn(
                                  title: "Sew",
                                  defaultValue: pcSew,
                                  callback: (v) => pcSew = v,
                                ),
                                Divider(color: Colors.grey[700], height: 1),
                                PhysicalCheckRadioBtn(
                                  title: "Appear",
                                  defaultValue: pcSew,
                                  callback: (v) => pcSew = v,
                                ),
                              ],
                            ),
                          ),
                          VerticalDivider(
                            color: Colors.grey[700],
                            thickness: 1,
                            width: 1,
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                PhysicalCheckRadioBtn(
                                  title: "Colour",
                                  defaultValue: pcColour,
                                  callback: (v) => pcColour = v,
                                ),
                                Divider(color: Colors.grey[700], height: 1),
                                PhysicalCheckRadioBtn(
                                  title: "Label",
                                  defaultValue: pcLabel,
                                  callback: (v) => pcLabel = v,
                                ),
                                Divider(color: Colors.grey[700], height: 1),
                                TextFormField(
                                  controller: tecPcRemark,
                                  autofocus: true,
                                  maxLength: 250,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    labelText: "Remark",
                                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(height: 16),
            Row(
              children: [
                Expanded(
                  child: RaisedButton.icon(
                    icon: Icon(Icons.delete),
                    label: Text("DELETE"),
                    onPressed: () {
                      if (grnDt != null) {
                        Provider.of<DocPoViewNotifier>(context, listen: false)
                            .removeGrnDetail(grnDt);
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Container(width: 8),
                Expanded(
                  child: RaisedButton.icon(
                    icon: Icon(Icons.save),
                    label: Text("SAVE"),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        final grnDetail = GrnDetail(
                          docDetailId: dt.docDetailId,
                          itemPackingId: dt.itemPackingId,
                          qty: double.tryParse(tecQty.text),
                          weight: double.tryParse(tecWeight.text),
                          manufactureDate: tecManufactureDate.text,
                          expireDate: tecExpireDate.text,
                          sampleBagTtl: int.tryParse(tecSampleBagTtl.text),
                          pcOdour: pcOdour,
                          pcColour: pcColour,
                          pcSew: pcSew,
                          pcLabel: pcLabel,
                          pcAppear: pcAppear,
                          pcRemark: tecPcRemark.text,
                          skuCode: dt.skuCode,
                          skuName: dt.skuName,
                          uomCode: dt.uomCode,
                          uomDesc: dt.uomDesc,
                        );

                        Provider.of<DocPoViewNotifier>(context, listen: false)
                            .addGrnDetail(grnDetail);
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
