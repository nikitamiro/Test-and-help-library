# Nikita Miroshnichenko


class MyNode:
    def __init__(self, data):
        self.data = data
        self.left = None
        self.right = None


def find_depth(node, counter=0):
    """Find the min depth of a binary tree by depth-first search."""
    counter += 1

    if (node.left is None) and (node.right is None):
        return counter

    if (node.left is None) and (node.right is not None):
        return find_depth(node.right, counter)

    elif (node.left is not None) and (node.right is None):
        return find_depth(node.left, counter)

    elif (node.left is not None) and (node.right is not None):
        return min(find_depth(node.left, counter), find_depth(node.right, counter))


def find_depth_new(node):
    """Find the min depth of a binary tree by breadth-first search.
    Runs more efficiently than the find_depth function (depth-first search).
    """
    counter = 1

    if (node.left is None) and (node.right is None):
        return counter

    # Create queue for nodes; go through nodes via breadth-first search
    # Populate queue with tuples; each tuple is (node, node_depth)
    queue = []

    if node.left is not None:
        queue.append((node.left, counter + 1))

    if node.right is not None:
        queue.append((node.right, counter + 1))

    while queue != []:
        
        current_node = queue.pop(0)

        if (current_node[0].left is None) and (current_node[0].right is None):
            return current_node[1]

        if current_node[0].left is not None:
            queue.append((current_node[0].left, current_node[1] + 1))

        if current_node[0].right is not None:
            queue.append((current_node[0].right, current_node[1] + 1))


# Test find_depth and find_depth_new

print("\nTest 1 (root, root.left, root.right, root.left.left, root.left.right, root.right.left, root.right.left.right)")
root = MyNode(1)
root.left = MyNode(2)
root.right = MyNode(3)
root.left.left = MyNode(4)
root.left.right = MyNode(5)
root.right.left = MyNode(6)
root.right.left.right = MyNode(7)
print("find_depth min depth: %d" % find_depth(root))
print("find_depth_new min depth: %d" % find_depth_new(root))

print("\nTest 2 (root, root.left, root.right, root.left.left, root.left.right, root.right.left)")
root = MyNode(1)
root.left = MyNode(2)
root.right = MyNode(3)
root.left.left = MyNode(4)
root.left.right = MyNode(5)
root.right.left = MyNode(6)
print("find_depth min depth: %d" % find_depth(root))
print("find_depth_new min depth: %d" % find_depth_new(root))

print("\nTest 3 (root, root.left, root.left.left, root.left.right)")
root = MyNode(1)
root.left = MyNode(2)
root.left.left = MyNode(4)
root.left.right = MyNode(5)
print("find_depth min depth: %d" % find_depth(root))
print("find_depth_new min depth: %d" % find_depth_new(root))

print("\nTest 4 (root, root.left, root.right, root.left.left)")
root = MyNode(1)
root.left = MyNode(2)
root.right = MyNode(3)
root.left.left = MyNode(4)
print("find_depth min depth: %d" % find_depth(root))
print("find_depth_new min depth: %d" % find_depth_new(root))

print("\nTest 5 (root, root.left, root.left.right)")
root = MyNode(1)
root.left = MyNode(2)
root.left.right = MyNode(5)
print("find_depth min depth: %d" % find_depth(root))
print("find_depth_new min depth: %d" % find_depth_new(root))

print("\nTest 6 (root, root.left, root.right, root.left.right)")
root = MyNode(1)
root.left = MyNode(2)
root.right = MyNode(3)
root.left.right = MyNode(5)
print("find_depth min depth: %d" % find_depth(root))
print("find_depth_new min depth: %d" % find_depth_new(root))
