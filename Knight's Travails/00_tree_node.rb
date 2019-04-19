require 'byebug'

class PolyTreeNode

    attr_reader :parent, :children, :position

    def initialize(val)
        @parent = nil
        @children = []
        @position = val
    end

    # child_node.parent = parent_node
    def parent=(parent)
        @parent.children.delete(self) if @parent
        if parent.is_a?(PolyTreeNode)
            @parent = parent
            parent.children << self
        else
            @parent = nil
        end
    end

    def inspect
        @position
    end

    def add_child(child_node)
        child_node.parent = self
    end

    def remove_child(child_node)
        raise "Not one of the children" if !@children.include?(child_node)
        child_node.parent = nil
    end

    def dfs(target)
        return self if self.position == target
        self.children.each do |e|
            child = e.dfs(target)
            return child if child
        end
        nil
    end

# DFS
# stack 1 A not returned, check first child (C)
# stack 2 C not returned, check first child (G)
# stack 3 G not returned, no children
# stack 2 child is nil, check C's next child (I)
# stack 3 I is returned (I == I)
# stack 2 return I
# stack 1 return I

# Target = I
#      A
#   C     E   
# G  I   K  M

# BFS
# loop 1 [A] -> [A,C,E] -> [C,E]
# loop 2 [C,E] -> [C,E,G,I] -> [E,G,I]
# loop 3 [E,G,I] -> [E,G,I,K,M] -> [G,I,K,M]
# loop 4 [G,I,K,M] -> [G,I,K,M] -> [I,K,M]
# loop 5 [I,K,M] First is equal to target so return it

    def bfs(target)
        queue = [self]
        until queue.empty?
            return queue.first if queue.first.position == target
            queue += queue.first.children
            queue.shift
        end     
    end
end





