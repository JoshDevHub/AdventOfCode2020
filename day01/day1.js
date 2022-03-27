const fs = require('fs');
const readFile = (path) => fs.readFileSync(path, { encoding: 'utf8' });

const ExpenseReport = (file) => {
  const data = readFile(file).split('\n').slice(0, -1).map(Number);

  const twoPartSum = () => {
    const twoParts = data.filter((number) => data.includes(2020 - number));
    return twoParts[0] * twoParts[1];
  }

  const threePartSum = () => {
    const threeParts = [];
    const findParts = () => {
      for (const x of data) {
        for (const y of data) {
          const diff = 2020 - x - y;
          if (data.includes(diff)) {
            threeParts.push(x, y, diff);
            return;
          }
        }
      }
    }
    findParts();
    return threeParts.reduce((product, number) => product * number, 1);
  }

  return {
    twoPartSum,
    threePartSum
  }
}

ExpenseReport(process.argv[2]).twoPartSum(); // 691771
ExpenseReport(process.argv[2]).threePartSum(); // 232508760