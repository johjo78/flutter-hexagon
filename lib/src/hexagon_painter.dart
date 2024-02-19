import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'hexagon_path_builder.dart';

/// This class is responsible for painting HexagonWidget color and shadow in proper shape.
class HexagonPainter extends CustomPainter {
  HexagonPainter(this.pathBuilder, {this.color, this.elevation = 0, this.relief=false});

  final HexagonPathBuilder pathBuilder;
  final double elevation;
  final bool relief;
  final Color? color;

  final Paint _paint = Paint();
  Path? _path;




  @override
  void paint(Canvas canvas, Size size) {

    final Paint topP = Paint();
    topP.color = Colors.white60;
    topP.strokeWidth = 5;
    topP.style =  PaintingStyle.stroke;

    topP.blendMode=BlendMode.srcIn;

    final Paint shadowP = Paint();
    shadowP.color = Colors.black45;
    shadowP.strokeWidth = 5;
    shadowP.style =  PaintingStyle.stroke;
    shadowP.blendMode = BlendMode.colorBurn ;
    shadowP.maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    final Paint highP = Paint();
    highP.color = Colors.white70;
    highP.strokeWidth = 5;
    highP.style =  PaintingStyle.stroke;
    highP.blendMode = BlendMode.lighten;
    highP.maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);


    final translateM1 = Float64List.fromList([1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 3, 3, 0, 1]);
    final translateM2 = Float64List.fromList([1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, -3, -3, 0, 1]);

    _paint.color = color ?? Colors.white;
    _paint.isAntiAlias = true;
    _paint.style = PaintingStyle.fill;
    Path path = pathBuilder.build(size);
    _path = path;

    if ((elevation) > 0)
      canvas.drawShadow(path, Colors.black, elevation, false);
    canvas.drawPath(path, _paint);

    if(relief) {

      Path hPath = Path.from(path.transform(translateM2));
      canvas.drawPath(hPath, highP);

      Path sPath = Path.from(path.transform(translateM1));
      canvas.drawPath(sPath, shadowP);


      canvas.drawPath(path, topP);
    }

  }

  @override
  bool hitTest(Offset position) {
    return _path?.contains(position) ?? false;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is HexagonPainter &&
              runtimeType == other.runtimeType &&
              pathBuilder == other.pathBuilder &&
              elevation == other.elevation &&
              color == other.color;

  @override
  int get hashCode =>
      pathBuilder.hashCode ^ elevation.hashCode ^ color.hashCode;
}
