const fs = require('fs');
const readFile = (path) => fs.readFileSync(path, { encoding: 'utf8' });

const PasswordValidator = (file) => {
  const data = readFile(file).split('\n').map((line) => {
    const [range, letter, password] = line.trim().split(' ');
    const [min, max] = range.split('-').map(Number);
    return { min: min, max: max, letter: letter[0], password: password };
  });

  const countValidSledPasswords = () => {
    return data.reduce((validCount, pwdSet) => {
      const {min, max, letter, password} = pwdSet;
      letterCount = (password.match(new RegExp(letter, 'g')) || []).length
      return min <= letterCount && letterCount <= max ? validCount + 1 : validCount
    }, 0);
  }

  const countValidTobogganPassword = () => {
    return data.reduce((validCount, pwdSet) => {
      const {min, max, letter, password} = pwdSet;
      const [firstIdx, secondIdx] = [min, max].map(num => num - 1);
      const oneMatch = [password[firstIdx], password[secondIdx]]
        .filter((char) => char === letter).length === 1;
      return oneMatch ? validCount + 1 : validCount;
    }, 0);
  }

  return {
    countValidSledPasswords,
    countValidTobogganPassword
  }
}

const validator = PasswordValidator(process.argv[2]);
validator.countValidSledPasswords(); // 636
validator.countValidTobogganPassword(); // 588