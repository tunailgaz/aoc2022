import path from "path";
import fs from "node:fs";


interface File {
  name: string
  size: number
}

interface Folder {
  name: string
  files: File[]
  folders: Folder[]
  parent: Folder | null
}

let part_1_candidates: { name: string, size: number }[] = [];
let part_2_candidates: { name: string, size: number }[] = [];

const total_size = 70000000;
const required_size = 30000000;


const calc_folder_size = (folder: Folder, need_size: number): number => {
  let current_size = 0;
  for (let file of folder.files) {
    current_size += file.size;
  }
  if (folder.folders.length) {
    for (let f of folder.folders) {
      current_size += calc_folder_size(f, need_size)
    }
  }
  if (current_size <= 100000) {
    part_1_candidates = [...part_1_candidates, {
      name: folder.name,
      size: current_size,
    }]
  }
  if (need_size && current_size >= need_size) {
    part_2_candidates = [...part_2_candidates, {name: folder.name, size: current_size}];
  }

  return current_size
}


(() => {

  // const file_path = path.join(__dirname, 'data/day7.example');
  const file_path = path.join(__dirname, 'data/day7');
  const input = fs.readFileSync(file_path, 'utf-8')
  const lines = input.split('\n');

  let rootFolder: Folder = {
    name: '/',
    files: [],
    folders: [],
    parent: null,
  }

  let currentFolder = rootFolder;
  for (let i = 1; i < lines.length; i++) {
    let line = lines[i].trim();

    if (line && line[0] === '$') {
      let command = line.split(' ')[1]?.trim();

      switch (command) {
        case 'cd': {
          let args = line.split(' ')[2]?.trim()
          if (args === '..') {
            if (currentFolder.parent) {
              currentFolder = currentFolder.parent;
            }
          } else {
            let folder = currentFolder.folders?.find(t => t.name === args)
            if (folder) {
              currentFolder = folder;
            } else {
              let new_folder: Folder = {
                name: args,
                folders: [],
                files: [],
                parent: currentFolder,
              }
              currentFolder.folders.push(new_folder);
              currentFolder = new_folder;
            }
          }

          break;

        }
        case 'ls': {
          let j = 1;
          while (true) {
            let line = lines[i + j];
            if (!line || line[0] === '$') {
              break;
            }
            j++

            let ls_command = line.split(' ');
            if (ls_command[0].trim() === 'dir') {
              let new_folder: Folder = {
                name: ls_command[1].trim(),
                folders: [],
                files: [],
                parent: currentFolder,
              }
              currentFolder.folders.push(new_folder)

            } else {
              let size = Number(ls_command[0].trim());
              let name = ls_command[1].trim();
              let file: File = {
                name,
                size
              }
              currentFolder.files.push(file)

            }
          }
          break;
        }
      }
    }
  }

  // add part1 candidates
  let rootSize = calc_folder_size(rootFolder, 0)
  console.log(`part1: ${part_1_candidates.map(t => t.size).reduce((a, b) => b + a, 0)}`)

  // add part2 candidates
  calc_folder_size(rootFolder, required_size - (total_size - rootSize))
  console.log(`part2: ${Math.min(...part_2_candidates.map(t => t.size))}`)

})();
