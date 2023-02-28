const std = @import("std");

const print = std.debug.print;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    // const byte: usize = std.math.maxInt(@TypeOf(myval));

    const data = @embedFile("data/day3.example");

    var it = std.mem.split(u8, data, "\n");

    var lineList = std.ArrayList([]const u8).init(allocator);
    defer lineList.deinit();

    var groupList = std.ArrayList([][]const u8).init(allocator);
    defer groupList.deinit();

    var gLimit: u8 = 2;
    var gCounter: u8 = 0;
    while (it.next()) |line| {
        try lineList.append(line[0..]);
        gCounter += 1;
        if (gCounter > gLimit) {
            try groupList.append(lineList.items[lineList.items.len - 3 .. lineList.items.len]);
            gCounter = 0;
        }
    }

    for (groupList.items) |gItems| {
        print("gitems: {s} \n", .{gItems});
    }
}
