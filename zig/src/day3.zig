const std = @import("std");

const print = std.debug.print;
const mem = std.mem;
const ArrayList = std.ArrayList;
// https://www.huy.rocks/everyday/01-04-2022-zig-strings-in-5-minutes

// https://www.youtube.com/watch?v=VgjRyaRTH6E
// 6:26 explains about slices and arrays

fn get_item_pri(item: u8) u8 {
    // 61 -> a ascii and 41 -> A,
    const t: u8 = if (item > 96) 96 else 38;
    return item - t;
}

// fn qq() !void {
//     return error.MyCustomError;
// }
pub fn main() !void {
    const data = @embedFile("data/day3.example");
    // const data = @embedFile("data/day3");

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    // const allocator = arena.allocator();

    var lines_it = mem.tokenize(u8, data, "\n");

    var part1_prios: u64 = 0;
    var part2PrioritiesSum: u64 = 0;

    // var g_length: u2 = 0;
    // var groups: ?[3]usize = undefined;

    var nGroup: u2 = 0;
    var groupSacks = std.mem.zeroes([3][52]u8);
    // var groupSacks: [3][52]u8 = undefined;

    while (lines_it.next()) |line| {
        // print("line len {} \n", .{line.len});
        // print("line: {s} \n", .{line});
        var comp1 = line[0 .. line.len / 2];
        var comp2 = line[line.len / 2 ..];

        testingo: for (comp1, 0..) |_, i| {
            if (mem.indexOf(u8, comp1, comp2[i .. i + 1])) |idx| {
                part1_prios += get_item_pri(comp1[idx]);
                break :testingo;
            }
        }

        for (line) |val| {
            // Convert letters to integer priorities (0-indexed).
            // a-z is 0-25; A-Z is 26-51.
            var idx: u8 = undefined;
            if (val > 'a') {
                idx = val - 'a';
            } else {
                idx = val - 'A' + 26;
            }

            // print("\ngroupSacks[{}][{}] = {} {} idx:{}  charid {} char {c} \n", .{ nGroup, idx, groupSacks[nGroup][idx], groupSacks[nGroup][idx], idx, val, val });
            groupSacks[nGroup][idx] += 1;
            // print("groupSacks[{}][{}] = {} {} idx:{}  charid {} char {c} \n\n", .{ nGroup, idx, groupSacks[nGroup][idx], groupSacks[nGroup][idx], idx, val, val });
        }

        // Part 2.
        nGroup += 1;
        if (nGroup > 2) {
            // Calculate the badge (common item) in the group's sacks.
            for (groupSacks[0], 0..) |n, i| {
                // print("n: {} i: {} groupSacks[0][{}] = {} \n", .{ n, i, i, n });
                if (n > 0 and groupSacks[1][i] > 0 and groupSacks[2][i] > 0) {
                    // Badge found.
                    part2PrioritiesSum += i + 1;
                }
            }
            // Clear the group's sack memory.
            groupSacks = std.mem.zeroes([3][52]u8);
            nGroup = 0;
        }
        // break;
    }

    print("part1: {} \n", .{part1_prios});
    print("part2: {} \n", .{part2PrioritiesSum});
}

test "some test" {}
