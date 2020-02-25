import 'package:ep_grn/models/doc_po.dart';
import 'package:ep_grn/models/doc_po_detail.dart';
import 'package:ep_grn/models/store.dart';
import 'package:ep_grn/modules/api.dart';
import 'package:ep_grn/utils/error.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class POViewNotifier with ChangeNotifier {
  final DocPO docPO;
  final _errMsgSubject = BehaviorSubject<String>.seeded(null);

  bool _isLoading = true;
  List<DocPODetail> _docPODetailList = [];
  List<Store> _storeList = [];
  Store _selectedStore;

  bool get isLoading => _isLoading;

  List<DocPODetail> get docPODetailList => _docPODetailList;

  List<Store> get storeList => _storeList;

  Store get selectedStore => _selectedStore;

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
      final resPODetailList = await Api().dio.get('',
          queryParameters: {'r': 'apiMobileFmGrn/getdata', 'type': 'po_detail', 'id': docPO.id});
      final rpdl = Map<String, dynamic>.from(resPODetailList.data);
      _docPODetailList = List<DocPODetail>.from(rpdl['list'].map((r) => DocPODetail.fromJson(r)));

      final resStoreList =
      await Api().dio.get('', queryParameters: {'r': 'apiMobileFmGrn/lookup', 'type': 'store'});
      final rsl = Map<String, dynamic>.from(resStoreList.data);
      _storeList = List<Store>.from(rsl['list'].map((r) => Store.fromJson(r)));

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errMsgSubject.add(formatApiErrorMsg(e));
      _errMsgSubject.add(null);
    }
  }

  setSelectedStore(Store store) {
    this._selectedStore = store;
    notifyListeners();
  }
}
