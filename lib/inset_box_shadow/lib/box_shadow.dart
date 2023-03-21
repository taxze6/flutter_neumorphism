import 'dart:ui' as ui show lerpDouble;
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart' hide BoxShadow;
import 'package:flutter/painting.dart' as painting;

class BoxShadow extends painting.BoxShadow {
  const BoxShadow({
    Color color = const Color(0xFF000000),
    Offset offset = Offset.zero,
    double blurRadius = 0.0,
    double spreadRadius = 0.0,
    BlurStyle blurStyle = BlurStyle.normal,
    this.inset = false,
  }) : super(
          color: color,
          offset: offset,
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
          blurStyle: blurStyle,
        );

  /// Wether this shadow should be inset or not.
  final bool inset;

  /// Returns a new box shadow with its offset, blurRadius, and spreadRadius scaled by the given factor.
  @override
  BoxShadow scale(double factor) {
    return BoxShadow(
      color: color,
      offset: offset * factor,
      blurRadius: blurRadius * factor,
      spreadRadius: spreadRadius * factor,
      blurStyle: blurStyle,
      inset: inset,
    );
  }

  /// Linearly interpolate between two box shadows.
  ///
  /// If either box shadow is null, this function linearly interpolates from a
  /// a box shadow that matches the other box shadow in color but has a zero
  /// offset and a zero blurRadius.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static BoxShadow? lerp(BoxShadow? a, BoxShadow? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    if (a == null) {
      return b!.scale(t);
    }
    if (b == null) {
      return a.scale(1.0 - t);
    }

    final blurStyle =
        a.blurStyle == BlurStyle.normal ? b.blurStyle : a.blurStyle;

    if (a.inset != b.inset) {
      return BoxShadow(
        color: lerpColorWithPivot(a.color, b.color, t),
        offset: lerpOffsetWithPivot(a.offset, b.offset, t),
        blurRadius: lerpDoubleWithPivot(a.blurRadius, b.blurRadius, t),
        spreadRadius: lerpDoubleWithPivot(a.spreadRadius, b.spreadRadius, t),
        blurStyle: blurStyle,
        inset: t >= 0.5 ? b.inset : a.inset,
      );
    }

    return BoxShadow(
      color: Color.lerp(a.color, b.color, t)!,
      offset: Offset.lerp(a.offset, b.offset, t)!,
      blurRadius: ui.lerpDouble(a.blurRadius, b.blurRadius, t)!,
      spreadRadius: ui.lerpDouble(a.spreadRadius, b.spreadRadius, t)!,
      blurStyle: blurStyle,
      inset: b.inset,
    );
  }

  /// Linearly interpolate between two lists of box shadows.
  ///
  /// If the lists differ in length, excess items are lerped with null.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static List<BoxShadow>? lerpList(
    List<BoxShadow>? a,
    List<BoxShadow>? b,
    double t,
  ) {
    if (a == null && b == null) {
      return null;
    }
    a ??= <BoxShadow>[];
    b ??= <BoxShadow>[];
    final int commonLength = math.min(a.length, b.length);
    return <BoxShadow>[
      for (int i = 0; i < commonLength; i += 1) BoxShadow.lerp(a[i], b[i], t)!,
      for (int i = commonLength; i < a.length; i += 1) a[i].scale(1.0 - t),
      for (int i = commonLength; i < b.length; i += 1) b[i].scale(t),
    ];
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is BoxShadow &&
        other.color == color &&
        other.offset == offset &&
        other.blurRadius == blurRadius &&
        other.spreadRadius == spreadRadius &&
        other.blurStyle == blurStyle &&
        other.inset == inset;
  }

  @override
  int get hashCode =>
      Object.hash(color, offset, blurRadius, spreadRadius, blurStyle, inset);

  @override
  String toString() =>
      'BoxShadow($color, $offset, ${debugFormatDouble(blurRadius)}, ${debugFormatDouble(spreadRadius)}), $blurStyle, $inset)';
}

// 用于在两个数字之间进行线性插值，t 的范围是从 0 到 1
// 如果 t 小于 0.5，则在 a 和 0 之间进行插值
// 如果 t 大于或等于 0.5，则在 0 和 b 之间进行插值
double lerpDoubleWithPivot(num? a, num? b, double t) {
  if (t < 0.5) {
    // 如果 t 小于 0.5
    return ui.lerpDouble(a, 0, t * 2)!; // 在 a 和 0 之间进行插值
  }

  return ui.lerpDouble(0, b, (t - 0.5) * 2)!; // 在 0 和 b 之间进行插值
}

// 在两个偏移量之间进行线性插值，t 的范围是从 0 到 1
// 如果 t 小于 0.5，则在 a 和 Offset.zero 之间进行插值
// 如果 t 大于或等于 0.5，则在 Offset.zero 和 b 之间进行插值
Offset lerpOffsetWithPivot(Offset? a, Offset? b, double t) {
  if (t < 0.5) {
    // 如果 t 小于 0.5
    return Offset.lerp(a, Offset.zero, t * 2)!; // 在 a 和 Offset.zero 之间进行插值
  }

  return Offset.lerp(
      Offset.zero, b, (t - 0.5) * 2)!; // 在 Offset.zero 和 b 之间进行插值
}

// 在两个颜色之间进行线性插值，t 的范围是从 0 到 1
// 如果 t 小于 0.5，则在 a 和 a 的不透明度为 0 的颜色之间进行插值
// 如果 t 大于或等于 0.5，则在 b 的不透明度为 0 的颜色和 b 之间进行插值
Color lerpColorWithPivot(Color? a, Color? b, double t) {
  if (t < 0.5) {
    // 如果 t 小于 0.5
    return Color.lerp(
        a, a?.withOpacity(0), t * 2)!; // 在 a 和 a 的不透明度为 0 的颜色之间进行插值
  }

  return Color.lerp(
      b?.withOpacity(0), b, (t - 0.5) * 2)!; // 在 b 的不透明度为 0 的颜色和 b 之间进行插值
}
