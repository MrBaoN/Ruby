# Tetris game 

![Demonstration gif of the tetris game](./tetris.gif)

This project was created with intentions to learn more about advanced Object-Oriented Programming principles: 
- Dynamic dispatch
- Inheritance
- Composition
- Class Hierarchy

`tetris_base` is implemented with minimal feature to demonstrate effects of **Class Hierarchy** and **Inheritance**.

`tetris_enhanced` contains two subclass: `My_Class` and `My_Challenge_Class` where `My_Challenge_Class` < `My_Class` < `Base class`. This is done to show the **inheritance** as well as **dynamic dispatch** interaction between class.

`tetris_graphic` contains all the necessary graphic in order to run the game

`tetris_runner` is the bridge to run 3 different tetris game, from 3 different classes.

In order to run the game, type the command below in the terminal, substituting _tetris_type_ with either `original`, `enhanced`, or `challenge`
```
 ruby tetris_runner tetris_type
```

Control:
- From base class:
  - `wasd` or `arrow key`
  - `spacebar`- drop block
- From enhanced class:
  - `u` - rotate 180
- From challenge class:
  - `e` or `/` - hold block
  - `q` - quit game
  - `p` - pause
  - `r` or `n` - new game
