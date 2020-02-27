import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

const PRINTER_NAME = "PRINTER_NAME";
const PRINTER_ADDRESS = "PRINTER_ADDRESS";
const WEIGHING_NAME = "WEIGHING_NAME";
const WEIGHING_ADDRESS = "PRINTER_ADDRESS";

class BluetoothModule {
  static final _instance = BluetoothModule._internal();

  factory BluetoothModule() => _instance;

  BluetoothModule._internal();

  static SharedPreferences _sp;

  Future<SharedPreferences> get sp async {
    if (_sp != null) return _sp;
    _sp = await SharedPreferences.getInstance();
    return _sp;
  }

  static const MethodChannel _channel = const MethodChannel("bluetooth.flutter.io/method");

  static const EventChannel _readChannel = const EventChannel("bluetooth.flutter.io/read");

  static const EventChannel _statusChannel = const EventChannel("bluetooth.flutter.io/status");

  Future<List<BluetoothDevice>> getPairedDevices() async {
    final List list = await _channel.invokeMethod('getPairedDevices');
    return list.map((map) => BluetoothDevice.fromMap(map)).toList();
  }

  Future<bool> get isAvailable async => await _channel.invokeMethod('isAvailable');

  Future<bool> get isEnabled async => await _channel.invokeMethod('isEnabled');

  Future<bool> get isServiceAvailable async => await _channel.invokeMethod('isServiceAvailable');

  Future<dynamic> stopService() => _channel.invokeMethod('stopService');

  Future<dynamic> setupService() => _channel.invokeMethod('setupService');

  Future<dynamic> setDeviceTargetAndroid() => _channel.invokeMethod('setDeviceTargetAndroid');

  Future<dynamic> setDeviceTargetOther() => _channel.invokeMethod('setDeviceTargetOther');

  Future<dynamic> disconnect() => _channel.invokeMethod('disconnect');

  Future<dynamic> connect(String address) => _channel.invokeMethod('connect', {'address': address});

  Future<dynamic> sendText(String text) => _channel.invokeMethod('sendText', {'text': text});

  Future<dynamic> sendBytes(Uint8List bytes) =>
      _channel.invokeMethod('sendBytes', {'bytes': bytes});

  Future<dynamic> printQr(String qr) => _channel.invokeMethod('printQr', {'qr': qr});

  Stream<String> onRead() =>
      _readChannel.receiveBroadcastStream().map((buffer) => buffer.toString());

  Stream<BluetoothStatus> onStatusChanged() =>
      _statusChannel.receiveBroadcastStream().map((buffer) => BluetoothStatus.fromMap(buffer));

  simpleConnectOther(String address) async {
    await stopService();
    await setupService();
    await setDeviceTargetOther();
    await Future.delayed(Duration(seconds: 1));
    await connect(address);
  }

  saveBluetoothPrinter(BluetoothDevice device) async {
    final prefs = await sp;
    await prefs.setString(PRINTER_NAME, device.name);
    await prefs.setString(PRINTER_ADDRESS, device.address);
  }

  Future<BluetoothDevice> getBluetoothPrinter() async {
    final prefs = await sp;
    final name = prefs.getString(PRINTER_NAME);
    final address = prefs.getString(PRINTER_ADDRESS);

    if (name == null || address == null) {
      return null;
    }

    return BluetoothDevice(name, address);
  }

  saveBluetoothWeighing(BluetoothDevice device) async {
    final prefs = await sp;
    await prefs.setString(WEIGHING_NAME, device.name);
    await prefs.setString(WEIGHING_ADDRESS, device.address);
  }

  Future<BluetoothDevice> getBluetoothWeighing() async {
    final prefs = await sp;
    final name = prefs.getString(WEIGHING_NAME);
    final address = prefs.getString(WEIGHING_ADDRESS);

    if (name == null || address == null) {
      return null;
    }

    return BluetoothDevice(name, address);
  }
}

class BluetoothDevice {
  final String name;
  final String address;

  BluetoothDevice(this.name, this.address);

  BluetoothDevice.fromMap(Map map)
      : name = map["name"],
        address = map["address"];
}

class BluetoothStatus {
  final Status status;
  final String name;
  final String address;

  BluetoothStatus(this.status, this.name, this.address);

  BluetoothStatus.fromMap(Map map)
      : name = map["name"],
        address = map["address"],
        status = getStatus(map["status"]);
}

enum Status { DISCONNECTED, CONNECTION_FAILED, CONNECTED }

getStatus(String str) {
  if (str == "-1") {
    return Status.CONNECTION_FAILED;
  } else if (str == "0") {
    return Status.DISCONNECTED;
  } else if (str == "1") {
    return Status.CONNECTED;
  }
}
