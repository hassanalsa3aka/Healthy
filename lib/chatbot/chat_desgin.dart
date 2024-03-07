import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';


class DesginChat extends StatelessWidget {
  const DesginChat(
      {super.key,
        required this.msg,
        required this.chatIndex,
        this.shouldAnimate = false});

  final String msg;
  final int chatIndex;
  final bool shouldAnimate;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(

          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: chatIndex == 0
                      ? Text(msg,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16),)
                      : shouldAnimate
                      ? DefaultTextStyle(
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    child: AnimatedTextKit(
                        isRepeatingAnimation: false,
                        repeatForever: false,
                        displayFullTextOnTap: true,
                        totalRepeatCount: 1,
                        animatedTexts: [
                          TyperAnimatedText(
                            msg.trim(),

                          ),
                        ]),
                  )
                      : Text(
                    msg.trim(),
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),

              ],
            ),

          ),
        ),

      ],
    );
  }
}
