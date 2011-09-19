#!/usr/bin/ruby

require "./priority_queue.rb"
require "./pyraminx.rb"

def solve(puzzle)
    q = PriorityQueue.new
    moves = 0
    puzzle.moves = 0

    while puzzle.heuristic != 0
        puts "#{puzzle.heuristic} - #{puzzle.moves} - #{puzzle.heuristic + moves}"
        puzzle.generate_children.each do |child|
            q.push child, (child.heuristic + child.moves)
        end
        q.bubble_up
        puzzle = q.pop
        moves += 1
    end

    return "#{moves}    :    #{puzzle.moves}"
end

puts "------------------------------------"
puts "k  : Loops to solve : Moves to solve"
puts "------------------------------------"
k = 4 
puzzle = Pyraminx.new
puzzle.random_moves! k    

puzzle.print
puts "#{k}  : " + solve(puzzle).to_s
=begin
(4..10).each do |k|
    (0...5).each do
        puzzle = Pyraminx.new
        puzzle.random_moves! k    
        
        puts "#{k}  : " + solve(puzzle).to_s
    end
end
=end
