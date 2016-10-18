# ----------------------------------------------------------------------
# Information
# ----------------------------------------------------------------------

# Creates random rank matrix of given size.
# Based on code from Nandan Rao
#
# (Author) Hans-Peter Höllwirth
# (Date)   09.10.2016

createPreferences <- function (n) {
    m <- matrix(rep(1, n**2), n)
    for (i in 1:n) {
        s <- sample(1:(n-1))
        m[, i] <- append(s, 0, i-1)
    }
    m
}

sumPreferences <- function (m) {
    size <- dim(m)[1]
    n <- matrix(rep(1, length(m)), size)
    for (i in 1:size) {
        for (j in 1:size) {
            n[i,j] <- m[i,j] + m[j,i]
        }
    }
    n
}

createAndSumPreferences <- function (n) {
    sumPreferences(createPreferences(n))
}

ranks <- createAndSumPreferences(25)

interactive <- TRUE
if (interactive) {
    setwd("/Users/Hans-Peter/Documents/Masters/Blog/Group Allocation")
    fileName <- "data/students25_2.txt"
} 

# load student ranks
write.csv(ranks, fileName)
