BEGIN{
while (getline < "abb.txt"){
  for (i=1;i<=NF;i++){abb[$i]=1;}
  }
}
{
gsub("&gt;",">");
gsub("&lt;","<");
gsub("amp;","");
gsub(/[^a-zA-Z0-9\- ]/,"_&_");
gsub("__","_")
gsub("_ "," ")
gsub(" _"," ")
mystr="";
for (i=1;i<=NF;i++){
  if ($i ~ "_"){
    mystr=mystr" ";
    nw=split($i,wtmp,"_");
    for (j=1;j<=nw;j++){
      nabb=0;
      if (( wtmp[j] in abb) && (wtmp[j+1] == ".")){nabb=1;}
      nlow=0;
      nl=split(wtmp[j],ltmp,"");
      for (k=1;k<=nl;k++){if (ltmp[k] ~ /[a-z]/){nlow=nlow+1;}}
      if ((nlow > 1) && (nabb < 1)){mystr=mystr" ";}
      strtmp=wtmp[j];
      mystr=mystr""strtmp;
      if ((nlow > 1) && (nabb < 1)){mystr=mystr" ";}
      }
      if ((wtmp[nw] == ".") ){mystr=mystr"\n"}
    }else{
    mystr=mystr" "$i;
    if ((substr($i,length($i)) ~ /[.?!]/) && (!($(i-1) in abb ))){mystr=mystr"\n";}
    }
  }
gsub("^ ","",mystr);
gsub("^ ","",mystr);
gsub("\n ","\n",mystr);
gsub(" +"," ",mystr);
#gsub(/\(/,"-LRB-",mystr);
#gsub(/\)/,"-RRB-",mystr);
print mystr;
}
