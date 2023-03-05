const std = @import("std");

const print = std.debug.print;

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var allocator = arena.allocator();

    // const byte: usize = std.math.maxInt(@TypeOf(myval));

    var input = try stdin.readAllAlloc(allocator, 2048 * 2048);
    var it = std.mem.tokenize(u8, input, "\n");

    var lineList = std.ArrayList([]const u8).init(allocator);
    defer lineList.deinit();

    var groupList = std.ArrayList([][]const u8).init(allocator);
    defer groupList.deinit();

    var gLimit: u8 = 2;
    var gCounter: u8 = 0;
    var tt: u32 = 0;

    var gg: [][]const u8 = undefined;
    while (it.next()) |line| : (tt += 1) {
        try lineList.append(line[0..]);
        gCounter += 1;
        if (gCounter > gLimit) {
            // try groupList.append(lineList.items[0..]);
            try groupList.append(lineList.items[lineList.items.len - 3 .. lineList.items.len]);
            gg[tt] = line;
            groupList.clearAndFree();
            gCounter = 0;
        }
    }

    var testingo: u8 = 10;
    _ = testingo;

    // intersting
    // https://github.com/jordanlewis/aoc/blob/main/2022/src/day24.zig

    print("total: {} \n", .{groupList.items.len});
    print("total: {} \n", .{groupList.items.len});

    // print("gitems: {s} \n", .{gItems});
}
