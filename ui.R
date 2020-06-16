# load the shinydashboard package
library(shiny)
library(shinyjs)
require(shinydashboard)
library(dplyr)
library(DT)
library(shinycssloaders)
#library(shinybusy)





phages_names<- read.csv('./data/phages_names_hosts.csv',stringsAsFactors = F,header=T)


header <- dashboardHeader(title = "PRO PHAGE" )
                     

 

sidebar <- dashboardSidebar(
  sidebarMenu( id ="tabs",
               
    menuItem("About", tabName = "About", icon = icon("book")),
    menuItem("Dashboard", tabName = "dashboard", icon =icon("dna")),
    menuItem("Visit-us", icon = icon("send",lib='glyphicon'),  href = "https://www.salesforce.com"),
    conditionalPanel(
      condition = "input.btn2 == 1",
      menuItem("Results", tabName = "Results", icon = icon("poll"))
    )
  
))

'"-------------------------------------frows --------------------------------------------"'

frow1 <- fluidRow(

  h1("About *************** start now insights /automate /phago therapy "),
  
  tags$style(HTML('#btn3{background-color:limegreen}')),
  actionButton("btn3", "start",width= "80%" ,icon= icon("start"), position = "right"),
  br(),
  valueBoxOutput("profAcc"),
  valueBoxOutput("marketShare"),
  valueBoxOutput("profitMargin")
)




frow4 <- fluidRow(
  
  box(h5("  what to do****************************note that these records are up to date with nr blast")),
  
  tabBox(
    title = ""
    ,width = 10
    ,id = "dataTabBox"
    ,tabPanel(
      title = "Find  Protein "
      ,DT::dataTableOutput('phages_names')%>% withSpinner(color="#0dc5c1")
      ,br()
      ,tags$head(
        tags$style(HTML('#btn1{background-color:limegreen}',
                        '#btn2{background-color:limegreen}')))
      ,actionButton("btn1", "SEARCH",width= "80%" ,icon= icon("search"))
      ,br()
      ,br()
    )
    ,tabPanel(
      title = "Import  Protein ",
      textAreaInput('query1', 'Input sequence:', value = "", placeholder = "", width = "600px", height="200px"),
      fileInput("file", label = h3("File input (fasta format) ")),
      helpText("import your Fasta file"),
      actionButton("submit", "submit", value=FALSE)
      ,div(class = "busy",  
           p("Calculation in progress ... this may take a while "), 
           img(src="https://i.stack.imgur.com/8puiO.gif", height = 500, width = 500,align = "center")
      )
      
      
     
    )
  )
      ,conditionalPanel(
      condition = "input.btn1 >= 1" 
      ,DT::dataTableOutput('protein')%>% withSpinner(color="#0dc5c1")
      ,width=10
      ,br()
      
      ,actionButton("btn2", "Scan",width= "80%", icon = icon("server"))
      
      ,div(class = "busy",  
          p("Calculation in progress ... this may take a while "), 
          img(src="https://i.stack.imgur.com/8puiO.gif", height = 500, width = 500,align = "center")
      )
      
    )
    
    
    
    )      
      
    
    
  


frow5<-fluidRow(
  DT::dataTableOutput('protein_single')%>% withSpinner(color="#0dc5c1"),
  #DT::dataTableOutput('patts')%>% withSpinner(color="#0dc5c1"),
  uiOutput('align'),
  #plotOutput("MSAplot"),
  fluidRow(style='margin: 0px;',
  box(width="100%",
  tags$div(id="fv1"))
  ),
  
  tags$script(src="test2.js"),
  div(style="display:inline-block",
  selectInput("db", "Databse:", c("swissprot"="swissprot","non-redundant protein db (nr)"= "nr","pdb"="pdbaa"), width="120px")
  ),
  div(
  style="display:inline-block",
  selectInput("program", "Program:", choices=c("blastp"), width="100px")),
  div(
  style="display:inline-block",
  selectInput("eval", "e-value:", choices=c(1,0.001,1e-4,1e-5,1e-10), width="120px")),
  
  tags$br(),
  actionButton("btn_blast", "Run Blast",width= "50%", icon = icon("server")),
  
   div(class = "busy",
       p("Calculation in progress.."),
       img(src="https://i.stack.imgur.com/8puiO.gif", height = 500, width = 500,align = "center")
   ),
  

  tags$div(id="fv2"),
    
  
  tags$script(src="test2.js")
  
  
  
)

#tag$link(rel="stylesheet", type="text/css", href="feature-viewer.min.css")
#tags$script(src="https://cdn.jsdelivr.net/gh/calipho-sib/feature-viewer@v1.0.6/dist/feature-viewer.min.js")
'" -------------------------------------body----------------------------------------------------------------"'
# combine the three fluid rows to make the body
body <- dashboardBody(
  tagList(
    tags$head(
      tags$link(rel="stylesheet", type="text/css",href="style.css"),
      tags$script(type="text/javascript", src = "busy.js")
      )),
  tags$head(
    #tag$link(rel="stylesheet", type="text/css", href="feature-viewer.min.css"),
    tags$link( rel="stylesheet", type="text/css", href="https://cdn.jsdelivr.net/gh/calipho-sib/feature-viewer@v1.0.6/dist/feature-viewer.min.css"),
    tags$script (src="http://d3js.org/d3.v3.min.js" , charset="utf-8"),
    #tags$script (src="https://cdn.jsdelivr.net/gh/calipho-sib/feature-viewer@v1.0.6/dist/feature-viewer.bundle.js")
    tags$script(src="https://cdn.jsdelivr.net/gh/calipho-sib/feature-viewer@v1.0.6/dist/feature-viewer.min.js")
    
      ),
  
  tabItems(
    tabItem(tabName = "About", 
            frow1
            
    ),
    
    
    tabItem(tabName = "dashboard",
            
            frow4
    ),
    
    
   
    
     tabItem(tabName = "Results",
              shinyjs::useShinyjs(),
              h1("Res***************  now "),
              frow5
             )
    
  )
)
    
  
  
  
  
  
  


ui <- dashboardPage(header, sidebar, body, skin='green')
