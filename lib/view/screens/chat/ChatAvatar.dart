import 'package:flutter/material.dart';

class ChatAvatar extends StatelessWidget {
  final String image;
  final bool user;

  ChatAvatar(this.image, this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            height: 30,
            width: 30,
            child: user
                ? Image.asset(image, height: 25, width: 25)
                : Image.asset(image, height: 25, width: 25, color: Colors.red),
          ),
          !user
              ? Center(
                  child: Container(
                    margin: EdgeInsets.only(right: 3),
                    height: 12,
                    width: 12,
                    child: Image.asset("assets/images/ic_u.png",
                        color: Colors.red),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
