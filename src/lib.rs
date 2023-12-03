pub fn read_input(day: u8) -> String {
    let filename = format!("./Inputs/day{day}.txt");
    std::fs::read_to_string(filename).unwrap()
}

pub fn read_input_lines(day: u8) -> Vec<String> {
    read_input(day)
        .trim()
        .split('\n')
        .map(|it| it.to_string())
        .collect()
}
