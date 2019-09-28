#include <iostream>
#include <vector>
#include <fstream>
#include <sstream>
#include <string>

#include "kd_tree.hpp"

// Read in points from a file specified by filename
// A single line in the filename has the format <x> <y>
std::vector<Point> readPointsFromFile(const std::string& filename) {
    
    std::ifstream points_file(filename);
    std::vector<Point> points;
    
    std::string line;
    while (getline(points_file, line)) {
        std::stringstream ss(line);
        std::vector<float> coords;

        float val;
        while(ss >> val) {
            coords.push_back(val);
        }
        Point p{coords};
        points.push_back(p);
    }

    return points;
}

void printPoints(const std::vector<Point>& points) {
    for (auto it = points.begin(); it != points.end(); ++it) {
        std::cout << *it << ", ";
    }
    std::cout << std::endl;
}

int main(int argc, char* argv[]) {

    if (argc != 2) {
        std::cout << "Provide a file with a list of points" << std::endl;
        return 0;
    }

    const auto filename = std::string(argv[1]);
    std::cout << "Reading file: " << filename << std::endl;
    auto points = readPointsFromFile(filename);
    // printPoints(points);

    KDTree kd_tree(points);

    Point new_point{std::vector<float> {6, 8}};
    auto nn = kd_tree.findNN(new_point);

    std::cout << "NN: " << nn->p_ << std::endl;

    return 0;
}