import 'package:flutter/widgets.dart';

/// A utility class for responsive design.
class Responsive {
  final BuildContext context;
  late double _width;
  late double _height;
  late double _shortestSide;

  Responsive(this.context) {
    final size = MediaQuery.of(context).size;
    _width = size.width;
    _height = size.height;
    _shortestSide = size.shortestSide;
  }

  /// Returns true if the device is considered a mobile phone.
  bool get isMobile => _shortestSide < 600;

  /// Returns true if the device is considered a tablet.
  bool get isTablet => _shortestSide >= 600 && _shortestSide < 1200;

  /// Returns true if the device is considered a desktop.
  bool get isDesktop => _shortestSide >= 1200;

  /// Get width as a percentage of screen width.
  double wp(double percent) => _width * percent / 100;

  /// Get height as a percentage of screen height.
  double hp(double percent) => _height * percent / 100;

  /// Get a responsive font size based on screen width.
  double sp(double size) => size * (_width / 375);
}

