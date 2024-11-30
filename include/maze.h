#pragma once

#include <vector>

class Maze {
    const std::vector<std::vector<char>> grid;
    const char wall_symbol;
    const char path_symbol;

    const std::vector<int> di, dj;

public:
    Maze(std::vector<std::vector<char>> maze,
         char wall_symbol,
         char path_symbol);

    bool inside_grid(int i, int j);
    void fill(size_t i, size_t j, std::vector<std::vector<bool>> &vis);
    int components();
};
