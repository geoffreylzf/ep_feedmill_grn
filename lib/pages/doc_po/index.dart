import 'package:ep_grn/models/doc_po.dart';
import 'package:ep_grn/notifiers/po_view_notifier.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class DocPOIndexPage extends StatefulWidget {
  final DocPO docPO;

  DocPOIndexPage(this.docPO);

  @override
  _DocPOIndexPageState createState() => _DocPOIndexPageState();
}

class _DocPOIndexPageState extends State<DocPOIndexPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => POViewNotifier(docPO: widget.docPO),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text("Purchase Order"),
        ),
        body: Container(
          color: Colors.grey[200],
          child: ListView(
            children: [POHeader(), Container(height: 8), PODetail()],
          ),
        ),
      ),
    );
  }
}

class POHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final po = Provider.of<POViewNotifier>(context).docPO;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(po.docNo, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8, top: 4, bottom: 4),
                child: Icon(Icons.date_range, size: 12),
              ),
              Text(
                po.docDate,
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8, bottom: 4),
                child: Icon(FontAwesomeIcons.truck, size: 12),
              ),
              Text(
                po.deliveryDate,
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PODetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
    );
  }
}
