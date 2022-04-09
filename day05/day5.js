const fs = require('fs');
const readFile = (path) => fs.readFileSync(path, { encoding: 'utf8' });

const BoardingPassProcessor = (file) => {
  const data = readFile(file).split('\n')
                             .slice(0, -1)
                             .map((pass) => [pass.slice(0, 7), pass.slice(7)]);

  const buildRange = (start, end) =>
    Array.from({ length: end - start + 1 }, (_, i) => start + i);
  const rows = buildRange(0, 127);
  const cols = buildRange(0, 7);
  const allSeats = () => {
    const seatCollection = [];
    for(const row of rows) {
      for(const col of cols) {
        seatCollection.push([row, col]);
      }
    }
    return seatCollection;
  }

  const calculateMaxSeatID = () => {
    return data.reduce((maxID, pass) => {
      const seatCoords = pass.map(findPosition)
      const seatID = calculateSeatID(...seatCoords);
      return Math.max(maxID, seatID)
    }, 0)
  }

  const findMySeat = () => {
    const allSeatIDs = allSeats().map((seat) => calculateSeatID(...seat));
    const takenIDs = data.map((pass) => {
      const seatCoords = pass.map(findPosition)
      return seatID = calculateSeatID(...seatCoords);
    })
    const vacantIDs = allSeatIDs.filter((id) => !takenIDs.includes(id));
    return vacantIDs.filter((id) =>
      takenIDs.includes(id + 1) && takenIDs.includes(id - 1));
  }

  const findPosition = (instructions) => {
    const orientation = instructions.length === 7 ? rows : cols;
    const upperChar = orientation === rows ? 'F' : 'L';
    return instructions.split('').reduce((chart, char) => {
      const midpoint = chart.length / 2;
      return char === upperChar ? chart.slice(0, midpoint) : chart.slice(midpoint);
    }, orientation)[0]
  }

  const calculateSeatID = (rowPos, colPos) => (rowPos * 8) + colPos;

  return {
    get data() { return data },
    calculateMaxSeatID,
    findMySeat
  }
}

const processor = BoardingPassProcessor(process.argv[2]);

processor.calculateMaxSeatID(); // 955
console.log(processor.findMySeat()); // 569
