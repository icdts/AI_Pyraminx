#!/usr/bin/ruby

require "./priority_queue.rb"
require "./pyraminx.rb"

class Pyraminx
    attr_accessor :moves_to_get_here
    def all_possible_clockwise_moves
        return [
            {:pole=>0, :level=>0},
            {:pole=>0, :level=>1},
            {:pole=>0, :level=>2},
            {:pole=>1, :level=>0},
            {:pole=>1, :level=>1},
            {:pole=>1, :level=>2},
            {:pole=>2, :level=>0},
            {:pole=>2, :level=>1},
            {:pole=>2, :level=>2},
            {:pole=>3, :level=>0},
            {:pole=>3, :level=>1},
            {:pole=>3, :level=>2},
        ]
    end
end

class Solver
    attr_accessor :puzzle, :random_moves, :solving_moves
    def initialize(puzzle)
        @puzzle = puzzle
    end
    
    def randomize(k)
        @random_moves = @puzzle.random_moves! k
    end

    def solve
        q = PriorityQueue.new
        moves = 0
        puzzle.moves = 0

        while puzzle.heuristic != 0
            puts "#{puzzle.heuristic} - #{puzzle.moves_to_get_here.length} - #{puzzle.heuristic + moves}"
            generate_children.each do |child|
                q.push child, (child.heuristic + child.moves)
            end
            q.bubble_up
            puzzle = q.pop
            moves += 1
        end

        return "#{moves}    :    #{puzzle.moves}"
    end

    def generate_children
        moves_to_make = @puzzle.all_possible_clockwise_moves
        children = Array.new
        count = 0
        moves_to_make.each do |move|
            children.push self.create_clone
            children[count].rotate! move[:pole], move[:level]
            children[count].moves_to_get_here ||= []
            children[count].moves_to_get_here << move
            count += 1
        end

        return children
    end
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
