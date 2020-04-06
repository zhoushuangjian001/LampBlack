package com.example.lampblack;

import androidx.annotation.NonNull;

import android_serialport_api.SerialPortUtil;
import callback.SerialCallBack;
import callback.SerialPortCallBackUtils;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import util.ByteUtil;

public class MainActivity extends FlutterActivity implements SerialCallBack {
  // 打开串口渠道
  private static final String SerialportChannel = "com.lamp.serialport";
  // 发送指令获取串口信息的渠道
  private static final String SerialportDataChannel = "com.lamp.serialportdata";
  // 发送指令获取串口信息
  private String _serialProtData = "";

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine);
    // 注册串口数据回调函数
    SerialPortCallBackUtils.setCallBack(this);
    // 打开串口方法
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), SerialportChannel)
        .setMethodCallHandler((call, result) -> {
          result.success(callOpendSerialportMethod());
        });
    // 发送指令获取串口信息
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), SerialportDataChannel)
        .setMethodCallHandler((call, result) -> {
          String cmd = (String)call.arguments;
          result.success(sendCommandObtainSerialPortData(cmd));
        });
  }

  // 打开串口的方法
  public boolean callOpendSerialportMethod() {
    if (SerialPortUtil.isFlagSerial) {
      return true;
    }
    return SerialPortUtil.open("/dev/ttyS3", 9600, 0);
  }

  // 发送获取串口信息
  public String sendCommandObtainSerialPortData(String cmd) {
    SerialPortUtil.sendString(cmd);
    return _serialProtData;
  }

  // SerialCallBack 串口信息回调方法
  @Override
  public void onSerialPortData(String serialPortData) {
    _serialProtData = serialPortData;
  }
}
