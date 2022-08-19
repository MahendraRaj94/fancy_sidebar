library fancy_sidebar;

import 'package:flutter/material.dart';

import 'body.dart';

class FancySideBar extends StatefulWidget {
  const FancySideBar({Key? key}) : super(key: key);

  @override
  _FancySideBarState createState() => _FancySideBarState();
}

class _FancySideBarState extends State<FancySideBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  double widthRatio = 0.7;

  num minDragStartEdge = 10;
  num maxDragStartEdge = 10;
  bool _canBeDragged = true;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
  }

  void _toggleAnimation() => _animationController.isDismissed
      ? _animationController.forward()
      : _animationController.reverse();
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragStart: _onDragStart,
        onHorizontalDragUpdate: _onDragUpdate,
        onHorizontalDragEnd: _onDragEnd,
        child: SizedBox(
          width: width,
          height: MediaQuery.of(context).size.height,
          child: AnimatedBuilder(
            builder: (BuildContext context, Widget? child) {
              double slide = width * widthRatio * _animationController.value;
              double scale = 1 - (_animationController.value * 0.35);
              return Stack(
                children: [
                  _getDrawer(),
                  _getBodyScreen(slide, scale),
                ],
              );
            },
            animation: _animationController,
          ),
        ),
      ),
    );
  }

  _getBodyScreen(double slide, double scale) {
    return Transform(
      transform: Matrix4.identity()
        ..translate(slide)
        ..scale(scale),
      alignment: const Alignment(-1.0, 0.4),
      child: HomeBody(
        animationController: _animationController,
      ),
    );
  }

  _getDrawer() {
    return Container(
      color: Colors.blue,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          _getToolbar(),
          _getProfileWidget(),
          _getMenuItems(),
        ],
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = _animationController.isDismissed &&
        details.globalPosition.dx < minDragStartEdge;
    bool isDragCloseFromRight = _animationController.isCompleted &&
        details.globalPosition.dx > maxDragStartEdge;
    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta! /
          (MediaQuery.of(context).size.width * widthRatio);
      _animationController.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    if (_animationController.isDismissed || _animationController.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >=
        MediaQuery.of(context).size.width) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;
      _animationController.fling(velocity: visualVelocity);
    } else if (_animationController.value < 0.5) {
      _close();
    } else {
      _open();
    }
  }

  void _close() {
    _animationController.reverse();
  }

  void _open() {
    _animationController.forward();
  }

  _getProfileWidget() => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        child: Row(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const SizedBox(
                        width: 110,
                        height: 110,
                        child: CircularProgressIndicator(
                          value: 0.8,
                          strokeWidth: 2,
                          backgroundColor: Colors.grey,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      Image.asset(
                        "assets/images/dummy/male_1.png",
                        width: 80,
                        height: 80,
                      ),
                    ],
                  ),
                ),
                const Text(
                  "80% Complete",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 0,
              height: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Mahendra ",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "22 yrs old, Youtuber",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );

  _getToolbar() => SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 56,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            IconButton(
              onPressed: _close,
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
            ),
            const Center(
              child: Text(
                "My Profile",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
            )
          ],
        ),
      );

  _getMenuItems() {
    return FittedBox(
      fit: BoxFit.contain,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 32,
            bottom: 16,
            right: 16,
            top: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _getMenuItem(title: "Mood", subTitle: "Feeling 'Angry'"),
              _getMenuItem(
                title: "Invite Others",
              ),
              _getMenuItem(
                title: "Pricing",
              ),
              _getMenuItem(title: "Activity Status", subTitle: "Active'"),
              _getMenuItem(title: "Manage Contacts"),
              _getMenuItem(title: "Settings"),
            ],
          ),
        ),
      ),
    );
  }

  _getMenuItem({String title = "", String subTitle = "", String icon = ""}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.emoji_emotions,
            color: Colors.white,
          ),
          const SizedBox(
            width: 16,
            height: 0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              if ((subTitle ?? "").isNotEmpty)
                Text(
                  subTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}
