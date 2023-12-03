use std::collections::{HashMap, HashSet};

use adventofcode2023::read_input_lines;

fn make_num(digits: &[char]) -> u64 {
    assert!(!digits.is_empty());
    let mut total: u64 = 0;
    let mut curr_factor: u64 = 1;
    for c in digits.iter().rev() {
        total += c.to_digit(10).unwrap() as u64 * curr_factor;
        curr_factor *= 10;
    }

    total
}

fn extract_digits(grid: &HashMap<(i32, i32), char>, first_digit_at: (i32, i32)) -> Vec<char> {
    let mut digits = vec![];
    let mut curr = first_digit_at;
    while let Some(dig) = grid.get(&curr) {
        if !dig.is_ascii_digit() {
            break;
        }
        digits.push(*dig);
        curr = (curr.0 + 1, curr.1);
    }
    digits
}

fn is_part_number(
    grid: &HashMap<(i32, i32), char>,
    first_digit_at: (i32, i32),
    digits: &[char],
) -> bool {
    let mut indexes: Vec<(i32, i32)> = vec![
        (first_digit_at.0 - 1, first_digit_at.1),
        (first_digit_at.0 + digits.len() as i32, first_digit_at.1),
    ];
    for x_offset in (-1)..=(digits.len() as i32) {
        indexes.push((first_digit_at.0 + x_offset, first_digit_at.1 - 1));
        indexes.push((first_digit_at.0 + x_offset, first_digit_at.1 + 1));
    }

    indexes.into_iter().any(|idx| {
        grid.get(&idx)
            .map(|it| !it.is_ascii_digit())
            .unwrap_or_default()
    })
}

fn part_1(input_lines: &[String]) {
    let mut sparse_grid: HashMap<(i32, i32), char> = Default::default();
    let mut x_bounds = (0, 0);
    let mut y_bounds = (0, 0);
    for (yu, line) in input_lines.iter().enumerate() {
        for (xu, ch) in line.chars().enumerate() {
            let x = xu as i32;
            let y = yu as i32;
            if ch == '.' {
                continue;
            }
            x_bounds = (std::cmp::min(x_bounds.0, x), std::cmp::max(x_bounds.1, x));
            y_bounds = (std::cmp::min(y_bounds.0, y), std::cmp::max(y_bounds.1, y));
            sparse_grid.insert((x, y), ch);
        }
    }

    let mut part_numbers = vec![];

    for y in y_bounds.0..=y_bounds.1 {
        for x in x_bounds.0..=x_bounds.1 {
            if let Some(c) = sparse_grid.get(&(x, y)) {
                if c.is_ascii_digit()
                    && !sparse_grid
                        .get(&(x - 1, y))
                        .map(|chr| chr.is_ascii_digit())
                        .unwrap_or_default()
                {
                    let digits = extract_digits(&sparse_grid, (x, y));
                    if is_part_number(&sparse_grid, (x, y), &digits) {
                        part_numbers.push(make_num(&digits));
                    }
                }
            }
        }
    }

    println!("Part 1: {}", part_numbers.into_iter().sum::<u64>())
}

fn extract_number_start_from_any_digit_pos(
    grid: &HashMap<(i32, i32), char>,
    any_digit_pos: (i32, i32),
) -> (i32, i32) {
    let mut result = any_digit_pos;
    let mut next_pos = any_digit_pos;
    while let Some(c) = grid.get(&next_pos) {
        if c.is_ascii_digit() {
            result = next_pos;
            next_pos = (next_pos.0 - 1, next_pos.1);
        } else {
            break;
        }
    }
    result
}

fn extract_adjacent_numbers(grid: &HashMap<(i32, i32), char>, gear: (i32, i32)) -> Vec<u64> {
    let (gx, gy) = gear;
    let borders = vec![
        (gx - 1, gy),
        (gx + 1, gy),
        (gx, gy - 1),
        (gx, gy + 1),
        (gx - 1, gy - 1),
        (gx - 1, gy + 1),
        (gx + 1, gy - 1),
        (gx + 1, gy + 1),
    ];
    borders
        .into_iter()
        .filter_map(|b| match grid.get(&b) {
            Some(c) if c.is_ascii_digit() => Some(extract_number_start_from_any_digit_pos(grid, b)),
            _ => None,
        })
        .collect::<HashSet<_>>()
        .into_iter()
        .map(|pos| make_num(&extract_digits(grid, pos)))
        .collect()
}

fn part_2(input_lines: &[String]) {
    let mut sparse_grid: HashMap<(i32, i32), char> = Default::default();
    let mut x_bounds = (0, 0);
    let mut y_bounds = (0, 0);
    for (yu, line) in input_lines.iter().enumerate() {
        for (xu, ch) in line.chars().enumerate() {
            let x = xu as i32;
            let y = yu as i32;
            if ch == '.' {
                continue;
            }
            x_bounds = (std::cmp::min(x_bounds.0, x), std::cmp::max(x_bounds.1, x));
            y_bounds = (std::cmp::min(y_bounds.0, y), std::cmp::max(y_bounds.1, y));
            sparse_grid.insert((x, y), ch);
        }
    }

    let mut gear_ratios = vec![];

    for y in y_bounds.0..=y_bounds.1 {
        for x in x_bounds.0..=x_bounds.1 {
            if let Some('*') = sparse_grid.get(&(x, y)) {
                let adjacent = extract_adjacent_numbers(&sparse_grid, (x, y));
                if adjacent.len() == 2 {
                    gear_ratios.push(adjacent[0] * adjacent[1]);
                }
            }
        }
    }

    println!("Part 2: {}", gear_ratios.into_iter().sum::<u64>())
}

fn main() {
    let input = read_input_lines(3);
    part_1(&input);
    part_2(&input);
}
