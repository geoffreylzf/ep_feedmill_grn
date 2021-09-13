import 'package:ep_grn/animation/route_slide_right.dart';
import 'package:ep_grn/notifiers/doc_po_list_notifier.dart';
import 'package:ep_grn/pages/doc_po/index.dart';
import 'package:ep_grn/res/nav.dart';
import 'package:ep_grn/utils/table.dart';
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
        await Provider.of<DocPoListNotifier>(context, listen: false).fetchPoList();
      },
      child: DocPoList(),
    );
  }
}

class DocPoList extends StatefulWidget {
  @override
  _DocPoListState createState() => _DocPoListState();
}

class _DocPoListState extends State<DocPoList> {
  @override
  Widget build(BuildContext context) {
    final docPOList = Provider.of<DocPoListNotifier>(context).docPOList;

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
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8, top: 2, bottom: 2),
                                      child: Icon(Icons.location_on, size: 12),
                                    ),
                                    Text(po.locationName,
                                        style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.end,
                                ),
                                Container(
                                  margin: const EdgeInsets.all(4),
                                  width: double.infinity,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.red,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Trip #" + po.tripNo.toString(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
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
                          1: FractionColumnWidth(0.2),
                          2: FractionColumnWidth(0.2),
                          3: FractionColumnWidth(0.4),
                        },
                        children: [
                          TableRow(children: [
                            TableHeaderCell('Truck No'),
                            TableHeaderCell('Csr No'),
                            TableHeaderCell('W.B. No'),
                            TableHeaderCell('Container No'),
                          ]),
                          TableRow(children: [
                            TableDetailCell(po.truckNo ?? ''),
                            TableDetailCell(po.csrNo ?? ''),
                            TableDetailCell(po.weightBridgeNo ?? ''),
                            TableDetailCell(po.containerNo ?? ''),
                          ]),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.comment, size: 16),
                          Text(po.remark ?? ''),
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
                    onTap: Provider.of<DocPoListNotifier>(context).isLoading
                        ? null
                        : () async {
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
    Provider.of<DocPoListNotifier>(context, listen: false).errMsgStream.listen((errMsg) {
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
