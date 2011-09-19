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
    end

    def bubble_up
        (0...@tree.size).to_a.reverse.each do |i|
            parent = (i/2).ceil - 1
            if( @tree[i].value < @tree[parent].value)
                tmp = @tree[i]
                @tree[i] = @tree[parent]
                @tree[parent] = tmp
            end
        end
    end
end
