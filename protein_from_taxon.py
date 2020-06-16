# -*- coding: utf-8 -*-
"""
Created on Tue May 12 15:37:37 2020

@author: chemk

this function takes 
    list of taxons 
    protein * opt
returns
    df containing the proteins corresponding to the query
    csv file containing the proteins corresponding to the query
       taxon_name[organism]AND protein_name[ALL]      (if the protein_name arg is used )

"""

from Bio import Entrez
from Bio import SeqIO
import pandas as pd
Entrez.email = "cheemkhi.ali13@gmail.com" 

"""add the optional parameter protein name  to look for  proteins that belongs to [taxon_name]""" 
def protein_from_taxon(taxon_name , protein_name="" , Rmax= 20) :
    print (type(taxon_name))
    if isinstance(taxon_name, list):    #len(taxon_name)>1 &   
      taxon_name=tuple(taxon_name)  
      query ="[Organism] OR ".join(taxon_name)
      query += "[Organism]"
      if protein_name == "":
          query =query
        
      else :
          protein_name+="[All Feilds]"
          query+= protein_name

    elif isinstance(taxon_name, str):
      print("string")
      query=str(taxon_name)+"[Organism]"
    

    #print (query)
    
 
    search_handle = Entrez.esearch(db="protein",term=query,
    usehistory="y", idtype="acc")
    search_results = Entrez.read(search_handle)
    search_handle.close()
    webenv = search_results["WebEnv"]
    query_key = search_results["QueryKey"]
    #count =search_results["Count"]
        
    
    
    """ESpell: Obtaining spelling suggestions
    """
#    
#    if protein_name=="":
#        Rmax=count 
#    
    fetch_handle = Entrez.efetch(
                db="protein",
                rettype="fasta",
                retmode="text",
                retstart=0, 
                retmax=Rmax,
                webenv=webenv,
                query_key=query_key,
                idtype="acc",
                
                )
    result=fetch_handle.read()
    with open ("protein.fasta","w") as f :
        f.write(result)
        
    records=SeqIO.parse("protein.fasta", "fasta")
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
    
    return df 

