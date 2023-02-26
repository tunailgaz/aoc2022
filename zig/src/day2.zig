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

pub fn getScore(p1: rps, p2: rps) u8 {
    // 1 for Rock, 2 for Paper, and 3 for Scissors
    var base_score: u8 = switch (p1) {
        rps.rock => 1,
        rps.paper => 2,
        rps.scissors => 3,
    };

    // 0 if you lost, 3 if the round was a draw, and 6 if you won
    return switch (p1) {
        rps.rock => {
            return switch (p2) {
                rps.rock => base_score + 3,
                rps.paper => base_score + 0,
                rps.scissors => base_score + 6,
            };
        },
        rps.paper => {
            return switch (p2) {
                rps.rock => base_score + 6,
                rps.paper => base_score + 3,
                rps.scissors => base_score,
            };
        },
        rps.scissors => {
            return switch (p2) {
                rps.rock => base_score + 0,
                rps.paper => base_score + 6,
                rps.scissors => base_score + 3,
            };
        },
    };
}

const data = @embedFile("data/day2_p1.txt");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const ptr = try allocator.create(i32);
    print("ptr={*} \n", .{ptr});

    var lines_it = tokenize(u8, data, "\n");

    var player_total_score: u32 = 0;
    while (lines_it.next()) |line| {
        const p1 = try parseRps(line[0]); // them
        const p2 = try parseRps(line[2]); // us

        player_total_score += getScore(p2, p1);
        // print("{s} score: {} \n", .{ line, p2_score });
    }
    print("total: {} \n", .{player_total_score});
}
