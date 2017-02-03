;------------------------------- R E M O T E ------------------------------------------------------------------------------------------------
on 1:start: {
  hfree -w famtable
  hfree -w famignore
  hfree -w famstat
  hmake famtable 50
  hmake famignore 50
  hmake famstat 100
  hload -i famstat " $+ $scriptdir $+ familiada.ini $+ " stat
  hload -i famignore " $+ $scriptdir $+ familiada.ini $+ " ignore
  var %fam_temp = 1
  while (%fam_temp <= %fam_odp#) {
    if ($gettok(%fam_odpowiedz [ $+ [ %fam_temp ] ] ,1,32) == .) hadd famtable %fam_temp $gettok(%fam_odpowiedz [ $+ [ %fam_temp ] ] ,2-,32)
    inc -u0 %fam_temp
  }
  if (($var(%fam_odp#)) && (!$timer(familiada))) .timerfamiliada -o 1 %fam_delay f_end 7,2 *** Czas minal! *** Koniec Rundy $calc(%fam_rundy + 1)
  if ((!$var(%fam_odp#)) && ($var(%fam_auto_linenr))) .timerfamiliadaauto -o 1 %fam_auto_delay fautopyt
  if (!$var(%fam_loaded2)) { set %fam_loaded2 | fecho Wpisz /fkom by uzyskac liste komend } 
}
on *:text:*:%fam_kanal: {
  var %fam_temp = 1
  while (%fam_temp <= $hget(famignore,0).item) {
    if (($hget(famignore, %fam_temp).data iswm $fulladdress) || ($hget(famignore, %fam_temp).data == $nick)) halt
    inc -u0 %fam_temp
  }
  if ((%fam_ingame_ [ $+ [ $nick ] ] ) && ($hfind(famtable,$1-).data)) f_zgaduje $ifmatch $nick
  if ($1- == !przyp) f_przyp
  elseif ($1- == !join 1) f_join $nick 1 %fam_ingame_ [ $+ [ $nick ] ]
  elseif ($1- == !join 2) f_join $nick 2 %fam_ingame_ [ $+ [ $nick ] ]
  elseif ($1- == !part) f_part $nick $calc(0 + %fam_ingame_ [ $+ [ $nick ] ] )
  elseif ($1- == !pkt) f_statystyka $nick
  elseif (($1 == !pkt) && ($0 > 1)) f_punktacja $nick $2 $calc(0 + %fam_nick_ [ $+ [ $2 ] $+ [ _punkty ] ] ) $calc(0 + %fam_nick_ [ $+ [ $2 ] $+ [ _odpowiedzi ] ] )
  elseif (($1 == !team) && ($0 > 1)) f_team $calc(0 + %fam_ingame_ [ $+ [ $nick ] ] ) $2-
}
on *:dialog:famnew:edit:11,21: {
  while (($did(famnew,21).lines > 1) && ($len($strip($replace($did(famnew,21,1),$chr(9),$chr(32)))) == 0)) { did -d famnew 21 1 }
  if (($len($strip($replace($did(famnew,11,1),$chr(9),$chr(32)))) > 0) && ($len($strip($replace($did(famnew,21,1),$chr(9),$chr(32)))) > 0)) did -e famnew 30
  else did -b famnew 30
}
on *:dialog:famnew:init:0: {
  didtok famnew 500 44 Czas trwania rundy: 15s,Czas trwania rundy: 30s,Czas trwania rundy: 45s,Czas trwania rundy: 60s,Czas trwania rundy: 75s,Czas trwania rundy: 90s,Czas trwania rundy: 105s,Czas trwania rundy: 120s
  didtok famnew 703 44 Przerwa miedzy rundami autoquizu: 1s,Przerwa miedzy rundami autoquizu: 2s,Przerwa miedzy rundami autoquizu: 3s,Przerwa miedzy rundami autoquizu: 4s,Przerwa miedzy rundami autoquizu: 5s,Przerwa miedzy rundami autoquizu: 6s,Przerwa miedzy rundami autoquizu: 7s,Przerwa miedzy rundami autoquizu: 8s,Przerwa miedzy rundami autoquizu: 9s,Przerwa miedzy rundami autoquizu: 10s,Przerwa miedzy rundami autoquizu: 15s,Przerwa miedzy rundami autoquizu: 20s,Przerwa miedzy rundami autoquizu: 25s,Przerwa miedzy rundami autoquizu: 30s,Przerwa miedzy rundami autoquizu: 40s,Przerwa miedzy rundami autoquizu: 50s,Przerwa miedzy rundami autoquizu: 60s
  did -c famnew 500 $calc(%fam_delay /  15)
  if ((!$var(%fam_auto_file)) && (!$timer(familiada))) halt
  did -m famnew 21
  did -mra famnew 11 %fam_pytanie
  var %fam_temp = 1
  var %fam_temp_mnoznik = $calc(%fam_odp# - 1)
  var %fam_temp_przelicznik = $calc(45 / %fam_temp_mnoznik)
  while (%fam_temp <= %fam_odp#) {
    if (%fam_temp == 1) var %fam_temp_pkt = 50
    else var %fam_temp_pkt = $calc(5 + %fam_temp_mnoznik * %fam_temp_przelicznik))
    if ($count(%fam_temp_pkt ,.)) {
      if ($calc(%fam_temp_pkt - $int(%fam_temp_pkt)) >= 0.5) var %fam_temp_pkt = $calc($int(%fam_temp_pkt) + 1)
      else var %fam_temp_pkt = $int(%fam_temp_pkt)
    }
    if ($gettok(%fam_odpowiedz [ $+ [ %fam_temp ] ] ,1,32) == .) did -a famnew 21 %fam_temp_pkt pkt: $gettok(%fam_odpowiedz [ $+ [ %fam_temp ] ] ,2-,32) $crlf
    else did -a famnew 21 ---odgadniete--- $crlf
    inc -u0 %fam_temp
    dec -u0 %fam_temp_mnoznik
  }
}
on *:dialog:famhelp:init:0: {
  did -a famhelp 10 Aby rozpoczac runde, wpisz tresc pytania i poszczegolne odpowiedzi - po jednej w linijce. Odpowiedzi sa punktowane malejaco wedlug kolejnosci na liscie - za najwyzsza 50 punktow, za najnizsza 5 punktow. Koniec rundy nastepuje po uplywie okreslonego czasu lub po odgadnieciu wszystkich odpowiedzi. Czas trwania rundy mozesz zmienic przy pomocy rozwijanej listy (czas aktywnej rundy pozostanie niezmieniony).
  did -a famhelp 10 $crlf $crlf $+ W polu edycji "Lista ignorowanych osob" wpisz maske adresu/nick gracza, ktory ma byc ignorowany w grze. Po zatwierdzeniu klawiszem ENTER wpis zostanie dodany do listy ignorowanych. Wszystkie polecenia lub odpowiedzi podawane przez gracza o tym nicku lub adresie beda ignorowane. Aby usunac wpis z listy ignorowanych kliknij na nim dwukrotnie. 
  did -a famhelp 10 $crlf $crlf $+ Przycisk "Uruchom autoquiz" sluzy do wyboru pliku z autoquizem i rozpoczecia autoquizu (komenda /fauto). Po rozpoczeciu autoquizu przycisk zmienia funkcje na "Wylacz autoquiz", ktora konczy uruchomiony autoquiz (komenda /fautooff). Miedzy kolejnymi rundami autoquizu nastepuje przerwa, ktorej dlugosc wybrac mozesz z rozwijanej listy.
  did -a famhelp 10 $crlf $crlf $+ "Wyswietl wyniki" podaje na kanale aktualne wyniki gry, "Odkurzacz" wywoluje komende /fclean usuwajaca ze skladow druzyn wszystkich graczy nieobecnych na kanale.
  did -a famhelp 10 $crlf $crlf $+ Podczas trwania rundy niektore kontrolki staja sie nieaktywne, zmiana ich zawartosci bedzie mozliwa dopiero po zakonczeniu rundy.
}
on *:dialog:famnew:sclick:600: dialog $iif($dialog(famhelp),-v famhelp,-vm famhelp famhelp)
on *:dialog:famnew:sclick:500: fczas $calc($did(famnew,500).sel * 15)
on *:dialog:famnew:sclick:703: f_autoczas $left($gettok($did(famnew,703).seltext,5,32),-1)
on *:dialog:famnew:sclick:30: fpyt2
on *:dialog:famnew:dclick:402: f_remove_ignore dialog
on *:dialog:famnew:sclick:302: fclean
on *:dialog:famnew:sclick:303: {
  if ($dialog(famnew).focus == 11) did -f famnew 21
  elseif ((($dialog(famnew).focus == 401) || ($dialog(famnew).focus == 303)) && (($len($strip($replace($did(famnew,401,1),$chr(9),$chr(32)))) > 0))) f_ignoreplayer dialog
}
on *:dialog:famnew:sclick:304: fwynik
on *:dialog:famnew:sclick:701: { if ($did(famnew,701).text == Uruchom autoquiz) fauto | else fautooff }
on *:dialog:famnew:edit:401: {
  if ($right($did(401),1) == $chr(32)) {
    did -o famnew 401 1 $left($did(401),-1)
    did -c famnew 401 1 200 200
  }
}
on *:dialog:famnew:close:0: f_dialog_onclose

;------------------------------------ D I A L O G -------------------------------------------------------------------------------------------
dialog -l famnew {
  option dbu
  title "Familiada"
  size %fam_dialog_x %fam_dialog_y 235 286

  box Lista ignorowanych osob,400, 5 218 225 63
  edit ,401,10 228 215 10,autohs limit 200
  button ,303,250 10 10 10,default hide
  list 402,10 238 215 50,hsbar

  button Wyswietl wyniki,304,65 200 60 15
  button Odkurzacz,302,125 200 45 15
  button Help,600,190 200 40 15

  box ,9,5 1 225 178
  text Pytanie:,10,10 9 215 8,center
  edit ,11,10 19 215 10,autohs
  text Lista odpowiedzi:,20,10 34 215 8,center
  edit ,21,10 44 215 110,multi vsbar hsbar return
  button Rozpocznij runde,30,10 159 215 15,disable
  combo 500,5 184 90 10,drop

  button Uruchom autoquiz,701,5 200 60 15 
  combo 703,95 184 135 10,drop

}
dialog -l famhelp {
  option dbu 
  title "Famhelp"
  size -1 -1 200 130
  edit ,10,0 0 200 130,multi read vsbar
}

;-------------------------------------- K O M E N D Y ---------------------------------------------------------------------------------------
alias fon {
  if ($var(%fam_kanal)) fecho Familiada jest juz uruchomiona na kanale %fam_kanal
  if (($len($chan) < 1) && ($len($1) < 1) && (!$var(%fam_kanal))) fecho Nie okresliles(as) nazwy kanalu
  unset %fam_*
  hfree -w famtable
  hfree -w famignore
  hfree -w famstat
  hmake famtable 50
  hmake famignore 50
  hmake famstat 100
  if ($0) set %fam_kanal $zmiana(#$1)
  else set %fam_kanal $chan
  set %fam_loaded2
  set %fam_rundy 0 
  set %fam_team1_punkty 0
  set %fam_team2_punkty 0
  set %fam_team1_odpowiedzi 0
  set %fam_team2_odpowiedzi 0
  set %fam_start $ctime
  set %fam_team1_name Druzyna I
  set %fam_team2_name Druzyna II
  set %fam_team1_noname
  set %fam_team2_noname
  set %fam_team1_sklad
  set %fam_team2_sklad
  set %fam_stat_sort
  set %fam_auto_delay $readini(" $+ $scriptdir $+ familiada.ini $+ " ,settings,auto_opoznienie)
  set %fam_dialog_x $readini(" $+ $scriptdir $+ familiada.ini $+ " ,settings,dialog_x)
  set %fam_dialog_y $readini(" $+ $scriptdir $+ familiada.ini $+ " ,settings,dialog_y)
  set %fam_delay $readini(" $+ $scriptdir $+ familiada.ini $+ " ,settings,opoznienie)
  fsay 8,1           -= FAMILIADA 0.72 =-          
  fsay 9,1 Dostepne komendy: 4,1!join 1   !join 2   !part
  fsay 4,1 !pkt   !przyp   !pkt [nick]   !team [nazwa]
}
alias fam {
  fchk
  if ($dialog(famnew)) { dialog -v famnew | halt }
  dialog -vm famnew famnew
  did -f famnew 11
  var %fam_temp = 1
  while (%fam_temp <= $hget(famignore,0).item) {
    did -a famnew 402 $hget(famignore,%fam_temp).data
    inc -u0 %fam_temp
  }
  did -z famnew 402
  if (%fam_auto_delay <= 10) did -c famnew 703 %fam_auto_delay 
  elseif (%fam_auto_delay <= 25) did -c famnew 703 $calc(8 + %fam_auto_delay / 5)
  else did -c famnew 703 $calc(11 + %fam_auto_delay / 10)
  if (%fam_auto_linenr) did -o famnew 701 1 Wylacz autoquiz
}
alias foff {
  fchk
  if ($dialog(famnew)) dialog -x famnew
  if ($dialog(famhelp)) dialog -x famhelp
  .timerfamiliada* off 
  fsay 8,1            FAMILIADA ZAKONCZONA          
  if (%fam_rundy < 10) fsay 4,1 Liczba rund:9 $chr(91) %fam_rundy $chr(93) 4,1 Czas gry:9 $ftime(%fam_start)
  else fsay 4,1 Liczba rund:9 $chr(91) %fam_rundy $chr(93) 4,1Czas gry:9 $ftime(%fam_start)
  fsay 15,1          Autorzy: 8snajperx15 & 8Andrrew        
  fsay 11,1        http://www.swistak.kfizz.prv.pl      
  writeini -n " $+ $scriptdir $+ familiada.ini $+ " settings auto_opoznienie %fam_auto_delay
  writeini -n " $+ $scriptdir $+ familiada.ini $+ " settings dialog_x %fam_dialog_x
  writeini -n " $+ $scriptdir $+ familiada.ini $+ " settings dialog_y %fam_dialog_y
  writeini -n " $+ $scriptdir $+ familiada.ini $+ " settings opoznienie %fam_delay
  unset %fam_*
  set %fam_loaded2
  hfree -w famtable
  hfree -w famignore
  hfree -w famstat
  remini -n " $+ $scriptdir $+ familiada.ini $+ " ignore
  remini -n " $+ $scriptdir $+ familiada.ini $+ " stat
  remini -n " $+ $scriptdir $+ familiada.ini $+ " team1
  remini -n " $+ $scriptdir $+ familiada.ini $+ " team2
}
alias fauto {
  fchk
  if ($istok(1 2 3 4 5 6 7 8 9 10 15 20 25 30 40 50 60,$1-,32)) f_autoczas $int($1-)
  elseif ($len(%fam_auto_file) > 0) fecho Autoquiz jest juz uruchomiony
  set -u0 %fam_auto_file $dir="Wybierz plik z pytaniami" $scriptdir
  if ($len(%fam_auto_file) < 1) halt
  else set %fam_auto_file " $+ %fam_auto_file $+ "
  inc %fam_auto_linenr
  %fam_auto_line = $read(%fam_auto_file , %fam_auto_linenr)
  %fam_auto_line2 = $read(%fam_auto_file , $calc(%fam_auto_linenr + 1))
  fsay 9,2 *** Poczatek Autoquiza (przerwy %fam_auto_delay $+ s) ***
  if ($dialog(famnew)) did -o famnew 701 1 Wylacz autoquiz
  if (($len($zmiana(%fam_auto_line)) < 1) || ($len($zmiana(%fam_auto_line2)) < 1)) fautooff
  else fautopyt
}
alias fautooff {
  fchk
  if (($var(%fam_odp#)) && ($var(%fam_auto_file))) fecho Poczekaj na zakonczenie rundy
  if (!$var(%fam_auto_file)) fecho Autoquiz nie jest uruchomiony
  .timerfamiliadaauto off
  var %fam_temp = %fam_auto_delay
  unset %fam_auto*
  %fam_auto_delay = %fam_temp
  fsay 7,2 *** Koniec Autoquiza ***
  if ($dialog(famnew)) { did -nr famnew 11,21 | did -o famnew 701 1 Uruchom autoquiz }
  halt
}
alias fkom {
  echo -a 8,1 :famhelp: 
  echo -a 1,1  Dostepne komendy:
  echo -a 1,1  /fon - rozpoczecie Familiady
  echo -a 1,1  /foff - zakonczenie Familiady
  echo -a 1,1  /fam - otwarcie okienka gry
  echo -a 1,1  /fauto [1-10/15/20/25/30/40/50/60] - rozpoczecie autoquizu lub zmiana opoznienia autoquizu
  echo -a 1,1  /fautooff - zakonczenie autoquizu
  echo -a 1,1  /fwynik [liczba] - wyswietla wyniki druzyn i poszczegolnych graczy (domyslnie do 10 obsadzonych miejsc)
  echo -a 1,1  /fignore [nick] - dodaje nick/maske do listy ignore
  echo -a 1,1  /-fignore [nick] - usuwa nick/maske z listy ignore
  echo -a 1,1  /fczas [15/30/45/60/75/90/105/120] - zmiana czasu trwania rundy
  echo -a 1,1  /fclean - usuwa z druzyn graczy nieobecnych na kanale quizu
  echo -a 1,1  /funload - wyladowuje skrypt (stan gry pozostaje niezmieniony)
  echo -a 1,1___________________________
}
alias fignore f_ignore + $1-
alias -fignore f_ignore - $1-
alias fwynik {
  fchk
  var %fam_temp_output = $eval(3pos.12 %fam_teamx_name 4(6 %fam_teamx_sklad 4):5 %fam_teamx_punkty 3 $+ $fodmiana(%fam_teamx_punkty,punkt,punkty,punktow) za5 %fam_teamx_odpowiedzi 3 $+ $fodmiana(%fam_teamx_odpowiedzi,odpowiedz,odpowiedzi,odpowiedzi) $+ .,0) 
  var %fam_temp_output2 = $eval(4 $+ %fam_tmp1 $+ .6 %fam_tmp_nick 4:5 %fam_tmp_punkty 4 $+ $fodmiana(%fam_tmp_punkty,punkt,punkty,punktow) $+ .,0)
  fsay 8,1     WYNIKI DRUZYNOWE:    
  fsay $eval($replace(%fam_temp_output,pos,1,x,$iif(%fam_team1_punkty >= %fam_team2_punkty,1,2)),2)
  fsay $eval($replace(%fam_temp_output,pos,2,x,$iif(%fam_team1_punkty >= %fam_team2_punkty,2,1)),2)
  var %fam_tmp1 = 1
  var %fam_tmp_stat_pos = 1
  var %fam_tmp_plyr_pos = 1
  var %fam_tmp_punkty = $calc(0 + $gettok(%fam_stat_sort,1,32))
  if (!$hget(famstat,0).item) halt
  if ($1 != 0) fsay 8,1    WYNIKI INDYWIDUALNE:  
  while (%fam_tmp1 <= $iif($1 isnum 0-, $1 ,10)) {
    var %fam_tmp_nick = $gettok($hget(famstat,%fam_tmp_punkty),%fam_tmp_plyr_pos,32)
    fsay $eval(%fam_temp_output2,2)
    inc -u0 %fam_tmp1
    inc -u0 %fam_tmp_plyr_pos
    if (%fam_tmp_plyr_pos > $calc(0 + $numtok($hget(famstat,%fam_tmp_punkty),32))) {
      inc -u0 %fam_tmp_stat_pos
      var %fam_tmp_plyr_pos = 1
      var %fam_tmp_punkty = $calc(0 + $gettok(%fam_stat_sort,%fam_tmp_stat_pos,32))
      if (%fam_tmp_punkty == 0) break
    }
  }
}
alias fczas {
  fchk
  if (!$istok(15 30 45 60 75 90 105 120,$1,32)) fecho Obecny czas trwania rundy: %fam_delay $+ s
  set %fam_delay $1
  if ($dialog(famnew)) did -c famnew 500 $calc($1 / 15)
  fecho Czas trwania rundy zmieniony na %fam_delay $+ s
}
alias fclean {
  fchk
  var %fam_temp = 1
  while ((%fam_temp <= $ini(" $+ $scriptdir $+ familiada.ini $+ " ,team1,0)) || (%fam_temp <= $ini(" $+ $scriptdir $+ familiada.ini $+ " ,team2,0))) {
    if (($ini(" $+ $scriptdir $+ familiada.ini $+ " ,team1,%fam_temp)) && (!$nick(%fam_kanal , $ini(" $+ $scriptdir $+ familiada.ini $+ " ,team1,%fam_temp)))) {
      var %fam_tmp_removed1 = %fam_tmp_removed1 $ini(" $+ $scriptdir $+ familiada.ini $+ " ,team1,%fam_temp)
      set %fam_team1_sklad $remtok(%fam_team1_sklad,$ini(" $+ $scriptdir $+ familiada.ini $+ " ,team1,%fam_temp),1,32)
      unset %fam_ingame_ [ $+ [ $ini(" $+ $scriptdir $+ familiada.ini $+ " ,team1,%fam_temp) ] ]
    }
    if (($ini(" $+ $scriptdir $+ familiada.ini $+ " ,team2,%fam_temp)) && (!$nick(%fam_kanal , $ini(" $+ $scriptdir $+ familiada.ini $+ " ,team2,%fam_temp)))) {
      var %fam_tmp_removed2 = %fam_tmp_removed2 $ini(" $+ $scriptdir $+ familiada.ini $+ " ,team2,%fam_temp)
      set %fam_team2_sklad $remtok(%fam_team2_sklad,$ini(" $+ $scriptdir $+ familiada.ini $+ " ,team2,%fam_temp),1,32)
      unset %fam_ingame_ [ $+ [ $ini(" $+ $scriptdir $+ familiada.ini $+ " ,team2,%fam_temp) ] ]
    }
    inc -u0 %fam_temp
  }
  while (%fam_temp > 1) {
    dec -u0 %fam_temp
    if (%fam_temp <= $numtok(%fam_tmp_removed1 ,32)) remini -n " $+ $scriptdir $+ familiada.ini $+ " team1 $gettok(%fam_tmp_removed1,%fam_temp,32)
    if (%fam_temp <= $numtok(%fam_tmp_removed2 ,32)) remini -n " $+ $scriptdir $+ familiada.ini $+ " team2 $gettok(%fam_tmp_removed2,%fam_temp,32)
  }
  if ($var(%fam_tmp_removed1)) fsay 4,2 $iif($numtok(%fam_tmp_removed1,32) == 1,Gracz %fam_tmp_removed1 4zostal usuniety,Gracze %fam_tmp_removed1 4zostali usunieci) z druzyny9 %fam_team1_name
  if ($var(%fam_tmp_removed2)) fsay 4,2 $iif($numtok(%fam_tmp_removed2,32) == 1,Gracz %fam_tmp_removed2 4zostal usuniety,Gracze %fam_tmp_removed2 4zostali usunieci) z druzyny13 %fam_team2_name
  if (!$var(%fam_tmp_removed1) && (!$var(%fam_tmp_removed2))) fecho Nie ma nic do odkurzania.
}
alias funload {
  .timerfamiliada* off
  if ($dialog(famhelp)) dialog -x famhelp
  if ($dialog(famnew)) dialog -x famnew
  echo -a 8,1 FAMILIADA  Skrypt zostal wyladowany.   
  echo -a 8,1 FAMILIADA  Aby ponownie zaladowac skrypt, wpisz: /load -rs " $+ $script $+ "   
  unset %fam_loaded2
  .unload -rs " $+ $script $+ "
}

;------------------------------------------ A L I A S Y -------------------------------------------------------------------------------------
alias -l f_join {
  if ($3) f_part $1 $3
  writeini -n " $+ $scriptdir $+ familiada.ini $+ " team [ $+ [ $2 ] ] $1 $1
  set %fam_team [ $+ [ $2 ] $+ [ _sklad ] ] %fam_team [ $+ [ $2 ] $+ [ _sklad ] ] $1
  if ($2 == 1) .notice $1 dolaczyles(as) do druzyny3 " $+ %fam_team1_name $+ "
  elseif ($2 == 2) .notice $1 dolaczyles(as) do druzyny6 " $+ %fam_team2_name $+ "
  set %fam_ingame_ [ $+ [ $1 ] ] $2
  set %fam_nick_ [ $+ [ $1 ] $+ [ _punkty ] ] $calc(0 + %fam_nick_ [ $+ [ $1 ] $+ [ _punkty ] ] )
  set %fam_nick_ [ $+ [ $1 ] $+ [ _odpowiedzi ] ] $calc(0 + %fam_nick_ [ $+ [ $1 ] $+ [ _odpowiedzi ] ] )
}
alias -l f_part {
  if ($2 == 0) halt
  remini -n " $+ $scriptdir $+ familiada.ini $+ " team [ $+ [ $2 ] ] $1
  set %fam_team [ $+ [ $2 ] $+ [ _sklad ] ] $remtok(%fam_team [ $+ [ $2 ] $+ [ _sklad ] ] ,$1,1,32)
  if ($2 == 1) .notice $1 opusciles(as) druzyne3 " $+ %fam_team1_name $+ "
  elseif ($2 == 2) .notice $1 opusciles(as) druzyne6 " $+ %fam_team2_name $+ "
  unset %fam_ingame_ [ $+ [ $1 ] ]
  if (%fam_nick_ [ $+ [ $1 ] $+ [ _punkty ] ] == 0) unset %fam_nick_ [ $+ [ $1 ] $+ [ _punkty ] ] %fam_nick_ [ $+ [ $1 ] $+ [ _odpowiedzi ] ]
}
alias -l f_team if (($1 > 0) && ($0 > 1) && ($var(%fam_team [ $+ [ $1 ] $+ [ _noname ] ] ))) { set %fam_team [ $+ [ $1 ] $+ [ _name ] ] $zmiana($2-) | unset %fam_team [ $+ [ $1 ] $+ [ _noname  ] ] }
alias -l f_punktacja {
  if (($3 == 0) && (!$len(%fam_ingame_ [ $+ [ $2 ] ] ))) halt
  var %fam_temp_punkty = $3
  var %fam_temp1 = 1
  var %fam_temp2 = $findtok(%fam_stat_sort,%fam_temp_punkty,1,32))
  var %fam_temp_pos = 0
  while (%fam_temp1 < %fam_temp2) {
    inc -u0 %fam_temp_pos $numtok($hget(famstat,$gettok(%fam_stat_sort,%fam_temp1,32)),32)
    inc -u0 %fam_temp1
  }
  inc -u0 %fam_temp_pos $findtok($hget(famstat,$gettok(%fam_stat_sort,%fam_temp1,32)),$2,1,32)
  if ($len(%fam_ingame_ [ $+ [ $2 ] ] )) var %fam_temp3 = %fam_team [ $+ [ %fam_ingame_ [ $+ [ $2 ] ] ] $+ [ _name ] ]
  if ($3 == 0) {
    if (!$len(%fam_ingame_ [ $+ [ $2 ] ] )) .notice $1 $2 zdobyl(a) 0 pkt. w Familiadzie. $2 nie nalezy obeenie do zadnej z druzyn
    elseif (%fam_ingame_ [ $+ [ $2 ] ] == 1) .notice $1 $readini(" $+ $scriptdir $+ familiada.ini $+ " ,team1 ,$2) zdobyl(a) 0 pkt. w Familiadzie. $2 nalezy do druzyny3 $+(",%fam_temp3,")
    elseif (%fam_ingame_ [ $+ [ $2 ] ] == 2) .notice $1 $readini(" $+ $scriptdir $+ familiada.ini $+ " ,team2 ,$2) zdobyl(a) 0 pkt. w Familiadzie. $2 nalezy do druzyny6 $+(",%fam_temp3,")
  }
  else {
    if (!$len(%fam_ingame_ [ $+ [ $2 ] ] )) .notice $1 $2 zdobyl(a) lacznie $3 pkt. trafiajac $4 odp. i zajmuje %fam_temp_pos $+ . pozycje w rankingu Familiady.  $2 nie nalezy obecnie do zadnej z druzyn
    elseif (%fam_ingame_ [ $+ [ $2 ] ] == 1) .notice $1 $readini(" $+ $scriptdir $+ familiada.ini $+ " ,team1 ,$2) zdobyl(a) lacznie $3 pkt. trafiajac $4 odp. i zajmuje %fam_temp_pos $+ . pozycje w rankingu Familiady.  $2 nalezy do druzyny3 $+(",%fam_temp3,")
    elseif (%fam_ingame_ [ $+ [ $2 ] ] == 2) .notice $1 $readini(" $+ $scriptdir $+ familiada.ini $+ " ,team2 ,$2) zdobyl(a) lacznie $3 pkt. trafiajac $4 odp. i zajmuje %fam_temp_pos $+ . pozycje w rankingu Familiady.  $2 nalezy do druzyny6 $+(",%fam_temp3,")
  }
}
alias -l f_ignoreplayer {
  if ($1 == dialog) var %fam_temp_addr = $gettok($remove($did(famnew , 401),$chr(9)) ,1,32)
  else var %fam_temp_addr = $2
  if ($hfind(famignore , %fam_temp_addr , 1).data) fecho %fam_temp_addr zostal dodany do listy juz wczesniej
  if ($dialog(famnew)) {
    if ($1 == dialog) did -rf famnew 401
    did -a famnew 402 %fam_temp_addr
    did -z famnew 402
  }
  writeini -n " $+ $scriptdir $+ familiada.ini $+ " ignore %fam_temp_addr %fam_temp_addr
  hload -ni famignore " $+ $scriptdir $+ familiada.ini $+ " ignore
}
alias -l f_remove_ignore {
  if (($1 == dialog) && ($did(famnew , 402).sel == 0)) return
  elseif (($1 == command) && (!$hfind(famignore, $2 ,1).data)) fecho $2 nie ma na liscie ignore
  if ($1 == dialog) remini -n " $+ $scriptdir $+ familiada.ini $+ " ignore $did(famnew,402).seltext
  else remini -n " $+ $scriptdir $+ familiada.ini $+ " ignore $2
  hfree -w famignore
  hmake famignore 50
  hload -ni famignore " $+ $scriptdir $+ familiada.ini $+ " ignore
  if ($dialog(famnew)) {
    if ($1 == dialog) did -d famnew 402 $did(famnew , 402).sel
    else did -d famnew 402 $findtok($didtok(famnew,402,32),$2,1,32)
    did -z famnew 402
  }
}
alias -l fecho {
  echo -a 8,1 FAMILIADA  $1- 
  halt
}
alias -l fsay $iif(%fam_kanal ischan,msg %fam_kanal,echo -a 15 %fam_kanal --->) $1- 
alias -l fchk if ($len(%fam_kanal) < 1) fecho Najpierw uruchom Familiade
alias -l zmiana return $replace($1-,,,,,,,,,,)
alias -l fodmiana return $iif($1 == 1 , $2 , $iif(($calc($1 % 10) isnum 2-4) && ($calc($1 % 100) !isnum 12-14) , $3 , $4))
alias -l fpyt2 {
  set %fam_pytanie $zmiana($did(famnew,11))
  set %fam_odp# 0
  var %fam_temp = 1
  var %fam_temp2 = 1
  hfree -w famtable
  hmake famtable 50
  while (%fam_temp <= $did(famnew,21).lines) {
    var %fam_temp_txt = $zmiana($did(famnew,21,%fam_temp))
    if ($len(%fam_temp_txt) > 0) {
      set %fam_odpowiedz [ $+ [ %fam_temp2 ] ] . %fam_temp_txt
      inc %fam_odp#
      hadd famtable %fam_odp# %fam_temp_txt
      inc -u0 %fam_temp2
    }
    inc -u0 %fam_temp
  }
  did -mr famnew 11,21
  did -a famnew 11 %fam_pytanie
  did -b famnew 30
  var %fam_temp = 1
  var %fam_temp_mnoznik = $calc(%fam_odp# - 1)
  var %fam_temp_przelicznik = $calc(45 / %fam_temp_mnoznik)
  var %fam_temp_#tabeli = 1
  unset %fam_tabela_odpowiedzi*
  set %fam_tabela_odpowiedzi1 8,1 Pytanie: %fam_pytanie
  while ($var(%fam_odpowiedz [ $+ [ %fam_temp ] ] )) {
    if (%fam_temp == 1) var %fam_temp_pkt = 50
    else var %fam_temp_pkt = $calc(5 + %fam_temp_mnoznik * %fam_temp_przelicznik))
    if ($count(%fam_temp_pkt ,.)) {
      if ($calc(%fam_temp_pkt - $int(%fam_temp_pkt)) >= 0.5) var %fam_temp_pkt = $calc($int(%fam_temp_pkt) + 1)
      else var %fam_temp_pkt = $int(%fam_temp_pkt)
    }
    did -a famnew 21 %fam_temp_pkt pkt : $gettok(%fam_odpowiedz [ $+ [ %fam_temp ] ] ,2-,32) $crlf
    set %fam_tabela_odpowiedzi [ $+ [ %fam_temp_#tabeli ] ] %fam_tabela_odpowiedzi [ $+ [ %fam_temp_#tabeli ] ] 1,1 1,15 %fam_temp $+ . -----
    inc -u0 %fam_temp
    dec -u0 %fam_temp_mnoznik
    if ($len(%fam_tabela_odpowiedzi [ $+ [ %fam_temp_#tabeli ] ] ) > 400) inc -u0 %fam_temp_#tabeli
  }
  did -c famnew 21 1
  var %fam_temp1 = 1
  while (%fam_temp1 <= %fam_temp_#tabeli) {
    if (%fam_temp1 == %fam_temp_#tabeli) fsay %fam_tabela_odpowiedzi [ $+ [ %fam_temp1 ] ] 7,1 Czas: %fam_delay $+ s
    else fsay %fam_tabela_odpowiedzi [ $+ [ %fam_temp1 ] ]
    inc -u0 %fam_temp1
  }
  .timerfamiliada -o 1 %fam_delay f_end 7,2 *** Czas minal! *** Koniec Rundy $calc(%fam_rundy + 1)
}
alias -l f_przyp {
  if (!$var(%fam_tabela_odpowiedzi1)) return
  var %fam_temp_#tabeli = 1
  while ($var(%fam_tabela_odpowiedzi [ $+ [ %fam_temp_#tabeli ] ] )) {
    if (!$var(%fam_tabela_odpowiedzi [ $+ [ $calc(%fam_temp_#tabeli + 1) ] ] )) fsay %fam_tabela_odpowiedzi [ $+ [ %fam_temp_#tabeli ] ] 7,1 Pozostalo $timer(familiada).secs $+ s
    else fsay %fam_tabela_odpowiedzi [ $+ [ %fam_temp_#tabeli ] ]
    inc -u0 %fam_temp_#tabeli
  }
}
alias -l f_zgaduje {
  if ($dialog(famnew)) did -o famnew 21 $1 ---odgadniete---
  var %fam_temp_mnoznik = $calc(%fam_odp# - $1)
  var %fam_temp_przelicznik = $calc(45 / (%fam_odp# - 1))
  if ($1 == 1) var %fam_temp_pkt = 50
  else var %fam_temp_pkt = $calc(5 + %fam_temp_mnoznik * %fam_temp_przelicznik))
  if ($count(%fam_temp_pkt ,.)) {
    if ($calc(%fam_temp_pkt - $int(%fam_temp_pkt)) >= 0.5) var %fam_temp_pkt = $calc($int(%fam_temp_pkt) + 1)
    else var %fam_temp_pkt = $int(%fam_temp_pkt)
  }
  fam_rank $2 $calc(0 + %fam_nick_ [ $+ [ $2 ] $+ [ _punkty ] ] ) %fam_temp_pkt
  inc %fam_team [ $+ [ %fam_ingame_ [ $+ [ $2 ] ] ] $+ [ _punkty ] ] %fam_temp_pkt
  inc %fam_team [ $+ [ %fam_ingame_ [ $+ [ $2 ] ] ] $+ [ _odpowiedzi ] ] 1
  inc %fam_nick_ [ $+ [ $2 ] $+ [ _punkty ] ] %fam_temp_pkt
  inc %fam_nick_ [ $+ [ $2 ] $+ [ _odpowiedzi ] ] 1
  var %fam_temp_#tabeli = 1
  var %fam_temp_#odpowiedzi = 1
  unset %fam_tabela_odpowiedzi*
  set %fam_tabela_odpowiedzi1 8,1 Pytanie: %fam_pytanie
  set %fam_odpowiedz [ $+ [ $1 ] ] $puttok(%fam_odpowiedz [ $+ [ $1 ] ] ,-,1,32)
  while (%fam_temp_#odpowiedzi <= %fam_odp#) {
    if ($gettok(%fam_odpowiedz [ $+ [ %fam_temp_#odpowiedzi ] ] ,1,32) == -) set %fam_tabela_odpowiedzi [ $+ [ %fam_temp_#tabeli ] ] %fam_tabela_odpowiedzi [ $+ [ %fam_temp_#tabeli ] ] 1,1 1,15 %fam_temp_#odpowiedzi $+ . $gettok(%fam_odpowiedz [ $+ [ %fam_temp_#odpowiedzi ] ] ,2-,32)
    else set %fam_tabela_odpowiedzi [ $+ [ %fam_temp_#tabeli ] ] %fam_tabela_odpowiedzi [ $+ [ %fam_temp_#tabeli ] ] 1,1 1,15 %fam_temp_#odpowiedzi $+ . -----
    inc -u0 %fam_temp_#odpowiedzi
    var %fam_temp_nastepnaOdp = $gettok(%fam_odpowiedz [ $+ [ %fam_temp_#odpowiedzi ] ] ,2-,32)
    if ($gettok(%fam_odpowiedzi [ $+ [ %fam_temp_#odpowiedzi ] ] ,1,32) == -) {
      if ($calc($len(%fam_tabela_odpowiedzi [ $+ [ %fam_temp_#tabeli ] ] ) + 14 + $len(%fam_temp_#odpowiedzi) + $len(%fam_temp_nastepnaOdp)) > 400) inc -u0 %fam_temp_#tabeli
    }
    elseif ($calc($len(%fam_tabela_odpowiedzi [ $+ [ %fam_temp_#tabeli ] ] ) + 18 + $len(%fam_temp_#odpowiedzi)) > 400) inc -u0 %fam_temp_#tabeli
  }
  if (%fam_ingame_ [ $+ [ $2 ] ] == 1) fsay 0,3  0,2 $2 11zdobywa0 %fam_temp_pkt 11pkt. dla %fam_team1_name za0 $gettok(%fam_odpowiedz [ $+ [ $1 ] ] ,2-,32) 
  if (%fam_ingame_ [ $+ [ $2 ] ] == 2) fsay 0,13  0,2 $2 11zdobywa0 %fam_temp_pkt 11pkt. dla %fam_team2_name za0 $gettok(%fam_odpowiedz [ $+ [ $1 ] ] ,2-,32) 
  hdel famtable $1
  if ($hget(famtable,0).item == 0) f_end 7,2 Koniec Rundy $calc(%fam_rundy + 1)  
}
alias -l f_statystyka {
  .notice $1 3 %fam_team1_name ( $+ %fam_team1_sklad $+ ): %fam_team1_punkty pkt. %fam_team1_odpowiedzi odp. * 6 %fam_team2_name ( $+ %fam_team2_sklad $+ ): %fam_team2_punkty pkt. %fam_team2_odpowiedzi odp. * Czas gry: %fam_rundy $fodmiana(%fam_rundy ,runda,rundy,rund) ( $+ $ftime(%fam_start) $+ )
  if (!$var(%fam_nick_ [ $+ [ $1 ] $+ [ _punkty ] ] )) halt
  elseif (%fam_nick_ [ $+ [ $1 ] $+ [ _punkty ] ] == 0) .notice $1 Zdobyles(as) 0 pkt. w Familiadzie.
  elseif (%fam_nick_ [ $+ [ $1 ] $+ [ _punkty ] ] > 0) {
    var %fam_temp_punkty = %fam_nick_ [ $+ [ $1 ] $+ [ _punkty ] ]
    var %fam_temp_odpowiedzi = %fam_nick_ [ $+ [ $1 ] $+ [ _odpowiedzi ] ]
    var %fam_temp1 = 1
    var %fam_temp2 = $findtok(%fam_stat_sort,%fam_temp_punkty,1,32))
    var %fam_temp_pos = 0
    while (%fam_temp1 < %fam_temp2) {
      inc -u0 %fam_temp_pos $numtok($hget(famstat,$gettok(%fam_stat_sort,%fam_temp1,32)),32)
      inc -u0 %fam_temp1
    }
    inc -u0 %fam_temp_pos $findtok($hget(famstat,$gettok(%fam_stat_sort,%fam_temp1,32)),$1,1,32)
    .notice $1 Zdobyles(as) lacznie %fam_temp_punkty pkt. trafiajac %fam_temp_odpowiedzi odp. i zajmujesz %fam_temp_pos $+ . pozycje w rankingu Familiady
  }
}
alias -l ftime {
  var %fam_tmp_dni = $int($calc(0 + ($ctime - %fam_start)/86400))
  var %fam_tmp_godz = $int($calc(0 + ($ctime - %fam_start - 86400 * %fam_tmp_dni)/3600))
  var %fam_tmp_min = $int($calc(0 + ($ctime - %fam_start - 86400 * %fam_tmp_dni - 3600 * %fam_tmp_godz)/60))
  var %fam_tmp_sek = $calc(0 + $ctime - %fam_start - 86400 * %fam_tmp_dni - 3600 * %fam_tmp_godz - 60 * %fam_tmp_min)
  return %fam_tmp_dni $fodmiana(%fam_tmp_dni,dzien,dni,dni) $base(%fam_tmp_godz ,10,10,2) $+ : $+ $base(%fam_tmp_min ,10,10,2) $+ : $+ $base(%fam_tmp_sek ,10,10,2)
}
alias -l f_end {
  .timerfamiliada off
  inc %fam_rundy
  fsay $1-
  fsay 9,1 %fam_team1_name ( $+ %fam_team1_sklad $+ ):8 %fam_team1_punkty
  fsay 13,1 %fam_team2_name ( $+ %fam_team2_sklad $+ ):8 %fam_team2_punkty
  unset %fam_tabela_odpowiedzi*
  var %fam_temp_#tabeli = 1
  var %fam_temp_#odpowiedzi = 1
  while (%fam_temp_#odpowiedzi <= %fam_odp#) {
    if ($gettok(%fam_odpowiedz [ $+ [ %fam_temp_#odpowiedzi ] ] ,1,32) == .) set %fam_tabela_odpowiedzi [ $+ [ %fam_temp_#tabeli ] ] %fam_tabela_odpowiedzi [ $+ [ %fam_temp_#tabeli ] ] 8,1 1,15 %fam_temp_#odpowiedzi $+ .4 $gettok(%fam_odpowiedz [ $+ [ %fam_temp_#odpowiedzi ] ] ,2-,32)
    else set %fam_tabela_odpowiedzi [ $+ [ %fam_temp_#tabeli ] ] %fam_tabela_odpowiedzi [ $+ [ %fam_temp_#tabeli ] ] 8,1 1,15 %fam_temp_#odpowiedzi $+ . $gettok(%fam_odpowiedz [ $+ [ %fam_temp_#odpowiedzi ] ] ,2-,32)
    inc -u0 %fam_temp_#odpowiedzi
    var %fam_temp_nastepnaOdp = $gettok(%fam_odpowiedz [ $+ [ %fam_temp_#odpowiedzi ] ] ,2-,32)
    if ($calc($len(%fam_tabela_odpowiedzi [ $+ [ %fam_temp_#tabeli ] ] ) + 14 + $len(%fam_temp_#odpowiedzi) + $len(%fam_temp_nastepnaOdp)) > 400) inc -u0 %fam_temp_#tabeli
  }
  var %fam_temp_#tabeli = 1
  while ($var(%fam_tabela_odpowiedzi  [ $+ [ %fam_temp_#tabeli ] ] )) {
    if (!$var(%fam_tabela_odpowiedzi [ $+ [ $calc(%fam_temp_#tabeli + 1) ] ] )) {
       if (%fam_auto_linenr) {
         if ($len($zmiana($read(%fam_auto_file , $calc(%fam_auto_linenr + 2)))) < 1) fsay %fam_tabela_odpowiedzi [ $+ [ %fam_temp_#tabeli ] ] 7,1
         elseif ($len($zmiana($read(%fam_auto_file , $calc(%fam_auto_linenr + 3)))) < 1) fsay %fam_tabela_odpowiedzi [ $+ [ %fam_temp_#tabeli ] ] 7,1
         else fsay %fam_tabela_odpowiedzi [ $+ [ %fam_temp_#tabeli ] ] 7,1 Nastepne pytanie za %fam_auto_delay $+ s
       }
       else fsay %fam_tabela_odpowiedzi [ $+ [ %fam_temp_#tabeli ] ] 1,1
    }
    else fsay %fam_tabela_odpowiedzi [ $+ [ %fam_temp_#tabeli ] ]
    inc -u0 %fam_temp_#tabeli
  }
  unset %fam_tabela_odpowiedzi* %fam_odpowiedz* %fam_pytanie %fam_temp* %fam_odp#
  hfree -w famtable
  if ($len(%fam_auto_file) > 0) {
    inc %fam_auto_linenr 2
    %fam_auto_line = $read(%fam_auto_file , %fam_auto_linenr)
    %fam_auto_line2 = $read(%fam_auto_file , $calc(%fam_auto_linenr + 1))
    if (($len($zmiana(%fam_auto_line)) < 1) || ($len($zmiana(%fam_auto_line2)) < 1)) {
      var %fam_temp = %fam_auto_delay
      unset %fam_auto*
      %fam_auto_delay = %fam_temp
      fsay 7,2 *** Koniec Autoquiza ***

    }
    else .timerfamiliadaauto -o 1 %fam_auto_delay fautopyt
  }
  if ($dialog(famnew)) {
    if ($len(%fam_auto_file) > 0) did -mr famnew 11,21
    else { did -nr famnew 11,21 | did -o famnew 701 1 Uruchom autoquiz }
  }
}
alias fautopyt {
  .timerfamiliada off
  unset %fam_tabela_odpowiedzi*
  set %fam_pytanie $zmiana(%fam_auto_line)
  if ($count(%fam_auto_line2 , *) > 0) set %fam_odpowiedz1 . $zmiana($mid(%fam_auto_line2 , 1 , $calc($pos(%fam_auto_line2 , * , 1) - 1))))
  else set %fam_odpowiedz1 . $zmiana(%fam_auto_line2)
  set %fam_tabela_odpowiedzi1 8,1 Pytanie: %fam_pytanie 1,1 1,15 1. -----
  if ($dialog(famnew)) {
    did -mra famnew 11 %fam_pytanie
    did -mra famnew 21 50 pkt: $gettok(%fam_odpowiedz1 ,2-,32)
  }  
  hfree -w famtable
  hmake famtable 50
  hadd famtable 1 $gettok(%fam_odpowiedz1 ,2-,32)
  set %fam_odp# 1
  var %fam_temp3 = 1
  var %fam_temp2 = $calc($count(%fam_auto_line2 ,*) - 1)
  var %fam_temp1 = $calc(45 / $count(%fam_auto_line2 ,*))
  var %fam_temp_#tabeli = 1
  while (%fam_temp3 <= $count(%fam_auto_line2 ,*)) {
    var %fam_temp_pkt = $calc(5 + %fam_temp2 * %fam_temp1)
    if ($count(%fam_temp_pkt ,.)) {
      if ($calc(%fam_temp_pkt - $int(%fam_temp_pkt)) >= 0.5) var %fam_temp_pkt = $calc($int(%fam_temp_pkt) + 1)
      else var %fam_temp_pkt = $int(%fam_temp_pkt)
    }
    if ($pos(%fam_auto_line2 , * , $calc(%fam_temp3 + 1))) var %fam_temp4 = $ifmatch
    else var %fam_temp4 = $len(%fam_auto_line2)
    if (%fam_temp4 != $len(%fam_auto_line2)) set %fam_odpowiedz [ $+ [ $calc(%fam_temp3 + 1) ] ] . $right($zmiana($mid(%fam_auto_line2 , $pos(%fam_auto_line2 ,*, %fam_temp3) , $calc(%fam_temp4 - $pos(%fam_auto_line2 ,*, %fam_temp3)))),-1)
    else set %fam_odpowiedz [ $+ [ $calc(%fam_temp3 + 1) ] ] . $right(%fam_auto_line2 , $calc(-1 * $pos(%fam_auto_line2 ,*, %fam_temp3)))
    inc %fam_odp#
    hadd famtable %fam_odp# $gettok(%fam_odpowiedz [ $+ [ $calc(%fam_temp3 + 1) ] ] ,2-,32)
    set %fam_tabela_odpowiedzi [ $+ [ %fam_temp_#tabeli ] ] %fam_tabela_odpowiedzi [ $+ [ %fam_temp_#tabeli ] ] 1,1 1,15 $calc(%fam_temp3 + 1) $+ . -----
    inc -u0 %fam_temp3
    if ($dialog(famnew)) did -a famnew 21 $crlf $+ %fam_temp_pkt pkt: $gettok(%fam_odpowiedz [ $+ [ %fam_temp3 ] ] ,2-,32)
    dec -u0 %fam_temp2
    if ($len(%fam_tabela_odpowiedzi [ $+ [ %fam_temp_#tabeli ] ] ) > 400) inc -u0 %fam_temp_#tabeli
  }
  if ($dialog(famnew)) did -c famnew 21 1
  var %fam_temp1 = 1
  while (%fam_temp1 <= %fam_temp_#tabeli) {
    if (%fam_temp1 == %fam_temp_#tabeli) fsay %fam_tabela_odpowiedzi [ $+ [ %fam_temp1 ] ] 7,1 Czas: %fam_delay $+ s
    else fsay %fam_tabela_odpowiedzi [ $+ [ %fam_temp1 ] ]
    inc -u0 %fam_temp1
  }
  .timerfamiliada -o 1 %fam_delay f_end 7,2 *** Czas minal! *** Koniec Rundy $calc(%fam_rundy + 1)
}
alias -l fam_rank {
  if ($2 > 0) {
    if ($numtok($hget(famstat,$2),32) > 1) {
      hadd famstat $2 $remtok($hget(famstat,$2),$1,1,32)
      writeini -n " $+ $scriptdir $+ familiada.ini $+ " stat $2 $hget(famstat,$2)
    }
    else {
      hdel famstat $2
      set %fam_stat_sort $remtok(%fam_stat_sort,$2,1,32)
      remini -n " $+ $scriptdir $+ familiada.ini $+ " stat $2
    }
  }
  if (!$istok(%fam_stat_sort,$calc($2 + $3),32)) {
    var %fam_temp_pos = 1
    while ($gettok(%fam_stat_sort,%fam_temp_pos,32) > $calc($2 + $3)) {
      inc -u0 %fam_temp_pos
    }
    set %fam_stat_sort $instok(%fam_Stat_sort,$calc($2 + $3),%fam_temp_pos,32)
  }
  hadd famstat $calc($2 + $3) $hget(famstat,$calc($2 + $3)) $1
  writeini -n " $+ $scriptdir $+ familiada.ini $+ " stat $calc($2 + $3) $hget(famstat,$calc($2 + $3))
}
alias -l f_dialog_onclose {
  set %fam_dialog_x $dialog(famnew).x
  set %fam_dialog_y $dialog(famnew).y
}
alias -l f_autoczas {
  set %fam_auto_delay $1
  echo -a 8,1 FAMILIADA  Przerwa miedzy rundami autoquizu zmieniona na: %fam_auto_delay $+ s 
  if ($dialog(famnew)) {
    if (%fam_auto_delay <= 10) did -c famnew 703 %fam_auto_delay
    elseif (%fam_auto_delay <= 25) did -c famnew 703 $calc(8 + %fam_auto_delay / 5)
    else did -c famnew 703 $calc(11 + %fam_auto_delay / 10)
  }
  if ($len(%fam_auto_file)) halt
}
alias -l f_ignore {
  fchk
  if ($0 > 1) {
    $iif($1 == +,f_ignoreplayer,f_remove_ignore) command $2-
    fecho $iif($1 == +,Dodalem do listy ignorowanych:,Usunalem z listy ignore:) $2-
  }
  echo -a 8,1 :famignore: 
  if ($hget(famignore,0).item == 0) echo -a 1,1  Lista ignore jest pusta.
  else echo -a 1,1  Lista ignore:
  var %fam_temp = 1
  while (%fam_temp <= $hget(famignore,0).item) {
    echo -a 1,1  $hget(famignore,%fam_temp).data
    inc -u0 %fam_temp
  }
  echo -a 1,1___________________________
}