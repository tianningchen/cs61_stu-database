# Author: T.T. Chen
# Date: 2023-0824
# Purpose: visualize data in given student database, 
# especially looking for correlations between variables within the dataset

# Citation: most code adapted from http://www.sthda.com/english/wiki/visualize-correlation-matrix-using-correlogram

# set up
library(corrplot) # method 3
library(grDevices) # method 3
library(RColorBrewer) # method 3

# import data
students <- student.mat
rm(student.mat)
View(students)
attach(students)

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

############# LOOKING AT DISTRIBUTION OF TIME, ALC, GRADES ####################
# traveltime (1-4 graded scale, qualitative labels)
# studytime (1-4 graded scale, qualitative labels)
# activities (binary y/n)
# romantic (binary y/n)
# freetime (1-5)
# goout (1-5)
# Dalc (1-5)
# Walc (1-5)
# G3 (final math grade, 1-20)


############# variables with same number scale metric ####################
# create correlation matrix for easy numbered ones
cor(studytime, freetime)
cor(goout, Dalc)
numtime <- data.frame(freetime, goout, Dalc, Walc, G3)
numtime_cm <- cor(numtime)
numtime_cm

# create p-value matrix
p.mat <- cor.mtest(numtime_cm)
p.mat


# make color palette
col <- colorRampPalette(c("#488f31", "white","#de425b"))(200)

# corrplot(rawcormat, method="circle", type="lower", order="hclust",  col=c("black", "white"), bg="lightblue")
corrplot(numtime_cm, method="color", col=col, # scale colors (made it so smooth)
         type="lower", order="hclust",  
         addCoef.col = "black", # add coefficient label
         cl.pos = "r",
         tl.col="black", tl.srt=45,  # text color + string rotation
         # p.mat = p.mat, sig.level = 0.1,  # insig = "blank" would make it blank instead of crossed out!
         # diag=FALSE would hide coefficient along diagonal
         title="\n\n(Low-Significance) Correlations in Distribution of \n Time Spent & Final Math Grade",
         mar=c(0,2,4,2)  # margin to fix title position
         )


############# variables with quantitative description ####################
# create correlation matrix for all quantitatively described ones
qtime <- data.frame(studytime, traveltime, freetime, goout, Dalc, Walc, G3)
qtime_cm <- cor(qtime)
qtime_cm

# create p-value matrix
p.mat <- cor.mtest(qtime_cm)
p.mat


# make 20 of the colors in between? view legend again after you update next line!!
# corrplot(rawcormat, method="circle", type="lower", order="hclust",  col=c("black", "white"), bg="lightblue")
corrplot(qtime_cm, method="color", col=col, # scale colors (made it so smooth)
         type="lower",  order="hclust",  
         addCoef.col = "black", # add coefficient label
         cl.pos = "r",
         tl.col="black", tl.srt=45,  # text color + string rotation
         p.mat = p.mat, sig.level = 0.1,  insig = "blank",
         # diag=FALSE would hide coefficient along diagonal
         title="\n\n(A Few) Significant Correlations in \nDistribution of Time Spent & Final Math Grade",
         mar=c(0,2,4,2)  # margin to fix title position
)

############# all variables, forced as quantitive variables ####################
########### STILL TROUBLESHOOTING! WORK IN PROGRESS ###########################

alltime <- data.frame(studytime, traveltime, freetime, goout, Dalc, Walc, G3, romantic, activities)
alltime
alltime[!is.na(alltime$romantic)]
alltime$romantic[alltime$romantic=="yes"]=1
alltime$romantic[is.na(alltime$romantic)]=1
alltime
alltime_cm <- cor(qtime)
alltime_cm

# create p-value matrix
p.mat <- cor.mtest(qtime_cm)
p.mat


# make 20 of the colors in between? view legend again after you update next line!!
# corrplot(rawcormat, method="circle", type="lower", order="hclust",  col=c("black", "white"), bg="lightblue")
corrplot(qtime_cm, method="color", col=col, # scale colors (made it so smooth)
         type="lower",  order="hclust",  
         addCoef.col = "black", # add coefficient label
         cl.pos = "r",
         tl.col="black", tl.srt=45,  # text color + string rotation
         p.mat = p.mat, sig.level = 0.1,  insig = "blank",
         # diag=FALSE would hide coefficient along diagonal
         title="\n\n(A Few) Significant Correlations in \nDistribution of Time Spent & Final Math Grade",
         mar=c(0,2,4,2)  # margin to fix title position
)

# end
detach(students)
