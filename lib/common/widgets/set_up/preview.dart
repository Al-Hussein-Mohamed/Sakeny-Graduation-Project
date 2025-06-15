import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

class Preview extends StatelessWidget {

  const Preview({super.key, this.devicePreview = false, required this.child});
  final bool devicePreview;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return devicePreview
        ? DevicePreview(
            enabled: devicePreview,
            builder: (context) => child,
          )
        : child;
  }
}
