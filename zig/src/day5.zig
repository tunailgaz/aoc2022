const std = @import("std");
const print = std.debug.print;
const mem = std.mem;

const Stack = struct { crates: std.ArrayList };

fn parseCrates(crates: []const u8) !u32 {
    var it = mem.tokenize(u8, crates, "\n");
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    var list: [10]std.ArrayList(u8) = .{std.ArrayList(u8).init(allocator)} ** 10;
    // var bus1: [9]std.ArrayList(u8) = .{std.ArrayList(u8).init(allocator)} ** 9;
    // var stacks: []std.ArrayList = undefined;

    var j: u8 = 0;
    while (it.next()) |crate| {
        list[j] = std.ArrayList(u8).init(allocator);
        if (std.mem.containsAtLeast(u8, crate, 1, "[")) {
            print("\ncrate: {s}\n", .{crate});

            var pos: u8 = 1;
            var i: u8 = 0;
            for (crate[0..], 0..) |_, idx| {
                i += 1;
                if (!mem.eql(u8, crate[idx .. idx + 1], " ") and !mem.eql(u8, crate[idx .. idx + 1], "[") and !mem.eql(u8, crate[idx .. idx + 1], "]")) {
                    // _ = idx;

                    try list[j].insert(0, crate[idx]);
                    print(" [{}]{} -> {c} ", .{ pos, idx, crate[idx] });
                }
                if (i > 3) {
                    pos += 1;
                    i = 0;
                }
            }

            // print(" {s} {s} {s} \n", .{ crate[1..2], crate[4..5], crate[7..8] });
            // var cargo_it = mem.tokenize(u8, crate, "[]");
            // var cargo_idx: u8 = 0;
            // while (cargo_it.next()) |cargo| {
            //     cargo_idx += 1;
            //     if (cargo.len == 1 and !mem.eql(u8, cargo, " ")) {
            //         print("\ncargo: '{s}' {} | all '{s}' ", .{ cargo, (cargo_idx), cargo });
            //     }
            // }

            print("\n", .{});
        } else {
            print("end of story\n", .{});
        }
        print("list[{}]: {s}\n", .{ j, list[j].items });
        j += 1;
        // var cargo_it = mem.tokenize(u8, crate, "[ ]");

        // // var cargo_idx: u8 = 0;
        // while (cargo_it.next()) |cargo| {
        //     print(" {s} ", .{cargo});
        // }
    }

    return 3;
}

pub fn main() !void {
    const data = @embedFile("data/day5.example");

    var lines_it = mem.split(u8, data, "\n\n");

    var crates_it = mem.tokenize(u8, lines_it.next().?, "\n");
    // var moves = mem.tokenize(u8, lines_it.next().?, "\n");

    // _ = moves;
    // print("crates len:{}\n", .{crates.});
    const crates = try parseCrates(crates_it.rest());
    _ = crates;

    // print("\n-----------\n", .{});
    // while (moves.next()) |move| {
    //     print("move: {s}\n", .{move});
    // }
}
