# Author: T.T. Chen
# Date: 2023-0824
# Purpose: visualize data in given student database, 
# especially looking for correlations between variables within the dataset

# set up
library(ggplot2)
library(knitr)
library(kableExtra)
library(dplyr)

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

# spent a lot of itme trying to make this work but it does not look so good...
image(studyGradeCor, xlab="studytime       G1       G2       G3", ylab="studytime       G1       G2       G3")
#ggplot(studyGradeCor, aes(studytime, G1)) + geom_tile()

# end
detach(students)