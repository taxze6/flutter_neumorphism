import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_neumorphism/inset_box_shadow/lib/box_decoration.dart';
import 'package:flutter_neumorphism/inset_box_shadow/lib/box_shadow.dart';
import 'package:flutter_neumorphism/utils/colors_utils.dart';
import 'package:flutter_neumorphism/widget/shadow_container.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widget/style_list_controller.dart';

enum InsetType { flat, concave, convex, pressed }

enum Direction { topLeft, topRight, bottomLeft, bottomRight }

class NeumorphismPage extends StatefulWidget {
  const NeumorphismPage({Key? key}) : super(key: key);

  @override
  State<NeumorphismPage> createState() => _NeumorphismPageState();
}

class _NeumorphismPageState extends State<NeumorphismPage> {
  Size size = const Size(100, 100);
  double borderRadius = 20;
  double blurRadius = 10.0;
  double spreadRadius = 0.0;
  int intensity = 30;
  InsetType insetType = InsetType.flat;
  Color color = Color(0xff83ccd2);
  Color pickerColor = const Color(0xff443a49);
  Direction direction = Direction.topLeft;
  double distance = 10;
  List<BoxShadow> shadowList = [];
  late Offset darkOffset = Offset(distance, distance);

  late Offset lightOffset = Offset(-distance, -distance);

  void changeColor(Color color) {
    setState(() {
      pickerColor = color;
      this.color = color;
    });
  }

  void copyCode(String content) async {
    try {
      await Clipboard.setData(ClipboardData(text: content));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("复制成功"),
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.amber,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void changeSize(Size data) {
    setState(() {
      size = data;
    });
  }

  void changeInsetType(InsetType iType) {
    setState(() {
      insetType = iType;
    });
  }

  void changeDistance(double data) {
    setState(() {
      distance = data;
    });
  }

  void changeBorderRadius(double data) {
    setState(() {
      borderRadius = data;
    });
  }

  void changeBlurRadius(double data) {
    setState(() {
      blurRadius = data;
    });
  }

  void changeIntensity(double data) {
    setState(() {
      intensity = data.toInt();
    });
  }

  Future<void> _launchUrl(Uri uri) async {
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    String containerCode = '''
    Container(
        width: ${size.width.round()},
        height: ${size.height.round()},
        child: child,
        decoration: BoxDecoration(
          color: $color,
          borderRadius: BorderRadius.circular(${borderRadius.round()}),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ${ColorsUtils.getAdjustColor(color, intensity)},
              ${ColorsUtils.getAdjustColor(color, -intensity)},
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: ${ColorsUtils.getAdjustColor(color, intensity)},
              offset: $darkOffset,
              blurRadius: $blurRadius,
              spreadRadius: 0.0,
              inset: ${insetType == InsetType.pressed},
            ),
            BoxShadow(
              color: ${ColorsUtils.getAdjustColor(color, -intensity)},
              offset: $lightOffset,
              blurRadius: $blurRadius,
              spreadRadius: 0.0,
              inset: ${insetType == InsetType.pressed},
            ),
          ],
        )''';
    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        backgroundColor: color,
        title: const Text("Flutter Neumorphism"),
        actions: [
          IconButton(
            onPressed: () {
              copyCode(containerCode);
            },
            icon: const Icon(Icons.copy_rounded),
          ),
          GestureDetector(
            onTap: () {
              _launchUrl(Uri.parse("https://juejin.cn/user/598591926699358"));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/images/juejin.png",
                width: 32,
              ),
            ),
          ),
        ],
      ),
      body: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return Flex(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            direction: orientation == Orientation.landscape ? Axis.horizontal : Axis.vertical,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    previewBox(),
                    const SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ListTile(
                        leading: const Text(
                          "颜色",
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: InkWell(
                          onTap: () {
                            _openDialog();
                          },
                          child: Container(
                            width: 24.0,
                            height: 24.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color,
                              border: Border.all(
                                color: Colors.white,
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: rowTypeRadio(),
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                            child: columnStyleController())),
                  ],
                ),
              ),
              if(orientation == Orientation.landscape)
              const VerticalDivider(thickness: 2.0),
              if(orientation == Orientation.landscape)
              Container(
                width: 480.0,
                color: color,
                constraints: const BoxConstraints.tightForFinite(),
                child: SingleChildScrollView(
                  child: Text(
                    containerCode,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget shadowContainer() {
    final Color darkColor = ColorsUtils.getAdjustColor(color, intensity);
    final Color lightColor = ColorsUtils.getAdjustColor(color, -intensity);

    switch (direction) {
      case Direction.topLeft:
        darkOffset = Offset(-distance, -distance);
        lightOffset = Offset(distance, distance);
        break;
      case Direction.topRight:
        darkOffset = Offset(distance, -distance);
        lightOffset = Offset(-distance, distance);
        break;
      case Direction.bottomLeft:
        darkOffset = Offset(distance, distance);
        lightOffset = Offset(-distance, -distance);
        break;
      case Direction.bottomRight:
        darkOffset = Offset(-distance, distance);
        lightOffset = Offset(distance, -distance);
        break;
      default:
    }
    shadowList = [
      BoxShadow(
          color: lightColor,
          offset: lightOffset,
          blurRadius: blurRadius,
          spreadRadius: 0.0,
          inset: insetType == InsetType.pressed),
      BoxShadow(
          color: darkColor,
          offset: darkOffset,
          blurRadius: blurRadius,
          spreadRadius: 0.0,
          inset: insetType == InsetType.pressed),
    ];
    return ShadowContainer(
      size: size,
      color: color,
      borderRadius: borderRadius,
      shadowList: shadowList,
      gradient: ColorsUtils.getBackColor(insetType, color, 30),
    );
  }

  Widget previewBox() {
    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      return Stack(
        children: [
          Container(
            width: 400,
            height: 400,
            alignment: Alignment.center,
            child: shadowContainer(),
          ),
          Positioned(
            top: 25.0,
            left: 0,
            child: Transform.rotate(
              angle: -45.0,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    direction = Direction.topLeft;
                  });
                },
                icon: Icon(
                  Icons.light,
                  color: direction == Direction.topLeft
                      ? Colors.amber
                      : Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            top: 25.0,
            right: 0,
            child: Transform.rotate(
              angle: 45.0,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    direction = Direction.topRight;
                  });
                },
                icon: Icon(
                  Icons.light,
                  color: direction == Direction.topRight
                      ? Colors.amber
                      : Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10.0,
            right: 0,
            child: Transform.rotate(
              angle: 90.0,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    direction = Direction.bottomLeft;
                  });
                },
                icon: Icon(
                  Icons.light,
                  color: direction == Direction.bottomLeft
                      ? Colors.amber
                      : Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10.0,
            left: 0,
            child: Transform.rotate(
              angle: -90.0,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    direction = Direction.bottomRight;
                  });
                },
                icon: Icon(
                  Icons.light,
                  color: direction == Direction.bottomRight
                      ? Colors.amber
                      : Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget typeRadio(String text, InsetType type) {
    return Row(
      children: [
        Theme(
          data: ThemeData(unselectedWidgetColor: Colors.white),
          child: Radio<InsetType>(
            value: type,
            groupValue: insetType,
            activeColor: Colors.white,
            onChanged: (v) => changeInsetType(v!),
          ),
        ),
        Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 14.0),
        ),
      ],
    );
  }

  Widget rowTypeRadio() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        typeRadio("扁平", InsetType.flat),
        typeRadio("凸形", InsetType.convex),
        typeRadio("凹形", InsetType.concave),
        typeRadio("嵌入", InsetType.pressed),
      ],
    );
  }

  Widget columnStyleController() {
    return Column(
      children: [
        StyleListController(
          leading: "尺寸",
          min: 100.0,
          max: 300.0,
          value: size.width,
          trailing: size.width.round().toString(),
          onChanged: (v) => changeSize(Size(v, v)),
          lineColor: ColorsUtils.getAdjustColor(color, 30),
        ),
        StyleListController(
          leading: "圆角",
          min: 0.0,
          max: 150.0,
          value: borderRadius,
          trailing: borderRadius.round().toString(),
          onChanged: (v) => changeBorderRadius(v),
          lineColor: ColorsUtils.getAdjustColor(color, 30),
        ),
        StyleListController(
          leading: "模糊",
          min: 0.0,
          max: 100.0,
          value: blurRadius,
          trailing: blurRadius.round().toString(),
          onChanged: (v) => changeBlurRadius(v),
          lineColor: ColorsUtils.getAdjustColor(color, 30),
        ),
        StyleListController(
          leading: "距离",
          min: 1.0,
          max: 50.0,
          value: distance,
          trailing: distance.round().toString(),
          onChanged: (v) => changeDistance(v),
          lineColor: ColorsUtils.getAdjustColor(color, 30),
        ),
        StyleListController(
          leading: "强度",
          min: 1.0,
          max: 50.0,
          value: intensity.toDouble(),
          trailing: intensity.toString(),
          onChanged: (v) => changeIntensity(v),
          lineColor: ColorsUtils.getAdjustColor(color, 30),
        ),
      ],
    );
  }

  void _openDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(10.0),
          title: Text("颜色"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.3,
                  // padding: const EdgeInsets.all(20.0),
                  child: GridView.count(
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    crossAxisCount: 10,
                    children: _buildColorItems(),
                  ),
                ),
                ColorPicker(
                  pickerColor: pickerColor,
                  onColorChanged: changeColor,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Got it'),
              onPressed: () {
                setState(() => color = pickerColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildColorItems() {
    List<Widget> items = [];

    colors.asMap().forEach((key, color) {
      items.add(
        InkWell(
          onTap: () {
            changeColor(color);
            Navigator.pop(context);
          },
          child: Container(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    });

    return items.toList();
  }
}
