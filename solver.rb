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
    
    def heuristic
        tips = 0
        edges = 0
        centers = 0

        (0...4).each do |i|
            #points easiest to solve
            [0,4,9].each do |k|
                tips+= 1 if @faces[i][k] != i
            end

            #next is edges
            [1,3,6].each do |k|
                edges += 4 if @faces[i][k] != i
            end

            #finally centers
            [2,5,7].each do |k|
                centers += 2 if @faces[i][k] != i
            end
        end
        return (tips + edges + centers)/3
    end
end

class Solver
    attr_accessor :puzzle, :random_moves, :solving_moves
    def initialize(puzzle)
        @puzzle = puzzle
    end
    
    def randomize(k)
        possible_moves = @puzzle.all_possible_clockwise_moves
        old1 = nil
        old2 = nil

        k.times do
            current = possible_moves[rand(possible_moves.length)]

            #prevent backtracking
            while current == old1 and current == old2
                current = possible_moves[rand(possible_moves.length)]
            end

            @random_moves ||= []
            @random_moves << current
            @puzzle.rotate! current[:pole], current[:level]

            old2 = old1
            old1 = current
        end
    end

    def solve
        q = PriorityQueue.new
        @puzzle.moves_to_get_here = []
        loops = 0
        while @puzzle.heuristic != 0
            puts "#{@puzzle.heuristic} - #{@puzzle.moves_to_get_here.length}"
            #puts @puzzle.moves_to_get_here
            generate_children.each do |child|
                q.push child, (child.heuristic + child.moves_to_get_here.length)
            end
            q.bubble_up
            @puzzle = q.pop
            loops += 1

            break if @puzzle.moves_to_get_here.length > @random_moves.length
        end

        return "#{loops}    :    #{@puzzle.moves_to_get_here}"
    end

    def generate_children
        moves_to_make = @puzzle.all_possible_clockwise_moves
        children = Array.new
        count = 0
        moves_to_make.each do |move|
            children.push @puzzle.create_clone
            children[count].rotate! move[:pole], move[:level]
            children[count].moves_to_get_here ||= @puzzle.moves_to_get_here.clone
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
solver = Solver.new(Pyraminx.new)
solver.randomize k

puts "#{k}  : " + solver.solve.to_s + " : \n" + solver.random_moves.to_s
=begin
(4..10).each do |k|
    (0...5).each do
        puzzle = Pyraminx.new
        puzzle.random_moves! k    
        
        puts "#{k}  : " + solve(puzzle).to_s
    end
end
=end
