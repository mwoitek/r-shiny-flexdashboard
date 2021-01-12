library(shiny)
library(tidyverse)
library(plotly)
library(DT)

#####Import Data

dat<-read_csv(url("https://www.dropbox.com/s/uhfstf6g36ghxwp/cces_sample_coursera.csv?raw=1"))
dat<- dat %>% select(c("pid7","ideo5","newsint","gender","educ","CC18_308a","region"))
dat<-drop_na(dat)

#####Make your app

ui <- 
server<-function(input,output){
  
  #####Hint: when you make the data table on page 3, you may need to adjust the height argument in the dataTableOutput function. Try a value of height=500
  
} 

shinyApp(ui,server)