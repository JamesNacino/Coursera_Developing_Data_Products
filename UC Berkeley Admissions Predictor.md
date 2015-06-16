---
title: "UC Berkeley Admissions Predictor"
author: "James Nacino"
date: "Monday, June 15, 2015"
output: html_document
---

##Question
Is it possible to predict admittance to a specific department at UC Berkeley based only on gender?

##Introduction
Getting into a prestigous school like UC Berkeley is tough. I would like to know if there is any correlation between admittance rate and the variables: gender and Department. Using the 'datasets' package in R, I have loaded the UCBAdmissions dataset. This dataset consists of three variables. 

```
## Number of cases in table: 4526 
## Number of factors: 3 
## Test for independence of all factors:
## 	Chisq = 2000.3, df = 16, p-value = 0
```

```
##      Admit Gender Dept Freq
## 1 Admitted   Male    A  512
## 2 Rejected   Male    A  313
## 3 Admitted Female    A   89
## 4 Rejected Female    A   19
## 5 Admitted   Male    B  353
## 6 Rejected   Male    B  207
```

##Hypothesis
It is possible to predict a male or female student getting admitted into a specific department at UC Berkeley.

##Experiment
The department variable includes six different values (A,B,C,D,E, and F). From this we do not know if "A" corresponds to business, engineering, nursing, etc. I will collect all of the different departments of UC Berkeley through web scraping at their site "http://www.berkeley.edu/atoz/dept" and randomly select six different departments from the list. Then I will set the department values (A,B,C,D,E, and F) to one of the deparments that I randomly generated. Next, I will calculate the probability of each gender being accepted into the department. My shiny application will focus upon these probabilities. Each time the Shiny application will be loaded, there will be another set of random departments.

####Loading the packages and loading the dataset

```r
##Load packages
library(XML)
library(datasets)

##Create a data frame with the admissions data
df <- data.frame(UCBAdmissions)
head(df)
```

```
##      Admit Gender Dept Freq
## 1 Admitted   Male    A  512
## 2 Rejected   Male    A  313
## 3 Admitted Female    A   89
## 4 Rejected Female    A   19
## 5 Admitted   Male    B  353
## 6 Rejected   Male    B  207
```

####Web scraping the UC Berkeley website to gather the list of their departments

```r
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
final_depts[1:40]
```

```
##  [1] "Aerospace Studies"                                              
##  [2] "African American Studies"                                       
##  [3] "Agricultural and Resource Economics"                            
##  [4] "Air Force"                                                      
##  [5] "American Cultures"                                              
##  [6] "American Studies"                                               
##  [7] "Ancient History and Mediterranean Archaeology"                  
##  [8] "Anthropology"                                                   
##  [9] "Applied Science and Technology Graduate Group"                  
## [10] "Architecture"                                                   
## [11] "Army"                                                           
## [12] "Art History"                                                    
## [13] "Art Practice"                                                   
## [14] "Arts & Humanities, College of Letters & Science Division"       
## [15] "Asian American Studies"                                         
## [16] "Asian Studies"                                                  
## [17] "Astronomy"                                                      
## [18] "Biochemistry, Comparative"                                      
## [19] "Bioengineering"                                                 
## [20] "Biological Sciences, College of Letters and Science Division of"
## [21] "Biology, Integrative"                                           
## [22] "Biology, Molecular and Cell"                                    
## [23] "Biology, Plant and Microbial"                                   
## [24] "Biophysics"                                                     
## [25] "Biostatistics"                                                  
## [26] "Buddhist Studies"                                               
## [27] "Business"                                                       
## [28] "Canadian Studies Program"                                       
## [29] "Celtic Studies"                                                 
## [30] "Department of Chemical and Biomolecular Engineering"            
## [31] "Chemistry, College of"                                          
## [32] "Chemistry, Department of  "                                     
## [33] "Chicano Studies"                                                
## [34] "City and Regional Planning"                                     
## [35] "Civil and Environmental Engineering"                            
## [36] "Classics"                                                       
## [37] "Cognitive Science"                                              
## [38] "College Writing Programs"                                       
## [39] "Communications, Mass"                                           
## [40] "Comparative Biochemistry"
```

####Create the modified dataset replacing alphabet characters with actual department names

```r
##Pick six random departments at UCB
rand_depts_gen <- sample(final_depts, 6)

##Assign the values (A,B,C,D,E,F) of the departments column an actual department name from the randomly generate 
assign_depts <- vector()
for (i in 1:6){
temp <- rep(rand_depts_gen[i], times=4)
assign_depts <- append(assign_depts, temp)
}
df$steps <- assign_depts
```

Here is the modified dataset which replaces the departments with actual names.

```
##      Admit Gender Dept Freq                      steps
## 1 Admitted   Male    A  512 Chemistry, Department of  
## 2 Rejected   Male    A  313 Chemistry, Department of  
## 3 Admitted Female    A   89 Chemistry, Department of  
## 4 Rejected Female    A   19 Chemistry, Department of  
## 5 Admitted   Male    B  353    Law & Economics Program
## 6 Rejected   Male    B  207    Law & Economics Program
```

####Modify the dataset again to include the probability of each gender being admitted into the department

```r
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
head(df)
```

```
##      Admit Gender Dept Freq                      steps Probability
## 1 Admitted   Male    A  512 Chemistry, Department of        62.1 %
## 2 Rejected   Male    A  313 Chemistry, Department of        37.9 %
## 3 Admitted Female    A   89 Chemistry, Department of        82.4 %
## 4 Rejected Female    A   19 Chemistry, Department of        17.6 %
## 5 Admitted   Male    B  353    Law & Economics Program      63.0 %
## 6 Rejected   Male    B  207    Law & Economics Program      37.0 %
```
