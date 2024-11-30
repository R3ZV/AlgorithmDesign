#include "../include/maze.h"

Maze::Maze(std::vector<std::vector<char>> maze,
           char wall_symbol,
           char path_symbol)
    : grid(maze),
      wall_symbol(wall_symbol),
      path_symbol(path_symbol),
      di{-1, 1, 0, 0},
      dj{0, 0, -1, 1}
{}

bool Maze::inside_grid(int i, int j) {
    return 0 <= i && i < (int)grid.size() &&
           0 <= j && j < (int)grid[0].size();
}

void Maze::fill(size_t i, size_t j, std::vector<std::vector<bool>> &vis) {
    for (size_t dir = 0; dir < di.size(); dir++) {
        int new_i = i + di[dir];
        int new_j = j + dj[dir];

        if (inside_grid(new_i, new_j) && grid[new_i][new_j] == path_symbol &&
            !vis[new_i][new_j]) {

            vis[new_i][new_j] = true;
            fill(new_i, new_j, vis);
        }
    }
}

int Maze::components() {
    int res = 0;
    std::vector<std::vector<bool>> vis(grid.size(), std::vector<bool>(grid[0].size(), false));

    for (size_t i = 0; i < grid.size(); i++) {
        for (size_t j = 0; j < grid[i].size(); j++) {
            if (vis[i][j] || grid[i][j] != path_symbol) continue;

            fill(i, j, vis);
            ++res;
        }
    }

    return res;
}

