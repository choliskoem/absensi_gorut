import 'package:absensi/common/my_color.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';


/// Represents Homepage for Navigation
class PdfView extends StatefulWidget {
  final String value ;
  PdfView({Key? key, required this.value,}) : super(key: key);
  @override
  _PdfView createState() => _PdfView();
}

class _PdfView extends State<PdfView> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kegiatan'),
        backgroundColor: MyColor.orange1,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.bookmark,
              color: Colors.white,
              semanticLabel: 'Bookmark',
            ),
            onPressed: () {
              _pdfViewerKey.currentState?.openBookmarkView();
            },
          ),
        ],
      ),
      body: SfPdfViewer.network( widget.value,
        key: _pdfViewerKey,
      ),
    );
  }
}