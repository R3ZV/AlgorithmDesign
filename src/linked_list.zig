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
            while (true) {
                const next = it.?.next;
                if (it != null) {
                    self.alloc.destroy(it.?);
                }
                if (next == null) {
                    break;
                }
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
        /// If the allocation fails add() will return an error.
        pub fn add(self: *Self, value: T) !void {
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

test "simple linked list" {
    const testing = std.testing;
    const alloc = testing.allocator;

    var nums = LinkedList(i32).init(alloc);
    defer nums.deinit();

    try testing.expectEqual(nums.first(), null);
    try testing.expectEqual(nums.last(), null);

    const elems: [5]i32 = .{ 3, 4, 5, 1, 9 };
    for (0..elems.len) |i| {
        try nums.add(elems[i]);
    }

    try testing.expectEqual(3, nums.first());
    try testing.expectEqual(9, nums.last());

    try testing.expectEqual(4, nums.nth(1));
    try testing.expectEqual(5, nums.nth(2));
    try testing.expectEqual(null, nums.nth(5));
}
