import 'package:ep_grn/models/doc_po_detail.dart';
import 'package:ep_grn/models/grn_detail.dart';
import 'package:ep_grn/notifiers/po_view_notifier.dart';
import 'package:ep_grn/utils/table.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DocPoDetailPage extends StatefulWidget {
  final PoViewNotifier poViewNotifier;

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
    final dt = Provider.of<PoViewNotifier>(context).selectedDocPODetail;
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
                TableDetailCell("PO"),
                TableDetailCell(dt.qty.toString(), textAlign: TextAlign.right),
                TableDetailCell(dt.weight.toString(), textAlign: TextAlign.right),
              ]),
              TableRow(children: [
                TableDetailCell("GRN"),
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
  final tecExpiredDate = TextEditingController();

  DocPoDetail dt;

  @override
  void initState() {
    super.initState();
    tecQty.addListener(() {
      final qty = double.tryParse(tecQty.text);
      if (qty != null) {
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
    tecExpiredDate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dt = Provider.of<PoViewNotifier>(context).selectedDocPODetail;

    final grnDt = Provider.of<PoViewNotifier>(context).getGrnDetail(dt);

    if (grnDt != null) {
      tecQty.text = grnDt.qty.toString();
      tecWeight.text = grnDt.weight.toString();
      tecExpiredDate.text = grnDt.expiredDate.toString();
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
                  child: Container(),
                ),
                Container(width: 8),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now().add(Duration(days: -365)),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );

                      if (selectedDate != null) {
                        tecExpiredDate.text = dateFormat.format(selectedDate);
                      }
                    },
                    child: TextFormField(
                      controller: tecExpiredDate,
                      enabled: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Expired Date",
                        contentPadding: EdgeInsets.all(16),
                        errorStyle: TextStyle(
                          color: Theme.of(context).errorColor, // or any other color
                        ),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Cannot blank";
                        }
                        return null;
                      },
                    ),
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
                        Provider.of<PoViewNotifier>(context, listen: false).removeGrnDetail(grnDt);
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
                          expiredDate: tecExpiredDate.text,
                          skuCode: dt.skuCode,
                          skuName: dt.skuName,
                          uomCode: dt.uomCode,
                          uomDesc: dt.uomDesc,
                        );

                        Provider.of<PoViewNotifier>(context, listen: false).addGrnDetail(grnDetail);
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
