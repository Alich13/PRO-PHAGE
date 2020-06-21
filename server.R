library("reticulate")
library("shinyjs")
library("jsonlite", lib.loc="/usr/local/lib/R/site-library")
require(XML)
library(plyr)
library(dplyr)
library(DT)
library(seqinr)
#library(adegenet)
library(ape)
library(ggtree)
library(DECIPHER)
library(viridis)
library(ggplot2)
library("ggmsa")
rm(list = ls())
source_python("protein_from_taxon.py")
source_python("prosite.py")
source_python("retrieve_protein_byid.py")
source_python("splitR.py")
Sys.setenv(BLASTDB="/home/ali/blastdb")
Sys.setenv(PATH=paste(Sys.getenv("PATH"), "/home/ali/ncbi-blast-2.10.0+/bin" , sep=":"))

server <- function(input, output,session) { 
  
  setwd("~/shiny_app")
  phages_names<- read.csv('./data/phages_names_hosts.csv',stringsAsFactors = F,header=T)
  phages_names=phages_names[-c(1)]
  
 
 
  
  output$profAcc <- renderValueBox({
    valueBox(
      formatC(prof.account$value, format="d", big.mark=',')
      ,paste('Top Account:',prof.account$Account)
      ,icon = icon("stats",lib='glyphicon')
      ,color = "purple")
    
    
  })
  
  
  
  output$marketShare <- renderValueBox({
    
    valueBox(
      formatC(total.revenue, format="d", big.mark=',')
      ,'Total Expected Revenue'
      ,icon = icon("gbp",lib='glyphicon')
      ,color = "green")
    
  })
  
  output$profitMargin <- renderValueBox({
    
    valueBox(
      formatC(prof.prod$value, format="d", big.mark=',')
      ,paste('Top Product:',prof.prod$Product)
      ,icon = icon("menu-hamburger",lib='glyphicon')
      ,color = "yellow")
    
  })
  
  observeEvent(input$btn3,{
    updateTabItems(session, "tabs", selected = "dashboard")
    
  })
  
  

  protein_by_tx <- NULL 

  output$phages_names <-DT::renderDataTable( phages_names,server = FALSE , filter = "top")
  obs1<-observeEvent(input$btn1, {
    y12=input$phages_names_rows_selected
    phages= phages_names[y12,1]
   
    protein_by_tx <<- protein_from_taxon(phages, protein_name="" , Rmax= 20)
    output$protein  <-DT::renderDataTable(protein_by_tx ,server = FALSE , selection='single' ,options = list(
      autoWidth = TRUE,
      columnDefs = list(list(width = '50px', targets = "_all" ,scrollX=TRUE ))
    )) 
    
  
  
  
  })
  
 
  

  
patterns=NULL
se=NULL 

tmp=NULL


submit<-observeEvent(input$submit,{
    query <- input$query1
    tmp <- tempfile(fileext = ".fa")
  
    # This reactive function will take the inputs from UI.R and use them for read.table() to read     the data from the file. It returns the dataset in the form of a dataframe.
    # file$datapath -> gives the path of the file
    
    file1 <- input$file
    print(file1)
    
    if(!(is.null(file1)))
      {
      
    
    print ("file")
    data_file=read.table(file= file1$datapath ,skip = 1)
   
    query<-read.table(file = file1$datapath ,header = F,nrows = 1 ,sep = "")
    con <- file(file1$datapath,"r")
    first_line <- readLines(con,n=1)
    close(con)
    query=first_line
    for (p in data_file[,1]) {
      query<-paste(query,p,sep='\n')
    }
    print (query)
    
    }
    
    
    
    
      
    if (startsWith(query, ">"))
          {
          writeLines(query, tmp)
          se_table <-read.table(tmp ,skip="1",sep="")
          se=""
          for (p in se_table[,1]) {
            se<-paste(se,p,sep='')
          }
          se<<-se
          print("se with <")
          print(se)
          
        }
        else
        {
          writeLines(paste0(">Query\n",query), tmp)
          se_table <-read.table(tmp ,skip="1",sep="")
          se=""
          for (p in se_table[,1]) {
            se<-paste(se,p,sep='')
          }
          se<<-se
        }
        
          x <- data.frame("Query" = "my query", "seq" = c(se))
          output$protein_single  <-DT::renderDataTable(x ,server = FALSE ,options = list(
          autoWidth = TRUE,
          columnDefs = list(list(width = '50px', targets = "_all" ,scrollX=TRUE ))))
          
          updateTabItems(session, "tabs", selected = "Results")
          patterns<<- Scan_Prosite(se,sk="off")
          #output$patts<-DT::renderDataTable(patterns,server = FALSE ,selection='single') 
          shinyjs::addClass(selector = "body", class = "sidebar-collapse")
          Sys.sleep(2)
          shinyjs::removeClass(selector = "body", class = "sidebar-collapse")
          session$sendCustomMessage("seq",se)
          patts=toJSON(patterns, pretty=TRUE)
          session$sendCustomMessage("DT",patts)
        
          
        })   
          
          
          
         
        
btn_2<-observeEvent(input$btn2,{        
       
      
   
      y11=input$protein_rows_selected
      protein_by_tx = protein_by_tx[y11,]
      output$protein_single  <-DT::renderDataTable(protein_by_tx ,server = FALSE ,options = list(
      autoWidth = TRUE,
      columnDefs = list(list(width = '50px', targets = "_all" ,scrollX=TRUE ))
         )) 
      se<<-protein_by_tx[1,4]
      
      

      updateTabItems(session, "tabs", selected = "Results")
      
      patterns<<- Scan_Prosite(se,sk="off")
      #output$patts<-DT::renderDataTable(patterns,server = FALSE ,selection='single') 
      shinyjs::addClass(selector = "body", class = "sidebar-collapse")
      Sys.sleep(2)
      shinyjs::removeClass(selector = "body", class = "sidebar-collapse")
      session$sendCustomMessage("seq",se)
      patts=toJSON(patterns, pretty=TRUE)
      session$sendCustomMessage("DT",patts)
     
      })
      
  
      
      
  
  
 
  
  
  
  
  
  
  
  '"---------------------------------------------blast-------------------------------------------------"'
  db=NULL
  blast_results=NULL
  aligned=NULL
  obs4 <- observeEvent(input$btn_blast, {
  
  shinyjs::hide("btn_blast", "db" ,"eval" ,"program")
  shinyjs::hide( "db" )
  shinyjs::hide("eval" )
  shinyjs::hide("program")
  #gather input and set up temp files
  query <- se
  db<<-input$db
  tmp <- tempfile(fileext = ".fa")


    if ( input$db == "nr")
    {
      db <- c("nr")
      #add remote option for nr since we don't have a local copy
      remote <- c("-remote")
    }else
    {
      remote=" "
    }

    #this makes sure the fasta is formatted properly
    if (startsWith(query, ">")){
      writeLines(query, tmp)
    } else {
      writeLines(paste0(">Query\n",query), tmp)
    }

    #calls the blast
    data <- system(paste0(input$program," -query ",tmp," -db ",input$db ," -evalue ",input$eval,"  -outfmt 5 -max_hsps 1 -max_target_seqs 20 ", remote), intern = T)
    print ("data")
    print (data)
    
    blastresults<-xmlParse(data)

    if (is.null(blastresults)){}
    
    else {
        xmltop = xmlRoot(blastresults)
        # hits_exist <- xpathApply(blastresults, '//Iteration',function(row){
        #   hit_ <- getNodeSet(row, 'Iteration_hits//Hit') %>% sapply(., xmlValue)}
        #   )
        #print(hits_exist)
        #the first chunk is for multi-fastas
        results <- xpathApply(blastresults, '//Iteration',function(row){
          query_ID <- getNodeSet(row, 'Iteration_query-def') %>% sapply(., xmlValue)
          hit_accs <- getNodeSet(row, 'Iteration_hits//Hit//Hit_accession') %>% sapply(., xmlValue)
          hit_defs <- getNodeSet(row, 'Iteration_hits//Hit//Hit_def') %>% sapply(., xmlValue)
          hit_length <- getNodeSet(row, 'Iteration_hits//Hit//Hit_len') %>% sapply(., xmlValue)
          bitscore <- getNodeSet(row, 'Iteration_hits//Hit//Hit_hsps//Hsp//Hsp_bit-score') %>% sapply(., xmlValue)
          eval__ <- getNodeSet(row, 'Iteration_hits//Hit//Hit_hsps//Hsp//Hsp_evalue') %>% sapply(., xmlValue)
          start_pos <- getNodeSet(row, 'Iteration_hits//Hit//Hit_hsps//Hsp//Hsp_query-from') %>% sapply(., xmlValue)
          stop_pos <- getNodeSet(row, 'Iteration_hits//Hit//Hit_hsps//Hsp//Hsp_query-to') %>% sapply(., xmlValue)
          hseq <- getNodeSet(row, 'Iteration_hits//Hit//Hit_hsps//Hsp//Hsp_hseq') %>% sapply(., xmlValue)
          
          
          cbind(query_ID,hit_accs,hit_defs,hit_length,bitscore,eval__,start_pos,stop_pos,hseq)
        })
        #this ensures that NAs get added for no hits
        results <- rbind.fill(lapply(results,function(y){as.data.frame((y),stringsAsFactors=FALSE)}))
        print(class(results))
        
        print ("results")
        
        print (results)
        print (dim(results))
        
        if ( dim(results) == c(1,1) )
          {
          print("no  blast")
          message="No blast found in the corresonding Database"
          session$sendCustomMessage("no_blast",message)
        }
        
        else{
          print("no c(1(1")
          results=toJSON(results, pretty=TRUE)
          session$sendCustomMessage("blast",results)
          blast_results<-fromJSON(results) %>% as.data.frame
          #print (blast_results$hit_accs)
          blast_results<<-retreivebyID (blast_results$hit_accs)
          print(blast_results)
          
          seqs <- readAAStringSet("protein_uniprot.fasta", format = "fasta")
          names(seqs)=splitR(names(seqs))
          if (length(seqs)>1){
            aligned <<- AlignSeqs(seqs)
            writeXStringSet(aligned,
                            file="Amanita_aligned.fasta")
            prot<- read.alignment("Amanita_aligned.fasta", format = "fasta")
            
            D <- dist.alignment(prot, matrix = "similarity")
            temp <- as.data.frame(as.matrix(D))
            #table.paint(temp, cleg=0, clabel.row=.5, clabel.col=.5)+ scale_color_viridis()
            
            tre <- nj(D)
            tre <- ladderize(tre)
            tre.new <- tre
            # change tip labels to full alignment names
            tre.new$tip.label <- aligned@ranges@NAMES
            
            
            ggtre1 <- ggtree(tre) + geom_tiplab(size=3)
            
            ggtre2 <- ggtree(tre) + geom_tiplab(size=3)
            msaplot(ggtre2, "Amanita_aligned.fasta" , offset=0.5, width=2)
            
            output$tree1<-renderPlot({
              plot(ggtre1, cex = 0.6)
              
            })
            output$tree2<-renderPlot({
              plot(ggtre2, cex = 0.6)
              
            })
            
            
            
            output$align <-renderUI( {
              fluidRow(style='margin: 0px;',
                       
                       
                       box(width="50%",
                           tags$img(src = "55.png", width = "300px", height = "200px"),
                           
                           actionLink("MSA", "See full Multiple Sequences  Alignment ")
                       ),
                       tabBox(width="50%",
                              title = "phylo tree",
                              
                              tabPanel(title = "basic tree",
                                        plotOutput("tree1")
                              ),
                              tabPanel(title = "MSA tree",
                                        plotOutput("tree2")
                              )
                              
                       )
                       
                       
                       
              )
              
              
            })
            
            
            
            
            
            
            
            '""
        #BrowseSeqs(aligned, highlight=0)
        writeXStringSet(aligned,
                        file="Amanita_aligned.fasta")
        prot<- read.alignment("Amanita_aligned.fasta", format = "fasta")
        
        D <- dist.alignment(prot, matrix = "similarity")
        temp <- as.data.frame(as.matrix(D))
        table.paint(temp, cleg=0, clabel.row=.5, clabel.col=.5)+ scale_color_viridis()
        
        tre <- nj(D)
        class(tre)
        tre <- ladderize(tre)
        plot(tre, cex = 0.6)
        h_cluster <- hclust(D, method = "average", members = NULL) # method = average is used for UPGMA, members can be equal to NULL or a vector with a length of size D
        plot(h_cluster, cex = 0.6)
        
        ""'
            
            
          }
        }
        
    }})
  '"******************************************************************************"'
  obsalign<-observeEvent(input$MSA, {
    BrowseSeqs(aligned, highlight=0)
  })
  
  library(stringr)
  obs3<-observeEvent(input$docs, {
    print("yeah url D3")
    handle<-input$docs 
    
    
    if ( (substr(handle$description, 1, 2) == "PS" ) && ( str_length(handle$description)==7)  ) {
      print ("patterns")
      get_documentation (handle$description)
      browseURL("my_prodoc_record.html")
    } 
    
    else  if  (str_length(handle$description > 7)) 
    {
      
      print ("blast")
      uniprot_id=handle$id
      session$sendCustomMessage("uniprot_id",uniprot_id)
      
      
      seq_blast<-blast_results$seq[ blast_results$ID_ == uniprot_id]
      
     
      patterns_blast<<- Scan_Prosite(seq_blast,sk="off")
      session$sendCustomMessage("seq_blast",seq_blast)
      session$sendCustomMessage("db",db)
      patts_blast=toJSON(patterns_blast, pretty=TRUE)
      session$sendCustomMessage("DT_blast",patts_blast)
      
      
      
    }
    
    else {
      print ("blast else")
    }
    
    
    #output$pa_=renderPrint(input$docs)
    
    
  })
  
  
  
  obs4<-observeEvent(input$docs2, {
    print("yeah url D3 2")
    handle<-input$docs2 
    
    
    if ( (substr(handle$description, 1, 2) == "PS" ) && ( str_length(handle$description)==7)  ) {
      print ("patterns")
      get_documentation (handle$description)
      browseURL("my_prodoc_record.html")
    } 
    
    else  
    {
     print ("nothing") 
      
    }
    
   
    
    #output$pa_=renderPrint(input$docs)
    
    
  })
  
    

  
  #Now to parse the results...
 
  
  
  
  
  
  
  uiState <- reactiveValues()
  uiState$readyFlag <- 0
  uiState$readyCheck <- 0
  
 
  
  
  

}


#shinyApp(ui, server)