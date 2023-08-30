# Author: T.T. Chen
# Date: 2023-0824
# Purpose: visualize data in given student database, 
# especially looking for correlations between variables within the dataset

# set up
library(ggplot2) # method 2
library(knitr)
library(kableExtra)
library(plyr)  # must come first, method 2
library(dplyr)
library(reshape2) # method 2
library(corrplot) # method 3
library(grDevices) # method 3 ?
library(RColorBrewer) # method 3

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

# bigger correlation matrix time!! try looking at first & second term grades too!
studyGrade <- data.frame(studytime, G1, G2, G3)
rawcormat <- cor(studyGrade)
View(rawcormat)

###################### METHOD 1 of CORMAT VISUALIZATION ##########################

# spent a lot of item trying to make this work but it does not look so good...
image(rawcormat, xlab="studytime       G1       G2       G3", ylab="studytime       G1       G2       G3")
#ggplot(rawcormat, aes(studytime, G1)) + geom_tile()


###################### METHOD 2 of CORMAT VISUALIZATION ##########################

# this method adapted from http://www.sthda.com/english/wiki/ggplot2-quick-correlation-matrix-heatmap-r-software-and-data-visualization

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
cormat <- round(rawcormat, 2)

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


###################### METHOD 3 of CORMAT VISUALIZATION ##########################

# this method adapted from http://www.sthda.com/english/wiki/visualize-correlation-matrix-using-correlogram

# helper function to experiment with adding p-value
  # mat : is a matrix of data
  # ... : further arguments to pass to the native R cor.test function
cor.mtest <- function(mat, ...) {
  mat <- as.matrix(mat)
  n <- ncol(mat)
  p.mat<- matrix(NA, n, n)
  diag(p.mat) <- 0
  for (i in 1:(n - 1)) {
    for (j in (i + 1):n) {
      tmp <- cor.test(mat[, i], mat[, j], ...)
      p.mat[i, j] <- p.mat[j, i] <- tmp$p.value
    }
  }
  colnames(p.mat) <- rownames(p.mat) <- colnames(mat)
  p.mat
}

# make p-value matrix
p.mat <- cor.mtest(rawcormat)
head(p.mat[,1:4])


# make 20 of the colors in between? view legend again after you update next line!!
# (set col=col)
# (or set col=brewer.pal(n=40, name="RdYlBu"))
col <- colorRampPalette(c("#488f31", "white","#de425b"))  # or could put (200) here too
corrplot(rawcormat, method="circle", type="upper", order="hclust",  col=c("black", "white"), bg="lightblue")
corrplot(rawcormat, method="color", col=col(200), # scale colors (made it so smooth)
         type="upper", order="hclust",  
         addCoef.col = "black", # add coefficient label
         cl.pos = "r",
         tl.col="black", tl.srt=45,  # text color + string rotation
         p.mat = p.mat, sig.level = 0.05,  # insig = "blank" would make it blank instead of crossed out!
         # diag=FALSE would hide coefficient along diagonal
         title="\n\nSignificant Correlations in Time Studied & \nGrades for Semester 1, 2, and Final (G1,2,3)",
         mar=c(0,2,4,2)  # margin to fix title position
         )


# experimenting with adding p



# end
detach(students)
