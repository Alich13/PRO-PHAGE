# -*- coding: utf-8 -*-
"""
Created on Mon May 11 23:30:56 2020

@author: chemk

"""
"""
taxon_serch  search for hits corresponding to the query 
Rmax is the max numebr of records to return s
-------------return-----------------------------
this function creates csv file containing the retrieved data
and a dataframe object df

"""
from Bio import Entrez
Entrez.email = "chemkhi.ali13@gmail.com"
Entrez.tool = "MyLocalScript"
import pandas as pd 

    

    
def taxon_search (org_name,Rmax):
    """don't forget to download PHages names""" 
    query=org_name+"[All Fields] AND species[Rank]"
    handle = Entrez.esearch(db="Taxonomy", term=query, usehistory="y",RetMax= Rmax )
    search_results = Entrez.read(handle)
    if search_results["Count"] <= search_results["RetMax"]:
        count=int(search_results["Count"])
    elif search_results["Count"] > search_results["RetMax"]:
        count=int(search_results["RetMax"])
    
    webenv = search_results["WebEnv"]
    query_key = search_results["QueryKey"]
    search_results
    
    
    data={}
    dict_list=['TaxId', 'ScientificName', 'Rank',
                'Division', 'GeneticCode', 'Lineage',
                 'CreateDate', 'UpdateDate', 'PubDate']
    data.fromkeys(dict_list)
    data = {k: [] for k in dict_list}
    
    for start in range(0, count , 1):
    
        print("Going to download record %i" % (start + 1))
        fetch_handle = Entrez.efetch(
                db="Taxonomy",
                
                retstart=start, 
                retmax=1,
                webenv=webenv,
                query_key=query_key,
                idtype="acc",
                
                )
        
        records=Entrez.read(fetch_handle)
        for i in dict_list :
            data[i].append(records[0][i])
        
    
    
    
    #df.to_csv ('taxon.csv', index = False, header=True)
        
    return df 


