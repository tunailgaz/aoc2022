const std = @import("std");

const print = std.debug.print;

pub fn main() !void {
    print("hello \n", .{});
}

test "some test" {
    print("print some test \n", .{});
}
