const std = @import("std");

const print = std.debug.print;
const mem = std.mem;

// https://www.huy.rocks/everyday/01-04-2022-zig-strings-in-5-minutes

fn get_item_pri(item: u8) u8 {
    // 61 -> a ascii and 41 -> A,
    const t: u8 = if (item > 96) 96 else 38;
    return item - t;
}

pub fn main() !void {
    const data = @embedFile("data/day3.example");

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    // const allocator = arena.allocator();

    var lines_it = mem.tokenize(u8, data, "\n");

    var part1_prios: u8 = 0;

    while (lines_it.next()) |line| {
        var comp1 = line[0 .. line.len / 2];
        var comp2 = line[line.len / 2 ..];

        for (comp1, 0..) |_, i| {
            if (mem.indexOf(u8, comp1, comp2[i .. i + 1])) |idx| {
                part1_prios += get_item_pri(comp1[idx]);
                break;
            }
        }
    }

    print("part: {} \n", .{part1_prios});
}

test "some test" {}
