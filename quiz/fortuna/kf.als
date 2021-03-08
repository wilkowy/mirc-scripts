; usuniety bug z /replace - gracz ktorego sie usunelo nie mogl wchodzic na swoje miejsce
; mod by wilk (zmieniono absurdalnie wysokie stawki: kasa z 10000 do 2000, stawka z 10000 do 500, zmniejszone wykrecone stawki za odsloniete litery z 50/100/250/500/1000/2000 na 50/100/150/200/250/300, podniesiono podstawowa stawke z 50 do 100, obnizono cene samoglosek z 500 do 250, nagroda dodatkowych rund zmniejszona do 3 z 5, poprawki)

on *:dialog:kolof:sclick:*: {
  if ($did == 4) unset %kf_prowadzacy %kf_kanal
  if ($did == 1) %kf_prowadzacy = m
  if ($did == 2) %kf_prowadzacy = k
  if ($did == 3) kfon2
}
on *:TEXT:*:%kf_kanal: {
  if (%kf_replace == 1) {
    if (($1 == !join) && ($nick != %kf_gracz1) && ($nick != %kf_gracz2) && ($nick != %kf_gracz3) && ($nick != %kf_gracz4) && ($nick != %kf_gracz5)) kf_gracz_zastepczy $nick %kf_gracz
    halt
  }
  if ($left($1- , 1) == !) {
    if ($len($right($1- , $calc($len($1-) - 1))) < 1) halt
    if ((%kf_mega_nagroda == 1) && ($nick == %kf_gracz)) {
      kfsay 8,1 %kf_gracz 11najpierw musisz wybrac mega nagrode
      halt
    }
    if (($right($1- , $calc($len($1-) - 1)) == join) && ($len(%kf_gracz [ $+ [ %kf_ilosc_graczy ] ] ) < 1) && ($len(%kf_haslo) > 0)) {
      if ($len(%kf_gracz1) < 1) kfgracz2 $nick
      if (($len(%kf_gracz2) < 1) && ($nick != %kf_gracz1)) $iif(%kf_ilosc_graczy == 2 , kfbegin , kfgracz3) $nick
      if (($len(%kf_gracz3) < 1) && ($nick != %kf_gracz1) && ($nick != %kf_gracz2)) $iif(%kf_ilosc_graczy == 3 , kfbegin , kfgracz4) $nick
      if (($len(%kf_gracz4) < 1) && ($nick != %kf_gracz1) && ($nick != %kf_gracz2) && ($nick != %kf_gracz3)) $iif(%kf_ilosc_graczy == 4 , kfbegin , kfgracz5) $nick
      if (($len(%kf_gracz5) < 1) && ($nick != %kf_gracz1) && ($nick != %kf_gracz2) && ($nick != %kf_gracz3) && ($nick != %kf_gracz4)) kfbegin $nick
    }
    if (($right($1- , $calc($len($1-) - 1)) == krece) && ($nick == %kf_gracz) && (%kf_haslo != krece)) {
      if (%kf_krecenie == 0) {
        kfsay 8,1 %kf_gracz 15nie mozesz krecic kolem dwa razy podczas jednej rundy
        halt
      }    
      %kf_krecenie = 0
      kfkrece 50 100 150 200 250 300 50 100 150 200 250 300 $rand(1 , 15)
    }
    if (($right($1- , $calc($len($1-) - 1)) == nagrody) && (%kf_haslo != nagrody)) kfnagrody $nick
    if ($len(%kf_gracz [ $+ [ %kf_ilosc_graczy ] ] ) > 0) {
      if ($right($1- , $calc($len($1-) - 1)) == %kf_haslo) kfcongr $nick
      if (($len($right($1- , $calc($len($1-) - 1))) < 1) || ($right($1- , 1) !isin abcdefghijklmnopqrstuvwxyz)) halt
      if (($len($right($1- , $calc($len($1-) - 1))) == 1) && ($nick == %kf_gracz)) kf_zgaduje_litere $nick $upper($right($1- , 1))
      elseif ($nick == %kf_gracz) kf_zgaduje_haslo $nick $right($1- , $calc($len($1-) - 1))
    }
  }
  if ((%kf_mega_nagroda == 1) && ($nick == %kf_gracz) && (($1- == kasa) || ($1- == rundy) || ($1- == stawka))) {
    if ($1- == kasa) {
      kfsetline %kf_gracz
      inc %kf_punkty 2000
      write -dl $+ %kf_linenr " $+ $scriptdir $+ kf.lst $+ "
      kfrank %kf_gracz %kf_punkty %kf_nagrody
      kfgra 11,1 Teraz gra8 %kf_gracz 11( $+ $calc(%kf_punkty - 2000) $+ zl+2000zl= $+ %kf_punkty $+ zl)
    }
    if ($1- == stawka) {
      %kf_stawka2 = 500
      kfgra 11,1 Teraz gra8 %kf_gracz $+
    }
    if ($1- == rundy) {
      inc %kf_kolejka 3
      kfgra 11,1 Teraz gra8 %kf_gracz $+
    }
    unset %kf_mega_nagroda
    halt
  }
}
alias kfon {
  if ($len(%kf_kanal) > 0) {
    if ($input(Kolo Fortuny jest juz uruchomione na kanale %kf_kanal $+ . $+ $crlf $+ Chcesz rozpoczac nowy quiz?,136) == $true) {
      kfchk clean
      .timerkf off
      if ($len(%kf_haslo) > 0) kfsay 11,1 Runda zostala anulowana!
      unset %kf_gracz* %kf_haslo* %kf_kategoria %kf_litery_w_hasle %kf_nieodkryte_litery %kf_stawka* %kf_punkty* %kf_nagrody* %kf_mega_nagroda %kf_ilosc_graczy %kf_numer_gracza %kf_replace
      %kf_rundy = 0 
      %kf_start = $asctime($gmt)
      write -c " $+ $scriptdir $+ kf.lst $+ "
      kfsay 8,1 KF(tm) 11 $iif(%kf_prowadzacy == m , Rozpoczalem , Rozpoczelam) nowy quiz
    }
    halt
  }
  if (($len($chan) < 1) && ($len($1) < 1) && ($len(%kf_kanal) < 1)) kfmsg Nie podales(as) nazwy kanalu
  unset %kf*
  %kf_kanal = $iif($len($1) > 0 , $zmiana(#$1) , $chan)
  %kf_prowadzacy = m
  kfchoose
}
alias -l kfon2 {
  %kf_rundy = 0
  %kf_start = $asctime($gmt)
  %kf_afks = 5
  write -c " $+ $scriptdir $+ kf.lst $+ "
  kfsay 11,1 Swistak(r) 8Kolo Fortuny(tm) 11v1.1
  kfsay 9,1 Starring13 $iif(%kf_prowadzacy = k , $me 9as 13Magda Masny9 and 8Wojciech Pijanowski , 8Magda Masny9 and13 $me 9as 13Wojciech Pijanowski)
}
alias -l kfmsg {
  echo -a 8,1 KF(tm) 11 $1- 
  halt
}
alias -l kfsay {
  if (%kf_kanal ischan) msg %kf_kanal $1- 
  else echo -a 15 %kf_kanal ---> $1- 
}
alias haslo {
  kfchk
  if (%kf_haslo != $null) kfmsg Pytanie jest juz w trakcie odpowiadania - uzyj polecenia /pomin lub /anuluj
  var %kf_nowa_kategoria = $zmiana($input(Podaj kategorie , 69))
  var %kf_nowe_haslo = $zmiana($input(Podaj haslo , 69))
  if (($len(%kf_nowe_haslo) < 1) || ($len(%kf_nowa_kategoria) < 1)) halt
  %kf_haslo = %kf_nowe_haslo
  %kf_kategoria = %kf_nowa_kategoria
  %kf_haslo_wykropkowane = %kf_haslo
  var %kf_ascii = 97
  unset %kf_nagrody* %kf_punkty* %kf_litery_w_hasle %kf_stawka* %kf_nieodkryte_litery %kf_gracz* %kf_krecenie %kf_line* %kf_kolejka %kf_mega_nagroda %kf_ilosc_graczy %kf_numer_gracza %kf_replace
  while (%kf_ascii < 123) {
    if ($chr(%kf_ascii) isin %kf_haslo) %kf_litery_w_hasle = %kf_litery_w_hasle $+ $chr(%kf_ascii)
    %kf_haslo_wykropkowane = $replace(%kf_haslo_wykropkowane , $chr(%kf_ascii) , .)
    inc %kf_stawka $calc(100 * $count(%kf_haslo , $chr(%kf_ascii)))
    inc %kf_ascii
  }
  %kf_nieodkryte_litery = abcdefghijklmnopqrstuvwxyz
  if (($zmiana($1) isnum 2-5) && ($left($1 , 1) != 0)) %kf_ilosc_graczy = $1
  else %kf_ilosc_graczy = 5
  kfgracz1
}
alias -l kfgracz1 kfsay 11,1 Nowe haslo -8 !join 11( $+ $kftime4(%kf_ilosc_graczy , zostalo , zostalo , zostaly , zostalo) %kf_ilosc_graczy $kftime4(%kf_ilosc_graczy , zgloszen , zgloszenie , zgloszenia , zgloszen)) $+ )
alias -l kfgracz2 {
  %kf_gracz1 = $1
  kfsay 11,1 $iif(%kf_prowadzacy == k , Przyjelam , Przyjalem) $1 -8 !join 11( $+ $kftime4($calc(%kf_ilosc_graczy - 1) , zostalo , zostalo , zostaly , zostalo) $calc(%kf_ilosc_graczy - 1) $kftime4($calc(%kf_ilosc_graczy - 1) , zgloszen , zgloszenie , zgloszenia , zgloszen)) $+ )
  halt
}
alias -l kfgracz3 {
  %kf_gracz2 = $1
  kfsay 11,1 $iif(%kf_prowadzacy == k , Przyjelam , Przyjalem) $1 -8 !join 11( $+ $kftime4($calc(%kf_ilosc_graczy - 2) , zostalo , zostalo , zostaly , zostalo) $calc(%kf_ilosc_graczy - 2) $kftime4($calc(%kf_ilosc_graczy - 2) , zgloszen , zgloszenie , zgloszenia , zgloszen)) $+ )
  halt
}
alias -l kfgracz4 {
  %kf_gracz3 = $1
  kfsay 11,1 $iif(%kf_prowadzacy == k , Przyjelam , Przyjalem) $1 -8 !join 11( $+ $kftime4($calc(%kf_ilosc_graczy - 3) , zostalo , zostalo , zostaly , zostalo) $calc(%kf_ilosc_graczy - 3) $kftime4($calc(%kf_ilosc_graczy - 3) , zgloszen , zgloszenie , zgloszenia , zgloszen)) $+ )
  halt
}
alias -l kfgracz5 {
  %kf_gracz4 = $1
  kfsay 11,1 $iif(%kf_prowadzacy == k , Przyjelam , Przyjalem) $1 -8 !join 11( $+ $kftime4($calc(%kf_ilosc_graczy - 4) , zostalo , zostalo , zostaly , zostalo) $calc(%kf_ilosc_graczy - 4) $kftime4($calc(%kf_ilosc_graczy - 4) , zgloszen , zgloszenie , zgloszenia , zgloszen)) $+ )
  halt
}
alias -l kfbegin {
  %kf_gracz [ $+ [ %kf_ilosc_graczy ] ] = $1
  kf_nastepny_gracz
  kfgra 11,1 $iif(%kf_prowadzacy == k , Przyjelam , Przyjalem) $1 $+ . Litery odgaduja:8 %kf_gracz1 11( $+ %kf_punkty $+ zl)8 %kf_gracz2 %kf_gracz3 %kf_gracz4 %kf_gracz5
}
alias anuluj {
  kfchk
  if ($len(%kf_haslo) < 1) kfmsg Nie $iif(%kf_prowadzacy == k , podalas , podales) hasla
  kfsay 11,1 $iif(%kf_ilosc_graczy == 1,Liczba graczy zredukowana do 1.,) Runda zostala anulowana!
  unset %kf_haslo %kf_haslo_wykropkowane %kf_kategoria %kf_litery_w_hasle %kf_stawka* %kf_nieodkryte_litery %kf_gracz* %kf_krecenie %kf_linenr %kf_punkty_next %kf_nagrody_next %kf_kolejka %kf_ilosc_graczy %kf_numer_gracza %kf_punkty* %kf_nagrody* %kf_kolejka %kf_ilosc_graczy %kf_numer_gracza %kf_mega_nagroda %kf_replace
  halt
}
alias pomin {
  kfchk
  if ($len(%kf_haslo) < 1) kfmsg Nie $iif(%kf_prowadzacy == k , podalas , podales) hasla
  if (%kf_replace == 1) {
    if (%kf_ilosc_graczy == 2) {
      dec %kf_ilosc_graczy
      anuluj
    }
    elseif (%kf_ilosc_graczy == 3) {
      if (%kf_numer_gracza == 1) {
        set %kf_numer_gracza 3
        set %kf_gracz1 %kf_gracz2
        set %kf_gracz2 %kf_gracz3
        unset %kf_gracz3
      }
      elseif (%kf_numer_gracza == 2) {
        set %kf_numer_gracza 1
        set %kf_gracz1 %kf_gracz1
        set %kf_gracz2 %kf_gracz3
        unset %kf_gracz3
      }
      elseif (%kf_numer_gracza == 3) {
        set %kf_numer_gracza 2
        set %kf_gracz1 %kf_gracz1
        set %kf_gracz2 %kf_gracz2
        unset %kf_gracz3
      }
    }
    elseif (%kf_ilosc_graczy == 4) {
      if (%kf_numer_gracza == 1) {
        set %kf_numer_gracza 4
        set %kf_gracz1 %kf_gracz2
        set %kf_gracz2 %kf_gracz3
        set %kf_gracz3 %kf_gracz4
        unset %kf_gracz4
      }
      elseif (%kf_numer_gracza == 2) {
        set %kf_numer_gracza 1
        set %kf_gracz1 %kf_gracz1
        set %kf_gracz2 %kf_gracz3
        set %kf_gracz3 %kf_gracz4
        unset %kf_gracz4
      }
      elseif (%kf_numer_gracza == 3) {
        set %kf_numer_gracza 2
        set %kf_gracz1 %kf_gracz1
        set %kf_gracz2 %kf_gracz2
        set %kf_gracz3 %kf_gracz4
        unset %kf_gracz4
      }
      elseif (%kf_numer_gracza == 4) {
        set %kf_numer_gracza 3
        set %kf_gracz1 %kf_gracz1
        set %kf_gracz2 %kf_gracz2
        set %kf_gracz3 %kf_gracz3
        unset %kf_gracz4
      }
    }
    elseif (%kf_ilosc_graczy == 5) {
      if (%kf_numer_gracza == 1) {
        set %kf_numer_gracza 5
        set %kf_gracz1 %kf_gracz2
        set %kf_gracz2 %kf_gracz3
        set %kf_gracz3 %kf_gracz4
        set %kf_gracz4 %kf_gracz5
        unset %kf_gracz5
      }
      elseif (%kf_numer_gracza == 2) {
        set %kf_numer_gracza 1
        set %kf_gracz1 %kf_gracz1
        set %kf_gracz2 %kf_gracz3
        set %kf_gracz3 %kf_gracz4
        set %kf_gracz4 %kf_gracz5
        unset %kf_gracz5
      }
      elseif (%kf_numer_gracza == 3) {
        set %kf_numer_gracza 2
        set %kf_gracz1 %kf_gracz1
        set %kf_gracz2 %kf_gracz2
        set %kf_gracz3 %kf_gracz4
        set %kf_gracz4 %kf_gracz5
        unset %kf_gracz5
      }
      elseif (%kf_numer_gracza == 4) {
        set %kf_numer_gracza 3
        set %kf_gracz1 %kf_gracz1
        set %kf_gracz2 %kf_gracz2
        set %kf_gracz3 %kf_gracz3
        set %kf_gracz4 %kf_gracz5
        unset %kf_gracz5
      }
      elseif (%kf_numer_gracza == 5) {
        set %kf_numer_gracza 4
        set %kf_gracz1 %kf_gracz1
        set %kf_gracz2 %kf_gracz2
        set %kf_gracz3 %kf_gracz3
        set %kf_gracz4 %kf_gracz4
        unset %kf_gracz5
      }
    }
    dec %kf_ilosc_graczy       
    kfsay 11,1 Liczba graczy zredukowana do %kf_ilosc_graczy $+ . Kolejka przechodzi na8 %kf_gracz_next 
    unset %kf_replace
    kf_nastepny_gracz
    halt
  }
  if ($len(%kf_gracz [ $+ [ %kf_ilosc_graczy ] ] ) > 0) {
    nastepny
    halt
  }
  if ($len(%kf_gracz2) < 1) anuluj
  elseif ($len(%kf_gracz3) < 1) {
    set %kf_ilosc_graczy 2
  }
  elseif ($len(%kf_gracz4) < 1) {
    set %kf_ilosc_graczy 3
  }
  elseif ($len(%kf_gracz5) < 1) {
    set %kf_ilosc_graczy 4
  }
  kf_nastepny_gracz
  kfgra 11,1 Liczba graczy zredukowana do %kf_ilosc_graczy $+ . Litery odgaduja:8 %kf_gracz1 11( $+ %kf_punkty $+ zl)8 %kf_gracz2 %kf_gracz3 %kf_gracz4 %kf_gracz5
}
alias -l kfcongr {
  inc %kf_rundy
  if ($len($read(" $+ $scriptdir $+ kf.lst $+ " , w , * $+ $chr(160) $1 $chr(160) $+ *)) < 1) write " $+ $scriptdir $+ kf.lst $+ " $chr(160) $1 $chr(160) 0 $chr(160)
  var %kf_punkty_stare = %kf_punkty
  kfsetline $1
  kfrank2 kf_punkty 6 %kf_line
  kfrank2 kf_nagrody 7- %kf_line
  inc %kf_punkty %kf_stawka
  write -dl $+ %kf_linenr " $+ $scriptdir $+ kf.lst $+ "
  kfrank $1 %kf_punkty %kf_nagrody
  if (%kf_haslo_wykropkowane == %kf_haslo) {
    kfsay 9,1 Magda odslon litery $upper($2) $+ .8 $1 ( $+ %kf_punkty_stare $+ zl+ $+ %kf_wygrana $+ zl $+ $iif($2 isin aeiouy , -250zl= , =) $+ %kf_punkty $+ zl) 9odgadl(a) wszystkie litery
    kfsay 9,1 Prawidlowe haslo to: 8 $upper(%kf_haslo)9
  }
  else {
    kfsay 9,1 Brawo!8 $1 9odgadl(a) haslo:8 $upper(%kf_haslo)9
    kfsay 9,1 $1 ma8 $calc(%kf_punkty - %kf_stawka) zl + %kf_stawka zl = %kf_punkty zl
  }
  unset %kf_haslo %kf_haslo_wykropkowane %kf_kategoria %kf_litery_w_hasle %kf_stawka* %kf_nieodkryte_litery %kf_gracz* %kf_krecenie %kf_linenr %kf_punkty_next %kf_nagrody_next %kf_kolejka %kf_ilosc_graczy %kf_numer_gracza
  halt
}  
alias -l kf_zgaduje_litere {
  kfsetline %kf_gracz
  set -u0 %kf_line $read(" $+ $scriptdir $+ imiona.kf $+ " , $calc($asc($2) - 64))
  set -u0 %kf_spacja1_nr $rand(1 , $calc($pos(%kf_line , $chr(32) , 0) - 1))
  set -u0 %kf_spacja2_nr $calc(%kf_spacja1_nr + 1)
  set -u0 %kf_spacja1_pos $pos(%kf_line , $chr(32) , %kf_spacja1_nr)
  set -u0 %kf_spacja2_pos $pos(%kf_line , $chr(32) , %kf_spacja2_nr)
  set -u0 %kf_imie $mid(%kf_line , %kf_spacja1_pos , $calc($len(%kf_line) - $len($mid(%kf_line , %kf_spacja2_pos , $len(%kf_line))) - $len($mid(%kf_line , 1 , %kf_spacja1_pos)) + 1))
  if (($2 isin aeiouy) && (%kf_punkty < 250)) {
    kfsay 15,1 Samogloska kosztuje 250zl. Brakuje ci $calc(250 - %kf_punkty) $+ zl
    halt
  }
  if ($2 isin %kf_haslo_wykropkowane) {
    if ($2 isin aeiouy) {
      dec %kf_punkty 250
      write -dl $+ %kf_linenr " $+ $scriptdir $+ kf.lst $+ "
      kfrank %kf_gracz %kf_punkty %kf_nagrody
    }
    kfgra 15,1 $2 jak %kf_imie $+ . Litera jest juz odkryta. $iif($2 isin aeiouy , $calc(%kf_punkty + 250) $+ zl-250zl= $+ %kf_punkty $+ zl. 11, 11) $+ $iif(%kf_kolejka == 0 , Teraz gra8 %kf_gracz_next 11( $+ %kf_punkty_next $+ zl) , 8 $+ %kf_gracz 11wykorzystuje %kf_kolejka powtorzenie rundy)
    if (%kf_kolejka == 0) {
      kf_nastepny_gracz
      halt
    }
    dec %kf_kolejka
    %kf_krecenie = 1
    halt
  }
  if ($2 !isin %kf_haslo) {
    if ($2 isin aeiouy) {
      dec %kf_punkty 250
      write -dl $+ %kf_linenr " $+ $scriptdir $+ kf.lst $+ "
      kfrank %kf_gracz %kf_punkty %kf_nagrody
    }
    %kf_nieodkryte_litery = $replace(%kf_nieodkryte_litery , $2 , 14 $+ $2 $+ 11)
    kfgra 15,1 $2 jak %kf_imie $+ . Litery nie ma w hasle. $iif($2 isin aeiouy , $calc(%kf_punkty + 250) $+ zl-250zl= $+ %kf_punkty $+ zl. 11, 11) $+ $iif(%kf_kolejka == 0 , Teraz gra8 %kf_gracz_next 11( $+ %kf_punkty_next $+ zl) , 8 $+ %kf_gracz 11wykorzystuje %kf_kolejka powtorzenie rundy)
    if (%kf_kolejka == 0) {
      kf_nastepny_gracz
      halt
    }
    dec %kf_kolejka
    %kf_krecenie = 1
    halt
  }
  set -u0 %kf_pozycje_litery_w_hasle $pos(%kf_haslo , $2 , 0)
  %kf_stawka = $calc(%kf_stawka - $calc(100 * %kf_pozycje_litery_w_hasle))
  set -u0 %kf_wygrana $calc(%kf_stawka2 * %kf_pozycje_litery_w_hasle)
  while (%kf_pozycje_litery_w_hasle > 0) {
    set -u0 %kf_pozycja_litery_w_hasle $pos(%kf_haslo , $2 , %kf_pozycje_litery_w_hasle)
    %kf_haslo_wykropkowane = $left(%kf_haslo_wykropkowane , $calc(%kf_pozycja_litery_w_hasle - 1)) $+ $mid(%kf_haslo , %kf_pozycja_litery_w_hasle , 1) $+ $right(%kf_haslo_wykropkowane , $calc($len(%kf_haslo) - %kf_pozycja_litery_w_hasle))
    dec %kf_pozycje_litery_w_hasle
  }
  %kf_nieodkryte_litery = $replace(%kf_nieodkryte_litery , $2 , 14 $+ $2 $+ 11)
  var %kf_punkty_stare = %kf_punkty
  if ($2 isin aeiouy) dec %kf_punkty 250
  inc %kf_punkty %kf_wygrana
  write -dl $+ %kf_linenr " $+ $scriptdir $+ kf.lst $+ "
  kfrank %kf_gracz %kf_punkty %kf_nagrody
  if (%kf_haslo_wykropkowane == %kf_haslo) {
    kfcongr %kf_gracz $2
    halt
  }
  kfgra 9,1 $2 jak %kf_imie $+ . Magda odslon litery.11 Teraz gra8 %kf_gracz 11( $+ %kf_punkty_stare $+ zl+ $+ %kf_wygrana $+ zl $+ $iif($2 isin aeiouy , -250zl= , =) $+ %kf_punkty $+ zl)
}
alias -l kf_zgaduje_haslo {
  if ($2- == %kf_haslo) kfcongr $1
  kfgra 15,1 $2- nie jest poprawnym haslem.11 $iif(%kf_kolejka == 0 , Teraz gra8 %kf_gracz_next 11( $+ %kf_punkty_next $+ zl) , 8 $+ %kf_gracz 11wykorzystuje %kf_kolejka powtorzenie rundy)
  if (%kf_kolejka == 0) {
    kf_nastepny_gracz
    halt
  }
  dec %kf_kolejka
  %kf_krecenie = 1
  halt
}
alias -l nastepny {
  kfchk
  if ($len(%kf_haslo) < 1) kfmsg Nie $iif(%kf_prowadzacy == k , podalas , podales) hasla
  if ($len(%kf_gracz) < 1) kfmsg Poczekaj az zglosza sie wszyscy gracze
  kf_nastepny_gracz
  kfsay 11,1 Kolejka przechodzi na8 %kf_gracz 11( $+ %kf_punkty $+ zl)
}
alias -l kfrank2 set -u0 % [ $+ [ $1 ] ] $ [ $+ [ $2 ] ]
alias -l kfrank {
  %kf_linenr = $calc($lines(" $+ $scriptdir $+ kf.lst $+ ") + 1)
  while (((%kf_punkty2 < $2) || (%kf_punkty2 == $null)) && (%kf_linenr > 0)) {
    dec %kf_linenr
    set -u0 %kf_line $read(" $+ $scriptdir $+ kf.lst $+ " , %kf_linenr)
    kfrank2 kf_punkty2 6 %kf_line
  }
  write -il $+ $calc(%kf_linenr + 1) " $+ $scriptdir $+ kf.lst $+ " $chr(160) $1 $chr(160) $2 $3-
}
alias kfstat {
  kfchk
  kfrank2 kf_temp_punkty 6 $read(" $+ $scriptdir $+ kf.lst $+ " , 1)
  if (($file(" $+ $scriptdir $+ kf.lst $+ ").size == 0) || (%kf_temp_punkty < 1)) kfmsg Lista jest pusta
  kfsay 8,1 KF(tm)11 - wyniki - %kf_rundy $kftime4(%kf_rundy , rund , runda , rundy , rund) - $kftime(%kf_start)
  if (($len($read(" $+ $scriptdir $+ kf.lst $+ " , $calc(20 * ($1 - 1) + 1))) != 0) && ($left($1 , 1) != 0)) var %kf_temp_linenr = $calc(20 * ($1 - 1))
  .timerkf 0 %kf_afks kfstat2 $1
}
alias -l kfstat2 {
  var %kf_temp_nicknr = 0
  var %kf_scriptdir = " $+ $scriptdir $+ kf.lst $+ "
  unset %kf_wyniki
  while (%kf_temp_nicknr < 20) {
    inc -u0 %kf_temp_nicknr
    inc %kf_temp_linenr
    var %kf_temp_line2 = $read(%kf_scriptdir, $calc(%kf_temp_linenr + 1))
    var %kf_temp_line = $read(%kf_scriptdir , %kf_temp_linenr)
    kfrank2 kf_temp_nick 4 %kf_temp_line
    kfrank2 kf_temp_punkty 6 %kf_temp_line
    kfrank2 kf_temp_punkty2 6 %kf_temp_line2
    if (($len(%kf_temp_nick) > 0) && (%kf_temp_punkty > 0)) {
      if (%kf_temp_linenr < $lines(%kf_scriptdir)) {
        if (%kf_temp_punkty2 > 0) {
          if (%kf_temp_nicknr == 1) {
            if (%kf_temp_linenr > 1) var %kf_wyniki = %kf_wyniki 8 ... 11 $+ %kf_temp_nick %kf_temp_punkty 8 $+ $iif(%kf_temp_nicknr == 20 , ... , -)
            else var %kf_wyniki = %kf_wyniki 8 11 $+ %kf_temp_nick %kf_temp_punkty 8 $+ $iif(%kf_temp_nicknr == 20 , ... , -)
          }
          else var %kf_wyniki = %kf_wyniki 11 $+ %kf_temp_nick %kf_temp_punkty 8 $+ $iif(%kf_temp_nicknr == 20 , ... , -)
        }
        else {
          if (%kf_temp_nicknr == 1) {
            if (%kf_temp_linenr > 1) var %kf_wyniki = %kf_wyniki 8 ... 11 $+ %kf_temp_nick %kf_temp_punkty
            else var %kf_wyniki = %kf_wyniki 8 11 $+ %kf_temp_nick %kf_temp_punkty
          }
          else var %kf_wyniki = %kf_wyniki 11 $+ %kf_temp_nick %kf_temp_punkty
        }
      }
      else {
        if (%kf_temp_nicknr == 1) {
          if (%kf_temp_linenr > 1) var %kf_wyniki = %kf_wyniki 8 ... 11 $+ %kf_temp_nick %kf_temp_punkty
          else var %kf_wyniki = %kf_wyniki 8 11 $+ %kf_temp_nick %kf_temp_punkty
        }
        else var %kf_wyniki = %kf_wyniki 11 $+ %kf_temp_nick %kf_temp_punkty
      }
    }
  }
  kfsay 11,1 $+ %kf_wyniki
  if ((%kf_temp_linenr == $calc(20 * $1)) || (%kf_temp_punkty < 1)) %kf_temp_linenr = $lines(" $+ $scriptdir $+ kf.lst $+ ")
  if (%kf_temp_linenr >= $lines(" $+ $scriptdir $+ kf.lst $+ ")) {
    unset %kf_temp_linenr
    .timerkf off
  }
}
alias kfoff {
  kfchk
  .timerkf off
  .remove " $+ $scriptdir $+ kf.lst $+ "
  kfsay 11,1 Swistak(r) 8Kolo Fortuny(tm) 11zakonczony !!!!!!!!! 
  kfsay 9,1 Autor:11 snajperx9,1, poprawki:11 wilk 
  kfsay 9,1 Sciagaj z:13 http://www.quizpl.net 
  unset %kf*
}
alias kfprzyp {
  kfchk
  if ($len(%kf_haslo) < 1) kfmsg Nie $iif(%kf_prowadzacy == k , podalas , podales) hasla
  echo -a 11,1 Kategoria: 12 %kf_kategoria
  echo -a 11,1 9 11 9 11 Haslo: 12 %kf_haslo
}
alias -l kftime {
  kftime3 $gmt $ctime($1) 1 604800 kf_week
  kftime3 %kf_czas %kf_week 604800 86400 kf_day
  kftime3 %kf_czas %kf_day 86400 3600 kf_hour
  kftime3 %kf_czas %kf_hour 3600 60 kf_minute
  kftime3 %kf_czas %kf_minute 60 1 kf_second
  unset %kf_czas
  kftime2 %kf_week tydzien tygodnie tygodni
  kftime2 %kf_day dzien dni dni
  kftime2 %kf_hour godzina godziny godzin
  kftime2 %kf_minute minuta minuty minut
  kftime2 %kf_second sekunda sekundy sekund
  return $iif(%kf_czas == $null , 0 sekund , %kf_czas)
}
alias -l kftime2 $iif($1 == 0 , return , set -u0 %kf_czas %kf_czas $1 $iif($1 == 1 , $2 , $iif(($calc($1 % 10) isnum 2-4) && ($calc($1 % 100) !isnum 12-14) , $3 , $4)))
alias -l kftime3 {
  set -u0 %kf_czas $calc($1 - $2 * $3)
  set -u0 % [ $+ [ $5 ] ] $iif($int($calc(%kf_czas / $4)) >= 1 , $int($calc(%kf_czas / $4)) , 0)
}
alias -l kftime4 return $iif($1 == 0 , $2 , $iif($1 == 1 , $3 , $iif(($calc($1 % 10) isnum 2-4) && ($calc($1 % 100) !isnum 12-14) , $4 , $5)))
alias -l zmiana return $replace($1-,,,,,,,,,,)
alias kfdodaj {
  kfchk
  if (($zmiana($1) == $null) || ($zmiana($2) == $null) || ($left($1 , 9) == $left($2 , 9))) halt
  kfsetline $1 1
  if ($len(%kf_line1) < 1) kfdodaj2 $1
  kfsetline $2 2
  if ($len(%kf_line2) < 1) kfdodaj2 $2
  if ($result == halt) halt
  kfrank2 kf_punkty1 6 %kf_line1
  kfrank2 kf_punkty2 6 %kf_line2
  kfrank2 kf_nick1 4 %kf_line1
  kfrank2 kf_nick2 4 %kf_line2
  kfrank2 kf_nagrody1 7- %kf_line1
  kfrank2 kf_nagrody2 7- %kf_line2
  kfdodaj3 kf_nick1
  kfdodaj3 kf_nick2
  write -dl $+ $iif(%kf_line1nr > %kf_line2nr , %kf_line2nr , %kf_line1nr) " $+ $scriptdir $+ kf.lst $+ "
  write -dl $+ $iif(%kf_line1nr > %kf_line2nr , $calc(%kf_line1nr - 1) , $calc(%kf_line2nr - 1)) " $+ $scriptdir $+ kf.lst $+ "
  %kf_punkty = $calc(%kf_punkty1 + %kf_punkty2)
  kfsay 8,1 KF(tm) 11 %kf_nick1 = %kf_nick1 + %kf_nick2
  kfrank %kf_nick1 $calc(%kf_punkty1 + %kf_punkty2) %kf_nagrody1 %kf_nagrody2
}
alias -l kfdodaj2 {
  echo -a 8,1 KF(tm) 11 Nicka $1 nie ma na liscie 
  return halt
}
alias -l kfdodaj3 if ($len($nick(%kf_kanal , % [ $+ [ $1 ] ] )) > 0) % [ $+ [ $1 ] ] = $nick(%kf_kanal , $nick(%kf_kanal , % [ $+ [ $1 ] ] ))
alias -l kfchk {
  if (($timer(kf) == 1) && ($1 != clean)) kfmsg Poczekaj na wyswietlenie rankingu
  if ($len(%kf_kanal) < 1) kfmsg Najpierw uruchom Kolo Fortuny(tm)
}
alias -l kfchoose { 
  dialog -vms kolof kolof
  did -c kolof 1
}
dialog kolof {
  title "Kolo Fortuny(tm)"
  size -1 -1 250 90
  result 
  radio Wojciech Pijanowski , 1 , 10 10 120 20
  radio Magda Masny , 2 , 10 30 100 20
  button OK , 3 , 40 60 50 20 , ok
  button Zrezygnuj , 4 , 120 60 90 20 , cancel
}
alias -l kfkrece {
  if ($13 isnum 1-6) kfstawka $ [ $+ [ $13 ] ]
  if ($13 isnum 7-12) kfgotowka $ [ $+ [ $13 ] ]
  if ($13 == 13) kfkolejka
  if ($13 == 14) kfstrata
  if ($13 == 15) kfnagroda $rand(1 , $lines(" $+ $scriptdir $+ nagrody.kf $+ "))
  halt
}
alias -l kfstawka {
  %kf_stawka2 = $1
  kfsay 8,1 %kf_gracz 11wykrecil(a) $1 $+ zl za kazda litere
  %kf_krecenie = 0
}
alias -l kfgotowka {
  kfsetline %kf_gracz
  kfrank2 kf_punkty 6 %kf_line
  kfrank2 kf_nagrody 7- %kf_line
  inc %kf_punkty $1
  set %kf_punkty %kf_punkty
  set %kf_nagrody %kf_nagrody
  write -dl $+ %kf_linenr " $+ $scriptdir $+ kf.lst $+ "
  kfrank %kf_gracz %kf_punkty %kf_nagrody
  %kf_krecenie = 0
  kfsay 8,1 %kf_gracz 11wygrywasz $1 $+ zl (razem %kf_punkty $+ zl)
}
alias -l kfkolejka {
  inc %kf_kolejka
  kfsay 8,1 %kf_gracz 11masz mozliwosc powtorzenia rundy
  %kf_krecenie = 0
}
alias -l kfstrata {
  if ($rand(1 , 3) == 3) kfbankrut
  kfgra 8,1 %kf_gracz 15strata kolejki.11 Teraz gra8 %kf_gracz_next 11( $+ %kf_punkty_next $+ zl)
  kf_nastepny_gracz
}
alias -l kfbankrut {
  kfsetline %kf_gracz
  write -dl $+ %kf_linenr " $+ $scriptdir $+ kf.lst $+ "
  kfgra 8,1 %kf_gracz 15bankrut.11 Teraz gra8 %kf_gracz_next 11( $+ %kf_punkty_next $+ zl)
  kf_nastepny_gracz
  halt
}
alias -l kfnagroda {
  if ($rand(1 , 3) == 3) kfmeganagroda
  var %kf_nagroda = $read(" $+ $scriptdir $+ nagrody.kf $+ " , $1)
  kfsay 8,1 %kf_gracz 11zdobywasz nagrode! Twoja nagroda to: %kf_nagroda $+ . Masz prawo do ponownego krecenia
  kfsetline %kf_gracz
  write -al $+ %kf_linenr " $+ $scriptdir $+ kf.lst $+ " %kf_nagroda $chr(160)
  %kf_krecenie = 1
}
alias -l kfmeganagroda {
  %kf_mega_nagroda = 1
  kfsay 8,1 %kf_gracz 11wylosowales(as)13 mega nagrode!11. Wpisz 8kasa 11aby otrzymac 2000zl. Wpisz 8stawka 11aby stawka za odkryta litere wynosila 500zl. Wpisz 8rundy 11aby zyskac trzy dodatkowe rundy
  halt
}
alias -l kfnagrody {
  var %kf_line = $read(" $+ $scriptdir $+ kf.lst $+ " , w , * $+ $chr(160) $1 $chr(160) $+ *)
  kfrank2 kf_nagrody 7- %kf_line
  if ($len(%kf_nagrody) > 0) kfsay 8,1 $1 11twoje nagrody to:8 %kf_nagrody
  halt
}
alias -l kf_nastepny_gracz {
  unset %kf_mega_nagroda
  inc %kf_numer_gracza
  if (%kf_numer_gracza > %kf_ilosc_graczy) %kf_numer_gracza = 1
  %kf_gracz = %kf_gracz [ $+ [ %kf_numer_gracza ] ]
  %kf_gracz_next = %kf_gracz [ $+ [ $iif(%kf_numer_gracza == %kf_ilosc_graczy , 1 , $calc(%kf_numer_gracza + 1)) ] ]
  if ($len($read(" $+ $scriptdir $+ kf.lst $+ " , w , * $+ $chr(160) %kf_gracz $chr(160) $+ *)) < 1) write " $+ $scriptdir $+ kf.lst $+ " $chr(160) %kf_gracz $chr(160) 0 $chr(160)
  if ($len($read(" $+ $scriptdir $+ kf.lst $+ " , w , * $+ $chr(160) %kf_gracz_next $chr(160) $+ *)) < 1) write " $+ $scriptdir $+ kf.lst $+ " $chr(160) %kf_gracz_next $chr(160) 0 $chr(160)
  kfsetline %kf_gracz
  kfrank2 kf_punkty 6 %kf_line
  kfrank2 kf_nagrody 7- %kf_line
  set %kf_punkty %kf_punkty
  set %kf_nagrody %kf_nagrody
  set -u0 %kf_line2 $read(" $+ $scriptdir $+ kf.lst $+ " , w , * $+ $chr(160) %kf_gracz_next $chr(160) $+ *)
  set -u0 %kf_line2nr $readn
  kfrank2 kf_punkty_next 6 %kf_line2
  kfrank2 kf_nagrody_next 7- %kf_line2
  set %kf_punkty_next %kf_punkty_next
  set %kf_nagrody_next %kf_nagrody_next
  %kf_stawka2 = 100
  set %kf_krecenie 1
  %kf_kolejka = 0
}
alias -l kfgra {
  kfsay $1-
  kfsay 11,1 Stawka8 %kf_stawka $+ zl 11-8 %kf_kategoria 11-8 %kf_haslo_wykropkowane 11- %kf_nieodkryte_litery
}
alias -l kfsetline {
  set -u0 %kf_line [ $+ [ $2 ] ] $read(" $+ $scriptdir $+ kf.lst $+ " , w , * $+ $chr(160) $1 $chr(160) $+ *)
  set -u0 %kf_line [ $+ [ $2 ] $+ [ nr ] ] $readn
}
alias usun {
  kfchk
  if ($len(%kf_haslo) < 1) kfmsg Nie $iif(%kf_prowadzacy == k , podalas , podales) hasla
  if ($len(%kf_gracz) < 1) kfmsg Poczekaj az zglosza sie wszyscy gracze
  %kf_replace = 1
  unset %kf_gracz [ $+ [ %kf_numer_gracza ] ]
  kfsay 11,1 %kf_gracz odpada z gry.8 !join 11(zostalo 1 zgloszenie)
}
alias -l kf_gracz_zastepczy {
  %kf_gracz [ $+ [ %kf_numer_gracza ] ] = $1
  dec %kf_numer_gracza
  if (%kf_numer_gracza == 0) %kf_numer_gracza = %kf_ilosc_graczy
  kf_nastepny_gracz
  kfgra 8,1 $1 11( $+ %kf_punkty $+ zl) wchodzi na miejsce $2 $+ .
  unset %kf_replace
}
alias kfaf {
  kfchk
  if ($1 !isnum 0-10) halt
  %kf_afks = $int($1)
  kfmsg AFKS Timer:  $kfodmiana(%kf_afks , sekunda , sekundy , sekund)
}
alias -l kfodmiana return $1 $iif($1 == 1 , $2 , $iif(($calc($1 % 10) isnum 2-4) && ($calc($1 % 100) !isnum 12-14) , $3 , $4))
alias kfkom {
  echo -a -- 10Kolo Fortuny(tm) - spis komend --
  echo -a $chr(124) 10/kfon #kanal - uruchomienie Kola Fortuny na #kanal
  echo -a $chr(124) 10/kfoff - zakonczenie Kola Fortuny
  echo -a $chr(124) 10/haslo - podanie nowego hasla dla pieciu osob
  echo -a $chr(124) 10/haslo 2-5- podanie nowego hasla, cyfra oznacza liczbe graczy, wybor od 2 do 5
  echo -a $chr(124) 10/anuluj - anulowanie biezacej rundy
  echo -a $chr(124) 10/pomin - pominiecie kolejki gracza
  echo -a $chr(124) 10/kfstat - wyswietlenie rankingu
  echo -a $chr(124) 10/kfprzyp - przypomina haslo prowadzacemu(ej)
  echo -a $chr(124) 10/kfdodaj nick1 nick2 - dodanie punktow <nick2> do <nick1>, usuniecie <nick2> z rankingu
  echo -a $chr(124) 10/usun - usuniecie z gry gracza, na ktorego przypada kolejka
  echo -a $chr(124) 10/kfaf [1-10] - zmiana opoznienia (w sekundach) przed wyswietleniem kazdej linijki w rankingu
}
