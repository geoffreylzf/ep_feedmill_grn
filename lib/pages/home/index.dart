import 'package:ep_grn/animation/route_slide_right.dart';
import 'package:ep_grn/notifiers/po_list_notifier.dart';
import 'package:ep_grn/pages/doc_po/index.dart';
import 'package:ep_grn/res/nav.dart';
import 'package:ep_grn/widgets/simple_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomeIndexPage extends StatefulWidget {
  @override
  _HomeIndexPageState createState() => _HomeIndexPageState();
}

class _HomeIndexPageState extends State<HomeIndexPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Exit App'),
                    content: Text('Are you confirrm ?'),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: new Text('CANCEL'),
                      ),
                      FlatButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text('EXIT'),
                      ),
                    ],
                  );
                }) ??
            false;
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Eng Peng GRN")),
        body: Stack(
          children: [
            POListRefresher(),
            _ErrorMessage(),
          ],
        ),
        drawer: NavDrawerStart(),
      ),
    );
  }
}

class POListRefresher extends StatefulWidget {
  @override
  _POListRefresherState createState() => _POListRefresherState();
}

class _POListRefresherState extends State<POListRefresher> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
        GlobalKey<RefreshIndicatorState>();

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () async {
        await Provider.of<POListNotifier>(context, listen: false).refreshPOList();
      },
      child: POList(),
    );
  }
}

class POList extends StatefulWidget {
  @override
  _POListState createState() => _POListState();
}

class _POListState extends State<POList> {
  @override
  Widget build(BuildContext context) {
    final docPOList = Provider.of<POListNotifier>(context).docPOList;

    return ListView.builder(
      itemCount: docPOList.length,
      itemBuilder: (ctx, index) {
        final po = docPOList[index];
        return Padding(
          padding: const EdgeInsets.only(left: 4, top: 4, right: 4),
          child: Stack(
            children: [
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  po.docNo,
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                                ),
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
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  po.supplierName,
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 8, top: 4, bottom: 4),
                                        child: Icon(Icons.location_on, size: 12),
                                      ),
                                      Text(po.locationName,
                                          style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                                    ],
                                    mainAxisAlignment: MainAxisAlignment.end,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Container(height: 8),
                      Table(
                        border: TableBorder.all(color: Colors.grey[300]),
                        columnWidths: {
                          0: FractionColumnWidth(0.2),
                          1: FractionColumnWidth(0.25),
                          2: FractionColumnWidth(0.55),
                        },
                        children: [
                          TableRow(children: [
                            TableHeaderCell('Truck No'),
                            TableHeaderCell('Weight Bridge No'),
                            TableHeaderCell('Remark'),
                          ]),
                          TableRow(children: [
                            TableDetailCell(po.truckNo),
                            TableDetailCell(po.weightBridgeNo),
                            TableDetailCell(po.remark),
                          ]),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: new Material(
                  color: Colors.transparent,
                  child: new InkWell(
                    onTap: () async {
                      await Future.delayed(Duration(milliseconds: 100));
                      Navigator.push(
                        context,
                        SlideRightRoute(widget: DocPOIndexPage(po)),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<POListNotifier>(context, listen: false).errMsgStream.listen((errMsg) {
      if (errMsg != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleAlertDialog(
              title: 'Error',
              message: errMsg,
            );
          },
        );
      }
    });
    return Container();
  }
}

class TableHeaderCell extends StatelessWidget {
  final String text;

  TableHeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey[400], fontSize: 8),
      ),
    );
  }
}

class TableDetailCell extends StatelessWidget {
  final String text;
  final TextAlign textAlign;

  TableDetailCell(
    this.text, {
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        text,
        textAlign: textAlign,
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}