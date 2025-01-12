#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

global bpm := 100 ; Default BPM (beats per minute)
global base_duration := 60000 / bpm ; Calculated from BPM (quarter note duration in ms)

F3::
{
    select_and_play_song()
    return
}

; Function to display GUI, list songs, and handle selection
select_and_play_song() {
    local file_list := []  ; Initialize an array to hold the file names
    local file_display_text := ""
    local index := 1
    local file_path := A_ScriptDir . "\*.txt"

    ; Loop through all .txt files and list them
    Loop, Files, %file_path%
    {
        file_list.Push(A_LoopFileFullPath)
        file_display_text .= A_index . ": " . A_LoopFileName . "`n"
    }

    ; Check if there are any files found
    if (file_list.Length() = 0) {
        MsgBox, No text files found in the script directory.
        return
    }

    ; Create GUI for selection
    Gui, New
    Gui, Font, s11
    Gui, Add, Text, , Select a file number to play:
    Gui, Add, Edit, vSelectedFileNumber
    Gui, Add, Text, , %file_display_text%
    Gui, Add, Button, Default gplay_selected_song, Play
    Gui, Add, Text, , Adjust BPM
    Gui, Add, Edit, vSelectedBpm, % bpm
    Gui, Show, , Select a Song
    return
}

; Button action for playing the selected file
play_selected_song:
{
    Gui, Submit, NoHide
    Gui, Destroy
    selected_index := SelectedFileNumber
    file_path := A_ScriptDir . "\*.txt"
    bpm := SelectedBpm

    ; Refresh the file list to ensure up-to-date selection
    file_list := []
    Loop, Files, %file_path%
        file_list.Push(A_LoopFileFullPath)

    ; Validate user input
    if (selected_index < 1 || selected_index > file_list.Length()) {
        MsgBox, Invalid selection. Please enter a valid number.
        return
    }

    ; Retrieve the chosen file and play the notes
    selected_file := file_list[selected_index]
    WinActivate, Destiny 2
    Sleep, 100
    DllCall("mouse_event", uint, 1, int, 0, int, 5000)   
    Sleep, 100
    play_notes_from_file(selected_file)
    return
}

; Function to read a file and play the notes
play_notes_from_file(file_path) {
    notes := []  ; Clear the notes array

    ; Read the selected file and parse the content
    Loop, Read, %file_path%
    {
        line := A_LoopReadLine
        ; Remove square brackets and unnecessary characters
        StringReplace, line, line, `[, , All
        StringReplace, line, line, `], , All
        StringReplace, line, line, %A_Space%, , All
        
        ; Split by commas and process each note-duration pair
        notes_raw := StrSplit(line, ",")
        
        ; Loop through pairs and handle default durations
        index := 1
        Loop % notes_raw.Length()/2
        {
            note_letter := notes_raw[index]

            ; Try to get duration, default to quarter note
            if (index + 1 <= notes_raw.Length() && RegExMatch(notes_raw[index + 1], "^\d+(\.\d+)?$")) {
                duration_multiplier := notes_raw[index + 1]
            } else {
                duration_multiplier := 0.25
            }
            index += 2

            note_number := get_note_number(note_letter)
            
            if (note_number != "")
                notes.Push([note_number, duration_multiplier])
            else
                MsgBox, Error: Invalid note found in file "%note_letter%"
        }
    }

    ; Play the notes using test mode (set test to False for actual gameplay)
    test := False
    Sleep, 100
    Loop, % notes.Length()
        play_note(notes[A_Index], test)
    return
}

get_note_number(note) {
    switch note
    {
        case "C":  return 1
        case "Cs", "Db": return 2
        case "D":  return 3
        case "Ds", "Eb": return 4
        case "E":  return 5
        case "F":  return 6
        case "Fs", "Gb": return 7
        case "G":  return 8
        case "Gs", "Ab": return 9
        case "A":  return 10
        case "As", "Bb": return 11
        case "B":  return 12
        case "Ch": return 13
        default: return ""
    }
}

play_note(k, test:=false) {
    note := k[1] ; note identifier
    duration_multiplier := k[2] ; duration multiplier

    ; Recalculate base_duration in case BPM was changed
    base_duration := 60000 / bpm 

    ; Assign positions based on the note number
    switch note {
        case 0: move_mouse(0, 0, duration_multiplier, True) ; rest
        case 1: move_mouse(-3000, 600, duration_multiplier, False, test, 1)
        case 2: move_mouse(-2500, 550, duration_multiplier, False, test, 2)
        case 3: move_mouse(-2000, 450, duration_multiplier, False, test, 3)
        case 4: move_mouse(-1500, 350, duration_multiplier, False, test, 4)
        case 5: move_mouse(-1000, 250, duration_multiplier, False, test, 5)
        case 6: move_mouse(-500, 100, duration_multiplier, False, test, 6)
        case 7: move_mouse(0, 0, duration_multiplier, False, test, 7)
        case 8: move_mouse(500, 100, duration_multiplier, False, test, 8)
        case 9: move_mouse(1000, 250, duration_multiplier, False, test, 9)
        case 10: move_mouse(1500, 350, duration_multiplier, False, test, 10)
        case 11: move_mouse(2000, 450, duration_multiplier, False, test, 11)
        case 12: move_mouse(2500, 550, duration_multiplier, False, test, 12)
        case 13: move_mouse(3000, 600, duration_multiplier, False, test, 13)
    }

    return
}

move_mouse(x_dist, y_dist, duration_multiplier, rest:=false, test:=false, note_number:=1) {
    if (rest) {
        precise_sleep(base_duration * duration_multiplier)
        return
    }
    if (test) {
        frequencies := [262, 277, 294, 311, 330, 349, 370, 392, 415, 440, 466, 494, 523]
        frequency := frequencies[note_number]
        precise_sleep(10)
        precise_sleep(10)
        SoundBeep, % frequency, % (base_duration * duration_multiplier) - 20
        return
    }
    precise_sleep(5)
    DllCall("mouse_event", uint, 1, int, x_dist, int, y_dist-2750)

    ; Apply wait time based on note duration
    wait_time := base_duration * duration_multiplier  ; Duration calculated based on BPM
    precise_sleep(5)
    Click
    precise_sleep(max(wait_time-10, 1))

    DllCall("mouse_event", uint, 1, int, -x_dist, int, 5000)
    Return
}

precise_sleep(ti) {
	if (ht := DllCall("CreateWaitableTimerExW", "ptr", 0, "ptr", 0, "uint", 3, "uint", 0x1F0003, "uptr")) {
		DllCall("SetWaitableTimer", "uptr", ht, "uint64*", ti * -10000, "int", 0, "ptr", 0, "ptr", 0, "int", 0)
		DllCall("WaitForSingleObject", "uptr", ht, "UInt", 0xFFFFFFFF) 
        DllCall("CloseHandle", "uptr", ht)
    }
    return
}

F4::reload
