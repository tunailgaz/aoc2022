import fs from 'node:fs';
import path from 'path';


const get_item_priority = (item: string) => item.charCodeAt(0) - (item.toUpperCase() == item ? 38 : 96);

const part1 = (list: string[]): number => {
  let total_priority = 0;

  for (let items of list) {
    const item_count = items.length;
    const comp1 = items.slice(0, item_count / 2);
    const comp2 = items.slice(item_count / 2);

    // const sorted1 = [...comp1].sort((a, b) => get_item_priority(a) - get_item_priority(b)).join('');
    // const sorted2 = [...comp2].sort((a, b) => get_item_priority(a) - get_item_priority(b)).join('');

    for (let item of [...comp1]) {
      if (comp2.indexOf(item) > -1) {
        // console.log(`found: ${item} -> ${get_item_priority(item)}`);

        total_priority += get_item_priority(item);
        break;
      }
    }

  }
  return total_priority;
}


const part2 = (list: string[]): number => {
  let total = 0;

  let groups: Array<string[]> = [];


  for (let i = 0; i < list.length; i += 3) {
    let group = list.slice(i, i + 3);
    groups = [...groups, group];
  }

  for (let group of groups) {
    for (let item of [...group[0]]) {
      // console.log(item);
      if (group[1].indexOf(item) > -1 && group[2].indexOf(item) > -1) {
        // console.log(`found: ${item}: ${get_item_priority(item)}`);
        total += get_item_priority(item);
        break;
      }
      // testingo
    }
  }
  return total;
}


(() => {

  // const file_path = path.join(__dirname, 'data/day3.example');
  const file_path = path.join(__dirname, 'data/day3');
  const list = fs.readFileSync(file_path, 'utf-8')?.split('\n');

  const part1_result = part1(list);
  console.log(`part1: ${part1_result}`);

  const part2_result = part2(list);
  console.log(`part2: ${part2_result}`);

})();