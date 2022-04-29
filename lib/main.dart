import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const TicTacToe());
}

class TicTacToe extends StatelessWidget {
  const TicTacToe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const Grid(title: 'Tic Tac Toe'),
    );
  }
}

class Grid extends StatefulWidget {
  const Grid({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Grid> createState() => GridState();
}

class GridState extends State<Grid> {
  static const Map<String, Icon> ICON_MAP = {
    "" : Icon(null),
    "X" : Icon(Icons.clear, color: Colors.orange),
    "O" : Icon(Icons.circle_outlined, color: Colors.orange),
  };

  static int GRID_DIMENSION = 3;

  List<List<String>> _grid = List.generate(GRID_DIMENSION, (i) => List.filled(GRID_DIMENSION, "", growable: false), growable: false);
  bool _xPlayerCurrent = true;
  int _xPlayerWins = 0;
  int _oPlayerWins = 0;
  int _numberOfMoves = 0;
  bool _disabled = false;

  void _handleCellTap(i, j) {
    if (_disabled) {
      return;
    }
    setState(() {
      if (_grid[i][j].isEmpty) {
        _grid[i][j] = _xPlayerCurrent ? "X" : "O";
        _numberOfMoves++;
      } else {
        return;
      }

      final String symbol = _grid[i][j];

      for (var x = 0; x < GRID_DIMENSION; x++) {
        int horizontalCount = 0;
        int verticalCount = 0;
        for (var y = 0; y < GRID_DIMENSION; y++) {
          if (_grid[x][y] == symbol) {
            horizontalCount += 1;
            if (horizontalCount == 3) {
              if (_xPlayerCurrent) {
                _xPlayerWins += 1;
              } else {
                _oPlayerWins += 1;
              }
              _newGame(winningSymbol: symbol);
              return;
            }
          }

          if (_grid[y][x] == symbol) {
            verticalCount += 1;
            if (verticalCount == 3) {
              if (_xPlayerCurrent) {
                _xPlayerWins += 1;
              } else {
                _oPlayerWins += 1;
              }
              _newGame(winningSymbol: symbol);
              return;
            }
          }
        }
      }

      // check diagonal wins
      final bool leftToRightDiagonal = _grid[0][0] == symbol && _grid[1][1] == symbol && _grid[2][2] == symbol;
      final bool rightToLeftDiagonal = _grid[2][0] == symbol && _grid[1][1] == symbol && _grid[0][2] == symbol;
      if (leftToRightDiagonal || rightToLeftDiagonal) {
        if (_xPlayerCurrent) {
          _xPlayerWins += 1;
        } else {
          _oPlayerWins += 1;
        }
        _newGame(winningSymbol: symbol);
        return;
      }

      if (_numberOfMoves == GRID_DIMENSION*GRID_DIMENSION) {
        _newGame(draw: true);
        return;
      }

      _xPlayerCurrent = !_xPlayerCurrent;
    });
  }

  void _newGame({String? winningSymbol, bool? draw}) {
    setState(() {
      _disabled = true;
    });
    if (winningSymbol != null) {
      Fluttertoast.showToast(
          msg: "Player $winningSymbol wins!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 24.0
      );
    }

    if (draw == true) {
      Fluttertoast.showToast(
          msg: "It's a draw!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 24.0
      );
    }

    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _grid = List.generate(GRID_DIMENSION, (i) => List.filled(GRID_DIMENSION, "", growable: false), growable: false);
        _xPlayerCurrent = true;
        _numberOfMoves = 0;
        _disabled = false;
      });
    });
  }

  void _resetGame() {
    setState(() {
      _grid = List.generate(GRID_DIMENSION, (i) => List.filled(GRID_DIMENSION, "", growable: false), growable: false);
      _xPlayerWins = 0;
      _oPlayerWins = 0;
      _xPlayerCurrent = true;
      _disabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        color: Colors.blue.shade50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: const EdgeInsets.all(32.0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      PlayerScoreIndicator(playerSymbol: "X", playerScore: _xPlayerWins, isActivePlayer: _xPlayerCurrent),
                      PlayerScoreIndicator(playerSymbol: "O", playerScore: _oPlayerWins, isActivePlayer: !_xPlayerCurrent)
                    ]
                  )
                ]
              )
            ),
            Container(
              padding: const EdgeInsets.all(32.0),
              child: Table(
                border: TableBorder(
                    verticalInside: BorderSide(width: 8.0, color: Colors.orange.shade100),
                    horizontalInside: BorderSide(width: 8.0, color: Colors.orange.shade100)
                ),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: <TableRow>[
                  TableRow(
                    children: <Widget>[
                      GridCell(x: 0, y: 0, handleTap: _handleCellTap, icon: ICON_MAP[_grid[0][0]]),
                      GridCell(x: 0, y: 1, handleTap: _handleCellTap, icon: ICON_MAP[_grid[0][1]]),
                      GridCell(x: 0, y: 2, handleTap: _handleCellTap, icon: ICON_MAP[_grid[0][2]]),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      GridCell(x: 1, y: 0, handleTap: _handleCellTap, icon: ICON_MAP[_grid[1][0]]),
                      GridCell(x: 1, y: 1, handleTap: _handleCellTap, icon: ICON_MAP[_grid[1][1]]),
                      GridCell(x: 1, y: 2, handleTap: _handleCellTap, icon: ICON_MAP[_grid[1][2]]),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      GridCell(x: 2, y: 0, handleTap: _handleCellTap, icon: ICON_MAP[_grid[2][0]]),
                      GridCell(x: 2, y: 1, handleTap: _handleCellTap, icon: ICON_MAP[_grid[2][1]]),
                      GridCell(x: 2, y: 2, handleTap: _handleCellTap, icon: ICON_MAP[_grid[2][2]]),
                    ],
                  )
                ],
              )
            ),
            GestureDetector(
              onTap: () => {_newGame()},
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  "New Game",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  )
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => {_resetGame()},
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                    "Reset",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    )
                ),
              ),
            )
          ]
        )
      )
    );
  }
}

class PlayerScoreIndicator extends StatelessWidget {
  const PlayerScoreIndicator({Key? key, required this.playerSymbol, required this.playerScore, required this.isActivePlayer}) : super(key: key);

  final String playerSymbol;
  final int playerScore;
  final bool isActivePlayer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(4.0),
          child: Text(
            "Player $playerSymbol",
            style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.orange
            )
          ),
          decoration: isActivePlayer ? BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          ) : null
        ),
        Text(
            "${playerScore}",
            style: const TextStyle(
                fontSize: 24.0,
                color: Colors.grey
            )
        )
      ]
    );
  }
}


class GridCell extends StatelessWidget {
  const GridCell({
    Key? key,
    required this.x,
    required this.y,
    required this.handleTap,
    required this.icon
  }) : super(key: key);

  final int x;
  final int y;
  final Function handleTap;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {handleTap(x, y)},
      child: Container(
        color: Colors.blue.shade50,
        padding: const EdgeInsets.all(32.0),
        child: icon,
      ),
    );
  }
}

