##Load the datasets and XML package
library(datasets)
library(XML)

##Create a data frame with the admissions data
df <- data.frame(UCBAdmissions)

##Extract all departments from UC Berkeley webpages 
final_depts <- vector()
#Using 26 because there are 26 different webpages of departments. One page for each letter in the alphabet
for (i in 1:26) {
  letter <- LETTERS[i]
  deptsUrl <- "http://www.berkeley.edu/atoz/dept/"
  deptsUrl <- paste(deptsUrl,letter, sep="")
  doc <- htmlTreeParse(deptsUrl, useInternal=TRUE)
  depts <- xpathSApply(doc, "//div[@class='list-content']//a", xmlValue)
  depts <- sub("\n +", "", depts)
  final_depts <- append(final_depts, depts)
}

##Pick six random departments at UCB
rand_depts_gen <- sample(final_depts, 6)

##Assign the values (A,B,C,D,E,F) of the departments column an actual department name from the randomly generated departments
assign_depts <- vector()
for (i in 1:6){
temp <- rep(rand_depts_gen[i], times=4)
assign_depts <- append(assign_depts, temp)
}
df$Dept <- assign_depts

##Calculate the probabilities for gender admittance into each department
Probability <- vector()
for (i in 1:6){
  temp <- df[df$Dept==unique(df$Dept)[i],]
  temp_male <- temp[temp$Gender=="Male",]
  temp_male2 <- sum(temp_male$Freq)
  temp_male3 <- temp_male$Freq[1]/temp_male2
  Probability <- append(Probability, temp_male3)
  temp_male4 <- temp_male$Freq[2]/temp_male2
  Probability <- append(Probability, temp_male4)
  temp_fmale <- temp[temp$Gender=="Female",]
  temp_fmale2 <- sum(temp_fmale$Freq)
  temp_fmale3 <- temp_fmale$Freq[1]/temp_fmale2
  Probability <- append(Probability, temp_fmale3)
  temp_fmale4 <- temp_fmale$Freq[2]/temp_fmale2
  Probability <- append(Probability, temp_fmale4)
}
df <- cbind(df, Probability)
df$Probability <- round(df$Probability, digits=3) ##Round two three decimal places
df$Probability <- sprintf("%.1f %%", 100*df$Probability) ##Format probability as percentage
