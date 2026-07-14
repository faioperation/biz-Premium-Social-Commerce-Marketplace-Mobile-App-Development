import 'package:flutter/material.dart';
import 'responsive_builder.dart';

class AdaptiveLayout extends StatelessWidget {
  /// The default desktop layout. Since the admin panel is desktop-first, this is required.
  final Widget desktop;
  
  /// Optional layout for extremely large screens. Defaults to [desktop] if not provided.
  final Widget? largeDesktop;
  
  /// Optional layout for tablets. Defaults to [desktop] if not provided.
  final Widget? tablet;
  
  /// Optional layout for mobile phones. Defaults to [tablet] or [desktop] if not provided.
  final Widget? mobile;

  const AdaptiveLayout({
    super.key,
    required this.desktop,
    this.largeDesktop,
    this.tablet,
    this.mobile,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // We evaluate constraints.maxWidth instead of MediaQuery to support nested layouts
        double width = constraints.maxWidth;
        
        // For testing/mocking when constraints might be infinite
        if (width == double.infinity) {
          width = MediaQuery.of(context).size.width;
        }

        DeviceType deviceType;
        if (width <= 767.9) { // ScreenBreakpoints.mobileMax
          deviceType = DeviceType.mobile;
        } else if (width <= 1023.9) { // ScreenBreakpoints.tabletMax
          deviceType = DeviceType.tablet;
        } else if (width <= 1439.9) { // ScreenBreakpoints.desktopMax
          deviceType = DeviceType.desktop;
        } else {
          deviceType = DeviceType.largeDesktop;
        }

        if (deviceType == DeviceType.largeDesktop) {
          return largeDesktop ?? desktop;
        }
        if (deviceType == DeviceType.desktop) {
          return desktop;
        }
        if (deviceType == DeviceType.tablet) {
          return tablet ?? desktop;
        }
        // mobile
        return mobile ?? tablet ?? desktop;
      },
    );
  }
}
