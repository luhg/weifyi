# UTF-8编码
BEGIN{
loadsource();
loadphrase3();
tranphrase3();
loadphrase2();
tranphrase2();
loadworddict();
tranworddict();
cncombine();
}
#1. 载入要翻译的文本，一词一行，原词\t原型\t词性\t短语\t是否生物名称
function loadsource(){
ntext=0;
while (getline < "input.txt"){
  ntext=ntext+1;
  text1[ntext]=$1;
  text2[ntext]=$2;
  text3[ntext]=$3;
  text4[ntext]=$4;
  }
}

#2. 载入3词短语翻译表
function loadphrase3(){
while (getline < "data/phrase3.txt"){
  phrase3[$1]=$2; #载入3词短语翻译表，词之间用_连接。
  }
}

#3. 翻译3词短语
function tranphrase3(){
for (i=3;i<=ntext;i++){
  myphrase=text2[i-2]"_"text2[i-1]"_"text2[i];
  if ( myphrase in phrase3 ){
    textcn[i-2]=phrase3[myphrase];
    textcn[i-1]="";
    textcn[i]="";
    }
  }
}

#4. 载入2词短语翻译表
function loadphrase2(){
while (getline < "data/phrase2.txt"){
  phrase2[$1]=$2; #载入2词短语翻译表，词之间用_连接。
  }
}

#5. 翻译2词短语
function tranphrase2(){
for (i=2;i<=ntext;i++){
  if (!( ( i in textcn ) || ( (i-1) in textcn ))){
    myphrase=text2[i-1]"_"text2[i];
    if ( myphrase in phrase2 ){
      textcn[i-1]=phrase2[myphrase];
      textcn[i]="";
      }
    }
  }
}

#6. 载入单词翻译表
function loadworddict(){
while (getline < "data/worddict.txt"){
  worddict[$1]=$2; #载入单词翻译表。
  }
}

#7. 翻译单词
function tranworddict(){
for (i=1;i<=ntext;i++){
  myphrase=tolower(text2[i]);
  if (!( i in textcn )){
    if ( myphrase in worddict ){
      textcn[i]=worddict[myphrase];
      }else{
      textcn[i]=text1[i];
      }
    }
  }
}

#8. 串联翻译结果
function cncombine(){
for (i=1;i<=ntext;i++){
  if (text4[i] ~ "B-"){printf " ";}
  if (text1[i] == "." && text4[i] == "O" ){printf "。"}
  else{printf textcn[i];}
  }
}
