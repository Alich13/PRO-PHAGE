# load the shinydashboard package
library(shiny)
library(shinyjs)
require(shinydashboard)
library(DT)
library(shinycssloaders)
#library(shinybusy)





phages_names<- read.csv('./data/phages_names_hosts.csv',stringsAsFactors = F,header=T)



header <- dashboardHeader(title ="PROPHAGE"
)




sidebar <- dashboardSidebar(
  sidebarMenu( id ="tabs",
               tags$img(src="1zs4.jpg", height = '225', width = '225'),
               
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
  
  tags$a(href= "http://www.insat.rnu.tn/Fr/accueil_46_34" ,  tags$img(src="insat.png", height = '100', width = '200' ,align= 'right' )),
  
  tags$img(src="prophage.png", height = '100', width = '100' ,align= 'right' ),
  
  hr(tags$style(HTML("width:50%;text-align:left;margin-left:0"))),
  h1("Welcome to PROPHAGE"),
  hr(tags$style(HTML("width:50%;text-align:left;margin-left:0"))),
  
  
  
  box(width="100%",
      tags$div(HTML(' PROPHAGE is a web tool that automates and facilitates the analysis and annotation of primary sequences of Bacteriophages proteins allowing the prediction of different sites, domains and  presenting the results in interactive and  friendly-User visualization 
                    <br />The study, comparison and determination of such  protein domaines are made possible thanks to bioinformatics tools like
                    <a rel="ScanPROSITE" href="https://prosite.expasy.org/scanprosite">ScanPROSITE,</a>   
                    <a rel="BLAST" href="https://blast.ncbi.nlm.nih.gov/Blast.cgi">BLAST,</a>
                    <a rel="Clustal" href="https://www.ebi.ac.uk/Tools/msa/clustalo/"> Clustal</a>
                    ... ,which allows us in this case to study the evolution, structure and functions of phages proteins .<br />
                    So our job is to exploit these tools in a synergistic way '),
               hr(),
               p("A search bar in the website interface allows direct and instant access to general protein databases such as NCBI nr,SWISSPROT and PDB PDBaa .") 
      )
      
      
      ),
  
  
  hr(tags$style(HTML("width:50%;text-align:left;margin-left:0"))),
  hr(tags$style(HTML("width:50%;text-align:left;margin-left:0"))),
  valueBoxOutput("SWISSPROT"),
  valueBoxOutput("PDB"),
  valueBoxOutput("nr"),
  hr(),
  tags$style(HTML('#btn3{background-color:#72FF33}')),
  actionButton("btn3", "START NOW ",width= "50%" ,icon= icon("start"), align = "center"),
  hr(),
  tags$div(HTML(' <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/">
                
                </a><br />PROPHAGE is a web tool developed as part of the end-of-year project in the National Institute of Applied Science and Technology under a 
                <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/">Creative Commons Attribution-NonCommercial 4.0 International License</a><br/>
                <hr/>
                <img alt="Creative Commons License"   width="100" height="50"  style="border-width:10" 
                src="https://i.creativecommons.org/l/by-nc/4.0/88x31.png" />
                ')),
  br()
  
  
  
  )




frow4 <- fluidRow(
  
  box(h2("Start by importing or retrieving your protein !")),
  
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
  ,conditionalPanel(condition = "input.btn1 >= 1",
                    tabBox(title="",
                           width = 10,
                           
                           tabPanel(
                             title = "Find  Protein "       
                             
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
    #   tags$script(scr="shiny-server-client.js"),
    #   tags$script(src="shiny-server-client.min.js")
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
