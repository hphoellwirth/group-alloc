# ----------------------------------------------------------------------
# Information
# ----------------------------------------------------------------------

# Find optimal group allocation based on given rank matrix.
# Form group of 3s and fill up to 4 were necessary.
#
# (Author) Hans-Peter Höllwirth
# (Date)   09.10.2016


# ----------------------------------------------------------------------
# Loading data
# ----------------------------------------------------------------------

# house cleaning
rm(list = ls())

# if interactive, during the development, set to TRUE
interactive <- TRUE
if (interactive) {
    setwd("/Users/Hans-Peter/Documents/Masters/Blog/Group Allocation")
    loadFileName <- "data/students25_2.txt"
} 

# load student ranks
ranks <- read.csv(loadFileName, header = TRUE, sep = ",")[,-1]

# ----------------------------------------------------------------------
# Initialization of groups
# ----------------------------------------------------------------------

# randomly group students into initial groups of given size
# the first (num_students mod size) groups have size+1
init.groups <- function(num_students, size) {
    num_groups <- floor(num_students/size)
    larger_groups <- num_students %% size
    
    #groups <- rep(0, num_students)
    groups <- sample(num_students)
    cur_group <- 1
    group_members <- 0
 
    group_size <- size 
    if (larger_groups > 0)
        group_size <- group_size + 1
    
    for (i in 1:num_students) {
        if (group_members == group_size) {
            cur_group <- cur_group + 1
            group_members <- 0
            larger_groups <- larger_groups - 1
            if (larger_groups <= 0) 
                group_size <- size
        }
        group_members <- group_members + 1
        groups[which(groups == i)] <- cur_group
        #groups[i] <- cur_group
    }
    return(groups)
}

# ----------------------------------------------------------------------
# Compute total cost of given group allocation
# ----------------------------------------------------------------------

# compute rank cost for a particular student to its current group members
rank.cost <- function(student, groups, ranks) {
    group <- groups[student]
    
    cost <- 0
    for(i in 1:length(groups)) {
        if (groups[i] == group)
            cost <- cost + ranks[student, i]
    }
    return (cost)
}

#groups <- init.groups(nrow(ranks), 3)
#rank.cost(1, groups, ranks)

# compute total cost of given group allocation
total.costs <- function(groups, ranks) {
    cost <- 0
    for (i in 2:length(groups)) {
        for (j in 1:i) {
            if (groups[i] == groups[j])
                cost <- cost + ranks[i,j]
        }
    }
    return(cost)
}

# ----------------------------------------------------------------------
# Compute optimal group allocation
# ----------------------------------------------------------------------

# find optimal groups
optimal_groups <- function(ranks, gsize) {
    # initialize groups
    num_students <- nrow(ranks)
    groups <- init.groups(num_students, gsize)
    
    # keep optimizing until solution stays the same
    opt_found <- FALSE
    while (!opt_found) {
        old_groups <- groups

        # compare all n choose 2 pairs of vertices
        for (i in 1:num_students) {
            for (j in 1:num_students) {
                if (i != j && groups[i] != groups[j]) {
                    cur_cost <- rank.cost(i, groups, ranks) + rank.cost(j, groups, ranks)
                    
                    new_groups <- groups
                    new_groups[i] <- groups[j]
                    new_groups[j] <- groups[i]
                    new_cost <- rank.cost(i, new_groups, ranks) + rank.cost(j, new_groups, ranks)
                    
                    # swap students if new total cost is lower
                    if (new_cost < cur_cost) {
                        groups <- new_groups
                        #print(total.costs(groups, ranks))
                    }
                }
            }
        }
        print(groups)
        opt_found <- all(groups == old_groups)
    }
    print(total.costs(groups, ranks))
    return (groups)
}

optimal <- optimal_groups(ranks, 3)

test.convergence <- function(ranks, gsize, runs) {
    for (i in 1:runs) {
        optimal_groups(ranks, gsize)
    }
}

test.convergence(ranks, 3, 10)
