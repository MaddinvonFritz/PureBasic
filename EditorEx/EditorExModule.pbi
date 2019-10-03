﻿;/ ============================
;/ =     EditExModule.pbi     =
;/ ============================
;/
;/ [ PB V5.7x / 64Bit / all OS / DPI ]
;/
;/ © 2019 Thorsten1867 (03/2019)
;/

; Last Update: 3.10.2019
;
; New:   Completely revised with a new approach to text handling
; Added: Correction suggestions for spell-checking (right click on wrong (red) words)
; Added: Right douple click: spell-checking and, if necessary, correction suggestions
; Added: CountItems()
; Bugfix: SetText()


;{ ===== MIT License =====
;
; Copyright (c) 2018 Thorsten Hoeppner
;
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
; 
; The above copyright notice and this permission notice shall be included in all
; copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.
;}


; ----- Description ------------------------------------------------------------------------------
; - WordWrap & Hyphenation          | Automatischer Zeilenumbruch & Silbentrennung (Ctrl-Minus)
; - Soft-Hyphen (Ctrl-Minus)        | 'Weiches' Trennzeichen bzw. bedingter Trennstrich
; - Automatic hiding of scrollbars  | Automatisches Ausblenden der Scrollbars
; - Automatic resizing              | Automatische Größenanpassung
; - Undo/Redo - function            | Undo/Redo - Funktion
; - Simple syntax highlighting      | Einfache Syntax-Hervorhebung (z.B. für Rechtschreibkontrolle)
; - Automatic spell checking        | automatische Rechtschreibkorrektur
; - Suggested corrections           | Korrekturvorschläge
; -------------------------------------------------------------------------------------------------


;{ -----ShortCuts -----
; Home         - Move cursor to start of row
; End          - Move cursor to end of row
; Shft-Del     - Cut & copy selected text to clipboard
; Shft-Insert  - Paste clipboard at cursor position
; Crtl-A       - Select all
; Crtl-C       - Copy selected text to clipboard
; Crtl-D       - Delete selected text
; Crtl-V       - Paste clipboard at cursor position
; Crtl-X       - Cut & copy selected text to clipboard
; Ctrl-Z       - Perform Undo
; Ctrl-End     - Move the cursor to the end of the last row
; Ctrl-Down    - Move the cursor to the beginning of the next paragraph
; Ctrl-Home    - Move the cursor to the beginning of the first row
; Crtl-Insert  - Copy selected text to clipboard 
; Crtl-Left    - Move the cursor to the beginning of the previous word
; Crtl-Minus   - Insert at cursor position a 'Soft-Hyphen'
; Crtl-Right   - Move the cursor to the beginning of the next word.
; Crtl-Up      - Move the cursor to the beginning of the previous paragraph.
;}


;{ _____ EditEx Commands _____ 

  ; EditEx::AddItem()                - Add text row at 'Position' (or #FirstRow / #LastRow)
  ; EditEx::AddToUserDictionary()    - Add a new word to user dictionary
  ; EditEx::AddWord()                - Add word to syntax highlighting
  ; EditEx::AttachPopup()            - Attach 'PopUpMenu' to gadget
  ; EditEx::ClearWords()             - Delete the list with the words for syntax highlighting
  ; EditEx::ClearUndo()              - Delete the list with Undo/Redo steps
  ; EditEx::Copy()                   - Copy selected text to clipboard
  ; EditEx::Cut()                    - Cut the selected text and copy it to the clipboard
  ; EditEx::CorrectionSuggestions()  - Retruns a list of suggested corrections
  ; EditEx::CountItems()             - Returns number of rows
  ; EditEx::DeleteSelection()        - Delete selected text (Remove selection: #True/#False)
  ; EditEx::DeleteWord()             - Delete word from syntax highlighting
  ; EditEx::EnableAutoSpellCheck()   - Activate automatic spelling correction
  ; EditEx::EnableSyntaxHighlight()  - Enable syntax highlighting (#False/#CaseSensitiv/#NoCase)
  ; EditEx::EnableUndoRedo()         - Enable 'Undo/Redo' function (#True/#False)
  ; EditEx::FreeDictionary()         - Removes the loaded dictionary from memory
  ; EditEx::GetAttribute()           - Returns value of attribute (#ReadOnly/#WordWrap/#Hyphenation/#Border/#CtrlChars)
  ; EditEx::GetColor()               - Returns color of attribute (#FrontColor/#BackColor/#SyntaxColor/#SelectionColor)
  ; EditEx::GetItemText()            - Returns text row at 'Position'
  ; EditEx::GetSelection()           - Returns selected text (Remove selection: #True/#False)
  ; EditEx::GetText()                - Returns all text rows seperated by 'Seperator'
  ; EditEx::InsertText()             - Insert text at cursor position (or replace selection)
  ; EditEx::IsRedo()                 - Checks if an redo is possible
  ; EditEx::IsSelected()             - Returns whether a selection exists
  ; EditEx::IsUndo()                 - Checks if an undo is possible
  ; EditEx::LoadDictionary()         - Load the dictionary for spell checking
  ; EditEx::LoadHyphenationPattern() - Load hyphenation pattern for selected language (#Deutsch/#English/#French)
  ; EditEx::Redo()                   - Perform Redo
  ; EditEx::ReDraw()                 - Redraw the gadget
  ; EditEx::RemoveGadget()           - Releases the used memory and deletes the cursor thread
  ; EditEx::Paste()                  - Inserting text from the clipboard
  ; EditEx::SaveUserDictionary()     - Save user dictionary
  ; EditEx::SetAutoResizeFlags()     - [#MoveX|#MoveY|#Width|#Height]
  ; EditEx::SetAttribute()           - Enable/Disable attribute (#ReadOnly/#WordWrap/#Hyphenation/#Border/#CtrlChars)
  ; EditEx::SetColor()               - Set or change color of attribute (#FrontColor/#BackColor/#SyntaxColor/#SelectionColor)
  ; EditEx::SetFont()                - Set or change font FontID(#Font)
  ; EditEx::SetFlags()               - Set gadget flags
  ; EditEx::SetItemText()            - Replace text row at 'Position'
  ; EditEx::SetText()                - Set or replace all text rows
  ; EditEx::SetTextWidth()           - Set text width for wordwrap and hyphenation (pt/px/in/cm/mm)
  ; EditEx::SpellCheck()             - Checks the spelling of the word (returns: #True/#False)
  ; EditEx::SpellChecking()          - Check the spelling in the editor gadget (#Highlight/#WrongWords)
  ; EditEx::Undo()                   - Perform Undo
  ; -----------------------
  ; EditEx::Gadget()                 - Creates an editor gadget
  ; -----------------------
  
;} ===========================


DeclareModule EditEx
  
  ;- ============================================================================
  ;-   DeclareModule - Constants
  ;- ============================================================================
  
  #Enable_Hyphenation     = #True  ; Requires file with hyphenation patterns => LoadHyphenationPattern()
  #Enable_SpellChecking   = #True  ; Requires file with dictionary           => LoadDictionary()
  #Enable_SyntaxHighlight = #True  ; Needed for spell checking!
  #Enable_UndoRedo        = #True 
  
  ;{ _____ Constants _____
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Windows
      #NL$ = #CRLF$
    CompilerCase #PB_OS_MacOS
      #NL$ = #LF$
    CompilerCase #PB_OS_Linux
      #NL$ = #LF$
  CompilerEndSelect
  
  Enumeration Language 1
    #Deutsch
    #English
    #French
  EndEnumeration
  
  EnumerationBinary
    #ReadOnly
    #ReadWrite
    #AutoResize
    #WordWrap
    #Hyphenation
    #MaxTextWidth
    #Borderless
    #CtrlChars
    #AutoSpellCheck
    #Suggestions
    #SyntaxHighlight
    #UndoRedo
    #ScrollBar_Vertical
    #ScrollBar_Horizontal
  EndEnumeration
  
  EnumerationBinary SpellCheck
    #Highlight
    #WrongWords
  EndEnumeration 
  
  Enumeration Color 1
    #FrontColor
    #BackColor
    #SyntaxColor
    #SelectTextColor
    #SelectionColor
  EndEnumeration

  EnumerationBinary
    #CaseSensitiv ; must be 1
    #NoCase       ; must be 2
    #Punctation
    #Brackets
    #QuotationMarks
    #WordOnly
    #Parse
  EndEnumeration
  
  EnumerationBinary
    #MoveX
    #MoveY
    #Width
    #Height
  EndEnumeration 
  
  ; --- UTF-8 ---
  #Space$      = "·"
  #SoftHyphen$ = Chr(173)
  #Paragraph$  = Chr(182)
  #Hyphen$     = Chr(8722)
  #BlockChar$  = "·/·"
  
  ; --- AddItem ---
  #FirstRow =  0
  #LastRow  = -1
  
  CompilerIf Defined(ModuleEx, #PB_Module)
    
    #Event_Cursor = ModuleEx::#Event_Cursor
    
  CompilerElse
    
    Enumeration #PB_Event_FirstCustomValue
      #Event_Cursor
    EndEnumeration

  CompilerEndIf
  
  
  CompilerIf #Enable_Hyphenation
    
    #PAT_Deutsch = "german.pat"
    #PAT_English = "english.pat"
    #PAT_French  = "french.pat"
    
  CompilerEndIf
  
  CompilerIf #Enable_SpellChecking
    
    #DIC_Deutsch = "german.dic"
    #DIC_English = "english.dic"
    #DIC_French  = "french.dic"
    
  CompilerEndIf
  ;}
  
  ;- ============================================================================
  ;-   DeclareModule
  ;- ============================================================================
  
  CompilerIf #Enable_SyntaxHighlight
    Declare   AddWord(GNum.i, Word.s, Color.i=#False)                            ; Add word to syntax highlighting
    Declare   ClearWords(GNum.i)                                                 ; Delete the list with the words for syntax highlighting
    Declare   DeleteWord(GNum.i, Word.s)                                         ; Delete word from syntax highlighting
    Declare   EnableSyntaxHighlight(GNum.i, State.i=#True, Flag.i=#CaseSensitiv) ; Enable syntax highlighting ((#False/#CaseSensitiv/#NoCase)
  CompilerEndIf
  
  CompilerIf #Enable_Hyphenation
    Declare LoadHyphenationPattern(File.s=#PAT_Deutsch)                     ; Load hyphenation pattern for selected language (ALL gadgets)
  CompilerEndIf
  
  CompilerIf #Enable_SpellChecking
    Declare   LoadDictionary(DicFile.s, AddDicFile.s="")                      ; Load the dictionary for spell checking (ALL gadgets)
    Declare   EnableAutoSpellCheck(GNum.i, State.i=#True, Flag.i=#False)      ; Activate automatic spelling correction
    Declare   SpellCheck(Word.s)                                              ; Checks the spelling of the word (returns: #True/#False)
    Declare   SpellChecking(GNum.i, Flag.i=#Highlight)                        ; Check the spelling in the editor gadget
    Declare   CorrectionSuggestions(GNum.i, Word.s, List Suggestions.s())
    Declare   AddToUserDictionary(GNum.i, Word.s)                             ; Add a new word to user dictionary
    Declare   SaveUserDictionary()                                            ; Save user dictionary
    Declare   FreeDictionary()                                                ; Removes the loaded dictionary from memory
    Global NewList WrongWords.s()                                           ; <= SpellChecking(GNum, #WrongWords)
  CompilerEndIf
  
  CompilerIf #Enable_UndoRedo
    
    Declare ClearUndo(GNum.i)
    Declare EnableUndoRedo(GNum.i, State.i=#True, MaxSteps.i=#False)
    Declare Undo(GNum.i)
    Declare Redo(GNum.i)
    Declare IsUndo(GNum.i)
    Declare IsRedo(GNum.i)
    
  CompilerEndIf
  
  Declare   AddItem(GNum.i, Position.i, Text.s)
  Declare   AttachPopup(GNum.i, PopUpMenu.i)
  Declare   Copy(GNum.i)
  Declare   Cut(GNum.i)
  Declare.i CountItems(GNum.i)
  Declare   DeleteSelection(GNum.i, Remove.i=#True)
  Declare.i GetAttribute(GNum.i, Attribute.i)
  Declare.i GetColor(GNum.i, Attribute.i)
  Declare.s GetItemText(GNum.i, Position.i)
  Declare.s GetSelection(GNum.i, Remove.i=#True)
  Declare.s GetText(GNum.i, Flags.i=#False)
  Declare   InsertText(GNum.i, Text.s)
  Declare.i IsSelected(GNum.i) 
  Declare   Paste(GNum.i)
  Declare   ReDraw(GNum.i)
  Declare   RemoveGadget(GNum.i)
  Declare   SetAttribute(GNum.i, Attribute.i, Value.i)
  Declare   SetAutoResizeFlags(GNum.i, Flags.i)
  Declare   SetColor(GNum.i, Attribute.i, Color.i)
  Declare   SetFlags(GNum.i, Flags.i)
  Declare   SetFont(GNum.i, FontID.i)
  Declare   SetItemText(GNum.i, Position.i, Text.s)
  Declare   SetText(GNum.i, Text.s)
  Declare   SetTextWidth(GNum.i, Value.f, unit.s="px")
  Declare.i Gadget(GNum.i, X.i, Y.i, Width.i, Height.i, Flags.i=#False, WindowNum.i=#PB_Default)
  
EndDeclareModule

Module EditEx
  
  EnableExplicit
  
  UseCRC32Fingerprint()
  
  ;- ============================================================================
  ;-   Module - Constants
  ;- ============================================================================  
  
  ;-_____ OS specific definitions _____
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Windows
      #Scroll_Width = 17
    CompilerCase #PB_OS_MacOS
      #Scroll_Width = 18
    CompilerCase #PB_OS_Linux
      #Scroll_Width = 18
  CompilerEndSelect
  
  ;{ _____ Constants _____
  #CursorFrequency = 600

  Enumeration Cursor 1
    #Cursor_Up
    #Cursor_Down
  EndEnumeration
  
  Enumeration MouseMove
    #Mouse_Move   ; just changing the cursor ...
    #Mouse_Select ; selecting
  EndEnumeration
  
  Enumeration Selection
    #NoSelection
    #StartSelection
    #Selected
  EndEnumeration
  
  Enumeration ScrollBar 1
    #Vertical
    #Horizontal
  EndEnumeration
  
  #CurrentCursor = -1
  #Scroll_Max    = 10000
  
  #PB_Shortcut_Hyphen = 189
  ;}
  
  ;- ============================================================================
  ;-   Module - Structures
  ;- ============================================================================   
  
  ;{ _____ Structures _____
  Structure Cursor_Thread_Structure ;{ Cursor-Thread
    Num.i
    Active.i
    Exit.i
  EndStructure ;}
  
  CompilerIf #Enable_Hyphenation    
    
    Structure HyphenStructure       ;{ Hyphenation
      chars.s
      pattern.s
    EndStructure ;}
    Global NewList HyphPattern.HyphenStructure()
    
  CompilerEndIf
  
  CompilerIf #Enable_SpellChecking
    
    Structure Dictionary_Structure
      Stem.s
      Endings.s
      Flag.i
    EndStructure
    
    Structure Spellcheck_Structure
      checked.i
      misspelled.i
    EndStructure
    
    Global NewList Dictionary.Dictionary_Structure()
    Global NewList UserDic.Dictionary_Structure()
    Global NewMap  Words.Spellcheck_Structure()
  CompilerEndIf
  
  CompilerIf #Enable_UndoRedo
    
    Structure Redo_Structure
      CursorPos.i
      Text.s
    EndStructure
    
    Structure Undo_Diff_Structure    ;{ EditEx()\Undo\Item()\DiffText()\..
      CursorPos.i
      Text.s
      Length.i
      CRC32.s
    EndStructure ;}
    
    Structure Undo_Item_Structure    ;{ EditEx()\Undo\Item()\...
      CursorPos.i
      Text_1.s
      Length_1.i
      CRC32_1.s
      Text_2.s
      Length_2.i
      CRC32_2.s
      List DiffText.Undo_Diff_Structure()
    EndStructure ;}
    
    Structure Undo_Structure         ;{ EditEx()\Undo\...
      CursorPos.i
      Redo.Redo_Structure
      List Item.Undo_Item_Structure()
      MaxSteps.i
    EndStructure ;}
    
  CompilerEndIf
  
  Structure Select_Structure         ;{ Selection
    Pos1.i
    Pos2.i
    Flag.i
  EndStructure ;}
  
  Structure Paragraph_Structure      ;{ ...\Paragraph\...
    Pos.i
    Len.i
  EndStructure ;}
  
  ; ------------------------------
  Structure Text_Structure           ;{ Text\...
    CursorRow.i
    CursorPos.i
    Map Paragraph.s()
  EndStructure ;}
  ; ------------------------------
  
  Structure Path_Structure           ;{ Path\...
    Dictionary.s
    Pattern.s
  EndStructure ;}
  Global Path.Path_Structure
  
  Structure EditEx_Mistake_Structure ;{ EditEx()\Mistake\...
    List Pos.i()
    Len.i
  EndStructure ;}
  
  Structure EditEx_Visible_Structure ;{ EditEx()\Visible\...
    RowOffset.i
    PosOffset.i
    CtrlChars.i
    Width.i
    Height.i
    WordList.i
  EndStructure ;}
  
  Structure EditEx_Scroll_Structure  ;{ EditEx()\VScroll\...
    ID.i
    MinPos.i  ; FirstTop
    MaxPos.i  ; LastTop
    Position.i ; TopCell
    Hide.i
  EndStructure ;}
  
  Structure EditEx_Text_Structure    ;{ EditEx()\Text\...
    Width.i       ; maximum width for hyphenation
    Height.i      ; text height of rows
    MaxRowWidth.i ; maximum length of rows 
    Len.i
  EndStructure ;}
  
  Structure EditEx_Mouse_Structure   ;{ EditEx()\Mouse\...
    DeltaX.i ; will be used to relativise absolute X,Y
    DeltaY.i
    Cursor.i
    Status.i
  EndStructure ;}

  Structure EditEx_Cursor_Structure  ;{ EditEx()\Cursor\...
    ; 0: "|abc" / 1: "a|bc" / 2: "ab|c"  / 3: "abc|"
    Pos.i
    Row.i
    X.i
    Y.i
    Height.i
    BackChar.s
    FrontColor.i
    BackColor.i
    LastX.i
    Pause.i
    State.i
  EndStructure ;}
  
  Structure EditEx_Color_Structure   ;{ EditEx()\Color\...
    Front.i
    Back.i
    Cursor.i
    SpellCheck.i
    SyntaxHighlight.i
    Highlight.i
    HighlightText.i
    ReadOnly.i
    ScrollBar.i
    Border.i
  EndStructure ;}
  
  Structure EditEx_Window_Structure  ;{ EditEx()\Window\...
    Num.i
    Width.i
    Height.i
  EndStructure ;}
  
  Structure EditEx_Size_Structure    ;{ EditEx()\Size\...
    X.i
    Y.i
    Width.i
    Height.i
    PaddingX.i
    PaddingY.i
    Flags.i
  EndStructure ;}
  
  Structure EditEx_Row_Structure     ;{ EditEx()\Row()\...
    X.i
    Y.i
    Pos.i
    Len.i
    Width.i
    WordWrap.s
  EndStructure ;}
  
  ; ----- EditEx - Structure -----
  
  Structure EditEx_Structure         ;{ EditEx(#gadget)\...
    CanvasNum.i
    ListNum.i
    WinNum.i
    PopupMenu.i
    FontID.i
    
    SyntaxHighlight.i
    
    Text$
    Flags.i
    ; ----------------
    Window.EditEx_Window_Structure
    Visible.EditEx_Visible_Structure
    Color.EditEx_Color_Structure
    Text.EditEx_Text_Structure
    Mouse.EditEx_Mouse_Structure
    HScroll.EditEx_Scroll_Structure
    VScroll.EditEx_Scroll_Structure
    Size.EditEx_Size_Structure
    Selection.Select_Structure
    Cursor.EditEx_Cursor_Structure
    CompilerIf #Enable_UndoRedo
      Undo.Undo_Structure
    CompilerEndIf
    ; ---------------
    Map  Syntax.i()
    Map  Mistake.s()
    List Suggestions.s()
    List Row.EditEx_Row_Structure()
  EndStructure ;}
  Global NewMap EditEx.EditEx_Structure()
  
  Global Thread.Cursor_Thread_Structure
  
  ;} ------------------------------
  
  Global Time.i, Time1.i, Time2.i
  
  ;- ============================================================================
  ;-   Module - Internal   [ -> Selected EditEx() map element required ]
  ;- ============================================================================
  
  Declare   UpdateScrollBar_()
  Declare   Draw_()
  Declare.s DeleteStringPart(String.s, Position.i, Length.i=1)
  Declare.i WordStart_(String.s, Position.i, Flags.i=#WordOnly)
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    ; Addition of mk-soft
    
    Procedure OSX_NSColorToRGBA(NSColor)
      Protected.cgfloat red, green, blue, alpha
      Protected nscolorspace, rgba
      nscolorspace = CocoaMessage(0, nscolor, "colorUsingColorSpaceName:$", @"NSCalibratedRGBColorSpace")
      If nscolorspace
        CocoaMessage(@red, nscolorspace, "redComponent")
        CocoaMessage(@green, nscolorspace, "greenComponent")
        CocoaMessage(@blue, nscolorspace, "blueComponent")
        CocoaMessage(@alpha, nscolorspace, "alphaComponent")
        rgba = RGBA(red * 255.9, green * 255.9, blue * 255.9, alpha * 255.)
        ProcedureReturn rgba
      EndIf
    EndProcedure
    
    Procedure OSX_NSColorToRGB(NSColor)
      Protected.cgfloat red, green, blue
      Protected r, g, b, a
      Protected nscolorspace, rgb
      nscolorspace = CocoaMessage(0, nscolor, "colorUsingColorSpaceName:$", @"NSCalibratedRGBColorSpace")
      If nscolorspace
        CocoaMessage(@red, nscolorspace, "redComponent")
        CocoaMessage(@green, nscolorspace, "greenComponent")
        CocoaMessage(@blue, nscolorspace, "blueComponent")
        rgb = RGB(red * 255.0, green * 255.0, blue * 255.0)
        ProcedureReturn rgb
      EndIf
    EndProcedure
    
  CompilerEndIf
  
	Procedure.f dpiX(Num.i)
	  If Num > 0  
	    ProcedureReturn DesktopScaledX(Num)
	  EndIf   
	EndProcedure

	Procedure.f dpiY(Num.i)
	  If Num > 0  
	    ProcedureReturn DesktopScaledY(Num)
	  EndIf  
	EndProcedure
   
  ;- ----- Strings -----
 
  Procedure.s StringSegment(String.s, Pos1.i, Pos2.i=#PB_Ignore)
    ; Return String from Pos1 to Pos2 
    Define.i Length
    
    Length = Pos2 - Pos1
    
    If Pos2 = #PB_Ignore
      ProcedureReturn Mid(String, Pos1 , Len(String) - Pos1)
    Else
      ProcedureReturn Mid(String, Pos1, Pos2 - Pos1)
    EndIf
    
  EndProcedure 

  Procedure.s DeleteStringPart(String.s, Position.i, Length.i=1)
    ; Delete string part at Position (with Length)
    
    If Position <= 0 : Position = 1 : EndIf
    If Position > Len(String) : Position = Len(String) : EndIf
    
    ProcedureReturn Left(String, Position - 1) + Mid(String, Position + Length)
  EndProcedure
  
  ; ----- Text / TextArea -----
  
  Procedure   IsTextArea_(X.i, Y.i)
  
    If X <= EditEx()\Size\PaddingX Or X > EditEx()\Size\PaddingX + EditEx()\Visible\Width
      ProcedureReturn #False
    ElseIf Y <= EditEx()\Size\PaddingY Or Y > EditEx()\Size\PaddingY + EditEx()\Visible\Height
      ProcedureReturn #False
    EndIf
    
    ProcedureReturn #True
  EndProcedure

  Procedure.i Paragraph_(Direction.i)
    ; cursor pos of previeous/next paragraph
    Define.i p, Pos, lfPos, Count

    Pos = 1

    Count = CountString(EditEx()\Text$, #LF$) + 1
    For p=1 To Count
      
      lfPos = FindString(EditEx()\Text$, #LF$, Pos + 1)
      If lfPos = 0 : lfPos = EditEx()\Text\Len : EndIf

      Select Direction
        Case #Cursor_Up
          If EditEx()\Cursor\Pos > Pos And EditEx()\Cursor\Pos <= lfPos + 1
            ProcedureReturn Pos
          EndIf  
        Case #Cursor_Down  
          If EditEx()\Cursor\Pos >= Pos And EditEx()\Cursor\Pos <= lfPos
            ProcedureReturn lfPos + 1
          EndIf  
      EndSelect 
      
      Pos = lfPos + 1
      
    Next
    
    ProcedureReturn Pos
  EndProcedure
  
  Procedure.i PageRows_(ScrollBar = #True)
    ; Number of visible rows
    Define.i Rows
    
    If EditEx()\Text\Height
      If ScrollBar
        ProcedureReturn EditEx()\Visible\Height / EditEx()\Text\Height
      Else
        ProcedureReturn (GadgetHeight(EditEx()\CanvasNum) - (EditEx()\Size\PaddingY * 2)) / EditEx()\Text\Height
      EndIf 
    EndIf

  EndProcedure
  
  ;- ----- Mouse -----
  
  Procedure   ChangeMouseCursor_(GNum.i, CursorX.i, CursorY.i)
    
    If IsTextArea_(CursorX, CursorY)
      If EditEx()\Mouse\Cursor <> #PB_Cursor_IBeam
        SetGadgetAttribute(GNum, #PB_Canvas_Cursor, #PB_Cursor_IBeam)
        EditEx()\Mouse\Cursor = #PB_Cursor_IBeam
      EndIf
    Else
      If EditEx()\Mouse\Cursor <> #PB_Cursor_Default
        SetGadgetAttribute(GNum, #PB_Canvas_Cursor, #PB_Cursor_Default)
        EditEx()\Mouse\Cursor = #PB_Cursor_Default
      EndIf
    EndIf
    
  EndProcedure  

  ;- ----- Cursor -----
  
  Procedure.i CursorUpDown_(Direction.i)
    ; Change cursor row (up/down)
    Define.i Row, c, CursorPos 
    
    Select Direction
      Case #Cursor_Up
        Row = EditEx()\Cursor\Row - 1
      Case #Cursor_Down
        Row = EditEx()\Cursor\Row + 1
    EndSelect

    If Row >= 0 And Row < ListSize(EditEx()\Row())
      
      If SelectElement(EditEx()\Row(), Row)
        
        If StartDrawing(CanvasOutput(EditEx()\CanvasNum))
          
          If EditEx()\Cursor\X < EditEx()\Row()\X + EditEx()\Row()\Width
  
            If EditEx()\FontID : DrawingFont(EditEx()\FontID) : EndIf
            
            For c=0 To EditEx()\Row()\Len - 1
              
              If TextWidth(Mid(EditEx()\Text$, EditEx()\Row()\Pos, c + 1)) >= EditEx()\Cursor\X
                CursorPos =  EditEx()\Row()\Pos + c
                EditEx()\Cursor\X   = EditEx()\Row()\X + TextWidth(Mid(EditEx()\Text$, EditEx()\Row()\Pos, c))
                EditEx()\Cursor\Y   = EditEx()\Row()\Y
                EditEx()\Cursor\Pos = CursorPos
                EditEx()\Cursor\Row = ListIndex(EditEx()\Row())
                Break
              EndIf  
              
            Next
  
          Else
            
            CursorPos =  EditEx()\Row()\Pos + EditEx()\Row()\Len - 1
            EditEx()\Cursor\X   = EditEx()\Row()\X + TextWidth(Mid(EditEx()\Text$, EditEx()\Row()\Pos, CursorPos))
            EditEx()\Cursor\Y   = EditEx()\Row()\Y
            EditEx()\Cursor\Pos = CursorPos
            EditEx()\Cursor\Row = ListIndex(EditEx()\Row())
            
          EndIf
        
          StopDrawing()
        EndIf
      
      EndIf
      
    EndIf

    ProcedureReturn CursorPos
  EndProcedure 

  Procedure.i CursorPos_(CursorX.i=#CurrentCursor, CursorY.i=#CurrentCursor, Change.i=#True)
    ; Determine cursor position based on X/Y position
    Define.i c, CursorPos
    
    If CursorX = #CurrentCursor : CursorX = EditEx()\Cursor\X : EndIf
    If CursorY = #CurrentCursor : CursorY = EditEx()\Cursor\Y : EndIf
    
    ForEach EditEx()\Row()
      
      If CursorY >= EditEx()\Row()\Y And CursorY < EditEx()\Row()\Y + EditEx()\Text\Height
        
        If StartDrawing(CanvasOutput(EditEx()\CanvasNum)) 
        
          If EditEx()\FontID : DrawingFont(EditEx()\FontID) : EndIf
          
          For c=0 To EditEx()\Row()\Len - 1
            
            If TextWidth(Mid(EditEx()\Text$, EditEx()\Row()\Pos, c + 1)) >= CursorX
              
              CursorPos =  EditEx()\Row()\Pos + c
              
              If Change
                EditEx()\Cursor\X   = EditEx()\Row()\X + TextWidth(Mid(EditEx()\Text$, EditEx()\Row()\Pos, c))
                EditEx()\Cursor\Y   = EditEx()\Row()\Y
                EditEx()\Cursor\Pos = CursorPos
                EditEx()\Cursor\Row = ListIndex(EditEx()\Row())
                EditEx()\Cursor\BackChar = Mid(EditEx()\Text$, EditEx()\Cursor\Pos, 1)
              EndIf
              
              Break
            EndIf  
            
          Next
          
          StopDrawing()
        EndIf
        
        Break
      EndIf
      
    Next
    
    ProcedureReturn CursorPos
  EndProcedure
  
  ;- ----- Scrolling -----
  
  Procedure.i GetScrollStateMax_(Flag.i)
    ; Maximum state of the scrollbar
    
    Select  Flag
      Case #Vertical
        ProcedureReturn ListSize(EditEx()\Row()) - PageRows_()
      Case #Horizontal
        ProcedureReturn EditEx()\Text\maxRowWidth - EditEx()\Visible\Width + 1
    EndSelect
    
  EndProcedure
  
  Procedure.i AdjustScrolls_(ReDraw.i=#True)
    ; hide/show scrollbars
    Define.i GNum, PageSize, PageRows, Rows, MaxPos
    Define.i HScroll, VScroll, Changed
    
    EditEx()\Text\maxRowWidth = 0
    ForEach EditEx()\Row()
      If EditEx()\Row()\Width > EditEx()\Text\maxRowWidth
        EditEx()\Text\maxRowWidth = EditEx()\Row()\Width
      EndIf   
    Next

    Rows = ListSize(EditEx()\Row())
    
    If EditEx()\Flags & #ScrollBar_Horizontal : HScroll = #True : EndIf
    If EditEx()\Flags & #ScrollBar_Vertical   : VScroll = #True : EndIf
    
    If EditEx()\Text\maxRowWidth <= dpiX(GadgetWidth(EditEx()\CanvasNum)) - dpiX(EditEx()\Size\PaddingX * 2)
      HScroll = #False
    EndIf

    If Rows <= PageRows_(#False)
      VScroll = #False
    EndIf
    
    If VScroll And HScroll ;{ Both scrollbars necessary
      EditEx()\Visible\Width  = GadgetWidth(EditEx()\CanvasNum)  - (EditEx()\Size\PaddingX * 2) - #Scroll_Width - 1
      EditEx()\Visible\Height = GadgetHeight(EditEx()\CanvasNum) - (EditEx()\Size\PaddingY * 2) - #Scroll_Width - 1
      ;}
    ElseIf HScroll         ;{ Horizontal scrollbar necessary
      EditEx()\Visible\Height = GadgetHeight(EditEx()\CanvasNum) - (EditEx()\Size\PaddingY * 2) - #Scroll_Width - 1
      If EditEx()\Flags & #ScrollBar_Vertical And Rows > PageRows_()
        EditEx()\Visible\Width = GadgetWidth(EditEx()\CanvasNum) - (EditEx()\Size\PaddingX * 2) - #Scroll_Width - 1
        VScroll = #True 
      Else
        EditEx()\Visible\Width = GadgetWidth(EditEx()\CanvasNum) - (EditEx()\Size\PaddingX * 2)
      EndIf ;}
    ElseIf VScroll         ;{ Vertical scrollbar necessary
      EditEx()\Visible\Width = GadgetWidth(EditEx()\CanvasNum)  - (EditEx()\Size\PaddingX * 2) - #Scroll_Width - 1
      If EditEx()\Flags & #ScrollBar_Horizontal And EditEx()\Text\maxRowWidth > EditEx()\Visible\Width
        EditEx()\Visible\Height = GadgetHeight(EditEx()\CanvasNum) - (EditEx()\Size\PaddingY * 2) - #Scroll_Width - 1
        HScroll = #True
      Else
        EditEx()\Visible\Height = GadgetHeight(EditEx()\CanvasNum) - (EditEx()\Size\PaddingY * 2)
      EndIf ;}
    Else                   ;{ No scrollbars necessary
      EditEx()\Visible\Width  = GadgetWidth(EditEx()\CanvasNum)  - (EditEx()\Size\PaddingX * 2) - 1
      EditEx()\Visible\Height = GadgetHeight(EditEx()\CanvasNum) - (EditEx()\Size\PaddingY * 2) - 1
      ;}
    EndIf

    If IsGadget(EditEx()\HScroll\ID) ;{ Horizontal Scrollbar
      
      GNum = GetGadgetData(EditEx()\HScroll\ID)
      
      If GetScrollStateMax_(#Horizontal) <= #Scroll_Max
        
        If HScroll And EditEx()\HScroll\Hide
          
          HideGadget(EditEx()\HScroll\ID, #False)
          
          If VScroll
            ResizeGadget(EditEx()\HScroll\ID, 2, GadgetHeight(EditEx()\CanvasNum) - #Scroll_Width - 1, GadgetWidth(EditEx()\CanvasNum) - #Scroll_Width - 4, #Scroll_Width)
          Else
            ResizeGadget(EditEx()\HScroll\ID, 2, GadgetHeight(EditEx()\CanvasNum) - #Scroll_Width - 1, GadgetWidth(EditEx()\CanvasNum) - 4, #Scroll_Width)
          EndIf

          Changed = #True
          
        ElseIf Not HScroll  And Not EditEx()\HScroll\Hide
          
          HideGadget(EditEx()\HScroll\ID, #True)

          EditEx()\Visible\PosOffset = 0
          Changed = #True
          
        EndIf
        
        SetGadgetAttribute(EditEx()\HScroll\ID, #PB_ScrollBar_Minimum,    0)
        SetGadgetAttribute(EditEx()\HScroll\ID, #PB_ScrollBar_Maximum,    EditEx()\Text\maxRowWidth)
        SetGadgetAttribute(EditEx()\HScroll\ID, #PB_ScrollBar_PageLength, EditEx()\Visible\Width)
        
        EditEx()\HScroll\MinPos = 1
        EditEx()\HScroll\MaxPos = GetScrollStateMax_(#Horizontal)
        
      EndIf
      ;}
    EndIf
    
    If IsGadget(EditEx()\VScroll\ID) ;{ Vertical Scrollbar
     
      GNum = GetGadgetData(EditEx()\VScroll\ID)
      
      MaxPos = GetScrollStateMax_(#Vertical)
      If MaxPos <= #Scroll_Max
        
        If VScroll And EditEx()\VScroll\Hide
          
          HideGadget(EditEx()\VScroll\ID, #False)
          
          If HScroll
            ResizeGadget(EditEx()\VScroll\ID, GadgetWidth(EditEx()\CanvasNum) - #Scroll_Width - 1, 2, #Scroll_Width, GadgetHeight(EditEx()\CanvasNum) - #Scroll_Width - 4) 
          Else
            ResizeGadget(EditEx()\VScroll\ID, GadgetWidth(EditEx()\CanvasNum) - #Scroll_Width - 1, 2, #Scroll_Width, GadgetHeight(EditEx()\CanvasNum) - 4)
          EndIf 
          
          Changed = #True
          
        ElseIf VScroll = #False And EditEx()\VScroll\Hide = #False
          
          HideGadget(EditEx()\VScroll\ID, #True)
          EditEx()\Visible\RowOffset = 0
          Changed = #True
        EndIf
        
        SetGadgetAttribute(EditEx()\VScroll\ID, #PB_ScrollBar_Minimum,    0)
        SetGadgetAttribute(EditEx()\VScroll\ID, #PB_ScrollBar_Maximum,    Rows)
        SetGadgetAttribute(EditEx()\VScroll\ID, #PB_ScrollBar_PageLength, PageRows_() + 1)
        
        EditEx()\VScroll\MinPos = 0
        EditEx()\VScroll\MaxPos = MaxPos
        
      EndIf 
      ;}
    EndIf
    
    If VScroll : EditEx()\VScroll\Hide = #False :  Else : EditEx()\VScroll\Hide = #True : EndIf 
    If HScroll : EditEx()\HScroll\Hide = #False :  Else : EditEx()\HScroll\Hide = #True : EndIf
    
    If Redraw And Changed : Draw_() : EndIf
    
  EndProcedure
  
  
  Procedure   SetHScrollPosition_()
    Define.i ScrollPos
    
    If IsGadget(EditEx()\HScroll\ID)
      ScrollPos = EditEx()\Visible\PosOffset
      If ScrollPos < EditEx()\HScroll\MinPos : ScrollPos = EditEx()\HScroll\MinPos : EndIf
      EditEx()\HScroll\Position = ScrollPos
      SetGadgetState(EditEx()\HScroll\ID, ScrollPos)
    EndIf
    
  EndProcedure 
  
  Procedure   SetVScrollPosition_()
    Define.i ScrollPos
    
    If IsGadget(EditEx()\VScroll\ID)
      ScrollPos = EditEx()\Visible\RowOffset
      If ScrollPos > EditEx()\VScroll\MaxPos : ScrollPos = EditEx()\VScroll\MaxPos : EndIf
      EditEx()\VScroll\Position = ScrollPos
      SetGadgetState(EditEx()\VScroll\ID, ScrollPos)
    EndIf
    
  EndProcedure  
  
  
  Procedure   UpdateScrollBar_()
    ; Adjust offset and scrollbar to new cursor position
    Define.i CharW, PageRows
    
    ;{ Changed cursor position
    If StartDrawing(CanvasOutput(EditEx()\CanvasNum)) 
      
      If EditEx()\FontID : DrawingFont(EditEx()\FontID) : EndIf
      
      ForEach EditEx()\Row()
        
        If EditEx()\Cursor\Pos >= EditEx()\Row()\Pos And EditEx()\Cursor\Pos < EditEx()\Row()\Pos + EditEx()\Row()\Len
          
          EditEx()\Cursor\X   = EditEx()\Row()\X + TextWidth(StringSegment(EditEx()\Text$, EditEx()\Row()\Pos, EditEx()\Cursor\Pos))
          EditEx()\Cursor\Y   = EditEx()\Row()\Y
          EditEx()\Cursor\Row = ListIndex(EditEx()\Row())
          
          CharW = TextWidth(StringSegment(EditEx()\Text$, EditEx()\Cursor\Pos, EditEx()\Cursor\Pos + 1))

          Break
        EndIf
        
      Next
      
      StopDrawing()
    EndIf ;}
    
    EditEx()\Cursor\BackChar = Mid(EditEx()\Text$, EditEx()\Cursor\Pos, 1)
    
    If IsGadget(EditEx()\HScroll\ID) ;{ Horizontal Scrollbar

      If EditEx()\Cursor\X - EditEx()\Visible\PosOffset < EditEx()\Size\PaddingX
        EditEx()\Visible\PosOffset = EditEx()\Cursor\X - EditEx()\Size\PaddingX
        SetGadgetState(EditEx()\HScroll\ID, EditEx()\Visible\PosOffset)
      ElseIf EditEx()\Cursor\X + CharW >= EditEx()\Visible\Width + EditEx()\Size\PaddingX
        EditEx()\Visible\PosOffset = EditEx()\Cursor\X + CharW - (EditEx()\Visible\Width + EditEx()\Size\PaddingX)
        SetGadgetState(EditEx()\HScroll\ID, EditEx()\Visible\PosOffset)
      EndIf  

      SetHScrollPosition_()
      ;}
    EndIf
  
    If IsGadget(EditEx()\VScroll\ID) ;{ Vertical Scrollbar
      
      PageRows  = PageRows_() - 1

      If EditEx()\Cursor\Row < EditEx()\Visible\RowOffset
        EditEx()\Visible\RowOffset = EditEx()\Cursor\Row
        If EditEx()\Visible\RowOffset < 0 : EditEx()\Visible\RowOffset = 0 : EndIf
        SetGadgetState(EditEx()\VScroll\ID, EditEx()\VScroll\Position)
      EndIf
     
      If EditEx()\Cursor\Row > PageRows
        EditEx()\Visible\RowOffset = EditEx()\Cursor\Row - PageRows
        SetGadgetState(EditEx()\VScroll\ID, EditEx()\VScroll\Position)
      EndIf
 
      SetVScrollPosition_()
      ;}
    EndIf
    
  EndProcedure

  ;- ----- Selection -----
  
  Procedure   RemoveSelection_()
    ; Remove & Reset Selection 
    
    If EditEx()\Selection\Flag = #Selected
      EditEx()\Selection\Flag = #NoSelection
      EditEx()\Selection\Pos1 = #False
      EditEx()\Selection\Pos2 = #False
      EditEx()\Mouse\Status   = #False
    EndIf
    
  EndProcedure
  
  Procedure.i DeleteSelection_(Remove.i=#True)
    ; Delete selected text (Remove selection: #True/#False)
    Define.i Pos1, Pos2

    If EditEx()\Selection\Flag = #Selected
      
      If EditEx()\Selection\Pos1 > EditEx()\Selection\Pos2
        Pos1 = EditEx()\Selection\Pos2
        Pos2 = EditEx()\Selection\Pos1
      Else
        Pos1 = EditEx()\Selection\Pos1
        Pos2 = EditEx()\Selection\Pos2
      EndIf 
      
      EditEx()\Text$ = Left(EditEx()\Text$, Pos1 - 1) + Mid(EditEx()\Text$, Pos2)
      EditEx()\Cursor\Pos = Pos1
      
      If Remove : RemoveSelection_() : EndIf
      
      ProcedureReturn #True
    EndIf
    
    ProcedureReturn #False
  EndProcedure
  
  Procedure.s GetSelection_(Remove.i=#True)
    ; Return selected text (Remove selection: #True/#False)
    Define.i Pos1, Pos2
    Define.s Text$
    
    If EditEx()\Selection\Flag = #Selected      
      
      If EditEx()\Selection\Pos1 > EditEx()\Selection\Pos2
        Pos1 = EditEx()\Selection\Pos2
        Pos2 = EditEx()\Selection\Pos1
      Else
        Pos1 = EditEx()\Selection\Pos1
        Pos2 = EditEx()\Selection\Pos2
      EndIf
      
      Text$ = StringSegment(EditEx()\Text$, Pos1, Pos2)
      
      If Remove : RemoveSelection_() : EndIf
      
      ProcedureReturn Text$
    EndIf
  
  EndProcedure
  
  ;- ----- Words etc. -----
  
  Procedure   AddItem_(Position.i, Text.s)
    
    EditEx()\Text$ = InsertString(EditEx()\Text$, Text, Position)

  EndProcedure
  
  Procedure.s GetWord_(Word.s, Flags.i=#WordOnly)
    ; word with or without punctuation etc.
    Define.i i 
    Define.s Char$, Diff1$, Diff2$
    
    Word = RTrim(Trim(Word), #LF$)
    If EditEx()\Visible\CtrlChars : Word = RTrim(Word, #Paragraph$) : EndIf
    
    For i=1 To 2
      Char$ = Left(Word, 1)
      Select Char$
        Case "{", "[", "(", "<"
          If Flags & #Brackets Or Flags & #WordOnly
            Word = LTrim(Word, Char$)
            Diff1$ + Char$
          EndIf
        Case Chr(34), "'", "«", "»"
          If Flags & #QuotationMarks Or Flags & #WordOnly
            Word = LTrim(Word, Char$)
            Diff1$ + Char$
          EndIf
        Case #SoftHyphen$, #LF$, #Paragraph$
          Word = LTrim(Word, Char$)
        Default
          Break
      EndSelect
    Next
    
    For i=1 To 2
      Char$ = Right(Word, 1)
      Select Char$
        Case ".", ":", ",", ";", "!", "?"
          If Flags & #Punctation Or Flags & #WordOnly
            Word = RTrim(Word, Char$)
            Diff2$ + Char$
          EndIf
        Case  ")", "]", "}", ">"
          If Flags & #Brackets Or Flags & #WordOnly
            Word = RTrim(Word, Char$)
            Diff2$ + Char$
          EndIf
        Case Chr(34), "'", "«", "»"
          If Flags & #QuotationMarks Or Flags & #WordOnly
            Word = RTrim(Word, Char$)
            Diff2$ + Char$
          EndIf  
        Case " ", #SoftHyphen$, #LF$
          Word = LTrim(Word, Char$)
        Default
          Break
      EndSelect
    Next
    If Flags & #Parse
      ProcedureReturn Diff1$+"|"+Word+"|"+Diff2$
    Else  
      ProcedureReturn Word
    EndIf
  EndProcedure
  
  
  Procedure.i WordStart_(String.s, Position.i, Flags.i=#WordOnly)
    ; Position of the first letter of the word
    Define.i p
    
    For p = Position To 1 Step -1
      Select Mid(String, p, 1)
        Case " ", #CR$, #LF$, #LF$
          ProcedureReturn p + 1
        Case ".", ":", ",", ";", "!", "?"
          If Flags & #Punctation Or Flags & #WordOnly
            ProcedureReturn p + 1
          EndIf
        Case "{", "[", "(", "<"
          If Flags & #Brackets Or Flags & #WordOnly
            ProcedureReturn p + 1
          EndIf
        Case Chr(34), "'", "«", "»"
          If Flags & #QuotationMarks Or Flags & #WordOnly
            ProcedureReturn p + 1
          EndIf
      EndSelect
    Next
    
    ProcedureReturn 1
  EndProcedure
  
  Procedure.i WordEnd_(String.s, Position.i, Flags.i=#WordOnly)
    ; Position of the last letter of the word
    Define.i p
    
    For p = Position To Len(String)
      Select Mid(String, p, 1)
        Case " ", #CR$, #LF$, #LF$
          ProcedureReturn p
        Case ".", ":", ",", ";", "!", "?"
          If Flags & #Punctation Or Flags & #WordOnly
            ProcedureReturn p
          EndIf
        Case ")", "]", "}", ">"
          If Flags & #Brackets Or Flags & #WordOnly
            ProcedureReturn p
          EndIf
        Case Chr(34), "'", "»", "«"
          If Flags & #QuotationMarks Or Flags & #WordOnly
            ProcedureReturn p
          EndIf  
      EndSelect
    Next
    
    ProcedureReturn p
  EndProcedure
  
  
  Procedure.i SpaceStart_(String.s, Position.i)
    ; start position of multiple space
    Define.i p
    
    For p = Position To 1 Step -1
      If Mid(String, p, 1) <> " "
        ProcedureReturn p + 1
      EndIf 
    Next
    
    ProcedureReturn 1
  EndProcedure  
  
  Procedure.i SpaceEnd_(String.s, Position.i)
    ; end position of multiple space
    Define.i p
    
    For p = Position To Len(String)
      
      If Mid(String, p, 1) <> " "
        ProcedureReturn p
      EndIf
      
    Next
    
    ProcedureReturn p
  EndProcedure
  
  
  ;----------------------------------------------------------------------------- 
  ;-   SpellChecking
  ;-----------------------------------------------------------------------------  
  
  CompilerIf #Enable_SpellChecking

    Procedure ResizeList_(Pos.i)
      Define.i X, Y, sX, sY
      
      If StartDrawing(CanvasOutput(EditEx()\CanvasNum)) 
      
        If EditEx()\FontID : DrawingFont(EditEx()\FontID) : EndIf
        
        ForEach EditEx()\Row()
          
          If Pos >= EditEx()\Row()\Pos And Pos < EditEx()\Row()\Pos + EditEx()\Row()\Len
            
            X = EditEx()\Row()\X + TextWidth(StringSegment(EditEx()\Text$, EditEx()\Row()\Pos, Pos))
            Y = EditEx()\Row()\Y + EditEx()\Text\Height

            Break
          EndIf
          
        Next
        
        StopDrawing()
      EndIf
      
      sX = GadgetX(EditEx()\CanvasNum, #PB_Gadget_ScreenCoordinate)
    	sY = GadgetY(EditEx()\CanvasNum, #PB_Gadget_ScreenCoordinate)
    	
    	ResizeWindow(EditEx()\WinNum, sX + X, sY + Y, #PB_Ignore, #PB_Ignore)
    	
    EndProcedure
    
    Procedure.s UCase_(Word.s)
      ProcedureReturn UCase(Left(Word, 1)) + Mid(Word, 2)
    EndProcedure
    
    Procedure.i SearchFirstLetters(Word.s)
      Define.i ListPos, StartPos, EndPos
      Define.s Chars
      
      StartPos = 0
      EndPos   = ListSize(Dictionary()) - 1
      
      Chars = LCase(Left(Word, 2))
      
      Repeat
        ListPos = StartPos + Round((EndPos - StartPos)  / 2, #PB_Round_Up)
        If SelectElement(Dictionary(), ListPos)
          If Chars = Left(Dictionary()\Stem, 2)
            Break
          ElseIf Chars < Left(Dictionary()\Stem, 2)
            EndPos   = ListPos - 1
          ElseIf Chars > Left(Dictionary()\Stem, 2)
            StartPos = ListPos + 1
          EndIf  
        EndIf
      Until (EndPos - StartPos) < 0
      
      While PreviousElement(Dictionary())
        If Chars <> Left(Dictionary()\Stem, 2)
          ProcedureReturn ListIndex(Dictionary()) + 1
        EndIf
      Wend
      
      ProcedureReturn ListIndex(Dictionary())
    EndProcedure
    
    Macro D(i,j) ; DamerauLevenshteinDistance
      D_(i+1,j+1)
    EndMacro

    Procedure   DamerauLevenshteinDistance(String1$, String2$)
      Define.i m, n, i, j, k, l, db, min, value, cost, maxDist
      
      NewMap DA.i()
      
      m = Len(String1$)
      n = Len(String2$)
      
      Dim D_(m+1,n+1)
      
      maxDist = m + n
      D(-1,-1) = maxDist 
    
      For i=0 To m
        D( i,-1) = maxDist
        D( i, 0) = i
      Next
    
      For j=0 To n
        D(-1, j) = maxDist
        D( 0, j) = j
      Next
      
      For i=1 To m
        
        db = 0
        
        For j=1 To n
          
          k = DA(Mid(String2$, j, 1))
          l = db
          
          If Mid(String1$, i, 1) = Mid(String2$, j, 1)
            cost = 0
            db = j
          Else
            cost = 1
          EndIf
          
          min   = D(i-1,j-1) + cost ; a substitution
          value = D(i  ,j-1) + 1    ; an insertion
          If value < min : min = value : EndIf
          value = D(i-1,j  ) + 1    ; a deletion
          If value < min : min = value : EndIf
          value = D(k-1,l-1) + (i-k-1) + 1 + (j-l-1) ; transposition
          If value < min : min = value : EndIf
          D(i,j) = min
          
        Next
        
        DA(Mid(String1$, i, 1)) = i
        
      Next  
      
      ProcedureReturn D(m,n)
    EndProcedure

    Procedure.i CorrectionSuggestions_(Word.s)
      Define.i i, Index, UCase, Count
      Define.s FirstChars, dicWord$
      
      FirstChars = LCase(Left(Word, 2))
      
      If Left(Word, 1) = UCase(Left(Word, 1)) : UCase = #True : EndIf
      
      ClearList(EditEx()\Suggestions())
      
      Index = SearchFirstLetters(Word)
      If SelectElement(Dictionary(), Index)
        
        Repeat
  
          If Left(Dictionary()\Stem, 2) <> FirstChars : Break : EndIf
          
          If UCase Or Dictionary()\Flag
            dicWord$ = UCase_(Dictionary()\Stem)
          Else
            dicWord$ = Dictionary()\Stem
          EndIf
          
          If DamerauLevenshteinDistance(Word, dicWord$) = 1
            AddElement(EditEx()\Suggestions())
            EditEx()\Suggestions() = dicWord$
          EndIf  
          
          If Dictionary()\Endings
            
            Count = CountString(Dictionary()\Endings, "|") + 1
            
            For i=1 To Count
              
              If DamerauLevenshteinDistance(Word, dicWord$ + StringField(Dictionary()\Endings, i, "|")) = 1
                AddElement(EditEx()\Suggestions())
                EditEx()\Suggestions() = dicWord$ + StringField(Dictionary()\Endings, i, "|")
              EndIf
              
            Next
            
          EndIf
          
        Until NextElement(Dictionary()) = #False
        
      EndIf

      ProcedureReturn ListSize(EditEx()\Suggestions())
    EndProcedure
    
    
    Procedure   UpdateWordList_()
      Define.i s, Spaces
      Define.s Word$, Text$
 
      Text$ = RemoveString(EditEx()\Text$, #Hyphen$)
      Text$ = RemoveString(Text$, #SoftHyphen$)
      Text$ = ReplaceString(Text$, #LF$, " ")
      
      Spaces = CountString(Text$, " ")
      For s=1 To Spaces + 1
        Word$ = GetWord_(StringField(Text$, s, " "))
        If Word$
          If FindMapElement(Words(), Word$) = #False
            AddMapElement(Words(), Word$)
          EndIf
        EndIf
      Next
      
    EndProcedure
    
    Procedure   SpellCheckEndings_(Position.i, Word.s, Length.i=4)
      Define.i i, StartPos, Count
      Define.s Pattern$ = LCase(Left(Word, Length))
      NewMap CheckWords.i()
      
      ;{ Search starting position
      StartPos = Position
      While PreviousElement(Dictionary())
        If Left(Dictionary()\Stem, Length) <> Pattern$ : Break : EndIf
        StartPos - 1
      Wend ;}
      
      ;{ Search to end position & expand endings
      If SelectElement(Dictionary(), StartPos)
        Repeat
          If Left(Dictionary()\Stem, Length) <> Pattern$ : Break : EndIf
          CheckWords(Dictionary()\Stem) = Dictionary()\Flag
          If Dictionary()\Endings
            Count = CountString(Dictionary()\Endings, "|") + 1
            For i=1 To Count
              CheckWords(Dictionary()\Stem + StringField(Dictionary()\Endings, i, "|")) = Dictionary()\Flag
            Next
          EndIf
        Until NextElement(Dictionary()) = #False
      EndIf ;}
      
      If FindMapElement(CheckWords(), LCase(Word))
        If CheckWords() ; Upper case required
          If Left(Word, 1) = UCase(Left(Word, 1))
            ProcedureReturn #True
          EndIf
        Else            ; No capitalization required
          ProcedureReturn #True
        EndIf
      EndIf
      
      ProcedureReturn #False
    EndProcedure
    
    Procedure   SpellCheck_(Word.s)
      Define.i ListPos, StartPos, EndPos
      Define.s LWord$ = LCase(Word)
      
      StartPos = 0
      EndPos   = ListSize(Dictionary()) - 1
      
      Repeat
        ListPos = StartPos + Round((EndPos - StartPos)  / 2, #PB_Round_Up)
        If SelectElement(Dictionary(), ListPos)
          If Dictionary()\Stem  = LWord$                      ;{ direct hit
            If Dictionary()\Flag ; Upper case required
              If Left(Word, 1) = UCase(Left(Word, 1))
                ProcedureReturn #True
              Else
                ProcedureReturn #False
              EndIf
            Else           ; No capitalization required
              ProcedureReturn #True
            EndIf ;}
          ElseIf Left(LWord$, 4) < Left(Dictionary()\Stem, 4) ;{ word smaller than current word
            EndPos   = ListPos - 1
            ;}
          ElseIf Left(LWord$, 4) > Left(Dictionary()\Stem, 4) ;{ word greater than current word
            StartPos = ListPos + 1
            ;}
          Else                                          ;{ Search by word endings
            If SpellCheckEndings_(ListPos, Word)
              ProcedureReturn #True
            Else
              ProcedureReturn #False
            EndIf ;}
          EndIf
        EndIf
      Until (EndPos - StartPos) < 0
      
      ProcedureReturn #False
    EndProcedure
    
    
    Procedure   SpellChecking_(Highlight.i = #True)
      Define.s Word$
      
      ClearMap(EditEx()\Mistake())
      
      If MapSize(Words()) > 0
        
        ForEach Words()
          
          Word$ = MapKey(Words())
          
          If Words()\checked = #False
            If SpellCheck(Word$) = #False
              Words()\misspelled = #True
            EndIf
            Words()\checked = #True
          EndIf
          
          If Words()\misspelled = #True
            
            If EditEx()\Flags & #Suggestions : EditEx()\Mistake(Word$) = Word$ : EndIf 
            
            If Highlight : EditEx()\Syntax(Word$) = EditEx()\Color\SyntaxHighlight : EndIf
            
          EndIf
          
        Next
        
      EndIf
      
    EndProcedure
    
  CompilerEndIf
  
  ;----------------------------------------------------------------------------- 
  ;-   Hyphenation / WordWrap
  ;-----------------------------------------------------------------------------
  
  CompilerIf #Enable_Hyphenation
    ;/ ===== Word Hy-phen-a-tion =====
    ;/ Algorithm of Frankling Mark Liang (1983)
    ;/ based on "hyphenator for HTML" (Mathias Nater, Zürich)
    
    Procedure.s HyphenateWord(Word.s, Separator.s=#SoftHyphen$)
      Define.i c, i, ins 
      Define.i WordLen, WordIdx, Digits
      Define LWord.s, Char.s{1}
      
      If ListSize(HyphPattern()) = 0
        Debug "ERROR: Hyphen patterns are required => LoadHyphenationPattern()"
        ProcedureReturn Word
      EndIf
      
      Word    = "_"+Word+"_" ; Mark start and end of word
      LWord   = LCase(Word)  ; Lowercase word
      WordLen = Len(Word)    ; Word length
      
      Dim Hypos.s(WordLen)
      
      ForEach HyphPattern()  ;{ Evaluate pattern
        
        WordIdx = FindString(LWord, HyphPattern()\chars, 1)
        If WordIdx
          
          Digits = 1
          
          For c = 1 To Len(HyphPattern()\pattern)
            
            Char = Mid(HyphPattern()\pattern, c, 1)
            If Char >= "0" And Char <= "9"
              
              If c = 1
                i = WordIdx
              Else
                i = WordIdx + c - Digits
              EndIf
              
              If Hypos(i) = "" Or Hypos(i) < Char ; Overwrite a smaller number
                Hypos(i) = Char
              EndIf
              
              Digits + 1
              
            EndIf
            
          Next
          
        EndIf
        ;}
      Next
      
      ;{ Create separation pattern
      ins = 0               
      For c = 3 To WordLen - 2
        If Val(Hypos(c))
          Word = InsertString(Word, Hypos(c), c + ins)
          ins + 1
        EndIf
      Next ;}
      
      Word = Trim(Word, "_") ; Remove marker for beginning and end of word
      For c = 1 To 9         ;{ Determine separation points (odd numbers)
        If (c % 2)
          ; separation point
          Word = ReplaceString(Word, Str(c), Separator)
        Else                
          ; no separation point
          Word = RemoveString(Word, Str(c))
        EndIf
      Next ;}
      
      ProcedureReturn Word
    EndProcedure
    
  CompilerEndIf
  
  ;----------------------------------------------------------------------------- 
  ;-   Undo / Redo
  ;-----------------------------------------------------------------------------
  
  CompilerIf #Enable_UndoRedo
    
    Procedure.s GetCRC32(Text.s) 
      ProcedureReturn StringFingerprint(Text, #PB_Cipher_CRC32)
    EndProcedure
    
    Procedure   AddRedo_()
      
      EditEx()\Undo\Redo\CursorPos = EditEx()\Cursor\Pos
      EditEx()\Undo\Redo\Text      = EditEx()\Text$
      
    EndProcedure
    
    Procedure.s GetLastRedo_()
      
      If EditEx()\Undo\Redo\Text
        EditEx()\Undo\CursorPos = EditEx()\Undo\Redo\CursorPos
        ProcedureReturn EditEx()\Undo\Redo\Text
      EndIf
      
      EditEx()\Undo\CursorPos = EditEx()\Cursor\Pos
      
      ProcedureReturn EditEx()\Text$
    EndProcedure
    
    Procedure   ClearRedo_()
      
      EditEx()\Undo\Redo\CursorPos = 0
      EditEx()\Undo\Redo\Text      = ""
      
    EndProcedure
    
    Procedure   ChangeUndoCursor_()
      
      If LastElement(EditEx()\Undo\Item())
        
        If LastElement(EditEx()\Undo\Item()\DiffText())
          EditEx()\Undo\Item()\DiffText()\CursorPos = EditEx()\Cursor\Pos
        Else
          EditEx()\Undo\Item()\CursorPos = EditEx()\Cursor\Pos
        EndIf
        
        EditEx()\Cursor\BackChar = Mid(EditEx()\Text$, EditEx()\Cursor\Pos, 1)
        
      EndIf 

    EndProcedure  
    
    Procedure   AddUndo_()
      Define.i Lenght_1, Lenght_2
      Define.s Diff$, CRC32_1$, CRC32_2$
      
      ;{ MaxSteps
      
      If EditEx()\Undo\MaxSteps And ListSize(EditEx()\Undo\Item()) >= EditEx()\Undo\MaxSteps
        If FirstElement(EditEx()\Undo\Item())
          DeleteElement(EditEx()\Undo\Item())
        EndIf
      EndIf ;}
      
      If LastElement(EditEx()\Undo\Item())
        
        ;{ Compare with last entry    
        If LastElement(EditEx()\Undo\Item()\DiffText())
          Lenght_1 = EditEx()\Undo\Item()\DiffText()\Length
          CRC32_1$ = EditEx()\Undo\Item()\DiffText()\CRC32
        Else
          Lenght_1 = EditEx()\Undo\Item()\Length_1
          CRC32_1$ = EditEx()\Undo\Item()\CRC32_1
        EndIf
        
        Lenght_2 = EditEx()\Undo\Item()\Length_2
        CRC32_2$ = EditEx()\Undo\Item()\CRC32_2
        
        If CRC32_1$ = GetCRC32(Left(EditEx()\Text$, Lenght_1)) And CRC32_2$ = GetCRC32(Right(EditEx()\Text$, Lenght_2))
          
          ;{ Remember differential text
          Diff$ = Mid(EditEx()\Text$, Lenght_1 + 1, EditEx()\Text\Len - Lenght_1 - Lenght_2)
          If Diff$
            
            If AddElement(EditEx()\Undo\Item()\DiffText())
              EditEx()\Undo\Item()\DiffText()\CursorPos = EditEx()\Cursor\Pos
              EditEx()\Undo\Item()\DiffText()\Text      = Diff$
              EditEx()\Undo\Item()\DiffText()\Length    = Lenght_1 + Len(Diff$)
              EditEx()\Undo\Item()\DiffText()\CRC32     = GetCRC32(Left(EditEx()\Text$, EditEx()\Undo\Item()\DiffText()\Length))
            EndIf 
            
          EndIf ;}
          
        Else
          
          If AddElement(EditEx()\Undo\Item()) ;{ Remember full text
            EditEx()\Undo\Item()\CursorPos = EditEx()\Cursor\Pos
            EditEx()\Undo\Item()\Text_1    = Left(EditEx()\Text$, EditEx()\Cursor\Pos - 1)
            EditEx()\Undo\Item()\Length_1  = Len(EditEx()\Undo\Item()\Text_1)
            EditEx()\Undo\Item()\CRC32_1   = GetCRC32(EditEx()\Undo\Item()\Text_1)
            EditEx()\Undo\Item()\Text_2    = Mid(EditEx()\Text$, EditEx()\Cursor\Pos)
            EditEx()\Undo\Item()\Length_2  = Len(EditEx()\Undo\Item()\Text_2)
            EditEx()\Undo\Item()\CRC32_2   = GetCRC32(EditEx()\Undo\Item()\Text_2)
          EndIf ;}
          
        EndIf ;}
        
      Else
      
        If AddElement(EditEx()\Undo\Item()) ;{ First entry
          EditEx()\Undo\Item()\CursorPos = EditEx()\Cursor\Pos
          EditEx()\Undo\Item()\Text_1    = Left(EditEx()\Text$, EditEx()\Cursor\Pos - 1)
          EditEx()\Undo\Item()\Length_1  = Len(EditEx()\Undo\Item()\Text_1)
          EditEx()\Undo\Item()\CRC32_1   = GetCRC32(EditEx()\Undo\Item()\Text_1)
          EditEx()\Undo\Item()\Text_2    = Mid(EditEx()\Text$, EditEx()\Cursor\Pos)
          EditEx()\Undo\Item()\Length_2  = Len(EditEx()\Undo\Item()\Text_2)
          EditEx()\Undo\Item()\CRC32_2   = GetCRC32(EditEx()\Undo\Item()\Text_2)
        EndIf ;}
      
      EndIf

      
    EndProcedure
    
    Procedure.s GetLastUndo_(Redo.i=#False)
      Define.s Text1$, Text2$, LastDiff$

      AddRedo_()
      
      If LastElement(EditEx()\Undo\Item())
        
        Text1$ = EditEx()\Undo\Item()\Text_1
        Text2$ = EditEx()\Undo\Item()\Text_2
        
        If LastElement(EditEx()\Undo\Item()\DiffText()) ; Differential text
          
          EditEx()\Undo\CursorPos = EditEx()\Undo\Item()\DiffText()\CursorPos
          
          LastDiff$ = EditEx()\Undo\Item()\DiffText()\Text
          
          DeleteElement(EditEx()\Undo\Item()\DiffText())
          
          If FirstElement(EditEx()\Undo\Item()\DiffText())
            
            Repeat
              Text1$ + EditEx()\Undo\Item()\DiffText()\Text
            Until NextElement(EditEx()\Undo\Item()\DiffText()) = #False
            
          EndIf
          
          ProcedureReturn Text1$ + LastDiff$ + Text2$
        Else ; Complete text
          
          EditEx()\Undo\CursorPos = EditEx()\Undo\Item()\CursorPos
          
          If ListSize(EditEx()\Undo\Item()) > 1 : DeleteElement(EditEx()\Undo\Item()) : EndIf
          
          ProcedureReturn Text1$ + Text2$
        EndIf  

      EndIf
      
      EditEx()\Undo\CursorPos = EditEx()\Cursor\Pos
      
      ProcedureReturn EditEx()\Text$
    EndProcedure
    
    Procedure   Undo_()
      Define.s Text$
    
      Text$ = GetLastUndo_()

      If Trim(Text$) = Trim(EditEx()\Text$)
        EditEx()\Text$      = GetLastUndo_()
        EditEx()\Cursor\Pos = EditEx()\Undo\CursorPos
      Else  
        EditEx()\Text$      = Text$
        EditEx()\Cursor\Pos = EditEx()\Undo\CursorPos
      EndIf
      
    EndProcedure
    
  CompilerEndIf
  
  ;- __________ Drawing __________
  
  Procedure.i BlendColor_(Color1.i, Color2.i, Scale.i=50)
    Define.i R1, G1, B1, R2, G2, B2
    Define.f Blend = Scale / 100
    
    R1 = Red(Color1): G1 = Green(Color1): B1 = Blue(Color1)
    R2 = Red(Color2): G2 = Green(Color2): B2 = Blue(Color2)
    
    ProcedureReturn RGB((R1*Blend) + (R2 * (1-Blend)), (G1*Blend) + (G2 * (1-Blend)), (B1*Blend) + (B2 * (1-Blend)))
  EndProcedure
  
  
  Procedure   CurserXY_()
    
    If EditEx()\Cursor\Pos >= EditEx()\Row()\Pos And EditEx()\Cursor\Pos <= EditEx()\Row()\Pos + EditEx()\Row()\Len
      EditEx()\Cursor\X   = EditEx()\Row()\X + TextWidth(StringSegment(EditEx()\Text$, EditEx()\Row()\Pos, EditEx()\Cursor\Pos))
      EditEx()\Cursor\Y   = EditEx()\Row()\Y
      EditEx()\Cursor\Row = ListIndex(EditEx()\Row())
    EndIf
    
  EndProcedure 

  Procedure.i AddRow_(Pos.i, X.i, Y.i) 

    If AddElement(EditEx()\Row())
      EditEx()\Row()\Pos = Pos
      EditEx()\Row()\X   = X
      EditEx()\Row()\Y   = Y
      ProcedureReturn #True
    EndIf
  
    ProcedureReturn #False    
  EndProcedure
  
  CompilerIf #Enable_SyntaxHighlight
    
    Procedure   DrawSyntaxHighlight_(Word$, Pos, X, Y)
      Define.i wPos, Result, DiffW
      Define.s sWord$
      
      sWord$ = GetWord_(Word$)
      If EditEx()\SyntaxHighlight = #NoCase : sWord$ = LCase(sWord$) :  EndIf

      If FindMapElement(EditEx()\Syntax(), sWord$)

        DrawingMode(#PB_2DDrawing_Default)
        
        If EditEx()\Syntax() = #False : EditEx()\Syntax() = EditEx()\Color\SyntaxHighlight : EndIf
        
        wPos = FindString(Word$, sWord$)
        If wPos > 1 : X + TextWidth(Left(Word$, wPos - 1)) : EndIf
        
        DrawText(X, Y, RTrim(sWord$, #LF$), EditEx()\Syntax(), EditEx()\Color\Back)
        
        DrawingMode(#PB_2DDrawing_Transparent)
        
        If EditEx()\Cursor\Pos >= Pos + wPos - 1 And EditEx()\Cursor\Pos < Pos + wPos + Len(sWord$)
          EditEx()\Cursor\FrontColor = EditEx()\Syntax()
          EditEx()\Cursor\BackColor  = EditEx()\Color\Back
        EndIf
        
      EndIf
      
      If EditEx()\Flags & #CtrlChars
        
        DrawingMode(#PB_2DDrawing_Default)

        wPos = FindString(Word$, " ")
        If wPos
          If FindMapElement(EditEx()\Syntax(), #Space$)  
            DiffW = (TextWidth(" ") - TextWidth(#Space$)) / 2
            DrawText(X + TextWidth(Left(Word$, wPos - 1)) + DiffW, Y, #Space$, EditEx()\Syntax(), EditEx()\Color\Back)
          EndIf
        EndIf

        wPos = FindString(Word$, #Paragraph$)
        If wPos
          If FindMapElement(EditEx()\Syntax(), #Paragraph$)  
            DrawText(X + TextWidth(Left(Word$, wPos - 1)), Y, #Paragraph$, EditEx()\Syntax(), EditEx()\Color\Back)
          EndIf
        EndIf
        
        wPos = FindString(Word$, #SoftHyphen$)
        If wPos
          If FindMapElement(EditEx()\Syntax(), #SoftHyphen$)
          ;Line(X + TextWidth(Left(Word$, wPos - 1)), Y, dpiX(1), EditEx()\Text\Height, EditEx()\Syntax())
          DrawText(X + TextWidth(Left(Word$, wPos - 1)), Y, #SoftHyphen$, EditEx()\Syntax(), EditEx()\Color\Back)
          EndIf
        EndIf

        DrawingMode(#PB_2DDrawing_Transparent)
        
      EndIf
      
    EndProcedure

  CompilerEndIf
  
  Procedure   DrawSelection_(X, Pos.i, Len.i, Pos1.i, Pos2.i)
    Define.i sPosX, sWidth
    Define.s Text$

    If Pos2 >= Pos And Pos1 <= Pos + Len

      DrawingMode(#PB_2DDrawing_Default)
      
      If Pos1 <= Pos
        
        sPosX = X
        
        If Pos2 >= Pos + Len
          Text$ = StringSegment(EditEx()\Text$, Pos, Pos + Len)
        Else
          Text$ = StringSegment(EditEx()\Text$, Pos, Pos2)
        EndIf

      Else
        
        sPosX = X + TextWidth(StringSegment(EditEx()\Text$, Pos, Pos1))
        
        If Pos2 >= Pos + Len
          Text$ = StringSegment(EditEx()\Text$, Pos1, Pos + Len)
        Else
          Text$ = StringSegment(EditEx()\Text$, Pos1, Pos2)
        EndIf

      EndIf
      
      sWidth = TextWidth(Text$)
      
      DrawText(sPosX, EditEx()\Row()\Y, RTrim(Text$, #LF$), EditEx()\Color\HighlightText, EditEx()\Color\Highlight)
      
      DrawingMode(#PB_2DDrawing_Transparent)

      If EditEx()\Cursor\Pos >= Pos1 And EditEx()\Cursor\Pos < Pos2
        EditEx()\Cursor\FrontColor = EditEx()\Color\HighlightText
        EditEx()\Cursor\BackColor  = EditEx()\Color\Highlight
      EndIf
      
    EndIf 

  EndProcedure  
  
  Procedure   Draw_() ; Draw Gadget
    Define.i X, Y, Width, Height, PosX, PosY, WordLen, maxTextWidth
    Define.i r, w, h, Rows, Words, Pos, wPos, Pos1, Pos2, sPosX, Hyphen
    Define.s Row$, Word$, hWord$, WordOnly$, WordMask$, Part$
    
    ClearList(EditEx()\Row())
    
    If StartDrawing(CanvasOutput(EditEx()\CanvasNum)) 
      
      If EditEx()\FontID : DrawingFont(EditEx()\FontID) : EndIf

      EditEx()\Text\Height = TextHeight("Abc")
      
      ;{ _____ Draw Background _____
      DrawingMode(#PB_2DDrawing_Default)
      Box(0, 0, dpiX(GadgetWidth(EditEx()\CanvasNum)), dpiY(GadgetHeight(EditEx()\CanvasNum)), EditEx()\Color\Back)  
      ;}
      
      X = dpiX(EditEx()\Size\PaddingX) - dpiX(EditEx()\Visible\PosOffset)
      Y = dpiY(EditEx()\Size\PaddingY) - (EditEx()\Visible\RowOffset * EditEx()\Text\Height)

      If EditEx()\Text\Width
        maxTextWidth = dpiX(EditEx()\Text\Width)
      Else
        maxTextWidth = dpiX(EditEx()\Visible\Width)
      EndIf

      If Not EditEx()\Cursor\Pos : EditEx()\Cursor\Pos = 1 : EndIf
      
      EditEx()\Text\Len = Len(EditEx()\Text$)
      If EditEx()\Text\Len : Pos = 1 : EndIf
      
      EditEx()\Cursor\FrontColor = EditEx()\Color\Front
      EditEx()\Cursor\BackColor  = EditEx()\Color\Back
      
      ;{ _____ Selection _____
      If EditEx()\Selection\Pos1 > EditEx()\Selection\Pos2
        Pos1 = EditEx()\Selection\Pos2
        Pos2 = EditEx()\Selection\Pos1
      Else
        Pos1 = EditEx()\Selection\Pos1
        Pos2 = EditEx()\Selection\Pos2
      EndIf ;}
    
      ;{ _____ Draw Text _____
      DrawingMode(#PB_2DDrawing_Transparent)
      
      Pos    = 1
      PosY   = Y
      
      Rows = CountString(EditEx()\Text$, #LF$) + 1 
      For r=1 To Rows

        PosX = X
        
        Row$ = StringField(EditEx()\Text$, r, #LF$)
        If r <> Rows : Row$ + #LF$ : EndIf
        
        If EditEx()\Flags & #CtrlChars : Row$ = ReplaceString(Row$, #LF$, #Paragraph$) : EndIf  
        
        If EditEx()\Flags & #WordWrap Or EditEx()\Flags & #Hyphenation ;{ WordWrap / Hyphenation
          
          AddRow_(Pos, PosX, PosY) 
          
          Words = CountString(Row$, " ") + 1
          For w=1 To Words
            
            Word$ = StringField(Row$, w, " ")
            If w <> Words : Word$ + " " : EndIf

            If PosX + TextWidth(RTrim(Word$)) > maxTextWidth
              
              CompilerIf #Enable_Hyphenation
                
                If EditEx()\Flags & #Hyphenation
                  
                  WordOnly$ = GetWord_(Word$)
                  
                  If WordOnly$ <> Word$
                    WordMask$ = ReplaceString(Word$, WordOnly$, "$")
                  Else
                    WordMask$ = ""
                  EndIf
                  
                  hWord$ = HyphenateWord(WordOnly$)
                  Hyphen = CountString(hWord$, #SoftHyphen$)
                  
                  If Hyphen
                    
                    Part$ = ""
                    
                    If WordMask$ : hWord$ = ReplaceString(WordMask$, "$", hWord$) : EndIf
                  
                    For h=1 To Hyphen + 1
                      If PosX + TextWidth(RTrim(Part$ + StringField(hWord$, h, #SoftHyphen$))) > maxTextWidth
                        Break
                      Else
                        Part$ + StringField(hWord$, h, #SoftHyphen$)
                      EndIf  
                    Next
                    
                    If Part$
                      
                      hWord$ = RemoveString(hWord$, #SoftHyphen$)
                      
                      DrawText(PosX, PosY, RTrim(Part$ + "-", #LF$), EditEx()\Color\Front)
                      
                      Word$ = Mid(hWord$, Len(Part$) + 1)
                      
                      If EditEx()\Flags & #SyntaxHighlight : DrawSyntaxHighlight_(Part$ + "-", Pos, PosX, PosY) : EndIf
                      
                      WordLen = Len(Part$)
                      
                      If EditEx()\Selection\Flag = #Selected : DrawSelection_(PosX, Pos, WordLen, Pos1, Pos2) : EndIf
                      
                      EditEx()\Row()\Len   + WordLen
                      EditEx()\Row()\Width + TextWidth(Part$)
                      EditEx()\Row()\WordWrap = "-" + #LF$
                      
                      Pos + WordLen
                    EndIf
                    
                  EndIf

                EndIf
                
              CompilerEndIf
              
              If EditEx()\Row()\WordWrap = "" : EditEx()\Row()\WordWrap = #LF$ : EndIf
              
              PosX = X
              PosY + EditEx()\Text\Height
              AddRow_(Pos, PosX, PosY)
              
            EndIf

            sPosX = PosX
            PosX  = DrawText(PosX, PosY, RTrim(Word$, #LF$), EditEx()\Color\Front)

            CompilerIf #Enable_SyntaxHighlight
            
              If EditEx()\Flags & #SyntaxHighlight : DrawSyntaxHighlight_(Word$, Pos, sPosX, PosY) : EndIf
              
            CompilerElse
              
              If EditEx()\Flags & #CtrlChars
                
                If FindMapElement(EditEx()\Syntax(), #Space$)  
                  wPos = FindString(Word$, " ")
                  If wPos
                    DiffW = (TextWidth(" ") - TextWidth(#Space$)) / 2
                    DrawText(X + TextWidth(Left(Word$, wPos - 1)) + DiffW, Y, #Space$, $B48246)
                  EndIf
                EndIf
                
              EndIf
              
            CompilerEndIf 

            WordLen = Len(Word$)
            
            If EditEx()\Selection\Flag = #Selected : DrawSelection_(sPosX, Pos, WordLen, Pos1, Pos2) : EndIf
            
            EditEx()\Row()\Len   + WordLen
            EditEx()\Row()\Width + TextWidth(Word$)
            
            CurserXY_()
            
            Pos + WordLen
          Next
          
          CurserXY_()
          
          PosY + EditEx()\Text\Height
          ;}
        Else                                                           ;{ no WordWrap
          
          AddRow_(Pos, PosX, PosY)
          
          Words = CountString(Row$, " ") + 1
          For w=1 To Words
            
            Word$ = StringField(Row$, w, " ")
            If w <> Words : Word$ + " " : EndIf

            sPosX = PosX
            PosX  = DrawText(PosX, PosY, RTrim(Word$, #LF$), EditEx()\Color\Front)
            
            CompilerIf #Enable_SyntaxHighlight
            
              If EditEx()\Flags & #SyntaxHighlight : DrawSyntaxHighlight_(Word$, Pos, sPosX, PosY) : EndIf
              
            CompilerElse
              
              If FindMapElement(EditEx()\Syntax(), #Space$)  
                wPos = FindString(Word$, " ")
                If wPos
                  DiffW = (TextWidth(" ") - TextWidth(#Space$)) / 2
                  DrawText(X + TextWidth(Left(Word$, wPos - 1)) + DiffW, Y, #Space$, $B48246)
                EndIf
              EndIf
              
            CompilerEndIf   
            
            WordLen = Len(Word$)
            
            If EditEx()\Selection\Flag = #Selected : DrawSelection_(sPosX, Pos, WordLen, Pos1, Pos2) : EndIf

            EditEx()\Row()\Len   + WordLen
            EditEx()\Row()\Width + TextWidth(Word$)
            
            Pos + WordLen
          Next
          
          CurserXY_()
          
          PosY + EditEx()\Text\Height
          ;}
        EndIf

      Next  
      ;}

      ;{ _____ Cursor _____
      If EditEx()\Cursor\State
        Line(EditEx()\Cursor\X, EditEx()\Cursor\Y, dpiX(1), EditEx()\Cursor\Height, EditEx()\Color\Cursor)
      EndIf
      EditEx()\Cursor\Height   = EditEx()\Text\Height
      EditEx()\Cursor\BackChar = Mid(EditEx()\Text$, EditEx()\Cursor\Pos, 1)
      ;}
      
      ;{ _____ Padding _____
      DrawingMode(#PB_2DDrawing_Default)
      Box(0, dpiY(GadgetHeight(EditEx()\CanvasNum) - EditEx()\Size\PaddingY), dpiX(GadgetWidth(EditEx()\CanvasNum)), dpiY(EditEx()\Size\PaddingY), EditEx()\Color\Back)
      Box(dpiX(GadgetWidth(EditEx()\CanvasNum) - EditEx()\Size\PaddingX), 0, dpiX(EditEx()\Size\PaddingX), dpiY(GadgetHeight(EditEx()\CanvasNum)), EditEx()\Color\Back)
      If EditEx()\VScroll\Hide = #False
        Box(dpiX(GadgetWidth(EditEx()\CanvasNum)) - dpiX(#Scroll_Width + 1), dpiX(2), dpiX(#Scroll_Width), dpiY(GadgetHeight(EditEx()\CanvasNum)) - dpiY(4), EditEx()\Color\ScrollBar)
      EndIf ;}
      
      ;{ _____ Border _____
      If EditEx()\Flags & #Borderless = #False
        DrawingMode(#PB_2DDrawing_Outlined)
        Box(0, 0, dpiX(GadgetWidth(EditEx()\CanvasNum)), dpiY(GadgetHeight(EditEx()\CanvasNum)), EditEx()\Color\Border)
      EndIf ;}

      StopDrawing()
    EndIf

  EndProcedure
  
  ;- __________ Events __________
  
  Procedure _ListViewHandler()
    Define.i GNum, Selected
    Define.i ListNum.i = EventGadget()
    
    If IsGadget(ListNum)
      
      GNum = GetGadgetData(ListNum)
      If FindMapElement(EditEx(), Str(GNum))
        
        HideWindow(EditEx()\WinNum, #True)
        
        If GetGadgetState(ListNum) <> -1
          EditEx()\Cursor\Pos = EditEx()\Selection\Pos1
          DeleteSelection_()
          EditEx()\Text$ = InsertString(EditEx()\Text$, GetGadgetText(ListNum), EditEx()\Cursor\Pos)
          Draw_()
        EndIf  
        
        EditEx()\Visible\WordList = #False
      EndIf
      
    EndIf
    
  EndProcedure
  
  ;- --- Cursor-Handler ---  
  
  Procedure _CursorDrawing() ; Trigger from Thread (PostEvent Change)
    Define.i WindowNum = EventWindow()
    
    ForEach EditEx()
      
      If EditEx()\Cursor\Pause = #False

        EditEx()\Cursor\State ! #True
      
        If StartDrawing(CanvasOutput(EditEx()\CanvasNum)) 
          DrawingMode(#PB_2DDrawing_Default)
          If EditEx()\Cursor\State
            Line(EditEx()\Cursor\X, EditEx()\Cursor\Y, 1, EditEx()\Cursor\Height, EditEx()\Color\Cursor)
          Else
            If EditEx()\FontID : DrawingFont(EditEx()\FontID) : EndIf
            DrawText(EditEx()\Cursor\X, EditEx()\Cursor\Y, EditEx()\Cursor\BackChar, EditEx()\Cursor\FrontColor, EditEx()\Cursor\BackColor)
          EndIf
          StopDrawing()
        EndIf
        
      ElseIf EditEx()\Cursor\State
        
        If StartDrawing(CanvasOutput(EditEx()\CanvasNum))
          DrawingMode(#PB_2DDrawing_Default)
          Line(EditEx()\Cursor\X, EditEx()\Cursor\Y, 1, EditEx()\Cursor\Height, EditEx()\Color\Back)
          StopDrawing()
        EndIf
      
      EndIf
      
    Next
    
  EndProcedure 
 
  Procedure _CursorThread(Frequency.i)
    Define.i ElapsedTime
    
    Repeat
      
      If ElapsedTime >= Frequency
        PostEvent(#Event_Cursor)
        ElapsedTime = 0
      EndIf
      
      Delay(100)
      
      ElapsedTime + 100
      
    Until Thread\Exit
    
  EndProcedure
  
  Procedure _FocusHandler()
    Define.i GNum = EventGadget()
    
    If FindMapElement(EditEx(), Str(GNum))
      
      EditEx()\Cursor\Pause = #False
      EditEx()\Cursor\State = #False

    EndIf  
 
  EndProcedure
  
  Procedure _LostFocusHandler()
    Define.i GNum = EventGadget()
    
    If FindMapElement(EditEx(), Str(GNum))
      
      EditEx()\Cursor\Pause = #True
      _CursorDrawing()
      
    EndIf
    
  EndProcedure  
  
  ;- --- Key-Handler ---  
  
  Procedure _KeyDownHandler() ; Handle Shortcuts
    Define.i GNum = EventGadget()
    Define.i Key, Modifier, CursorRow, CursorPos, Pos1, Pos2, ReDraw
    Define.s Text$
    
    If FindMapElement(EditEx(), Str(GNum))
      
      Key       = GetGadgetAttribute(GNum, #PB_Canvas_Key)
      Modifier  = GetGadgetAttribute(GNum, #PB_Canvas_Modifiers)
      
      CursorPos = EditEx()\Cursor\Pos
      CursorRow = EditEx()\Cursor\Row
      
      ;{ Selection
      If EditEx()\Selection\Flag = #Selected
        If EditEx()\Selection\Pos1 > EditEx()\Selection\Pos2
          Pos1 = EditEx()\Selection\Pos2
          Pos2 = EditEx()\Selection\Pos1
        Else
          Pos1 = EditEx()\Selection\Pos1
          Pos2 = EditEx()\Selection\Pos2
        EndIf 
      EndIf ;}
      
      Select Key
        Case #PB_Shortcut_Left     ;{ Left
          
          If Modifier & #PB_Canvas_Shift And Modifier & #PB_Canvas_Control ;{ Selection up to the beginning of the word

            EditEx()\Cursor\Pos = WordStart_(EditEx()\Text$, CursorPos)
            
            If EditEx()\Selection\Flag = #NoSelection
              EditEx()\Selection\Pos1 = CursorPos
              EditEx()\Selection\Pos2 = EditEx()\Cursor\Pos
              EditEx()\Selection\Flag = #Selected
            Else
              EditEx()\Selection\Pos2 = EditEx()\Cursor\Pos
            EndIf
            ;}
          ElseIf Modifier & #PB_Canvas_Shift                               ;{ Selection left
            
            If EditEx()\Cursor\Pos > 1
              
              EditEx()\Cursor\Pos - 1 
              
              If EditEx()\Selection\Flag = #NoSelection
                EditEx()\Selection\Pos1 = CursorPos
                EditEx()\Selection\Pos2 = EditEx()\Cursor\Pos
                EditEx()\Selection\Flag = #Selected
              Else
                EditEx()\Selection\Pos2 = EditEx()\Cursor\Pos
              EndIf

            EndIf
            ;}
          ElseIf Modifier & #PB_Canvas_Control                             ;{ Start of word
            
            EditEx()\Cursor\Pos = WordStart_(EditEx()\Text$, CursorPos)
            
            If EditEx()\Selection\Flag = #Selected
              EditEx()\Selection\Pos2 = EditEx()\Cursor\Pos
            EndIf
            ;}
          Else                                                             ;{ Cursor left
            
            If CursorPos > 1
              EditEx()\Cursor\Pos - 1
            EndIf
            
            RemoveSelection_()
            ;}
          EndIf
          
          ReDraw = #True
          ;}
        Case #PB_Shortcut_Right    ;{ Right
          
          If Modifier & #PB_Canvas_Shift And Modifier & #PB_Canvas_Control ;{ Selection up to the end of the word
            
            EditEx()\Cursor\Pos = WordEnd_(EditEx()\Text$, CursorPos)
            
            If EditEx()\Selection\Flag = #NoSelection
              EditEx()\Selection\Pos1 = CursorPos
              EditEx()\Selection\Pos2 = EditEx()\Cursor\Pos
              EditEx()\Selection\Flag = #Selected
            Else
              EditEx()\Selection\Pos2 = EditEx()\Cursor\Pos
            EndIf
            ;}
          ElseIf Modifier & #PB_Canvas_Shift                               ;{ Selection right
            
            If EditEx()\Cursor\Pos < EditEx()\Text\Len
              
              EditEx()\Cursor\Pos + 1 
              
              If EditEx()\Selection\Flag = #NoSelection
                EditEx()\Selection\Pos1 = CursorPos
                EditEx()\Selection\Pos2 = EditEx()\Cursor\Pos
                EditEx()\Selection\Flag = #Selected
              Else
                EditEx()\Selection\Pos2 = EditEx()\Cursor\Pos
              EndIf

            EndIf
            ;}
          ElseIf Modifier & #PB_Canvas_Control                             ;{ End of word
            
            EditEx()\Cursor\Pos = WordEnd_(EditEx()\Text$, CursorPos)
            
            If EditEx()\Selection\Flag = #Selected
              EditEx()\Selection\Pos2 = EditEx()\Cursor\Pos
            EndIf
            ;}
          Else                                                             ;{ Cursor right
            
            If CursorPos <= EditEx()\Text\Len
              EditEx()\Cursor\Pos + 1
            EndIf
            
            RemoveSelection_()
            ;}
          EndIf
          
          ReDraw = #True
          ;}
        Case #PB_Shortcut_Up       ;{ Up
          
          If Modifier & #PB_Canvas_Shift       ;{ Selection up
            
            CursorUpDown_(#Cursor_Up)
            
            If EditEx()\Selection\Flag = #NoSelection
              EditEx()\Selection\Pos1 = CursorPos
              EditEx()\Selection\Pos2 = EditEx()\Cursor\Pos
              EditEx()\Selection\Flag = #Selected
            Else
              EditEx()\Selection\Pos2 = EditEx()\Cursor\Pos
            EndIf
            ;}
          ElseIf Modifier & #PB_Canvas_Control ;{ Previous paragraph
            
            EditEx()\Cursor\Pos = Paragraph_(#Cursor_Up)
            
            RemoveSelection_() 
            ;}
          Else                                 ;{ Cursor  up
            
            CursorUpDown_(#Cursor_Up)
            
            RemoveSelection_()
            ;}
          EndIf
          
          ReDraw = #True
          ;}
        Case #PB_Shortcut_Down     ;{ Down
          
          If Modifier & #PB_Canvas_Shift       ;{ Selection down
            
            CursorUpDown_(#Cursor_Down)
            
            If EditEx()\Selection\Flag = #NoSelection
              EditEx()\Selection\Pos1 = CursorPos
              EditEx()\Selection\Pos2 = EditEx()\Cursor\Pos
              EditEx()\Selection\Flag = #Selected
            Else
              EditEx()\Selection\Pos2 = EditEx()\Cursor\Pos
            EndIf
            ;}
          ElseIf Modifier & #PB_Canvas_Control ;{ Next paragraph
            
            EditEx()\Cursor\Pos = Paragraph_(#Cursor_Down)
            
            RemoveSelection_()
            ;}
          Else                                 ;{ Cursor down

            CursorUpDown_(#Cursor_Down)
            
            RemoveSelection_()
            ;}
          EndIf
          
          ReDraw = #True
          ;}
        Case #PB_Shortcut_PageUp   ;{ PageUp
          
          CursorRow = EditEx()\Cursor\Row - PageRows_() + 1
          If CursorRow < 0 : CursorRow = 0 : EndIf
          
          If SelectElement(EditEx()\Row(), CursorRow)
            EditEx()\Cursor\Pos = EditEx()\Row()\Pos
          EndIf  
          
          RemoveSelection_()
          ReDraw = #True
          ;}
        Case #PB_Shortcut_PageDown ;{ PageDown
          
          CursorRow = EditEx()\Cursor\Row + PageRows_() + 1
          If CursorRow >= ListSize(EditEx()\Row()) : CursorRow = ListSize(EditEx()\Row()) - 1 : EndIf
          
          If SelectElement(EditEx()\Row(), CursorRow)
            EditEx()\Cursor\Pos = EditEx()\Row()\Pos
          EndIf 
          
          RemoveSelection_()
          ReDraw = #True
          ;}
        Case #PB_Shortcut_Home     ;{ Home / Pos1
          
          If Modifier & #PB_Canvas_Control
           
            EditEx()\Cursor\Pos = 1

            RemoveSelection_()
            
          ElseIf Modifier & #PB_Canvas_Shift
            
            If SelectElement(EditEx()\Row(), EditEx()\Cursor\Row)
              EditEx()\Cursor\Pos = EditEx()\Row()\Pos
            EndIf
            
            If EditEx()\Selection\Flag = #NoSelection
              EditEx()\Selection\Pos1 = CursorPos
              EditEx()\Selection\Pos2 = EditEx()\Cursor\Pos
              EditEx()\Selection\Flag = #Selected
            Else
              EditEx()\Selection\Pos2 = EditEx()\Cursor\Pos
            EndIf
            
          Else
            
            If SelectElement(EditEx()\Row(), EditEx()\Cursor\Row)
              EditEx()\Cursor\Pos = EditEx()\Row()\Pos
            EndIf
            
            RemoveSelection_()
          EndIf
          
          ReDraw = #True
          ;}
        Case #PB_Shortcut_End      ;{ End
          
          If Modifier & #PB_Canvas_Control
            
            EditEx()\Cursor\Pos = EditEx()\Text\Len + 1
            
            RemoveSelection_()
            
          ElseIf Modifier & #PB_Canvas_Shift
            
            If SelectElement(EditEx()\Row(), EditEx()\Cursor\Row)
              EditEx()\Cursor\Pos = EditEx()\Row()\Pos + EditEx()\Row()\Len - 1
            EndIf
            
            If EditEx()\Selection\Flag = #NoSelection
              EditEx()\Selection\Pos1 = CursorPos
              EditEx()\Selection\Pos2 = EditEx()\Cursor\Pos
              EditEx()\Selection\Flag = #Selected
            Else
              EditEx()\Selection\Pos2 = EditEx()\Cursor\Pos
            EndIf
            
          Else
            
            If SelectElement(EditEx()\Row(), EditEx()\Cursor\Row)
              EditEx()\Cursor\Pos = EditEx()\Row()\Pos + EditEx()\Row()\Len - 1
            EndIf

            RemoveSelection_()
          EndIf
          
          ReDraw = #True
          ;}
        Case #PB_Shortcut_Return   ;{ Return
          
          If EditEx()\Flags & #ReadOnly = #False
            
            EditEx()\Text$ = InsertString(EditEx()\Text$, #LF$, EditEx()\Cursor\Pos)
            EditEx()\Cursor\Pos + 1
            
            RemoveSelection_()
            
            CompilerIf #Enable_SpellChecking
              
              If EditEx()\Flags & #AutoSpellCheck
                UpdateWordList_()
                SpellChecking_(#True)
              EndIf
              
            CompilerEndIf 
            
            CompilerIf #Enable_UndoRedo
              
              If EditEx()\Flags & #UndoRedo : AddUndo_() : EndIf
              
            CompilerEndIf
            
            ReDraw = #True
          EndIf
          ;}
        Case #PB_Shortcut_Delete   ;{ Delete / Cut (Shift)
          
          If EditEx()\Flags & #ReadOnly = #False
            
            If Modifier & #PB_Canvas_Shift ;{ Cut selected text to clipboard
              
              If EditEx()\Selection\Flag = #Selected
                SetClipboardText(GetSelection_(#False))
                DeleteSelection_(#False)
              EndIf
              ;}
            Else                           ;{ Delete text/character

              If EditEx()\Selection\Flag = #Selected And (CursorPos >= Pos1 And CursorPos <= Pos2)
                DeleteSelection_(#False)
              Else 
                EditEx()\Text$ = DeleteStringPart(EditEx()\Text$, EditEx()\Cursor\Pos)
              EndIf
              ;}
            EndIf
            
            RemoveSelection_()
            
            ReDraw = #True
          EndIf
          ;}
        Case #PB_Shortcut_Back     ;{ Back
          
          If EditEx()\Flags & #ReadOnly = #False
            
            If CursorPos > 1
              
              If EditEx()\Selection\Flag = #Selected And (CursorPos > Pos1 And CursorPos <= Pos2)
                
                DeleteSelection_(#False)
                
              Else
                
                EditEx()\Text$ = DeleteStringPart(EditEx()\Text$, EditEx()\Cursor\Pos - 1)
                
                EditEx()\Cursor\Pos - 1
                If EditEx()\Cursor\Pos < 1 : EditEx()\Cursor\Pos = 1 : EndIf
                
              EndIf
              
            EndIf
            
            RemoveSelection_()
            
            ReDraw = #True
          EndIf
          ;}
        Case #PB_Shortcut_C        ;{ Copy  (Ctrl)
          
          If Modifier & #PB_Canvas_Control
            
            If EditEx()\Selection\Flag = #Selected
              SetClipboardText(GetSelection_())
            EndIf
            
          EndIf
          ;}
        Case #PB_Shortcut_V        ;{ Paste (Ctrl)
          
          If EditEx()\Flags & #ReadOnly = #False
            
            If Modifier & #PB_Canvas_Control
              
              Text$ = GetClipboardText()
              
              If EditEx()\Selection\Flag = #Selected
                DeleteSelection_(#False)
              EndIf
              
              EditEx()\Text$ = InsertString(EditEx()\Text$, Text$, EditEx()\Cursor\Pos)
              EditEx()\Cursor\Pos + Len(Text$)
              
              CompilerIf #Enable_UndoRedo
                
                If EditEx()\Flags & #UndoRedo : AddUndo_() : EndIf
                
              CompilerEndIf
              
              ReDraw = #True
            EndIf
            
          EndIf
          ;}
        Case #PB_Shortcut_X        ;{ Cut   (Ctrl)
          
          If EditEx()\Flags & #ReadOnly = #False
            
            If Modifier & #PB_Canvas_Control
              
              If EditEx()\Selection\Flag = #Selected

                SetClipboardText(GetSelection_(#False))
                DeleteSelection_(#False)
                
                CompilerIf #Enable_UndoRedo
                  
                  If EditEx()\Flags & #UndoRedo : AddUndo_() : EndIf
                  
                CompilerEndIf
                
              EndIf
              
              RemoveSelection_()
              
              ReDraw = #True
            EndIf 
            
          EndIf
          ;}
        Case #PB_Shortcut_Insert   ;{ Copy  (Ctrl) / Paste (Shift)
          
          If EditEx()\Flags & #ReadOnly = #False
            
            If Modifier & #PB_Canvas_Shift
              
              Text$ = GetClipboardText()
              
              If EditEx()\Selection\Flag = #Selected
                DeleteSelection_(#False)
              EndIf
              
              EditEx()\Text$ = InsertString(EditEx()\Text$, Text$, EditEx()\Cursor\Pos + 1)
              EditEx()\Cursor\Pos + Len(Text$)
              
              CompilerIf #Enable_UndoRedo
                
                If EditEx()\Flags & #UndoRedo : AddUndo_() : EndIf
                
              CompilerEndIf
              
            ElseIf Modifier & #PB_Canvas_Control
              
              If EditEx()\Selection\Flag = #Selected
                
                Text$ = GetSelection_()
                
                SetClipboardText(Text$)
                
              EndIf
              
            EndIf
            
            ReDraw = #True
          EndIf 
          ;}
        Case #PB_Shortcut_Hyphen   ;{ Minus (Ctrl)   
          
          If Modifier & #PB_Canvas_Control
            
            EditEx()\Text$ = InsertString(EditEx()\Text$, #SoftHyphen$, EditEx()\Cursor\Pos)
            EditEx()\Cursor\Pos + 1
            
            ReDraw = #True
          EndIf
          ;}
        Case #PB_Shortcut_A        ;{ Ctrl-A (Select all)
          
          If Modifier & #PB_Canvas_Control
            
            EditEx()\Cursor\Pos     = EditEx()\Text\Len + 1
            EditEx()\Selection\Flag = #Selected
            EditEx()\Selection\Pos1 = 1
            EditEx()\Selection\Pos2 = EditEx()\Text\Len + 1
            
            ReDraw = #True
          EndIf
          ;}
        Case #PB_Shortcut_Z        ;{ Crtl-Z (Undo)
          
          CompilerIf #Enable_UndoRedo
            
            If Modifier & #PB_Canvas_Control
              
              If EditEx()\Flags & #UndoRedo
                Undo_()
                ReDraw = #True
              EndIf
              
            EndIf 

          CompilerEndIf
          ;}
        Case #PB_Shortcut_D        ;{ Ctrl-D (Delete selection)
          
          If Modifier & #PB_Canvas_Control
            DeleteSelection_()
            EditEx()\Cursor\Pos = Pos1
            ReDraw = #True
          EndIf
          ;}
      EndSelect
      
      If ReDraw
        UpdateScrollBar_()
        Draw_()
        AdjustScrolls_()
      EndIf
      
    EndIf
    
  EndProcedure
  
  Procedure _InputHandler()   ; Input character
    Define.i GNum = EventGadget()
    Define.i Char, SpellCheck
    
    If EditEx()\Flags & #ReadOnly = #False
      
      If FindMapElement(EditEx(), Str(GNum))

        Char = GetGadgetAttribute(GNum, #PB_Canvas_Input)
        
        DeleteSelection_(#False)
        
        EditEx()\Text$ = InsertString(EditEx()\Text$, Chr(Char), EditEx()\Cursor\Pos)
        EditEx()\Cursor\Pos + 1

        RemoveSelection_()
        
        CompilerIf #Enable_UndoRedo
          
          If EditEx()\Flags & #UndoRedo
            Select Char
              Case 32, 33, 58, 59, 63
                AddUndo_()
            EndSelect
          EndIf
          
        CompilerEndIf
        
        CompilerIf #Enable_SpellChecking
          
          If EditEx()\Flags & #AutoSpellCheck
            
            Select Char
              Case 32, 33, 41, 44, 46
                SpellCheck = #True
              Case 58, 59, 63, 93, 125
                SpellCheck = #True
            EndSelect
            
            If SpellCheck 
              UpdateWordList_()
              SpellChecking_(#True)
            EndIf
            
          EndIf
          
        CompilerEndIf
        
        Draw_()
        
      EndIf
      
    EndIf
    
  EndProcedure 
  
  ;- --- Mouse-Handler ---
  
  Procedure _RightClickHandler()
    Define.i GNum = EventGadget()
    Define.i X, Y, CursorPos, sWord, eWord
    Define.s Word$
    
    If FindMapElement(EditEx(), Str(GNum))

      X = GetGadgetAttribute(GNum, #PB_Canvas_MouseX)
      Y = GetGadgetAttribute(GNum, #PB_Canvas_MouseY)
      
      CompilerIf #Enable_SpellChecking
        
        If EditEx()\Visible\WordList = #True
          HideWindow(EditEx()\WinNum, #True)
          EditEx()\Visible\WordList = #False
        EndIf 
        
        If EditEx()\Flags & #Suggestions
          
          CursorPos = CursorPos_(X, Y, #False)
          If CursorPos
            
            sWord = WordStart_(EditEx()\Text$, CursorPos)
            eWord = WordEnd_(EditEx()\Text$ , CursorPos)
            Word$ = StringSegment(EditEx()\Text$, sWord, eWord)
            
            ForEach EditEx()\Mistake()
              
              If Word$ = EditEx()\Mistake()
                
                EditEx()\Selection\Pos1 = sWord
                EditEx()\Selection\Pos2 = eWord
                EditEx()\Selection\Flag = #Selected
                Draw_()
                
                If CorrectionSuggestions_(Word$)
                  ResizeList_(sWord)
                  ClearGadgetItems(EditEx()\ListNum)
                  ForEach EditEx()\Suggestions()
                    AddGadgetItem(EditEx()\ListNum, -1, EditEx()\Suggestions())
                  Next  
                  EditEx()\Visible\WordList = #True
                  HideWindow(EditEx()\WinNum, #False)
                EndIf
                
                ProcedureReturn #True
              EndIf   
            Next
            
          EndIf
          
        EndIf
        
      CompilerEndIf
      
      If IsMenu(EditEx()\PopupMenu) 
        If IsTextArea_(X, Y)
          DisplayPopupMenu(EditEx()\PopupMenu, WindowID(EditEx()\Window\Num))
        EndIf
      EndIf
      
    EndIf
    
  EndProcedure
  
  CompilerIf #Enable_SpellChecking
  
    Procedure _RightDoubleClickHandler()
      Define.i GNum = EventGadget()
      Define.i X, Y, CursorPos, sWord, eWord
      Define.s Word$
      
      If FindMapElement(EditEx(), Str(GNum))
      
        X = GetGadgetAttribute(GNum, #PB_Canvas_MouseX)
        Y = GetGadgetAttribute(GNum, #PB_Canvas_MouseY)
        
        CursorPos = CursorPos_(X, Y)
        If CursorPos
         
          sWord = WordStart_(EditEx()\Text$, CursorPos)
          eWord = WordEnd_(EditEx()\Text$ , CursorPos)
          Word$ = StringSegment(EditEx()\Text$, sWord, eWord)
          
          If Words(Word$)\checked = #False
            If SpellCheck(Word$) = #False
              Words(Word$)\misspelled = #True
            EndIf
            Words(Word$)\checked = #True
          EndIf
          
          If Words(Word$)\misspelled = #True
            
            If EditEx()\Flags & #Suggestions : EditEx()\Mistake(Word$) = Word$ : EndIf 
            
            EditEx()\Syntax(Word$) = EditEx()\Color\SyntaxHighlight
          Else
            EditEx()\Syntax(Word$) = $008000
          EndIf
          
          Draw_()
        EndIf
        
      EndIf
      
    EndProcedure
    
  CompilerEndIf

  Procedure _LeftButtonDownHandler()
    Define.i GNum = EventGadget()
    Define.i CursorX, CursorY, CursorPos
    
    If FindMapElement(EditEx(), Str(GNum))
      
      CursorX   = GetGadgetAttribute(GNum, #PB_Canvas_MouseX)
      CursorY   = GetGadgetAttribute(GNum, #PB_Canvas_MouseY)
      
      CompilerIf #Enable_SpellChecking
        If EditEx()\Visible\WordList = #True
          HideWindow(EditEx()\WinNum, #True)
          EditEx()\Visible\WordList = #False
        EndIf  
      CompilerEndIf
      
      CursorPos = CursorPos_(CursorX, CursorY)
      If CursorPos
        EditEx()\Cursor\LastX = EditEx()\Cursor\X ; last cursor position for cursor up/down
        RemoveSelection_()
        Draw_()
      EndIf
    
      CompilerIf #Enable_UndoRedo
        
        If EditEx()\Flags & #UndoRedo : ChangeUndoCursor_() : EndIf 
        
      CompilerEndIf

    EndIf
    
  EndProcedure
  
  Procedure _LeftButtonUpHandler()
    Define.i GNum = EventGadget()
    Define.i CursorPos, CursorX, CursorY
    
    If FindMapElement(EditEx(), Str(GNum))

      CursorX   = GetGadgetAttribute(GNum, #PB_Canvas_MouseX)
      CursorY   = GetGadgetAttribute(GNum, #PB_Canvas_MouseY)
      
      If EditEx()\Mouse\Status = #Mouse_Select
        
        CursorPos = CursorPos_(CursorX, CursorY)
        If CursorPos
          EditEx()\Selection\Pos2 = CursorPos
          EditEx()\Cursor\LastX   = EditEx()\Cursor\X ; last cursor position for cursor up/down
          Draw_()
        EndIf
        
        EditEx()\Mouse\Status = #Mouse_Move
      EndIf
      
    EndIf
    
  EndProcedure  
  
  Procedure _LeftDoubleClickHandler()
    Define.i GNum = EventGadget()
    Define.i CursorX, CursorY, CursorPos
    Define.s Text$
    
    If FindMapElement(EditEx(), Str(GNum))
      
      CursorX   = GetGadgetAttribute(GNum, #PB_Canvas_MouseX)
      CursorY   = GetGadgetAttribute(GNum, #PB_Canvas_MouseY)

      CursorPos = CursorPos_(CursorX, CursorY)
      
      CompilerIf #Enable_SpellChecking
        If EditEx()\Visible\WordList = #True
          HideWindow(EditEx()\WinNum, #True)
          EditEx()\Visible\WordList = #False
        EndIf 
      CompilerEndIf
      
      If Mid(EditEx()\Text$, CursorPos, 1) = " "
        
        EditEx()\Selection\Pos1 = SpaceStart_(EditEx()\Text$, CursorPos)
        EditEx()\Selection\Pos2 = SpaceEnd_(EditEx()\Text$,   CursorPos)
        
      Else
        
        EditEx()\Selection\Pos1 = WordStart_(EditEx()\Text$, CursorPos)
        EditEx()\Selection\Pos2 = WordEnd_(EditEx()\Text$,   CursorPos)
        
      EndIf  
      
      If EditEx()\Selection\Pos1 <> EditEx()\Selection\Pos2
        
        EditEx()\Selection\Flag = #Selected
        EditEx()\Cursor\Pos     = EditEx()\Selection\Pos2
        
        Draw_()
      EndIf
      
    EndIf
    
  EndProcedure
  
  Procedure _MouseMoveHandler()
    Define.i GNum = EventGadget()
    Define.i CursorPos, NewPos, CursorX, CursorY
    
    If FindMapElement(EditEx(), Str(GNum))
      
      CursorX   = GetGadgetAttribute(GNum, #PB_Canvas_MouseX)
      CursorY   = GetGadgetAttribute(GNum, #PB_Canvas_MouseY)
      CursorPos = EditEx()\Cursor\Pos

      If GetGadgetAttribute(GNum, #PB_Canvas_Buttons) = #PB_Canvas_LeftButton ;{ Left Mouse Button
        
        Select EditEx()\Mouse\Status
          Case #Mouse_Move   ;{ Start Selection
            
            If EditEx()\Selection\Flag = #NoSelection
              
              NewPos = CursorPos_(CursorX, CursorY)
              If NewPos 

                If CursorPos <> EditEx()\Cursor\Pos
                  
                  EditEx()\Selection\Pos1 = CursorPos
                  EditEx()\Selection\Pos2 = EditEx()\Cursor\Pos
                  EditEx()\Selection\Flag = #Selected
                  EditEx()\Mouse\Status   = #Mouse_Select
                  
                  Draw_()
                EndIf
                
              EndIf
              
            EndIf  
            ;}
          Case #Mouse_Select ;{ Continue Selection
            
            If EditEx()\Selection\Flag = #Selected
              
              NewPos = CursorPos_(CursorX, CursorY)
              If NewPos 
                
                EditEx()\Cursor\Pos = NewPos
                
                If CursorPos <> EditEx()\Cursor\Pos
                  EditEx()\Selection\Pos2 = EditEx()\Cursor\Pos
                  Draw_()
                EndIf
                
              EndIf
              
            EndIf  
            ;}
        EndSelect
        ;}
      Else
        EditEx()\Mouse\Status = #Mouse_Move 
      EndIf
      
      ChangeMouseCursor_(GNum, CursorX, CursorY)
      
    EndIf  
  
  EndProcedure
  
  Procedure _MouseWheelHandler()
    Define.i GNum = EventGadget()
    Define.i Delta, ScrollPos
    
    If FindMapElement(EditEx(), Str(GNum))

      Delta = GetGadgetAttribute(GNum, #PB_Canvas_WheelDelta)
      
      If IsGadget(EditEx()\VScroll\ID)
        
        ScrollPos = GetGadgetState(EditEx()\VScroll\ID) - Delta
        
        If ScrollPos > EditEx()\VScroll\MaxPos : ScrollPos = EditEx()\VScroll\MaxPos : EndIf
        If ScrollPos < EditEx()\VScroll\MinPos : ScrollPos = EditEx()\VScroll\MinPos : EndIf
        
        If ScrollPos <> EditEx()\VScroll\Position
          EditEx()\Visible\RowOffset = ScrollPos
          SetVScrollPosition_()
          Draw_()
        EndIf
      
      EndIf

    EndIf
    
  EndProcedure
  
  ;- --- Scrollbar ---
  
  Procedure _SynchronizeScrollPos()
    Define.i ScrollID = EventGadget()
    Define.i GNum = GetGadgetData(ScrollID)
    Define.i ScrollPos, OffSet
    
    If FindMapElement(EditEx(), Str(GNum))
      
      ScrollPos = GetGadgetState(ScrollID)
      If ScrollPos <> EditEx()\HScroll\Position
        
        If ScrollPos < EditEx()\Visible\PosOffset
          EditEx()\Visible\PosOffset = ScrollPos - 30
        ElseIf ScrollPos > EditEx()\Visible\PosOffset
          EditEx()\Visible\PosOffset = ScrollPos + 30
        EndIf
        ;Debug "ScrollPos1: " + Str(EditEx()\Visible\PosOffset)
        If EditEx()\Visible\PosOffset < EditEx()\HScroll\MinPos : EditEx()\Visible\PosOffset = EditEx()\HScroll\MinPos : EndIf
        If EditEx()\Visible\PosOffset > EditEx()\HScroll\MaxPos : EditEx()\Visible\PosOffset = EditEx()\HScroll\MaxPos : EndIf
        ;Debug "ScrollPos2: " + Str(EditEx()\HScroll\MaxPos)
        SetGadgetState(ScrollID, EditEx()\Visible\PosOffset)
        
        SetHScrollPosition_()
        
        Draw_()
      EndIf
      
    EndIf
    
  EndProcedure
 
  Procedure _SynchronizeScrollRows()
    Define.i ScrollID = EventGadget()
    Define.i GNum = GetGadgetData(ScrollID)
    Define   ScrollPos.i, OffSet.i, Calc.f
    
    If FindMapElement(EditEx(), Str(GNum))
      
      ScrollPos = GetGadgetState(ScrollID)
      If ScrollPos <> EditEx()\VScroll\Position
        EditEx()\Visible\RowOffset = ScrollPos
        SetVScrollPosition_()
        Draw_()
      EndIf
      
    EndIf
    
  EndProcedure 
  
  ;- --- Resize Gadget ---
  
  Procedure _ResizeHandler()
    Define.i GNum = EventGadget()
    
    If FindMapElement(EditEx(), Str(GNum))
      
      AdjustScrolls_(#False)
      
      If Not EditEx()\VScroll\Hide And Not EditEx()\HScroll\Hide
        If IsGadget(EditEx()\HScroll\ID) And IsGadget(EditEx()\VScroll\ID)
          ResizeGadget(EditEx()\HScroll\ID, 1, GadgetHeight(EditEx()\CanvasNum) - #Scroll_Width - 1,  GadgetWidth(EditEx()\CanvasNum) - #Scroll_Width - 2, #Scroll_Width)
          ResizeGadget(EditEx()\VScroll\ID, GadgetWidth(EditEx()\CanvasNum) - #Scroll_Width - 1, 1, #Scroll_Width, GadgetHeight(EditEx()\CanvasNum) - #Scroll_Width - 2)
        EndIf  
      ElseIf Not EditEx()\VScroll\Hide 
        If IsGadget(EditEx()\VScroll\ID)
          ResizeGadget(EditEx()\VScroll\ID, GadgetWidth(EditEx()\CanvasNum) - #Scroll_Width - 1, 1, #Scroll_Width, GadgetHeight(EditEx()\CanvasNum) - 2)
        EndIf  
      ElseIf Not EditEx()\HScroll\Hide
        If IsGadget(EditEx()\HScroll\ID)
          ResizeGadget(EditEx()\HScroll\ID, 1, GadgetHeight(EditEx()\CanvasNum) - #Scroll_Width - 1, GadgetWidth(EditEx()\CanvasNum) - 2, #Scroll_Width)
        EndIf 
      EndIf
      
      Draw_()
      
      AdjustScrolls_()
      
    EndIf
    
  EndProcedure
  
  Procedure _ResizeWindowHandler()
    Define.f X, Y, Width, Height
    Define.i  OffSetX, OffsetY

    ForEach EditEx()
      
      If IsGadget(EditEx()\CanvasNum)
        
        If EditEx()\Flags & #AutoResize
          
          If IsWindow(EditEx()\Window\Num)
            
            OffSetX = WindowWidth(EditEx()\Window\Num)  - EditEx()\Window\Width
            OffsetY = WindowHeight(EditEx()\Window\Num) - EditEx()\Window\Height
            
            If EditEx()\Size\Flags
              
              X = #PB_Ignore : Y = #PB_Ignore : Width  = #PB_Ignore : Height = #PB_Ignore
              
              If EditEx()\Size\Flags & #MoveX : X = EditEx()\Size\X + OffSetX : EndIf
              If EditEx()\Size\Flags & #MoveY : Y = EditEx()\Size\Y + OffSetY : EndIf
              If EditEx()\Size\Flags & #Width  : Width  = EditEx()\Size\Width  + OffSetX : EndIf
              If EditEx()\Size\Flags & #Height : Height = EditEx()\Size\Height + OffSetY : EndIf

              ResizeGadget(EditEx()\CanvasNum, X, Y, Width, Height)
              
            Else

              ResizeGadget(EditEx()\CanvasNum, #PB_Ignore, #PB_Ignore, EditEx()\Size\Width + OffSetX,  EditEx()\Size\Height + OffSetY)
              
            EndIf

          EndIf
          
        EndIf
        
      EndIf
      
    Next
    
  EndProcedure  
  
  
  Procedure _CloseWindowHandler()
    Define.i Window = EventWindow()
    
    ForEach EditEx()
    
      If EditEx()\Window\Num = Window
        
        CompilerIf Defined(ModuleEx, #PB_Module) = #False
          If MapSize(EditEx()) = 1
            Thread\Exit = #True
            Delay(100)
            If IsThread(Thread\Num) : KillThread(Thread\Num) : EndIf
            Thread\Active = #False
          EndIf
        CompilerEndIf
        
        If IsWindow(EditEx()\WinNum) : CloseWindow(EditEx()\WinNum) : EndIf
        
        DeleteMapElement(EditEx())
        
      EndIf
      
    Next
    
  EndProcedure
  
  
  ;- ==========================================================================
  ;-   Module - Declared Procedures
  ;- ========================================================================== 

  ;- ===== Spell Checking =====
  
  CompilerIf #Enable_SpellChecking
    
    Procedure LoadDictionary(DicFile.s, AddDicFile.s="")
      Define.i FileID
      Define.s Word$, Path$
      
      ClearList(Dictionary())
      
      Path\Dictionary = GetPathPart(DicFile)
      
      FileID = ReadFile(#PB_Any, DicFile)
      If FileID
        While Eof(FileID) = #False
          Word$ = ReadString(FileID)
          AddElement(Dictionary())
          Dictionary()\Stem = StringField(Word$, 1, Chr(127))
          If CountString(Word$, Chr(127)) = 2
            Dictionary()\Endings = StringField(Word$, 2, Chr(127))
            Dictionary()\Flag    = Val(StringField(Word$, 3, Chr(127)))
          Else
            Dictionary()\Endings = ""
            Dictionary()\Flag    = Val(StringField(Word$, 3, Chr(127)))
          EndIf
        Wend
        CloseFile(FileID)
      EndIf
      
      If AddDicFile
        
        FileID = ReadFile(#PB_Any, AddDicFile)
        If FileID
          While Eof(FileID) = #False
            Word$ = ReadString(FileID)
            AddElement(Dictionary())
            Dictionary()\Stem = StringField(Word$, 1, Chr(127))
            If CountString(Word$, Chr(127)) = 2
              Dictionary()\Endings = StringField(Word$, 2, Chr(127))
              Dictionary()\Flag    = Val(StringField(Word$, 3, Chr(127)))
            Else
              Dictionary()\Endings = ""
              Dictionary()\Flag    = Val(StringField(Word$, 3, Chr(127)))
            EndIf
          Wend
          CloseFile(FileID)
        EndIf
      EndIf
      
      ;{ Dictionary is required
      If ListSize(Dictionary()) = 0
        Debug "ERROR: No dictionary found"
        ProcedureReturn #False
      EndIf ;}
      
      ClearList(UserDic())
      
      FileID = ReadFile(#PB_Any, Path\Dictionary + "user.dic")
      If FileID
        
        While Eof(FileID) = #False
          Word$ = ReadString(FileID)
          AddElement(UserDic())
          UserDic()\Stem = StringField(Word$, 1, Chr(127))
          If CountString(Word$, Chr(127)) = 2
            UserDic()\Endings = StringField(Word$, 2, Chr(127))
            UserDic()\Flag    = Val(StringField(Word$, 3, Chr(127)))
          Else
            UserDic()\Endings = ""
            UserDic()\Flag    = Val(StringField(Word$, 3, Chr(127)))
          EndIf
        Wend
        
        MergeLists(UserDic(), Dictionary())
        
        CloseFile(FileID)
      EndIf
      
      SortStructuredList(Dictionary(), #PB_Sort_Ascending, OffsetOf(Dictionary_Structure\Stem), TypeOf(Dictionary_Structure\Stem))  
      
    EndProcedure
    
    Procedure FreeDictionary()
      ClearList(Dictionary())
    EndProcedure
    
    Procedure EnableAutoSpellCheck(GNum.i, State.i=#True, Flag.i=#False)
      
      ;{ Syntax highlighting is required
      If #Enable_SyntaxHighlight = #False
        Debug "ERROR: Syntax highlighting is required => #Enable_SyntaxHighlight = #True"
        ProcedureReturn #False
      EndIf ;}
      
      ;{ Dictionary is required
      If ListSize(Dictionary()) = 0
        Debug "ERROR: Dictionary is required => LoadDictionary()"
        ProcedureReturn #False
      EndIf ;}
      
      If FindMapElement(EditEx(), Str(GNum))
        
        EditEx()\SyntaxHighlight = #CaseSensitiv
        
        If State
          EditEx()\Flags | #AutoSpellCheck
          EditEx()\Flags | #SyntaxHighlight
          If Flag = #Suggestions : EditEx()\Flags | #Suggestions : EndIf 
        Else
          EditEx()\Flags & ~#AutoSpellCheck
          EditEx()\Flags & ~#SyntaxHighlight
          EditEx()\Flags & ~#Suggestions
        EndIf   
        
      EndIf
      
      
    EndProcedure
    
    Procedure SpellCheck(Word.s)
      ProcedureReturn SpellCheck_(Word)
    EndProcedure
    
    Procedure SpellChecking(GNum.i, Flag.i=#Highlight)
      
      ;{ Syntax highlighting is required
      If #Enable_SyntaxHighlight = #False
        Debug "ERROR: Syntax highlighting is required => #Enable_SyntaxHighlight = #True"
        ProcedureReturn #False
      EndIf ;}
      
      ;{ Dictionary is required
      If ListSize(Dictionary()) = 0
        Debug "ERROR: Dictionary is required => LoadDictionary()"
        ProcedureReturn #False
      EndIf ;}
      
      If FindMapElement(EditEx(), Str(GNum))
        
        EditEx()\SyntaxHighlight = #CaseSensitiv
        
        UpdateWordList_()
        
        If Flag & #Highlight
          SpellChecking_(#True)
        Else
          SpellChecking_(#False)
        EndIf
        
        If Flag & #WrongWords
          ClearList(WrongWords())
          ForEach Words()
            If Words()\misspelled = #True
              If AddElement(WrongWords())
                WrongWords() = MapKey(Words())
              EndIf  
              DeleteMapElement(Words())
            EndIf
          Next
        EndIf

        If Flag & #Highlight : Draw_() : EndIf
        
      EndIf
      
    EndProcedure
    
    Procedure SaveUserDictionary()
      Define.i FileID
      Define.s File$, Word$
      
      File$ = Path\Dictionary + "user.dic"
      
      If ListSize(UserDic()) = 0 : ProcedureReturn #False : EndIf
      
      FileID = CreateFile(#PB_Any, File$)
      If FileID
        
        SortStructuredList(UserDic(), #PB_Sort_Ascending, OffsetOf(Dictionary_Structure\Stem), TypeOf(Dictionary_Structure\Stem))
        
        ForEach UserDic()
          Word$ = UserDic()\Stem + Chr(127) + UserDic()\Endings + Chr(127) + UserDic()\Flag
          WriteStringN(FileID, Word$, #PB_UTF8)
        Next
        
        CloseFile(FileID)
      EndIf
      
    EndProcedure
    
    Procedure AddToUserDictionary(GNum.i, Word.s)
      
      If FindMapElement(EditEx(), Str(GNum))
        
        If SpellCheck(Word) = #False
          
          DeleteMapElement(EditEx()\Syntax(), Word)
          Words(Word)\misspelled = #False
  
          If AddElement(UserDic())
            UserDic()\Stem    = LCase(Word)
            UserDic()\Endings = ""
            If Left(Word, 1)  = UCase(Left(Word, 1))
              UserDic()\Flag  = #True
            Else
              UserDic()\Flag  = #False
            EndIf
          EndIf
          
          If AddElement(Dictionary())
            Dictionary()\Stem    = LCase(Word)
            Dictionary()\Endings = ""
            If Left(Word, 1) = UCase(Left(Word, 1))
              Dictionary()\Flag  = #True
            Else
              Dictionary()\Flag  = #False
            EndIf
          EndIf
          
          SortStructuredList(Dictionary(), #PB_Sort_Ascending, OffsetOf(Dictionary_Structure\Stem), TypeOf(Dictionary_Structure\Stem))
          
          If EditEx()\Flags & #AutoSpellCheck
            UpdateWordList_()
            SpellChecking_(#True)
            Draw_()
          EndIf
  
        EndIf
        
      EndIf
      
    EndProcedure
    
    Procedure ClearCheckedWords()
      
      ClearMap(Words())
      
    EndProcedure

    Procedure CorrectionSuggestions(GNum.i, Word.s, List Suggestions.s())
      
      If FindMapElement(EditEx(), Str(GNum))
        
        If CorrectionSuggestions_(Word)
          CopyList(EditEx()\Suggestions(), Suggestions())
        EndIf
        
      EndIf
      
    EndProcedure
   
  CompilerEndIf  
  
  ;- ===== Hyphenation =====
  
  CompilerIf #Enable_Hyphenation
  
    Procedure   LoadHyphenationPattern(File.s=#PAT_Deutsch) ; [ ALL gadgets ]
      Define.i FileID
      Define.s Pattern 
      
      Path\Pattern = GetPathPart(File)
      
      ClearList(HyphPattern())
      
      FileID = ReadFile(#PB_Any, File)
      If FileID
        While Eof(FileID) = #False
          Pattern = Trim(ReadString(FileID, #PB_UTF8))
          AddElement(HyphPattern())
          HyphPattern()\chars   = StringField(Pattern, 1, ":")
          HyphPattern()\pattern = StringField(Pattern, 2, ":")
        Wend 
        CloseFile(FileID)
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
      
    EndProcedure

  CompilerEndIf
  
  ;- ===== Syntax Highlighting =====
  
  CompilerIf #Enable_SyntaxHighlight
    
    Procedure EnableSyntaxHighlight(GNum.i, State.i=#True, Flag.i=#CaseSensitiv) ; #False/#CaseSensitiv/#NoCase
      
      If FindMapElement(EditEx(), Str(GNum))
        
        If State
          EditEx()\Flags | #SyntaxHighlight
          EditEx()\SyntaxHighlight = Flag
        Else
          EditEx()\Flags & ~#SyntaxHighlight
          EditEx()\SyntaxHighlight = #False
        EndIf
        
        Draw_()
        
      EndIf
      
    EndProcedure
  
    Procedure AddWord(GNum.i, Word.s, Color.i=#False)
      
      If FindMapElement(EditEx(), Str(GNum))
        
        EditEx()\Syntax(Word)  = Color
        
      EndIf
    
  EndProcedure
  
    Procedure DeleteWord(GNum.i, Word.s)
      
      If FindMapElement(EditEx(), Str(GNum))
        
        DeleteMapElement(EditEx()\Syntax(), Word) 
  
      EndIf  
   
    EndProcedure
  
    Procedure ClearWords(GNum.i)
      
      If FindMapElement(EditEx(), Str(GNum))
        
        ClearMap(EditEx()\Syntax())
        
      EndIf
      
    EndProcedure
    
  CompilerEndIf
  
  ;- ===== Undo / Redo =====
  
  CompilerIf #Enable_UndoRedo

    Procedure EnableUndoRedo(GNum.i, State.i=#True, MaxSteps.i=#False) ; #True / #False
      
      If FindMapElement(EditEx(), Str(GNum))
        
        If State
          EditEx()\Flags | #UndoRedo
        Else
          EditEx()\Flags & ~#UndoRedo
        EndIf
        
        EditEx()\Undo\MaxSteps = MaxSteps
        
      EndIf
      
    EndProcedure  
    
    Procedure Undo(GNum.i)
      Define r.i, Text$, CurrentText$
      
      If FindMapElement(EditEx(), Str(GNum))
        
        If EditEx()\Flags & #UndoRedo
          
          Undo_()
          Draw_()
          AdjustScrolls_()
          
        EndIf
        
      EndIf
      
    EndProcedure
    
    Procedure Redo(GNum.i)
      Define Text$
      
      If FindMapElement(EditEx(), Str(GNum))
        
        If EditEx()\Flags & #UndoRedo
          
          Text$ = GetLastRedo_()
          If Text$
  
            ClearRedo_()
            
            EditEx()\Text$ = Text$
            EditEx()\Cursor\Pos = EditEx()\Undo\CursorPos

            Draw_()
            AdjustScrolls_()
            
          EndIf
          
        EndIf
        
      EndIf
      
    EndProcedure
    
    Procedure IsUndo(GNum.i)
      
      If FindMapElement(EditEx(), Str(GNum))
        
        If ListSize(EditEx()\Undo\Item())
          ProcedureReturn #True
        EndIf
        
      EndIf
      
      ProcedureReturn #False
    EndProcedure
    
    Procedure IsRedo(GNum.i)
      
      If FindMapElement(EditEx(), Str(GNum))
        
        If EditEx()\Undo\Redo\Text
          ProcedureReturn #True
        EndIf
        
        ProcedureReturn #False
      EndIf
      
    EndProcedure
    
    Procedure ClearUndo(GNum.i)  
      
      If FindMapElement(EditEx(), Str(GNum))
        ClearList(EditEx()\Undo\Item())
        ClearRedo_()
      EndIf
      
    EndProcedure
    
  CompilerEndIf
  
  ;- ===== Selection / Cursor =====
  
  Procedure.i IsSelected(GNum.i)                         ; Returns whether a selection exists
    
    If FindMapElement(EditEx(), Str(GNum))
      If EditEx()\Selection\Flag = #Selected
        ProcedureReturn #True
      EndIf
    EndIf
    
    ProcedureReturn #False
  EndProcedure
  
  Procedure   DeleteSelection(GNum.i, Remove.i=#True)    ; Delete selected text (Remove selection: #True/#False)
    Define row.i, CurrentRow, Text.s
    
    If EditEx()\Flags & #ReadOnly = #False
      
      If FindMapElement(EditEx(), Str(GNum))
        
        If DeleteSelection_(Remove)
          Draw_()
        EndIf
      
      EndIf
      
    EndIf
    
  EndProcedure
  
  Procedure.s GetSelection(GNum.i, Remove.i=#True)       ; Return selected text (Remove selection: #True/#False)
    Define row.i, Text.s
    
    If FindMapElement(EditEx(), Str(GNum))
      
      Text = GetSelection_(Remove)      
      If Remove : Draw_() : EndIf
      
      ProcedureReturn Text
    EndIf
  
  EndProcedure
  
  Procedure   InsertText(GNum.i, Text.s)                 ; Insert text at cursor position (or replace selection)
    
    If EditEx()\Flags & #ReadOnly = #False
      
      If FindMapElement(EditEx(), Str(GNum))
        
        If EditEx()\Selection\Flag = #Selected
          DeleteSelection_()
        EndIf
        
        EditEx()\Text$ = InsertString(EditEx()\Text$, Text, EditEx()\Cursor\Pos + 1)
        EditEx()\Cursor\Pos + Len(Text)

        Draw_()
        AdjustScrolls_()
        
      EndIf
      
    EndIf
    
  EndProcedure

  ;- ===== Clipboard =====
  
  Procedure  Copy(GNum.i)
    Define.s Text$
    
    If FindMapElement(EditEx(), Str(GNum))
      
      If EditEx()\Selection\Flag = #Selected
        
        Text$ = GetSelection_()
        If Text$
          Text$ = ReplaceString(Text$, #LF$, #NL$)
          SetClipboardText(Text$)
        EndIf
        
      EndIf
      
    EndIf

  EndProcedure
  
  Procedure  Cut(GNum.i)
    Define.s Text$
    
    If FindMapElement(EditEx(), Str(GNum))
      
      If EditEx()\Selection\Flag = #Selected
        
        Text$ = GetSelection_(#False)
        If Text$
          Text$ = ReplaceString(Text$, #LF$, #NL$)
          SetClipboardText(Text$)
          DeleteSelection_()
        EndIf

        AdjustScrolls_()
        Draw_()
        
      EndIf
      
    EndIf 
    
  EndProcedure
  
  Procedure  Paste(GNum.i)
    Define.s Text
    
    If FindMapElement(EditEx(), Str(GNum))
      
      If EditEx()\Flags & #ReadOnly = #False
        
        Text = ReplaceString(GetClipboardText(), #NL$, #LF$)

        If EditEx()\Selection\Flag = #Selected
          DeleteSelection_()
        EndIf
        
        EditEx()\Text$ = InsertString(EditEx()\Text$, Text, EditEx()\Cursor\Pos + 1)
        EditEx()\Cursor\Pos + Len(Text)
        
        CompilerIf #Enable_SpellChecking

          If EditEx()\Flags & #AutoSpellCheck
            UpdateWordList_()
            SpellChecking_(#True)
          EndIf 
          
        CompilerEndIf

        Draw_()
        AdjustScrolls_()
        
      EndIf
      
    EndIf
    
  EndProcedure
  
  ;- =====================

  Procedure   AddItem(GNum.i, Position.i, Text.s)        ; Add text row at 'Position' (or #FirstRow / #LastRow)
    
    If FindMapElement(EditEx(), Str(GNum))
      
      AddItem_(Position, Text)
      
      CompilerIf #Enable_SpellChecking
        
        If EditEx()\Flags & #AutoSpellCheck
          UpdateWordList_()
          SpellChecking_(#True)
        EndIf
        
      CompilerEndIf 

      Draw_()
      AdjustScrolls_()
      
    EndIf
    
    ProcedureReturn ListSize(EditEx()\Row())
  EndProcedure
  
  Procedure   AttachPopup(GNum.i, PopUpMenu.i)           ; Attach 'PopUpMenu' to gadget 
    If FindMapElement(EditEx(), Str(GNum))
      EditEx()\PopupMenu = PopUpMenu
    EndIf
  EndProcedure   
  
  
  Procedure.i CountItems(GNum.i)
    
    If FindMapElement(EditEx(), Str(GNum))
      ProcedureReturn ListSize(EditEx()\Row())
    EndIf  
    
  EndProcedure
  
  
  Procedure.i GetAttribute(GNum.i, Attribute.i)          ; Similar to GetGadgetAttribute()
    
    If FindMapElement(EditEx(), Str(GNum))
      
      Select Attribute
        Case #CtrlChars
          ProcedureReturn EditEx()\Visible\CtrlChars
        Case #MaxTextWidth  
          ProcedureReturn EditEx()\Text\Width
      EndSelect
      
    EndIf
    
  EndProcedure  
  
  Procedure.i GetColor(GNum.i, Attribute.i)
    
    If FindMapElement(EditEx(), Str(GNum))
      
      Select Attribute
        Case #FrontColor
          ProcedureReturn EditEx()\Color\Front
        Case #BackColor
          ProcedureReturn EditEx()\Color\Back
        Case #SyntaxColor
          ProcedureReturn EditEx()\Color\SyntaxHighlight
        Case #SelectionColor
          ProcedureReturn EditEx()\Color\Highlight
        Case #SelectTextColor
          ProcedureReturn EditEx()\Color\HighlightText
      EndSelect
      
    EndIf
    
  EndProcedure 
  
  Procedure.s GetItemText(GNum.i, Row.i)                 ; Return text row from 'Position'
    Define.i Count
    Define.s Text$
    
    If FindMapElement(EditEx(), Str(GNum))
      
      If SelectElement(EditEx()\Row(), Row)
        
        If EditEx()\Flags & #Hyphenation Or EditEx()\Flags & #WordWrap
          Text$ = Mid(EditEx()\Text$, EditEx()\Row()\Pos, EditEx()\Row()\Len) + EditEx()\Row()\WordWrap
          ProcedureReturn ReplaceString(Text$, #LF$, #NL$)
        Else  
          Text$ = Mid(EditEx()\Text$, EditEx()\Row()\Pos, EditEx()\Row()\Len)
          ProcedureReturn ReplaceString(Text$, #LF$, #NL$)
        EndIf
        
      EndIf

    EndIf
    
  EndProcedure  
  
  Procedure.s GetText(GNum.i, Flags.i=#False)
    Define.s Text$
    
    If FindMapElement(EditEx(), Str(GNum))
      
      If Flags & #Hyphenation
        
        ForEach EditEx()\Row()
          Text$ + Mid(EditEx()\Text$, EditEx()\Row()\Pos, EditEx()\Row()\Len) + EditEx()\Row()\WordWrap
        Next  
        
        Text$ = RemoveString(Text$, #SoftHyphen$)
        
        ProcedureReturn ReplaceString(Text$, #LF$, #NL$)
      Else
        
        Text$ = RemoveString(EditEx()\Text$, #SoftHyphen$)
        
        ProcedureReturn ReplaceString(Text$, #LF$, #NL$)
      EndIf  
      
    EndIf
    
  EndProcedure
  
  
  Procedure   ReDraw(GNum.i)
    
    If FindMapElement(EditEx(), Str(GNum))
      Draw_()
    EndIf
    
  EndProcedure  
  
  
  Procedure   SetAttribute(GNum.i, Attribute.i, Value.i) ; Similar to SetGadgetAttribute()
    
    If FindMapElement(EditEx(), Str(GNum))
      
      Select Attribute
        Case #WordWrap, #PB_Editor_WordWrap
          If Value
            EditEx()\Flags | #WordWrap
            EditEx()\Flags & ~#ScrollBar_Horizontal
          Else
            EditEx()\Flags & ~#WordWrap
          EndIf  
        Case #ReadOnly, #PB_Editor_ReadOnly
          If Value
            EditEx()\Flags | #ReadOnly
          Else
            EditEx()\Flags & ~#ReadOnly
          EndIf  
        Case #MaxTextWidth  
          EditEx()\Text\Width = Value
        Case #CtrlChars
          If Value
            EditEx()\Flags | #CtrlChars
            CompilerIf #Enable_SyntaxHighlight
              EditEx()\Flags | #SyntaxHighlight
              EditEx()\Syntax(#Paragraph$)  = $578B2E
              EditEx()\Syntax(#Space$)      = $B48246
              EditEx()\Syntax(#SoftHyphen$) = $7280FA
            CompilerEndIf  
          Else
            EditEx()\Flags & ~#CtrlChars
          EndIf  
      EndSelect
      
    EndIf
    
  EndProcedure
  
  Procedure   SetAutoResizeFlags(GNum.i, Flags.i)
    
    If FindMapElement(EditEx(), Str(GNum))
      
      EditEx()\Size\Flags = Flags
      
    EndIf  
   
  EndProcedure  
  
  Procedure   SetColor(GNum.i, Attribute.i, Color.i)
    
    If FindMapElement(EditEx(), Str(GNum))
      
      Select Attribute
        Case #FrontColor, #PB_Gadget_FrontColor
          EditEx()\Color\Front = Color
        Case #BackColor, #PB_Gadget_BackColor
          EditEx()\Color\Back  = Color
        Case #SyntaxColor
          EditEx()\Color\SyntaxHighlight = Color
        Case #SelectTextColor
          EditEx()\Color\HighlightText = Color
        Case #SelectionColor
          EditEx()\Color\Highlight = Color
      EndSelect
    EndIf
    
  EndProcedure
  
  Procedure   SetFlags(GNum.i, Flags.i)
    
    If FindMapElement(EditEx(), Str(GNum))
      
      If Flags & #WordWrap
        EditEx()\Flags | #WordWrap
        EditEx()\Flags & ~#ScrollBar_Horizontal
      EndIf  
      
      If Flags & #Hyphenation
        EditEx()\Flags | #Hyphenation
        EditEx()\Flags & ~#ScrollBar_Horizontal
      EndIf
      
      If Flags & #ReadOnly
        EditEx()\Flags | #ReadOnly
      ElseIf Flags & #ReadWrite
        EditEx()\Flags & ~#ReadOnly
      EndIf
      
    EndIf  
    
  EndProcedure
  
  Procedure   SetFont(GNum.i, FontID.i)
    
    If FindMapElement(EditEx(), Str(GNum))
      
      If FontID
        EditEx()\FontID   = FontID
      Else
        EditEx()\FontID   = GetGadgetFont(GNum)
      EndIf
      
      Draw_()
      
    EndIf
    
  EndProcedure  
  
  Procedure   SetItemText(GNum.i, Row.i, Text.s) ; Replace text row at 'Position'
    Define.i Count, Pos1, Pos2
    
    If FindMapElement(EditEx(), Str(GNum))

      Count = ListSize(EditEx()\Row())
      If Count And Row < Count

        If SelectElement(EditEx()\Row(), Row)
          
          Pos1 = EditEx()\Row()\Pos - 1
          If Pos1 < 1 : Pos1 = 1 : EndIf
          
          Pos2 = EditEx()\Row()\Pos + EditEx()\Row()\Len + 1
          If Pos2 > EditEx()\Text\Len + 1 : Pos2 = EditEx()\Text\Len + 1 : EndIf
          
          EditEx()\Text$ = Left(EditEx()\Text$, Pos1) + Text + Mid(EditEx()\Text$, Pos2)
          
        EndIf
        
      EndIf
      
      Draw_()
      
      CompilerIf #Enable_SpellChecking
        
        If EditEx()\Flags & #AutoSpellCheck
          UpdateWordList_()
          SpellChecking_(#True)
        EndIf
      
      CompilerEndIf
      
      CompilerIf #Enable_UndoRedo
        If EditEx()\Flags & #UndoRedo : AddUndo_() : EndIf
      CompilerEndIf
      
    EndIf  

  EndProcedure
  
  Procedure   SetText(GNum.i, Text.s)
    Define.i r, Rows
    
    If FindMapElement(EditEx(), Str(GNum))
      
      EditEx()\Text$ = Text

      CompilerIf #Enable_SpellChecking
        
        If EditEx()\Flags & #AutoSpellCheck
          UpdateWordList_()
          SpellChecking_(#True)
        EndIf
        
      CompilerEndIf
      
      CompilerIf #Enable_UndoRedo
        
        If EditEx()\Flags & #UndoRedo : AddUndo_() : EndIf
        
      CompilerEndIf

      Draw_()
      AdjustScrolls_()
      
    EndIf 
    
  EndProcedure
  
  Procedure   SetTextWidth(GNum.i, Value.f, unit.s="px")
    Define.f ScaleFactor
    Define.i Pixel
    
    If FindMapElement(EditEx(), Str(GNum))
    
      Select Unit
        Case "pt"
          EditEx()\Text\Width = Round((Value * 96) / 72, #PB_Round_Nearest)
        Case "mm"
          EditEx()\Text\Width = Round(Value * (72 / 25.4), #PB_Round_Nearest)
        Case "cm"
          EditEx()\Text\Width = Round(Value * (72 / 2.54), #PB_Round_Nearest)
        Case "in"
          EditEx()\Text\Width = Round(Value * 96, #PB_Round_Nearest)
        Default
          EditEx()\Text\Width = Value
      EndSelect

    EndIf
    
  EndProcedure

  ;- ===== Gadget =====
  
  Procedure.i Gadget(GNum.i, X.i, Y.i, Width.i, Height.i, Flags.i=#False, WindowNum.i=#PB_Default)
    Define.i Result, txtNum, WNum 
    
    If Flags & #WordWrap Or Flags & #Hyphenation
      Flags | #ScrollBar_Vertical
    ElseIf Flags & #ScrollBar_Horizontal = #False And  Flags & #ScrollBar_Vertical = #False
      Flags | #ScrollBar_Horizontal
      Flags | #ScrollBar_Vertical
    EndIf
    
    If Flags & #PB_Editor_WordWrap
      Flags | #WordWrap
      Flags & ~#PB_Editor_WordWrap
    EndIf
    
    Result = CanvasGadget(GNum, X, Y, Width, Height, #PB_Canvas_Keyboard|#PB_Canvas_Container|#PB_Canvas_ClipMouse)
    If Result
      
      If GNum = #PB_Any : GNum = Result : EndIf
      
      If AddMapElement(EditEx(), Str(GNum))
     
        EditEx()\CanvasNum = GNum
        
        EditEx()\Size\X = X
        EditEx()\Size\Y = Y
        EditEx()\Size\Width     = Width
        EditEx()\Size\Height    = Height
        EditEx()\Size\PaddingX  = 4
        EditEx()\Size\PaddingY  = 2
        EditEx()\Visible\Width  = Width  - 8
        EditEx()\Visible\Height = Height - 4
        
        CompilerIf Defined(ModuleEx, #PB_Module)
          
          If WindowNum = #PB_Default
            EditEx()\Window\Num = ModuleEx::GetGadgetWindow()
          Else
            EditEx()\Window\Num = WindowNum
          EndIf
          
        CompilerElse
          
          If WindowNum = #PB_Default
            EditEx()\Window\Num = GetActiveWindow()
          Else
            EditEx()\Window\Num = WindowNum
          EndIf
        
        CompilerEndIf

        CompilerIf Defined(ModuleEx, #PB_Module)
          
          If ModuleEx::AddWindow(EditEx()\Window\Num, ModuleEx::#Tabulator|ModuleEx::#CursorEvent)
            ModuleEx::AddGadget(GNum, EditEx()\Window\Num, ModuleEx::#UseTabulator)
          EndIf
          
        CompilerElse  
          
          If Thread\Active = #False
            
            Thread\Exit   = #False
            Thread\Num    = CreateThread(@_CursorThread(), #CursorFrequency)
            Thread\Active = #True

          EndIf
          
        CompilerEndIf
        
        EditEx()\Cursor\Pause = #True
        
        CompilerSelect #PB_Compiler_OS ;{ Font
          CompilerCase #PB_OS_Windows
            EditEx()\FontID = GetGadgetFont(#PB_Default)
          CompilerCase #PB_OS_MacOS
            txtNum = TextGadget(#PB_Any, 0, 0, 0, 0, " ")
            If txtNum
              EditEx()\FontID = GetGadgetFont(txtNum)
              FreeGadget(txtNum)
            EndIf
          CompilerCase #PB_OS_Linux
            EditEx()\FontID = GetGadgetFont(#PB_Default)
        CompilerEndSelect ;}
        
        ;{ Scrollbars
        If Flags & #ScrollBar_Horizontal And Flags & #ScrollBar_Vertical
          EditEx()\HScroll\ID = ScrollBarGadget(#PB_Any, 2, Height - #Scroll_Width - 1, Width - #Scroll_Width - 4, #Scroll_Width, 0, 0, 0)
          EditEx()\VScroll\ID = ScrollBarGadget(#PB_Any, Width - #Scroll_Width - 1, 2, #Scroll_Width, Height - #Scroll_Width - 4, 0, 0, 0, #PB_ScrollBar_Vertical)
          SetGadgetData(EditEx()\VScroll\ID, GNum)
          SetGadgetData(EditEx()\HScroll\ID, GNum)
          HideGadget(EditEx()\HScroll\ID, #True)
          HideGadget(EditEx()\VScroll\ID, #True)
          BindGadgetEvent(EditEx()\HScroll\ID, @_SynchronizeScrollPos(),  #PB_All)
          BindGadgetEvent(EditEx()\VScroll\ID, @_SynchronizeScrollRows(), #PB_All) 
        ElseIf Flags & #ScrollBar_Horizontal
          EditEx()\HScroll\ID = ScrollBarGadget(#PB_Any, 2, Height - #Scroll_Width - 1, Width - #Scroll_Width - 4, #Scroll_Width, 0, 0, 0)
          EditEx()\VScroll\ID = #PB_Default
          SetGadgetData(EditEx()\HScroll\ID, GNum)
          HideGadget(EditEx()\HScroll\ID, #True)
          BindGadgetEvent(EditEx()\HScroll\ID, @_SynchronizeScrollPos(), #PB_All)
        ElseIf Flags & #ScrollBar_Vertical
          EditEx()\VScroll\ID = ScrollBarGadget(#PB_Any, Width - #Scroll_Width - 1, 2, #Scroll_Width, Height - #Scroll_Width - 4, 0, 0, 0, #PB_ScrollBar_Vertical)
          EditEx()\HScroll\ID = #PB_Default
          SetGadgetData(EditEx()\VScroll\ID, GNum)
          HideGadget(EditEx()\VScroll\ID, #True)
          BindGadgetEvent(EditEx()\VScroll\ID, @_SynchronizeScrollRows(), #PB_All)
        EndIf

        EditEx()\HScroll\Hide = #True
        EditEx()\VScroll\Hide = #True
        ;}

        EditEx()\Flags = Flags
        
        SetGadgetData(EditEx()\CanvasNum, GNum)

      Else
        ProcedureReturn #False
      EndIf

      ;{ ----- Set colors -------------------------
      
      EditEx()\Color\Front         = $000000
      EditEx()\Color\Back          = $FFFFFF
      EditEx()\Color\ReadOnly      = $F5F5F5
      EditEx()\Color\Cursor        = $000000
      EditEx()\Color\HighlightText = $FFFFFF
      EditEx()\Color\Highlight     = $D77800
      EditEx()\Color\ScrollBar     = $C8C8C8
      EditEx()\Color\Border        = $E3E3E3
      
      CompilerSelect  #PB_Compiler_OS
        CompilerCase #PB_OS_Windows
          EditEx()\Color\Front         = GetSysColor_(#COLOR_WINDOWTEXT)
          EditEx()\Color\Back          = GetSysColor_(#COLOR_WINDOW)
          EditEx()\Color\ReadOnly      = GetSysColor_(#COLOR_3DLIGHT)
          EditEx()\Color\HighlightText = GetSysColor_(#COLOR_HIGHLIGHTTEXT)
          EditEx()\Color\Highlight     = GetSysColor_(#COLOR_HIGHLIGHT)
          EditEx()\Color\Cursor        = GetSysColor_(#COLOR_WINDOWTEXT)
          EditEx()\Color\ScrollBar     = GetSysColor_(#COLOR_MENU)
          EditEx()\Color\Border        = GetSysColor_(#COLOR_ACTIVEBORDER)
        CompilerCase #PB_OS_MacOS  
          EditEx()\Color\Front         = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor textColor"))
          EditEx()\Color\Back          = BlendColor_(OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor textBackgroundColor")), $FFFFFF, 80)
          EditEx()\Color\ReadOnly      = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor controlBackgroundColor"))
          EditEx()\Color\HighlightText = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor selectedTextColor"))
          EditEx()\Color\Highlight     = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor selectedTextBackgroundColor"))
          EditEx()\Color\Cursor        = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor textColor"))
          EditEx()\Color\ScrollBar     = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor controlBackgroundColor"))
          EditEx()\Color\Border        = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor grayColor"))
        CompilerCase #PB_OS_Linux
      
      CompilerEndSelect
      
      If EditEx()\Flags & #ReadOnly
        EditEx()\Color\Back = EditEx()\Color\ReadOnly
      EndIf
      
      EditEx()\Color\SyntaxHighlight = $0000E6
      ;}

      EditEx()\Visible\RowOffset = 0
      EditEx()\Visible\PosOffset = 0
      
      BindGadgetEvent(GNum, @_RightClickHandler(),       #PB_EventType_RightClick)
      BindGadgetEvent(GNum, @_RightDoubleClickHandler(), #PB_EventType_RightDoubleClick)
      BindGadgetEvent(GNum, @_LeftDoubleClickHandler(),  #PB_EventType_LeftDoubleClick)
      BindGadgetEvent(GNum, @_LeftButtonDownHandler(),   #PB_EventType_LeftButtonDown)
      BindGadgetEvent(GNum, @_LeftButtonUpHandler(),     #PB_EventType_LeftButtonUp)
      BindGadgetEvent(GNum, @_MouseMoveHandler(),        #PB_EventType_MouseMove)
      BindGadgetEvent(GNum, @_MouseWheelHandler(),       #PB_EventType_MouseWheel)
      BindGadgetEvent(GNum, @_KeyDownHandler(),          #PB_EventType_KeyDown)
      BindGadgetEvent(GNum, @_InputHandler(),            #PB_EventType_Input)
      BindGadgetEvent(GNum, @_LostFocusHandler(),        #PB_EventType_LostFocus)
      BindGadgetEvent(GNum, @_FocusHandler(),            #PB_EventType_Focus)
      BindGadgetEvent(GNum, @_ResizeHandler(),           #PB_EventType_Resize)
      
      BindEvent(#Event_Cursor, @_CursorDrawing())
      
      If IsWindow(EditEx()\Window\Num)
        
        EditEx()\Window\Width  = WindowWidth(EditEx()\Window\Num)
        EditEx()\Window\Height = WindowHeight(EditEx()\Window\Num)
        
        If Flags & #AutoResize
          BindEvent(#PB_Event_SizeWindow, @_ResizeWindowHandler(), EditEx()\Window\Num)
        EndIf
        
        BindEvent(#PB_Event_CloseWindow, @_CloseWindowHandler(), EditEx()\Window\Num)
      EndIf
      
      CloseGadgetList()
      
      CompilerIf #Enable_SpellChecking ; ListView
       
        If IsWindow(WindowNum)
          WNum = OpenWindow(#PB_Any, X, Y, 100, 60, "Suggestions", #PB_Window_BorderLess|#PB_Window_Invisible, WindowID(WindowNum))
        Else
          WNum = OpenWindow(#PB_Any, X, Y, 100, 60, "Suggestions", #PB_Window_BorderLess|#PB_Window_Invisible)
        EndIf
        
	      If WNum
	        StickyWindow(WNum, #True) 
	        EditEx()\WinNum  = WNum
          EditEx()\ListNum = ListViewGadget(#PB_Any, 0, 0, 100, 60)
          If IsGadget(EditEx()\ListNum)
            SetGadgetData(EditEx()\ListNum, GNum)
            BindGadgetEvent(EditEx()\ListNum, @_ListViewHandler(), #PB_EventType_LeftDoubleClick)
          EndIf
          HideWindow(EditEx()\WinNum, #True)
        EndIf
        
      CompilerEndIf
      
    EndIf
    
    Draw_()
    
    ProcedureReturn GNum
  EndProcedure
  
  Procedure   RemoveGadget(GNum.i)
    
    If FindMapElement(EditEx(), Str(GNum))
      
      CompilerIf Defined(ModuleEx, #PB_Module) = #False
        If MapSize(EditEx()) = 1
          Thread\Exit = #True
          Delay(100)
          If IsThread(Thread\Num) : KillThread(Thread\Num) : EndIf
          Thread\Active = #False
        EndIf
      CompilerEndIf
      
      DeleteMapElement(EditEx())
      
    EndIf 
    
  EndProcedure
  
EndModule

;- ========  Module - Example ========

CompilerIf #PB_Compiler_IsMainFile
  
  Language = EditEx::#Deutsch  ; #Deutsch / #English / #French
  
  Define.s Text
  Define.i QuitWindow.i
  
  Enumeration 
    #Window
    #Editor
    #EditEx
    #PopupMenu
    #MenuItem_1
    #MenuItem_2
    #MenuItem_3
    #MenuItem_4
    #MenuItem_5
  EndEnumeration
  
  Select Language
    Case EditEx::#Deutsch
      Text = "Die Schule ist ein schönes Ding." + #LF$ + "Man braucht sie, das ist wahr." + #LF$ + "Auf einem umgestürzten Baum saß eine Affenschar."
      Text + #LF$ + "Man hatte sie dorthin geschickt, zu bilden den Verstand." + #LF$ + "Der Lehrer war drei Tonnen schwer, ein gescheiter Elefant."
      Text + #LF$ + "Der Lehrer nahm mit seinem Rüssel die Schüler bei den Ohren." + #LF$ + "Sie lernten nichts, sie lärmten nur, alle Mühe war verloren."
    Case EditEx::#English
      Text = "School is a beautiful thing." + #LF$ + "You need it, that's true." + #LF$ + "There was a group of monkeys sitting on a fallen tree."
      Text + #LF$ + "They had been sent there to make up the mind." + #LF$ + "The teacher was three tons heavy, a clever elephant."
      Text + #LF$ + "The teacher took the students by the ears with his trunk." + #LF$ + "They didn't learn anything, they just made noise, all effort was lost."
    Case EditEx::#French
      Text = "L'école est une belle chose." + #LF$ + "Tu en as besoin, c'est vrai." + #LF$ + "Sur un arbre tombé, un troupeau de singes était assis."
      Text + #LF$ + "Ils avaient été envoyés là-bas pour se décider."  + #LF$ + "Le professeur pesait trois tonnes, un éléphant intelligent."
      Text + #LF$ + "Le professeur a pris les élèves par les oreilles avec son coffre." + #LF$ + "Ils n'ont rien appris, ils ont juste fait du bruit, tous les efforts ont été perdus."
  EndSelect

  #Font = 1
  
  LoadFont(#Font, "Arial", 11)
  
  CompilerIf EditEx::#Enable_Hyphenation
    
    Select Language
      Case EditEx::#Deutsch
        EditEx::LoadHyphenationPattern(EditEx::#PAT_Deutsch) ; or: "german.pat"
      Case EditEx::#English
        EditEx::LoadHyphenationPattern(EditEx::#PAT_English) ; or: "english.pat"
      Case EditEx::#French
        EditEx::LoadHyphenationPattern(EditEx::#PAT_French)  ; or: "french.pat"
    EndSelect
    
  CompilerEndIf
  
  CompilerIf EditEx::#Enable_SpellChecking
    
    Select Language
      Case EditEx::#Deutsch
        EditEx::LoadDictionary(EditEx::#DIC_Deutsch) ; or: "german.dic"
      Case EditEx::#English
        EditEx::LoadDictionary(EditEx::#DIC_English) ; or: "english.dic"
      Case EditEx::#French
        EditEx::LoadDictionary(EditEx::#DIC_French)  ; or: "french.dic"
    EndSelect
    
  CompilerEndIf
  
  If OpenWindow(#Window, 0, 0, 322, 287, "EditorGadget", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    
    If CreatePopupMenu(#PopupMenu) ;{ Creation of the pop-up menu begins.
      MenuItem(#MenuItem_1, "Copy")
      MenuItem(#MenuItem_2, "Paste")
      MenuItem(#MenuItem_3, "Cut")
      CompilerIf EditEx::#Enable_UndoRedo
        MenuBar()
        MenuItem(#MenuItem_4, "Undo")
        MenuItem(#MenuItem_5, "Redo")
      CompilerEndIf
    EndIf ;}
    
    EditorGadget(#Editor, 8, 8, 306, 133, #PB_Editor_WordWrap)
    SetGadgetText(#Editor, Text)
    SetGadgetFont(#Editor, FontID(#Font))
    
    EditEx::Gadget(#EditEx, 8, 146, 306, 133, EditEx::#AutoResize, #Window)
    EditEx::SetFont(#EditEx, FontID(#Font))

    ; Test WordWrap and Hyphenation
    CompilerIf EditEx::#Enable_Hyphenation
      EditEx::SetFlags(#EditEx, EditEx::#Hyphenation) ; Test Hyphenation
    CompilerElse
      EditEx::SetFlags(#EditEx, EditEx::#WordWrap)    ; Test WordWrap
    CompilerEndIf
    
    CompilerIf EditEx::#Enable_UndoRedo
      EditEx::EnableUndoRedo(#EditEx, #True)
    CompilerEndIf
    
    ;EditEx::AttachPopup(#EditEx, #PopupMenu)
    
    ;EditEx::SetAttribute(#EditEx, EditEx::#CtrlChars, #True)
    
    CompilerIf EditEx::#Enable_SpellChecking
      EditEx::EnableAutoSpellCheck(#EditEx, #True, EditEx::#Suggestions)
    CompilerEndIf
    
    ; --- Add Text ---
    ;EditEx::SetText(#EditEx, Text)
    ; ----------------
    
    CompilerIf EditEx::#Enable_SpellChecking
      
      EditEx::AddToUserDictionary(#EditEx, "Affenschar")
      
    CompilerElseIf EditEx::#Enable_SyntaxHighlight
      
      EditEx::EnableSyntaxHighlight(#EditEx)
      EditEx::AddWord(#EditEx, "Schule")
      EditEx::AddWord(#EditEx, "ein")
      EditEx::AddWord(#EditEx, "Affenschar", #Blue)
      EditEx::AddWord(#EditEx, "bilden",     #Green)
      EditEx::ReDraw(#EditEx)
      
      ; EditEx::DeleteWord(#EditEx, "ein")
      
    CompilerEndIf
    
    ;Debug EditEx::GetText(#EditEx, EditEx::#Hyphenation)
    
    QuitWindow = #False
    
    Repeat
      Select WaitWindowEvent()
        Case #PB_Event_CloseWindow ;{ Close Window
          QuitWindow = #True
          ;}
        Case #PB_Event_Menu        ;{ Popup-Menue
          Select EventMenu()
            Case #MenuItem_1       ;{ Copy
              EditEx::Copy(#EditEx)
              ;}
            Case #MenuItem_2       ;{ Paste
              EditEx::Paste(#EditEx)
              ;}
            Case #MenuItem_3       ;{ Cut
              EditEx::Cut(#EditEx)
              ;}
            CompilerIf EditEx::#Enable_UndoRedo  
              Case #MenuItem_4     ;{ Undo
                EditEx::Undo(#EditEx)
                ;}
              Case #MenuItem_5     ;{ Redo
                EditEx::Redo(#EditEx)
                ;}
            CompilerEndIf
          EndSelect ;}
      EndSelect
    Until QuitWindow
    
    CompilerIf EditEx::#Enable_SpellChecking
      ;EditEx::SaveUserDictionary()
    CompilerEndIf
    
    EditEx::RemoveGadget(#EditEx)
    
    CloseWindow(#Window)  
  EndIf
  
CompilerEndIf

; IDE Options = PureBasic 5.71 LTS (Windows - x86)
; CursorPosition = 53
; Folding = c9HAAAAAAAAAIEAICAAAgAwQAAAAAAvoDocgFCAAAEAEkQDg
; EnableThread
; EnableXP
; DPIAware