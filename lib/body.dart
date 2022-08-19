import 'package:flutter/material.dart';

class HomeBody extends StatelessWidget {
  final AnimationController animationController;
  const HomeBody({Key? key, required this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          animationController.isDismissed ? Colors.white : Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(animationController.isDismissed ? 0 : 50),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 90, blurStyle: BlurStyle.inner,
              offset: const Offset(-40, 0), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            _getBodyToolbar(context),
          ],
        ),
      ),
    );
  }

  _getBodyToolbar(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 56,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          InkWell(
            onTap: () {
              if (animationController.isDismissed) {
                _open();
              } else if (animationController.isCompleted) {
                _close();
              }
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(
                Icons.menu,
                color: Colors.black,
              ),
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
          ),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                if (animationController.isDismissed) {
                  _open();
                } else if (animationController.isCompleted) {
                  _close();
                }
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(
                  Icons.notifications_outlined,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _close() {
    animationController.reverse();
  }

  void _open() {
    animationController.forward();
  }
}
