;/ ============================
;/ =   ToolBarExModule.pbi    =
;/ ============================
;/
;/ [ PB V5.7x - &.0 / 64Bit / All OS / DPI ]
;/
;/ Extended ToolBar Gadget
;/
;/ © 2022 Thorsten1867 (03/2019)
;/

; Last Update: 27.06.22
;
; Optimisations
;
; ToolBar::Disable()
; Bugfixes
; DPI-Handling
;

;{ ===== MIT License =====
;
; Copyright (c) 2022 Thorsten Hoeppner
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

;{ ===== Additional tea & pizza license =====
; <purebasic@thprogs.de> has created this code. 
; If you find the code useful and you want to use it for your programs, 
; you are welcome to support my work with a cup of tea or a pizza
; (or the amount of money for it). 
; [ https://www.paypal.me/Hoeppner1867 ]
;}


;{ _____ ListEx - Commands _____

; ToolBar::AddItem()              - similar to 'AddGadgetItem()'
; ToolBar::AttachPopupMenu()      - attachs a popup menu to the button
; ToolBar::Button()               - simple toolbar button (text only)
; ToolBar::ButtonText()           - similar to 'ToolBarButtonText()'
; ToolBar::ComboBox()             - adds a ComboBox to the toolbar
; ToolBar::Disable()              - disable the toolbar
; ToolBar::DisableButton()        - similar to 'DisableToolBarButton()'
; ToolBar::DisableReDraw()        - disable/enable redrawing
; ToolBar::Separator()            - similar to 'ToolBarSeparator()'
; ToolBar::EventNumber()          - returns the event number (integer) of the toolbar button
; ToolBar::EventID()              - returns the event ID (string) of the toolbar button
; ToolBar::EventState()           - returns the state of a toolbar gadget (e.g. ComboBox)
; ToolBar::Free()                 - similar to 'FreeToolBar()'
; ToolBar::Gadget()               - similar to 'CreateToolBar()'
; ToolBar::GetAttribute()         - similar to 'GetGadgetAttribute()'
; ToolBar::GetIndex()             - returns item index of the corresponding event number
; ToolBar::GetIndexFromID()       - returns item index of the corresponding event ID
; ToolBar::GetGadgetNumber()      - returns the gadget number of the gadget at index position
; ToolBar::GetItemState()         - similar to 'GetGadgetState()'
; ToolBar::GetItemText()          - similar to 'GetGadgetText()'
; ToolBar::ImageButton()          - similar to 'ToolBarImageButton()'
; ToolBar::HideButton()           - hide button
; ToolBar::Height()               - similar to 'ToolBarHeight()'
; ToolBar::SetAutoResizeFlags()   - [#MoveX|#MoveY|#ResizeWidth|#ResizeHeight]
; ToolBar::SetAttribute()         - similar to 'SetGadgetColor()'
; ToolBar::SetColor()             - similar to 'SetGadgetAttribute()'
; ToolBar::SetFont()              - similar to 'SetGadgetFont()'
; ToolBar::SetItemFlags()         - [#Top/#Bottom]
; ToolBar::SetPostEvent()         - changes PostEvent [#PB_Event_Gadget/#PB_Event_Menu]
; ToolBar::SetSpinAttribute()     - similar to 'SetGadgetAttribute()' for the SpinGadget [#PB_Spin_Minimum/#PB_Spin_Maximum]
; ToolBar::SetItemState()         - similar to 'SetGadgetState()'
; ToolBar::SetItemText()          - similar to 'SetGadgetText()'
; ToolBar::Spacer()               - inserts available space between buttons
; ToolBar::SpinBox()              - adds a SpinGadget to the toolbar
; ToolBar::ToolTip()              - similar to 'ToolBarToolTip()'
; ToolBar::TextButton()           - similar to 'ButtonGadget()'

;} -----------------------------

; XIncludeFile "ModuleEx.pbi"

DeclareModule ToolBar
  
  #Version  = 22062100
  #ModuleEx = 19112500
  
  #EnableToolBarGadgets = #True
  
  ;- ===========================================================================
  ;-   DeclareModule - Constants
  ;- ===========================================================================  

  ;{ ____ Constants_____
  #Top    = 1
  #Bottom = 2
  
  EnumerationBinary Gadget
    #ImageSize_16 = #PB_ToolBar_Small
    #ImageSize_24 = #PB_ToolBar_Large
    #ButtonText   = #PB_ToolBar_Text
    #InlineText   = #PB_ToolBar_InlineText ; [not all OS!]
    #ImageSize_32
    #AutoResize
    #AdjustHeight
    #AdjustButtons
    #AdjustAllButtons
    #RoundFocus
    #Border
    #ToolTips
    #TextInside
    #UseExistingCanvas
  EndEnumeration
  
  Enumeration Attribute 1
    #Height
    #Spacing
    #ButtonHeight
    #ButtonWidth
    #ButtonSpacing
  EndEnumeration

  EnumerationBinary Resize
    #MoveX
    #MoveY
    #ResizeWidth
    #ResizeHeight
  EndEnumeration 
  
  Enumeration Color 1 
    #FrontColor
    #BackColor
    #FocusColor
    #SeparatorColor
    #BorderColor
  EndEnumeration


  #Event_Menu   = #PB_Event_Menu 
  
  CompilerIf Defined(ModuleEx, #PB_Module)
    
    #Event_Gadget          = ModuleEx::#Event_Gadget
    #Event_Theme           = ModuleEx::#Event_Theme
    
    #EventType_ImageButton = ModuleEx::#EventType_ImageButton
    #EventType_TextButton  = ModuleEx::#EventType_TextButton
    #EventType_ComboBox    = ModuleEx::#EventType_ComboBox
    #EventType_SpinBox     = ModuleEx::#EventType_SpinBox
    #EventType_Button      = ModuleEx::#EventType_Button
    #EventType_TrackBar    = ModuleEx::#EventType_TrackBar
    #EventType_DropDown    = ModuleEx::#EventType_DropDown

  CompilerElse
    
    Enumeration #PB_Event_FirstCustomValue
      #Event_Gadget
    EndEnumeration

    Enumeration #PB_EventType_FirstCustomValue
      #EventType_ImageButton
      #EventType_TextButton
      #EventType_Button
      #EventType_ComboBox
      #EventType_SpinBox
      #EventType_TrackBar
      #EventType_DropDown
    EndEnumeration
    
  CompilerEndIf
  ;}
  
  ;- ===========================================================================
  ;-   DeclareModule - Procedures
  ;- ===========================================================================
  
  Declare   AttachPopupMenu(GNum.i, TB_Index.i, MenuNum.i, EventNum.i=#PB_Default) 
  Declare   ClearItems(GNum.i)
  Declare   Disable(GNum.i, State.i)
  Declare   DisableButton(GNum.i, TB_Index.i, State.i)
  Declare   DisableRedraw(GNum.i, State.i=#False)
  Declare.s EventID(GNum.i)
  Declare.i EventNumber(GNum.i)
  Declare.i EventState(GNum.i)
  Declare   Free(GNum.i)
  Declare.i Gadget(GNum.i, X.i=#PB_Ignore, Y.i=#PB_Ignore, Width.i=#PB_Ignore, Height.i=#PB_Ignore, Flags.i=#False, WindowNum.i=#PB_Default)
  Declare.i GetAttribute(GNum.i, Attribute.i)
  Declare.i GetGadgetNumber(GNum.i, TB_Index.i)
  Declare.q GetData(GNum.i)
	Declare.s GetID(GNum.i)
  Declare.i GetIndex(GNum.i, EventNum.i)
  Declare.i GetIndexFromID(GNum.i, EventID.s) 
  Declare   Height(GNum.i)
  Declare   HideButton(GNum.i, TB_Index.i, State.i)
  Declare   Hide(GNum.i, State.i=#True)
  Declare   ImageButton(GNum.i, ImageNum.i, EventNum.i=#False, Text.s="", EventID.s="", Flags.i=#False)
  Declare   RemoveItem(GNum.i, Index.i)
  Declare   Separator(GNum.i, Width.i=#PB_Default)
  Declare   SetAutoResizeFlags(GNum.i, Flags.i)
  Declare   SetAttribute(GNum.i, Attribute.i, Value.i)
  Declare   SetColor(GNum.i, ColorType.i, Color.i)
  Declare   SetData(GNum.i, Value.q)
  Declare   SetFont(GNum.i, FontID.i)
  Declare   SetID(GNum.i, String.s)
  Declare   SetPostEvent(GNum.i, Event.i=#Event_Gadget) 
  Declare   Spacer(GNum.i)
  Declare   TextButton(GNum.i, Text.s="", EventNum.i=#False, EventID.s="", Flags.i=#False)
  Declare   ToolTip(GNum.i, TB_Index.i, Text.s, EventNum.i=#PB_Default) 
  
  CompilerIf #EnableToolBarGadgets
    
    Declare   AddItem(GNum.i, TB_Index.i, Position, Text.s, ImageID.i=#False)
    Declare   ButtonText(GNum.i, TB_Index.i, Text.s)
    Declare   ComboBox(GNum.i, Width.i, Height.i, EventNum.i=#PB_Ignore, Text.s="", EventID.s="", Flags.i=#False)
    Declare.i GetItemState(GNum.i, TB_Index.i)
    Declare.s GetItemText(GNum.i, TB_Index.i)
    Declare   SetItemFlags(GNum.i, TB_Index.i, Flags.i)
    Declare   SetItemAttribute(GNum.i, TB_Index.i, Attribute.i, Value.i)
    Declare   SetItemState(GNum.i, TB_Index.i, State.i)
    Declare   SetItemText(GNum.i, TB_Index.i, Text.s)
    Declare.i SpinBox(GNum.i, Width.i, Height.i, Minimum.i, Maximum.i, EventNum.i=#PB_Ignore, Text.s="", EventID.s="", Flags.i=#False)
    Declare.i Button(GNum.i, Width.i, Height.i, Text.s, EventNum.i=#PB_Ignore, EventID.s="", Flags.i=#False)
    Declare.i TrackBar(GNum.i, Width.i, Height.i, Minimum.i, Maximum.i, EventNum.i=#PB_Ignore, EventID.s="", Flags.i=#False)
    
  CompilerEndIf
  
EndDeclareModule

Module ToolBar
  
  EnableExplicit
  
  UsePNGImageDecoder()
  
  ;- ===========================================================================
  ;-   Module - Constants / Structures
  ;- ===========================================================================  
  
  #NoFocus     = -1
  #NoIndex     = -1
  #NotSelected = -1
  #NotValid    = -1
  #Round = 7

  EnumerationBinary ItemFlags
    #Top    = 1 ; must be 1
    #Bottom = 2 ; must be 2
    #Click
    #Focus
    #Disable
    #Hide
    #FocusLost
  EndEnumeration
  
  Enumeration Items 1
    #ImageButton
    #TextButton
    #Button
    #ComboBox
    #Separator
    #Spacer
    #SpinGadget
    #TrackBar
  EndEnumeration
  
  Structure TBEx_Event_Structure     ;{ TBEx()\Event\...
    Type.i
    btIndex.i
    Num.i
    ID.s
    State.i
  EndStructure ;}
  
  Structure TBEx_Color_Structure     ;{ TBEx()\Color\...
    Front.i
    Back.i
    Focus.i
    Border.i
    GrayText.i
    Separator.i
  EndStructure ;}
  
  Structure TBEx_Window_Structure    ;{ TBEx()\Window\...
    Num.i
    Width.f
    Height.i
  EndStructure ;}
  
  Structure TBEx_Size_Structure      ;{ TBEx()\Size\...
    X.f
    Y.f
    Width.f
    Height.f
    Spacing.f
    Items.f
    Flags.i
  EndStructure ;}
  
  Structure TBEx_Images_Structure    ;{ TBEx()\Images\...
    Width.i
    Height.i
  EndStructure ;}
  
  Structure TBEx_Items_Structure     ;{ TBEx()\Items\...
    Num.i
    Type.i
    X.i
    Y.i
    cX.i
    cY.i
    Width.i
    Height.i
    Text.s
    ToolTip.s
    Event.i
    EventID.s
    PopupMenu.i
    State.i
    Flags.i
    ImageNum.i
    Image.TBEx_Images_Structure
  EndStructure ;}
  
  Structure TBEx_Button_Structure    ;{ TBEx()\Buttons\...
    X.i
    Y.i
    Width.i
    Height.i
    Spacing.i
    LastX.f
    txtHeight.f
    Focus.i
    State.i
  EndStructure ;}
  
  
  Structure ToolBarEx_Structure   ;{ TBEx()\...
    
    CanvasNum.i
    
    Quad.q
    ID.s
    
    FontID.i
    
    Focus.i
    LastFocus.i 
    ReDraw.i    ; #True/#False
    Spacer.i    ; Number of spaacer
    Hide.i
    
    ToolTip.i
    
    PostEvent.i
    
    Event.TBEx_Event_Structure
    Color.TBEx_Color_Structure
    Window.TBEx_Window_Structure
    Size.TBEx_Size_Structure
    Buttons.TBEx_Button_Structure
    Images.TBEx_Images_Structure
    
    PopupMenu.i
    
    Flags.i
    
    List Items.TBEx_Items_Structure()

  EndStructure ;}  
  Global NewMap TBEx.ToolBarEx_Structure()
  
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
  
  CompilerIf Defined(ModuleEx, #PB_Module)
    
    Procedure.i GetGadgetWindow()
      ProcedureReturn ModuleEx::GetGadgetWindow()
    EndProcedure
    
  CompilerElse  
    
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      ; Thanks to mk-soft
      Import ""
        PB_Object_EnumerateStart(PB_Objects)
        PB_Object_EnumerateNext( PB_Objects, *ID.Integer )
        PB_Object_EnumerateAbort( PB_Objects )
        PB_Window_Objects.i
      EndImport
    CompilerElse
      ImportC ""
        PB_Object_EnumerateStart( PB_Objects )
        PB_Object_EnumerateNext( PB_Objects, *ID.Integer )
        PB_Object_EnumerateAbort( PB_Objects )
        PB_Window_Objects.i
      EndImport
    CompilerEndIf
    
    Procedure.i GetGadgetWindow()
      ; Thanks to mk-soft
      Define.i WindowID, Window, Result = #PB_Default
      
      WindowID = UseGadgetList(0)
      
      PB_Object_EnumerateStart(PB_Window_Objects)
      
      While PB_Object_EnumerateNext(PB_Window_Objects, @Window)
        If WindowID = WindowID(Window)
          Result = Window
          Break
        EndIf
      Wend
      
      PB_Object_EnumerateAbort(PB_Window_Objects)
      
      ProcedureReturn Result
    EndProcedure
    
  CompilerEndIf	  
  
  ;- ----- DPI -----
  
  Procedure.i dpiX(Num.i)
    ProcedureReturn DesktopScaledX(Num)
  EndProcedure
  
  Procedure.i dpiY(Num.i)
    ProcedureReturn DesktopScaledY(Num)
  EndProcedure
  
  
  Procedure TextHeight_(Text.s)
	  ProcedureReturn DesktopUnscaledY(TextHeight(Text))
	EndProcedure
	
	Procedure TextWidth_(Text.s)
	  ProcedureReturn DesktopUnscaledX(TextWidth(Text))
	EndProcedure  
	
	Procedure DrawText_(X.i, Y.i, Text.s, FrontColor.i=#PB_Default, BackColor.i=#PB_Default)
	  Define.i PosX
	  
	  If FrontColor = #PB_Default
	    PosX = DrawText(dpiX(X), dpiY(Y), Text)
	    ProcedureReturn DesktopUnscaledX(PosX)
	  ElseIf BackColor = #PB_Default
	    PosX = DrawText(dpiX(X), dpiY(Y), Text, FrontColor)
	    ProcedureReturn DesktopUnscaledX(PosX)
	  Else
	    PosX = DrawText(dpiX(X), dpiY(Y), Text, FrontColor, BackColor)
	    ProcedureReturn DesktopUnscaledX(PosX)
	  EndIf 
	  
	EndProcedure
  
  
  Procedure Box_(X.i, Y.i, Width.i, Height.i, Color.i, Rounded.i=#False)
		If Rounded
			RoundBox(dpiX(X), dpiY(Y), dpiX(Width), dpiY(Height), dpiX(Rounded), dpiY(Rounded), Color)
		Else
			Box(dpiX(X), dpiY(Y), dpiX(Width), dpiY(Height), Color)
		EndIf
	EndProcedure
	
	Procedure LineXY_(x1.i, y1.i, x2.i, y2.i, Color.i=#PB_Default)
	  If Color.i=#PB_Default
	    LineXY(dpiX(x1), dpiY(y1), dpiX(x2), dpiY(y2))
	  Else
	    LineXY(dpiX(x1), dpiY(y1), dpiX(x2), dpiY(y2), Color)
	  EndIf   
	EndProcedure
	
	Procedure Line_(X.i, Y.i, Width.i, Height.i, Color.i=#PB_Default)
	  If Color = #PB_Default
	    Line(dpiX(X), dpiY(Y), dpiX(Width), dpiY(Height))
	  Else  
	    Line(dpiX(X), dpiY(Y), dpiX(Width), dpiY(Height), Color)
	  EndIf   
	EndProcedure  
	
	Procedure DrawImage_(ImageID.i, X.i, Y.i, Width.i=#PB_Default, Height.i=#PB_Default)
	  If Width = #PB_Default And Height = #PB_Default
	    DrawImage(ImageID, dpiX(X), dpiY(Y))
	  Else
	    DrawImage(ImageID, dpiX(X), dpiY(Y), dpiX(Width), dpiY(Height))
	  EndIf  
	EndProcedure  
	
	Procedure DrawAlphaImage_(Image.i, X.i, Y.i, Alpha.i)
  	DrawAlphaImage(Image, dpiX(X), dpiY(Y), Alpha)
  EndProcedure

	Procedure FillArea_(X.i, Y.i, OutlineColor.i, FillColor.i=#PB_Default)
	  FillArea(dpiX(X), dpiY(Y), OutlineColor, FillColor)
	EndProcedure  
	
	Procedure ClipOutput_(X, Y, Width, Height)
    ClipOutput(dpiX(X), dpiY(Y), dpiX(Width), dpiY(Height)) 
  EndProcedure
  
  Procedure UnclipOutput_()
    UnclipOutput() 
  EndProcedure
	
  ;- -------------------
  
  Procedure.i GetAvailableSpace_()
    Define.i Space
    
    If ListSize(TBEx()\Items()) = 0 : ProcedureReturn TBEx()\Size\Width : EndIf
    
    PushListPosition(TBEx()\Items())
    
    Space = TBEx()\Size\Spacing * 2
    
    ForEach TBEx()\Items()
      
      Select TBEx()\Items()\Type
        Case #ImageButton, #TextButton
          Space + TBEx()\Items()\Width + TBEx()\Buttons\Spacing
        Case #Button, #ComboBox, #SpinGadget, #TrackBar
          Space + TBEx()\Items()\Width + TBEx()\Buttons\Spacing + 8
        Case #Separator
          Space + TBEx()\Items()\Width + TBEx()\Buttons\Spacing
      EndSelect    
    
    Next
    
    PopListPosition(TBEx()\Items())
    
    ProcedureReturn GadgetWidth(TBEx()\CanvasNum) - Space
  EndProcedure
  
  Procedure.i GetButtonY_(Bottom.i=#False)
    Define.f OffsetY
    
    OffSetY = (GadgetHeight(TBEx()\CanvasNum) - TBEx()\Buttons\Height - TBEx()\Buttons\txtHeight) / 2
    
    If Bottom
      ProcedureReturn OffsetY + TBEx()\Buttons\Height
    Else
      ProcedureReturn OffsetY
    EndIf
    
  EndProcedure
  
  Procedure   DisableToolTip_()
    
    If TBEx()\ToolTip
      TBEx()\ToolTip = #False
      GadgetToolTip(TBEx()\CanvasNum, "")
    EndIf

  EndProcedure
  
  Procedure GetIndex_(EventNum.i)
    
    ForEach TBEx()\Items()
      If TBEx()\Items()\Event = EventNum
        ProcedureReturn ListIndex(TBEx()\Items())
      EndIf  
    Next
    
  EndProcedure
  
  ;- ==========================================================================
  ;-   Module - Drawing
  ;- ========================================================================== 
  
  Procedure.i BlendColor_(Color1.i, Color2.i, Scale.i=50)
    Define.i R1, G1, B1, R2, G2, B2
    Define.f Blend = Scale / 100
    
    R1 = Red(Color1): G1 = Green(Color1): B1 = Blue(Color1)
    R2 = Red(Color2): G2 = Green(Color2): B2 = Blue(Color2)
    
    ProcedureReturn RGB((R1*Blend) + (R2 * (1-Blend)), (G1*Blend) + (G2 * (1-Blend)), (B1*Blend) + (B2 * (1-Blend)))
  EndProcedure
  
  
  Procedure.i AdjustHeight_()
    Define.i Height, ItemHeight
    
    If StartDrawing(CanvasOutput(TBEx()\CanvasNum))
      
      If TBEx()\FontID : DrawingFont(TBEx()\FontID) : EndIf
      
      ForEach TBEx()\Items()
        
        Select TBEx()\Items()\Type
          Case #ImageButton
            ItemHeight = TBEx()\Images\Height
          Case #TextButton 
            ItemHeight = TextHeight_(TBEx()\Items()\Text) 
          Default
            ItemHeight = TBEx()\Items()\Height 
        EndSelect

        If ItemHeight > Height : Height = ItemHeight : EndIf 
        
      Next
      
      If Height = 0
        Height = TBEx()\Buttons\Height
      Else  
        Height + 8
        TBEx()\Buttons\Height = Height
      EndIf

      If TBEx()\Flags & #ButtonText : Height + TextHeight_("Abc") : EndIf 
      
      StopDrawing()
    EndIf
    
    Height + TBEx()\Size\Spacing * 2
    
    ResizeGadget(TBEx()\CanvasNum, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height)
    
    ProcedureReturn Height
  EndProcedure
  
  Procedure   DrawSingleButton_(btIndex.i, Flags.i=#False)
    Define.i ImageID,  txtHeight, TextInside, BackColor, BorderColor
    Define.i X, Y, btY, imgY, imgX, txtX, txtY

    If ListSize(TBEx()\Items()) = 0 : ProcedureReturn #False : EndIf 
    If btIndex < 0 : ProcedureReturn #False : EndIf 
    
    If StartDrawing(CanvasOutput(TBEx()\CanvasNum))
      
      If TBEx()\FontID : DrawingFont(TBEx()\FontID) : EndIf
      
      If TBEx()\Flags & #ButtonText : txtHeight  = TextHeight_("ABC") : EndIf
      If TBEx()\Flags & #TextInside : TextInside = txtHeight : EndIf
      
      imgY = (TBEx()\Buttons\Height - TBEx()\Images\Height) / 2 + TBEx()\Items()\Y
      
      If SelectElement(TBEx()\Items(), btIndex)
        
        If TBEx()\Items()\Flags & #Hide = #False
          
          X   = TBEx()\Items()\X
          btY = TBEx()\Items()\Y
          
          ;{ Draw background
          Select TBEx()\Items()\State
            Case #Focus
              BackColor   = BlendColor_(TBEx()\Color\Focus, TBEx()\Color\Back, 20)
              BorderColor = BlendColor_(TBEx()\Color\Focus, TBEx()\Color\Back)
            Case #Click
              BackColor   = BlendColor_(TBEx()\Color\Focus, TBEx()\Color\Back, 32)
              BorderColor = BlendColor_(TBEx()\Color\Focus, TBEx()\Color\Back)
            Default
              BackColor   = TBEx()\Color\Back
              BorderColor = #PB_Default
          EndSelect
          
          If TBEx()\Flags & #RoundFocus
            
            DrawingMode(#PB_2DDrawing_Default)
            Box_(X, btY, TBEx()\Items()\Width, TBEx()\Buttons\Height + TextInside, BackColor, #Round)
            
            If BorderColor <> #PB_Default
              DrawingMode(#PB_2DDrawing_Outlined)
              Box_(X, btY, TBEx()\Items()\Width, TBEx()\Buttons\Height + TextInside, BorderColor, #Round)
            EndIf
          
          Else
            
            DrawingMode(#PB_2DDrawing_Default)
            Box_(X, btY,  TBEx()\Items()\Width, TBEx()\Buttons\Height + TextInside, BackColor)
            
            If BorderColor <> #PB_Default
              DrawingMode(#PB_2DDrawing_Outlined)
              Box_(X, btY,  TBEx()\Items()\Width, TBEx()\Buttons\Height + TextInside, BorderColor)
            EndIf
            
          EndIf ;}

          imgX = (TBEx()\Items()\Width - TBEx()\Images\Width) / 2
          
          ;{ Draw image
          If IsImage(TBEx()\Items()\ImageNum)
            
            DrawingMode(#PB_2DDrawing_AlphaBlend)
            
            If TBEx()\Items()\Flags & #Disable
              ImageID = ResizeImage(TBEx()\Items()\ImageNum, TBEx()\Images\Width, TBEx()\Images\Height, #PB_Image_Smooth)
              DrawAlphaImage_(ImageID, X + imgX, imgY, 128)
            Else
              DrawImage_(ImageID(TBEx()\Items()\ImageNum), X + imgX, imgY, TBEx()\Images\Width, TBEx()\Images\Height)
            EndIf
            
          EndIf ;}
          
          
          If TBEx()\Items()\Type = #TextButton ;{ Draw Text Button
            
            ClipOutput_(X, btY, TBEx()\Items()\Width, TBEx()\Buttons\Height)
            
            DrawingMode(#PB_2DDrawing_Transparent)
            
            If TBEx()\Items()\Flags & #Disable
              DrawText_(TBEx()\Items()\cX, TBEx()\Items()\cY, TBEx()\Items()\Text, BlendColor_(TBEx()\Color\Front, TBEx()\Color\Back))
            Else
              DrawText_(TBEx()\Items()\cX, TBEx()\Items()\cY, TBEx()\Items()\Text, TBEx()\Color\Front)
            EndIf
            
            UnClipOutput_()        
            ;}
          ElseIf TBEx()\Flags & #TextInside And TBEx()\Flags & #ButtonText ;{ Draw Text
            
            txtX = (TBEx()\Items()\Width - TextWidth_(TBEx()\Items()\Text)) / 2
            If txtX < 0 : txtX = 0 : EndIf
            
            ClipOutput_(X, txtY, TBEx()\Items()\Width, TBEx()\Buttons\txtHeight)
            
            DrawingMode(#PB_2DDrawing_Transparent)
            If TBEx()\Items()\Flags & #Disable
              DrawText_(X + txtX, txtY, TBEx()\Items()\Text, BlendColor_(TBEx()\Color\Front, TBEx()\Color\Back))
            Else
              DrawText_(X + txtX, txtY, TBEx()\Items()\Text, TBEx()\Color\Front)
            EndIf
            
            UnClipOutput_()
            ;}
          EndIf

        EndIf  
          
      EndIf 

      StopDrawing()
    EndIf  
   
  EndProcedure
  
  Procedure.i Draw_(Flags.i=#False)
    ; DPI: TBEx()\Items()\... / TBEx()\Buttons\...
    Define.i X, Y, btY, btX, imgY, imgX, txtX, txtY, cbY, OffsetY
    Define.i Width, Height, gHeight, btHeight, TextInside, BackColor, BorderColor
    Define.i ImageID
    
    If TBEx()\Hide : ProcedureReturn #False : EndIf

    If StartDrawing(CanvasOutput(TBEx()\CanvasNum))
      
      If TBEx()\FontID : DrawingFont(TBEx()\FontID) : EndIf
      
      If Flags & #AdjustButtons        ;{ Adjust single buttons width to text
        ForEach TBEx()\Items()
          If TBEx()\Items()\Type = #ImageButton
            If TextWidth_(TBEx()\Items()\Text) > TBEx()\Items()\Width
              TBEx()\Items()\Width = TextWidth_(TBEx()\Items()\Text)
            EndIf
          ElseIf TBEx()\Items()\Type = #TextButton
            If TextWidth_(TBEx()\Items()\Text) + 6 > TBEx()\Items()\Width
              TBEx()\Items()\Width = TextWidth_(TBEx()\Items()\Text) + 6
            EndIf
          EndIf  
        Next ;}
      ElseIf Flags & #AdjustAllButtons ;{ Adjust all buttons width to text
        Width = 0
        ForEach TBEx()\Items()
          If TBEx()\Items()\Type = #ImageButton
            If TextWidth_(TBEx()\Items()\Text) > Width
              Width = TextWidth_(TBEx()\Items()\Text)
            EndIf
          ElseIf TBEx()\Items()\Type = #TextButton
            If TextWidth_(TBEx()\Items()\Text) + 6 > Width
              Width = TextWidth_(TBEx()\Items()\Text) + 6
            EndIf
          EndIf
        Next
        If TBEx()\Buttons\Width < Width
          TBEx()\Buttons\Width = Width
          ForEach TBEx()\Items()
            If TBEx()\Items()\Type = #ImageButton Or TBEx()\Items()\Type = #TextButton
              TBEx()\Items()\Width = Width + 6
            EndIf
          Next
        EndIf ;}
      EndIf
      
      If TBEx()\Flags & #ButtonText
        TBEx()\Buttons\txtHeight = TextHeight_("ABC") 
      Else
        TBEx()\Buttons\txtHeight = 0
      EndIf   
     
      If TBEx()\Flags & #TextInside
        TextInside = TBEx()\Buttons\txtHeight
      EndIf
      
      X    = TBEx()\Size\Spacing
      btY  = (GadgetHeight(TBEx()\CanvasNum) - TBEx()\Buttons\Height - TBEx()\Buttons\txtHeight) / 2
      imgY = (TBEx()\Buttons\Height - TBEx()\Images\Height) / 2 + btY

      txtY = btY + TBEx()\Buttons\Height

      ;{ _____ Background _____
      DrawingMode(#PB_2DDrawing_Default)
      Box_(0, 0, GadgetWidth(TBEx()\CanvasNum), GadgetHeight(TBEx()\CanvasNum), TBEx()\Color\Back)
      ;}
      
      ForEach TBEx()\Items()
        
        ;{ Button background
        Select TBEx()\Items()\State
          Case #Focus
            BackColor   = BlendColor_(TBEx()\Color\Focus, TBEx()\Color\Back, 20)
            BorderColor = BlendColor_(TBEx()\Color\Focus, TBEx()\Color\Back)
          Case #Click
            BackColor   = BlendColor_(TBEx()\Color\Focus, TBEx()\Color\Back, 32)
            BorderColor = BlendColor_(TBEx()\Color\Focus, TBEx()\Color\Back)
          Default
            BackColor   = TBEx()\Color\Back
            BorderColor = #PB_Default
        EndSelect
        
        If TBEx()\Flags & #RoundFocus
          
          DrawingMode(#PB_2DDrawing_Default)
          Box_(X, btY, TBEx()\Items()\Width, TBEx()\Buttons\Height + TextInside, BackColor, #Round)

          If BorderColor <> #PB_Default
            DrawingMode(#PB_2DDrawing_Outlined)
            Box_(X, btY, TBEx()\Items()\Width, TBEx()\Buttons\Height + TextInside, BorderColor, #Round)
          EndIf
          
        Else
          
          DrawingMode(#PB_2DDrawing_Default)
          Box_(X, btY,  TBEx()\Items()\Width, TBEx()\Buttons\Height + TextInside, BackColor)
          
          If BorderColor <> #PB_Default
            DrawingMode(#PB_2DDrawing_Outlined)
            Box_(X, btY,  TBEx()\Items()\Width, TBEx()\Buttons\Height + TextInside, BorderColor)
          EndIf
          
        EndIf ;}

        ;{ _____ Items _____
        If TBEx()\Items()\Flags & #Hide = #False
          
          Select TBEx()\Items()\Type
            Case #TextButton  ;{ Text Button
              
              TBEx()\Items()\X  = X
              TBEx()\Items()\Y  = btY
              
              TBEx()\Items()\cX = (TBEx()\Items()\Width  - TextWidth_(TBEx()\Items()\Text)) / 2 + X
              TBEx()\Items()\cY = (TBEx()\Buttons\Height - TextHeight_(TBEx()\Items()\Text)) / 2 + btY
              
              ClipOutput_(X, btY, TBEx()\Items()\Width, TBEx()\Buttons\Height)
              
              DrawingMode(#PB_2DDrawing_Transparent)
              
              If TBEx()\Items()\Flags & #Disable
                DrawText_(TBEx()\Items()\cX, TBEx()\Items()\cY, TBEx()\Items()\Text, BlendColor_(TBEx()\Color\Front, TBEx()\Color\Back))
              Else
                DrawText_(TBEx()\Items()\cX, TBEx()\Items()\cY, TBEx()\Items()\Text, TBEx()\Color\Front)
              EndIf
              
              UnClipOutput_()
              
              X + TBEx()\Items()\Width + TBEx()\Buttons\Spacing
              ;}
            Case #ImageButton ;{ ImageButton
              
              imgX = (TBEx()\Items()\Width - TBEx()\Images\Width) / 2
              
              If IsImage(TBEx()\Items()\ImageNum)

                DrawingMode(#PB_2DDrawing_AlphaBlend)
                
                If TBEx()\Items()\Flags & #Disable
                  
                  ImageID = CopyImage(TBEx()\Items()\ImageNum, #PB_Any)
                  If ResizeImage(ImageID, TBEx()\Images\Width, TBEx()\Images\Height, #PB_Image_Smooth)
                    DrawAlphaImage_(ImageID(ImageID), X + imgX, imgY, 128)
                  EndIf
                  
                Else
                  DrawImage_(ImageID(TBEx()\Items()\ImageNum), X + imgX, imgY, TBEx()\Images\Width, TBEx()\Images\Height)
                EndIf
                
              EndIf
              
              TBEx()\Items()\X = X
              TBEx()\Items()\Y = btY

              If TBEx()\Flags & #ButtonText
                
                txtX = (TBEx()\Items()\Width - TextWidth_(TBEx()\Items()\Text)) / 2
                If txtX < 0 : txtX = 0 : EndIf
                
                ClipOutput_(X, txtY, TBEx()\Items()\Width, TBEx()\Buttons\txtHeight)
                
                DrawingMode(#PB_2DDrawing_Transparent)
                
                If TBEx()\Items()\Flags & #Disable
                  DrawText_(X + txtX, txtY, TBEx()\Items()\Text, BlendColor_(TBEx()\Color\Front, TBEx()\Color\Back))
                Else
                  DrawText_(X + txtX, txtY, TBEx()\Items()\Text, TBEx()\Color\Front)
                EndIf
                
                UnClipOutput_()
                
              EndIf

              X + TBEx()\Items()\Width + TBEx()\Buttons\Spacing
              ;}
            Case #ComboBox, #SpinGadget, #Button, #TrackBar ;{ ComboBox / SpinGadget / TextButton / TrackBar
 
              If IsGadget(TBEx()\Items()\Num)
                
                X + 4
                
                TBEx()\Items()\X = X
                
                If TBEx()\Items()\Flags & #Top
                  cbY = btY + 4
                ElseIf TBEx()\Items()\Flags & #Bottom
                  cbY = btY + TBEx()\Buttons\Height - TBEx()\Items()\Height - 4
                Else
                  cbY = (GadgetHeight(TBEx()\CanvasNum) - TBEx()\Items()\Height - TBEx()\Buttons\txtHeight) / 2
                EndIf

                If X <> GadgetX(TBEx()\Items()\Num) Or Y + cbY <> GadgetY(TBEx()\Items()\Num)
                  ResizeGadget(TBEx()\Items()\Num,  X,  Y + cbY, TBEx()\Items()\Width, TBEx()\Items()\Height)
                EndIf
              
                X + TBEx()\Items()\Width + 4 + TBEx()\Buttons\Spacing
              EndIf
              ;}
            Case #Separator   ;{ Separator
              
              btX = (TBEx()\Items()\Width - 2) / 2
              If btX < 0 : btX = 0 : EndIf
              
              TBEx()\Items()\X = X   + btX + 1
              TBEx()\Items()\Y = btY + 4
              
              DrawingMode(#PB_2DDrawing_Default)
              
              Box_(X + btX + 1, btY + 4, 1, TBEx()\Buttons\Height - 8, BlendColor_(TBEx()\Color\Separator, TBEx()\Color\Back))
              Box_(X + btX,     btY + 4, 1, TBEx()\Buttons\Height - 8, TBEx()\Color\Separator)
              
              X + TBEx()\Items()\Width + TBEx()\Buttons\Spacing
              ;}
            Case #Spacer      ;{ Spacer
              
              TBEx()\Items()\X = X
              TBEx()\Items()\Width = (GetAvailableSpace_() / TBEx()\Spacer)
              
              If TBEx()\Spacer
                X + TBEx()\Items()\Width
              EndIf 
              ;}
          EndSelect
          
        Else
          TBEx()\Items()\X = #PB_Ignore
        EndIf
        ;}
        
      Next
      
      TBEx()\Buttons\LastX = X
      
      ;{ _____ Border _____
      If TBEx()\Flags & #Border
        DrawingMode(#PB_2DDrawing_Outlined)
        Box_(0, 0, GadgetWidth(TBEx()\CanvasNum), GadgetHeight(TBEx()\CanvasNum), TBEx()\Color\Border)
      EndIf
      ;}
      
      StopDrawing()
    EndIf
    
    ProcedureReturn Height
  EndProcedure
  
  
  ;- ==========================================================================
  ;-   Module - Events
  ;- ========================================================================== 
  
  CompilerIf Defined(ModuleEx, #PB_Module)
    
    Procedure _ThemeHandler()

      ForEach TBEx()
        
        If IsFont(ModuleEx::ThemeGUI\Font\Num)
          TBEx()\FontID = FontID(ModuleEx::ThemeGUI\Font\Num)
        EndIf
        
        TBEx()\Color\Front     = ModuleEx::ThemeGUI\FrontColor
        TBEx()\Color\Back      = ModuleEx::ThemeGUI\GadgetColor
        TBEx()\Color\Separator = ModuleEx::ThemeGUI\Button\BorderColor
        TBEx()\Color\Focus     = ModuleEx::ThemeGUI\Focus\BackColor
        TBEx()\Color\Border    = ModuleEx::ThemeGUI\BorderColor

        Draw_()
      Next
      
    EndProcedure
    
  CompilerEndIf   
  
  CompilerIf #EnableToolBarGadgets
    
    Procedure _GadgetHandler()
      Define.i GadgetNum = EventGadget()
      Define.i GNum = GetGadgetData(GadgetNum)
      
      If FindMapElement(TBEx(), Str(GNum))
        
        ForEach TBEx()\Items()
          
          If TBEx()\Items()\Num = GadgetNum
            
            TBEx()\Event\Num     = TBEx()\Items()\Event
            TBEx()\Event\ID      = TBEx()\Items()\EventID
            
            If IsWindow(TBEx()\Window\Num)
              
              Select TBEx()\Items()\Type
                Case #ComboBox   ;{ ComboBox changed
                  
                  TBEx()\Event\Type  = #EventType_ComboBox
                  TBEx()\Event\State = GetGadgetState(GadgetNum)
                  
                  If TBEx()\Items()\Event = #PB_Ignore
                    PostEvent(#PB_Event_Gadget, TBEx()\Window\Num, TBEx()\CanvasNum, #EventType_ComboBox, ListIndex(TBEx()\Items()))
                    PostEvent(#Event_Gadget, TBEx()\Window\Num, TBEx()\CanvasNum, #EventType_ComboBox, ListIndex(TBEx()\Items()))
                  Else
                    PostEvent(#PB_Event_Gadget, TBEx()\Window\Num, TBEx()\Items()\Event, #EventType_ComboBox, TBEx()\Event\State)
                    PostEvent(#Event_Gadget, TBEx()\Window\Num, TBEx()\Items()\Event, #EventType_ComboBox, TBEx()\Event\State)
                  EndIf
                  ;}
                Case #SpinGadget ;{ SpinGadget changed
                  
                  If TBEx()\Event\State <> GetGadgetState(GadgetNum)
                    
                    TBEx()\Event\Type  = #EventType_SpinBox
                    TBEx()\Event\State = GetGadgetState(GadgetNum)
                    SetGadgetText(GadgetNum, Str(GetGadgetState(GadgetNum)))
                    
                    If TBEx()\Items()\Event = #PB_Ignore
                      PostEvent(#PB_Event_Gadget, TBEx()\Window\Num, TBEx()\CanvasNum, #EventType_SpinBox, ListIndex(TBEx()\Items()))
                      PostEvent(#Event_Gadget, TBEx()\Window\Num, TBEx()\CanvasNum, #EventType_SpinBox, ListIndex(TBEx()\Items()))
                    Else
                      PostEvent(#PB_Event_Gadget, TBEx()\Window\Num, TBEx()\Items()\Event, #EventType_SpinBox, TBEx()\Event\State)
                      PostEvent(#Event_Gadget, TBEx()\Window\Num, TBEx()\Items()\Event, #EventType_SpinBox, TBEx()\Event\State)
                    EndIf
                    
                  EndIf
                  ;}
                Case #Button     ;{ Textbutton clicked
                  
                  TBEx()\Event\Type  = #EventType_Button
                  TBEx()\Event\State = GetGadgetState(GadgetNum)
                  
                  If TBEx()\Items()\Event = #PB_Ignore
                    PostEvent(#PB_Event_Gadget, TBEx()\Window\Num, TBEx()\CanvasNum, #EventType_Button, ListIndex(TBEx()\Items()))
                    PostEvent(#Event_Gadget, TBEx()\Window\Num, TBEx()\CanvasNum, #EventType_Button, ListIndex(TBEx()\Items()))
                  Else
                    PostEvent(#PB_Event_Gadget, TBEx()\Window\Num, TBEx()\Items()\Event, #EventType_Button, TBEx()\Event\State)
                    PostEvent(#Event_Gadget, TBEx()\Window\Num, TBEx()\Items()\Event, #EventType_Button, TBEx()\Event\State)
                  EndIf
                  ;}
                Case #TrackBar   ;{ TrackBarGadget changed
                  
                  If TBEx()\Event\State <> GetGadgetState(GadgetNum)
                    
                    TBEx()\Event\Type  = #EventType_TrackBar
                    TBEx()\Event\State = GetGadgetState(GadgetNum)
                    
                    If TBEx()\Items()\Event = #PB_Ignore
                      PostEvent(#PB_Event_Gadget, TBEx()\Window\Num, TBEx()\CanvasNum, #EventType_TrackBar, ListIndex(TBEx()\Items()))
                      PostEvent(#Event_Gadget, TBEx()\Window\Num, TBEx()\CanvasNum, #EventType_TrackBar, ListIndex(TBEx()\Items()))
                    Else
                      PostEvent(#PB_Event_Gadget, TBEx()\Window\Num, TBEx()\Items()\Event, #EventType_TrackBar, TBEx()\Event\State)
                      PostEvent(#Event_Gadget, TBEx()\Window\Num, TBEx()\Items()\Event, #EventType_TrackBar, TBEx()\Event\State)
                    EndIf
                    
                  EndIf
                  ;}  
              EndSelect
              
            EndIf
            
          EndIf
        
        Next
        
      EndIf
      
    EndProcedure
    
  CompilerEndIf
  
  Procedure _MenuEventHandler()
    Define.i Event = EventMenu()
    
    ForEach TBEx()
      If TBEx()\PopupMenu <> #PB_Default
        
        If SelectElement(TBEx()\Items(), TBEx()\PopupMenu)
          TBEx()\Event\Type    = #EventType_DropDown
          TBEx()\Event\ID      = TBEx()\Items()\EventID
          TBEx()\Event\Num     = TBEx()\Items()\Event
          TBEx()\Event\State   = #Click
          TBEx()\Event\btIndex = TBEx()\PopupMenu
        EndIf
      
        ProcedureReturn #True
      EndIf  
    Next
    
  EndProcedure
  
  Procedure _LeftButtonDownHandler()
    Define.f X, Y, minY, maxY, btIndex
    Define.i GNum = EventGadget()
    
    If FindMapElement(TBEx(), Str(GNum))
      
      X = DesktopUnscaledX(GetGadgetAttribute(GNum, #PB_Canvas_MouseX))
      Y = DesktopUnscaledY(GetGadgetAttribute(GNum, #PB_Canvas_MouseY))
      
      TBEx()\Event\Type    = #False
      TBEx()\Event\btIndex = #NoIndex
      TBEx()\Buttons\State = #Click
      
      ForEach TBEx()\Items()
        
        If TBEx()\Items()\X = #PB_Ignore   : Continue : EndIf
        If TBEx()\Items()\Flags & #Disable : Continue : EndIf
        
        If X > TBEx()\Items()\X And X < TBEx()\Items()\X + TBEx()\Items()\Width 
          If Y > TBEx()\Items()\Y And Y < TBEx()\Items()\Y + TBEx()\Buttons\Height

            btIndex = ListIndex(TBEx()\Items())
            
            Select TBEx()\Items()\Type
              Case #ImageButton
               
                TBEx()\Event\Type    = #EventType_ImageButton
                TBEx()\Event\btIndex = btIndex
                
                If btIndex > #NoFocus
                  TBEx()\Items()\State = #Click
                  DrawSingleButton_(btIndex)
                EndIf
                
              Case #TextButton
                
                TBEx()\Event\Type    = #EventType_Button
                TBEx()\Event\btIndex = btIndex
                
                If btIndex > #NoFocus
                  TBEx()\Items()\State = #Click
                  DrawSingleButton_(btIndex)
                EndIf
                
            EndSelect  
        
            Break
           
          EndIf
        EndIf
        
      Next
      
    EndIf 
    
  EndProcedure
  
  Procedure _LeftButtonUpHandler()
    Define.f X, Y
    Define.i btIndex
    Define.i GNum = EventGadget()
    
    If FindMapElement(TBEx(), Str(GNum))
      
      X = DesktopUnscaledX(GetGadgetAttribute(GNum, #PB_Canvas_MouseX))
      Y = DesktopUnscaledY(GetGadgetAttribute(GNum, #PB_Canvas_MouseY))
      
      TBEx()\Buttons\State = #False
      
      ForEach TBEx()\Items()
        
        If TBEx()\Items()\X = #PB_Ignore : Continue : EndIf
        
        If X > TBEx()\Items()\X And X < TBEx()\Items()\X + TBEx()\Items()\Width
          If Y > TBEx()\Items()\Y And Y < TBEx()\Items()\Y + TBEx()\Buttons\Height
            
            btIndex = ListIndex(TBEx()\Items())
            
            Select TBEx()\Event\Type
              Case #EventType_Button      ;{ TextButton clicked & released
                
                If TBEx()\Buttons\Focus = btIndex And TBEx()\Event\btIndex = btIndex
                  
                  If TBEx()\Items()\PopupMenu = #NotValid ;{ Button without Popupmenu
                    
                    TBEx()\Event\Num = TBEx()\Items()\Event
                    TBEx()\Event\ID  = TBEx()\Items()\EventID

                    TBEx()\Items()\State = #Focus
                    
                    If IsWindow(TBEx()\Window\Num)
                      If TBEx()\PostEvent = #Event_Menu
                        PostEvent(#PB_Event_Menu, TBEx()\Window\Num, TBEx()\Items()\Event, #EventType_Button, btIndex)
                      Else
                        PostEvent(#PB_Event_Gadget, TBEx()\Window\Num, TBEx()\CanvasNum, #EventType_Button, btIndex)
                        PostEvent(#Event_Gadget, TBEx()\Window\Num, TBEx()\CanvasNum, #EventType_Button, btIndex)
                      EndIf 
                    EndIf
                    
                    DrawSingleButton_(btIndex)
                    ;}
                  Else

                    DisableToolTip_()

                    TBEx()\Items()\State = #Click
                    
                    DrawSingleButton_(btIndex)
                    
                    If IsWindow(TBEx()\Window\Num)
                      If TBEx()\PostEvent = #Event_Menu
                        PostEvent(#PB_Event_Menu, TBEx()\Window\Num, TBEx()\Items()\Event, #EventType_Button, btIndex)
                      Else
                        PostEvent(#PB_Event_Gadget, TBEx()\Window\Num, TBEx()\CanvasNum, #EventType_Button, btIndex)
                        PostEvent(#Event_Gadget, TBEx()\Window\Num, TBEx()\CanvasNum, #EventType_Button, btIndex)
                      EndIf 
                    EndIf
                    
                    TBEx()\PopupMenu = btIndex
                    
                    X = WindowX(TBEx()\Window\Num, #PB_Window_InnerCoordinate) + TBEx()\Size\X + TBEx()\Items()\X
                    Y = WindowY(TBEx()\Window\Num, #PB_Window_InnerCoordinate) + TBEx()\Size\Y + GetButtonY_(#True) + TBEx()\Buttons\Spacing
                    
                    If IsMenu(TBEx()\Items()\PopupMenu) : DisplayPopupMenu(TBEx()\Items()\PopupMenu, WindowID(TBEx()\Window\Num), X, Y) : EndIf
                    
                    DrawSingleButton_(TBEx()\LastFocus)

                  EndIf

                Else
                  TBEx()\Event\Type    = #False
                  TBEx()\Event\btIndex = #NoIndex
                EndIf
                
                ;}
              Case #EventType_ImageButton ;{ ImageButton clicked & released
                
                If TBEx()\Buttons\Focus = btIndex And TBEx()\Event\btIndex = btIndex
                  
                  If TBEx()\Items()\PopupMenu = #NotValid  ;{ Button without Popupmenu
                    
                    TBEx()\Event\Num = TBEx()\Items()\Event
                    TBEx()\Event\ID  = TBEx()\Items()\EventID

                    TBEx()\Items()\State = #Focus
                    
                    If IsWindow(TBEx()\Window\Num)
                      If TBEx()\PostEvent = #Event_Menu
                        PostEvent(#PB_Event_Menu, TBEx()\Window\Num, TBEx()\Items()\Event, #EventType_ImageButton, btIndex)
                      Else
                        PostEvent(#PB_Event_Gadget, TBEx()\Window\Num, TBEx()\CanvasNum, #EventType_ImageButton, btIndex)
                        PostEvent(#Event_Gadget, TBEx()\Window\Num, TBEx()\CanvasNum, #EventType_ImageButton, btIndex)
                      EndIf 
                    EndIf
                    
                    DrawSingleButton_(btIndex)
                    ;}
                  Else

                    DisableToolTip_()

                    TBEx()\Items()\State = #Click
                    
                    DrawSingleButton_(btIndex) 
                    
                    If IsWindow(TBEx()\Window\Num)
                      If TBEx()\PostEvent = #Event_Menu
                        PostEvent(#PB_Event_Menu, TBEx()\Window\Num, TBEx()\Items()\Event, #EventType_Button, btIndex)
                      Else
                        PostEvent(#PB_Event_Gadget, TBEx()\Window\Num, TBEx()\CanvasNum, #EventType_Button, btIndex)
                        PostEvent(#Event_Gadget, TBEx()\Window\Num, TBEx()\CanvasNum, #EventType_Button, btIndex)
                      EndIf 
                    EndIf
                    
                    TBEx()\PopupMenu = btIndex
                    
                    X = WindowX(TBEx()\Window\Num, #PB_Window_InnerCoordinate) + TBEx()\Size\X + TBEx()\Items()\X
                    Y = WindowY(TBEx()\Window\Num, #PB_Window_InnerCoordinate) + TBEx()\Size\Y + GetButtonY_(#True) + TBEx()\Buttons\Spacing
                    
                    If IsMenu(TBEx()\Items()\PopupMenu) : DisplayPopupMenu(TBEx()\Items()\PopupMenu, WindowID(TBEx()\Window\Num), X, Y) : EndIf
                    
                    DrawSingleButton_(TBEx()\LastFocus)
                    
                  EndIf

                Else
                  TBEx()\Event\Type    = #False
                  TBEx()\Event\btIndex = #NoIndex
                EndIf
              ;}
            EndSelect  
          
            Break
          EndIf   
        EndIf
        
      Next
    EndIf
    
  EndProcedure    
  
  Procedure _MouseLeaveHandler()
    Define.i GNum = EventGadget()

    If FindMapElement(TBEx(), Str(GNum))
      
      If TBEx()\PopupMenu <> #PB_Default : ProcedureReturn #True : EndIf
      
      TBEx()\Buttons\Focus = #NoFocus
      TBEx()\LastFocus     = #PB_Default
      
      ForEach TBEx()\Items()
        TBEx()\Items()\State = #False
      Next  

      DisableToolTip_()
      Draw_()
    EndIf  
    
  EndProcedure
  
  Procedure _MouseMoveHandler()
    Define.i X, Y, minY, maxY, LastButtonFocus, ItemIndex
    Define.i GNum = EventGadget()
    
    If FindMapElement(TBEx(), Str(GNum))
      
      X = DesktopUnscaledX(GetGadgetAttribute(GNum, #PB_Canvas_MouseX))
      Y = DesktopUnscaledY(GetGadgetAttribute(GNum, #PB_Canvas_MouseY))

      LastButtonFocus = TBEx()\LastFocus
      
      ForEach TBEx()\Items()
        
        ItemIndex = ListIndex(TBEx()\Items())
        
        
        If TBEx()\Items()\X = #PB_Ignore : Continue : EndIf
        
        If X > TBEx()\Items()\X And X < TBEx()\Items()\X + TBEx()\Items()\Width
          If Y > TBEx()\Items()\Y And Y < TBEx()\Items()\Y + TBEx()\Buttons\Height
            
            Select TBEx()\Items()\Type
              Case #ImageButton, #TextButton
                
                If TBEx()\Items()\Flags & #Disable ;{ Button disabled
                  TBEx()\Items()\State = #False
                  TBEx()\Buttons\Focus = #NoFocus
                  DisableToolTip_()
                  ;}
                Else
                  
                  ; Focus
                  TBEx()\Items()\State = #Focus
                  TBEx()\Buttons\Focus = ItemIndex
                  TBEx()\LastFocus     = TBEx()\Buttons\Focus
                  
                  If LastButtonFocus = ItemIndex : Break : EndIf
                  
                  ; Tooltip availible
                  If TBEx()\Items()\ToolTip
                    TBEx()\ToolTip = ItemIndex
                    GadgetToolTip(TBEx()\CanvasNum, TBEx()\Items()\ToolTip)
                  Else 
                    DisableToolTip_()
                  EndIf
 
                  If TBEx()\Buttons\State <> #Click And LastButtonFocus <> ItemIndex
                    DrawSingleButton_(ItemIndex)
                  EndIf
                  
                EndIf
                
              Default
                
                TBEx()\Items()\State = #False
                TBEx()\Buttons\Focus = #NoFocus
                
            EndSelect
            
            Continue
          EndIf
        EndIf
        
        TBEx()\Items()\State = #False
        If TBEx()\ToolTip = ItemIndex : DisableToolTip_() : EndIf
        
      Next

      If LastButtonFocus <> TBEx()\Buttons\Focus
        DrawSingleButton_(LastButtonFocus) 
      EndIf 
      
    EndIf
    
  EndProcedure  
  
  Procedure _ResizeHandler()
    Define.i GNum = EventGadget()
    
    If FindMapElement(TBEx(), Str(GNum))
      Draw_()
    EndIf  
 
  EndProcedure
  
  Procedure _ResizeWindowHandler()
    Define.f X, Y, Width, Height
    Define.f OffSetX, OffSetY
    
    ForEach TBEx()
      
      If IsGadget(TBEx()\CanvasNum)
        
        If TBEx()\Flags & #AutoResize
          
          If IsWindow(TBEx()\Window\Num)
            
            OffSetX = WindowWidth(TBEx()\Window\Num)  - TBEx()\Window\Width
            OffsetY = WindowHeight(TBEx()\Window\Num) - TBEx()\Window\Height

            TBEx()\Window\Width  = WindowWidth(TBEx()\Window\Num)
            TBEx()\Window\Height = WindowHeight(TBEx()\Window\Num)
            
            If TBEx()\Size\Flags
              
              X = #PB_Ignore : Y = #PB_Ignore : Width = #PB_Ignore : Height = #PB_Ignore
              
              If TBEx()\Size\Flags & #MoveX : X = GadgetX(TBEx()\CanvasNum) + OffSetX : EndIf
              If TBEx()\Size\Flags & #MoveY : Y = GadgetY(TBEx()\CanvasNum) + OffSetY : EndIf
              If TBEx()\Size\Flags & #ResizeWidth  : Width  = GadgetWidth(TBEx()\CanvasNum)  + OffSetX : EndIf
              If TBEx()\Size\Flags & #ResizeHeight : Height = GadgetHeight(TBEx()\CanvasNum) + OffSetY : EndIf
              
              ResizeGadget(TBEx()\CanvasNum, X, Y, Width, Height)
              
            Else
              ResizeGadget(TBEx()\CanvasNum, #PB_Ignore, #PB_Ignore, GadgetWidth(TBEx()\CanvasNum) + OffSetX,  #PB_Ignore)
            EndIf
            
            If OffSetX Or OffsetY : Draw_() : EndIf
          EndIf
          
        EndIf
        
      EndIf
      
    Next
    
  EndProcedure
  
  ;- ==========================================================================
  ;-   Module - Declared Procedures
  ;- ==========================================================================    
  
  ;- Add gadgets to toolbar
  
  CompilerIf #EnableToolBarGadgets
    
    Procedure   AddItem(GNum.i, TB_Index.i, Position, Text.s, ImageID.i=#False)
    
      If FindMapElement(TBEx(), Str(GNum))
        
        If SelectElement(TBEx()\Items(), TB_Index)
          
          If IsGadget(TBEx()\Items()\Num)
            AddGadgetItem(TBEx()\Items()\Num, Position, Text, ImageID)
          EndIf
          
        EndIf
  
      EndIf 
      
    EndProcedure
  
    
    Procedure.i ComboBox(GNum.i, Width.i, Height.i, EventNum.i=#PB_Ignore, Text.s="", EventID.s="", Flags.i=#False)
      Define.i GadgetList
      
      If FindMapElement(TBEx(), Str(GNum))
        
        If AddElement(TBEx()\Items())
          
          OpenGadgetList(TBEx()\CanvasNum)

          TBEx()\Items()\Type    = #ComboBox
          TBEx()\Items()\Num     = ComboBoxGadget(#PB_Any, 0, 0, Width, Height, Flags)
          TBEx()\Items()\Event   = EventNum
          TBEx()\Items()\EventID = EventID
          TBEx()\Items()\Text    = Text
          TBEx()\Items()\Width   = Width
          TBEx()\Items()\Height  = Height
          TBEx()\Items()\PopupMenu = #NotValid
          
          CloseGadgetList()
          
          If IsGadget(TBEx()\Items()\Num)
            SetGadgetData(TBEx()\Items()\Num, TBEx()\CanvasNum)
            BindGadgetEvent(TBEx()\Items()\Num, @_GadgetHandler(), #PB_EventType_Change)
          EndIf
          
          TBEx()\Size\Height = AdjustHeight_()
          
          If TBEx()\ReDraw : Draw_() : EndIf
          
          ProcedureReturn TBEx()\Items()\Num
        EndIf
        
      EndIf   
      
    EndProcedure
    
    Procedure.i SpinBox(GNum.i, Width.i, Height.i, Minimum.i, Maximum.i, EventNum.i=#PB_Ignore, Text.s="", EventID.s="", Flags.i=#False)
      Define.i GadgetList
      
      If FindMapElement(TBEx(), Str(GNum))
        
        If AddElement(TBEx()\Items())
          
          OpenGadgetList(TBEx()\CanvasNum)
  
          TBEx()\Items()\Type    = #SpinGadget
          TBEx()\Items()\Num     = SpinGadget(#PB_Any, 0, 0, Width, Height, Minimum, Maximum, Flags)
          TBEx()\Items()\Event   = EventNum
          TBEx()\Items()\EventID = EventID
          TBEx()\Items()\Text    = Text
          TBEx()\Items()\Width   = Width
          TBEx()\Items()\Height  = Height
          TBEx()\Items()\PopupMenu = #NotValid
          
          CloseGadgetList()
          
          If IsGadget(TBEx()\Items()\Num)
            SetGadgetData(TBEx()\Items()\Num, TBEx()\CanvasNum)
            BindGadgetEvent(TBEx()\Items()\Num, @_GadgetHandler())
          EndIf
          
          TBEx()\Size\Height = AdjustHeight_()
          
          If TBEx()\ReDraw : Draw_() : EndIf
          
          ProcedureReturn TBEx()\Items()\Num
        EndIf
        
      EndIf   
      
    EndProcedure
    
    Procedure.i Button(GNum.i, Width.i, Height.i, Text.s, EventNum.i=#PB_Ignore, EventID.s="", Flags.i=#False)
      Define.i GadgetList
  
      If FindMapElement(TBEx(), Str(GNum))
        
        If AddElement(TBEx()\Items())
          
          OpenGadgetList(TBEx()\CanvasNum)
  
          TBEx()\Items()\Type    = #Button
          TBEx()\Items()\Num     = ButtonGadget(#PB_Any, 0, 0, Width, Height, Text, Flags)
          TBEx()\Items()\Event   = EventNum
          TBEx()\Items()\EventID = EventID
          TBEx()\Items()\Width   = Width
          TBEx()\Items()\Height  = Height
          TBEx()\Items()\PopupMenu = #NotValid
          
          CloseGadgetList()
          
          If IsGadget(TBEx()\Items()\Num)
            SetGadgetData(TBEx()\Items()\Num, TBEx()\CanvasNum)
            BindGadgetEvent(TBEx()\Items()\Num, @_GadgetHandler())
          EndIf
          
          TBEx()\Size\Height = AdjustHeight_()
          
          If TBEx()\ReDraw : Draw_() : EndIf
          
          ProcedureReturn TBEx()\Items()\Num
        EndIf
        
      EndIf   
      
    EndProcedure
    
    Procedure.i TrackBar(GNum.i, Width.i, Height.i, Minimum.i, Maximum.i, EventNum.i=#PB_Ignore, EventID.s="", Flags.i=#False)
      Define.i GadgetList
      
      If FindMapElement(TBEx(), Str(GNum))
        
        If AddElement(TBEx()\Items())
          
          OpenGadgetList(TBEx()\CanvasNum)

          TBEx()\Items()\Type    = #TrackBar
          TBEx()\Items()\Num     = TrackBarGadget(#PB_Any, 0, 0, Width, Height, Minimum, Maximum, Flags)
          TBEx()\Items()\Event   = EventNum
          TBEx()\Items()\EventID = EventID
          TBEx()\Items()\Width   = Width
          TBEx()\Items()\Height  = Height
          TBEx()\Items()\PopupMenu = #NotValid
          
          CloseGadgetList()
          
          If IsGadget(TBEx()\Items()\Num)
            SetGadgetData(TBEx()\Items()\Num, TBEx()\CanvasNum)
            BindGadgetEvent(TBEx()\Items()\Num, @_GadgetHandler())
          EndIf
          
          TBEx()\Size\Height = AdjustHeight_()
          
          If TBEx()\ReDraw : Draw_() : EndIf
          
          ProcedureReturn TBEx()\Items()\Num
        EndIf
        
      EndIf   
      
    EndProcedure
    
    
    Procedure.i GetItemState(GNum.i, TB_Index.i)
    
      If FindMapElement(TBEx(), Str(GNum))
        
        If SelectElement(TBEx()\Items(), TB_Index)
          
          If IsGadget(TBEx()\Items()\Num)
            ProcedureReturn GetGadgetState(TBEx()\Items()\Num)
          EndIf
          
        EndIf
  
      EndIf 
      
    EndProcedure
    
    Procedure.s GetItemText(GNum.i, TB_Index.i)
      
      If FindMapElement(TBEx(), Str(GNum))
        
        If SelectElement(TBEx()\Items(), TB_Index)
          
          If IsGadget(TBEx()\Items()\Num)
            ProcedureReturn GetGadgetText(TBEx()\Items()\Num)
          EndIf
          
        EndIf
  
      EndIf 
      
    EndProcedure
    
    Procedure   SetItemFlags(GNum.i, TB_Index.i, Flags.i)
      ; #Top / #Bottom 
      
      If FindMapElement(TBEx(), Str(GNum))
        
        If SelectElement(TBEx()\Items(), TB_Index)
          
          If IsGadget(TBEx()\Items()\Num)
            TBEx()\Items()\Flags | Flags
          EndIf
          
        EndIf
  
      EndIf 
      
    EndProcedure
    
    Procedure   SetItemAttribute(GNum.i, TB_Index.i, Attribute.i, Value.i)
    
      If FindMapElement(TBEx(), Str(GNum))
        
        If SelectElement(TBEx()\Items(), TB_Index)
          
          If IsGadget(TBEx()\Items()\Num)
            SetGadgetAttribute(TBEx()\Items()\Num, Attribute, Value)
          EndIf
          
        EndIf
  
      EndIf 
      
    EndProcedure

    Procedure   SetItemState(GNum.i, TB_Index.i, State.i)
    
      If FindMapElement(TBEx(), Str(GNum))
        
        If SelectElement(TBEx()\Items(), TB_Index)
          
          If IsGadget(TBEx()\Items()\Num)
            
            Select TBEx()\Items()\Type
              Case #SpinGadget
                SetGadgetState(TBEx()\Items()\Num, State)
                SetGadgetText(TBEx()\Items()\Num, Str(State))
              Default
                SetGadgetState(TBEx()\Items()\Num, State)
            EndSelect
            
          EndIf
          
        EndIf
  
      EndIf 
      
    EndProcedure
  
    Procedure   SetItemText(GNum.i, TB_Index.i, Text.s)
      
      If FindMapElement(TBEx(), Str(GNum))
        
        If SelectElement(TBEx()\Items(), TB_Index)
          
          If IsGadget(TBEx()\Items()\Num)
            SetGadgetText(TBEx()\Items()\Num, Text)
          EndIf
          
        EndIf
  
      EndIf 
      
    EndProcedure
    
  CompilerEndIf  
  
  
  Procedure   AttachPopupMenu(GNum.i, TB_Index.i, MenuNum.i, EventNum.i=#PB_Default) 
    
    If FindMapElement(TBEx(), Str(GNum))
      
      If EventNum <> #PB_Default : TB_Index = GetIndex_(EventNum) : EndIf
      
      If SelectElement(TBEx()\Items(), TB_Index)
        
        TBEx()\Items()\PopupMenu = MenuNum

        If TBEx()\ReDraw : Draw_() : EndIf
      EndIf
      
    EndIf  
    
  EndProcedure  
  
  
  Procedure   ButtonText(GNum.i, TB_Index.i, Text.s)
    Define.i Flags
    
    If FindMapElement(TBEx(), Str(GNum))
      
      If SelectElement(TBEx()\Items(), TB_Index)

        TBEx()\Items()\Text = Text
        
      If TBEx()\Flags & #AdjustHeight Or TBEx()\Flags & #AdjustAllButtons Or TBEx()\Flags & #AdjustButtons
        
        If TBEx()\Flags & #AdjustHeight     : Flags | #AdjustHeight    : EndIf
        If TBEx()\Flags & #AdjustButtons    : Flags | #AdjustButtons    : EndIf
        If TBEx()\Flags & #AdjustAllButtons : Flags | #AdjustAllButtons : EndIf
        Draw_(Flags)
        
      Else
        If TBEx()\ReDraw : Draw_() : EndIf
      EndIf
        
      EndIf
      
    EndIf
    
  EndProcedure
  
  Procedure   ClearItems(GNum.i)
    
    If FindMapElement(TBEx(), Str(GNum))
      
      ForEach TBEx()\Items()
        If TBEx()\Items()\Num
          If IsGadget(TBEx()\Items()\Num) : FreeGadget(TBEx()\Items()\Num) : EndIf
        EndIf 
      Next  
      
      ClearList(TBEx()\Items())
      
      Draw_()
    EndIf  
 
  EndProcedure
  
  Procedure   Disable(GNum.i, State.i)
    
    If FindMapElement(TBEx(), Str(GNum))
      
      ForEach TBEx()\Items()
        
        If State
          TBEx()\Items()\Flags | #Disable
        Else
          TBEx()\Items()\Flags & ~#Disable
        EndIf
        
        CompilerIf #EnableToolBarGadgets
          
          Select TBEx()\Items()\Type
            Case #ComboBox, #SpinGadget, #Button, #TrackBar
              DisableGadget(TBEx()\Items()\Num, State) 
          EndSelect
          
        CompilerEndIf 
        
      Next  
     
      If TBEx()\ReDraw : Draw_() : EndIf
     
    EndIf  
    
  EndProcedure  
  
  Procedure   DisableButton(GNum.i, TB_Index.i, State.i)
    
    If FindMapElement(TBEx(), Str(GNum))
      
      If SelectElement(TBEx()\Items(), TB_Index)
        
        If State
          TBEx()\Items()\Flags | #Disable
        Else
          TBEx()\Items()\Flags & ~#Disable
        EndIf
        
        CompilerIf #EnableToolBarGadgets
          
          Select TBEx()\Items()\Type
            Case #ComboBox, #SpinGadget, #Button, #TrackBar
              DisableGadget(TBEx()\Items()\Num, State) 
          EndSelect
          
        CompilerEndIf 
        
        If TBEx()\ReDraw : Draw_() : EndIf
        
      EndIf
      
    EndIf  
    
  EndProcedure  
  
  Procedure   DisableRedraw(GNum.i, State.i=#False)
    
    If FindMapElement(TBEx(), Str(GNum))
      
      If State
        TBEx()\ReDraw = #False
      Else
        TBEx()\ReDraw = #True
        Draw_()
      EndIf
      
    EndIf
    
  EndProcedure   
  
  ;- ----- Events -----
  
  Procedure.i EventNumber(GNum.i)
    
    If FindMapElement(TBEx(), Str(GNum))
      ProcedureReturn TBEx()\Event\Num
    EndIf
    
  EndProcedure
  
  Procedure.s EventID(GNum.i)
    
    If FindMapElement(TBEx(), Str(GNum))
      ProcedureReturn TBEx()\Event\ID
    EndIf
    
  EndProcedure
  
  Procedure.i EventState(GNum.i)
    
    If FindMapElement(TBEx(), Str(GNum))
      ProcedureReturn TBEx()\Event\State
    EndIf
    
  EndProcedure

  ;- ----- Toolbar - Gadget ----- 
  
  Procedure.i Gadget(GNum.i, X.i=#PB_Ignore, Y.i=#PB_Ignore, Width.i=#PB_Ignore, Height.i=#PB_Ignore, Flags.i=#False, WindowNum.i=#PB_Default)
    ; #ImageSize_16|#ImageSize_24|#ImageSize_32|#ButtonText|#Border|#PopupArrows|#ImageText
    ; #AutoResize|#AdjustButtons|#AdjustAllButtons|#AdjustHeight
    Define Result.i, ImageSize.i, AdjustHeight.i
    
    CompilerIf Defined(ModuleEx, #PB_Module)
      If ModuleEx::#Version < #ModuleEx : Debug "Please update ModuleEx.pbi" : EndIf 
    CompilerEndIf
    
  	If WindowNum = #PB_Default
      WindowNum = GetGadgetWindow()
    Else
      WindowNum = WindowNum
    EndIf
    
    ;{ ImageSize
    If Flags & #ImageSize_16
      ImageSize = 16
    ElseIf Flags & #ImageSize_24
      ImageSize = 24
    Else
      ImageSize = 32
    EndIf ;}
    
    ;{ Default gadget size
    If IsWindow(WindowNum)
      If X = #PB_Ignore : X = 0 : EndIf
      If Y = #PB_Ignore : Y = 0 : EndIf
      If Width = #PB_Ignore : Width = WindowWidth(WindowNum, #PB_Window_InnerCoordinate) : EndIf
    EndIf
    
    If Height = #PB_Ignore
      Height = ImageSize + 14
      AdjustHeight = #True
      If Flags & #Border :  Height + 4 : EndIf
    EndIf ;}
    
    If Flags & #UseExistingCanvas ;{ Use an existing CanvasGadget
      If IsGadget(GNum)
        Result = #True
      Else
        ProcedureReturn #False
      EndIf
      ;}
    Else
      Result = CanvasGadget(GNum, X, Y, Width, Height, #PB_Canvas_Container)
    EndIf

    If Result
      
      If GNum = #PB_Any : GNum = Result : EndIf
      
      If AddMapElement(TBEx(), Str(GNum))
        
        TBEx()\CanvasNum  = GNum
        TBEx()\Window\Num = WindowNum
        
        CompilerIf Defined(ModuleEx, #PB_Module)
          If ModuleEx::AddWindow(TBEx()\Window\Num, ModuleEx::#Tabulator)
            ModuleEx::AddGadget(GNum, TBEx()\Window\Num, ModuleEx::#IgnoreTabulator)
          EndIf
        CompilerEndIf
        
        TBEx()\Size\X = X
        TBEx()\Size\Y = Y
        TBEx()\Size\Width  = Width
        TBEx()\Size\Height = Height
        
        TBEx()\Size\Spacing = 3
       
        TBEx()\LastFocus = #NoFocus
        TBEx()\PopupMenu = #PB_Default
        
        TBEx()\Buttons\Focus   = #NoFocus
        TBEx()\Buttons\Width   = ImageSize + 8
        TBEx()\Buttons\Height  = ImageSize + 8
        TBEx()\Buttons\Spacing = 2
        
        TBEx()\Images\Width    = ImageSize
        TBEx()\Images\Height   = ImageSize
        
        TBEx()\Color\Front     = $000000
        TBEx()\Color\Back      = $EDEDED
        TBEx()\Color\Separator = $A0A0A0
        TBEx()\Color\Focus     = $FF8000
        TBEx()\Color\Border    = $C7C7C7
        
        CompilerSelect #PB_Compiler_OS ;{ window background color (if possible)
          CompilerCase #PB_OS_Windows
            TBEx()\Color\Back      = GetSysColor_(#COLOR_MENU)
            TBEx()\Color\Separator = GetSysColor_(#COLOR_3DSHADOW)
            TBEx()\Color\Focus     = GetSysColor_(#COLOR_MENUHILIGHT)
          CompilerCase #PB_OS_MacOS
            TBEx()\Color\Back      = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor controlBackgroundColor"))
            TBEx()\Color\Separator = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor separatorColor"))
            TBEx()\Color\Focus     = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor selectedControlColor"))
            TBEx()\Color\Border    = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor grayColor"))
          CompilerCase #PB_OS_Linux

        CompilerEndSelect ;}
        
        TBEx()\Flags  = Flags
        
        BindGadgetEvent(TBEx()\CanvasNum, @_ResizeHandler(), #PB_EventType_Resize)
        
        If Flags & #AutoResize
          If IsWindow(WindowNum)
            TBEx()\Window\Width  = WindowWidth(WindowNum)
            TBEx()\Window\Height = WindowHeight(WindowNum)
            BindEvent(#PB_Event_SizeWindow, @_ResizeWindowHandler(), WindowNum)
          EndIf  
        EndIf
        
        BindGadgetEvent(GNum,  @_MouseMoveHandler(),      #PB_EventType_MouseMove)
        BindGadgetEvent(GNum,  @_LeftButtonDownHandler(), #PB_EventType_LeftButtonDown)
        BindGadgetEvent(GNum,  @_LeftButtonUpHandler(),   #PB_EventType_LeftButtonUp)
        BindGadgetEvent(GNum,  @_ResizeHandler(),         #PB_EventType_Resize)
        BindGadgetEvent(GNum,  @_MouseLeaveHandler(),     #PB_EventType_MouseLeave)
        
        BindEvent(#PB_Event_Menu, @_MenuEventHandler(), WindowNum)
        
        CompilerIf Defined(ModuleEx, #PB_Module)
          BindEvent(#Event_Theme, @_ThemeHandler())
        CompilerEndIf        
        
        If AdjustHeight : TBEx()\Size\Height = AdjustHeight_() : EndIf 
        
        TBEx()\ReDraw = #True
        
        Draw_()  
      
      EndIf
      
      CloseGadgetList()

    EndIf
    
    ProcedureReturn GNum
  EndProcedure    
  
  ;- ----- Toolbar - Items -----
  
  Procedure   ImageButton(GNum.i, ImageNum.i, EventNum.i=#False, Text.s="", EventID.s="", Flags.i=#False)
 
    If FindMapElement(TBEx(), Str(GNum))
      
      If AddElement(TBEx()\Items())
        
        TBEx()\Items()\Type       = #ImageButton
        TBEx()\Items()\Event      = EventNum
        TBEx()\Items()\EventID    = EventID
        TBEx()\Items()\Text       = Text
        TBEx()\Items()\ImageNum   = ImageNum
        TBEx()\Items()\Width      = TBEx()\Buttons\Width
        TBEx()\Items()\Height     = TBEx()\Buttons\Height
        TBEx()\Items()\PopupMenu = #NotValid
        TBEx()\Items()\Flags      = Flags
        
        If TBEx()\Flags & #ToolTips
          TBEx()\Items()\ToolTip = Text
        EndIf
        
        TBEx()\Size\Height = AdjustHeight_()
        
        If TBEx()\Flags & #AdjustAllButtons
          Draw_(#AdjustAllButtons)
        ElseIf TBEx()\Flags & #AdjustButtons
          Draw_(#AdjustButtons)
        Else
          If TBEx()\ReDraw : Draw_() : EndIf
        EndIf

      EndIf
      
    EndIf
    
  EndProcedure
  
  Procedure   TextButton(GNum.i, Text.s="", EventNum.i=#False, EventID.s="", Flags.i=#False)
 
    If FindMapElement(TBEx(), Str(GNum))
      
      If AddElement(TBEx()\Items())
        
        TBEx()\Items()\Type       = #TextButton
        TBEx()\Items()\Event      = EventNum
        TBEx()\Items()\EventID    = EventID
        TBEx()\Items()\Text       = Text
        TBEx()\Items()\Width      = TBEx()\Buttons\Width
        TBEx()\Items()\PopupMenu  = #NotValid
        TBEx()\Items()\Flags      = Flags
        
        If TBEx()\Flags & #ToolTips
          TBEx()\Items()\ToolTip = Text
        EndIf
        
        TBEx()\Size\Height = AdjustHeight_()
        
        If TBEx()\Flags & #AdjustAllButtons
          Draw_(#AdjustAllButtons)
        ElseIf TBEx()\Flags & #AdjustButtons
          Draw_(#AdjustButtons)
        Else
          If TBEx()\ReDraw : Draw_() : EndIf
        EndIf

      EndIf
      
    EndIf
    
  EndProcedure
  
  Procedure   Separator(GNum.i, Width.i=#PB_Default)
    
    If FindMapElement(TBEx(), Str(GNum))
      
      If Width = #PB_Default : Width = 10 : EndIf
      
      If AddElement(TBEx()\Items())
        
        TBEx()\Items()\Type  = #Separator
        TBEx()\Items()\Width = Width
        TBEx()\Items()\PopupMenu = #NotValid
        
        If TBEx()\ReDraw : Draw_() : EndIf
      EndIf 
      
    EndIf  
    
  EndProcedure  
  
  Procedure   Spacer(GNum.i)
    
    If FindMapElement(TBEx(), Str(GNum))
      
      If AddElement(TBEx()\Items())
        
        TBEx()\Items()\Type  = #Spacer
        TBEx()\Spacer + 1
        TBEx()\Items()\PopupMenu = #NotValid
        
        If TBEx()\ReDraw : Draw_() : EndIf
      EndIf 
      
    EndIf  
    
  EndProcedure 

  ; -----------------------------
  
  Procedure.i GetAttribute(GNum.i, Attribute.i)
    
    If FindMapElement(TBEx(), Str(GNum))
      
      Select Attribute
        Case #Height
          ProcedureReturn TBEx()\Size\Height
        Case #Spacing
          ProcedureReturn TBEx()\Size\Spacing
        Case #ButtonHeight
          ProcedureReturn TBEx()\Buttons\Height
        Case #ButtonWidth
          ProcedureReturn TBEx()\Buttons\Width
        Case #ButtonSpacing
          ProcedureReturn TBEx()\Buttons\Spacing
      EndSelect
      
      If TBEx()\ReDraw : Draw_() : EndIf
    EndIf
    
  EndProcedure
  
  Procedure.i GetGadgetNumber(GNum.i, TB_Index.i)
    
    If FindMapElement(TBEx(), Str(GNum))
      
      If SelectElement(TBEx()\Items(), TB_Index)
        If IsGadget(TBEx()\Items()\Num)
          ProcedureReturn TBEx()\Items()\Num
        EndIf
      EndIf
      
    EndIf
    
  EndProcedure
  
  Procedure.q GetData(GNum.i)
	  
	  If FindMapElement(TBEx(), Str(GNum))
	    ProcedureReturn TBEx()\Quad
	  EndIf  
	  
	EndProcedure	
	
	Procedure.s GetID(GNum.i)
	  
	  If FindMapElement(TBEx(), Str(GNum))
	    ProcedureReturn TBEx()\ID
	  EndIf
	  
	EndProcedure
  
  Procedure.i GetIndex(GNum.i, EventNum.i) 
    
    If FindMapElement(TBEx(), Str(GNum))
      
      ProcedureReturn GetIndex_(EventNum)
      
    EndIf
    
  EndProcedure  
  
  Procedure.i GetIndexFromID(GNum.i, EventID.s) 
    
    If FindMapElement(TBEx(), Str(GNum))
      
      ForEach TBEx()\Items()
        If TBEx()\Items()\EventID = EventID
          
          ProcedureReturn ListIndex(TBEx()\Items())
          
        EndIf  
      Next
      
    EndIf
    
  EndProcedure 
  
  
  Procedure.i Height(GNum.i)
    
    If FindMapElement(TBEx(), Str(GNum))
      ProcedureReturn TBEx()\Size\Height
    EndIf
    
  EndProcedure
 
  Procedure   Hide(GNum.i, State.i=#True)
  
    If FindMapElement(TBEx(), Str(GNum))
      
      If State
        TBEx()\Hide = #True
        HideGadget(GNum, #True)
      Else
        TBEx()\Hide = #False
        HideGadget(GNum, #False)
        Draw_()
      EndIf  
      
    EndIf  
    
  EndProcedure 
  
  Procedure   HideButton(GNum.i, Index.i, State.i)
    
    If FindMapElement(TBEx(), Str(GNum))
      
      If SelectElement(TBEx()\Items(), Index)
        
        If State
          TBEx()\Items()\Flags | #Hide
        Else
          TBEx()\Items()\Flags & ~#Hide
        EndIf
        
        If TBEx()\ReDraw : Draw_() : EndIf  
      EndIf
      
    EndIf  
    
  EndProcedure
  

  Procedure   RemoveItem(GNum.i, Index.i)
    
    If FindMapElement(TBEx(), Str(GNum))
      
      If SelectElement(TBEx()\Items(), Index)
        If TBEx()\Items()\Num
          If IsGadget(TBEx()\Items()\Num) : FreeGadget(TBEx()\Items()\Num) : EndIf
        EndIf 
        DeleteElement(TBEx()\Items())
      EndIf
      
      Draw_()
    EndIf  
 
  EndProcedure
  
 
  Procedure   SetAutoResizeFlags(GNum.i, Flags.i)
    
    If FindMapElement(TBEx(), Str(GNum))
      
      TBEx()\Size\Flags = Flags
      
    EndIf  
   
  EndProcedure
  
  Procedure   SetAttribute(GNum.i, Attribute.i, Value.i)
    
    If FindMapElement(TBEx(), Str(GNum))
      
      Select Attribute
        Case #Height
          TBEx()\Size\Height     = Value
        Case #Spacing
          TBEx()\Size\Spacing    = Value
        Case #ButtonHeight
          TBEx()\Buttons\Height  = Value
        Case #ButtonWidth
          TBEx()\Buttons\Width   = Value
        Case #ButtonSpacing
          TBEx()\Buttons\Spacing = Value
      EndSelect
      
      If TBEx()\ReDraw : Draw_() : EndIf
    EndIf
    
  EndProcedure
  
  Procedure   SetColor(GNum.i, ColorType.i, Color.i)
    
    If FindMapElement(TBEx(), Str(GNum))
      
      Select ColorType
        Case #FrontColor
          TBEx()\Color\Front     = Color
        Case #BackColor
          TBEx()\Color\Back      = Color
        Case #FocusColor
          TBEx()\Color\Focus     = Color
        Case #SeparatorColor
          TBEx()\Color\Separator = Color
        Case #BorderColor
          TBEx()\Color\Border    = Color
      EndSelect
      
      If TBEx()\ReDraw : Draw_() : EndIf
    EndIf
    
  EndProcedure
  
  Procedure   SetData(GNum.i, Value.q)
	  
	  If FindMapElement(TBEx(), Str(GNum))
	    TBEx()\Quad = Value
	  EndIf  
	  
	EndProcedure

  Procedure   SetFont(GNum.i, FontID.i)
    Define.i Flags
    
    If FindMapElement(TBEx(), Str(GNum))
      
      TBEx()\FontID = FontID
      
      CompilerIf #EnableToolBarGadgets
        
        ForEach TBEx()\Items()
          Select TBEx()\Items()\Type
            Case #ComboBox   ;{ ComboBox Font
              If IsGadget(TBEx()\Items()\Num)
                SetGadgetFont(TBEx()\Items()\Num, FontID)
              EndIf ;}
            Case #SpinGadget ;{ SpinGadget Font
              If IsGadget(TBEx()\Items()\Num)
                SetGadgetFont(TBEx()\Items()\Num, FontID)
              EndIf ;}
            Case #Button     ;{ TextButton Font
              If IsGadget(TBEx()\Items()\Num)
                SetGadgetFont(TBEx()\Items()\Num, FontID)
              EndIf ;}  
          EndSelect
        Next
        
      CompilerEndIf
      
      If TBEx()\Flags & #AdjustHeight Or TBEx()\Flags & #AdjustAllButtons Or TBEx()\Flags & #AdjustButtons
        
        If TBEx()\Flags & #AdjustHeight     : Flags | #AdjustHeight    : EndIf
        If TBEx()\Flags & #AdjustButtons    : Flags | #AdjustButtons    : EndIf
        If TBEx()\Flags & #AdjustAllButtons : Flags | #AdjustAllButtons : EndIf
        
        Draw_(Flags)
        
      Else
        If TBEx()\ReDraw : Draw_() : EndIf
      EndIf
      
    EndIf
    
  EndProcedure
  
  Procedure   SetID(GNum.i, String.s)
	  
	  If FindMapElement(TBEx(), Str(GNum))
	    TBEx()\ID = String
	  EndIf
	  
	EndProcedure   
  
  Procedure   SetPostEvent(GNum.i, Event.i=#Event_Gadget)
    
    If FindMapElement(TBEx(), Str(GNum))
      
      TBEx()\PostEvent = Event

    EndIf
    
  EndProcedure
  
 
  Procedure   ToolTip(GNum.i, TB_Index.i, Text.s, EventNum.i=#PB_Default) 
    
    If FindMapElement(TBEx(), Str(GNum))
      
      If EventNum <> #PB_Default : TB_Index = GetIndex_(EventNum) : EndIf
      
      If SelectElement(TBEx()\Items(), TB_Index)
        
        Select TBEx()\Items()\Type
          Case #ComboBox, #SpinGadget, #Button, #TrackBar
            If IsGadget(TBEx()\Items()\Num) : GadgetToolTip(TBEx()\Items()\Num, Text) : EndIf
          Default
            TBEx()\Items()\ToolTip = Text
        EndSelect    

      EndIf
      
    EndIf
    
  EndProcedure
  
  
  Procedure   Free(GNum.i)
    
    If FindMapElement(TBEx(), Str(GNum))
      
      DeleteMapElement(TBEx())
      
    EndIf
    
  EndProcedure
  
EndModule

;- ========  Module - Example ========

CompilerIf #PB_Compiler_IsMainFile
  
  Define.i IdxTB
  
  UsePNGImageDecoder()
  
  Enumeration 1  ;{ Gadgets
    #Window
    #ToolBar
    #Font
    #Popup
    #ComboBox
    #SpinBox
    #Button
    #TrackBar
  EndEnumeration ;}
  
  Enumeration 1  ;{ Images
    #IMG_New
    #IMG_Save
    #IMG_Copy
    #IMG_Cut
    #IMG_Paste
    #IMG_Help
    #IMG_Star
    #IMG_World
  EndEnumeration ;}
  
  Enumeration 10 ;{ Event number
    #TB_New
    #TB_Save
    #TB_Copy
    #TB_Cut
    #TB_Paste
    #TB_Help
    #Menu_Item1
    #Menu_Item2
  EndEnumeration ;}
  
  ;{ ----- Load resources -----
  LoadImage(#IMG_Save,  "Save.png")
  LoadImage(#IMG_Copy,  "Copy.png")
  LoadImage(#IMG_Cut,   "Cut.png")
  LoadImage(#IMG_Paste, "Paste.png")
  LoadImage(#IMG_Help,  "Help.png")
  LoadImage(#IMG_Star,  "Star16.png")
  LoadImage(#IMG_World, "World16.png")
  
  LoadFont(#Font, "Arial", 9)
  ;}

  
  If OpenWindow(#Window, 0, 0, 600, 300, "Example", #PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_SizeGadget)
    
    If CreatePopupImageMenu(#Popup)
      MenuItem(#Menu_Item1, "Star",  ImageID(#IMG_Star))
      MenuItem(#Menu_Item2, "World", ImageID(#IMG_World))
    EndIf

    ; ----- Add toolbar gadget -----
    
    ToolBar::Gadget(#ToolBar, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, ToolBar::#Border|ToolBar::#AutoResize|ToolBar::#ButtonText|ToolBar::#AdjustButtons|ToolBar::#RoundFocus|ToolBar::#ToolTips, #Window)
    ; |ToolBar::#TextInside|ToolBar::#AdjustHeight
    
    ToolBar::DisableRedraw(#ToolBar, #True)
    
    ; ----- Add items to toolbar
    
    ;ToolBar::ImageButton(#ToolBar, #IMG_New,   #TB_New,   "New",   "newID") 
    ToolBar::TextButton(#ToolBar, "New",       #TB_New,   "newID") 
    ToolBar::ImageButton(#ToolBar, #IMG_Save,  #TB_Save,  "Save",  "saveID")
    
    ToolBar::Separator(#ToolBar)
    
    ToolBar::ImageButton(#ToolBar, #IMG_Copy,  #TB_Copy,  "Copy",  "copyID")
    ToolBar::ImageButton(#ToolBar, #IMG_Cut,   #TB_Cut,   "Cut",   "cutID")
    ToolBar::ImageButton(#ToolBar, #IMG_Paste, #TB_Paste, "Paste", "pasteID")
    
    ToolBar::Separator(#ToolBar)
    
    CompilerIf ToolBar::#EnableToolBarGadgets
      ToolBar::ComboBox(#ToolBar, 60, 24, #ComboBox, "", "comboID")
      ToolBar::Separator(#ToolBar)
      ToolBar::SpinBox(#ToolBar,  40, 22, 1, 18, #SpinBox, "", "spinID", #PB_Spin_ReadOnly)
      ToolBar::Separator(#ToolBar)
      ToolBar::Button(#ToolBar,   60, 24, "Button", #Button, "buttonID", #PB_Button_Toggle)
      ToolBar::TrackBar(#ToolBar, 95, 24, 0, 10, #TrackBar, "trackID", #PB_TrackBar_Ticks)
    CompilerEndIf
    
    ToolBar::Spacer(#ToolBar)
    
    ToolBar::ImageButton(#ToolBar, #IMG_Help,  #TB_Help,  "Help",  "helpID")
    
    ; -------------------------------------------------------------------------
    
    ToolBar::SetFont(#ToolBar, FontID(#Font))
    
    ToolBar::ToolTip(#ToolBar,  #False, "ComboBox", #ComboBox)
    ToolBar::ToolTip(#ToolBar,  #False, "SpinBox", #SpinBox)
    ToolBar::ToolTip(#ToolBar,  #False, "TextButton", #Button)
    
    ;ToolBar::SetItemFlags(#ToolBar,  7, ToolBar::#Bottom)
    ;ToolBar::SetItemFlags(#ToolBar,  9, ToolBar::#Bottom)
    ;ToolBar::SetItemFlags(#ToolBar, 11, ToolBar::#Bottom)
    
    ToolBar::DisableRedraw(#ToolBar, #False)
    
    ; ----- Button with popupmenu -----
    
    IdxTB = ToolBar::GetIndex(#ToolBar, #TB_Save)
    ToolBar::AttachPopupMenu(#ToolBar, IdxTB, #Popup) 
    
    ;ToolBar::ButtonText(#ToolBar, 0, "Document")
    
    ToolBar::SetColor(#ToolBar, ToolBar::#FrontColor, $571313)
    
    ToolBar::DisableButton(#ToolBar, 3, #True)
    ;ToolBar::HideButton(#ToolBar, 3, #True)
    
    ToolBar::SetPostEvent(#ToolBar, #PB_Event_Menu)
    
    CompilerIf ToolBar::#EnableToolBarGadgets
      ; ---ComboBox---
      ToolBar::AddItem(#ToolBar, 7, -1, "Item 1")
      ToolBar::AddItem(#ToolBar, 7, -1, "Item 2")
      ToolBar::AddItem(#ToolBar, 7, -1, "Item 3")
      ToolBar::SetItemState(#ToolBar, 7, 0)
      
      ; --- SpinBox ---
      ToolBar::SetItemState(#ToolBar, 9, 9)
    CompilerEndIf
    
    ;ModuleEx::SetTheme(ModuleEx::#Theme_Blue)
    
    ;ToolBar::Disable(#ToolBar, #True)
    
    Repeat
      Event = WaitWindowEvent()
      Select Event
        Case #PB_Event_Menu  ;{ Menu Events
          Select EventMenu()
            Case #TB_New
              Debug "Menu Item: 'New' ("   + Str(ToolBar::EventNumber(#ToolBar)) + ")"
            Case #TB_Save 
              Debug "Menu Item: 'Save' ("  + Str(ToolBar::EventNumber(#ToolBar)) + ")"
            Case #TB_Copy 
              Debug "Menu Item: 'Copy' ("  + Str(ToolBar::EventNumber(#ToolBar)) + ")"
            Case #TB_Cut  
              Debug "Menu Item: 'Cut' ("   + Str(ToolBar::EventNumber(#ToolBar)) + ")"
            Case #TB_Paste
              Debug "Menu Item: 'Paste' (" + Str(ToolBar::EventNumber(#ToolBar)) + ")"
            Case #TB_Help
              Debug "Menu Item: 'Help' ("  + Str(ToolBar::EventNumber(#ToolBar)) + ")"
            Case #Menu_Item1
              Debug "PopupMenu: 'Star' ("+Str(#Menu_Item1)+")"
            Case #Menu_Item2
              Debug "PopupMenu: 'World' ("+Str(#Menu_Item2)+")"
          EndSelect ;}  
        Case #PB_Event_Gadget
          Select EventGadget()
            Case #ToolBar    ;{ ToolBar-Gadget
              Select EventType()
                Case ToolBar::#EventType_ImageButton
                  Debug "ImageButton clicked: " + Str(EventData()) + " [ Number: " +Str(ToolBar::EventNumber(#ToolBar))+" / ID: '"+ToolBar::EventID(#ToolBar)+ "' ]"
                Case ToolBar::#EventType_TextButton
                  Debug "TextButton clicked: " + Str(EventData()) + " [ Number: " +Str(ToolBar::EventNumber(#ToolBar))+" / ID: '"+ToolBar::EventID(#ToolBar)+ "' ]"
                Case ToolBar::#EventType_ComboBox ; EventNum = #PB_Ignore
                  Debug "ComboBox changed: " + Str(ToolBar::EventState(#ToolBar)) + " [ Index: " +Str(EventData())+" / ID: '"+ToolBar::EventID(#ToolBar)+ "' ]"
                Case ToolBar::#EventType_SpinBox  ; EventNum = #PB_Ignore
                  Debug "SpinBox changed: " + Str(ToolBar::EventState(#ToolBar))  + " [ Index: " +Str(EventData())+" / ID: '"+ToolBar::EventID(#ToolBar)+ "' ]"  
              EndSelect ;}
            Case #ComboBox   ;{ Gadget (Toolbar)
              Debug "ComboBox State: " + Str(EventData())
            Case #SpinBox  
              Debug "SpinBox State: " + Str(EventData())
            Case #Button
              If EventData() = #True
                Debug "Button: pressed" 
              Else
                Debug "Button: not pressed" 
              EndIf 
            Case #TrackBar
              Debug "TrackBar State: " + Str(EventData())  
              ;}
          EndSelect
       
      EndSelect
     Until Event = #PB_Event_CloseWindow
    
  EndIf
  
CompilerEndIf  
; IDE Options = PureBasic 6.00 LTS (Windows - x64)
; CursorPosition = 1161
; FirstLine = 410
; Folding = 5GAAAAMhQACyDKAA7DAAAIgQ6
; Markers = 1407
; EnableXP
; DPIAware
; Executable = Test.exe