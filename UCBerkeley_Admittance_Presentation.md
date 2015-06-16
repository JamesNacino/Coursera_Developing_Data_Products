UC Berkeley Admittance Presentation
========================================================
author: James Nacino
date: 6/16/2015
width: 1440
height: 900

Question & Hypothesis
========================================================

**Question**

Is it possible to predict admittance to a specific department at UC Berkeley based only on gender?

**Hypothesis**

It is possible to predict a male or female student getting admitted into a specific department at UC Berkeley.


Experiment
========================================================

Getting into a prestigous school like UC Berkeley is tough. I would like to know if there is any correlation between admittance rate and the variables: gender and Department. Using the 'datasets' package in R, I have loaded the UCBAdmissions dataset. This dataset consists of three variables and 4526 records. The department variable includes six different values (A,B,C,D,E, and F). From this we do not know if "A" corresponds to business, engineering, nursing, etc. I will collect all of the different departments of UC Berkeley through web scraping at their site "http://www.berkeley.edu/atoz/dept" and randomly select six different departments from the list.


Web scraping the UC Berkeley website to gather the list of their departments
========================================================



```r
for (i in 1:26) {
  letter <- LETTERS[i]
  deptsUrl <- "http://www.berkeley.edu/atoz/dept/"
  deptsUrl <- paste(deptsUrl,letter, sep="")
  doc <- htmlTreeParse(deptsUrl, useInternal=TRUE)
  depts <- xpathSApply(doc, "//div[@class='list-content']//a", xmlValue)
  depts <- sub("\n +", "", depts)
  final_depts <- append(final_depts, depts)}
final_depts[1:3]
```

```
[1] "Aerospace Studies"                  
[2] "African American Studies"           
[3] "Agricultural and Resource Economics"
```


Original vs. Final Dataset
========================================================


```
     Admit Gender Dept Freq
1 Admitted   Male    A  512
2 Rejected   Male    A  313
3 Admitted Female    A   89
4 Rejected Female    A   19
5 Admitted   Male    B  353
6 Rejected   Male    B  207
```

```
     Admit Gender          Dept Freq Probability
1 Admitted   Male Media Studies  512      62.1 %
2 Rejected   Male Media Studies  313      37.9 %
3 Admitted Female Media Studies   89      82.4 %
4 Rejected Female Media Studies   19      17.6 %
5 Admitted   Male       Physics  353      63.0 %
6 Rejected   Male       Physics  207      37.0 %
```
