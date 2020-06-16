# -*- coding: utf-8 -*-
"""
Created on Sat Apr 18 20:38:32 2020

@author: chemk
"""
from Bio import ExPASy
from Bio.ExPASy import ScanProsite
from Bio.ExPASy import Prosite
import pandas as pd
import webbrowser
import os



sequence = "MKKMLFSAALAMLITGCAQQTFTVGNKPTAVTPKETITHHFFVSGIGQEKTVDAAKICGGAENVVKTETQQTFVNGFLGFITLGIYTPLEARVYCSQ"

def Scan_Prosite(entry,sk="off"):
    """  Scan_Prosite takes as arg : 
        entry = Uniprot ID ,PDB or SEQ 
        skip  = (default ="off" ) if "on" 
                skip patterns and profiles with hight probabilty 
                
    returns :
        df =(matchs and other features (start,end ,id,score...))
        number_of_matchs
        csv file corresponding to df
        
        """

    handle = ScanProsite.scan( entry ,skip=sk)
    #By executing handle.read(), you can obtain the search results in raw XML format. Instead, let’s use
    #Bio.ExPASy.ScanProsite.read to parse the raw XML into a Python object:
    result = ScanProsite.read(handle)

    data={}
    dict_list=['sequence_ac', 'start', 'stop', 'signature_ac', 'score', 'level']
    data.fromkeys(dict_list)
    data = {k: [] for k in dict_list}
    df = pd.DataFrame(data)
    for k in result:
        df=df.append(k, ignore_index=True)
   
    number_of_matchs=result.n_match
    #df.to_csv("my_prosite_hits.csv")
    return (df )





def get_documentation (accession):
    """
    get_documentation  function gets as arg :
        accesion (signature_ac example "PS00001" )
    returns 
        html file containing full documentaion 
    """
    
    handle_1 = ExPASy.get_prosite_raw(accession)
    records = Prosite.read(handle_1)
    handle_2 = ExPASy.get_prodoc_entry (records.pdoc) 
    #record = Prodoc.read(handle_2)"
    html = handle_2.read()  
    with open("my_prodoc_record.html", "w") as out_handle:
        out_handle.write(html) 
        
    #path = os.path.abspath('my_prodoc_record.html')
    #url = 'file://' + path
    #webbrowser.open(url)
    



    
         
  
