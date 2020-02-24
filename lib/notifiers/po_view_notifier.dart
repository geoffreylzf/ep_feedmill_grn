import 'package:ep_grn/models/doc_po.dart';
import 'package:ep_grn/models/doc_po_detail.dart';
import 'package:ep_grn/modules/api.dart';
import 'package:ep_grn/utils/error.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class POViewNotifier with ChangeNotifier {
  final DocPO docPO;
  final _errMsgSubject = BehaviorSubject<String>.seeded(null);

  bool _isLoading = true;
  List<DocPODetail> _docPODetailList = [];

  bool get isLoading => _isLoading;

  List<DocPODetail> get docPODetailList => _docPODetailList;

  Stream<String> get errMsgStream => _errMsgSubject.stream;

  @override
  void dispose() {
    _errMsgSubject.close();
    super.dispose();
  }

  POViewNotifier({@required this.docPO}) {
    _init();
  }

  _init() async {
    try {
      final response = await Api().dio.get('',
          queryParameters: {'r': 'apiMobileFmGrn/getdata', 'type': 'po_detail', 'id': docPO.id});
      final data = Map<String, dynamic>.from(response.data);
      _docPODetailList = List<DocPODetail>.from(data['list'].map((r) => DocPODetail.fromJson(r)));
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errMsgSubject.add(formatApiErrorMsg(e));
      _errMsgSubject.add(null);
    }
  }
}
