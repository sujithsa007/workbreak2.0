import 'dart:math';

class RandomMessage {
  static String getARandomMessage() {
    List workMessages = [
      'Time to take a break',
      'Lets stretch those muscles a bit',
      'Give your eyes some rest',
      'Take a brisk walk to freshen up',
      'Step out to catch some fresh air',
      'Get some coffee',
      'Time to stretch',
      'Time to take your eyes of that bright monitor',
      'Cool down your brain, it needs a break',
      'I know work is important, but so are you. Take a break'
    ];
    int randomIndex = Random().nextInt(workMessages.length);
    return workMessages[randomIndex];
  }
}
