; Map Capslock to Control
; Map press & release of Capslock with no other key to Esc
; Press both shift keys together to toggle Capslock

*Capslock::
    Send {Blind}{LControl down}
    return

*Capslock up::
	Send {Blind}{LControl up}
    	; Tooltip, %A_PRIORKEY%
    	SetTimer, RemoveTooltip, 1000
    if A_PRIORKEY = CapsLock
    {
        	Send {Esc}
    }
    return

RemoveTooltip(){
    SetTimer, RemoveTooltip, Off
    Tooltip
    return
}

ToggleCaps(){
    ; this is needed because by default, AHK turns CapsLock off before doing Send
    SetStoreCapsLockMode, Off
    Send {CapsLock}
    SetStoreCapsLockMode, On
    return
}
LShift & RShift::ToggleCaps()
RShift & LShift::ToggleCaps()

; ^!r::Reload