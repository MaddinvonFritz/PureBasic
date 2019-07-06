﻿;/ ============================
;/ =    CalendarModule.pbi    =
;/ ============================
;/
;/ [ PB V5.7x / 64Bit / All OS / DPI ]
;/
;/ Calendar - Gadget 
;/
;/ © 2019 Thorsten1867 (07/2019)
;/


; Last Update: 

;{ ===== MIT License =====
;
; Copyright (c) 2019 Thorsten Hoeppner
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


;{ _____ Calendar - Commands _____

;}


DeclareModule Calendar
  
  ;- ===========================================================================
  ;-   DeclareModule - Constants
  ;- =========================================================================== 
  
  ;{ _____ Constants _____
  EnumerationBinary ;{ GadgetFlags
    #AutoResize    ; Automatic resizing of the gadget
    #Border        ; Draw a border  
    #FixDayOfMonth ; Don't change day of month
    #FixMonth      ; Don't change month
    #FixYear       ; Don't change year
    #PostEvent     ; Send PostEvents
    #ToolTips      ; Show tooltips
  EndEnumeration ;}
  
  Enumeration 1     ;{ Attribute
    #Spacing         ; Horizontal spacing for month name
    #Height_Month    ; Row height for month and year
    #Height_WeekDays ; Row height for weekdays
    #Maximum         ; Year (SpinGadget)
    #Minimum         ; Year (SpinGadget)
  EndEnumeration ;}
  
  Enumeration 1     ;{ fontType
    #Font_Gadget
    #Font_Month
    #Font_WeekDays
  EndEnumeration
  
  Enumeration 1     ;{ FlagType
    #Year
    #Month
    #Gadget
  EndEnumeration
  
  EnumerationBinary ;{ AutoResize
    #MoveX
    #MoveY
    #ResizeWidth
    #ResizeHeight
  EndEnumeration ;} 
  
  Enumeration 1     ;{ Color
    #ArrowColor
    #BackColor
    #BorderColor
    #FocusColor
    #FrontColor
    #LineColor
    #EntryColor
    #Entry_FrontColor
    #Entry_BackColor
    #Month_FrontColor
    #Month_BackColor
    #Week_FrontColor
    #Week_BackColor
  EndEnumeration ;}
  
  CompilerIf Defined(ModuleEx, #PB_Module)
    
    #Event_Gadget    = ModuleEx::#Event_Gadget
    #EventType_Month = ModuleEx::#EventType_Month
    #EventType_Year  = ModuleEx::#EventType_Year
    
  CompilerElse
    
    Enumeration #PB_Event_FirstCustomValue
      #Event_Gadget
    EndEnumeration
    
    Enumeration #PB_EventType_FirstCustomValue
      #EventType_Month
      #EventType_Year
    EndEnumeration
    
  CompilerEndIf
  ;}
  
 
  ;- ===========================================================================
  ;-   DeclareModule
  ;- ===========================================================================
  
  Declare   AttachPopupMenu(GNum.i, PopUpNum.i)
  Declare   DefaultCountry(Code.s)
  Declare   DisableReDraw(GNum.i, State.i=#False)
  Declare.i Gadget(GNum.i, X.i, Y.i, Width.i, Height.i, Flags.i=#False, WindowNum.i=#PB_Default)
  Declare.i GetDay(GNum.i)
  Declare.i GetMonth(GNum.i) 
  Declare.i GetState(GNum.i) 
  Declare.i GetYear(GNum.i)
  Declare   MonthName(Month.i, Name.s)
  Declare   SetAttribute(GNum.i, Attribute.i, Value.i)
  Declare   SetAutoResizeFlags(GNum.i, Flags.i)
  Declare   SetColor(GNum.i, ColorTyp.i, Value.i)
  Declare   SetFont(GNum.i, FontNum.i, FontType.i=#Font_Gadget) 
  Declare   SetState(GNum.i, Date.i)
  Declare   WeekDayName(WeekDay.i, Name.s)
  
EndDeclareModule

Module Calendar
  
  EnableExplicit
  
  ;- ============================================================================
  ;-   Module - Constants
  ;- ============================================================================ 
  
  #Value$ = "{Value}"
  
  #NotValid = -1
  
  #MonthOfYear = 1
  #WeekDays    = 2
  
  #Previous = 1
  #Next     = 2
  #Change   = 1
  
  ;- ============================================================================
  ;-   Module - Structures
  ;- ============================================================================
  
  Structure Color_Structure              ;{ ...\Color\...
    Front.i
    Back.i
    Border.i
  EndStructure  ;}
  
  Structure Entry_Structure              ;{ ...\Entry\...
    StartDate.i
    EndDate.i
    FrontColor.i
    BackColor.i
    Flags.i
  EndStructure ;}
  
  Structure Button_Size_Structure        ;{ Calendar()\Button\...
    prevX.i
    nextX.i
    Y.i
    Width.i
    Height.i
  EndStructure  ;}
  
  Structure Calendar_PostEvent_Structure ;{ Calendar()\PostEvent\
    MonthX.i
    YearX.i
    Y.i
    MonthWidth.i
    YearWidth.i
    Height.i
  EndStructure ;}

  Structure Calendar_Day_Structure       ;{ Calendar()\Day\...
    X.i
    Y.i
    Width.i
    Height.i
    ToolTip.s
  EndStructure ;}
  
  Structure Calendar_Month_Structure     ;{ Calendar()\Month\...
    Y.i
    Height.i
    defHeight.i
    Spacing.i
    Font.i
    Flags.i
    State.i
    Color.Color_Structure
    Map Name.s()
    List Entries.Entry_Structure()
  EndStructure ;}
  
  Structure Calendar_Year_Structure      ;{ Calendar()\Year\...
    Minimum.i
    Maximum.i
    State.i
    Flags.i
  EndStructure ;}
  
  Structure Calendar_Week_Structure      ;{ Calendar()\Week\...
    Y.i
    Height.i
    defHeight.i
    Font.i
    Color.Color_Structure
    Map Day.s()
  EndStructure ;}
  
  Structure Calendar_Current_Structure   ;{ Calendar()\Current\...
    Date.i
    Focus.i
    Month.i
    Year.i
  EndStructure ;}
  
  Structure Calendar_Margins_Structure   ;{ Calendar()\Margin\...
    Top.i
    Left.i
    Right.i
    Bottom.i
  EndStructure ;}
  
  Structure Calendar_Color_Structure     ;{ Calendar()\Color\...
    Arrow.i
    Back.i
    Border.i
    Focus.i
    Gadget.i
    Front.i
    Line.i
    Entry.i
    EntryFront.i
    EntryBack.i
  EndStructure  ;}
  
  Structure Calendar_Window_Structure    ;{ Calendar()\Window\...
    Num.i
    Width.f
    Height.f
  EndStructure ;}
  
  Structure Calendar_Size_Structure      ;{ Calendar()\Size\...
    X.f
    Y.f
    Width.f
    Height.f
    Flags.i
  EndStructure ;} 
  
  
  Structure Calendar_Structure           ;{ Calendar()\...
    CanvasNum.i
    SpinNum.i
    ListNum.i
    PopupNum.i
    
    FontID.i
    
    ReDraw.i
    
    Flags.i
    
    ToolTip.i
    ToolTipText.s
    
    Color.Calendar_Color_Structure
    Current.Calendar_Current_Structure
    
    Button.Button_Size_Structure
    Margin.Calendar_Margins_Structure
    Month.Calendar_Month_Structure
    PostEvent.Calendar_PostEvent_Structure
    Size.Calendar_Size_Structure
    Week.Calendar_Week_Structure
    Window.Calendar_Window_Structure
    Year.Calendar_Year_Structure
    
    Map Day.Calendar_Day_Structure()
    Map PopUpItem.s()
    
    List Entries.Entry_Structure()
    
  EndStructure ;}
  Global NewMap Calendar.Calendar_Structure()
  
  Global CountryCode.s
  Global NewMap NameOfMonth.s(), NewMap NameOfWeekDay.s()
  
  ;- ============================================================================
  ;-   Module - Internal
  ;- ============================================================================  
  
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
    ProcedureReturn DesktopScaledX(Num)
  EndProcedure
  
  Procedure.f dpiY(Num.i)
    ProcedureReturn DesktopScaledY(Num)
  EndProcedure
  
  
  Procedure.s GetPopUpText_(Text.s)
    Define.f Percent
    Define.s Text$ = ""

    If Text
      Text$ = ReplaceString(Text$, #Value$, "") ; <<<
    EndIf
    
    ProcedureReturn Text$
  EndProcedure
  
  Procedure   UpdatePopUpMenu_()
    Define.s Text$
    
    ForEach Calendar()\PopUpItem()
      Text$ = GetPopUpText_(Calendar()\PopUpItem())
      SetMenuItemText(Calendar()\PopupNum, Val(MapKey(Calendar()\PopUpItem())), Text$)
    Next
    
  EndProcedure
  
  
  Procedure   Months_(Code.s="")
	  
    Select Code
      Case "AT"
	      Calendar()\Month\Name("1")  = "Jänner"
	      Calendar()\Month\Name("2")  = "Februar"
	      Calendar()\Month\Name("3")  = "März"
	      Calendar()\Month\Name("4")  = "April"
	      Calendar()\Month\Name("5")  = "Mai"
	      Calendar()\Month\Name("6")  = "Juni"
	      Calendar()\Month\Name("7")  = "Juli"
	      Calendar()\Month\Name("8")  = "August"
	      Calendar()\Month\Name("9")  = "September"
	      Calendar()\Month\Name("10") = "Oktober"
	      Calendar()\Month\Name("11") = "November"
	      Calendar()\Month\Name("12") = "Dezember"  
	    Case "DE"
	      Calendar()\Month\Name("1")  = "Januar"
	      Calendar()\Month\Name("2")  = "Februar"
	      Calendar()\Month\Name("3")  = "März"
	      Calendar()\Month\Name("4")  = "April"
	      Calendar()\Month\Name("5")  = "Mai"
	      Calendar()\Month\Name("6")  = "Juni"
	      Calendar()\Month\Name("7")  = "Juli"
	      Calendar()\Month\Name("8")  = "August"
	      Calendar()\Month\Name("9")  = "September"
	      Calendar()\Month\Name("10") = "Oktober"
	      Calendar()\Month\Name("11") = "November"
	      Calendar()\Month\Name("12") = "Dezember"
	    Case "ES"
	      Calendar()\Month\Name("1")  = "enero"
	      Calendar()\Month\Name("2")  = "febrero"
	      Calendar()\Month\Name("3")  = "marzo"
	      Calendar()\Month\Name("4")  = "abril"
	      Calendar()\Month\Name("5")  = "mayo"
	      Calendar()\Month\Name("6")  = "junio"
	      Calendar()\Month\Name("7")  = "julio"
	      Calendar()\Month\Name("8")  = "agosto"
	      Calendar()\Month\Name("9")  = "septiembre"
	      Calendar()\Month\Name("10") = "octubre"
	      Calendar()\Month\Name("11") = "noviembre"
	      Calendar()\Month\Name("12") = "diciembre"
	    Case "FR"
	      Calendar()\Month\Name("1")  = "Janvier"
	      Calendar()\Month\Name("2")  = "Février"
	      Calendar()\Month\Name("3")  = "Mars"
	      Calendar()\Month\Name("4")  = "Avril"
	      Calendar()\Month\Name("5")  = "Mai"
	      Calendar()\Month\Name("6")  = "Juin"
	      Calendar()\Month\Name("7")  = "Juillet"
	      Calendar()\Month\Name("8")  = "Août"
	      Calendar()\Month\Name("9")  = "Septembre"
	      Calendar()\Month\Name("10") = "Octobre"
	      Calendar()\Month\Name("11") = "Novembre"
	      Calendar()\Month\Name("12") = "Décembre"
	    Case "GB", "US"
        Calendar()\Month\Name("1")  = "January"
	      Calendar()\Month\Name("2")  = "February"
	      Calendar()\Month\Name("3")  = "March"
	      Calendar()\Month\Name("4")  = "April"
	      Calendar()\Month\Name("5")  = "May"
	      Calendar()\Month\Name("6")  = "June"
	      Calendar()\Month\Name("7")  = "July"
	      Calendar()\Month\Name("8")  = "August"
	      Calendar()\Month\Name("9")  = "September"
	      Calendar()\Month\Name("10") = "October"
	      Calendar()\Month\Name("11") = "November"
	      Calendar()\Month\Name("12") = "December"
	    Default
	      If MapSize(NameOfMonth())
	        Calendar()\Month\Name("1")  = NameOfMonth("1")
  	      Calendar()\Month\Name("2")  = NameOfMonth("2")
  	      Calendar()\Month\Name("3")  = NameOfMonth("3")
  	      Calendar()\Month\Name("4")  = NameOfMonth("4")
  	      Calendar()\Month\Name("5")  = NameOfMonth("5")
  	      Calendar()\Month\Name("6")  = NameOfMonth("6")
  	      Calendar()\Month\Name("7")  = NameOfMonth("7")
  	      Calendar()\Month\Name("8")  = NameOfMonth("8")
  	      Calendar()\Month\Name("9")  = NameOfMonth("9")
  	      Calendar()\Month\Name("10") = NameOfMonth("10")
  	      Calendar()\Month\Name("11") = NameOfMonth("11")
  	      Calendar()\Month\Name("12") = NameOfMonth("12")
	      Else
  	      Calendar()\Month\Name("1")  = "January"
  	      Calendar()\Month\Name("2")  = "February"
  	      Calendar()\Month\Name("3")  = "March"
  	      Calendar()\Month\Name("4")  = "April"
  	      Calendar()\Month\Name("5")  = "May"
  	      Calendar()\Month\Name("6")  = "June"
  	      Calendar()\Month\Name("7")  = "July"
  	      Calendar()\Month\Name("8")  = "August"
  	      Calendar()\Month\Name("9")  = "September"
  	      Calendar()\Month\Name("10") = "October"
  	      Calendar()\Month\Name("11") = "November"
  	      Calendar()\Month\Name("12") = "December"
	      EndIf
	  EndSelect
	  
	EndProcedure
  
  Procedure   WeekDays_(Code.s="")
	  
	  Select Code
	    Case "DE", "AT"
	      Calendar()\Week\Day("1") = "Mo."
	      Calendar()\Week\Day("2") = "Di."
	      Calendar()\Week\Day("3") = "Mi."
	      Calendar()\Week\Day("4") = "Do."
	      Calendar()\Week\Day("5") = "Fr."
	      Calendar()\Week\Day("6") = "Sa."
	      Calendar()\Week\Day("7") = "So."
	    Case "ES"
	      Calendar()\Week\Day("1") = "Lun."
	      Calendar()\Week\Day("2") = "Mar."
	      Calendar()\Week\Day("3") = "Mié."
	      Calendar()\Week\Day("4") = "Jue."
	      Calendar()\Week\Day("5") = "Vie."
	      Calendar()\Week\Day("6") = "Sáb."
	      Calendar()\Week\Day("7") = "Dom."
	    Case "FR"
	      Calendar()\Week\Day("1") = "Lu."
	      Calendar()\Week\Day("2") = "Ma."
	      Calendar()\Week\Day("3") = "Me."
	      Calendar()\Week\Day("4") = "Je."
	      Calendar()\Week\Day("5") = "Ve."
	      Calendar()\Week\Day("6") = "Sa."
	      Calendar()\Week\Day("7") = "Di."
	    Case "GB", "US"
        Calendar()\Week\Day("1") = "Mon."
	      Calendar()\Week\Day("2") = "Tue."
	      Calendar()\Week\Day("3") = "Wed."
	      Calendar()\Week\Day("4") = "Thu."
	      Calendar()\Week\Day("5") = "Fri."
	      Calendar()\Week\Day("6") = "Sat."
	      Calendar()\Week\Day("7") = "Sun."
	    Default
	      If MapSize(NameOfWeekDay())
	        Calendar()\Week\Day("1") = NameOfWeekDay("1")
  	      Calendar()\Week\Day("2") = NameOfWeekDay("2") 
  	      Calendar()\Week\Day("3") = NameOfWeekDay("3") 
  	      Calendar()\Week\Day("4") = NameOfWeekDay("4") 
  	      Calendar()\Week\Day("5") = NameOfWeekDay("5") 
  	      Calendar()\Week\Day("6") = NameOfWeekDay("6") 
  	      Calendar()\Week\Day("7") = NameOfWeekDay("7") 
	      Else
  	      Calendar()\Week\Day("1") = "Mon."
  	      Calendar()\Week\Day("2") = "Tue."
  	      Calendar()\Week\Day("3") = "Wed."
  	      Calendar()\Week\Day("4") = "Thu."
  	      Calendar()\Week\Day("5") = "Fri."
  	      Calendar()\Week\Day("6") = "Sat."
  	      Calendar()\Week\Day("7") = "Sun."
  	    EndIf
	    
	  EndSelect
	  
	EndProcedure
	
	Procedure.i GetColor_(Color.i, DefaultColor.i)
	  
	  If Color = #PB_Default
	    ProcedureReturn DefaultColor
	  Else
	    ProcedureReturn Color
	  EndIf
	  
	EndProcedure
	
	Procedure   SetFont_(FontNum.i)
	  
	  If IsFont(FontNum)
	     DrawingFont(FontID(FontNum))
	  Else
	     DrawingFont(Calendar()\FontID)
	  EndIf
	  
	EndProcedure
	
	Procedure.i LastDayOfMonth_(Month.i, Year.i)
	  
	  ProcedureReturn Day(AddDate(AddDate(Date(Year, Month, 1, 0, 0, 0), #PB_Date_Month, 1), #PB_Date_Day, -1))
	  
	EndProcedure
	
	Procedure.i FirstWeekDay_(Month.i, Year.i)
	  Define.i DayOfWeek
	  
	  DayOfWeek = DayOfWeek(Date(Year, Month, 1, 0, 0, 0))
	  If DayOfWeek = 0 : DayOfWeek = 7 : EndIf
	  
	  ProcedureReturn DayOfWeek
	EndProcedure
	
  ;- __________ Drawing __________
	
	Procedure.i Arrow_(X.i, Y.i, Width.i, Height.i, Direction.i)
    
    Calendar()\Button\Width  = dpiX(5)
    Calendar()\Button\Height = dpiX(10)
    
    Calendar()\Button\Y = Y + (Height - Calendar()\Button\Height) / 2
    
    If Calendar()\Button\Width < Width And Calendar()\Button\Height < Height 
      
      Select Direction
        Case #Previous

          Calendar()\Button\prevX = X + Width - Calendar()\Button\Width - dpiX(21)

          DrawingMode(#PB_2DDrawing_Default)
          LineXY(Calendar()\Button\prevX, Calendar()\Button\Y + (Calendar()\Button\Height / 2), Calendar()\Button\prevX + Calendar()\Button\Width, Calendar()\Button\Y, Calendar()\Color\Arrow)
          LineXY(Calendar()\Button\prevX, Calendar()\Button\Y + (Calendar()\Button\Height / 2), Calendar()\Button\prevX + Calendar()\Button\Width, Calendar()\Button\Y + Calendar()\Button\Height, Calendar()\Color\Arrow)
          Line(Calendar()\Button\prevX + Calendar()\Button\Width, Calendar()\Button\Y, 1, Calendar()\Button\Height, Calendar()\Color\Arrow)
          FillArea(Calendar()\Button\prevX + Calendar()\Button\Width - dpix(2), Calendar()\Button\Y + (Calendar()\Button\Height / 2), -1, Calendar()\Color\Arrow)
          
        Case #Next

          Calendar()\Button\nextX = X + Width - Calendar()\Button\Width - dpiX(10)

          DrawingMode(#PB_2DDrawing_Default)
          Line(Calendar()\Button\nextX, Calendar()\Button\Y, 1, Calendar()\Button\Height, Calendar()\Color\Arrow)
          LineXY(Calendar()\Button\nextX, Calendar()\Button\Y, Calendar()\Button\nextX + Calendar()\Button\Width, Calendar()\Button\Y + (Calendar()\Button\Height / 2), Calendar()\Color\Arrow)
          LineXY(Calendar()\Button\nextX, Calendar()\Button\Y + Calendar()\Button\Height, Calendar()\Button\nextX + Calendar()\Button\Width, Calendar()\Button\Y + (Calendar()\Button\Height / 2), Calendar()\Color\Arrow)
          FillArea(Calendar()\Button\nextX + dpix(2), Calendar()\Button\Y + (Calendar()\Button\Height / 2), -1, Calendar()\Color\Arrow)
          
      EndSelect

    EndIf
    
  EndProcedure
	
  Procedure.i BlendColor_(Color1.i, Color2.i, Factor.i=50)
    Define.i Red1, Green1, Blue1, Red2, Green2, Blue2
    Define.f Blend = Factor / 100
    
    Red1 = Red(Color1): Green1 = Green(Color1): Blue1 = Blue(Color1)
    Red2 = Red(Color2): Green2 = Green(Color2): Blue2 = Blue(Color2)
    
    ProcedureReturn RGB((Red1 * Blend) + (Red2 * (1 - Blend)), (Green1 * Blend) + (Green2 * (1 - Blend)), (Blue1 * Blend) + (Blue2 * (1 - Blend)))
  EndProcedure
  
  Procedure   Draw_()
    Define.i X, Y, Width, Height, PosX, PosY, txtX, txtY, txtHeight
    Define.i c, r, Column, Row, ColumnWidth, RowHeight, Difference
    Define.i Month, Year, Day, FirstWeekDay, LastDay, FocusDay, FocusX, FocusY
    Define.i FrontColor, BackColor, CurrentDate
    Define.s Text$, Month$, Year$
    
    X = Calendar()\Margin\Left
    Y = Calendar()\Margin\Top
    
    Width  = Calendar()\Size\Width  - Calendar()\Margin\Left - Calendar()\Margin\Right
    Height = Calendar()\Size\Height - Calendar()\Margin\Top  - Calendar()\Margin\Bottom

    If StartDrawing(CanvasOutput(Calendar()\CanvasNum))
      
      ColumnWidth = Round(Width  / 7, #PB_Round_Down)  ; Days of week
      Width       = ColumnWidth *  7
      
      ;{ Calc Height
      If Calendar()\Month\defHeight = #PB_Default And Calendar()\Week\defHeight = #PB_Default
        
        RowHeight = Round(Height / 8, #PB_Round_Down) ; Month + Weekdays + Rows
        Calendar()\Month\Height = RowHeight
        Calendar()\Week\Height  = RowHeight

        Difference = Height - (RowHeight * 8)
        
      ElseIf Calendar()\Month\defHeight = #PB_Default
        
        RowHeight = Round((Height - Calendar()\Week\defHeight) / 7, #PB_Round_Down)
        Calendar()\Month\Height = RowHeight
        Calendar()\Week\Height  = Calendar()\Week\defHeight
        
        Difference = Height - (Calendar()\Week\Height + (RowHeight * 7))
        
      ElseIf Calendar()\Week\defHeight = #PB_Default 
        
        RowHeight = Round((Height - Calendar()\Month\defHeight) / 7, #PB_Round_Down)
        Calendar()\Month\Height = Calendar()\Month\defHeight
        Calendar()\Week\Height  = RowHeight
        
        Difference = Height - (Calendar()\Month\Height + (RowHeight * 7))
        
      Else
        
        RowHeight = Round((Height - Calendar()\Month\defHeight - Calendar()\Week\defHeight) / 6, #PB_Round_Down)
        Calendar()\Month\Height = Calendar()\Month\defHeight
        Calendar()\Week\Height  = Calendar()\Week\defHeight
        
        Difference = Height - (Calendar()\Month\Height + Calendar()\Week\Height + (RowHeight * 6))
        
      EndIf ;}
      
      Calendar()\Month\Height + Difference
      
      ;{ _____ Background _____
      DrawingMode(#PB_2DDrawing_Default)
      Box(0, 0, Calendar()\Size\Width, Calendar()\Size\Height, Calendar()\Color\Gadget)
      Box(0, 0, Width, Height, Calendar()\Color\Back) 
      ;}
      
      DrawingFont(Calendar()\FontID)
      
      Month = Calendar()\Current\Month
      Year  = Calendar()\Current\Year
      
      FirstWeekDay = FirstWeekDay_(Month, Year)
      LastDay      = LastDayOfMonth_(Month, Year)
      FocusDay     = Day(Calendar()\Current\Focus)
      
      FocusX = #NotValid
      FocusY = #NotValid
      
      PosY = Y
      Day  = 1

      For r=1 To 8

        Select r
          Case #MonthOfYear ;{ Month & Year
            
            SetFont_(Calendar()\Month\Font)
            
            PosX = X  + Calendar()\Month\Spacing
            
            Month$ = Calendar()\Month\Name(Str(Calendar()\Current\Month))
            Year$  = Str(Calendar()\Current\Year)
            Text$  = Month$ + "  " + Year$
            
            txtHeight = TextHeight(Text$)
            txtY      = (Calendar()\Month\Height - txtHeight) / 2
           
            FrontColor = GetColor_(Calendar()\Month\Color\Front, Calendar()\Color\Front)
            
            If Calendar()\Month\Color\Back <> #PB_Default
              DrawingMode(#PB_2DDrawing_Default)
              Box(X, PosY, Width, Calendar()\Month\Height, Calendar()\Month\Color\Back)
            EndIf
            
            DrawingMode(#PB_2DDrawing_Transparent) 
            DrawText(PosX, PosY + txtY, Text$, FrontColor)
            
            Calendar()\Month\Y      = PosY + txtY
            Calendar()\Month\Height = Calendar()\Month\Height
            
            Calendar()\PostEvent\MonthX     = PosX
            Calendar()\PostEvent\MonthWidth = TextWidth(Month$)
            Calendar()\PostEvent\YearX      = PosX + Calendar()\PostEvent\MonthWidth + TextWidth("  ")
            Calendar()\PostEvent\YearWidth  = TextWidth(Year$)
            Calendar()\PostEvent\Y          = PosY + txtY
            Calendar()\PostEvent\Height     = txtHeight
            
            DrawingMode(#PB_2DDrawing_Outlined) 
            Box(X, PosY, Width, Calendar()\Month\Height + dpiY(1), Calendar()\Color\Line)
            
            PosY + Calendar()\Month\Height
            ;}
          Case #WeekDays    ;{ Weekdays
            
            SetFont_(Calendar()\Week\Font)

            PosX      = X
            txtHeight = TextHeight("Abc")
            txtY      = (Calendar()\Week\Height - txtHeight) / 2
            
            FrontColor = GetColor_(Calendar()\Week\Color\Front, Calendar()\Color\Front)
            
            If Calendar()\Month\Color\Back <> #PB_Default
              DrawingMode(#PB_2DDrawing_Default)
              Box(X, PosY, Width, Calendar()\Week\Height, Calendar()\Week\Color\Back)
            EndIf
            
            For c=1 To 7
              
              Text$ = Calendar()\Week\Day(Str(c))
              txtX = (ColumnWidth - TextWidth(Text$)) / 2
              
              DrawingMode(#PB_2DDrawing_Transparent) 
              DrawText(PosX + txtX, PosY + txtY, Text$, FrontColor)
              
              DrawingMode(#PB_2DDrawing_Outlined) 
              Box(PosX, PosY, ColumnWidth + dpiX(1), Calendar()\Week\Height + dpiY(1), Calendar()\Color\Line)
              
              PosX + ColumnWidth
            Next
            
            PosY + Calendar()\Week\Height
            ;}
          Default           ;{ Days
            
            DrawingFont(Calendar()\FontID)
            
            PosX      = X
            txtHeight = TextHeight("Abc")
            txtY      = (RowHeight - txtHeight) / 2
            
            For c=1 To 7
              
              If Day = 1 And c <> FirstWeekDay
                DrawingMode(#PB_2DDrawing_Outlined) 
                Box(PosX, PosY, ColumnWidth + dpiX(1), RowHeight + dpiY(1), Calendar()\Color\Line)
                PosX + ColumnWidth
                Continue 
              EndIf
              
              If Day <= LastDay And Day <= 31
                
                Text$ = Str(Day)
                txtX = (ColumnWidth - TextWidth("33")) / 2 + (TextWidth("33") - TextWidth(Text$))
                
                If Day = FocusDay
                  If Month = Month(Calendar()\Current\Focus) And Year = Year(Calendar()\Current\Focus)
                    DrawingMode(#PB_2DDrawing_Default)
                    Box(PosX, PosY, ColumnWidth, RowHeight, BlendColor_(Calendar()\Color\Focus, Calendar()\Color\Back, 10))
                    FocusX = PosX : FocusY = PosY
                  EndIf
                EndIf
                
                DrawingMode(#PB_2DDrawing_Transparent) 
                DrawText(PosX + txtX, PosY + txtY, Text$, Calendar()\Color\Front)
                
                DrawingMode(#PB_2DDrawing_Outlined) 
                Box(PosX, PosY, ColumnWidth + dpiX(1), RowHeight + dpiY(1), Calendar()\Color\Line)
                
                Calendar()\Day(Str(Day))\X      = PosX
                Calendar()\Day(Str(Day))\Y      = PosY
                Calendar()\Day(Str(Day))\Width  = ColumnWidth
                Calendar()\Day(Str(Day))\Height = RowHeight
                
                Day + 1
              ElseIf Day <= 31
                
                Calendar()\Day(Str(Day))\X = #False
                Calendar()\Day(Str(Day))\Y = #False
                Calendar()\Day(Str(Day))\Width  = #False
                Calendar()\Day(Str(Day))\Height = #False
                
                Day + 1
              EndIf
              
              PosX + ColumnWidth
            Next

            PosY + RowHeight
            ;}
        EndSelect

      Next
      
      ;{ Draw Focus Border
      If FocusX <> #NotValid And FocusY <> #NotValid 
        DrawingMode(#PB_2DDrawing_Outlined) 
        Box(FocusX, FocusY, ColumnWidth + dpiX(1), RowHeight + dpiY(1), BlendColor_(Calendar()\Color\Focus, Calendar()\Color\Line, 40))
      EndIf
      ;}
      
      If Calendar()\Flags & #FixMonth = #False
        Arrow_(X, Y, Width, Calendar()\Month\Height, #Previous)
        Arrow_(X, Y, Width, Calendar()\Month\Height, #Next)
      EndIf
      
      ;{ _____ Border ____
      DrawingMode(#PB_2DDrawing_Outlined)
      
      ; If Height >= Calendar()\Size\Height :  Height= Calendar()\Size\Height : EndIf
      Box(0, 0, Width, Height, Calendar()\Color\Line)

      If Calendar()\Flags & #Border
        Box(0, 0, Calendar()\Size\Width, Calendar()\Size\Height, Calendar()\Color\Border)
      EndIf ;}
      
      StopDrawing()
    EndIf 
    
  EndProcedure
  
  ;- __________ Events __________
  
  
  Procedure  ChangeYear_(State.i=#True)
    Define.i X, Y, Width, Height, Year, OffsetY
    Define.i FontID, spinHeight, spinWidth
    
    If IsGadget(Calendar()\SpinNum)
      
      If State
        
        X = DesktopUnscaledX(Calendar()\PostEvent\YearX)
        Y = DesktopUnscaledX(Calendar()\PostEvent\Y)
        Width  = DesktopUnscaledX(Calendar()\PostEvent\YearWidth)
        Height = DesktopUnscaledX(Calendar()\PostEvent\Height)
        
        If IsFont(Calendar()\Month\Font)
          SetGadgetFont(Calendar()\SpinNum, FontID(Calendar()\Month\Font))
        Else
          SetGadgetFont(Calendar()\SpinNum, Calendar()\FontID)
        EndIf
        
        SetGadgetState(Calendar()\SpinNum, Calendar()\Current\Year)
        
        spinWidth  = GadgetWidth(Calendar()\SpinNum,  #PB_Gadget_RequiredSize)
        spinHeight = GadgetHeight(Calendar()\SpinNum, #PB_Gadget_RequiredSize)
        
        SetAttribute(Calendar()\SpinNum, #PB_Spin_Minimum, Calendar()\Year\Minimum)
        SetAttribute(Calendar()\SpinNum, #PB_Spin_Maximum, Calendar()\Year\Maximum)
        
        OffsetY = Round((Height - spinHeight) / 2, #PB_Round_Nearest)
        ResizeGadget(Calendar()\SpinNum, X, Y + OffsetY, spinWidth, spinHeight)
        
        HideGadget(Calendar()\SpinNum, #False)

        Calendar()\Year\State = #Change
      Else
        
        HideGadget(Calendar()\SpinNum, #True)
        
        Year = GetGadgetState(Calendar()\SpinNum)
        
        Calendar()\Current\Year  = Year
        Calendar()\Current\Date  = Date(Year, Calendar()\Current\Month, 1, 0, 0, 0)
        Draw_()
        
        Calendar()\Year\State = #False
      EndIf
      
    EndIf
    
  EndProcedure
  
  Procedure  ChangeMonth_(State.i=#True)
    Define.i X, Y, Height
    
    If IsGadget(Calendar()\ListNum)
      
      If State
        X      = DesktopUnscaledX(Calendar()\PostEvent\MonthX)
        Y      = DesktopUnscaledX(Calendar()\PostEvent\Y + Calendar()\PostEvent\Height) + 1
        Height = DesktopUnscaledX(Calendar()\Size\Height - Calendar()\Month\Height) - 5
        
        SetGadgetState(Calendar()\ListNum, Calendar()\Current\Month - 1)
        
        ResizeGadget(Calendar()\ListNum, X, Y, 90, Height)
        
        Calendar()\Month\State = #Change
        HideGadget(Calendar()\ListNum, #False)
        
      Else
        
        Calendar()\Month\State = #False
        HideGadget(Calendar()\ListNum, #True)
        
      EndIf 
      
    EndIf 
    
  EndProcedure
  
  Procedure _ListGadgetHandler()
    Define.i GadgetNum, Selected, Month
    Define.i ListGadgetNum = EventGadget()
    
    GadgetNum = GetGadgetData(ListGadgetNum)
    If FindMapElement(Calendar(), Str(GadgetNum))
      
      Selected = GetGadgetState(ListGadgetNum)
      If Selected <> -1
        
        HideGadget(ListGadgetNum, #True)
        Calendar()\Month\State = #False
        
        Month = Selected + 1
        If Month >= 1 And Month <= 12
          Calendar()\Current\Month = Month
          Calendar()\Current\Date  = Date(Calendar()\Current\Year, Month, 1, 0, 0, 0)
          Draw_()
        EndIf
        
      EndIf
      
    EndIf
    
  EndProcedure
  
  Procedure _LeftDoubleClickHandler()
    Define.i X, Y
    Define.i GadgetNum = EventGadget()
    
    If FindMapElement(Calendar(), Str(GadgetNum))
      
      X = GetGadgetAttribute(Calendar()\CanvasNum, #PB_Canvas_MouseX)
      Y = GetGadgetAttribute(Calendar()\CanvasNum, #PB_Canvas_MouseY)
      
    EndIf
    
  EndProcedure
  
  Procedure _RightClickHandler()
    Define.i X, Y
    Define.i GadgetNum = EventGadget()
    
    If FindMapElement(Calendar(), Str(GadgetNum))
      
      X = GetGadgetAttribute(Calendar()\CanvasNum, #PB_Canvas_MouseX)
      Y = GetGadgetAttribute(Calendar()\CanvasNum, #PB_Canvas_MouseY)
      
      If Calendar()\Month\State = #Change : ChangeMonth_(#False) : EndIf
      If Calendar()\Year\State  = #Change : ChangeYear_(#False)  : EndIf
      
      If X > = Calendar()\Size\X And X <= Calendar()\Size\X + Calendar()\Size\Width
        If Y >= Calendar()\Size\Y And Y <= Calendar()\Size\Y + Calendar()\Size\Height
          
          If IsWindow(Calendar()\Window\Num) And IsMenu(Calendar()\PopUpNum)
            UpdatePopUpMenu_()
            DisplayPopupMenu(Calendar()\PopUpNum, WindowID(Calendar()\Window\Num))
          EndIf
          
        EndIf
      EndIf
      
    EndIf
    
  EndProcedure
  
  Procedure _LeftButtonDownHandler()
    Define.i X, Y
    Define.i GadgetNum = EventGadget()
    
    If FindMapElement(Calendar(), Str(GadgetNum))
      
      X = GetGadgetAttribute(Calendar()\CanvasNum, #PB_Canvas_MouseX)
      Y = GetGadgetAttribute(Calendar()\CanvasNum, #PB_Canvas_MouseY) 
      
      If Calendar()\Month\State = #Change : ChangeMonth_(#False) : EndIf
      If Calendar()\Year\State  = #Change : ChangeYear_(#False)  : EndIf
      
    EndIf
    
  EndProcedure

  Procedure _LeftButtonUpHandler()  
    Define.i X, Y, Angle
    Define.i GadgetNum = EventGadget()
    
    If FindMapElement(Calendar(), Str(GadgetNum))
      
      X = GetGadgetAttribute(Calendar()\CanvasNum, #PB_Canvas_MouseX)
      Y = GetGadgetAttribute(Calendar()\CanvasNum, #PB_Canvas_MouseY)
      
      ;{ Buttons: Previous & Next
      If Calendar()\Flags & #FixMonth = #False
        If Y >= Calendar()\Button\Y And Y <= Calendar()\Button\Y + Calendar()\Button\Height
          If X >= Calendar()\Button\prevX And X <= Calendar()\Button\prevX + Calendar()\Button\Width
            Calendar()\Current\Date  = AddDate(Calendar()\Current\Date, #PB_Date_Month, -1)
            Calendar()\Current\Month = Month(Calendar()\Current\Date)
            Calendar()\Current\Year  = Year(Calendar()\Current\Date)
            Draw_()
            ProcedureReturn #True
          ElseIf X >= Calendar()\Button\nextX And X <= Calendar()\Button\nextX + Calendar()\Button\Width
            Calendar()\Current\Date  = AddDate(Calendar()\Current\Date, #PB_Date_Month, 1)
            Calendar()\Current\Month = Month(Calendar()\Current\Date)
            Calendar()\Current\Year  = Year(Calendar()\Current\Date)
            Draw_()
            ProcedureReturn #True
          EndIf
        EndIf  
      EndIf ;}
      
      ;{ Click: Month & Year
      If Y >= Calendar()\PostEvent\Y And Y <= Calendar()\PostEvent\Y + Calendar()\PostEvent\Height
        If X >= Calendar()\PostEvent\MonthX And X <= Calendar()\PostEvent\MonthX + Calendar()\PostEvent\MonthWidth
 
          If Calendar()\Month\Flags & #PostEvent
            PostEvent(#Event_Gadget,    Calendar()\Window\Num, Calendar()\CanvasNum, #EventType_Month)
            PostEvent(#PB_Event_Gadget, Calendar()\Window\Num, Calendar()\CanvasNum, #EventType_Month)
            ProcedureReturn #True
          Else
            ChangeMonth_()
            ProcedureReturn #True
          EndIf
          
        ElseIf X >= Calendar()\PostEvent\YearX And X <= Calendar()\PostEvent\YearX + Calendar()\PostEvent\YearWidth
          
          If Calendar()\Year\Flags & #PostEvent
            PostEvent(#Event_Gadget,    Calendar()\Window\Num, Calendar()\CanvasNum, #EventType_Year)
            PostEvent(#PB_Event_Gadget, Calendar()\Window\Num, Calendar()\CanvasNum, #EventType_Year)
            ProcedureReturn #True
          ElseIf Calendar()\Year\State = #False
            ChangeYear_(#True) 
            ProcedureReturn #True
          EndIf
          
        EndIf
      EndIf ;} 
      
      ;{ Click: Days of Month
      If Calendar()\Flags & #FixDayOfMonth = #False
        If Y > Calendar()\Week\Y + Calendar()\Week\Height
          ForEach Calendar()\Day()
            If Y >= Calendar()\Day()\Y And Y <= Calendar()\Day()\Y + Calendar()\Day()\Height
              If X >= Calendar()\Day()\X And X <= Calendar()\Day()\X + Calendar()\Day()\Width
                Calendar()\Current\Focus = Date(Calendar()\Current\Year, Calendar()\Current\Month, Val(MapKey(Calendar()\Day())), 0, 0, 0)
                Draw_()
                ProcedureReturn #True
              EndIf
            EndIf
          Next
        EndIf   
      EndIf ;}
      
    EndIf
    
  EndProcedure

  Procedure _MouseMoveHandler()
    Define.i X, Y
    Define.i GadgetNum = EventGadget()
    
    If FindMapElement(Calendar(), Str(GadgetNum))
      
      X = GetGadgetAttribute(GadgetNum, #PB_Canvas_MouseX)
      Y = GetGadgetAttribute(GadgetNum, #PB_Canvas_MouseY)
      
      ;{ Buttons: Previous & Next
      If Y >= Calendar()\Button\Y And Y <= Calendar()\Button\Y + Calendar()\Button\Height
        If X >= Calendar()\Button\prevX And X <= Calendar()\Button\prevX + Calendar()\Button\Width
          SetGadgetAttribute(GadgetNum, #PB_Canvas_Cursor, #PB_Cursor_Hand)
          ProcedureReturn #True
        ElseIf X >= Calendar()\Button\nextX And X <= Calendar()\Button\nextX + Calendar()\Button\Width
          SetGadgetAttribute(GadgetNum, #PB_Canvas_Cursor, #PB_Cursor_Hand)
          ProcedureReturn #True
        EndIf
      EndIf ;}
      
      ;{ Month & Year
      If Y > Calendar()\PostEvent\Y And Y < Calendar()\PostEvent\Y + Calendar()\PostEvent\Height
        If X > Calendar()\PostEvent\MonthX And X < Calendar()\PostEvent\MonthX + Calendar()\PostEvent\MonthWidth
          If Calendar()\Month\Flags & #PostEvent Or Calendar()\Month\Flags & #FixMonth = #False
            SetGadgetAttribute(GadgetNum, #PB_Canvas_Cursor, #PB_Cursor_Hand)
          EndIf 
          ProcedureReturn #True
        ElseIf X > Calendar()\PostEvent\YearX And X < Calendar()\PostEvent\YearX + Calendar()\PostEvent\YearWidth 
          If Calendar()\Year\Flags & #PostEvent Or Calendar()\Month\Flags & #FixYear = #False
            SetGadgetAttribute(GadgetNum, #PB_Canvas_Cursor, #PB_Cursor_Hand)
          EndIf
          ProcedureReturn #True
        EndIf
      EndIf ;}
      
      SetGadgetAttribute(GadgetNum, #PB_Canvas_Cursor, #PB_Cursor_Default)
      
      ;{ Days of Month
      If Y > Calendar()\Week\Y + Calendar()\Week\Height
        
        If Calendar()\Year\State = #Change : ChangeYear_(#False) : EndIf
        
        ForEach Calendar()\Day()
          If Y >= Calendar()\Day()\Y And Y <= Calendar()\Day()\Y + Calendar()\Day()\Height
            If X >= Calendar()\Day()\X And X <= Calendar()\Day()\X + Calendar()\Day()\Width

              If Calendar()\ToolTip = #False
                Calendar()\ToolTip = Val(MapKey(Calendar()\Day()))
                GadgetToolTip(GadgetNum, Calendar()\Day()\ToolTip)
              ElseIf Calendar()\ToolTip <> Val(MapKey(Calendar()\Day()))
                Calendar()\ToolTip = #False
                GadgetToolTip(GadgetNum, "")
              EndIf
              
              If Calendar()\Flags & #FixDayOfMonth = #False
                SetGadgetAttribute(GadgetNum, #PB_Canvas_Cursor, #PB_Cursor_Hand)
              EndIf
              
              ProcedureReturn #True
            EndIf
          EndIf
        Next
      EndIf ;}
      
      SetGadgetAttribute(GadgetNum, #PB_Canvas_Cursor, #PB_Cursor_Default)
      
      Calendar()\ToolTip = #False
      GadgetToolTip(GadgetNum, "")
      
    EndIf
    
  EndProcedure  
  
  
  Procedure _ResizeHandler()
    Define.i GadgetID = EventGadget()
    
    If FindMapElement(Calendar(), Str(GadgetID))
      
      Calendar()\Size\Width  = dpiX(GadgetWidth(GadgetID))
      Calendar()\Size\Height = dpiY(GadgetHeight(GadgetID))
      
      Draw_()
    EndIf  
 
  EndProcedure
  
  Procedure _ResizeWindowHandler()
    Define.f X, Y, Width, Height
    Define.f OffSetX, OffSetY
    
    ForEach Calendar()
      
      If IsGadget(Calendar()\CanvasNum)
        
        If Calendar()\Flags & #AutoResize
          
          If IsWindow(Calendar()\Window\Num)
            
            OffSetX = WindowWidth(Calendar()\Window\Num)  - Calendar()\Window\Width
            OffsetY = WindowHeight(Calendar()\Window\Num) - Calendar()\Window\Height

            Calendar()\Window\Width  = WindowWidth(Calendar()\Window\Num)
            Calendar()\Window\Height = WindowHeight(Calendar()\Window\Num)
            
            If Calendar()\Size\Flags
              
              X = #PB_Ignore : Y = #PB_Ignore : Width = #PB_Ignore : Height = #PB_Ignore
              
              If Calendar()\Size\Flags & #MoveX : X = GadgetX(Calendar()\CanvasNum) + OffSetX : EndIf
              If Calendar()\Size\Flags & #MoveY : Y = GadgetY(Calendar()\CanvasNum) + OffSetY : EndIf
              If Calendar()\Size\Flags & #ResizeWidth  : Width  = GadgetWidth(Calendar()\CanvasNum)  + OffSetX : EndIf
              If Calendar()\Size\Flags & #ResizeHeight : Height = GadgetHeight(Calendar()\CanvasNum) + OffSetY : EndIf
              
              ResizeGadget(Calendar()\CanvasNum, X, Y, Width, Height)
              
            Else
              ResizeGadget(Calendar()\CanvasNum, #PB_Ignore, #PB_Ignore, GadgetWidth(Calendar()\CanvasNum) + OffSetX, GadgetHeight(Calendar()\CanvasNum) + OffsetY)
            EndIf
          
            Draw_()
          EndIf
          
        EndIf
        
      EndIf
      
    Next
    
  EndProcedure

  ;- ==========================================================================
  ;-   Module - Declared Procedures
  ;- ========================================================================== 
  
  Procedure AddEntry()
    
    
  EndProcedure
  
  Procedure   AttachPopupMenu(GNum.i, PopUpNum.i)
    
    If FindMapElement(Calendar(), Str(GNum))
      Calendar()\PopupNum = PopUpNum
    EndIf
    
  EndProcedure  
  
  Procedure   DisableReDraw(GNum.i, State.i=#False)
    
    If FindMapElement(Calendar(), Str(GNum))
      
      If State
        Calendar()\ReDraw = #False
      Else
        Calendar()\ReDraw = #True
        Draw_()
      EndIf
      
    EndIf
    
  EndProcedure  
  
  Procedure.i Gadget(GNum.i, X.i, Y.i, Width.i, Height.i, Flags.i=#False, WindowNum.i=#PB_Default)
    Define d, m, DummyNum, Result.i
    
    Result = CanvasGadget(GNum, X, Y, Width, Height, #PB_Canvas_Container)
    If Result
      
      If GNum = #PB_Any : GNum = Result : EndIf
      
      X      = dpiX(X)
      Y      = dpiY(Y)
      Width  = dpiX(Width)
      Height = dpiY(Height)
      
      If AddMapElement(Calendar(), Str(GNum))
        
        Calendar()\CanvasNum = GNum
      
        CompilerIf Defined(ModuleEx, #PB_Module) ; WindowNum = #Default
          If WindowNum = #PB_Default
            Calendar()\Window\Num = ModuleEx::GetGadgetWindow()
          Else
            Calendar()\Window\Num = WindowNum
          EndIf
        CompilerElse
          If WindowNum = #PB_Default
            Calendar()\Window\Num = GetActiveWindow()
          Else
            Calendar()\Window\Num = WindowNum
          EndIf
        CompilerEndIf
        
        CompilerSelect #PB_Compiler_OS           ;{ Default Gadget Font
          CompilerCase #PB_OS_Windows
            Calendar()\FontID = GetGadgetFont(#PB_Default)
          CompilerCase #PB_OS_MacOS
            DummyNum = TextGadget(#PB_Any, 0, 0, 0, 0, " ")
            If DummyNum
              Calendar()\FontID = GetGadgetFont(DummyNum)
              FreeGadget(DummyNum)
            EndIf
          CompilerCase #PB_OS_Linux
            Calendar()\FontID = GetGadgetFont(#PB_Default)
        CompilerEndSelect ;}
        
        Calendar()\SpinNum = SpinGadget(#PB_Any, 0, 0, 0, 0, 1970, 2032, #PB_Spin_Numeric|#PB_Spin_ReadOnly)
        If Calendar()\SpinNum
          HideGadget(Calendar()\SpinNum, #True)
        EndIf
        
        Months_(CountryCode)
        WeekDays_(CountryCode)
        
        Calendar()\ListNum = ListViewGadget(#PB_Any, 0, 0, 0, 0)
        If Calendar()\ListNum
          SetGadgetData(Calendar()\ListNum, Calendar()\CanvasNum)
          HideGadget(Calendar()\ListNum, #True)
          For m=1 To 12
            AddGadgetItem(Calendar()\ListNum, -1, Calendar()\Month\Name(Str(m)))
          Next
        EndIf
        
        CloseGadgetList()
        
        Calendar()\Size\X = X
        Calendar()\Size\Y = Y
        Calendar()\Size\Width  = Width
        Calendar()\Size\Height = Height
        
        Calendar()\Margin\Left   = 0
        Calendar()\Margin\Right  = 0
        Calendar()\Margin\Top    = 0
        Calendar()\Margin\Bottom = 0
        
        Calendar()\Month\Spacing     = 8
        Calendar()\Month\defHeight   = #PB_Default
        Calendar()\Month\Color\Front = #PB_Default
        Calendar()\Month\Color\Back  = #PB_Default
        
        Calendar()\Week\defHeight    = #PB_Default
        Calendar()\Week\Color\Front  = #PB_Default
        Calendar()\Week\Color\Back   = #PB_Default
        
        Calendar()\Flags  = Flags
        
        If Calendar()\Flags & #PostEvent
          Calendar()\Month\Flags | #PostEvent
          Calendar()\Year\Flags  | #PostEvent
        EndIf
        
        Calendar()\ReDraw = #True
        
        Calendar()\Color\Arrow  = $E3E3E3
        Calendar()\Color\Back   = $FFFFFF
        Calendar()\Color\Border = $A0A0A0
        Calendar()\Color\Gadget = $EDEDED
        Calendar()\Color\Entry  = $0000CC
        Calendar()\Color\Focus  = $D77800
        Calendar()\Color\Front  = $000000
        Calendar()\Color\Line   = $B4B4B4

        CompilerSelect #PB_Compiler_OS ;{ Color
          CompilerCase #PB_OS_Windows
            Calendar()\Color\Arrow  = GetSysColor_(#COLOR_3DLIGHT)
            Calendar()\Color\Back   = GetSysColor_(#COLOR_WINDOW)
            Calendar()\Color\Border = GetSysColor_(#COLOR_WINDOWFRAME)
            Calendar()\Color\Focus  = GetSysColor_(#COLOR_MENUHILIGHT)
            Calendar()\Color\Front  = GetSysColor_(#COLOR_WINDOWTEXT)
            Calendar()\Color\Gadget = GetSysColor_(#COLOR_MENU)
            Calendar()\Color\Line   = GetSysColor_(#COLOR_ACTIVEBORDER)
          CompilerCase #PB_OS_MacOS
            Calendar()\Color\Arrow  = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor controlBackgroundColor"))
            Calendar()\Color\Back   = BlendColor_(OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor textBackgroundColor")), $FFFFFF, 80)
            Calendar()\Color\Border = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor grayColor"))
            Calendar()\Color\Gadget = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor windowBackgroundColor"))
            Calendar()\Color\Focus  = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor selectedControlColor"))
            Calendar()\Color\Front  = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor textColor"))
            Calendar()\Color\Line   = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor grayColor"))
          CompilerCase #PB_OS_Linux

        CompilerEndSelect ;} 
        
        BindGadgetEvent(Calendar()\CanvasNum,  @_ResizeHandler(),          #PB_EventType_Resize)
        BindGadgetEvent(Calendar()\CanvasNum,  @_RightClickHandler(),      #PB_EventType_RightClick)
        BindGadgetEvent(Calendar()\CanvasNum,  @_LeftDoubleClickHandler(), #PB_EventType_LeftDoubleClick)
        BindGadgetEvent(Calendar()\CanvasNum,  @_MouseMoveHandler(),       #PB_EventType_MouseMove)
        BindGadgetEvent(Calendar()\CanvasNum,  @_LeftButtonDownHandler(),  #PB_EventType_LeftButtonDown)
        BindGadgetEvent(Calendar()\CanvasNum,  @_LeftButtonUpHandler(),    #PB_EventType_LeftButtonUp)
        
        If IsGadget(Calendar()\ListNum)
          BindGadgetEvent(Calendar()\ListNum, @_ListGadgetHandler(), #PB_EventType_LeftClick)
        EndIf 
      
        If Flags & #AutoResize ;{ Enabel AutoResize
          If IsWindow(Calendar()\Window\Num)
            Calendar()\Window\Width  = WindowWidth(Calendar()\Window\Num)
            Calendar()\Window\Height = WindowHeight(Calendar()\Window\Num)
            BindEvent(#PB_Event_SizeWindow, @_ResizeWindowHandler(), Calendar()\Window\Num)
          EndIf  
        EndIf ;}

        Draw_()
        
        ProcedureReturn GNum
      EndIf
     
    EndIf
    
  EndProcedure    
  
  Procedure.i GetDay(GNum.i) 
    
    If FindMapElement(Calendar(), Str(GNum))
      ProcedureReturn Day(Calendar()\Current\Focus)
    EndIf
    
  EndProcedure
  
  Procedure.i GetMonth(GNum.i) 
    
    If FindMapElement(Calendar(), Str(GNum))
      ProcedureReturn Month(Calendar()\Current\Focus)
    EndIf
    
  EndProcedure
  
  Procedure.i GetYear(GNum.i) 
    
    If FindMapElement(Calendar(), Str(GNum))
      ProcedureReturn Year(Calendar()\Current\Focus)
    EndIf
    
  EndProcedure
  
  Procedure.i GetState(GNum.i) 
    
    If FindMapElement(Calendar(), Str(GNum))
      ProcedureReturn Calendar()\Current\Focus
    EndIf
    
  EndProcedure  
  
  Procedure   SetAttribute(GNum.i, Attribute.i, Value.i)
    
    If FindMapElement(Calendar(), Str(GNum))
      
      Select Attribute
        Case #Spacing
          Calendar()\Month\Spacing   = dpiX(Value)
        Case #Height_Month
          Calendar()\Month\defHeight = dpiY(Value)
        Case #Height_WeekDays
          Calendar()\Week\defHeight     = dpiY(Value)
      EndSelect
      
      If Calendar()\ReDraw : Draw_() : EndIf
    EndIf  
    
  EndProcedure 
  
  Procedure   SetAutoResizeFlags(GNum.i, Flags.i)
    
    If FindMapElement(Calendar(), Str(GNum))
      
      Calendar()\Size\Flags = Flags
      Calendar()\Flags | #AutoResize
      
    EndIf  
   
  EndProcedure
  
  Procedure   SetColor(GNum.i, ColorTyp.i, Value.i)
    
    If FindMapElement(Calendar(), Str(GNum))
    
      Select ColorTyp
        Case #ArrowColor
          Calendar()\Color\Arrow       = Value  
        Case #BackColor
          Calendar()\Color\Back        = Value
        Case #BorderColor
          Calendar()\Color\Border      = Value          
        Case #FrontColor
          Calendar()\Color\Front       = Value        
        Case #FocusColor
          Calendar()\Color\Focus       = Value  
        Case #LineColor
          Calendar()\Color\Line        = Value
        Case #EntryColor
          Calendar()\Color\Entry       = Value
        Case #Entry_FrontColor
          Calendar()\Color\EntryFront  = Value
        Case #Entry_BackColor
          Calendar()\Color\EntryBack   = Value
        Case #Month_FrontColor
          Calendar()\Month\Color\Front = Value
          ;If IsGadget(Calendar()\SpinNum) : SetGadgetColor(Calendar()\SpinNum, #PB_Gadget_FrontColor, Value) : EndIf
        Case #Month_BackColor
          Calendar()\Month\Color\Back  = Value
          ;If IsGadget(Calendar()\SpinNum) : SetGadgetColor(Calendar()\SpinNum, #PB_Gadget_BackColor, Value) : EndIf
        Case #Week_FrontColor
          Calendar()\Week\Color\Front  = Value
        Case #Week_BackColor  
          Calendar()\Week\Color\Back   = Value
      EndSelect
      
      If Calendar()\ReDraw : Draw_() : EndIf
    EndIf
    
  EndProcedure  
  
  Procedure   SetFlags(GNum.i, Type.i, Flags.i)
    
    If FindMapElement(Calendar(), Str(GNum))
      
      Select Type
        Case #Month
          Calendar()\Month\Flags | Flags
        Case #Year
          Calendar()\Year\Flags  | Flags
        Case #Gadget
          Calendar()\Flags | Flags
      EndSelect
      
      If Calendar()\ReDraw : Draw_() : EndIf
    EndIf 
    
  EndProcedure
  
  Procedure   SetFont(GNum.i, FontNum.i, FontType.i=#Font_Gadget) 
    
    If FindMapElement(Calendar(), Str(GNum))
      
      Select FontType
        Case #Font_Month
          Calendar()\Month\Font = FontNum
        Case #Font_Weekdays
          Calendar()\Week\Font  = FontNum
        Default
          Calendar()\FontID     = FontID(FontNum)
      EndSelect
      
      If Calendar()\ReDraw : Draw_() : EndIf
    EndIf
    
  EndProcedure  
  
  Procedure   SetState(GNum.i, Date.i) 
    
    If FindMapElement(Calendar(), Str(GNum))
      
      Calendar()\Current\Date  = Date
      Calendar()\Current\Focus = Date
      Calendar()\Current\Month = Month(Date)
      Calendar()\Current\Year  = Year(Date)
      
      If Calendar()\ReDraw : Draw_() : EndIf
    EndIf
    
  EndProcedure  
  
  Procedure DefaultCountry(Code.s)
    CountryCode = Code
  EndProcedure
  
  Procedure MonthName(Month.i, Name.s)
    If Month >= 1 And Month <= 12
      NameOfMonth(Str(Month)) = Name
    EndIf
  EndProcedure
  
  Procedure WeekDayName(WeekDay.i, Name.s)
    If WeekDay >= 0 And WeekDay <= 7
      If WeekDay = 0
        NameOfWeekDay("7") = Name
      Else
        NameOfWeekDay(Str(WeekDay)) = Name
      EndIf
    EndIf
  EndProcedure
  
EndModule


;- ========  Module - Example ========

CompilerIf #PB_Compiler_IsMainFile
  
  Calendar::DefaultCountry("DE")
  
  Enumeration 1
    #Window
    #Calendar
  EndEnumeration
  
  Enumeration 1
    #FontGadget
    #FontMonth
    #FontWeekDays
  EndEnumeration  
  
  LoadFont(#FontMonth,    "Arial", 10, #PB_Font_Bold)
  LoadFont(#FontWeekDays, "Arial",  9, #PB_Font_Bold)
  
  If OpenWindow(#Window, 0, 0, 300, 200, "Example", #PB_Window_SystemMenu|#PB_Window_Tool|#PB_Window_ScreenCentered|#PB_Window_SizeGadget)

    If Calendar::Gadget(#Calendar, 10, 10, 280, 180, #False, #Window) ; Calendar::#PostEvent|Calendar::#FixDayOfMonth|Calendar::#FixMonth|Calendar::#FixYear
      
      Calendar::SetFont(#Calendar, #FontMonth, Calendar::#Font_Month)
      Calendar::SetColor(#Calendar, Calendar::#Month_FrontColor, $FFF8F0)
      Calendar::SetColor(#Calendar, Calendar::#Month_BackColor,  $701919)
      Calendar::SetAttribute(#Calendar, Calendar::#Height_Month, 28)
      
      Calendar::SetFont(#Calendar, #FontWeekDays, Calendar::#Font_Weekdays)
      Calendar::SetColor(#Calendar, Calendar::#Week_FrontColor, $701919)
      Calendar::SetColor(#Calendar, Calendar::#Week_BackColor,  $FFFAF6)
      Calendar::SetAttribute(#Calendar, Calendar::#Height_WeekDays, 22)
      
      ;Calendar::SetColor(#Calendar, Calendar::#FocusColor, $00FC7C)
      
      Calendar::SetState(#Calendar, Date())
    EndIf
    
    Repeat
      Event = WaitWindowEvent()
      Select Event
        Case Calendar::#Event_Gadget ;{ Module Events
          Select EventGadget()  
            Case #Calendar
              Select EventType()
                Case Calendar::#EventType_Month
                  ; 
                Case Calendar::#EventType_Year
                  ; 
                Case #PB_EventType_LeftClick       ;{ Left mouse click
                  Debug "Left Click"
                  ;}
                Case #PB_EventType_LeftDoubleClick ;{ LeftDoubleClick
                  Debug "Left DoubleClick"
                  ;}
                Case #PB_EventType_RightClick      ;{ Right mouse click
                  Debug "Right Click"
                  ;}
              EndSelect
          EndSelect ;}
        Case #PB_Event_Gadget  
          Select EventGadget()
            Case #Calendar      ;{ only in use with EventType()  
              Select EventType()
                Case Calendar::#EventType_Month
                  Debug "Select: Month"
                Case Calendar::#EventType_Year
                  Debug "Select: Year"
              EndSelect ;}
          EndSelect  
      EndSelect        
    Until Event = #PB_Event_CloseWindow

    CloseWindow(#Window)
  EndIf 
  
CompilerEndIf

; IDE Options = PureBasic 5.71 beta 2 LTS (Windows - x86)
; CursorPosition = 1619
; FirstLine = 463
; Folding = 98ADAAAwlIEkAAU+
; EnableXP
; DPIAware