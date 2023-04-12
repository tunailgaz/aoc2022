const std = @import("std");
const fs = std.fs;
const ArrayList = std.ArrayList;

const File = struct {
    name: []const u8,
    size: u64,
};

const Folder = struct {
    name: []const u8,
    files: *ArrayList(File),
    folders: *ArrayList(Folder),
    parent: ?*Folder,
};

var part1Candidates = ArrayList(File){};
var part2Candidates = ArrayList(File){};

const totalSize: u64 = 70000000;
const requiredSize: u64 = 30000000;

fn calculateFolderSize(folder: *Folder, needSize: u64) u64 {
    var currentSize: u64 = 0;
    for (folder.files.items) |file| {
        currentSize += file.size;
    }
    for (folder.folders.items) |f| {
        currentSize += calculateFolderSize(&f, needSize);
    }

    if (currentSize <= 100000) {
        _ = part1Candidates.append(.{
            .name = folder.name,
            .size = currentSize,
        });
    }

    if (needSize != 0 and currentSize >= needSize) {
        _ = part2Candidates.append(.{ .name = folder.name, .size = currentSize });
    }

    return currentSize;
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    part1Candidates.init(allocator);
    defer part1Candidates.deinit();

    part2Candidates.init(allocator);
    defer part2Candidates.deinit();

    var rootFolder = Folder{
        .name = "/",
        .files = try ArrayList(File).initCapacity(allocator, 16),
        .folders = try ArrayList(Folder).initCapacity(allocator, 8),
        .parent = null,
    };
    defer {
        rootFolder.files.deinit();
        rootFolder.folders.deinit();
    }

    // Read file content
    const input = try fs.cwd().openFileAbsolute("data/day7", .{}).readToEndAlloc(allocator, 4096);
    defer allocator.free(input);

    // TODO: Process the input with a series of if, while and for blocks to manage folder structure.
    // This part will depend on your specific Zig implementation and how you handle strings and arrays.

    // Calculate folder sizes and find candidates
    _ = calculateFolderSize(&rootFolder, 0);
    const rootSize = try calculateFolderSize(&rootFolder, requiredSize - (totalSize - rootFolder.files.items.len));

    _ = rootSize;
    // Print results
    var part1Total: u64 = 0;
    for (part1Candidates.items) |t| {
        part1Total += t.size;
    }
    std.debug.print("part1: {}\n", .{part1Total});

    var min_part2: u64 = u64.max_value;
    for (part2Candidates.items) |t| {
        min_part2 = std.math.min(min_part2, t.size);
    }
    std.debug.print("part2: {}\n", .{min_part2});
}
