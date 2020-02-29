import 'package:ep_grn/models/item_packing.dart';
import 'package:ep_grn/modules/api.dart';
import 'package:ep_grn/utils/error.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class GrnAddDetailNotifier with ChangeNotifier {
  bool _isLoading = false;
  int _itemPackingCount = 0;
  ItemPacking _selectedItemPacking;
  List<ItemPacking> _itemPackingList = [];
  final _errMsgSubject = BehaviorSubject<String>.seeded(null);

  bool get isLoading => _isLoading;

  int get itemPackingCount => _itemPackingCount;

  ItemPacking get selectedItemPacking => _selectedItemPacking;

  List<ItemPacking> get itemPackingList => _itemPackingList;

  Stream<String> get errMsgStream => _errMsgSubject.stream;

  @override
  void dispose() {
    _errMsgSubject.close();
    super.dispose();
  }

  GrnAddDetailNotifier() {
    fetchItemPackingList();
  }

  fetchItemPackingList({String filter = ''}) async {
    try {
      _selectedItemPacking = null;
      _isLoading = true;
      notifyListeners();
      final response = await Api().dio.get('', queryParameters: {
        'r': 'apiMobileFmGrn/lookup',
        'type': 'item_packing',
        'filter': filter,
      });
      final data = Map<String, dynamic>.from(response.data);
      _itemPackingCount = data['count'] as int;
      _itemPackingList = List<ItemPacking>.from(data['list'].map((r) => ItemPacking.fromJson(r)));
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errMsgSubject.add(formatApiErrorMsg(e));
      _errMsgSubject.add(null);
    }
  }

  setSelectedItemPacking(ItemPacking ip) {
    this._selectedItemPacking = ip;
    notifyListeners();
  }

  showError(String err) {
    _errMsgSubject.add(err);
    _errMsgSubject.add(null);
  }
}
