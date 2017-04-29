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

    def size(self):
        return len(self.stack)

    def is_empty(self):
        return self.stack == []

    def push(self, value):
        if not isinstance(value, int):
            raise StackInputError()
        self.stack.append(value)

    def pop(self):
        if not self.stack:
            raise StackEmptyError()
        return self.stack.pop()

    def peek(self):
        if not self.stack:
            raise StackEmptyError()
        return self.stack[(len(self.stack) - 1)]

    def flush(self):
        self.stack = []

    def range_pair_comparison(self):
        """Returns the stack range in practical 3N/2 time, O(N).
        Runs through the stack 2 elements at a time and does 3 comparisons on each iteration.
        On each iteration compares the min and max of the current 2 elements to the stack min and max.
        """

        if not self.stack:
            raise StackEmptyError()
        # If stack has odd number of elements, then set [0] to min and max.
        elif len(self.stack) % 2 != 0:
            index_start = 1
            range_max = self.stack[0]
            range_min = self.stack[0]
        # If stack has even number of elements, then compare [0] and [1], and set to min or max respectively.
        else:
            index_start = 2
            if self.stack[0] == self.stack[1]:
                range_max = self.stack[0]
                range_min = self.stack[0]
            elif self.stack[0] < self.stack[1]:
                range_max = self.stack[1]
                range_min = self.stack[0]
            else:
                range_max = self.stack[0]
                range_min = self.stack[1]

        # Select 2 elements at time. Create a tuple (min, max) for the pair.
        # Compare the tuple's min and max to the stack's min and max, and update the stack range.
        for i in range(index_start, len(self.stack), 2):
            if self.stack[i] >= self.stack[i + 1]:
                local_range = (self.stack[i + 1], self.stack[i])
            else:
                local_range = (self.stack[i], self.stack[i + 1])

            if local_range[1] > range_max:
                range_max = local_range[1]

            if local_range[0] < range_min:
                range_min = local_range[0]

        return range_min, range_max

    def range_built_in(self):
        """Returns the stack range using built-in min and max methods from Python.
        """
        if not self.stack:
            raise StackEmptyError()
        return min(self.stack), max(self.stack)

    def range_simple(self):
        """Returns the stack range in O(N).
        Runs through the stack 1 element at a time and does 2 comparisons on each iteration.
        """

        if not self.stack:
            raise StackEmptyError()
        range_min = self.stack[0]
        range_max = self.stack[0]
        for i in self.stack:
            if range_min > i:
                range_min = i
            if range_max < i:
                range_max = i
        return range_min, range_max
