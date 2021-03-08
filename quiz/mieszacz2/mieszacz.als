; mod by oyey (szansa dla drugiej najszybszej osoby)
; mod by wilk (tryby mieszania 1: wszystko razem, 2: po wyrazach; !podp i ponowne mieszanie, ochrona przed niepomieszanym wyrazem, wyswietlanie czasu bonusowej odpowiedzi, poprawki kodu i inne)

on 1:TEXT:%wyraz:%mkkanal: congr $nick

on 1:TEXT:!punkty:%mkkanal:{
  if (%stat != juzbyl) { /statt }
  set %stat juzbyl
}

alias del {
  if ($1 == $null) set %delay $?="Opoznienie zadawanych pytan w sekundach:"
  else %delay = $1-
  msg %mkkanal 9,2 Opoznienie miedzy pytaniami: %delay s
}

alias statt {
  var %staty = 5
  if ($1 != $null) %staty = $1
  set %quizczas $duration($calc($ctime - %quizstart))
  if (%licz == 1) { msg %mkkanal 9,2 {LiTeRaKi} 12,0 Punktacja po4 %licz 12wyrazie ( $+ %quizczas $+ ): }
  else { msg %mkkanal 9,2 {LiTeRaKi} 12,0 Punktacja po4 %licz 12wyrazach ( $+ %quizczas $+ ): }
  var %qils = 1
  while (%qils <= %staty) {
    msg %mkkanal 5 $+ %qils $+ . Miejsce:12 $imie(%quiz [ $+ [ %qils ] $+ miejsce ] ) (4 %quiz [ $+ [ %qils ] $+ miejscePunkty ] 12 $+ $rodzaj(%quiz [ $+ [ %qils ] $+ miejscePunkty) $+ )
    inc %qils 1
  }
}

alias -l mkcounter {
  var %stawka = 1
  if ($2 != $null) { set %stawka $2 }
  if ( %quiz [ $+ [ $$1 ] ] == $null) {
    inc %gracze
    set %quiz [ $+ [ %gracze ] $+ miejsce ] $1
    set %quiz [ $+ [ %gracze ] $+ miejscePunkty ] %stawka
    set %quiz [ $+ [ $$1 ] ] %stawka
  }
  else { inc %quiz [ $+ [ $$1 ] ] %stawka }
}

alias -l mkrank {
  var %miejsce = 1
  while (%miejsce <= %gracze) {
    if (%quiz [ $+ [ %miejsce ] $+ miejsce ] == $1) {
      var %akt = 1
      while (%gracze >= %akt) {
        if (%quiz [ $+ [ $1 ] ] > %quiz [ $+ [ %akt ] $+ miejscePunkty ]) {
          var %akt2 = %miejsce
          while (%akt2 > %akt) {
            var %akt3 = %akt2 - 1
            set %quiz [ $+ [ %akt2 ] $+ miejsce ] %quiz [ $+ [ %akt3 ] $+ miejsce ]
            set %quiz [ $+ [ %akt2 ] $+ miejscePunkty ] %quiz [ $+ [ %akt3 ] $+ miejscePunkty ]
            dec %akt2 1
          }
          set %quiz [ $+ [ %akt ] $+ miejsce ] $1
          set %quiz [ $+ [ %akt ] $+ miejscePunkty ] %quiz [ $+ [ $1 ] ] 
          break
        }
        inc %akt 1
      }
    }
    inc %miejsce
  }
}

alias -l adress {
  if (*!*@*.*.cvx.ppp.tpnet.pl iswm $address($1,1)) set %adres $1
  if (*!*@*.*.ppp.tpnet.pl iswm $address($1,1)) set %adres $1
  else set %adres $address($1,1)
  if (%adres == $null) set %adres $1
}

on 1:TEXT:!podp:%mkkanal: {
  if (%wyraz == $null) { halt }
  if ($1 != $null) { inc %ktory $1 | dec %ktory }
  var %text = $remove(%wyraz,*)
  var %nowytext
  var %space = $chr(32)
  var %kropka = $chr(46)
  var %minus = $chr(45)
  var %i = 1
  var %dlugosc = $len(%text) + 1
  var %ktory3 = %ktory
  :next
  if (%i != %dlugosc) {
    if (%ktory >= %i) { 
      var %litera = $mid(%text,%i,1)
      if (%litera == %space) { var %litera = _ | set %ktory %i + %ktory3 }
      if (%litera == %minus) { var %litera = %minus | set %ktory %i + %ktory3 }
      inc %i
      var %nowytext = %nowytext $+ %litera 
    goto next }
    if ($mid(%text,%i,1) == %space) { var %nowytext = %nowytext $+ _ | set %ktory %i + %ktory3 | inc %i 1 | goto next }
    if ($mid(%text,%i,1) == %minus) { var %nowytext = %nowytext $+ %minus | set %ktory %i + %ktory3 | inc %i 1 | goto next }
    var %nowytext = %nowytext $+ %kropka | inc %i 1 | goto next
  }  
  %nowytext = $replace(%nowytext,_,%space)
  msg %mkkanal 9,2 Podpowiedz: 8 %nowytext
  set %ktory %ktory3 + 1
}

on 1:TEXT:!przyp:%mkkanal: {
  if (%wyraz == $null) { halt }
  unset %pomieszany_wyraz
  if (%trybgry == 1) {
    %pomieszany_wyraz = $mikser(%wyraz)
  }
  else {
    var %token = 1
    while (%token <= $numtok(%wyraz, 32)) {
      %pomieszany_wyraz = %pomieszany_wyraz $+ $chr(32) $+ $mikser($gettok(%wyraz, %token, 32))
      inc %token
    }
  }
  msg %mkkanal 8,2 Uloz wyraz z liter: 12,0 %pomieszany_wyraz 
}

alias autom {
  set %delay 7
  unset %mkkanal %wyraz %wyraz2 %pomieszany_wyraz %score* %wyniki* %poz* %xx %xxx %punkty* %qqstart %pierwszy
  if ($1 == $null) set %mkkanal $?="Podaj kanal, na ktorym chcesz uruchomic Quiz:"
  else set %mkkanal $1
  if ($2 == $null) set %plk $file="Wybierz plik z pytaniami" c:\katalog\*.txt
  else set %plk $2-
  mkon
  set %licz 1
  .timerm -pr 1 %delay wyraz
}

alias -l mikser {
  var %litery = $len($1)
  if (%litery < 2) { return $1 }
  var %watchdog = 10
  var %temp_wyraz = $1
  while ((%watchdog > 0) && (%temp_wyraz == $1)) {
    var %zostalo_liter = %litery
    var %temp_wyraz, %uzyte_litery
    while (%zostalo_liter > 0) {
      var %numer_litery = $rand(1, %litery)
      while (x %numer_litery x isin %uzyte_litery) {
        %numer_litery = $rand(1, %litery)
      }
      var %litera = $mid($1, %numer_litery, 1)
      %uzyte_litery = %uzyte_litery $+ x %numer_litery x
      %temp_wyraz = %temp_wyraz $+ %litera
      dec %zostalo_liter
    }
    dec %watchdog $iif(%litery <= 2, 100)
  }
  return %temp_wyraz
}

alias -l wyraz {
  .timerm off
  if (%licz > $lines(%plk)) {
    msg %mkkanal 9,2 Koniec pytan! 
    dec %licz
    unset %wyraz
    goto End
  }
  else {
    set %wyraz $read -s %licz %plk
  }
  unset %pomieszany_wyraz
  if (%trybgry == 1) {
    %pomieszany_wyraz = $mikser(%wyraz)
  }
  else {
    var %token = 1
    while (%token <= $numtok(%wyraz, 32)) {
      %pomieszany_wyraz = %pomieszany_wyraz $+ $chr(32) $+ $mikser($gettok(%wyraz, %token, 32))
      inc %token
    }
  }
  pisz_wyraz
  :End
}

alias -l pisz_wyraz {
  set %qqstart $uptime(mirc)
  ;msg %mkkanal 11,2 LiTeRaKi 
  msg %mkkanal 9,2 Pytanie numer %licz z $lines(%plk). 
  msg %mkkanal 8,2 Uloz wyraz z liter: 12,0 %pomieszany_wyraz 
}

alias -l mkon {
  if ($script(kf.als) != $null) .unload -rs kf.als
  if ($script(kfx.rem) != $null) .unload -rs kfx.rem
  if ($script(kf1.rem) != $null) .unload -rs kf1.rem
  if ($alias(kf.als) != $null) .unload -a kf.als
  msg %mkkanal 2,2.........11 LiTeRaKi 9Mieszacz Kfiss™ 2.........
  msg %mkkanal 9,2 Dostepne komendy: !podp , !przyp , !punkty 
  set %ktory 1
  set %quizstart $ctime
  if (%trybgry == $null) set %trybgry 2
}

alias mktryb {
  if ((%trybgry == $null) || (%trybgry == 1)) {
    set %trybgry 2
    echo -a 4Ustawiono tryb mieszania: po wyrazach
  }
  else {
    set %trybgry 1
    echo -a 4Ustawiono tryb mieszania: wszystko razem
  }
}

alias -l congr {
  var %qtodp = $calc(($uptime(mirc) - %qqstart) / 1000)
  set %ktory 1
  adress $nick
  mkcounter %adres
  msg %mkkanal 9,2 Brawo!8 $1 9odgadl(a) wyraz:8 %wyraz 9po czasie:8 %qtodp sek 9suma punktow:8 %quiz [ $+ [ %adres ] ] 
  mkrank %adres
  set %pierwszy $nick
  set %wyraz2 %wyraz
  .enable #bonus
  .timerbonus 1 1 .disable #bonus
  unset %stat 
  unset %wyraz
  inc %licz
  .timerm -pr 1 %delay wyraz
}

alias mkoff {
  set %quizczas $duration($calc($ctime - %quizstart))
  msg %mkkanal 0,2 LiTeRaKi 8Mieszacz Kfiss™ 9zakonczony! 
  if (%licz == 1) { msg %mkkanal 9,2 Czas gry:8 %licz 9wyraz w8 %quizczas 2.........  }
  else { msg %mkkanal 9,2 Czas gry:8 %licz 9wyrazow w8 %quizczas  }
  msg %mkkanal 0,2 Autorzy: 8snajperx0,2, 8oyey0 & 8wilk 0 0 0 0 0 0 
  msg %mkkanal 0,2 Sciagaj z:9 http://www.quizpl.net 2... 
  unset %mkkanal %wyraz %wyraz2 %pomieszany_wyraz %trybgry %score* %wyniki* %poz* %xx %xxx %punkty*
  unset %quiz* %stawka %gracze %plk %num %par %lin %ktory %podp %block %autonxt %delay %starydel %adres %stat %pomoc* %q1 %q2 %rc %pytan %pyt %licz %qqstart %pierwszy
}

alias wyniki wyniki2 %wyniki
alias -l wyniki2 {
  %poz = 2
  while (%poz <= 149) {
    if (($ [ $+ [ %poz ] ] != $null) && (- $ [ $+ [ %poz ] ] 11 !isin %wyniki2)) %wyniki2 = - $ [ $+ [ %poz ] ] 11 $+ %score [ $+ [ $ [ $+ [ %poz ] ] ] ] - %wyniki2
    inc %poz 3
  }
  if (%wyniki2 != $null) wyniki3 %wyniki2
}

alias -l wyniki3 {
  %poz = 2
  while (%poz <= 198) {
    if ($ [ $+ [ %poz ] ] != $null) {
      %xx = $ [ $+ [ %poz ] ] 11 $+ %score [ $+ [ $ [ $+ [ %poz ] ] ] ]
      %xxx = $ [ $+ [ %poz ] $+ [ - ] $+ [ $calc(%poz + 1) ] ]
      %wyniki2 = $replace(%wyniki2,%xxx ,%xx)
    }
    inc %poz 4
  }
  %xtend = 800
  %poz1 = 1
  %poz2 = 5
  while (%xtend != 0) {  
    if ((%poz1 == $null) || (%poz1 >= 201)) {
      %poz1 = 1
      %poz2 = 5
    }
    wyniki4 %wyniki2
    wyniki4 %wyniki2
    inc %poz1 4
    inc %poz2 4
  }
  unset %poz1 %poz2 %poz1b %poz2b %xtend
  if (%wyniki2 != $null) {
    msg %mkkanal 8,2 Mieszacz Kfiss™ - wyniki: 
    msg %mkkanal 11,14 %wyniki2 
  }
}

alias -l wyniki4 {
  %punktyx1 = $mid($ [ $+ [ $calc(%poz1 + 2) ] ] ,4,$calc($len($ [ $+ [ $calc(%poz1 + 2) ] ] ) - 4))
  %punktyx2 = $mid($ [ $+ [ $calc(%poz2 + 2) ] ] ,4,$calc($len($ [ $+ [ $calc(%poz2 + 2) ] ] ) - 4))
  var %repl1 = $ [ $+ [ %poz1 ] $+ [ - ] $+ [ $calc(%poz1 + 3) ] ]
  var %repl2 = $ [ $+ [ %poz2 ] $+ [ - ] $+ [ $calc(%poz2 + 3) ] ]
  if (%punktyx1 < %punktyx2) {
    inc %xtend
    %wyniki2 = $replace(%wyniki2,%repl1,qwertyuiop)
    %wyniki2 = $replace(%wyniki2,%repl2,asdfghjklz)
    %wyniki2 = $replace(%wyniki2,qwertyuiop,%repl2)
    %wyniki2 = $replace(%wyniki2,asdfghjklz,%repl1)
  }
  else dec %xtend
  if ($mid($ [ $+ [ $calc(%poz1 + 2) ] ] , 4,$len($ [ $+ [ $calc(%poz1 + 2) ] ] - 4)) == 0) %wyniki2 = $remove(%wyniki2,%repl1)
  if ($mid($ [ $+ [ $calc(%poz2 + 2) ] ] , 4,$len($ [ $+ [ $calc(%poz2 + 2) ] ] - 4)) == 0) %wyniki2 = $remove(%wyniki2,%repl2)
}

#bonus off
on 1:TEXT:%wyraz2:%mkkanal: congr2 $nick
alias -l congr2 {
  if (%pierwszy != $nick) {
    var %qtodp = $calc(($uptime(mirc) - %qqstart) / 1000)
    adress $nick
    mkcounter %adres
    mkrank %adres
    msg %mkkanal 9,6 Brawo!8 $1 9byl(a) tuz tuz! Odgadl(a) wyraz:8 %wyraz2 9po czasie:8 %qtodp sek 9suma punktow:8 %quiz [ $+ [ %adres ] ] 
    unset %wyraz2
  }
}
#bonus end

alias -l rodzaj { 
  if ($1 == $null) return
  if ($1 == 1) { return punkt. }
  elseif (($1 > 1) && ($1 < 5)) { return punkty. }
  else { return punktow. }
}

alias -l imie {
  if ($1 == $null) return ---
  elseif ($ial($1,1).nick == $null) { if (%quiz [ $+ [ $1 ] ] == $null) { return 1 $+ $1 } | else return $1 }
  else { return $ial($1,1).nick }
}
