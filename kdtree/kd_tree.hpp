#ifndef KD_TREE_CPP
#define KD_TREE_CPP

#include <iostream>
#include <algorithm>
#include <functional>
#include <vector>
#include <memory>
#include <iterator>
#include <queue>
#include <cmath>

struct Point {
    std::vector<float> coord_;

    Point(std::vector<float> point) : coord_(point) {}

    static float norm(const Point& p1, const Point& p2) {
        double sum = 0;
        auto p2_itr = p2.coord_.begin();
        for (auto p1_itr = p1.coord_.begin(); p1_itr != p1.coord_.end(); ++p1_itr) {
            sum += std::pow(*p2_itr - *p1_itr, 2);
            ++p2_itr;
        }
        return std::sqrt(sum);
    }
};

std::ostream& operator<<(std::ostream& os, const Point & p) {
    os << "(";
    for (auto it = p.coord_.begin(); it != p.coord_.end(); ++it) {
        os << *it << ", ";
    }
    return os << ")";
}

class KDTree {
protected:
    struct Node {
        Node(const Point& p) : p_(p), left_(nullptr), right_(nullptr) {}
    
        Point p_;
        std::shared_ptr<Node> left_;
        std::shared_ptr<Node> right_;
    };

public:
    KDTree(
        std::vector<Point>& points,
        int partition_limit=3, 
        int kdim = 2): partition_limit_(partition_limit), kdim_(kdim), root_(nullptr) {
        
        std::cout << "Constructing KD Tree..." << std::endl;
        root_ = buildKDTreeRecurse(points.begin(), points.end(), 0);
    }

    // Quick level order traversal print
    void printTree() {
        if (root_ == nullptr) {
            return;
        }

        std::queue< std::shared_ptr<Node> > level;
        level.push(root_);

        int depth = 0;
        bool valid_nodes_in_level = true;
        while (valid_nodes_in_level) {
            valid_nodes_in_level = false;
            std::queue< std::shared_ptr<Node> > new_level;
            std::cout << "Depth " << depth << ": ";
            
            while(level.size()) {
                auto node = level.front();
                level.pop();

                if (node) {
                    std::cout << node->p_ << ", ";
                } else {
                    std::cout << "[NULL], ";
                }
                
                if (node && node->left_) {
                    valid_nodes_in_level = true;
                    new_level.push(node->left_);
                } else {
                    new_level.push(nullptr);
                }
                if (node && node->right_) {
                    valid_nodes_in_level = true;
                    new_level.push(node->right_);
                } else {
                    new_level.push(nullptr);
                }
            }
            std::cout << std::endl;

            level = new_level;
            ++depth;
        }
    }

    void insert(const Point& p ) {
        if (root_ == nullptr) {
            return;
        }

        auto curr_node = root_;
        int depth = 0;
        while(true) {
            if (p.coord_[depth % kdim_] < curr_node->p_.coord_[depth % kdim_]) {
                if (curr_node->left_) {
                    ++depth;
                    curr_node = curr_node->left_;
                } else {
                    curr_node->left_ = std::make_shared<Node>(p);
                    break;
                }
            } else {
                if (curr_node->right_) {
                    ++depth;
                    curr_node = curr_node->right_;
                } else {
                    curr_node->right_ = std::make_shared<Node>(p);
                    break;
                }
            }
        }
    }

    // Find NN
    std::shared_ptr<Node> findNN(const Point& p) {
        return findNNRecurse(root_, p, 0);
    }

private:

    std::shared_ptr<KDTree::Node> buildKDTreeRecurse(
        std::vector<Point>::iterator front, 
        std::vector<Point>::iterator back, 
        int depth = 0) {

        if ((back - front) <= 0) {
            return nullptr;
        }
        
        // Select which coordinate tree level will use for comparison
        int axis = depth % kdim_;

        // Sort points to get median
        std::sort(front, back, [axis] (auto& p1, auto& p2) -> bool {
            return p1.coord_[axis] < p2.coord_[axis];
        });
        
        int mid = (back - front) / 2;

        // Push all values equal to median value on one side
        while (mid > 0 && (*(front+mid-1)).coord_[axis] == (*(front+mid)).coord_[axis]) {
            --mid;
        }

        auto node_ptr = std::make_shared<Node>(*(front+mid));
        node_ptr->left_ = buildKDTreeRecurse(front, front + mid, depth + 1);
        node_ptr->right_ = buildKDTreeRecurse(front + mid + 1, back, depth + 1);

        return node_ptr;
    }

    std::shared_ptr<Node> findNNRecurse(
        std::shared_ptr<Node> node, 
        const Point& p, 
        int depth = 0) {

        if (node == nullptr) {
            return node;
        }

        int axis = depth % kdim_;

        std::shared_ptr<Node> subtree, other_subtree;
        if (p.coord_[axis] < node->p_.coord_[axis]) {
            subtree = node->left_;
            other_subtree = node->right_;
        } else {
            subtree = node->right_;
            other_subtree = node->left_;
        }

        // Retreives closest node in one half of subtree
        auto closest_node = findNNRecurse(subtree, p, ++depth);
        closest_node = closerOfNodes(p, closest_node, node);

        // If the closest node has a distance farther than the current splitting axis
        // then there could be a node that is closer to point p
        if (Point::norm(p, closest_node->p_) > std::abs(p.coord_[axis] - node->p_.coord_[axis])) {
            auto other_closer_node = findNNRecurse(other_subtree, p, ++depth);
            closest_node = closerOfNodes(p, closest_node, other_closer_node);
        }

        return closest_node;
    }

    std::shared_ptr<Node> closerOfNodes(
        const Point& center, 
        std::shared_ptr<Node> node1, 
        std::shared_ptr<Node> node2) {

        if (node1 == nullptr) return node2;
        if (node2 == nullptr) return node1;

        auto dist1 = Point::norm(center, node1->p_);
        auto dist2 = Point::norm(center, node2->p_);

        return (dist1 < dist2) ? node1 : node2;
    }
    
    int partition_limit_;

    // The dimension of the points
    int kdim_;

    std::shared_ptr<Node> root_;
};

#endif // KD_TREE_CPP