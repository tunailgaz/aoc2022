const std = @import("std");
const print = std.debug.print;

// const area_size: u16 = 5;
// const data = @embedFile("data/day8.example");

const area_size: u16 = 99;
const data = @embedFile("data/day8");

fn is_biggest_item(item: u8, items: []u8) bool {
    for (items) |i| {
        if (i >= item) {
            return false;
        }
    }
    return true;
}

pub fn main() !void {
    var lines = std.mem.tokenize(u8, data, "\n");

    var col_idx: u32 = 0;
    var edge_count: u32 = 0;
    var interior_count: u32 = 0;

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const ArrayList = std.ArrayList;
    var area: [area_size]ArrayList(u8) = .{ArrayList(u8).init(allocator)} ** area_size;
    // tree_area.deinit();

    while (lines.next()) |line| : (col_idx += 1) {
        const trees = line[0..];
        for (trees, 0..) |tree, i| {
            try area[col_idx].insert(i, tree);
            if ((i == 0 or i == trees.len - 1) or (col_idx == 0 or lines.peek() == null)) {
                edge_count += 1;
            }
        }
    }
    print("edge_count: {}\n", .{edge_count});

    for (area, 0..) |trees, i| {
        for (trees.items, 0..) |tree, j| {
            // not edge cases
            if ((i != 0 and i != area.len - 1) and j != 0 and j != trees.items.len - 1) {
                var top_items = [_]u8{0} ** area_size;
                var bottom_items = [_]u8{0} ** area_size;

                for (0..col_idx) |k| {
                    if (k > i) {
                        bottom_items[k] = area[k].items[j];
                    } else if (k < i) {
                        top_items[k] = area[k].items[j];
                    }
                }

                if (is_biggest_item(tree, trees.items[j + 1 ..]) or
                    is_biggest_item(tree, trees.items[0..j]) or
                    is_biggest_item(tree, &top_items) or
                    is_biggest_item(tree, &bottom_items))
                {
                    interior_count += 1;
                }
            }
        }
    }
    print("interior_count: {}\n", .{interior_count});

    print("part1: {}\n", .{edge_count + interior_count});
}
