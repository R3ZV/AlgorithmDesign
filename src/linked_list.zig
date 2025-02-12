const std = @import("std");

/// Creates a linked list with values of type T.
/// You have to call .init() to allocate the list.
pub fn LinkedList(comptime T: type) type {
    return struct {
        const Self = @This();

        const Node = struct {
            value: T,
            next: ?*Node,
        };

        alloc: std.mem.Allocator,
        head: ?*Node,
        tail: ?*Node,
        length: usize,

        /// Initiates an empty linked list.
        pub fn init(alloc: std.mem.Allocator) Self {
            return Self{
                .alloc = alloc,
                .head = null,
                .tail = null,
                .length = 0,
            };
        }

        /// Destroyes all the allocated memmory.
        pub fn deinit(self: *Self) void {
            var it = self.head;
            while (it != null) {
                const next = it.?.next;
                self.alloc.destroy(it.?);
                it = next;
            }
        }

        /// Returns the first element in the list (i.e. the head)
        /// If the list doesn't yet have a head it will return null.
        pub fn first(self: *Self) ?T {
            if (self.head == null) {
                return null;
            }
            return self.head.?.value;
        }

        /// Returns the last element in the list (i.e. the tail)
        /// If the list doesn't yet have a tail it will return null.
        pub fn last(self: *Self) ?T {
            if (self.tail == null) {
                return null;
            }
            return self.tail.?.value;
        }

        /// Returns the nth element of the linked list.
        /// The list is 0 based indexed, so nth(0) will return the first
        /// element, nth(1) second and so on.
        ///
        /// If n is greater than length it will return null
        pub fn nth(self: *Self, idx: usize) ?T {
            if (idx >= self.length) return null;

            var i: usize = 0;
            var node = self.head;
            while (node != null) : (node = node.?.next) {
                if (i == idx) {
                    return node.?.value;
                }
                i += 1;
            }
            return null;
        }

        /// Adds a new element to the end of the list.
        /// If the allocation fails add_back() will return an error.
        pub fn add_back(self: *Self, value: T) !void {
            var node = try self.alloc.create(Node);
            node.value = value;
            node.next = null;

            self.length += 1;

            if (self.head == null) {
                self.head = node;
                self.tail = self.head;
                return;
            }

            std.debug.assert(self.tail != null);

            self.tail.?.next = node;
            self.tail = node;
        }

        /// Adds a new element to the end of the list.
        /// If the allocation fails add_back() will return an error.
        pub fn add_front(self: *Self, value: T) !void {
            var node = try self.alloc.create(Node);
            node.value = value;
            node.next = null;

            self.length += 1;

            if (self.head == null) {
                self.head = node;
                self.tail = self.head;
                return;
            }

            std.debug.assert(self.head != null);

            node.next = self.head;
            self.head = node;
        }

        /// Pops the element from the back, nothing hapends
        /// if there is no element in the list.
        pub fn pop(self: *Self) void {
            if (self.length == 0) return;

            if (self.length == 1) {
                self.alloc.destroy(self.tail.?);

                self.head = null;
                self.tail = null;
                self.length -= 1;
                return;
            }

            // 1 -> 2 -> 3 -> 4
            var new_last = self.head;
            std.debug.assert(self.head != null);
            std.debug.assert(self.length - 2 >= 0);

            var i: usize = 2;
            while (i < self.length) : (i += 1) {
                new_last = new_last.?.next;
            }
            std.debug.assert(new_last != null);

            std.debug.assert(self.tail != null);
            self.alloc.destroy(self.tail.?);

            new_last.?.next = null;
            self.tail = new_last;

            self.length -= 1;
        }

        /// Iterates the linked list outputting the value of each node
        pub fn dbg(self: *Self) void {
            var it = self.head;
            while (true) {
                std.debug.print("{} ", .{it.?.value});
                if (it.?.next == null) {
                    break;
                }
                it = it.?.next;
            }
            std.debug.print("\n", .{});
        }
    };
}

test "deinit_empty" {
    const testing = std.testing;
    const alloc = testing.allocator;

    var nums = LinkedList(i32).init(alloc);
    defer nums.deinit();
}

test "adding to the linked list" {
    const testing = std.testing;
    const alloc = testing.allocator;

    var nums = LinkedList(i32).init(alloc);
    defer nums.deinit();

    try testing.expectEqual(null, nums.first());
    try testing.expectEqual(null, nums.last());

    const elems: [5]i32 = .{ 3, 4, 5, 1, 9 };
    for (0..elems.len) |i| {
        try nums.add_back(elems[i]);
    }

    try testing.expectEqual(elems.len, nums.length);

    try testing.expectEqual(3, nums.first());
    try testing.expectEqual(9, nums.last());

    try testing.expectEqual(4, nums.nth(1));
    try testing.expectEqual(5, nums.nth(2));
    try testing.expectEqual(null, nums.nth(5));

    try nums.add_front(56);

    try testing.expectEqual(56, nums.first());
    try testing.expectEqual(56, nums.nth(0));
    try testing.expectEqual(3, nums.nth(1));
}
test "popping from the linked list" {
    const testing = std.testing;
    const alloc = testing.allocator;

    var nums = LinkedList(i32).init(alloc);
    defer nums.deinit();

    nums.pop();

    try nums.add_back(5);
    try testing.expectEqual(1, nums.length);
    try testing.expectEqual(5, nums.first());
    try testing.expectEqual(5, nums.last());

    try nums.add_back(8);
    try testing.expectEqual(2, nums.length);
    try testing.expectEqual(5, nums.first());
    try testing.expectEqual(8, nums.last());

    try nums.add_back(9);
    try testing.expectEqual(3, nums.length);
    try testing.expectEqual(5, nums.first());
    try testing.expectEqual(9, nums.last());

    try nums.add_back(2);
    try testing.expectEqual(4, nums.length);
    try testing.expectEqual(5, nums.first());
    try testing.expectEqual(2, nums.last());

    nums.pop();

    try testing.expectEqual(3, nums.length);
    try testing.expectEqual(5, nums.first());
    try testing.expectEqual(9, nums.last());
    try testing.expectEqual(9, nums.nth(2));
    try testing.expectEqual(null, nums.nth(3));
}

test "popping each time from the linked list" {
    const testing = std.testing;
    const alloc = testing.allocator;

    var nums = LinkedList(i32).init(alloc);
    defer nums.deinit();

    nums.pop();

    try nums.add_back(5);
    nums.pop();

    try nums.add_back(5);
    try nums.add_back(8);
    nums.pop();

    try nums.add_back(8);
    try nums.add_back(9);
    nums.pop();

    try nums.add_back(9);
    try nums.add_back(2);
    nums.pop();
}
