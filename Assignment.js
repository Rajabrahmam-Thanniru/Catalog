const fs = require("fs");

const decodeValue = (base, value) => {
  return parseInt(value, base);
};

const findConstantTerm = (points) => {
  let constant = 0;

  for (let i = 0; i < points.length; i++) {
    let { x: xi, y: yi } = points[i];
    let term = yi;

    for (let j = 0; j < points.length; j++) {
      if (i !== j) {
        let { x: xj } = points[j];
        term *= -xj / (xi - xj);
      }
    }

    constant += term;
  }

  return Math.round(constant);
};

const solveShamirSecret = (filePath) => {
  const data = JSON.parse(fs.readFileSync(filePath, "utf8"));

  const { keys, ...roots } = data;
  const points = [];

  Object.entries(roots).forEach(([key, { base, value }]) => {
    const x = parseInt(key, 10);
    const y = decodeValue(parseInt(base, 10), value);
    points.push({ x, y });
  });


  const k = keys.k;
  const requiredPoints = points.slice(0, k);
  


  const constantTerm = findConstantTerm(requiredPoints);
  return constantTerm;
};


const testCase1 = "./TestCase 01.json"; 
const testCase2 = "./TestCase 02.json"; 

console.log("Test 1: Constant Term is", solveShamirSecret(testCase1));
console.log("Test 2: Constant Term  is", solveShamirSecret(testCase2));