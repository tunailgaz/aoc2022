const std = @import("std");
const print = std.debug.print;

// const area_size: u16 = 5;
// const data = @embedFile("data/day8.example");

const area_size: u16 = 99;
const data = @embedFile("data/day8");

fn check_right_side(item: u8, right_items: []u8) bool {
    for (right_items) |r| {
        if (r >= item) {
            return false;
        }
    }
    // std.debug.print("right", .{});
    // std.debug.print("right {c} >= {s}", .{ item, right_items });
    return true;
}

fn check_left_side(item: u8, left_items: []u8) bool {
    for (left_items) |l| {
        if (l >= item) {
            return false;
        }
    }
    // std.debug.print("left", .{});
    return true;
}

fn check_bottom_side(item: u8, bottom_items: []u8) bool {
    for (bottom_items) |b| {
        if (b >= item) {
            return false;
        }
    }
    // std.debug.print("bottom", .{});
    return true;
}

fn chech_top_side(item: u8, top_items: []u8) bool {
    // print("top_items: {s}", .{top_items});
    for (top_items) |t| {
        if (t >= item) {
            return false;
        }
    }
    // std.debug.print("top", .{});
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

    for (area, 0..) |trees, i| {
        for (trees.items, 0..) |tree, j| {
            // not edge cases
            if ((i != 0 and i != area.len - 1) and j != 0 and j != trees.items.len - 1) {
                // std.debug.print("edge: {c}", .{tree});

                var top_items = [_]u8{0} ** area_size;
                var bottom_items = [_]u8{0} ** area_size;

                for (0..col_idx) |k| {
                    if (k > i) {
                        bottom_items[k] = area[k].items[j];
                    } else if (k < i) {
                        top_items[k] = area[k].items[j];
                    }
                }

                if (check_right_side(tree, trees.items[j + 1 ..]) or
                    check_left_side(tree, trees.items[0..j]) or
                    chech_top_side(tree, &top_items) or
                    check_bottom_side(tree, &bottom_items))
                {
                    interior_count += 1;
                }
            }
            print("\n", .{});
        }
    }
    print("edge_count: {}\n", .{edge_count});
    print("interior_count: {}\n", .{interior_count});

    print("part1: {}\n", .{edge_count + interior_count});
}
