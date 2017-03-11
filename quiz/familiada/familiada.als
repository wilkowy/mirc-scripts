; mod by wilk (wyniki indywidualne, podsumowanie gry, liczenie odpowiedzi, podpowiedzi, ustawianie czasu trwania rundy, wyœwietlanie pytania w podpowiedziach i przypomnieniu, kolorowe znaczki dru¿yn, poprawki kodu i inne)

on *:TEXT:%fam_odpowiedz1:%fam_kanal: f_zgaduje 1 $nick
on *:TEXT:%fam_odpowiedz2:%fam_kanal: f_zgaduje 2 $nick
on *:TEXT:%fam_odpowiedz3:%fam_kanal: f_zgaduje 3 $nick
on *:TEXT:%fam_odpowiedz4:%fam_kanal: f_zgaduje 4 $nick
on *:TEXT:%fam_odpowiedz5:%fam_kanal: f_zgaduje 5 $nick
on *:TEXT:%fam_odpowiedz6:%fam_kanal: f_zgaduje 6 $nick
on *:TEXT:%fam_odpowiedz7:%fam_kanal: f_zgaduje 7 $nick
on *:TEXT:%fam_odpowiedz8:%fam_kanal: f_zgaduje 8 $nick
on *:TEXT:%fam_odpowiedz9:%fam_kanal: f_zgaduje 9 $nick
on *:TEXT:%fam_odpowiedz10:%fam_kanal: f_zgaduje 10 $nick

on *:TEXT:!przyp:%fam_kanal: f_przyp
on *:TEXT:!join 1:%fam_kanal: f_join $nick 1 2
on *:TEXT:!join 2:%fam_kanal: f_join $nick 2 1
on *:TEXT:!part:%fam_kanal: f_part $nick
on *:TEXT:!pkt:%fam_kanal: f_statystyka $nick
on *:TEXT:!pkt *:%fam_kanal: f_punktacja $nick $2
on *:TEXT:!team *:%fam_kanal: f_team $nick $2-

on *:KICK:%fam_kanal: f_onpart $knick
on *:QUIT: f_onpart $nick
on *:NICK:%fam_kanal: f_onnick $nick $newnick
on *:JOIN:%fam_kanal: f_onjoin $nick
on *:PART:%fam_kanal: f_onpart $nick
on *:DISCONNECT: f_onpart $me

on *:dialog:familiada:init:*: {
  did -mbr familiada 112,122,132,142,152,162,172,182,192,202
  if (($len(%fam_auto_file) > 0) || ($len($timer(familiada).secs) > 0)) {
    did -mera familiada 102 %fam_pytanie
    var %fam_temp = 102
    while (%fam_temp <= 192) {
      did -mera familiada $calc(%fam_temp + 10) %fam_odpowiedz [ $+ [ $calc($int($calc(%fam_temp / 10)) - 9) ] ]
      inc %fam_temp 10
    }
  }
  did -b familiada 301
}

on *:dialog:familiada:edit:*: {
  var %fam_temp = 102
  while (%fam_temp <= 192) {
    if (($len($zmiana($did(%fam_temp))) >= 1) && ($did($calc(%fam_temp + 10)).enabled == $false)) did -ne familiada $calc(%fam_temp + 10)
    if (($len($zmiana($did(%fam_temp))) < 1) && ($did($calc(%fam_temp + 10)).enabled == $true)) did -mbr familiada $calc(%fam_temp + 10)
    inc %fam_temp 10
  }
  if (($len($zmiana($did(102))) >= 1) && ($len($zmiana($did(112))) >= 1)) did -e familiada 301
  else did -b familiada 301
}

on *:dialog:familiada:sclick:301: fpyt2

on *:dialog:fplay:dclick:*: if (($did == 101) || ($did == 201)) f_removeplayer $did

on *:dialog:fplay:sclick:302: {
  if ($did(101).sel > 0) f_removeplayer 101
  if ($did(201).sel > 0) f_removeplayer 201
  halt
}

dialog fplay {
  title "Familiada"
  size -1 -1 293 186
  box Druzyna I , 100 , 5 -1 140 133
  box Druzyna II , 200 , 150 -1 140 133
  list 101 , 10 15 130 130 , extsel
  list 201 , 155 15 130 130 , extsel
  button Wyrzuc , 302 , 5 135 283 50 , ok
}

dialog familiada {
  title "Familiada"
  size -1 -1 600 350
  box , 100 , 5 -1 590 311
  text Pytanie , 101 , 1 10 600 20 , center
  edit , 102 , 10 30 580 22 , autohs multi autovs limit 900
  edit , 103 , 10 30 580 22 , autohs multi hide limit 900
  text Pierwsza odpowiedz , 111 , 1 60 300 20 , center
  edit , 112 , 10 82 280 22 , autohs multi autovs limit 900
  edit , 113 , 10 82 280 22 , autohs multi hide limit 900
  text Druga odpowiedz , 121 , 1 110 300 20 , center
  edit , 122 , 10 132 280 22 , autohs multi autovs limit 900
  edit , 123 , 10 82 280 22 , autohs multi hide limit 900
  text Trzecia odpowiedz , 131 , 1 160 300 20 , center
  edit , 132 , 10 182 280 22 , autohs multi autovs limit 900
  edit , 133 , 10 82 280 22 , autohs multi hide limit 900
  text Czwarta odpowiedz , 141 , 1 210 300 20 , center
  edit , 142 , 10 232 280 22 , autohs multi autovs limit 900
  edit , 143 , 10 82 280 22 , autohs multi hide limit 900
  text Piata odpowiedz , 151 , 1 260 300 20 , center
  edit , 152 , 10 282 280 22 , autohs multi autovs limit 900
  edit , 153 , 10 82 280 22 , autohs multi hide limit 900
  text Szosta odpowiedz , 161 , 301 60 300 20 , center
  edit , 162 , 310 82 280 22 , autohs multi autovs limit 900
  edit , 163 , 310 82 280 22 , autohs multi hide limit 900
  text Siodma odpowiedz , 171 , 301 110 300 20 , center
  edit , 172 , 310 132 280 22 , autohs multi autovs limit 900
  edit , 173 , 310 82 280 22 , autohs multi hide limit 900
  text Osma odpowiedz , 181 , 301 160 300 20 , center
  edit , 182 , 310 182 280 22 , autohs multi autovs limit 900
  edit , 183 , 310 82 280 22 , autohs multi hide limit 900
  text Dziewiata odpowiedz , 191 , 301 210 300 20 , center
  edit , 192 , 310 232 280 22 , autohs multi autovs limit 900
  edit , 193 , 310 82 280 22 , autohs multi hide limit 900
  text Dziesiata odpowiedz , 201 , 301 260 300 20 , center
  edit , 202 , 310 282 280 22 , autohs multi autovs limit 900
  edit , 203 , 310 82 280 22 , autohs multi hide limit 900
  box , 300 , 5 307 640 39
  button OK , 301 , 225 320 50 20 , ok disable
  button Zrezygnuj , 302 , 325 320 90 20 , cancel
}

alias fon {
  if ($len(%fam_kanal) > 0) fmsg Familiada jest juz uruchomiona na kanale %fam_kanal
  if (($len($chan) < 1) && ($len($1) < 1) && ($len(%fam_kanal) < 1)) fmsg Nie podales(as) nazwy kanalu
  unset %fam_*
  write -cdl1 " $+ $scriptdir $+ team1.fam $+ "
  write -cdl1 " $+ $scriptdir $+ team2.fam $+ "
  set %fam_kanal $iif($len($1) > 0 , $zmiana(#$1) , $chan)
  set %fam_rundy 0
  set %fam_druzyna1_punkty 0
  set %fam_druzyna2_punkty 0
  set %fam_druzyna1_odpowiedzi 0
  set %fam_druzyna2_odpowiedzi 0
  set %fam_start $asctime($gmt)
  set %fam_team1_name Druzyna I
  set %fam_team2_name Druzyna II
  set %fam_auto_delay 15
  set %fam_duration 120
  fsay 8,1 8 8 8 8 8 8 8 8 8 8 -= FAMILIADA 0.66 =- 8 8 8 8 8 8 8 8 8 
  fsay 9,1 9 Dostepne komendy: 4 4!join 1 4 4 !join 2 4 4 !part 9 9 
  fsay 9,1 9 4 !pkt 4 4 !przyp 4 4 !pkt [nick] 4 4 !team [nazwa] 9 9 
}

alias fpyt {
  fchk
  if ($dialog(familiada) == familiada) dialog -iev familiada
  else dialog -dievmr familiada familiada
}

alias foff {
  fchk
  if ($dialog(familiada) == familiada) dialog -x familiada
  if ($dialog(fplay) == fplay) dialog -x fplay
  .timerfamiliada off 
  .timerfamiliadaauto off
  .timerfamiliadaonjoin off
  fsay 8,1 8 8 8 8 8 8 -= FAMILIADA ZAKONCZONA =- 8 8 8 8 8 
  fsay 4,14 Ilosc rund:9 [ %fam_rundy ] 11 Czas gry:9 $ftime(%fam_start) 
  fsay 15,1 15 15 15 15 15 15 15 15 15 15 Autorzy: 8snajperx15 & 8wilk 15 15 15 15 15 15 15 15 15 
  fsay 13,1 Sciagaj z: 11http://www.quizpl.net 8 8 8 8 8 8 8 8 8 8 8 
  unset %fam_*
  .remove " $+ $scriptdir $+ team1.fam $+ "
  .remove " $+ $scriptdir $+ team2.fam $+ "
}

alias fauto {
  fchk
  var %fam_temp = $iif(($1- isnum 1-60) && ($left($1-,1) != 0), 1, 0)
  if (($len(%fam_auto_file) > 0) && (%fam_temp != 1)) fmsg Autoquiz jest juz uruchomiony
  if ((%fam_temp == 1) && ($len(%fam_auto_file) > 0)) {
    set %fam_auto_delay $int($1-)
    fsay 8,2 FAMILIADA 9 Autoquiz opoznienie: %fam_auto_delay $+ s
    halt
  }
  set -u0 %fam_auto_file $dir="Wybierz plik z pytaniami" $mircdir
  if ($len(%fam_auto_file) < 1) halt
  else set %fam_auto_file %fam_auto_file
  if (%fam_temp == 1) set %fam_auto_delay $int($1-)
  inc %fam_auto_linenr
  set %fam_auto_line $read(%fam_auto_file , %fam_auto_linenr)
  set %fam_auto_line2 $read(%fam_auto_file , $calc(%fam_auto_linenr + 1))
  fsay 9,2 *** Poczatek Autoquiza (opoznienie: %fam_auto_delay $+ s) ***
  if (($len($zmiana(%fam_auto_line)) < 1) || ($len($zmiana(%fam_auto_line2)) < 1)) fautooff
  fautopyt
}

alias fautooff {
  fchk
  if (($timer(familiadaauto).secs !isnum) && ($len(%fam_auto_file) > 0)) fmsg Poczekaj na zakonczenie rundy
  if ($len(%fam_auto_file) < 1) fmsg Autoquiz nie jest uruchomiony
  var %fam_temp = %fam_auto_delay
  unset %fam_auto*
  set %fam_auto_delay %fam_temp
  .timerfamiliadaauto off
  fsay 7,2 *** Koniec Autoquiza ***
  if ($dialog(familiada) == familiada) {
    did -mbr familiada 112,122,132,142,152,162,172,182,192,202
    did -ner familiada 102
  }
  halt
}

alias fplay {
  fchk
  if ($dialog(fplay) == fplay) dialog -oiev fplay
  else {
    dialog -oievmr fplay fplay
    var %fam_temp = 1
    while ((%fam_temp <= $lines(" $+ $scriptdir $+ team1.fam $+ ")) || (%fam_temp <= $lines(" $+ $scriptdir $+ team2.fam $+ "))) {
      if (($len($read(" $+ $scriptdir $+ team1.fam $+ ", %fam_temp)) > 2) && ($len($nick(%fam_kanal , $read(" $+ $scriptdir $+ team1.fam $+ ", %fam_temp))) < 1)) did -a fplay 101 $read(" $+ $scriptdir $+ team1.fam $+ ", %fam_temp)
      if (($len($read(" $+ $scriptdir $+ team2.fam $+ ", %fam_temp)) > 2) && ($len($nick(%fam_kanal , $read(" $+ $scriptdir $+ team2.fam $+ ", %fam_temp))) < 1)) did -a fplay 201 $read(" $+ $scriptdir $+ team2.fam $+ ", %fam_temp)
      inc %fam_temp
    }
  }
}

alias -l f_part {
  if ($len(%fam_ingame_ [ $+ [ $1 ] ] ) < 1) halt
  else unset %fam_ingame_ [ $+ [ $1 ] ]
  var %fam_temp = $read(" $+ $scriptdir $+ team [ $+ [ %fam_ingame_ [ $+ [ $1 ] ] ] $+ [ .fam ] ] $+ ", s , $1)
  var %fam_temp = $readn
  if (%fam_temp > 0) write -dl [ $+ [ %fam_temp ] ] " $+ $scriptdir $+ team [ $+ [ %fam_ingame_ [ $+ [ $1 ] ] ] $+ [ .fam ] ] $+ "
}

alias -l f_onpart {
  if ($dialog(fplay) != fplay) halt
  elseif ($1 == $me) {
    did -r fplay 101,201
    var %fam_temp = 1
    while ((%fam_temp <= $lines(" $+ $scriptdir $+ team1.fam $+ ")) || (%fam_temp <= $lines(" $+ $scriptdir $+ team2.fam $+ "))) {
      did -a fplay 101 $read(" $+ $scriptdir $+ team1.fam $+ ", %fam_temp)
      did -a fplay 201 $read(" $+ $scriptdir $+ team2.fam $+ ", %fam_temp)
      inc %fam_temp
    }
  }
  elseif (($len($read(" $+ $scriptdir $+ team1.fam $+ " , s , $1)) < 1) && ($len($read(" $+ $scriptdir $+ team2.fam $+ " , s , $1)) < 1)) halt
  elseif ($len($read(" $+ $scriptdir $+ team1.fam $+ " , s , $1)) > 2) did -a fplay 101 $1
  else did -a fplay 201 $1
}

alias -l f_onjoin {
  if ($dialog(fplay) != fplay) halt
  elseif ($1 == $me) .timerfamiliadaonjoin -m 0 1 f_joinme
  elseif (($len($read(" $+ $scriptdir $+ team1.fam $+ " , s , $1)) < 1) && ($len($read(" $+ $scriptdir $+ team2.fam $+ " , s , $1)) < 1)) halt
  elseif ($len($read(" $+ $scriptdir $+ team1.fam $+ " , s , $1)) > 2) var %fam_temp2 = 1
  else var %fam_temp2 = 2
  var %fam_temp = 1
  did -r fplay %fam_temp2 $+ 01
  while (%fam_temp <= $lines(" $+ $scriptdir $+ team [ $+ [ %fam_temp2 ] $+ [ .fam ] ] $+ ")) {
    if (($len($read(" $+ $scriptdir $+ team [ $+ [ %fam_temp2 ] $+ [ .fam ] ] $+ " , %fam_temp)) > 2) && ($len($nick(%fam_kanal , $read(" $+ $scriptdir $+ team [ $+ [ %fam_temp2 ] $+ [ .fam ] ] $+ " , %fam_temp))) < 1)) did -a fplay %fam_temp2 $+ 01 $read(" $+ $scriptdir $+ team [ $+ [ %fam_temp2 ] $+ [ .fam ] ] $+ " , %fam_temp)
    inc %fam_temp
  }
}

alias -l f_onnick {
  if ($dialog(fplay) != fplay) halt
  elseif (($len($read(" $+ $scriptdir $+ team1.fam $+ " , s , $2)) < 1) && ($len($read(" $+ $scriptdir $+ team2.fam $+ " , s , $2)) < 1) && ($len($read(" $+ $scriptdir $+ team1.fam $+ " , s , $1)) < 1) && ($len($read(" $+ $scriptdir $+ team2.fam $+ " , s , $1)) < 1)) halt
  var %fam_temp = 1
  did -r fplay 101
  did -r fplay 201
  while ((%fam_temp <= $lines(" $+ $scriptdir $+ team1.fam $+ ")) || (%fam_temp <= $lines(" $+ $scriptdir $+ team2.fam $+ "))) {
    if (($len($read(" $+ $scriptdir $+ team1.fam $+ " , %fam_temp)) > 2) && ($len($nick(%fam_kanal , $read(" $+ $scriptdir $+ team1.fam $+ " , %fam_temp))) < 1)) did -a fplay 101 $read(" $+ $scriptdir $+ team1.fam $+ " , %fam_temp)
    if (($len($read(" $+ $scriptdir $+ team2.fam $+ " , %fam_temp)) > 2) && ($len($nick(%fam_kanal , $read(" $+ $scriptdir $+ team2.fam $+ " , %fam_temp))) < 1)) did -a fplay 201 $read(" $+ $scriptdir $+ team2.fam $+ " , %fam_temp)
    inc %fam_temp
  }
}

alias -l f_team {
  if (($read(" $+ $scriptdir $+ team1.fam $+ " , 1) != $1) && ($read(" $+ $scriptdir $+ team2.fam $+ " , 1) != $1)) halt
  elseif (($read(" $+ $scriptdir $+ team1.fam $+ " , 1) == $1) && ($len($zmiana($2-)) > 0)) set %fam_team1_name $zmiana($2-)
  elseif (($read(" $+ $scriptdir $+ team2.fam $+ " , 1) == $1) && ($len($zmiana($2-)) > 0)) set %fam_team2_name $zmiana($2-)
}

alias -l f_punktacja {
  if (($len($read(" $+ $scriptdir $+ team1.fam $+ " , s , $2)) < 1) && ($len($read(" $+ $scriptdir $+ team2.fam $+ " , s , $2)) < 1)) halt
  var %fam_temp2 = $readn
  if ($len($read(" $+ $scriptdir $+ team1.fam $+ " , s , $2)) > 0) var %fam_temp = 1
  else var %fam_temp = 2
  if (%fam_nick_ [ $+ [ $2 ] $+ [ _punkty ] ] > 0) .notice $1 $read(" $+ $scriptdir $+ team [ $+ [ %fam_temp ] $+ [ .fam ] ] $+ " , %fam_temp2) zdobyl(a) %fam_nick_ [ $+ [ $2 ] $+ [ _punkty ] ] punktow w Familiadzie za %fam_nick_ [ $+ [ $2 ] $+ [ _odpowiedzi ] ] odpowiedzi
}

alias -l f_removeplayer {
  var %fam_did_selnum = $did($1 , 0).sel
  var %fam_did_linenum = 1
  while (%fam_did_linenum <= %fam_did_selnum) {  
    unset %fam_ingame_ $+ $did($1).seltext
    var %fam_gracze = %fam_gracze $did($1 , $did($1 , 1).sel).text
    var %fam_linenum = $read(" $+ $scriptdir $+ $iif($1 == 101 , team1.fam , team2.fam) $+ " , s , $did($1).seltext)
    write -dl [ $+ [ $readn ] ] " $+ $scriptdir $+ $iif($1 == 101 , team1.fam , team2.fam) $+ "
    did -d fplay $1 $did($1 , 1).sel
    inc %fam_did_linenum
  }
  fsay 4,2 $iif(%fam_did_linenum <= 2 , Gracz %fam_gracze zostal usuniety , Gracze %fam_gracze zostali usunieci) z $iif($1 == 101 , 9 $+ %fam_team1_name , 13 $+ %fam_team2_name)
}

alias -l f_joinme {
  .timerfamiliadaonjoin off
  echo -a $nick(%fam_kanal , 1)
  did -r fplay 101,201
  var %fam_temp = 1
  while ((%fam_temp <= $lines(" $+ $scriptdir $+ team1.fam $+ ")) || (%fam_temp <= $lines(" $+ $scriptdir $+ team2.fam $+ "))) {
    if (($len($read(" $+ $scriptdir $+ team1.fam $+ " , %fam_temp)) > 2) && ($len($nick(%fam_kanal , $read(" $+ $scriptdir $+ team1.fam $+ " , %fam_temp))) < 1)) did -a fplay 101 $read(" $+ $scriptdir $+ team1.fam $+ " , %fam_temp)
    if (($len($read(" $+ $scriptdir $+ team2.fam $+ " , %fam_temp)) > 2) && ($len($nick(%fam_kanal , $read(" $+ $scriptdir $+ team2.fam $+ " , %fam_temp))) < 1)) did -a fplay 201 $read(" $+ $scriptdir $+ team2.fam $+ " , %fam_temp)
    inc %fam_temp
  }
}

alias -l fmsg {
  echo -a 8,1 FAMILIADA  $1- 
  halt
}

alias -l fsay {
  if ($server && (%fam_kanal ischan)) msg %fam_kanal $1- 
  else echo -a 15 %fam_kanal ---> $1- 
}

alias -l fchk if ($len(%fam_kanal) < 1) fmsg Najpierw uruchom Familiade

alias -l bkgrnd return $iif($version == 5.9 , $colour(background) , $color(background))

alias -l zmiana return $replace($1-,,,,,,,,,,)

alias -l fodmiana return $1 $iif($1 == 1 , $2 , $iif(($calc($1 % 10) isnum 2-4) && ($calc($1 % 100) !isnum 12-14) , $3 , $4))

alias -l ftabela {
  var %fam_temp = 1
  var %fam_tabela
  while ($len(%fam_odpowiedz [ $+ [ %fam_temp ] ] ) > 0) {
    var %fam_tabela = %fam_tabela 1,1 1,15 %fam_temp $+ .
    if (%fam_odpowiedz [ $+ [ %fam_temp ] $+ [ _byla ] ] == 0) {
      if ($1 == 0) {
        if (%fam_podpowiedz > 0) var %fam_tabela = %fam_tabela $+ 12 $left(%fam_odpowiedz [ $+ [ %fam_temp ] ], %fam_podpowiedz) $+ 14...
        else var %fam_tabela = %fam_tabela ----
      }
      else var %fam_tabela = %fam_tabela $+ 4 %fam_odpowiedz [ $+ [ %fam_temp ] ]
    }
    else var %fam_tabela = %fam_tabela %fam_odpowiedz [ $+ [ %fam_temp ] ]
    inc %fam_temp
  }
  return %fam_tabela
}

alias -l fpyt2 {
  set %fam_pytanie $zmiana($did(102))
  set %fam_podpowiedz 0
  var %fam_temp = 1
  while (%fam_temp <= 10) {
    var %fam_odpowiedz = $zmiana($did($calc(102 + 10 * %fam_temp)))
    set %fam_odpowiedz [ $+ [ %fam_temp ] ] %fam_odpowiedz
    set %fam_odpowiedz [ $+ [ %fam_temp ] $+ [ _byla ] ] $iif($len(%fam_odpowiedz) > 0 , 0 , 1)
    inc %fam_temp
  }
  .timerfamiliada off
  fsay 10,1 Pytanie:8,1 %fam_pytanie $ftabela(0) 1,1 7,1 Czas: %fam_duration $+ s
  .timerfamiliada -o 0 %fam_duration f_timeout
}

alias -l f_przyp if (%fam_podpowiedz != $null) fsay 10,1 Pytanie:8,1 %fam_pytanie $ftabela(0)

alias -l f_zgaduje {
  if (%fam_ingame_ [ $+ [ $2 ] ] !isnum 1-2) halt
  if (%fam_odpowiedz [ $+ [ $1 ] $+ [ _byla ] ] == 1) halt
  if ($dialog(familiada) == familiada) did -mbr familiada $calc(102 + 10 * $1)
  var %fam_punkty = $calc(5 * (11 - $1))
  inc %fam_druzyna [ $+ [ %fam_ingame_ [ $+ [ $2 ] ] ] $+ [ _punkty ] ] %fam_punkty
  inc %fam_druzyna [ $+ [ %fam_ingame_ [ $+ [ $2 ] ] ] $+ [ _odpowiedzi ] ]
  inc %fam_nick_ [ $+ [ $2 ] $+ [ _punkty ] ] %fam_punkty
  inc %fam_nick_ [ $+ [ $2 ] $+ [ _odpowiedzi ] ]
  set %fam_odpowiedz [ $+ [ $1 ] $+ [ _byla ] ] 1
  if (%fam_ingame_ [ $+ [ $2 ] ] == 1) fsay 0,3  0,2 $2 11zdobywa %fam_punkty punktow dla %fam_team1_name za0 %fam_odpowiedz [ $+ [ $1 ] ] 
  if (%fam_ingame_ [ $+ [ $2 ] ] == 2) fsay 0,13  0,2 $2 11zdobywa %fam_punkty punktow dla %fam_team2_name za0 %fam_odpowiedz [ $+ [ $1 ] ] 
  var %fam_temp = 1
  var %fam_temp_odpowiedzi = 0
  while (%fam_temp <= 10) {
    inc %fam_temp_odpowiedzi %fam_odpowiedz [ $+ [ %fam_temp ] $+ [ _byla ] ]
    inc %fam_temp
  }
  if (%fam_temp_odpowiedzi == 10) f_end 7,2 Koniec Rundy $calc(%fam_rundy + 1)
}

alias -l f_statystyka {
  var %fam_temp = 1
  var %fam_temp_d1
  var %fam_temp_d2
  while ((%fam_temp <= $lines(" $+ $scriptdir $+ team1.fam $+ ")) || (%fam_temp <= $lines(" $+ $scriptdir $+ team2.fam $+ "))) {
    var %fam_temp_d1 = %fam_temp_d1 $read(" $+ $scriptdir $+ team1.fam $+ " , %fam_temp)
    var %fam_temp_d2 = %fam_temp_d2 $read(" $+ $scriptdir $+ team2.fam $+ " , %fam_temp)
    inc %fam_temp
  }
  .notice $1 3 $+ %fam_team1_name ( $+ %fam_temp_d1 $+ ): %fam_druzyna1_punkty punktow *** 6 $+ %fam_team2_name ( $+ %fam_temp_d2 $+ ): %fam_druzyna2_punkty punktow *** Czas trwania gry: $fodmiana(%fam_rundy , runda , rundy , rund) ( $+ $ftime(%fam_start) $+ )
  if (%fam_nick_ [ $+ [ $1 ] $+ [ _punkty ] ] > 0) .notice $1 Zdobyles(as) %fam_nick_ [ $+ [ $1 ] $+ [ _punkty ] ] punktow w Familiadzie za %fam_nick_ [ $+ [ $1 ] $+ [ _odpowiedzi ] ] odpowiedzi
}

alias -l ftime {
  ftime3 $gmt $ctime($1) 1 604800 fam_week
  ftime3 %fam_czas %fam_week 604800 86400 fam_day
  ftime3 %fam_czas %fam_day 86400 3600 fam_hour
  ftime3 %fam_czas %fam_hour 3600 60 fam_minute
  ftime3 %fam_czas %fam_minute 60 1 fam_second
  unset %fam_czas
  ftime2 %fam_week tydzien tygodnie tygodni
  ftime2 %fam_day dzien dni dni
  ftime2 %fam_hour godzina godziny godzin
  ftime2 %fam_minute minuta minuty minut
  ftime2 %fam_second sekunda sekundy sekund
  return $iif(%fam_czas == $null , 0 sekund , %fam_czas)
}

alias -l ftime2 $iif($1 == 0 , return , set -u0 %fam_czas %fam_czas $1 $iif($1 == 1 , $2 , $iif(($calc($1 % 10) isnum 2-4) && ($calc($1 % 100) !isnum 12-14) , $3 , $4)))

alias -l ftime3 {
  set -u0 %fam_czas $calc($1 - $2 * $3)
  set -u0 % [ $+ [ $5 ] ] $iif($int($calc(%fam_czas / $4)) >= 1 , $int($calc(%fam_czas / $4)) , 0)
}

alias f_timeout {
  f_end 7,2 *** Time Out! *** Koniec Rundy $calc(%fam_rundy + 1) ***
}

alias -l f_end {
  .timerfamiliada off
  inc %fam_rundy
  fsay $1-
  var %fam_temp = 1
  var %fam_temp_d1
  var %fam_temp_d2
  while ((%fam_temp <= $lines(" $+ $scriptdir $+ team1.fam $+ ")) || (%fam_temp <= $lines(" $+ $scriptdir $+ team2.fam $+ "))) {
    var %fam_temp_d1 = %fam_temp_d1 $read(" $+ $scriptdir $+ team1.fam $+ " , %fam_temp)
    var %fam_temp_d2 = %fam_temp_d2 $read(" $+ $scriptdir $+ team2.fam $+ " , %fam_temp)
    inc %fam_temp
  }
  fsay 9,1 %fam_team1_name ( $+ %fam_temp_d1 $+ ):8 %fam_druzyna1_punkty
  fsay 13,1 %fam_team2_name ( $+ %fam_temp_d2 $+ ):8 %fam_druzyna2_punkty
  fsay $ftabela(1)
  unset %fam_podpowiedz %fam_odpowiedz* %fam_pytanie %fam_temp*
  if ($len(%fam_auto_file) > 0) {
    inc %fam_auto_linenr 2
    set %fam_auto_line $read(%fam_auto_file , %fam_auto_linenr)
    set %fam_auto_line2 $read(%fam_auto_file , $calc(%fam_auto_linenr + 1))
    if (($len($zmiana(%fam_auto_line)) < 1) || ($len($zmiana(%fam_auto_line2)) < 1)) {
      unset %fam_auto*
      fsay 7,2 *** Koniec Autoquiza ***
    }
    else .timerfamiliadaauto -o 0 %fam_auto_delay fautopyt
  }
  if ($dialog(familiada) == familiada) {
    did $iif($len(%fam_auto_file) > 0 , -mbr , -enr) familiada 102
    var %fam_temp = 102
    while (%fam_temp <= 192) {
      did -mbr familiada $calc(%fam_temp + 10) %fam_odpowiedz [ $+ [ $calc($int($calc(%fam_temp / 10)) - 9) ] ]
      inc %fam_temp 10
    }
  }
}

alias -l f_join {
  var %fam_temp = $read(" $+ $scriptdir $+ team [ $+ [ $2 ] $+ [ .fam ] ] $+ " , s , $1)
  var %fam_temp = $readn
  if (%fam_temp != 0) halt
  var %fam_temp = $read(" $+ $scriptdir $+ team [ $+ [ $3 ] $+ [ .fam ] ] $+ " , s , $1)
  var %fam_temp = $readn
  if (%fam_temp > 0) write -dl [ $+ [ %fam_temp ] ] " $+ $scriptdir $+ team [ $+ [ $3 ] $+ [ .fam ] ] $+ "
  write " $+ $scriptdir $+ team [ $+ [ $2 ] $+ [ .fam ] ] $+ " $1
  %fam_ingame_ [ $+ [ $1 ] ] = $2
}

alias fautopyt {
  .timerfamiliadaauto off
  %fam_pytanie = $zmiana(%fam_auto_line)
  set %fam_podpowiedz 0
  if ($dialog(familiada) == familiada) {
    did -mera familiada 102 %fam_pytanie
    did -b familiada 301
  }
  var %fam_temp = 1
  while (%fam_temp <= 10) {
    var %fam_temp_odp = $gettok(%fam_auto_line2, %fam_temp, 42)
    set %fam_odpowiedz [ $+ [ %fam_temp ] ] $zmiana(%fam_temp_odp)
    set %fam_odpowiedz [ $+ [ %fam_temp ] $+ [ _byla ] ] $iif(%fam_temp_odp == $null, 1, 0)
    if ($dialog(familiada) == familiada) did -mera familiada $calc(102 + %fam_temp * 10) $zmiana(%fam_temp_odp)
    inc %fam_temp
  }
  .timerfamiliada off
  fsay 10,1 Pytanie:8,1 %fam_pytanie $ftabela(0) 1,1 7,1 Czas: %fam_duration $+ s
  .timerfamiliada -o 0 %fam_duration f_timeout
}

alias fpodp {
  fchk
  if (%fam_podpowiedz == $null) halt
  inc %fam_podpowiedz
  fsay 10,1 Pytanie:8,1 %fam_pytanie $ftabela(0)
}

alias fczas {
  fchk
  if ($1- isnum) {
    set %fam_duration $int($1-)
    fsay 8,2 FAMILIADA 9 Czas trwania rundy: %fam_duration $+ s
  }
}

alias fkom {
  echo -a -- 10Familiada - spis komend --
  echo -a $chr(124) 10/fon #kanal - uruchomienie Familiady na #kanal
  echo -a $chr(124) 10/foff - zakonczenie Familiady
  echo -a $chr(124) 10/fplay - zarzadzanie skladami druzyn
  echo -a $chr(124) 10/fpyt - zadanie pytania
  echo -a $chr(124) 10/fauto - rozpoczenie autoquizu / ustawienie opoznienia
  echo -a $chr(124) 10/fautooff - zakonczenie autoquizu
  echo -a $chr(124) 10/fczas - ustawienie czasu trwania rundy
  echo -a $chr(124) 10/fpodp - wyswietlenie podpowiedzi
  echo -a $chr(124) . . .10 Szerszy opis komend na www.quizpl.net
}

alias -l fodmiana2 return $iif($1 == 1,$2,$iif(($calc($1 % 10) isnum 2-4) && ($calc($1 % 100) !isnum 12-14),$3,$4))

alias -l franking {
  inc %fam_temp_ilosc
  set %fam_temp_miejsce [ $+ [ %fam_temp_ilosc ] ] $1
}

alias -l fsort {
  var %fam_temp1 = 1
  while (%fam_temp1 < %fam_temp_ilosc) {
    var %fam_temp2 = $calc(%fam_temp1 + 1)
    while (%fam_temp2 <= %fam_temp_ilosc) {
      var %fam_temp_nick1 = %fam_temp_miejsce [ $+ [ %fam_temp1 ] ]
      var %fam_temp_nick2 = %fam_temp_miejsce [ $+ [ %fam_temp2 ] ]
      var %fam_temp_punkty1 = %fam_nick_ [ $+ [ %fam_temp_nick1 ] $+ ] _punkty
      var %fam_temp_punkty2 = %fam_nick_ [ $+ [ %fam_temp_nick2 ] $+ ] _punkty
      if (%fam_temp_punkty1 < %fam_temp_punkty2) {
        set %fam_temp_miejsce [ $+ [ %fam_temp1 ] ] %fam_temp_nick2
        set %fam_temp_miejsce [ $+ [ %fam_temp2 ] ] %fam_temp_nick1
      }
      inc %fam_temp2
    }
    inc %fam_temp1
  }
}

alias fwynik {
  var %fam_temp = 1
  var %fam_temp_d1
  var %fam_temp_d2
  set %fam_temp_ilosc 0  
  while ((%fam_temp <= $lines(" $+ $scriptdir $+ team1.fam $+ ")) || (%fam_temp <= $lines(" $+ $scriptdir $+ team2.fam $+ "))) {
    var %fam_temp1 = $read(" $+ $scriptdir $+ team1.fam $+ " , %fam_temp)
    var %fam_temp2 = $read(" $+ $scriptdir $+ team2.fam $+ " , %fam_temp)
    var %fam_temp_d1 = %fam_temp_d1 %fam_temp1
    var %fam_temp_d2 = %fam_temp_d2 %fam_temp2
    if (%fam_temp1) franking %fam_temp1
    if (%fam_temp2) franking %fam_temp2
    inc %fam_temp
  }
  fsort
  fsay 8,1 8 8 8 8 8 8 8 8 8 WYNIKI: 8 8 8 8 8 8 8 8 8
  var %fam_pkt1 = $iif(%fam_druzyna1_punkty > %fam_druzyna2_punkty,%fam_druzyna1_punkty,%fam_druzyna2_punkty)
  var %fam_pkt2 = $iif(%fam_druzyna1_punkty > %fam_druzyna2_punkty,%fam_druzyna2_punkty,%fam_druzyna1_punkty)
  var %fam_odp1 = $iif(%fam_druzyna1_punkty > %fam_druzyna2_punkty,%fam_druzyna1_odpowiedzi,%fam_druzyna2_odpowiedzi)
  var %fam_odp2 = $iif(%fam_druzyna1_punkty > %fam_druzyna2_punkty,%fam_druzyna2_odpowiedzi,%fam_druzyna1_odpowiedzi)
  fsay 31. Druzyna:12 $iif(%fam_druzyna1_punkty > %fam_druzyna2_punkty,%fam_team1_name,%fam_team2_name) 4(6 $iif(%fam_druzyna1_punkty > %fam_druzyna2_punkty,%fam_temp_d1,%fam_temp_d2) 4):5 %fam_pkt1 4 $+ $fodmiana2(%fam_pkt1,punkt,punkty,punktow) $+ ,5 %fam_odp1 4 $+ $fodmiana2(%fam_odp1,odpowiedz,odpowiedzi,odpowiedzi) $+ .
  fsay 32. Druzyna:12 $iif(%fam_druzyna1_punkty > %fam_druzyna2_punkty,%fam_team2_name,%fam_team1_name) 4(6 $iif(%fam_druzyna1_punkty > %fam_druzyna2_punkty,%fam_temp_d2,%fam_temp_d1) 4):5 %fam_pkt2 4 $+ $fodmiana2(%fam_pkt2,punkt,punkty,punktow) $+ ,5 %fam_odp2 4 $+ $fodmiana2(%fam_odp2,odpowiedz,odpowiedzi,odpowiedzi) $+ .
  var %fam_temp_ile = %fam_temp_ilosc
  if ($1) var %fam_temp_ile = $1
  var %fam_temp = 0
  var %fam_temp_place = 0
  while (%fam_temp < %fam_temp_ile) {
    inc %fam_temp
    inc %fam_temp_place
    if (%fam_temp <= %fam_temp_ilosc) {
      var %fam_temp_nick = %fam_temp_miejsce [ $+ [ %fam_temp ] ]
      var %fam_temp_punkty = %fam_nick_ [ $+ [ %fam_temp_nick ] $+ ] _punkty
      var %fam_temp_odpowiedzi = %fam_nick_ [ $+ [ %fam_temp_nick ] $+ ] _odpowiedzi
    }
    else {
      var %fam_temp_nick = -----
      var %fam_temp_punkty = 0
      var %fam_temp_odpowiedzi = 0
    }
    if (%fam_temp_punkty != $null) {
      fsay 4 $+ %fam_temp_place $+ . Miejsce:6 %fam_temp_nick 4:5 %fam_temp_punkty 4 $+ $fodmiana2(%fam_temp_punkty ,punkt,punkty,punktow) $+ ,5 %fam_temp_odpowiedzi 4 $+ $fodmiana2(%fam_temp_odpowiedzi ,odpowiedz,odpowiedzi,odpowiedzi) $+ .
    }
    else {
      dec %fam_temp_place
    }
  }
  unset %fam_temp*
}
