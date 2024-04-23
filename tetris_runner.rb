require_relative './tetris_base'
require_relative './tetris_enhanced'

def runTetris
  Tetris.new
  mainLoop
end

def runMyTetris
  MyTetris.new
  mainLoop
end

def runMyTetrisChallenge
  MyTetrisChallenge.new
  mainLoop
end

if ARGV.count == 0
  runMyTetris
elsif ARGV.count != 1
  puts "usage: tetris_runner.rb [enhanced | original | challenge]"
elsif ARGV[0] == "enhanced"
  runMyTetris
elsif ARGV[0] == "original"
  runTetris
elsif ARGV[0] == "challenge"
  runMyTetrisChallenge
else
  puts "usage: tetris_runner.rb [enhanced | original | challenge]"
end
