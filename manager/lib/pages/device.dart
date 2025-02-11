
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:manager/core/mirror_method_channel.dart';

class DeviceApp {

  DeviceApp({required this.packageName, required this.name, required this.system});

  final String packageName;
  final String name;
  final bool system;


  factory DeviceApp.fromJson(Map<String, dynamic> json) {
    return DeviceApp(
      packageName: json['package_name'],
      name: json['name'],
      system: json['system'],
    );
  }

  static List<DeviceApp> fromJsonArray(List<dynamic> jsonArray) {
    return jsonArray.map((json) => DeviceApp.fromJson(json)).toList();
  }

}

class DevicePage extends StatefulWidget {
  const DevicePage({super.key});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  
  List<DeviceApp> _apps = [];
  late DeviceInfo _deviceInfo;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final device = ModalRoute.of(context)!.settings.arguments as DeviceInfo;
    _deviceInfo = device;
    MethodChannelSingleton().callRpc(device.host, device.port, "listApp", "{}").then((res) {
      final apps = DeviceApp.fromJsonArray(jsonDecode(res) as List<dynamic>);
      setState(() {
        _apps = apps;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Device Info"),
      ),
      body: ListView.builder(
        itemCount: _apps.length,
        itemBuilder: (context, index) {
          final app = _apps[index];
          return GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  // Image.network(
                  //   "http://icon.smartisan.com/drawable/${app.packageName}/icon_provided_by_smartisan.png",
                  //   fit: BoxFit.cover,
                  //   height: 120,
                  //   width: 120,
                  // ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(app.name),
                        Text('Package: ${app.packageName}')
                      ],
                    ),
                  )
                ],
              ),
            ),
            onTap: () async {
              MethodChannelSingleton().startAppMirror(_deviceInfo.host, _deviceInfo.port, app.packageName);
            },
          );
        },
      ),
    );
  }
  
}