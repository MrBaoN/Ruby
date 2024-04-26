


class MyPiece < Piece
  def self.next_piece(board)
    if $var
      MyPiece.new([[0,0]],board)
    else
      MyPiece.new(All_My_Pieces.sample,board)
    end
  end
  # The constant All_My_Pieces should be declared here
  All_My_Pieces = All_Pieces + [rotations([[0, 0] , [0, 1], [-1, 1], [-1, 0], [1,0]]),
                  rotations([[0,0], [-2,0], [-1,0], [1,0], [2,0]]),
                  rotations([[0,0], [1,0], [0,1]])]
  # your enhancements here

end

class MyBoard < Board
  # your enhancements here
  def rotate180
    if !game_over? and @game.is_running?
      @current_block.move(0,0,2)
    end
    draw
  end

  def initialize (game)
    super
    @current_block = MyPiece.next_piece(self)

  end

  def next_piece
    @current_block = MyPiece.next_piece(self)
    if $var
      @score -= 100
      $var = false
    end
    @current_pos = nil

  end

  def store_current
    locations = @current_block.current_rotation
    displacement = @current_block.position

    (0..(locations.size-1)).each{|index|

      current = locations[index];
      @grid[current[1]+displacement[1]][current[0]+displacement[0]] =
      @current_pos[index]
    }
    remove_filled
    @delay = [@delay - 2, 80].max
  end
end

class MyTetris < Tetris
  # your enhancements here
  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 86)
    @board.draw
  end

  def key_bindings
    super
    @root.bind('u', proc {@board.rotate180})
    @root.bind('c', proc {if @board.score > 99 then $var = true end})
  end
end






# ==================================================================================






class MyTetrisChallenge < MyTetris

  def set_board
    @canvas = TetrisCanvas.new
    @display_next = TetrisCanvas.new
    @display_hold = TetrisCanvas.new
    @hold_flag = false
    @board = MyBoardChallenge.new(self, @data)
    @canvas.place(@board.block_size * @board.num_rows,
                  @board.block_size * @board.num_columns + 6, 24, 100)
    @display_next.place(@board.block_size* 6, @board.block_size * 6,195,100)
    @display_hold.place(@board.block_size* 6, @board.block_size * 6, 195, 230)
    @board.draw
  end

  def draw_next (piece, old = nil)
    if old != nil
      old.each{|block| block.remove}
    end
    size = @board.block_size
    blocks = piece.current_rotation
    start = [2,2]
    blocks.map{|block|
    TetrisRect.new(@display_next, start[0]*size + block[0]*size,
                                  start[1]*size + block[1]*size,
                                  start[0]*size + size + block[0]*size,
                                  start[1]*size + size + block[1]*size,
                                  piece.color)}
  end

  def draw_hold (piece, old = nil)
    if old != nil
      old.each{|block| block.remove}
    end

    size = @board.block_size
    blocks = piece.current_rotation
    start = [2,2]
    blocks.map{|block|
    TetrisRect.new(@display_hold, start[0]*size + block[0]*size,
                                  start[1]*size + block[1]*size,
                                  start[0]*size + size + block[0]*size,
                                  start[1]*size + size + block[1]*size,
                                  piece.color)}
  end

  def key_bindings
    super
    @root.bind('r', proc {self.new_game})
    @root.bind('s', proc {@board.lowering})
    @root.bind('Down', proc {@board.lowering})
    @root.bind('e', proc {@board.hold})
    @root.bind('/', proc {@board.hold})
  end

  def buttons
    pause = TetrisButton.new('pause', 'lightcoral'){self.pause}
    pause.place(35, 50, 90, 7)

    new_game = TetrisButton.new('new game', 'lightcoral'){self.new_game}
    new_game.place(35, 75, 15, 7)

    quit = TetrisButton.new('quit', 'lightcoral'){exitProgram}
    quit.place(35, 50, 140, 7)

    move_left = TetrisButton.new('left', 'lightgreen'){@board.move_left}
    move_left.place(35, 50, 27, 571)

    hold = TetrisButton.new('hold', 'lightgreen'){@board.hold}
    hold.place(35, 50, 127, 542)

    move_right = TetrisButton.new('right', 'lightgreen'){@board.move_right}
    move_right.place(35, 50, 127, 571)

    rotate_clock = TetrisButton.new('^_)', 'lightgreen'){@board.rotate_clockwise}
    rotate_clock.place(35,50,77,542)

    accelerate = TetrisButton.new('down', 'lightgreen'){@board.lowering}
    accelerate.place(35, 50, 77, 605)

    drop = TetrisButton.new('drop', 'lightgreen'){@board.drop_all_the_way}
    drop.place(35, 50, 77, 571)

    label = TetrisLabel.new(@root) do
      text 'Current Score: '
      background 'lightblue'
    end

    label.place(35, 100, 33, 65)

    highscorelabel = TetrisLabel.new(@root) do
      text 'High Score: '
      background 'lightblue'
    end

    highscorelabel.place(20, 100, 33, 50)

    next_piece = TetrisLabel.new(@root) do
      text 'Next'
      background 'lightblue'
    end

    next_piece.place(20, 100, 190, 80)

    hold = TetrisLabel.new(@root) do
      text 'Hold'
      background 'lightblue'
    end

    hold.place(20, 100, 190, 210)

    @highscore = TetrisLabel.new(@root) do
      background 'lightblue'
    end
    @highscore.text(@board.highscore)
    @highscore.place(20, 50, 110, 50)

    @score = TetrisLabel.new(@root) do
      background 'lightblue'
    end
    @score.text(@board.score)
    @score.place(35, 50, 120, 65)
  end

  def update_highscore
    @highscore.text(if @board.score > @board.highscore then @board.score else @board.highscore end)
  end

  def run_game
    if !@board.game_over? and @running
      @timer.stop
      @timer.start(@board.delay, (proc{@board.run; run_game}))

    end
    if @board.score >= @board.highscore
      File.write("highscore.txt",@board.score)
    end
  end
end

class MyPieceChallenge < MyPiece

  def base_position= array_position
    @base_position = array_position
  end

  def accelerate
    if @board.score > 1000
      num = 2

    elsif @board.score > 2000
      num = 3

    elsif @board.score > 3000
      num = 4
    else
      num = 1
    end
    @moved = move(0, num, 0)
  end

  def self.next_piece (board)
    MyPieceChallenge.new(All_My_Pieces.sample, board)
  end

end

class MyBoardChallenge < MyBoard

  def num_rows
    29
  end

  def initialize (game, data)
    @grid = Array.new(num_rows) {Array.new(num_columns)}
    @next_block = MyPieceChallenge.next_piece(self)
    @current_block = MyPieceChallenge.next_piece(self)
    @score = 0
    @hold_block = nil
    @hold_flag = false

    if File.exist?("highscore.txt")
      @highscore = File.read("highscore.txt").to_i
    else
      @highscore = 0
    end

    @game = game
    @delay = 500
  end

  def draw_next_piece
    @next_pos = @game.draw_next(@next_block, @next_pos)
  end

  def draw_hold
    @hold_pos = @game.draw_hold(@hold_block, @hold_pos)
  end

  def hold
    if @hold_block == nil and !@hold_flag
      @hold_block = @current_block
      @current_block = @next_block
      @current_pos.each{|block| block.remove}
      @current_block.base_position = [5,0]
      @next_block = MyPieceChallenge.next_piece(self)
      @current_pos = nil
      draw_hold
      draw_next_piece
      draw
      @hold_flag = true

    elsif !@hold_flag
      temp = @current_block
      @current_block = @hold_block
      @current_pos.each{|block| block.remove}
      @current_block.base_position = [5,0]
      @hold_block = temp
      @current_pos = nil
      draw_hold
      draw
      @hold_flag = true

    end
  end

  def next_piece
    @current_block = @next_block
    @next_block = MyPieceChallenge.next_piece(self)
    @current_pos = nil
  end

  def highscore
    @highscore
  end

  def store_current
    super
    @hold_flag = false
  end

  def run
    ran = @current_block.drop_by_one
    if !ran
      store_current
      if !game_over?
        next_piece
      end
    end

    @game.update_score
    @game.update_highscore
    draw_next_piece
    draw
  end

  def remove_filled
    pts_earn = -1
    (2..(@grid.size-1)).each{|num| row = @grid.slice(num);
      # see if this row is full (has no nil)
      if @grid[num].all?
        # remove from canvas blocks in full row
        (0..(num_columns-1)).each{|index|
          @grid[num][index].remove;
          @grid[num][index] = nil
        }
        # move down all rows above and move their blocks on the canvas
        ((@grid.size - num + 1)..(@grid.size)).each{|num2|
          @grid[@grid.size - num2].each{|rect| rect && rect.move(0, block_size)};
          @grid[@grid.size-num2+1] = Array.new(@grid[@grid.size - num2])
        }
        # insert new blank row at top
        @grid[0] = Array.new(num_columns);
        # adjust score for full flow
        pts_earn += 1;
      end}
    self

    if pts_earn > -1
      @score += 100 * (2 ** pts_earn)
    end
  end


  def drop_all_the_way
    if @game.is_running?
      ran = @current_block.drop_by_one
      @current_pos.each{|block| block.remove}
      while ran
        @score += 1
        ran = @current_block.drop_by_one
      end
      draw
      store_current
      if !game_over?
        next_piece
      end
      @game.update_score
      @game.update_highscore
      draw
      draw_next_piece
    end
  end

  def lowering
    if !game_over? and @game.is_running?
      @current_block.move(0,1,0)
      @score += 1
      @game.update_score
      @game.update_highscore
    end
    draw
  end

end
