import 'package:ep_grn/models/doc_po.dart';
import 'package:ep_grn/models/doc_po_detail.dart';
import 'package:ep_grn/models/grn_detail.dart';
import 'package:ep_grn/models/store.dart';
import 'package:ep_grn/modules/api.dart';
import 'package:ep_grn/utils/error.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class PoViewNotifier with ChangeNotifier {
  final DocPo docPO;
  final _errMsgSubject = BehaviorSubject<String>.seeded(null);

  bool _isLoading = true;
  List<DocPoDetail> _docPODetailList = [];
  DocPoDetail _selectedDocPODetail;
  List<Store> _storeList = [];
  Store _selectedStore;
  List<GrnDetail> _grnDetailList = [];

  String refNo = '', remark = '';

  bool get isLoading => _isLoading;

  List<DocPoDetail> get docPODetailList => _docPODetailList;

  DocPoDetail get selectedDocPODetail => _selectedDocPODetail;

  List<Store> get storeList => _storeList;

  Store get selectedStore => _selectedStore;

  List<GrnDetail> get grnDetailList => _grnDetailList;

  Stream<String> get errMsgStream => _errMsgSubject.stream;

  @override
  void dispose() {
    _errMsgSubject.close();
    super.dispose();
  }

  PoViewNotifier({@required this.docPO}) {
    _init();
  }

  _init() async {
    try {
      final resPODetailList = await Api().dio.get('',
          queryParameters: {'r': 'apiMobileFmGrn/getdata', 'type': 'po_detail', 'id': docPO.id});
      final rpdl = Map<String, dynamic>.from(resPODetailList.data);
      _docPODetailList = List<DocPoDetail>.from(rpdl['list'].map((r) => DocPoDetail.fromJson(r)));

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

  setSelectedDocPODetail(DocPoDetail docPODetail) {
    this._selectedDocPODetail = docPODetail;
    notifyListeners();
  }

  GrnDetail getGrnDetail(DocPoDetail p) {
    final grn = _grnDetailList.singleWhere((g) {
      return g.docDetailId == p.docDetailId && g.itemPackingId == p.itemPackingId;
    }, orElse: () => null);

    return grn;
  }

  addGrnDetail(GrnDetail grnDetail) {
    _grnDetailList.removeWhere((g) {
      return g.docDetailId == grnDetail.docDetailId && g.itemPackingId == grnDetail.itemPackingId;
    });

    _grnDetailList.add(grnDetail);
    notifyListeners();
  }

  saveGrn(){
    if(refNo == '' || refNo == null){
      _errMsgSubject.add('Please enter supplier ref / DO');
      _errMsgSubject.add(null);
      return;
    }
    if(_selectedStore == null){
      _errMsgSubject.add('Please select store');
      _errMsgSubject.add(null);
      return;
    }
    if(remark == '' || remark == null){
      _errMsgSubject.add('Please enter remark');
      _errMsgSubject.add(null);
      return;
    }
  }
}
