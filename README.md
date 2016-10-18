# Compute Optimum Group Allocation
The algorithm computes a "good" (but not necessarily optimum) group allocation (for any given group size) based on a ranking matrix.
The ranking matrix contains each person's ranking where a relatively lower rank signals higher preference.

### Algorithm
The proposed algorithm starts from a randomly chosen valid initial solution and then iteratively improves the solution by swapping unstable pairs of students from different groups. The produced solution is therefore guaranteed to be stable for pairs of individuals but not necessarily for 3 or more individuals trading “under-the-table”. From that follows that the algorithm is likely to find a “good” solution but not necessarily an optimal solution.

### Complexity
The algorithm compares (N choose 2) ≈ N^2/2 pairs of students in each WHILE loop. In the worst case, the algorithm could start from the worst possible solution and in each WHILE loop iteration only move to the next-best solution, thus leading to brute-force-like performance.
Tests with an implemented version of the algorithm (in R), however, showed that for graphs of size 25, the algorithm converges after an average of 20 swaps and no more than 3 WHILE loop iterations. Thus, the algorithm is believed to be efficient in the average case.

### Tests
Further tests with different initializations for the same rank matrix confirmed that the algorithm only converges to a local minimum in the solution space. It is believed that the algorithm produces a good solution when run several times with different initializations and then choosing the solution with lowest total cost, however, by no means it can be guaranteed to have found the global optimum solution.
