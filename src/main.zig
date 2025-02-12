const std = @import("std");
const LinkedList = @import("linked_list.zig").LinkedList;

pub fn main() !void {
    // var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    // const alloc = gpa.allocator();

    // var nums = LinkedList(u32).init(alloc);
    // defer nums.deinit();

    const N = 8 * 4096;
    var nums: [N]u32 = undefined;
    for (0..N) |i| {
        nums[i] = @intCast(i);
    }

    var sum: u64 = 0;
    for (0..N) |i| {
        sum += nums[i];
    }

    // for (0..N) |i| {
    //     try nums.add_back(@intCast(i));
    // }

    // var sum: u64 = 0;
    // var node = nums.head;
    // while (node != null) {
    //     sum += node.?.value;
    //     node = node.?.next;
    // }

    // nums.dbg();
}

test {
    _ = @import("linked_list.zig");
}
