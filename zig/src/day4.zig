const std = @import("std");
const print = std.debug.print;
const mem = std.mem;
const fmt = std.fmt;

const Section = struct { start: u32, end: u32 };
const Pair = struct { first: Section, second: Section };

// 2-4
fn parseSection(section_str: []const u8) !Section {
    var ids_it = mem.tokenize(u8, section_str[0..], "-");
    return .{ .start = try fmt.parseInt(u32, ids_it.next().?, 10), .end = try fmt.parseInt(u32, ids_it.next().?, 10) };
}

// 2-4,6-8
fn parsePair(line: []const u8) !Pair {
    var sections_it = mem.tokenize(u8, line, ",");
    return .{ .first = try parseSection(sections_it.next().?), .second = try parseSection(sections_it.next().?) };
}

fn fullyContains(pair: Pair) u1 {
    if ((pair.second.start >= pair.first.start and pair.second.start <= pair.first.end and
        pair.second.end >= pair.first.start and pair.second.end <= pair.first.end) or
        (pair.first.start >= pair.second.start and pair.first.start <= pair.second.end and
        pair.first.end >= pair.second.start and pair.first.end <= pair.second.end))
    {
        // print("pair: {any} \n", .{pair});
        return 1;
    }
    return 0;
}

fn isOverlap(pair: Pair) u1 {
    if ((pair.first.start >= pair.second.start and pair.first.start <= pair.second.end) or
        (pair.first.end >= pair.second.start and pair.first.end <= pair.second.end) or
        (pair.second.start >= pair.first.start and pair.second.start <= pair.first.end) or
        (pair.second.end >= pair.first.start and pair.second.end <= pair.first.end))
    {
        // print("overlap {}-{} , {}-{}\n", .{ pair.first.start, pair.first.end, pair.second.start, pair.second.end });
        return 1;
    }
    return 0;
}

pub fn main() !void {
    // const data = @embedFile("data/day4.example");
    const data = @embedFile("data/day4");
    // var lines_it = mem.tokenize(u8, "2-4,6-8\n2-3,4-5", "\n");
    var lines_it = mem.tokenize(u8, data, "\n");

    // var pairs: [6]Pair = .{};
    // var p_idx: u8 = 0;
    var part1: u32 = 0;
    var part2: u32 = 0;

    // var pairs: [2]Pair = undefined;
    // var p_idx: u32 = 0;
    while (lines_it.next()) |line| {
        // print("line: {s}\n", .{line});
        const pair: Pair = try parsePair(line);
        // 2-8 3-7
        part1 += fullyContains(pair);
        part2 += isOverlap(pair);
    }
    print("part1: {any} \n", .{part1});
    print("part2: {any} \n", .{part2});
}
