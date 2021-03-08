;# KeepNick v1.5 by wilk wilkowy (26.12.2008-13.08.2015)
;#########################################################
;# Features:
;# - fast nick regaining
;# - detects all nick events and netsplits
;# - easy customization with dialog box
;#
;# ToDo:
;# - support for multiple connections
;#
;# Commands:
;# /keepnick - show configuration dialog (alias: /kn)
;#########################################################

alias kn keepnick
alias keepnick dialog -mr keepnick.dialog keepnick.dialog

on *:START: {
  if (%keepnick.enabled == $null) {
    set %keepnick.enabled 0
    set %keepnick.nick $me
    set %keepnick.delay 45
  }
  .timer(keepnick) -o 0 %keepnick.delay keepnick.check
  set -e %keepnick._sent 0
  set -e %keepnick._split 0
  echo -s KeepNick v1.5 by wilk - loaded $+ $iif(%keepnick.enabled == 1, $chr(32) $+ $chr(40) $+ active $+ $chr(41)) $+ ...
}

on *:EXIT: {
  .timer(keepnick) off
  unset %keepnick._*
}

on *:UNLOAD: {
  .timer(keepnick) off
  unset %keepnick._*
}

dialog -l keepnick.dialog {
  title "KeepNick v1.5 by wilk"
  size -1 -1 118 58
  option dbu
  button "&OK", 1, 2 44 38 12, default flat ok
  button "&Cancel", 2, 78 44 38 12, flat cancel
  box "", 3, 2 0 114 42
  check "Enabled?", 4, 6 6 32 10, flat
  text "Keep nick:", 5, 6 20 26 8
  edit "", 6, 42 18 70 10, limit 15 center
  text "Check every:", 7, 6 30 34 8
  edit "", 8, 42 28 18 10, right
  text "s", 9, 62 30 6 8
}

; init dialog
on *:DIALOG:keepnick.dialog:INIT:*: {
  did $iif(%keepnick.enabled == 1, -c, -u) $dname 4
  did $iif(%keepnick.enabled == 1, -e, -b) $dname 5,6,7,8,9
  did -a $dname 6 %keepnick.nick
  did -a $dname 8 %keepnick.delay
}

; dialog click - ok
on *:DIALOG:keepnick.dialog:SCLICK:1: {
  set %keepnick.enabled $did($dname, 4).state
  var %nick = $did($dname, 6).text
  var %delay = $did($dname, 8).text
  if (%nick != $null) {
    set %keepnick.nick $left(%nick, 15)
  }
  if ((%delay != $null) && (%delay isnum) && (%delay > 0)) {
    set %keepnick.delay %delay
    .timer(keepnick) off
    .timer(keepnick) -o 0 %delay keepnick.check
  }
}

; dialog click - enable/disable
on *:DIALOG:keepnick.dialog:SCLICK:4: {
  did $iif($did($dname, 4).state == 1, -e, -b) $dname 5,6,7,8,9
}

; main timer handler
alias -l keepnick.check {
  if (%keepnick.enabled == 1) {
    if (%keepnick._sent == 1) {
      set %keepnick._sent 0
    }
    elseif (($me != %keepnick.nick) && ($status == connected) && ($ial(%keepnick.nick) == $null)) {
      set %keepnick._sent 1
      ison %keepnick.nick
    }
  }
}

; /ison response
raw 303:*: {
  if ((%keepnick.enabled == 1) && ($me != %keepnick.nick) && (%keepnick._sent == 1)) {
    if ($istok($2-, %keepnick.nick, 32) == $false) {
      nick %keepnick.nick
    }
    else {
      set %keepnick._sent 0
    }
    haltdef
  }
}

on *:CONNECT: {
  if ((%keepnick.enabled == 1) && ($me != %keepnick.nick)) {
    set %keepnick._sent 1
    ison %keepnick.nick
  }
}

; /nick response - "Erroneous Nickname"
raw 432:*: {
  if ((%keepnick.enabled == 1) && ($me != %keepnick.nick) && ($2 == %keepnick.nick) && (%keepnick._sent == 1)) {
    set %keepnick._sent 0
    set %keepnick.enabled 0
    haltdef
  }
}

; /nick response - "Nickname is already in use."
raw 433:*: {
  if ((%keepnick.enabled == 1) && ($me != %keepnick.nick) && ($2 == %keepnick.nick) && (%keepnick._sent == 1)) {
    set %keepnick._sent 0
    haltdef
  }
}

; /nick response - "Nick/channel is temporarily unavailable"
raw 437:*: {
  if ((%keepnick.enabled == 1) && ($me != %keepnick.nick) && ($2 == %keepnick.nick) && ((%keepnick._sent == 1) || (%keepnick._split == 1))) {
    set %keepnick._sent 0
    set %keepnick._split 1
    haltdef
  }
}

on *:QUIT: {
  if ((%keepnick.enabled == 1) && ($me != %keepnick.nick) && ($nick == %keepnick.nick)) {
    nick $nick
  }
}

on *:NICK: {
  if (%keepnick.enabled == 1) {
    if (($me != %keepnick.nick) && ($nick == %keepnick.nick)) {
      nick $nick
    }
    elseif (($me == $newnick) && ($newnick == %keepnick.nick)) {
      set %keepnick._sent 0
      set %keepnick._split 0
    }
  }
  if ($newnick == $me) {
    .timer(keepnick) off
    .timer(keepnick) -o 0 %keepnick.delay keepnick.check
  }
}
