import 'package:ep_grn/models/doc_po_container.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class GrnAddContainerNotifier with ChangeNotifier {
  DocPoContainer _selectedContainer;
  final _errMsgSubject = BehaviorSubject<String>.seeded(null);

  DocPoContainer get selectedContainer => _selectedContainer;

  Stream<String> get errMsgStream => _errMsgSubject.stream;

  @override
  void dispose() {
    _errMsgSubject.close();
    super.dispose();
  }

  setSelectedContainer(DocPoContainer c) {
    this._selectedContainer = c;
    notifyListeners();
  }

  showError(String err) {
    _errMsgSubject.add(err);
    _errMsgSubject.add(null);
  }
}
