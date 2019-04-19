require_relative '00_tree_node'
require "byebug"

class KnightPathFinder

    attr_reader :start_pos, :root
    def self.valid_moves(pos)
        x = pos[0]
        y = pos[1]
        moves = []

        moves << [x - 1, y - 2]
        moves << [x - 1, y + 2]
        moves << [x + 1, y - 2]
        moves << [x + 1, y + 2]
        moves << [x - 2, y - 1]
        moves << [x - 2, y + 1]
        moves << [x + 2, y - 1]
        moves << [x + 2, y + 1]
        moves.reject { |x,y| x < 0 || y < 0 || x > 7 || y > 7 }
    end

    def initialize(start_pos)
        @start_pos = start_pos
        @considered_pos = [start_pos]
    end

    def new_move_positions(pos)
        positions = KnightPathFinder.valid_moves(pos)
        positions.reject! {|array| @considered_pos.include?(array)}
        @considered_pos += positions
        positions
    end
    
    def build_move_tree #define all relationships
        @root = PolyTreeNode.new(start_pos)
        queue = [@root]
        until queue.empty?
            new_move_positions(queue.first.position).each do |position|
                child = PolyTreeNode.new(position)
                child.parent = queue.first
                queue << child
            end
            queue.shift
        end
    end
#---------------W2 D1 Work
    def find_path(target_pos) #redundant code geez, call build_move_tree first or modify below
        @considered_pos = [@start_pos]
        build_move_tree
        queue = [@root]
        until queue.empty?
            return trace_path_back(queue.first) if queue.first.position == target_pos
            queue.first.children.each do |child|
                queue << child
            end
            queue.shift
        end
    end

    def trace_path_back(target_node)
        arr = [target_node]
        until arr.first.position == @start_pos
           arr.unshift(arr.first.parent) 
        end
        arr
    end
end 


#k = KnightPathFinder.new([0,0])
#p k.new_move_positions([1,2])
#p k.build_move_tree()

kpf2 = KnightPathFinder.new([0, 0])
p kpf2.find_path([7, 6]) # => [[0, 0], [1, 2], [2, 4], [3, 6], [5, 5], [7, 6]]
p kpf2.find_path([6, 2]) # => [[0, 0], [1, 2], [2, 0], [4, 1], [6, 2]]