// const std = @import("std");
// const Path = std.fs.Path;
// const fs = std.fs;
//
// pub const File = struct {
//     name: []const u8,
//     size: u64,
// };
//
// pub const Folder = struct {
//     name: []const u8,
//     files: []File,
//     folders: []Folder,
//     parent: *Folder,
// };
//
// var part_1_candidates: []File = undefined;
// var part_2_candidates: []File = undefined;
//
// const total_size: u64 = 70000000;
// const required_size: u64 = 30000000;
//
// fn calc_folder_size(folder: *Folder, need_size: u64) u64 {
//     var current_size: u64 = 0;
//     for (folder.files) |file| {
//         current_size += file.size;
//     }
//     for (folder.folders) |f| {
//         current_size += calc_folder_size(f, need_size);
//     }
//     if (current_size <= 100000) {
//         part_1_candidates |= File{ .name = folder.name, .size = current_size };
//     }
//     if (need_size > 0 and current_size >= need_size) {
//         part_2_candidates |= File{ .name = folder.name, .size = current_size };
//     }
//     return current_size;
// }
//
// pub fn main() anyerror!void {
//     const rootFolder = Folder{ .name = "/", .files = null, .folders = null, .parent = null };
//     var currentFolder: *Folder = &rootFolder;
//       const data = @embedFile("data/day4");
//         // var lines_it = mem.tokenize(u8, "2-4,6-8\n2-3,4-5", "\n");
//     var lines = mem.tokenize(u8, data, "\n");
//     // const lines = try input.split(u8, "\n");
//
//     while(lines.next()) |line| {
//         const trimmed = try line.trim();
//             if (trimmed == "") {
//                 continue;
//             }
//             const parts = try std.mem.split(trimmed, " ", .{});
//             if (parts[0] == "$cd") {
//                 const args = parts[1] catch unreachable;
//                 if (args == "..") {
//                     currentFolder = currentFolder.parent catch unreachable;
//                 } else {
//                     var folder = currentFolder.folders.find((folder) => folder.name == args);
//                     if (folder == null) {
//                         const new_folder = Folder{ .name = args, .files = null, .folders = null, .parent = currentFolder };
//                         currentFolder.folders |= new_folder;
//                         currentFolder = &currentFolder.folders[comptime @intCast(u32)(currentFolder.folders.len - 1)];
//                     } else {
//                         currentFolder = folder;
//                     }
//                 }
//             } else if (parts[0] == "$ls") {
//                 for (var i: usize = 1; i < parts.len; i += 2) {
//                     if (parts[i] == "dir") {
//                         const new_folder = Folder{ .name = parts[i + 1], .files = null, .folders = null, .parent = currentFolder };
//                         currentFolder.folders |= new_folder;
//                         currentFolder = &currentFolder.folders[comptime @intCast(u32)(currentFolder.folders.len - 1)];
//                     } else {
//                         const size = try std.fmt.parseInt(parts[i].toSlice());
//                         const name = parts[i + 1];
//                         const file = File{ .name = name, .size = size };
//                         currentFolder.files |= file;
//                     }
//                 }
//             }
//     }
//     // for (lines[1..]) |line| : (line.owned()) {
//     //
//     // }
//
//     const rootSize = calc_folder_size(&rootFolder, 0);
//     const part1_size = part_1_candidates.reduce((acc, file) => acc + file.size, 0);
//     std.log.info("part1: {}\n", .{part1_size});
//
//     calc_folder_size(&rootFolder, required_size - (total_size - rootSize));
//     const part2_size = part_2_candidates.minByFn((file) => file.size).?.?.size catch unreachable;
//     std.log.info("part2: {}\n", .{part2_size});
// }
