const fs = require('fs');
const readFile = (path) => fs.readFileSync(path, { encoding: 'utf8' });


const TreeMap = (file) => {
  const data = readFile(file).split('\n')
  const rowLength = data[0].length;
  const numberOfTrees = (location) => location === '#' ? 1 : 0;

  const countTreesForSlope = (rightStep, downStep) => {
    let xPos = rightStep * -1;
    return data.reduce((treeCount, _, yPos) => {
      if (yPos % downStep === 0) {
        xPos = (xPos + rightStep) % rowLength;
        const location = data[yPos][xPos];
        treeCount += numberOfTrees(location);
      }
      return treeCount;
    }, 0);
  }

  const calculateAllSlopes = () => {
    return [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]]
      .reduce((product, coordSet) => product * countTreesForSlope(...coordSet), 1);
  }

  return {
    countTreesForSlope,
    calculateAllSlopes
  }
}

const mapper = TreeMap(process.argv[2]);
mapper.countTreesForSlope(3, 1); // 211
mapper.calculateAllSlopes(); // 3584591857
