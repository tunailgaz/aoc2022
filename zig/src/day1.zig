const std = @import("std");
const Allocator = std.mem.Allocator;
const log = std.log;

const data  = @embedFile("data/day1");

//
//fn remove_smallest(list: *T) void {
//
//}
pub fn main() !void {

  var elf :usize = 0;
  var lines_it = std.mem.split(u8, data, "\n");
  var general_purpose_allocator = std.heap.GeneralPurposeAllocator(.{}){};
  const gpa = general_purpose_allocator.allocator();



  var top_three = std.ArrayList(usize).init(gpa);
  defer top_three.deinit();


  while(lines_it.next()) |line| {

    if ( line.len > 0 ) {
      elf +=  std.fmt.parseInt(usize, line, 10) catch 0;
    } else {
      if(top_three.items.len >= 3) {
        for(top_three.items) |it|{
            if(elf > it ) {

                var smallest :usize = 0;
                var smallest_index :usize= 0;

                for(top_three.items) |val,val_index| {
                  if(val_index == 0){
                    smallest = val;
                  }
                  if(val < smallest) {
                    smallest = val;
                    smallest_index = val_index;
                  }
                }

                _ =  top_three.swapRemove(smallest_index);
                try top_three.append(elf);
                break;
              }
          }
        }else {
          try top_three.append( elf);
        }
        elf = 0;
    }
  }

  var total :usize = 0;
  for(top_three.items) |item| {
    log.info("item: {}", .{item});
    total += item;
  }
  std.debug.print("total: {} \n", .{ total});

}

