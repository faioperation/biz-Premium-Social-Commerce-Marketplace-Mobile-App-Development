import 'package:flutter/material.dart';
import 'screen_breakpoints.dart';

enum DeviceType {
  mobile,
  tablet,
  desktop,
  largeDesktop,
}

class ResponsiveBuilder {
  static DeviceType getDeviceType(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width <= ScreenBreakpoints.mobileMax) {
      return DeviceType.mobile;
    } else if (width <= ScreenBreakpoints.tabletMax) {
      return DeviceType.tablet;
    } else if (width <= ScreenBreakpoints.desktopMax) {
      return DeviceType.desktop;
    } else {
      return DeviceType.largeDesktop;
    }
  }

  static bool isMobile(BuildContext context) => getDeviceType(context) == DeviceType.mobile;
  static bool isTablet(BuildContext context) => getDeviceType(context) == DeviceType.tablet;
  static bool isDesktop(BuildContext context) => getDeviceType(context) == DeviceType.desktop;
  static bool isLargeDesktop(BuildContext context) => getDeviceType(context) == DeviceType.largeDesktop;
}
