use std::collections::HashMap;

fn check_byr(byr: &str) -> bool {
    let birth_year = byr.parse::<i32>().unwrap();
    if birth_year >= 1920 && birth_year <= 2002 {
        return true;
    }
    false
}

fn check_iyr(iyr: &str) -> bool {
    let issue_year = iyr.parse::<i32>().unwrap();
    if issue_year >= 2010 && issue_year <= 2020 {
        return true;
    }
    false
}

fn check_eyr(eyr: &str) -> bool {
    let expire_year = eyr.parse::<i32>().unwrap();
    if expire_year >= 2020 && expire_year <= 2030 {
        return true;
    }
    false
}

fn check_hgt(hgt: &str) -> bool {
    if hgt.contains("cm") {
        let hgt_cm = hgt.replace("cm", "").parse::<i32>().unwrap();
        if hgt_cm >= 150 && hgt_cm <= 193 {
            return true;
        }
        return false;
    }

    if hgt.contains("in") {
        let hgt_cm = hgt.replace("in", "").parse::<i32>().unwrap();
        if hgt_cm >= 59 && hgt_cm <= 76 {
            return true;
        }
        return false;
    }

    false
}

fn check_hcl(hcl: &str) -> bool {
    if hcl.chars().nth(0) == Some('#') {
        let value = hcl
            .chars()
            .skip(1)
            .map(|x| {
                if (x >= '0' && x <= '9') || (x >= 'a' && x <= 'f') {
                    return true;
                }
                return false;
            })
            .fold(true, |acc, i| acc && i);
        return value;
    }
    false
}

fn check_ecl(ecl: &str) -> bool {
    let colours = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"];
    colours.contains(&ecl)
}

fn check_pid(pid: &str) -> bool {
    pid.len() == 9
}

fn main() {
    let args: Vec<String> = std::env::args().skip(1).collect();

    if args.len() != 1 {
        eprintln!("please provide input file");
        std::process::exit(-1);
    }

    let file = std::fs::read_to_string(args[0].to_owned()).expect("file not found");
    let mut passports: Vec<HashMap<String, String>> = vec![];

    for i in file.trim().split("\n\n") {
        let j = i.replace('\n', " ");
        let k: Vec<&str> = j.split(" ").collect();
        let mut passport: HashMap<String, String> = HashMap::new();
        for l in k.iter() {
            let key = l.split(":").nth(0).unwrap();
            let value = l.split(":").nth(1).unwrap();
            passport.insert(key.into(), value.into());
        }
        passports.push(passport);
    }

    let mut valid_passports_part_1 = 0;
    let mut valid_passports_part_2 = 0;

    for passport in passports {
        let mut valid_count = false;

        if passport.get("cid").is_some() {
            if passport.len() == 8 {
                valid_passports_part_1 += 1;
                valid_count = true;
            }
        } else {
            if passport.len() == 7 {
                valid_passports_part_1 += 1;
                valid_count = true;
            }
        }

        if valid_count {
            let byr = check_byr(passport.get("byr").unwrap());
            let iyr = check_iyr(passport.get("iyr").unwrap());
            let eyr = check_eyr(passport.get("eyr").unwrap());
            let hgt = check_hgt(passport.get("hgt").unwrap());
            let hcl = check_hcl(passport.get("hcl").unwrap());
            let ecl = check_ecl(passport.get("ecl").unwrap());
            let pid = check_pid(passport.get("pid").unwrap());

            let valid = byr && iyr && eyr && hgt && hcl && ecl && pid;

            if valid {
                valid_passports_part_2 += 1;
            }
        }
    }

    println!("Part 1");
    println!("Valid Passports : {}", valid_passports_part_1);
    println!("Part 2");
    println!("Valid Passports : {}", valid_passports_part_2);
}
