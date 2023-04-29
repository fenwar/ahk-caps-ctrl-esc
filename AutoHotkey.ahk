; Map Capslock to Control
; Map press & release of Capslock with no other key to Esc
; Press both shift keys together to toggle Capslock

; Detect Remote Desktop Session to work around interference from the script
; also running on the RDP client machine
SysGet, SessionRemote, 4096

; ----------------------------------------------------------------------------
; Only add the following bindings if we're *not* inside an RDP session:
#If SessionRemote = 0

; When Capslock is pressed down, act like LControl.
*Capslock::
    Send {Blind}{LControl down}
    return

; When Capslock is released, if nothing else was pressed then act like Esc.
*Capslock up::
    Send {Blind}{LControl up}
    ;Popup("CAPS UP AFTER " . A_PRIORKEY)
    if A_PRIORKEY = CapsLock
    {
        Send {Esc}
    }
    return

; Function to trigger the original Capslock behaviour.
; This is needed because by default, AHK turns CapsLock off before doing Send
ToggleCaps(){
    SetStoreCapsLockMode, Off
    Send {CapsLock}
    SetStoreCapsLockMode, On
    return
}

; When both shift keys are pressed, act like Capslock
LShift & RShift::ToggleCaps()
RShift & LShift::ToggleCaps()

; ----------------------------------------------------------------------------
; If we're running inside Remote Desktop and the above bindings are applied on
; the client computer, they are not carried seamlessly into the session.
; Only add the following bindings if we *are* inside an RDP session:
#If SessionRemote <> 0

; When Capslock is pressed down, do nothing. The RDP session receives the
; LControl from the RDP client.
*Capslock::
    return

; When Capslock is released, if nothing else was pressed then act like Esc.
; The RDP session does not receive the Esc from the RDP client.
*Capslock up::
    ;Popup("CAPS UP IN RDP AFTER " . A_PRIORKEY)
    if A_PRIORKEY = LControl
    {
        Send {Esc}
    }
    return

; ----------------------------------------------------------------------------
; General-purpose debugging functions & bindings, safe to define regardless of
; RDP state:
#If

Popup(Msg, Timeout:=1000){
    Tooltip, % Msg
    SetTimer, RemoveTooltip, % Timeout
}

RemoveTooltip(){
    SetTimer, RemoveTooltip, Off
    Tooltip
    return
}

; When Ctrl-Alt-R is pressed, reload this script.
; This needs to be done every time we switch between a physical login on the
; computer, and a remote desktop session on the computer.
^!r::Reload

; When Ctrl-Alt-H is pressed, show the Keypress history
^!h::KeyHistory

;Browser_Home::Media_Play_Pause
;^!NumpadAdd::Volume_Up
;^!NumpadSub::Volume_Down
