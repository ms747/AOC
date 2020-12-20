const data = await Deno.readTextFile(Deno.args[0]);

let mask;
let memory = {};
let memory2 = {};

function applyMask(m, v) {
    let b36 = v.toString(2).padStart(36, 0);
    let result = [];

    for (let i = 0; i < 36; i++) {
        if (m[i] != 'X') {
            result.push(m[i]);
        } else {
            result.push(b36[i]);
        }
    }

    return parseInt(result.join(""), 2);
}

for (let line of data.split('\n')) {
    let matches;
    if (line != "") {
        if (matches = line.match(/mask = (\w+)/)) {
            mask = matches[1];
        }

        if (matches = line.match(/mem\[(\d+)\] = (\d+)/)) {
            // Memory 1
            const result = applyMask(mask, (+matches[2]));
            memory[matches[1]] = result;
            // Memory 2
            const value = +matches[2];
            const addresses = createCombinations(applyMask2(mask, (+matches[1])));
            for (let address of addresses) {
                memory2[address] = value;
            }
        }
    }
}

function applyMask2(m, v) {
    let b36 = v.toString(2).padStart(36, 0);
    let result = [];

    for (let i = 0; i < 36; i++) {
        if (m[i] === "1") {
            result.push("1");
        } else if (m[i] === "0") {
            result.push(b36[i]);
        } else {
            result.push(m[i]);
        }
    }

    return result;
}

function createCombinations(m) {
    let combos = [];
    for (let i of m) {
        if (i != 'X') {
            if (combos.length !== 0) {
                let temp = [];

                for (let c of combos) {
                    temp.push(c + i);
                }

                combos = temp;
            } else {
                combos.push(i);
            }
        } else {
            if (combos.length !== 0) {
                let temp = [];

                for(let c of combos) {
                    temp.push(c + "0");
                    temp.push(c + "1");
                }

                combos = temp;
            } else {
                combos.push("0");
                combos.push("1");
            }
        }
    }
    return combos.map(x => parseInt(x, 2));
}

let part1 = 0;

for (let value of Object.values(memory)) {
    part1 += +value;
}

let part2 = 0;

for (let value of Object.values(memory2)) {
    part2 += +value;
}

console.log(part1, part2);
