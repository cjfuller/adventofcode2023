def read_input_lines(day: int) -> list[str]:
    with open(f"./Inputs/day{day}.txt") as f:
        return f.read().strip().split("\n")
