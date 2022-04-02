const fs = require('fs');
const readFile = (path) => fs.readFileSync(path, { encoding: 'utf8' });

const PassportProcessor = (file) => {
  const data = readFile(file).split('\n\n').map((passport) => {
    return passport.replace(/\n/g, ' ').split(' ').reduce((map, field) => {
      const [key, value] = field.split(':');
      map.set(key, value);
      return map;
    }, new Map());
  });

  const validFields = ['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid'];
  const eyeColors = ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'];

  const hasAllFields = (passport) =>
    validFields.every((field) => passport.has(field));

  const hasValidValues = (passport) => {
    const validators = {
      byr: (data) => 1920 <= data && data <= 2002,
      iyr: (data) => 2010 <= data && data <= 2020,
      eyr: (data) => 2020 <= data && data <= 2030,
      hgt: (data) => {
        if (data.slice(-2) === 'cm') {
          const number = data.slice(0, 3);
          return data.length === 5 && 150 <= number && number <= 193;
        }
        if (data.slice(-2) === 'in') {
          const number = data.slice(0, 2);
          return data.length === 4 && 59 <= number && number <= 76;
        }
        return false;
      },
      hcl: (data) => data.match(/^#[a-f0-9]{6}$/),
      ecl: (data) => eyeColors.includes(data),
      pid: (data) => data.match(/^\d{9}$/),
      cid: (_data) => true,
    }

    return validFields.every((field) => {
      const value = passport.get(field);
      return validators[field](value);
    })
  }

  const countValidPassports = () => {
    return data.reduce((validCount, passport) => {
      if (hasAllFields(passport) && hasValidValues(passport)) {
        validCount++;
      }
      return validCount;
    }, 0);
  }

  const countValidFields = () => {
    return data.reduce((validCount, passport) =>
      hasAllFields(passport) ? validCount + 1 : validCount, 0);
  }

  return {
    countValidFields,
    countValidPassports
  };
}

const processor = PassportProcessor(process.argv[2]);

processor.countValidFields(); // 247
processor.countValidPassports(); // 145
