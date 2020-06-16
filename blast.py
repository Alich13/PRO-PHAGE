# Msg :
# "script hedha yblasti a partir mel ID aal Blast NCBI : el mochkla eli fih maykharjli chay la erreur la resultat
# normalement "NCBIXML.parse" traja3 un objet type blast , hedha yraja3li generator object !!! mafhmtch aalech"

from Bio.Blast import NCBIWWW
from Bio.Blast import NCBIXML
import sys,os
%%time
import time
start_time = time.time()

    
    
result_handle = NCBIWWW.qblast("blastp", "nr", "MKKMLFSAALAMLITGCAQQTFTVGNKPTAVTPKETITHHFFVSGIGQEKTVDAAKICGGAENVVKTETQQTFVNGFLGFITLGIYTPLEARVYCSQ")#enter input accession id or seq

with open(my_filename, "w") as out_handle:
    out_handle.write(result_handle.read())
    
result_handle = open("myblast.xml") 
#blast_record = NCBIXML.read(result_handle)   
blast_records =list( NCBIXML.parse(result_handle))
result_handle.close()
#blast_record =blast_records[0]
#blast_record.descriptions[0].__dict__
#blast_record.alignments[0].hsps[0].__dict__




for blast_record in blast_records :
    for alignment in blast_record.alignments:
        for hsp in alignment.hsps:
            if hsp.expect < 0.04 :

                #print("sequence:", alignment.title)
                print("length:", alignment.length)
                print("e value:", hsp.expect)
                print("match:", hsp.match)


print("--- %s seconds ---" % (time.time() - start_time))

