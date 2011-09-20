#!/usr/bin/ruby

class Pyraminx
    attr_accessor :moves

	def initialize
		@faces = Array.new(4)
		@edge_width = 5

		#each face gets a color
		(0...4).each do |i|
			@faces[i] = Array.new((@edge_width*2)-1)
            @faces[i].map! {|space| i}
        end
    end

	def rotate!(pole, level, is_clockwise=true)
		to_rotate = spaces_to_rotate(pole,level)
	   
        #log_debug "to_rotate = #{to_rotate}" 

        num_per_face = to_rotate[0][1].length
       
        (0...num_per_face).each do |i|
            if is_clockwise
                tmp = @faces[0][to_rotate[0][1][i]]
                @faces[to_rotate[0][0]][to_rotate[0][1][i]] = @faces[to_rotate[2][0]][to_rotate[2][1][i]]
                @faces[to_rotate[2][0]][to_rotate[2][1][i]] = @faces[to_rotate[1][0]][to_rotate[1][1][i]]
                @faces[to_rotate[1][0]][to_rotate[1][1][i]] = tmp
            else
                tmp = @faces[0][to_rotate[0][1][i]]
                @faces[to_rotate[0][0]][to_rotate[0][1][i]] = @faces[to_rotate[1][0]][to_rotate[1][1][i]]
                @faces[to_rotate[1][0]][to_rotate[1][1][i]] = @faces[to_rotate[2][0]][to_rotate[2][1][i]]
                @faces[to_rotate[2][0]][to_rotate[2][1][i]] = tmp
            end
        end
	end

    def random_moves!(amount, use_clockwise=false)
        amount.times do 
            self.rotate! rand(4), rand(3), use_clockwise
        end
    end

    #yay using regex to keep spacings...
    def print
        puts ""
    	puts "          [Pole#0]"
		puts "   [Face0]   +  [Face2]"
		puts "    #{@faces[0][4]}#{@faces[0][5]}#{@faces[0][1]}#{@faces[0][2]}#{@faces[0][0]}    #{@faces[1][0]}   #{@faces[2][0]}#{@faces[2][2]}#{@faces[2][3]}#{@faces[2][7]}#{@faces[2][8]}"
		puts "     #{@faces[0][6]}#{@faces[0][7]}#{@faces[0][3]}    #{@faces[1][1]}#{@faces[1][2]}#{@faces[1][3]}   #{@faces[2][1]}#{@faces[2][5]}#{@faces[2][6]}"
		puts "      #{@faces[0][8]}    #{@faces[1][4]}#{@faces[1][5]}#{@faces[1][6]}#{@faces[1][7]}#{@faces[1][8]}   #{@faces[2][4]}"
		puts "          [Face1]"
		puts "[Pole#1]+         +[Pole#2]"
		puts "          [Face3]"
		puts "	   #{@faces[3][8]}#{@faces[3][7]}#{@faces[3][6]}#{@faces[3][5]}#{@faces[3][4]}"
		puts "            #{@faces[3][3]}#{@faces[3][2]}#{@faces[3][1]}"
		puts "             #{@faces[3][0]}"
		puts "             +"
		puts "          [Pole#3]   "
        puts ""
    end

    def solved?
        is_solved = true

        (0...4).each do |i|
            (0...9).each do |j|
                if color != nil
                    is_solved = false if color != @faces[i][j]
                    break
                end
                color = @faces[i][j]
            end
            break unless is_solved
        end

        return is_solved
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
                edges += 3 if @faces[i][k] != i
            end

            #finally centers
            [2,5,7].each do |k|
                centers += 2 if @faces[i][k] != i
            end
        end
        return (tips/12) + (edges/2) + (centers/2)
    end


    def create_clone
        c = Pyraminx.new 
        (0...4).each do |i|
            c.set_face(i, @faces[i])
        end
        return c
    end

    def set_face(face, arr_of_values)
        (0...9).each do |i|
            @faces[face][i] = arr_of_values[i]
        end
    end
private
    def log_debug(msg)
        puts "<DEBUG>"
        puts "  #{msg}"
        puts "</DEBUG>"
    end

	#Using arrays with the indices going to these locations:
	#
	#               [Pole#0]
	#     [Face0]      +       [Face2]
	#   \4/5\1/2\0/   /0\   \0/2\3/7\8/
	#
	#     \6/7\3/   /1\2/3\   \1/5\6/
	#
	#       \8/   /4\5/6\7/8\   \4/
	#               [Face1]
	#[Pole#1]  +              +  [Pole#2]
	#
	#               [Face3]
	#		      \8/7\6/5\4/
	#
	#               \3/2\1/
	#
	#                 \0/
	#                  +
	#               [Pole#3]
	#
	#
	#

	#hardcoded because it'll never change so an alg is
	#	fun but waste of time.
	#All of these are listed in clockwise order.
	def spaces_to_rotate(pole, level)
        #log_debug "when #{( (pole*3) + level )}"
		case( (pole*3) + level )
		when 0  #pole=0, level=0
			[[2,[0]],        [1,[0]],        [0,[0]]]
		when 1  #pole=0, level=1
			[[2,[1,2,3]],    [1,[1,2,3]],    [0,[1,2,3]]]
		when 2  #pole=0, level=2
			[[2,[4,5,6,7,8]],[1,[4,5,6,7,8]],[0,[4,5,6,7,8]]]

		when 3  #pole=1, level=0
			[[0,[8]],        [1,[4]],        [3,[8]]]
		when 4  #pole=1, level=1
			[[0,[6,7,3]],    [1,[1,5,6]],    [3,[6,7,3]]]
		when 5  #pole=1, level=2
			[[0,[4,5,1,2,0]],[1,[0,2,3,7,8]],[3,[4,5,1,2,0]]]

		when 6  #pole=2, level=0
			[[3,[4]],        [1,[8]],        [2,[4]]]
		when 7  #pole=2, level=1
			[[3,[1,5,6]],    [1,[6,7,3]],    [2,[1,5,6]]]
		when 8  #pole=2, level=2
			[[3,[0,2,3,7,8]],[1,[4,5,1,2,0]],[2,[0,2,3,7,8]]]

		when 9  #pole=3, level=0
			[[0,[4]],        [3,[0]],        [2,[8]]]
		when 10 #pole=3, level=1
			[[0,[6,5,1]],    [3,[1,2,3]],    [2,[3,7,6]]]
		when 11 #pole=3, level=2
			[[0,[8,7,3,2,0]],[3,[4,5,6,7,8]],[2,[0,2,1,5,4]]]
		end
	end
end

#puzzle = Pyraminx.new
#puzzle.print
#puzzle.random_moves(5)
#puzzle.print
