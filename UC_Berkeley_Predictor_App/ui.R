##run the "UCB Admissions Predictor.R" script before running the shiny app
source("UCB Admissions Predictor.R", echo=TRUE)

##NOTE!!! The app takes a couple seconds to load
shinyUI(pageWithSidebar(
      
      headerPanel("UC Berkeley Admissions Predictor"),
      sidebarPanel(
        radioButtons('Depart', "Department",
                           c(unique(df$Dept)[1], unique(df$Dept)[2],
                             unique(df$Dept)[3], unique(df$Dept)[4],
                             unique(df$Dept)[5], unique(df$Dept)[6])),
        radioButtons('Gend', "Gender",
                           c("Male" = "Male", "Female" = "Female"))

      ),
      mainPanel(
        h3("Admissions Predictor"),
        h4('This is your probability of getting into this department'),
        verbatimTextOutput("prediction"))))
