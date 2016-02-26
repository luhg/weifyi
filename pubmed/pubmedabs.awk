BEGIN{
"date +%Y%m%d" | getline current_time;
close("date +%Y%m%d");
#print current_time;
while (getline <"jsci.txt"){
  topjournal[$1]=1
  };
}
/\<PubmedArticle\>/,/\<\/PubmedArticle\>/{
   if ($0 ~ "<PubmedArticle>") {
     jname="";pmid="";volume="";page="";doi="";year="";month="";day="";title="";abstract="";
     nauthor=0;issne="";issnp="";
     }
  if ($0 ~ "<LastName") {
     nauthor=nauthor+1;
     author[nauthor]=subpub($0);
  }
  if ($0 ~ "<PMID") { 
     pmid=subpub($0);
     }
  if ($0 ~ "<AbstractText") {
     abstract=abstract""subpub($0)" ";
     }
  if ($0 ~ "<ArticleTitle") {
     title=subpub($0);
     }
  if ($0 ~ "<ISOAbbreviation") {
     jname=subpub($0);
     jfile=subpub($0);
     gsub(/ /,"_",jfile);
     gsub(/\//,"_",jfile);
     gsub(/\(/,"",jfile);
     gsub(/\)/,"",jfile);
     gsub(/\./,"",jfile);
     #print jfile;
     }
  if ($0 ~ "<MedlinePgn") {
     page=subpub($0);
     }
  if ($0 ~ "<ISSN IssnType=\"Print\">") {
     issnp=subpub($0);
     }
  if ($0 ~ "<ISSN IssnType=\"Electronic\">") {
     issne=subpub($0);
     }
  if ($0 ~ "<ELocationID" || ($0 ~ "<ArticleId" && $0 ~ "doi") ) {
     doi=subpub($0);
     }
  if ($0 ~ "<JournalIssue") {
     while ($0 !~ "</JournalIssue") {
       getline;
       if ($0 ~ "<Volume>") {volume=subpub($0);}
       if ($0 ~ "<Issue>") {issue=subpub($0);;}
       if ($0 ~ "<Year>") {year=subpub($0);}
       if ($0 ~ "<Month>") {month=subpub($0);}
       if ($0 ~ "<Day>") {day=subpub($0);}
       }
     } 
   if ($0 ~ "</PubmedArticle>") {
     allauthor=author[1];
     if (nauthor < 11){
     for (i=2;i<=nauthor ;i++) {
       allauthor=allauthor", "author[i];
       }
      }else{
     for (i=2;i<=10;i++) {
       allauthor=allauthor", "author[i];
       }
     allauthor=allauthor", et. al";
     }
     if (length(issnp < 9)){issnp=issne}
     if (length(abstract) > 10){
       #print "DATE: "current_time"\nTITLE: "title"\nAUTHORS: "allauthor"\nREF: "jname", "year", "volume", "page", DOI: "doi"\nABSTRACT: "abstract"\n" >> "../data/"jfile".txt"; 
       print title"\n"abstract"\n" >> "../data/"jfile".txt"; 
       }
}
}

function subpub(pubstr){ 
  nbegin=index(pubstr,">");
  pubstr=substr(pubstr,nbegin+1)
  nend=index(pubstr,"<");
  return substr(pubstr,1,nend-1)
}
