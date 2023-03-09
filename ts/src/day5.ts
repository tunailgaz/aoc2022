import fs from 'node:fs';
import path from 'path';


const getSize = (stacks: Array<string>): number => {
  return  Math.max(...(stacks.join('\n').replace(/[^1-9]/g, '').split('').map(t=> Number(t))));
}


(() => {

  // const file_path = path.join(__dirname, 'data/day5.example');
  const file_path = path.join(__dirname, 'data/day5');
  const file_parts = fs.readFileSync(file_path, 'utf-8')?.split('\n\n');

  const stack_lines = file_parts[0]?.split("\n");
  const move_lines = file_parts[1]?.split("\n");
  const stack_size = getSize(stack_lines);

  let part_1_list: string[][] = [];
  let part_2_list: string[][] = [];

  for(let i=0; i<stack_size; i++) {
    part_1_list[i] = [];
    part_2_list[i] = [];
  }

  for(let line of stack_lines.reverse()) {
    if (line.indexOf('[')>-1) {
      for(let i=0; i<stack_size; i++) {
        let cargo = line.slice(4 * i, 4 * i + 4 );
        if(cargo.trim()){
          part_1_list[i].push(cargo.trim().replace(/[^A-Z]/g,''))
          part_2_list[i].push(cargo.trim().replace(/[^A-Z]/g,''))
        }
      }
    }
  }

  for(let move_line of move_lines) {
    const move_line_numbers  = move_line.split(/\s/g);
    if(move_line_numbers?.length) {
      const move = Number(move_line_numbers[1]);
      const from = Number(move_line_numbers[3]) -1 ;
      const to = Number(move_line_numbers[5]) -1 ;

      for(let i=0; i<move; i++){
        let item = part_1_list[from].pop();
        if(item){
          part_1_list[to].push(item);
        }
      }
      part_2_list[to] =  [...part_2_list[to], ...part_2_list[from].slice(move * -1)];
      part_2_list[from] = part_2_list[from].slice(0,part_2_list[from].length - move);
    }

  }

  let part1 = '';
  for(let list of part_1_list) {
    part1 += list[list.length -1];
  }
  console.log(part1)

  let part2 = '';
  for(let list of part_2_list) {
    part2 += list[list.length -1];
  }
  console.log(part2)

})();
