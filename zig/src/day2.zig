const std = @import("std");

const ArrayList = std.ArrayList;
const tokenize = std.mem.tokenize;
const parseInt = std.fmt.parseInt;
const print = std.debug.print;

const rps = enum(u8) {
    rock,
    paper,
    scissors,
    pub fn str(self: rps) []const u8 {
        return switch (self) {
            rps.rock => "rock",
            rps.paper => "paper",
            rps.scissors => "scissors",
        };
    }
};

pub fn parseRps(in: u8) !rps {
    return switch (in) {
        'A', 'X' => rps.rock,
        'B', 'Y' => rps.paper,
        'C', 'Z' => rps.scissors,
        else => unreachable,
    };
}

// 0 if loss, 3 if draw, 6 if won
var rpsScores: [3][3]u8 = .{ .{ 3, 0, 6 }, .{ 6, 3, 0 }, .{ 0, 6, 3 } };

// map that gives you the rps you need to play to lose/draw/win the first rps.
// rps -> lose/draw/win -> rps
var rpsKey: [3][3]rps = .{
    .{ rps.scissors, rps.rock, rps.paper },
    .{ rps.rock, rps.paper, rps.scissors },
    .{ rps.paper, rps.scissors, rps.rock },
};

pub fn evalRps(l: rps, r: rps) u8 {
    const i = @enumToInt(l);
    const j = @enumToInt(r);
    return rpsScores[i][j];
}

// Rock > Scissors
// Scissors > Paper
// Paper > Rock

const data = @embedFile("data/day2.txt");
// const data = @embedFile("data/day2.example");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const ptr = try allocator.create(i32);
    print("ptr={*} \n", .{ptr});

    var lines_it = tokenize(u8, data, "\n");

    var part1: u32 = 0;
    var part2: u32 = 0;

    var rounds: u32 = 0;
    while (lines_it.next()) |line| {
        rounds += 1;

        const p1 = try parseRps(line[0]); // them
        const p2 = try parseRps(line[2]); // us

        const score = evalRps(p2, p1);
        const total = @enumToInt(p2) + 1 + score;

        part1 += total;

        const shouldPlay = rpsKey[@enumToInt(p1)][@enumToInt(p2)];

        part2 += @enumToInt(shouldPlay) + 1 + (@enumToInt(p2) * 3);
    }
    print("part1: {} \n", .{part1});
    print("part2: {} \n", .{part2});
}
