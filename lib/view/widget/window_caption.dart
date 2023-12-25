// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';

import 'package:window_manager/src/widgets/drag_to_move_area.dart';
import 'package:window_manager/src/widgets/window_caption_button.dart';
import 'package:window_manager/src/window_listener.dart';
import 'package:window_manager/src/window_manager.dart';

class SphiaWindowCaption extends StatefulWidget {
  const SphiaWindowCaption({
    super.key,
    this.title,
    this.backgroundColor,
    this.brightness,
  });

  final Widget? title;
  final Color? backgroundColor;
  final Brightness? brightness;

  @override
  State<SphiaWindowCaption> createState() => _SphiaWindowCaptionState();
}

class _SphiaWindowCaptionState extends State<SphiaWindowCaption>
    with WindowListener {
  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ??
            (widget.brightness == Brightness.dark
                ? const Color(0xff1C1C1C)
                : Colors.transparent),
      ),
      child: Stack(
        children: [
          DragToMoveArea(
            child: SizedBox(
              height: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 16),
                    child: DefaultTextStyle(
                      style: TextStyle(
                        color: widget.brightness == Brightness.light
                            ? Colors.black.withOpacity(0.8956)
                            : Colors.white,
                        fontSize: 14,
                      ),
                      child: widget.title ?? Container(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              WindowCaptionButton.minimize(
                brightness: widget.brightness,
                onPressed: () async {
                  bool isMinimized = await windowManager.isMinimized();
                  if (isMinimized) {
                    windowManager.restore();
                  } else {
                    windowManager.minimize();
                  }
                },
              ),
              FutureBuilder<bool>(
                future: windowManager.isMaximized(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.data == true) {
                    return WindowCaptionButton.unmaximize(
                      brightness: widget.brightness,
                      onPressed: () {
                        windowManager.unmaximize();
                      },
                    );
                  }
                  return WindowCaptionButton.maximize(
                    brightness: widget.brightness,
                    onPressed: () {
                      windowManager.maximize();
                    },
                  );
                },
              ),
              WindowCaptionButton.close(
                brightness: widget.brightness,
                onPressed: () {
                  windowManager.close();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void onWindowMaximize() {
    setState(() {});
  }

  @override
  void onWindowUnmaximize() {
    setState(() {});
  }
}
