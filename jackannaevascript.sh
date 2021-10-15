##Usage: bash jackannaevescript.sh then cat finaltable.csv
##Usage: used to find best proteome canidates for ph resistant methanogens
##Usage: delete previous outputtable.csv each time before running script
#two individual for loops used to run muscle and align  the different fasta files for the hsp and mcrA genes
#hsp loop
for number in {1..22}
do
~/Private/muscle -in ./ref_sequences/hsp70gene_$number.fasta -out hspoutput
done
#mcrA loop
for mcrA in {1..18}
do
~/Private/muscle -in ./ref_sequences/mcrAgene_$mcrA.fasta -out mcrAoutput
done

#Hmmr used with the aligned files from muscle to produce two search images, one for each of the genes
~/Private/hammer/bin/hmmbuild resultshsp hspoutput
~/Private/hammer/bin/hmmbuild resultsmcrA mcrAoutput

#for loop used to run a search for each of the genes in each of the proteome files
for number in ./proteomes/*.fasta
do
#assign new variable used for naming which is the number in the proteome file 
name=$(echo $number | cut -d_ -f 2 | cut -d. -f 1)
#uses hmmr search to produce a results file of the matches for each gene in each proteome file
~/Private/hammer/bin/hmmsearch --tblout match${name}resultshsp.search resultshsp $number
~/Private/hammer/bin/hmmsearch --tblout match${name}resultsmcrA.search resultsmcrA $number
#two new variables with the number of matches for the hsp and mcrA genes in the proteome files
hsp70match=$(cat match${name}resultshsp.search | grep -v "#" | wc -l)
mcramatch=$(cat match${name}resultsmcrA.search | grep -v "#" | wc -l)
#create an output table with each of the variables (proteome, proteome number, hsp matches, mcrA matches)
echo "proteome", ${name}, ${hsp70match}, ${mcramatch} >> outputtable.csv
done

#sort the final output table based on the number of mcrA matches, followed by the nubmer of hsp matches and put into a final table with the best candidates for pH-resistant methanogens at the top
cat outputtable.csv | sort -r -t, -k4 -k3 > finaltable.csv 

