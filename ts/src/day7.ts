import path from "path";
import fs from "node:fs";

interface File {
  name: string;
  size: number;
}

interface Folder {
  name: string;
  files: File[];
  folders: Folder[];
  parent: Folder | null;
}

let part1Candidates: { name: string; size: number }[] = [];
let part2Candidates: { name: string; size: number }[] = [];

const totalSize = 70000000;
const requiredSize = 30000000;

// optimize this function to reduce time complexity
const calculateFolderSize = (folder: Folder, needSize: number): number => {
  let currentSize = folder.files.reduce((accumulator, file) => accumulator + file.size, 0)
 currentSize += folder.folders.reduce((acc, f) => acc + calculateFolderSize(f, needSize), 0);
  if (currentSize <= 100000) {
    part1Candidates.push({
      name: folder.name,
      size: currentSize,
    });
  }

  if (needSize && currentSize >= needSize) {
    part2Candidates.push({ name: folder.name, size: currentSize });
  }

  return currentSize;
};

(async () => {
  const fileDir = path.join(__dirname, "data/day7");
  const input = await fs.promises.readFile(fileDir, "utf-8");
  const lines = input.split("\n");

  let rootFolder: Folder = {
    name: "/",
    files: [],
    folders: [],
    parent: null,
  };

  let currentFolder = rootFolder;

  for (let i = 1; i < lines.length; i++) {
    const line = lines[i].trim();

    if (line && line[0] === "$") {
      const command = line.split(" ")[1]?.trim();

      switch (command) {
        case "cd": {
          const args = line.split(" ")[2]?.trim();

          if (args === "..") {
            if (currentFolder.parent) {
              currentFolder = currentFolder.parent;
            }
          } else {
            const folder = currentFolder.folders?.find(
              (t) => t.name === args
            );

            if (folder) {
              currentFolder = folder;
            } else {
              const newFolder: Folder = {
                name: args,
                folders: [],
                files: [],
                parent: currentFolder,
              };

              currentFolder.folders.push(newFolder);
              currentFolder = newFolder;
            }
          }

          break;
        }
        case "ls": {
          let j = 1;

          while (true) {
            const line = lines[i + j];

            if (!line || line[0] === "$") {
              break;
            }

            j++;

            const lsCommand = line.split(" ");

            if (lsCommand[0].trim() === "dir") {
              const newFolder: Folder = {
                name: lsCommand[1].trim(),
                folders: [],
                files: [],
                parent: currentFolder,
              };
              currentFolder.folders.push(newFolder);
            } else {
              const size = Number(lsCommand[0].trim());
              const name = lsCommand[1].trim();

              const file: File = {
                name,
                size,
              };

              currentFolder.files.push(file);
            }
          }
          break;
        }
      }
    }
  }

  // add part1 candidates
  const rootSize = calculateFolderSize(rootFolder, 0);
  console.log(
    `part1: ${part1Candidates.map((t) => t.size).reduce((a, b) => b + a, 0)}`
  );

  // add part2 candidates
  calculateFolderSize(rootFolder, requiredSize - (totalSize - rootSize));
  console.log(`part2: ${Math.min(...part2Candidates.map((t) => t.size))}`);
})();
