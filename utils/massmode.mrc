;# MassMode v1.3 by wilk wilkowy (13.06.2008-09.08.2015)
;#########################################################
;# Features:
;# - wildcards allowed
;# - supports very fast kick6 and mode5 combos
;# - optimised queue (ex. does not op person with an op)
;# - partial support for MODES (server parameter)
;#
;# Commands:
;# /mv <nicks...>     - mass voice
;# /mdv <nicks...>    - mass devoice
;# /mh <nicks...>     - mass halfop
;# /mdh <nicks...>    - mass dehalfop
;# /mo <nicks...>     - mass op
;# /mdo <nicks...>    - mass deop
;#
;# /mkreason <reason> - set kick reason (alias: /mm)
;# /mk <nicks...>     - mass kick
;#########################################################

on *:START: {
  .ial on
  if (%massmode.reason == $null) set %massmode.reason --==[ AdioS ]==--
  echo -s MassMode v1.3 by wilk - loaded...
}

alias mm mkreason $1-
alias mkreason {
  set %massmode.reason $iif($1 == $null, $me, $1-)
}

alias mv {
  if (($1 != $null) && ($chan != $null) && (($me isop $chan) || ($me ishop $chan))) {
    massmode.mode5 + v $massmode.getnicks(+v, $chan, $1-)
  }
}

alias mdv {
  if (($1 != $null) && ($chan != $null) && (($me isop $chan) || ($me ishop $chan))) {
    massmode.mode5 - v $massmode.getnicks(-v, $chan, $1-)
  }
}

alias mh {
  if (($1 != $null) && ($chan != $null) && (($me isop $chan) || ($me ishop $chan))) {
    massmode.mode5 + h $massmode.getnicks(+h, $chan, $1-)
  }
}

alias mdh {
  if (($1 != $null) && ($chan != $null) && (($me isop $chan) || ($me ishop $chan))) {
    massmode.mode5 - h $massmode.getnicks(-h, $chan, $1-)
  }
}

alias mo {
  if (($1 != $null) && ($chan != $null) && ($me isop $chan)) {
    massmode.mode5 + o $massmode.getnicks(+o, $chan, $1-)
  }
}

alias mdo {
  if (($1 != $null) && ($chan != $null) && ($me isop $chan)) {
    massmode.mode5 - o $massmode.getnicks(-o, $chan, $1-)
  }
}

; kicks nicks in batches of 4 (first batch is 6)
alias mk {
  if (($1 != $null) && ($chan != $null) && (($me isop $chan) || ($me ishop $chan))) {
    var %nicks = $massmode.getnicks(k, $chan, $1-)
    massmode.kick6 $gettok(%nicks, 1-6, 32)
    var %nicks = $deltok(%nicks, 1-6, 32)
    while $numtok(%nicks, 32) {
      massmode.kick6 $gettok(%nicks, 1-4, 32)
      var %nicks = $deltok(%nicks, 1-4, 32)
    }
  }
}

; standard irc command supports up to 4 nicks, but with 2+4 trick we can
; instantly kick 6 people without being caught by penalty points lag,
; in rare conditions we could kick 7 nicks - this is not used
alias -l massmode.kick6 {
  if (($1 != $null) && ($numtok($1-, 32) < 8)) {
    var %nicks = $replace($1-, $chr(32), $chr(44))
    if ($numtok(%nicks, 44) > 4) {
      .quote kick $chan $gettok(%nicks, 5-7, 44) : $+ %massmode.reason
    }
    .quote kick $chan $gettok(%nicks, 1-4, 44) : $+ %massmode.reason
  }
}

; optimised for ircnet, but supports MODES
alias -l massmode.mode5 {
  var %nicks = $3-
  if ($numtok(%nicks, 32) >= 5) {
    mode $chan $1 $+ $str($2, 2) $gettok(%nicks, 1-2, 32)
    mode $chan $1 $+ $str($2, 3) $gettok(%nicks, 3-5, 32)
  }
  elseif ($numtok(%nicks, 32) >= 4) {
    ;mode $chan $1 $+ $2 $gettok(%nicks, 1, 32)
    ;mode $chan $1 $+ $str($2, 3) $gettok(%nicks, 2-4, 32)
    mode $chan $1 $+ $str($2, 2) $gettok(%nicks, 1-2, 32)
    mode $chan $1 $+ $str($2, 2) $gettok(%nicks, 3-4, 32)
  }
  else {
    mode $chan $1 $+ $str($2, $numtok(%nicks, 32)) %nicks
    ;mode $chan $1 $+ $str($2, 2) $gettok(%nicks, 1-2, 32)
    ;mode $chan $1 $+ $2 $gettok(%nicks, 3, 32)
  }
  var %nicks = $deltok(%nicks, 1-5, 32)
  while $numtok(%nicks, 32) {
    var %line = $gettok(%nicks, 1- $modespl, 32)
    mode $chan $1 $+ $str($2, $iif($modespl < $numtok(%line, 32), $modespl, $numtok(%line, 32))) %line
    var %nicks = $deltok(%nicks, 1- $modespl, 32)
  }
}

alias -l massmode.getnicks {
  var %nicks
  var %cnt = 1
  while $gettok($3-, %cnt, 32) {
    var %mask = $v1
    var %cnt2 = 1
    while $ialchan(%mask, $2, %cnt2).nick {
      var %nick = $v1
      if (($1 == k) && (%nick != $me)) {
        if (($me isop $2) || (($me ishop $2) && (%nick !isop $2))) var %nicks = $addtok(%nicks, %nick, 32)
      }
      elseif (($1 == +v) && (%nick isreg $2)) var %nicks = $addtok(%nicks, %nick, 32)
      elseif (($1 == -v) && (%nick isvoice $2)) var %nicks = $addtok(%nicks, %nick, 32)
      elseif (($1 == +h) && ((%nick isvoice $2) || (%nick isreg $2))) var %nicks = $addtok(%nicks, %nick, 32)
      elseif (($1 == -h) && (%nick ishop $2)) var %nicks = $addtok(%nicks, %nick, 32)
      elseif (($1 == +o) && (%nick !isop $2)) var %nicks = $addtok(%nicks, %nick, 32)
      elseif (($1 == -o) && (%nick isop $2)) var %nicks = $addtok(%nicks, %nick, 32)
      inc %cnt2
    }
    inc %cnt
  }
  return %nicks
}

on *:JOIN:*: {
  if ($nick == $me) .who $chan
}
