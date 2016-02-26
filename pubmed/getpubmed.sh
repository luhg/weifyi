#!/bin/sh
rm -f newest.txt
wget -O newest.txt "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=\%222015/09/01\%22[CRDAT]%20:%20\%223000\%22[CRDAT]"
maxpmid=`gawk '/<Id>/{id=substr($1,5,8);print int(id/500)*500;exit;}' newest.txt`
beginpmid=`tail -1 pmid.txt`
echo $maxpmid >> pmid.txt
begin=`echo $beginpmid +1|bc`;
step=500;
end=$maxpmid;
while [[ ${begin} -lt ${end} ]];
  do
  echo ${begin},${step},${end}
  pmid=`gawk -v awkb=${begin} -v awks=${step} 'BEGIN{pmids=awkb;for (i=1;i<=awks-1;i++){pmids=pmids","awkb+i;};print pmids}'`
  echo ${pmid}
  wget -O ${begin}_${step}.xml "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&retmode=xml&id=${pmid}"
  gzip ${begin}_${step}.xml
  mv ${begin}_${step}.xml.gz ../data/
  begin=`echo ${begin} + ${step}|bc`
done
