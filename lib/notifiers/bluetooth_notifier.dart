import 'package:ep_grn/modules/bluetooth.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/subjects.dart';

enum BluetoothType { Weighing, Printer }
const _kg = "kg";

class BluetoothNotifier with ChangeNotifier {
  final _bluetooth = BluetoothModule();
  String _address = "";
  bool _isDispose = false;
  final BluetoothType type;

  final _devicesSubject = BehaviorSubject<List<BluetoothDevice>>.seeded([]);
  final _nameSubject = BehaviorSubject<String>.seeded("");
  final _addressSubject = BehaviorSubject<String>.seeded("");

  final _statusSubject = BehaviorSubject<String>.seeded("Not Connect");
  final _weighingResultSubject = BehaviorSubject<String>.seeded("");

  final _isConnectedSubject = BehaviorSubject<bool>.seeded(false);
  final _isBluetoothEnabledSubject = BehaviorSubject<bool>.seeded(false);

  final _errMsgSubject = BehaviorSubject<String>.seeded(null);

  Stream<List<BluetoothDevice>> get devicesStream => _devicesSubject.stream;

  Stream<String> get nameStream => _nameSubject.stream;

  Stream<String> get addressStream => _addressSubject.stream;

  Stream<String> get statusStream => _statusSubject.stream;

  Stream<String> get weighingResultStream => _weighingResultSubject.stream;

  Stream<bool> get isConnectedStream => _isConnectedSubject.stream;

  Stream<bool> get isBluetoothEnabledStream => _isBluetoothEnabledSubject.stream;

  Stream<String> get errMsgStream => _errMsgSubject.stream;

  BluetoothNotifier(this.type) {
    init();
  }

  init() async {
    final isBluetoothAvailable = await _bluetooth.isAvailable;
    if (!isBluetoothAvailable) {
      _errMsgSubject.add('Bluetooth not available!');
      _errMsgSubject.add(null);
      return;
    }

    final isBluetoothEnabled = await _bluetooth.isEnabled;
    if (!isBluetoothEnabled) {
      _errMsgSubject.add('Bluetooth not enable!');
      _errMsgSubject.add(null);
      return;
    } else {
      _isBluetoothEnabledSubject.add(true);
    }

    await loadDevices();

    _bluetooth.onStatusChanged().listen((btStatus) {
      if (!_isDispose) {
        switch (btStatus.status) {
          case Status.CONNECTED:
            _statusSubject.add("Connected");
            _isConnectedSubject.add(true);
            break;
          case Status.DISCONNECTED:
            _statusSubject.add("Disconnected");
            _isConnectedSubject.add(false);
            break;
          case Status.CONNECTION_FAILED:
            _statusSubject.add("Failed");
            _isConnectedSubject.add(false);
            break;
          default:
            _statusSubject.add("Unknown");
            _isConnectedSubject.add(false);
            break;
        }
      }
    });

    _bluetooth.onRead().listen((data) {
      if (!_isDispose && type == BluetoothType.Weighing) {
        if (data.contains(_kg)) {
          data = data.replaceAll(_kg, "");
          data = data.trim();
          _weighingResultSubject.add(data);
        }
      }
    });

    var device;
    if (type == BluetoothType.Printer) {
      device = await _bluetooth.getBluetoothPrinter();
    } else if (type == BluetoothType.Weighing) {
      device = await _bluetooth.getBluetoothWeighing();
    }

    if (device != null) {
      _nameSubject.add(device.name);
      _addressSubject.add(device.address);
      _address = device.address;
      await connectDevice();
    }
  }

  loadDevices() async {
    List<BluetoothDevice> devices = await _bluetooth.getPairedDevices();
    _devicesSubject.sink.add(devices);
  }

  selectDevice(BluetoothDevice device) async {
    _nameSubject.add(device.name);
    _addressSubject.add(device.address);
    _address = device.address;
    await connectDevice();
    if (type == BluetoothType.Printer) {
      await _bluetooth.saveBluetoothPrinter(device);
    } else if (type == BluetoothType.Weighing) {
      await _bluetooth.saveBluetoothWeighing(device);
    }
  }

  connectDevice() async {
    _statusSubject.add("Connecting");
    await _bluetooth.simpleConnectOther(_address);
  }

  disconnectDevice() async {
    await _bluetooth.stopService();
  }

  print(String qrText, String printText) async {
    if (qrText != null) {
      await _bluetooth.printQr(qrText);
    }
    await _bluetooth.sendText(printText);
  }

  String getWeighingResult() {
    return _weighingResultSubject.value;
  }

  @override
  void dispose() {
    _isDispose = true;
    _bluetooth.stopService();

    _devicesSubject.close();
    _nameSubject.close();
    _addressSubject.close();

    _statusSubject.close();
    _weighingResultSubject.close();

    _isConnectedSubject.close();
    _isBluetoothEnabledSubject.close();

    _errMsgSubject.close();
    super.dispose();
  }
}
