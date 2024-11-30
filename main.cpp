#include <iostream>
#include <vector>

#include "./include/maze.h"

int main() {
    size_t n, m;
    std::cin >> n >> m;

    std::vector<std::vector<char>> grid(n, std::vector<char>(m));
    for (size_t i = 0; i < n; i++) {
        for (size_t j = 0; j < m; ++j) {
            std::cin >> grid[i][j];
        }
    }

    Maze res = Maze(grid, '#', '.');
    std::cout << res.components() << std::endl;
}
