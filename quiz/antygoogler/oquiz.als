alias start {
  unset %oq*  
  if ($1 == $null) set %oqkanal $?="Podaj kanal, na ktorym bedzie uruchomiony quiz np: #oyey "
  else set %oqkanal $1
  set %oqplik $file="Wybierz plik z pytaniami" c:\*.txt
  oqload
  oqproc
}

alias oqload {
  .write -c oqag.txt
  .write -c oqag1.txt
  .write -c oqag2.txt
  .write -c oqag3.txt
  .write -c oqnicks.txt
  .write -c oqczasy.txt
  set %oqg 
  set %oqk1 0,01
  set %oqk0 8,01
  set %oqk1b 0,14
  set %oqk0b 8,14
  set %oqkpyt 12
  set %oqkpkt 15
  set %oqodp 1
  set %oqdelay 5
  set %oqnump 1
  set %oqnumo 2
  set %oqohpodp 0
  set %oqnrpyt 0
  set %oqpytania $lines(%oqplik) / 2
  .ial on
  set %oqnag 8,0%0,8%9,8%8,9%3,9%9,3%5,3%3,5%1,5%5,1%1,1-5,1-4,1-7,1-8,1-0,1=  oyey-quiz  =8,1-7,1-4,1-5,1-1,1-5,1%1,5%3,5%5,3%9,3%3,9%8,9%9,8%0,8%8,0%
  msg %oqkanal %oqnag
  msg %oqkanal %oqk0 Antygoogler %oqk1 $+ - Wiesz lub nie.  Wystartowal... 
}

alias oqproc {
  if (%oqnumo > $lines(%oqplik)) { oqprocend }
  else { unset %oqoh* %oqpodp*
    .disable #czytaj
    inc %oqnrpyt
    set %oqohpodp 0
    set %oqodp 1
    set %oqstaw 3
    %oqq = $right($read(%oqplik,%oqnump),$calc($len($read(%oqplik,%oqnump))-4))
    %oqa = $right($read(%oqplik,%oqnumo),$calc($len($read(%oqplik,%oqnumo))-4))
    oqhint
    set %oqpodp1 %oqohntext
    unset %oqohntext %oqohnowytekst
    oqhint
    set %oqpodp2 %oqohntext
    unset %oqohntext %oqohnowytekst
    oqhint
    set %oqpodp3 %oqohntext
    unset %oqohntext %oqohnowytekst
    set %oqastart $uptime(mirc)
    .timerczytaj 1 %oqdelay .enable #czytaj
    .timerdelay 1 %oqdelay msg %oqkanal %oqk1 Pytanie %oqnrpyt z %oqpytania $+ :  $+ %oqkpyt %oqq
    .timerpodp0 1 %oqdelay msg %oqkanal %oqk1 Podpowiedz %oqkpkt $+ (3p) $+ %oqk1 $+ :  %oqkpyt %oqpodp1
    inc %oqnumo 2
    inc %oqnump 2
    if (%oqodp == 1) {
      .timerpodp1a 1 $calc(%oqdelay + 8) set %oqstaw 2
    .timerpodp1b 1 $calc(%oqdelay + 8.1) msg %oqkanal %oqk1 Podpowiedz %oqkpkt $+ (2p) $+ %oqk1 $+ :  %oqkpyt %oqpodp2 }
    if (%oqodp == 1) {
      .timerpodp2a 1 $calc(%oqdelay + 14) set %oqstaw 1
    .timerpodp2b 1 $calc(%oqdelay + 14.1) msg %oqkanal %oqk1 Podpowiedz %oqkpkt $+ (1p) $+ %oqk1 $+ :  %oqkpyt %oqpodp3 }
    .timerpodpenda 1 $calc(%oqdelay + 20) unset %oqa
    .timerpodpenda 1 $calc(%oqdelay + 20) msg %oqkanal %oqk1 Odpowiedz to %oqk0 %oqa %oqk1 Za chwile nastepne pytanie... 
  .timerpodpendc 1 $calc(%oqdelay + 20) oqproc }
}

#czytaj on
on 1:TEXT:%oqa:%oqkanal: pkt $nick
alias -l pkt {
  .timerpodp* off
  set %oqodp 0
  rankg $nick %oqstaw
  if (%oqstaw = 3) rantg $nick
  %oqtodp = $calc($uptime(mirc) - %oqastart - %oqdelay * 1000)
  %oqtnor = $calc(%oqtodp / 1000)
  %oqdlodp = $len(%oqa)
  ranks $nick
  set %oqstawwait %oqstaw
  if (%oqstaw > 1) { msg %oqkanal %oqk0 %oqstaw $+ %oqk1 punkty dla %oqg %oqk0 $+ $nick $+ %oqk1 %oqg za $+ %oqk0 %oqa $+ %oqk1 $+ %oqk1 czas: $+ %oqk0 %oqtnor $+ %oqk1 sek. Punktow: $+ %oqk0 %oqsuma $+ %oqk1 Pozycja: $+ %oqk0 %oqplace %oqk1 }
  else { msg %oqkanal %oqk0 %oqstaw $+ %oqk1 Punkt dla %oqg %oqk0 $+ $nick $+ %oqk1 %oqg za $+ %oqk0 %oqa $+ %oqk1 $+ %oqk1 czas: $+ %oqk0 %oqtnor $+ %oqk1 sek. Punktow: $+ %oqk0 %oqsuma $+ %oqk1 Pozycja: $+ %oqk0 %oqplace %oqk1 }
  set %oqa2 %oqa
  unset %oqa
  set %oqpier $nick
  set %oqpierial $address($nick,1) 
  .enable #wait
  .timerwait 1 1 .disable #wait
  unset %oqstat
  if (%oqnumo > $lines(%oqplik)) { oqprocend }
  else { .timerdel 1 1 msg %oqkanal %oqk1 Za chwile nastepne pytanie...  |  oqproc  }
}
#czytaj end

#wait off
on 1:TEXT:%oqa2:%oqkanal: pkt2 $nick   
alias -l pkt2 {
  if ((%oqpier != $nick) && (%oqpierial != $address($nick,1))) {
    rankg $nick %oqstawwait
    if (%oqstawwait = 3) rantg $nick   
    if (%oqstawwait > 1) { msg %oqkanal %oqk1b Extra $+ %oqk0b %oqstawwait $+ %oqk1b punkty dla %oqg $+ %oqk0b $+ $nick $+ %oqk1b $+ %oqg Punktow: %oqk0b $+ %oqsuma $+ %oqk1b Pozycja: $+ %oqk0b %oqplace $+ %oqk1b %oqk1 }
    else { msg %oqkanal %oqk1b Extra $+ %oqk0b %oqstawwait $+ %oqk1b punkt dla %oqg $+ %oqk0b $+ $nick $+ %oqk1b $+ %oqg Punktow: %oqk0b $+ %oqsuma $+ %oqk1b Pozycja: $+ %oqk0b %oqplace $+ %oqk1b %oqk1 }
    unset %oqa2
  }
}
#wait end


alias oqprocend {
  .timer1 1 1 msg %oqkanal 0,4 Nie ma wiecej pytan. 
  %oqmaks = $calc(%oqpytania * 3)
  %oqwinner = $left($read(oqag.txt,1),$pos($read(oqag.txt,1),$chr(32)))
  %oqwinpts = $remove($read(oqag.txt,1),%oqwinner)
  %oqagmax = $round($calc(%oqwinpts / %oqmaks * 100),0)
  %oqagile = $read(oqag2.txt,s,%oqwinner)
  %oqagpkty = $round($calc(%oqagile * 3 * 100 / %oqwinpts),0)
  %oqnickwinner = $read(oqnicks.txt,s,%oqwinner)
  .timer2 1 2 msg %oqkanal %oqk1 Zwyciezca %oqk0 %oqnickwinner %oqk1 ma %oqk0 $+ %oqagmax $+ % $+ %oqk1 z mozliwych punktow (w tym %oqk0 $+ %oqagpkty $+ % $+ %oqk1 antygooglowych) 
}

alias oqhint {
  %oqohspace = $chr(32)
  %oqohgw = $chr(42)
  %oqohtekst1 = $replace(%oqa,%oqohspace,$chr(21))
  %oqohdlugosc = $len(%oqa)
  if (%oqohpodp = 0) {
    var %oqohz 1
    while (%oqohz <= %oqohdlugosc) {
      %oqohlitera = $mid(%oqa,%oqohz,1)
      if (%oqohlitera = %oqohspace) {
      set %oqohlit $chr(21) }
      elseif ((%oqohlitera < 10) && (%oqohlitera >= 0 )) {
      set %oqohlit %oqohgw }
      elseif (%oqohlitera = $chr(34)) { 
      set %oqohlit $chr(34) }
      elseif (%oqohlitera = $chr(44)) {
      set %oqohlit $chr(44) }
      elseif (%oqohlitera = $chr(46)) {
      set %oqohlit $chr(46) }
      elseif (%oqohlitera = $chr(45)) {
      set %oqohlit $chr(45) }
      elseif (%oqohlitera = $chr(33)) {
      set %oqohlit $chr(33) }
      elseif (%oqohlitera = $chr(37)) {
      set %oqohlit $chr(37) }
      elseif (%oqohlitera = $chr(39)) {
      set %oqohlit $chr(39) }
      elseif (%oqohlitera = $chr(40)) {
      set %oqohlit $chr(40) }
      elseif (%oqohlitera = $chr(41)) {
      set %oqohlit $chr(41) }
      elseif (%oqohlitera = $chr(58)) {
      set %oqohlit $chr(58) }
      elseif (%oqohlitera = $chr(59)) {
      set %oqohlit $chr(59) }
      elseif (%oqohlitera = $chr(96)) {
      set %oqohlit $chr(96) }
      else { %oqohlit = $chr(46) }
      set %oqohntekst %oqohntekst $+ %oqohlit
      inc %oqohz
    }
    %oqohntext = $replace(%oqohntekst,$chr(21),%oqohspace)
  }
  else {
    if (%oqohdlugosc = %oqohpodp) dec %oqohpodp
    %oqohinterwal = 4
    var %oqohz1 1
    %oqohileczesci = $ceil($calc(%oqohdlugosc / %oqohinterwal))
    while (%oqohz1 <= $calc(%oqohileczesci * %oqohinterwal)) {
      %oqohpokaz = $mid(%oqohtekst1,%oqohz1,%oqohpodp)
      %oqohjeden = $calc(%oqohz1 + %oqohpodp)
      %oqohdwa = $calc(%oqohinterwal - %oqohpodp)
      %oqohukryj = $mid(%oqohntekst,%oqohjeden,%oqohdwa)
      set %oqohpolacz %oqohpokaz $+ %oqohukryj 
      set %oqohnowytekst %oqohnowytekst $+ %oqohpolacz
      inc %oqohz1 %oqohinterwal
    }
    %oqohntext = $replace(%oqohnowytekst,$chr(21),%oqohspace)
  }
  inc %oqohpodp
}

alias koniec {
  .timer* off
  msg %oqkanal %oqnag
  msg %oqkanal 0,4 Quiz zostal zakonczony! 
  msg %oqkanal 0,4 Sciagaj z:9,4 http://www.quizpl.net 
  unset %oq*
}

alias rankg {
  if ($read(oqag.txt,s,$address($1,1)) == $null) { write -i oqag.txt $address($1,1) $2 | write -i oqnicks.txt $address($1,1) $1 }
  else { %oqnpunktg = $remove($read(oqag.txt,s,$address($1,1)),$address($1,1)) | if ($read(oqnicks.txt,s,$address($1,1)) != $1) { write -i oqnicks.txt $address($1,1) $1 } | %oqnpkg = $calc(%oqnpunktg + $2) | .write -ds $+ $address($1,1) oqag.txt | .write oqag.txt $address($1,1) %oqnpkg }
  %oqsuma = $read(oqag.txt,s,$address($1,1))
  filter -cteuff 2 32 oqag.txt oqag.txt
  %oqplace1 = $read(oqag.txt,s,$address($1,1))
  %oqplace = $readn
  write -c oqag1.txt
  var %oqro1 1
  while (%oqro1 <= $lines(oqag.txt)) {
    %oqialnick = $left($read(oqag.txt,%oqro1),$pos($read(oqag.txt,%oqro1),$chr(32)))
    %oqnik = $read(oqnicks.txt,s,%oqialnick)
    %oqptsg = $read(oqag.txt,s,%oqialnick)
    write oqag1.txt %oqnik %oqptsg
    inc %oqro1
  }
}

alias rank {
  var %oqs 1
  while (%oqs <= $lines(oqag1.txt)) {
    %oqcalosc = $read(oqag1.txt,%oqs)
    set %oqnewstt %oqk0 $+ %oqnewstt %oqk1 $+ %oqg %oqs $+ . $+ %oqg $+ %oqk0 %oqcalosc
    inc %oqs
  }
  msg %oqkanal %oqnag
  msg %oqkanal %oqk0 $+ %oqg $+ Ranking: $+ %oqg $+ %oqnewstt
  unset %oqnewstt
}



alias rantg {
  if ($read(oqag2.txt,s,$address($1,1)) == $null) { write -i oqag2.txt $address($1,1) 1 }
  else { %oqnpunktg2 = $remove($read(oqag2.txt,s,$address($1,1)),$address($1,1)) | %oqnpkg2 = $calc(%oqnpunktg2 + 1) | .write -ds $+ $address($1,1) oqag2.txt | .write oqag2.txt $address($1,1) %oqnpkg2 }
  filter -cteuff 2 32 oqag2.txt oqag2.txt
  write -c oqag3.txt
  var %oqro2 1
  while (%oqro2 <= $lines(oqag2.txt)) {
    %oqialnick2 = $left($read(oqag2.txt,%oqro2),$pos($read(oqag2.txt,%oqro2),$chr(32)))
    %oqnik2 = $read(oqnicks.txt,s,%oqialnick2)
    %oqptsg2 = $read(oqag2.txt,s,%oqialnick2)
    write oqag3.txt %oqnik2 %oqptsg2
    inc %oqro2
  }
}

alias ranking {
  var %oqs2 1
  while (%oqs2 <= $lines(oqag3.txt)) {
    %oqcalosc2 = $read(oqag3.txt,%oqs2)
    set %oqnewstt2 %oqk0 $+ %oqnewstt2 %oqk1 $+ %oqg %oqs2 $+ . $+ %oqg $+ %oqk0 %oqcalosc2
    inc %oqs2
  }
  msg %oqkanal %oqnag
  msg %oqkanal %oqk0 $+ %oqg $+ Ranking Antygooglowy: $+ %oqg $+ %oqnewstt2
  unset %oqnewstt2
}

alias ranks {
  write -i oqczasy.txt $nick %oqtnor ( $+ %oqdlodp $+ )
  filter -ctuff 2 32 oqczasy.txt oqczasy.txt
}

alias czas {
  var %cz1 1
  while (%cz1 <= $lines(oqczasy.txt)) {
    %oqtajm = $read(oqczasy.txt,%cz1)
    set %oqnewczas %oqk0 $+ %oqnewczas %oqk1 $+ %oqg %cz1 $+ . $+ %oqg $+ %oqk0 %oqtajm $+ %oqk1
    if (%cz1 < 5) { inc %cz1 }
    else { goto oqnewczas }
  }
  :oqnewczas
  msg %oqkanal %oqnag
  msg %oqkanal %oqk0 $+ %oqg $+ Najlepsze czasy: $+ %oqg $+ %oqnewczas
  unset %oqnewczas
}

alias delay {
  if ($1 == $null) set %oqdelay $?="Opoznienie zadawanych pytan w sekundach:"
  else %oqdelay = $1-
  msg %oqkanal %oqk1 {oyey-quiz} %oqk1 Opoznienie miedzy pytaniami: %oqdelay sekund
}

alias kolornor {
  set %oqkolnor $?="wybierz kolor np. 8 lub 8,1 by wybrac kolor z tlem:"
  set %oqk1  $+ %oqkolnor
  echo -a %oqk1 taki kolor ma obecnie zwykly tekst!
}

alias kolorpyt {
  set %oqkolpyt $?="wybierz kolor np. 8 lub 8,1 by wybrac kolor z tlem:"
  set %oqkpyt  $+ %oqkolpyt
  echo -a %oqkpyt taki kolor pytan jest obecnie!
}

alias kolorzm {
  set %oqkolzm $?="wybierz kolor np. 8 lub 8,1 by wybrac kolor z tlem:"
  set %oqk0  $+ %oqkolzm
  echo -a %oqk0 taki kolor ma obecnie tekst wartosci zmiennych np. punktow
}

alias resetk {
  set %oqk1 0,1
  set %oqk0 8,1
  set %oqkpyt 12
  echo -a %oqk1 kolory standardowe zostaly przywrocone
}

on 1:TEXT:!stat:%oqkanal:{
  if (%oqstat != byl) { rank }
  set %oqstat byl
}
