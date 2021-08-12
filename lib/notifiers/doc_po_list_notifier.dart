import 'package:ep_grn/models/doc_po.dart';
import 'package:ep_grn/modules/api.dart';
import 'package:ep_grn/utils/error.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class DocPoListNotifier with ChangeNotifier {
  bool _isLoading = false;
  List<DocPo> _docPOList = [];

  final _errMsgSubject = BehaviorSubject<String>.seeded(null);

  bool get isLoading => _isLoading;

  List<DocPo> get docPOList => _docPOList;

  Stream<String> get errMsgStream => _errMsgSubject.stream;

  @override
  void dispose() {
    _errMsgSubject.close();
    super.dispose();
  }

  DocPoListNotifier() {
    fetchPoList();
  }

  fetchPoList() async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await (await Api().dio).get('', queryParameters: {
        'r': 'apiMobileFmGrn/getdata',
        'type': 'po_list',
      });
      final data = Map<String, dynamic>.from(response.data);
      final poList = List<DocPo>.from(data['list'].map((r) => DocPo.fromJson(r)));
      _docPOList = poList;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errMsgSubject.add(formatApiErrorMsg(e));
      _errMsgSubject.add(null);
    }
  }
}
