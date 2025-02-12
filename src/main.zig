const std = @import("std");
const LinkedList = @import("linked_list.zig").LinkedList;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();

    var nums = LinkedList(i32).init(alloc);
    defer nums.deinit();

    const elems: [5]i32 = .{ 3, 4, 5, 1, 9 };
    for (0..elems.len) |i| {
        try nums.add(elems[i]);
    }

    nums.dbg();
}

test {
    _ = @import("linked_list.zig");
}
