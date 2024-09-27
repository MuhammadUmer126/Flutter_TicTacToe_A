import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/constants/my_colors.dart';

class TicTacToe extends StatefulWidget {
  const TicTacToe({super.key});
  @override
  State<TicTacToe> createState() => _TicTacToeState();
}

//Winning Patterns
//012
//345
//678

//036
//147
//258

//048
//246

class _TicTacToeState extends State<TicTacToe> {
  List<String> boxesVal = ["", "", "", "", "", "", "", "", ""];
  bool isXturn = true;
  String status = "";
  bool isGameOver = true;
  List<int> winnerBoxes = [];
  final ConfettiController confettiController = ConfettiController();
  int xScore = 0;
  int yScore = 0;

  Timer? timer;
  static const int maxSconds = 30;
  int seconds = maxSconds;

  void startTimer() {
    status = "";
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        seconds--;
      } else {
        timer?.cancel();
        isGameOver = true;
        status = "Time up";
        seconds = maxSconds;
      }
      setState(() {});
    });
  }

  void declareWinner(int a, int b, int c) {
    status = "${boxesVal[a]} Wins";
    isGameOver = true;
    winnerBoxes.addAll([a, b, c]);
    confettiController.play();
    timer?.cancel();
    if (boxesVal[a] == "X") {
      xScore++;
    } else {
      yScore++;
    }
    Timer.periodic(const Duration(seconds: 5), (timer) {
      confettiController.stop();
    });
  }

  void checkWinners() {
    if (boxesVal[0] != "" &&
        boxesVal[0] == boxesVal[1] &&
        boxesVal[0] == boxesVal[2]) {
      declareWinner(0, 1, 2);
    } else if (boxesVal[3] != "" &&
        boxesVal[3] == boxesVal[4] &&
        boxesVal[3] == boxesVal[5]) {
      declareWinner(3, 4, 5);
    } else if (boxesVal[6] != "" &&
        boxesVal[6] == boxesVal[7] &&
        boxesVal[6] == boxesVal[8]) {
      declareWinner(6, 7, 8);
    } else if (boxesVal[0] != "" &&
        boxesVal[0] == boxesVal[3] &&
        boxesVal[0] == boxesVal[6]) {
      declareWinner(0, 3, 6);
    } else if (boxesVal[1] != "" &&
        boxesVal[1] == boxesVal[4] &&
        boxesVal[1] == boxesVal[7]) {
      declareWinner(1, 4, 7);
    } else if (boxesVal[2] != "" &&
        boxesVal[2] == boxesVal[5] &&
        boxesVal[2] == boxesVal[8]) {
      declareWinner(2, 5, 8);
    } else if (boxesVal[0] != "" &&
        boxesVal[0] == boxesVal[4] &&
        boxesVal[0] == boxesVal[8]) {
      declareWinner(0, 4, 8);
    } else if (boxesVal[2] != "" &&
        boxesVal[2] == boxesVal[4] &&
        boxesVal[2] == boxesVal[6]) {
      declareWinner(2, 4, 6);
    } else if (boxesVal.every((e) => e != "")) {
      status = "Game Drawn";
      isGameOver = true;
      timer?.cancel();
    }
  }

  void onBoxTap(index) {
    if (isGameOver == false) {
      if (boxesVal[index] == "") {
        if (isXturn == true) {
          boxesVal[index] = "X";
        } else {
          boxesVal[index] = "0";
        }
        isXturn = !isXturn;
        checkWinners();
        setState(() {});
      }
    }
  }

  void startGame() {
    seconds = maxSconds;
    startTimer();
    winnerBoxes = [];
    isGameOver = false;
    boxesVal.fillRange(0, 9, "");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AssetColors.primaryColor,
      //Main column
      body: SafeArea(
        child: ConfettiWidget(
          blastDirection: pi / 4,
          gravity: 1,
          blastDirectionality: BlastDirectionality.explosive,
          confettiController: confettiController,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: Column(
              children: [
                //Score Card Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // X Score
                    Column(
                      children: [
                        Text(
                          "Player X",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          xScore.toString(),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    // 0 Score
                    Column(
                      children: [
                        Text(
                          "Player 0",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          yScore.toString(),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                      // X Score
                    ),
                  ],
                ),
                const Spacer(
                  flex: 1,
                ),
                Text(
                  status,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                //Game Board
                SizedBox(
                  height: 480,
                  child: GridView.builder(
                      itemCount: 9,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            onBoxTap(index);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(4),
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: winnerBoxes.contains(index)
                                  ? AssetColors.accentColor
                                  : AssetColors.secondaryColor,
                            ),
                            child: Text(
                              boxesVal[index],
                              style: TextStyle(
                                  fontSize: 80,
                                  color: AssetColors.primaryColor),
                            ),
                          ),
                        );
                      }),
                ),
                const Spacer(
                  flex: 1,
                ),

                //Bottom Section
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Stack(
                    alignment: Alignment.center,
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: 1 - seconds / maxSconds,
                        strokeWidth: 8,
                        valueColor:
                            AlwaysStoppedAnimation(AssetColors.accentColor),
                      ),
                      Center(
                        child: Text(
                          seconds.toString(),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(
                        180,
                        60,
                      ),
                      foregroundColor: AssetColors.primaryColor,
                    ),
                    onPressed: () {
                      startGame();
                    },
                    child: Text(
                      style: const TextStyle(
                        fontSize: 24,
                      ),
                      isGameOver == true ? "Start Game" : "Restart",
                    ),
                  ),
                ),
                const Spacer(
                  flex: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
