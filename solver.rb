#!/usr/bin/ruby

require "./priority_queue.rb"
require "./pyraminx.rb"

class Pyraminx
    attr_accessor :moves_to_get_here
    def all_possible_clockwise_moves
        return [
            {:pole=>0, :level=>0},
            {:pole=>0, :level=>1},
            {:pole=>1, :level=>0},
            {:pole=>1, :level=>1},
            {:pole=>2, :level=>0},
            {:pole=>2, :level=>1},
            {:pole=>3, :level=>0},
            {:pole=>3, :level=>1},
        ]
    end
    
    def heuristic
        count = 0
        center_count = 0
        triplets = [
            {:tip=>0,:center=>2,:edge=>6},
            {:tip=>4,:center=>5,:edge=>1},
            {:tip=>8,:center=>7,:edge=>3}
        ]

        centers = [2,5,7]

        (0...4).each do |i|
            triplets.each do |trip|
                count += 1 if @faces[i][trip[:tip]] != @faces[i][trip[:center]]
                count += 1 if @faces[i][trip[:edge]] != @faces[i][trip[:center]]
            end

            #check that centers all on same face
            center_count += 1 if @faces[i][2] != @faces[i][5]
            center_count += 1 if @faces[i][5] != @faces[i][7]
        end
        return count/2 + center_count/4
    end
end

class Solver
    attr_accessor :puzzle, :random_moves, :solving_moves, :expanded_nodes
    def initialize(puzzle)
        @puzzle = puzzle
    end
    
    def randomize!(k)
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
            @puzzle.rotate! current[:pole], current[:level], false

            old2 = old1
            old1 = current
        end
    end

    def solve!
        q = PriorityQueue.new
        initial_puzzle = @puzzle
        @puzzle.moves_to_get_here = []
        loops = 0
        cost_limit = 3*@random_moves.length
        lowest_out_of_bound = nil

        while @puzzle.heuristic != 0
            current_cost = @puzzle.heuristic + @puzzle.moves_to_get_here.length
            if current_cost <= cost_limit
                generate_children.each do |child|
                    #puts "child cost: #{(child.heuristic + child.moves_to_get_here.length)}"
                    q.push! child, (child.heuristic + child.moves_to_get_here.length) 
                end
            else
                if lowest_out_of_bound == nil || lowest_out_of_bound > current_cost
                    lowest_out_of_bound = current_cost 
                end
            end
            @puzzle = q.pop!
            
            if @puzzle != nil
                loops += 1
            else
                #ran out of nodes, increase limit, redo
                @puzzle = initial_puzzle
                cost_limit = lowest_out_of_bound
                lowest_out_of_bound = nil
            end
        end

        @solving_moves = @puzzle.moves_to_get_here.clone
        @expanded_nodes = loops
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
puts "k,Loops to solve,Solving Count" #,Random Moves,Solving Moves"
=begin
k = 2 
solver = Solver.new(Pyraminx.new)
solver.randomize k
#solver.puzzle.print
puts "#{k}  : " + solver.solve.to_s + " : \n" + solver.random_moves.length.to_s
#solver.puzzle.print
=end
(4..10).each do |k|
    (0...5).each do
        solver = Solver.new(Pyraminx.new)
        solver.randomize! k
        solver.solve!

        puts "#{k},#{solver.expanded_nodes},#{solver.solving_moves.length}" #\"#{solver.random_moves}\",\"#{solver.solving_moves}\""
    end
end
