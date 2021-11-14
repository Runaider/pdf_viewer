import 'dart:io';
import 'package:advance_pdf_viewer/src/zoomable_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';

/// A class to represent PDF page
/// [imgPath], path of the image (pdf page)
/// [num], page number
/// [onZoomChanged], function called when zoom is changed
/// [zoomSteps], number of zoom steps on double tap
/// [minScale] minimum zoom scale
/// [maxScale] maximum zoom scale
/// [panLimit] limit for pan
class PDFPage extends StatefulWidget {
  final String? imgPath;
  final int num;
  final Function(double)? onZoomChanged;
  final int zoomSteps;
  final double minScale;
  final double maxScale;
  final double panLimit;
  final Function? onPageError;
  PDFPage(
    this.imgPath,
    this.num, {
    this.onZoomChanged,
    this.zoomSteps = 3,
    this.minScale = 1.0,
    this.maxScale = 5.0,
    this.panLimit = 1.0,
    this.onPageError,
  });

  @override
  _PDFPageState createState() => _PDFPageState();
}

class _PDFPageState extends State<PDFPage> {
  late ImageProvider provider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _repaint();
  }

  @override
  void didUpdateWidget(PDFPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imgPath != widget.imgPath && oldWidget.imgPath != null) {
      _repaint();
    }
  }

  _repaint() {
    provider = FileImage(File(widget.imgPath!));
    final resolver = provider.resolve(createLocalImageConfiguration(context));
    resolver.addListener(
      ImageStreamListener(
        (imgInfo, alreadyPainted) {
          if (!alreadyPainted) setState(() {});
        },
        onChunk: (a) => {},
        onError: (a, b) {
          print('error');
          widget.onPageError?.call();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: null,
        child: ZoomableWidget(
          onZoomChanged: widget.onZoomChanged,
          zoomSteps: widget.zoomSteps,
          minScale: widget.minScale,
          panLimit: widget.panLimit,
          maxScale: widget.maxScale,
          child: Image(image: provider),
        ));
  }
}
