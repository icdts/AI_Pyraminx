class Node
    attr_accessor :obj, :value
    def initialize(obj, value)
        @obj = obj
        @value = value
    end
end

class PriorityQueue
    #fuck I'm so unhappy that I'm writing this fuck
    def initialize
        @tree = Array.new
    end

    def pop
        top_item = @tree.shift
        return top_item.obj
    end

    def push(item, priority)
        node=Node.new(item, priority)
        @tree = @tree.push(node)

        #bubble it up
        current = @tree.length - 1
        parent = (current/2.0).ceil - 1

        while parent >= 0
            if( @tree[current].value < @tree[parent].value )
                tmp = @tree[current]
                @tree[current] = @tree[parent]
                @tree[parent] = tmp

                current = parent
                parent = (current/2.0).ceil - 1
            else
                break
            end
        end
    end

    def bubble_up
        (0...@tree.size).to_a.reverse.each do |i|
            parent = (i/2.0).ceil - 1
            if parent >= 0
                if( @tree[i].value < @tree[parent].value)
                    tmp = @tree[i]
                    @tree[i] = @tree[parent]
                    @tree[parent] = tmp
                end
            end
        end
    end
end

=begin
q = PriorityQueue.new

(1..10).to_a.reverse.each do |i|
    q.push i,i
end

(1..10).each do
    q.bubble_up
    puts q.pop
end
=end
