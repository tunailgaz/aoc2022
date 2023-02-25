const std = @import("std");
const Allocator = std.mem.Allocator;
const log = std.log;

const data  = @embedFile("data/day1");

/// Remove smallest number from array list.
fn remove_smallest(list: anytype ) void {
    var smallest :usize = 0;
    var smallest_index :usize= 0;

    for(list.items) |val,val_index| {
      if(val_index == 0)   smallest = val;

      if(val < smallest) {
        smallest = val;
        smallest_index = val_index;
      }
    }
    _ =  list.swapRemove(smallest_index);
}

pub fn main() !void {

  var holder :usize = 0;
  var lines_it = std.mem.split(u8, data, "\n");
  var general_purpose_allocator = std.heap.GeneralPurposeAllocator(.{}){};
  const gpa = general_purpose_allocator.allocator();

  var top_three = std.ArrayList(usize).init(gpa);
  defer top_three.deinit();

  while(lines_it.next()) |line| {
    if ( line.len > 0 ) {
      holder +=  std.fmt.parseInt(usize, line, 10) catch 0;
    } else {
      if(top_three.items.len >= 3) {
        for(top_three.items) |it|{
            if(holder > it ) {
                remove_smallest(&top_three);
                try top_three.append(holder);
                break;
              }
          }
        }else {
          try top_three.append( holder);
        }
        holder = 0;
    }
  }
  var total :usize = 0;
  for(top_three.items) |item| {
    log.info("item: {}", .{item});
    total += item;
  }
  std.debug.print("total: {} \n", .{total});
}

