# Nikita Miroshnichenko


class StackInputError(Exception):
    def __init_(self):
        super().__init_("Error: push input should be an integer")


class StackEmptyError(Exception):
    def __init_(self):
        super().__init_("Error: stack is empty")


class MyStack:
    def __init__(self):
        self.stack = []
        self.min_stack = []
        self.max_stack = []

    def size(self):
        return len(self.stack)

    def is_empty(self):
        return self.stack == []

    def push(self, value):
        """When a new item is pushed, it's compared to the peeks of the min and max stack.
        If the new item is the new min or max, then it is also pushed onto the min or max stack respectively.
        If the new item is equal to the current min or max, then it is still pushed onto the min or max stack
        respectively.
        """
        if not isinstance(value, int):
            raise StackInputError()
        self.stack.append(value)

        # Update the min and max stack
        if len(self.stack) == 1:
            self.min_stack.append(value)
            self.max_stack.append(value)
        else:
            if value <= self.min_stack[(len(self.min_stack) - 1)]:
                self.min_stack.append(value)
            elif value >= self.max_stack[(len(self.max_stack) - 1)]:
                self.max_stack.append(value)

    def pop(self):
        """When an item is popped, it's compared to the peeks of the min and max stack.
        If the popped item is the current min or max, then it is also popped from the min or max stack respectively.
        """

        if not self.stack:
            raise StackEmptyError()

        popped = self.stack.pop()

        # Update the min and max stack
        if popped == self.min_stack[(len(self.min_stack) - 1)]:
            self.min_stack.pop()
        if popped == self.max_stack[(len(self.max_stack) - 1)]:
            self.max_stack.pop()

        return popped

    def peek(self):
        if not self.stack:
            raise StackEmptyError()
        return self.stack[(len(self.stack) - 1)]

    def flush(self):
        self.stack = []

    def range(self):
        """Returns the stack range (the peeks of the min and max stacks). O(1) runtime.
        This is faster than an O(N) range function that will iteratively look for the min and max of a list.
        """

        if not self.stack:
            raise StackEmptyError()
        return self.min_stack[(len(self.min_stack) - 1)], self.max_stack[(len(self.max_stack) - 1)]
