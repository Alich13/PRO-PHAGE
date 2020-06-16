from Bio import Entrez
from Bio import SeqIO
import pandas as pd
Entrez.email = "cheemkhi.ali13@gmail.com"


def retreivebyID (query_list):
#"""args : list of protein accesion
#
#returns :fasta file containing multiple seq corresponding to these IDs

      if isinstance(query_list, list): 
        separator = ','
        query=separator.join(query_list)
        print (query)
        
      elif isinstance(query_list, str):
        query=query_list
        
      
      search_handle = Entrez.esearch(db="protein",term=query,usehistory="y", idtype="acc")
      search_results = Entrez.read(search_handle)
      search_handle.close()
      webenv = search_results["WebEnv"]
      query_key = search_results["QueryKey"]
      
     
          #count =search_results["Count"]
              
          
         
      #    
      #    if protein_name=="":
      #        Rmax=count 
      #    
      fetch_handle = Entrez.efetch(
                      db="protein",
                      rettype="fasta",
                      retmode="text",
                      retstart=0, 
                      retmax=20,
                      webenv=webenv,
                      query_key=query_key,
                      idtype="acc",
                      
                      )
      result=fetch_handle.read()
      with open ("protein_uniprot.fasta","w") as f :
        f.write(result)
      
      records=SeqIO.parse("protein_uniprot.fasta", "fasta")
      data={}
      dict_list=['seq', 'id', 'name','description']
                  
      data.fromkeys(dict_list)
      data = {k: [] for k in dict_list}
      
      for record in records:
          for k in dict_list:
              data[k].append(getattr(record,k))
      #print (data)        
      df = pd.DataFrame(data)
      
      #df.to_csv ('protein.csv', index = False, header=True)
      df = pd.DataFrame(data) 
      columnsName = list(df.columns)
      seq,I = columnsName.index("seq"), columnsName.index("id")
      columnsName[seq], columnsName[I] = columnsName[I],columnsName[seq]
      df = df[columnsName]
      df['seq'] = df['seq'].astype(str)
      
      columnsName = list(df.columns)
      seq,I = columnsName.index("seq"), columnsName.index("description")
      columnsName[seq], columnsName[I] = columnsName[I],columnsName[seq]
      df = df[columnsName]
      df['seq'] = df['seq'].astype(str)
      
      df['ID_'] = df.apply(lambda row: row["id"].split("|")[1].split(".")[0] , axis = 1) 
      
        
      return df 
