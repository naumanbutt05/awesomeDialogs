import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:rive/rive.dart' hide Artboard;
import 'package:rive_native/rive_native.dart' as rive_native;

///RiveRuntimeRender
class RiveAssetAnimation extends StatefulWidget {
  ///Constructor
  const RiveAssetAnimation({
    required this.assetPath,
    required this.animName,
    Key? key,
  }) : super(key: key);

  ///Path of the .riv assets file
  final String assetPath;

  ///Name od the animation to load
  final String animName;

  @override
  State<RiveAssetAnimation> createState() => _RiveAnimationState();
}

class _RiveAnimationState extends State<RiveAssetAnimation> {
  late rive_native.File? file;
  rive_native.Artboard? artboard;
  late rive_native.SingleAnimationPainter _painter;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      file = await rive_native.File.asset(widget.assetPath, riveFactory: rive_native.Factory.flutter);
      _painter = rive_native.SingleAnimationPainter(widget.animName);
      artboard = file?.defaultArtboard();
      loading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const SizedBox.shrink()
        : rive_native.RiveArtboardWidget(artboard: artboard!, painter: _painter);
  }
}
