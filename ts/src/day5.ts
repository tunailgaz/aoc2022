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



  let array_list: string[][] = [];
  for(let i=0; i<stack_size; i++) {
    array_list[i] = [];
  }

  for(let line of stack_lines.reverse()) {
    if (line.indexOf('[')>-1) {
      for(let i=0; i<stack_size; i++) {
        let cargo = line.slice(4 * i, 4 * i + 4 );
        if(cargo.trim()){
          array_list[i].push(cargo.trim().replace(/[^A-Z]/g,''))
        }
      }
    }
  }
  for(let move_line of move_lines) {
    const move_line_numbers  = move_line.split(/\s/g);
    if(move_line_numbers?.length) {
      let move = Number(move_line_numbers[1]);
      const from = Number(move_line_numbers[3]) -1 ;
      const to = Number(move_line_numbers[5]) -1 ;
      while(move > 0) {
        let item = array_list[from].pop();
        if(item){
          array_list[to].push(item);
        }
        move--;
      }
    }

  }
  let part1 = '';
  for(let list of array_list) {
    part1 += list[list.length -1];
  }

  console.log(part1)

})();
