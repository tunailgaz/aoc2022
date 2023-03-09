import fs from 'node:fs';
import path from 'path';


const isMarker = (marker: string): boolean => {
  for (let i = 0; i < marker.length; i++) {
    if (marker.indexOf(marker[i]) !== marker.lastIndexOf(marker[i])) {
      return false
    }
  }
  return true;
}

const getPosition = (input: string, marker_size: number): number => {
  for (let i = 0; i < input.length - marker_size; i++) {
    if (isMarker(input.slice(i, i + marker_size))) {
      return input.indexOf(input.slice(i, i + marker_size)) + marker_size
    }
  }
  return -1;
}

(() => {

  const file_path = path.join(__dirname, 'data/day6');
  const input = fs.readFileSync(file_path, 'utf-8')
  // example
  // const input = 'mjqjpqmgbljsphdztnvjfqwrcgsmlb';

  console.log(`part1: ${getPosition(input, 4)}`)
  console.log(`part2: ${getPosition(input, 14)}`)

})();
