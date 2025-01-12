# Scorgan Music Player

## Requirements
- **AutoHotkey v1.1** must be installed. You can download it here: [https://www.autohotkey.com/](https://www.autohotkey.com/)

---

## How to Download and Use
1. **Download the Files:** Click the green **Code** button on this page and select **Download ZIP**.
2. **Extract the Files:** Unzip the downloaded folder.
3. **Run the Macro:**
   - Open the `.ahk` file with AutoHotkey.
   - Stand in the following location: ![Location Image](location.png)
   - Look at this point: ![Look Direction Image](look_here.png)
   - Press **F3** to open the song selection window.
   - Select a song and BPM: ![Song Selection Image](song_selection.png)

---

## How to Add Your Own Songs
You can add custom songs by creating a `.txt` file in the same folder as the script. The file should follow this format:

**Example: Hot Cross Buns**
```
[C, 0.25], [D, 0.25], [E, 0.5]
[D, 0.25], [E, 0.25], [F, 0.5]
```

### **Explanation:**
- Each note is written as `[Note, Duration]`.
- **Notes:** `C, Cs (C♯), Db, D, Ds, Eb, E, F, Fs, Gb, G, Gs, Ab, A, As, Bb, B, Ch` (Ch is the second C note on the far right side of teh scorgan)
- **Durations:**
  - `0.25` = Quarter note
  - `0.5` = Half note
  - `1.0` = Whole note
  - This can be any value, but be aware making it too small/using a bpm too fast will cause the music to sound wrong
- **Rests:** Use `[0, Duration]` for a rest.

### **Credit:**
- All current songs were transposed by **Jellyback Joe**. He takes Scorgan song requests on [Twitter](https://x.com/JellybackJoe). You should also check out his other linke: [Twitch](https://www.twitch.tv/jellybackjoe), [Destiny Channel](https://www.youtube.com/@jellybackjoe), [Music Channel](https://www.youtube.com/@jhfcomposer)

---

## Limitations
- Trying to play a song too fast will cause the tempo to become inconsistant

---

## Epilepsy Warning
This macro causes rapid camera movements and flashing visuals. Viewer discretion is advised.
