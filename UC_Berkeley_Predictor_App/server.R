##You must run the "UCB Admissions Predictor.R" script before running the shiny app


admissionsprediction <- function(Gend, Depart){
  temp <- df[df$Gender==Gend & df$Dept==Depart & df$Admit=="Admitted",]
                                               temp$Probability}



shinyServer(
  function(input, output){
    output$prediction <- renderPrint({admissionsprediction(input$Gend, input$Depart)})
  })