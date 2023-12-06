import functools
import math
from dataclasses import dataclass


@dataclass
class Race:
    time: int
    distance: int

    @property
    def winning_range(self) -> range:
        lower = 1e-14 + (self.time - math.sqrt(self.time**2 - 4 * self.distance)) / 2
        upper = -1e-14 + (self.time + math.sqrt(self.time**2 - 4 * self.distance)) / 2
        return range(math.ceil(lower), math.floor(upper) + 1)


d6_input = [
    Race(time=48, distance=261),
    Race(time=93, distance=1192),
    Race(time=84, distance=1019),
    Race(time=66, distance=1063),
]


part1 = functools.reduce(
    lambda a, b: a * b, (len(race.winning_range) for race in d6_input)
)

print(f"Part 1: {part1}")

part2_input = Race(time=48938466, distance=261119210191063)
print(f"Part 2: {len(part2_input.winning_range)}")
