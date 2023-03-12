const std = @import("std");
const print = std.debug.print;

const data = @embedFile("data/day7.example");

pub fn main() !void {
    // const stdin = std.io.getStdIn().reader();
    // var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    // defer arena.deinit();

    // const allocator = arena.allocator();
    // _ = allocator;

    // var buffer: [1024]u8 = undefined;
    // while (try stdin.readUntilDelimiterOrEof(buffer[0..], '\n')) |line| {
    //     if (line[0] == '$') {
    //         // print("yep \n", .{});
    //     }
    //     // print(" line: '{s}' \n", .{line});
    // }

    var lines_it = std.mem.split(u8, data, "\n");

    // var commands = std.ArrayList([][]const u8);

    print("\n", .{});
    while (lines_it.next()) |line| {
        if (line[0] == '$') {
            // print("yesss", .{});
        }
        print(" line: {s} \n", .{line});
    }
}
