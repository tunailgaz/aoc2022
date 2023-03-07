const std = @import("std");

const print = std.debug.print;

pub fn main() !void {
    var str = "2-4";

    var str_it = std.mem.tokenize(u8, str, "-");

    var ptr = str_it.buffer.ptr;
    print("{s} {any} \n", .{ str_it.next().?, ptr.* });

    // print("gitems: {s} \n", .{gItems});
}
