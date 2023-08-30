# Author: T.T. Chen
# Date: 2023-0824
# Purpose: visualize data in given student database, 
# especially looking for correlations between variables within the dataset

# set up
library(ggplot2)
library(knitr)
library(kableExtra)
library(plyr)  # must come first
library(dplyr)
library(reshape2)

# import data
students <- student.mat
rm(student.mat)
View(students)
attach(students)

# test out some visualizations on studytime and final math grade!!
View(studyGrade)
plot(studytime, G3, main="final grade vs. time studied")
abline(lm(G3~studytime), col="red")
cor(students$studytime, students$G3) # correlation = 0.09781969
ggplot(students, aes(x=studytime, y=G3)) + geom_point() + ggtitle("final grade vs. time studied")

# try looking at first & second term grades too!
studyGrade <- data.frame(studytime, G1, G2, G3)
studyGradeCor <- cor(studyGrade)
View(studyGradeCor)

# spent a lot of item trying to make this work but it does not look so good...
image(studyGradeCor, xlab="studytime       G1       G2       G3", ylab="studytime       G1       G2       G3")
#ggplot(studyGradeCor, aes(studytime, G1)) + geom_tile()


##############################################################################
# now trying the ggplot heatmap customizable!!! 
# --> the following code is adapted from http://www.sthda.com/english/wiki/ggplot2-quick-correlation-matrix-heatmap-r-software-and-data-visualization

#helper function to get upper triangle of the correlation matrix (lower tri becomes NA)
get_upper_tri <- function(cormat){
  cormat[lower.tri(cormat)]<- NA
  return(cormat)
}

# helper function to reorder with hierarchical clustering to see patterns better
reorder_cormat <- function(cormat){
  # Use correlation between variables as distance
  dd <- as.dist((1-cormat)/2)
  dd
  hc <- hclust(dd)
  hc
  cormat <-cormat[hc$order, hc$order]
  cormat
}

# for later pretty labels
cormat <- round(studyGradeCor, 2)

# reorder cormat to highlight patterns
reordered_cormat <- reorder_cormat(cormat)

# get upper triangle
upper_tri <- get_upper_tri(reordered_cormat)

# reshape2 melts the correlation matrix into input format, removing the NA parts!!!
melted_cormat <- melt(upper_tri, na.rm = TRUE)


# create heatmap
ggheatmap <- ggplot(data = melted_cormat, aes(Var2, Var1, fill = value)) +
  
  # colors
  geom_tile(color = "white") +
  scale_fill_gradient2(low = "#488f31", high = "#de425b", mid = "white", 
                       midpoint = 0, limit = c(-1,1), space = "Lab", 
                       name="Pearson\nCorrelation") +
  
  # layout
  theme_minimal()+ 
  theme(axis.text.x = element_text(angle = 45, vjust = 1, 
                                   size = 12, hjust = 1)) +
  coord_fixed()  # ensures units on x-axis = units on y-axis.

# customize!!
ggheatmap + 
  # add correlation coefficients
  geom_text(aes(Var2, Var1, label = value), color = "black", size = 4) +
  
  ggtitle("\nTime Studied & Grades for Semester1 (G1),\nSemester2 (G2), and Final (G3)") +
  

  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    panel.grid.major = element_blank(),
    panel.border = element_blank(),
    panel.background = element_blank(),
    axis.ticks = element_blank(),
    
    # change legend position!
    legend.justification = c(1, 0),
    legend.position = c(0.45, 0.75),
    legend.direction = "horizontal") +
    
    guides(fill = guide_colorbar(barwidth = 7, barheight = 1,
                               title.position = "top", title.hjust = 0.5))

# end
detach(students)
