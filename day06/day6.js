const fs = require('fs');
const readFile = (path) => fs.readFileSync(path, { encoding: 'utf8' });

const Customs = (file) => {
  const data = readFile(file).split('\n\n');

  const countYesResponses = () => {
    return data.reduce((count, group) => {
      const totalResponses = group.replaceAll('\n', '');
      const uniqueResponses = [...new Set(totalResponses)];
      return count + uniqueResponses.length
    }, 0)
  }

  const countYesForEveryone = () => {
    return data.reduce((count, group) => {
      const responseArray = group.replaceAll('\n', '').split('');
      const numberOfPeople = group.split('\n').length;
      const responseCounts = tally(responseArray);
      Object.values(responseCounts).forEach((total) => {
        if (total === numberOfPeople) count++;
      })
      return count;
    }, 0)
  }

  const tally = (array) => {
    return array.reduce((counterObj, char) => {
      counterObj[char] ? counterObj[char]++ : counterObj[char] = 1;
      return counterObj;
    }, {})
  }

  return {
    countYesResponses,
    countYesForEveryone
  }
}

const customs = Customs(process.argv[2]);

customs.countYesResponses(); // 6735
customs.countYesForEveryone(); // 3221
