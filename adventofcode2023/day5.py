import itertools
import re
from dataclasses import dataclass
from typing import Generator

from .util import read_input_lines


@dataclass
class Range:
    src_range_start: int
    dest_range_start: int
    size: int

    def __contains__(self, item: int) -> bool:
        return item in range(self.src_range_start, self.src_range_start + self.size)

    def map(self, item: int) -> int:
        return item - self.src_range_start + self.dest_range_start

    def merge_with(self, target: "Range") -> Generator["Range", None, None]:
        if (
            target.src_range_start < self.dest_range_start + self.size
            and target.src_range_start + target.size > self.dest_range_start
        ):
            # There is *some* overlap.
            # If the range is completely contained in the target one, then we're good.
            # Otherwise, we need to split and start over.
            if (
                self.dest_range_start >= target.src_range_start
                and self.dest_range_start + self.size
                <= target.src_range_start + target.size
            ):
                offset = self.dest_range_start - target.src_range_start
                # complete overlap
                yield Range(
                    src_range_start=self.src_range_start,
                    dest_range_start=target.dest_range_start + offset,
                    size=self.size,
                )
            elif target.src_range_start > self.dest_range_start:
                offset = target.src_range_start - self.dest_range_start
                yield Range(
                    src_range_start=self.src_range_start,
                    dest_range_start=self.dest_range_start,
                    size=offset,
                )
                yield Range(
                    src_range_start=self.src_range_start + offset,
                    dest_range_start=target.src_range_start,
                    size=self.size - offset,
                )
            elif (target_end := target.src_range_start + target.size) < (
                src_end := self.dest_range_start + self.size
            ):
                overlap = target_end - self.dest_range_start
                yield Range(
                    src_range_start=self.src_range_start,
                    dest_range_start=self.dest_range_start,
                    size=overlap,
                )
                yield Range(
                    src_range_start=self.src_range_start + overlap,
                    dest_range_start=target_end,
                    size=(src_end - target_end),
                )


@dataclass
class Map:
    src_type: str
    dest_type: str
    ranges: list[Range]

    def do_mapping(self, item: int) -> int:
        for rng in self.ranges:
            if item in rng:
                return rng.map(item)
        return item

    def merge(self, next_map: "Map") -> "Map":
        new_ranges = []
        needs_merge = [*self.ranges]
        while needs_merge:
            range = needs_merge[0]
            needs_merge = needs_merge[1:]
            had_any_overlap = False
            for target_range in next_map.ranges:
                result = list(range.merge_with(target_range))
                if not result:
                    continue
                had_any_overlap = True
                if len(result) == 1:
                    new_ranges += result
                else:
                    needs_merge += result
                    break
            if not had_any_overlap:
                new_ranges.append(range)

        return Map(
            src_type=self.src_type, dest_type=next_map.dest_type, ranges=new_ranges
        )


inputs = read_input_lines(5)
test_input = """\
seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4 
"""
# inputs = test_input.split("\n")
maps = {}

curr_map = None

for line in inputs:
    if m := re.search("seeds: (.*)", line):
        seeds = [int(num, 10) for num in m.group(1).strip().split(" ")]
    elif m := re.search(r"(\w+)-to-(\w+) map:", line):
        if curr_map:
            maps[curr_map.src_type] = curr_map
        curr_map = Map(src_type=m.group(1), dest_type=m.group(2), ranges=[])
    elif re.search(r"\d", line):
        dest, source, rlen = [int(num) for num in line.strip().split(" ")]
        curr_map.ranges.append(
            Range(src_range_start=source, dest_range_start=dest, size=rlen)
        )

maps[curr_map.src_type] = curr_map


def map_to_location(curr_type: str, curr_num: int) -> int:
    if curr_type == "location":
        return curr_num

    next_map = maps[curr_type]
    assert next_map.src_type == curr_type
    return map_to_location(next_map.dest_type, next_map.do_mapping(curr_num))


part_1 = min([map_to_location("seed", seed) for seed in seeds])

print(f"Part 1: {part_1}")

part_2_seeds = list(itertools.batched(seeds, 2))

merged_map = Map(
    src_type="origin",
    dest_type="seed",
    ranges=[Range(start, start, size) for start, size in part_2_seeds],
)

while merged_map.dest_type != "location":
    merged_map = merged_map.merge(maps[merged_map.dest_type])

part_2 = min(r.dest_range_start for r in merged_map.ranges)

print(f"Part 2: {part_2}")
