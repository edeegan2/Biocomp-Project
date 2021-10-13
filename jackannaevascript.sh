for number in {1..22}
do
~/Private/muscle -in ./ref_sequences/hsp70gene_$number.fasta -out hspoutput
done
for mcrA in {1..18}
do
~/Private/muscle -in ./ref_sequences/mcrAgene_$mcrA.fasta -out mcrAoutput
done

~/Private/hammer/bin/hmmbuild resultshsp hspoutput
~/Private/hammer/bin/hmmbuild resultsmcrA mcrAoutput


for number in ./proteomes/*.fasta
do
name=$(echo $number | cut -d_ -f 2 | cut -d. -f 1)
~/Private/hammer/bin/hmmsearch --tblout match${name}resultshsp.search resultshsp $number
~/Private/hammer/bin/hmmsearch --tblout match${name}resultsmcrA.search resultsmcrA $number
done


