import 'package:flutter/material.dart';
import 'package:flutter_neumorphism/flutter_neumorphism.dart';

final List<Color> colors = [
  const Color(0xffefeeee),
  const Color(0xff333333),
  const Color(0xff4caf50),
  const Color(0xff9c27b0),
  const Color(0xff5758BB),
  const Color(0xff955539),
  const Color(0xff292d32),
  const Color(0xff6F1E51),
  const Color(0xffED4C67),
  const Color(0xffC4E538),
  const Color(0xff9980FA),
  const Color(0xffecf0f3),
  const Color(0xffE96831),
  const Color(0xff48c0a3),
  const Color(0xffD1667C),
  const Color(0xff71A89C),
  const Color(0xff296A73),
  const Color(0xffa69abd),
  const Color(0xffe198b4),
  const Color(0xffcd5e3c),
  const Color(0xff89c3eb),
  const Color(0xff0eb83a),
  const Color(0xff392f41),
  const Color(0xff21a675),
  const Color(0xff83ccd2),
];

class ColorsUtils {
  static Color getInverseColor(Color color) {
    // 计算相反的颜色值
    Color inverseColor = Color.fromRGBO(
      255 - color.red,
      255 - color.green,
      255 - color.blue,
      color.opacity,
    );

    return inverseColor;
  }

  static List<Color> getShadowColorList(Color color) {
    Color baseColor = color; // 按钮的基础颜色
    Color highlightColor = Color.alphaBlend(
      Colors.white.withOpacity(0.5),
      baseColor,
    ); // 计算顶部阴影颜色
    Color shadowColor = Color.alphaBlend(
      Colors.black.withOpacity(0.5),
      baseColor,
    ); // 计算底部阴影颜色
    return [highlightColor, shadowColor];
  }

  static LinearGradient getBackColor(
      InsetType insetType, Color color, int depth) {
    if (insetType == InsetType.flat || insetType == InsetType.pressed) {
      return LinearGradient(
        colors: [
          getAdjustColor(color, -depth),
          getAdjustColor(color, depth),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (insetType == InsetType.concave) {
      return LinearGradient(
        colors: [
          getAdjustColor(color, -depth),
          getAdjustColor(color, depth),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomRight,
      );
    } else if (insetType == InsetType.convex) {
      return LinearGradient(
        colors: [
          getAdjustColor(color, depth),
          getAdjustColor(color, -depth),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomRight,
      );
    } else {
      return LinearGradient(
        colors: [color, color],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
  }
  // 定义静态函数 getAdjustColor，接收基础颜色 baseColor 和需要调整的颜色量 amount
  static Color getAdjustColor(Color baseColor, int amount) {
    // 将 baseColor 的 red、green、blue 分量存储在一个 Map 对象 colors 中
    Map colors = {
      "red": baseColor.red,
      "green": baseColor.green,
      "blue": baseColor.blue
    };

    // 使用 map 函数对 colors 中的每一个键值对进行处理
    colors = colors.map((key, value) {
      // 如果 value + amount < 0，则将当前分量设为 0
      if (value + amount < 0) return MapEntry(key, 0);
      // 如果 value + amount > 255，则将当前分量设为 255
      if (value + amount > 255) return MapEntry(key, 255);
      // 否则，将当前分量设为 value + amount
      return MapEntry(key, value + amount);
    });

    // 返回根据调整后的 red、green、blue 分量创建的颜色对象
    return Color.fromRGBO(colors["red"], colors["green"], colors["blue"], 1);
  }

}
