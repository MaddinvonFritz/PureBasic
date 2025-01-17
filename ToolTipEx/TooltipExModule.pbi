﻿;/ ===========================
;/ =    ToolTipExModule.pbi    =
;/ ===========================
;/
;/ [ PB V5.7x / 64Bit / All OS / DPI ]
;/
;/ Extended ToolTips for all Gadgets
;/
;/ © 2020 by Thorsten Hoeppner (07/2019)
;/

; Last Update: 4.05.2022

; Changed: Timer


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

;{ ===== Tea & Pizza Ware =====
; <purebasic@thprogs.de> has created this code. 
; If you find the code useful and you want to use it for your programs, 
; you are welcome to support my work with a cup of tea or a pizza
; (or the amount of money for it). 
; [ https://www.paypal.me/Hoeppner1867 ]
;}


;{ _____ ToolTip - Commands _____

; ToolTip::Gadget()       - Add tooltip gadget
; ToolTip::SetAttribute() - similar to SetGadgetAttribute()
; ToolTip::SetColor()     - similar to SetGadgetColor()
; ToolTip::SetContent()   - set tooltip text & Title and define tooltip area
; ToolTip::SetFont()      - similar to SetGadgetFont()
; ToolTip::SetImage()     - adds an image to the tooltip
; ToolTip::SetState()     - activates/deactivates tooltip

;}

; XIncludeFile "ModuleEx.pbi"

DeclareModule ToolTip
  
  #Version  = 20032800
  #ModuleEx = 19111702
  
	;- ===========================================================================
	;-   DeclareModule - Constants
	;- ===========================================================================

  ;{ _____ Constants _____
  
  Enumeration 1
    #MouseX
    #MouseY
  EndEnumeration

  EnumerationBinary
    #MouseEnter
    #MouseLeave
    #MouseMove
  EndEnumeration
  
  #MouseEvents = #MouseEnter|#MouseLeave|#MouseMove
	
	Enumeration 1  ; Attribute
	  #PaddingX
	  #PaddingY
	  #Spacing
	  #Title
	  #Text
	EndEnumeration
	
	Enumeration 1  ; Color
	  #FrontColor
	  #BackColor
	  #BorderColor
	  #TitleColor
	  #TitleBackColor
	  #TitleBorderColor
	EndEnumeration
  
	EnumerationBinary ; GadgetFlags
		#Border ; Draw a border
	EndEnumeration

  CompilerIf Defined(ModuleEx, #PB_Module)
	  
	  #Event_ToolTip = ModuleEX::#Event_ToolTip
	  #Event_Theme   = ModuleEx::#Event_Theme
	  
	CompilerElse
	  
    Enumeration #PB_Event_FirstCustomValue
  		#Event_ToolTip
  	EndEnumeration
  	
  CompilerEndIf
	;}
	
	;- ===========================================================================
	;-   DeclareModule
	;- ===========================================================================
  
  Declare.q GetData(GNum.i)
	Declare.s GetID(GNum.i)
  Declare   SetData(GNum.i, Value.q)
	Declare   SetID(GNum.i, String.s)
  
	Declare.i Create(Gadget.i, Window.i, Flags.i=#False)
	Declare   SetAttribute(GNum.i, Attribute.i, Value.i) 
  Declare   SetColor(GNum.i, ColorTyp.i, Value.i)
  Declare   SetContent(GNum.i, Text.s, Title.s="", X.i=#PB_Default, Y.i=#PB_Default, Width.i=#PB_Default, Height.i=#PB_Default)
  Declare   SetFont(GNum.i, FontNum.i, FontType.i=#Text)
  Declare   SetImage(GNum.i, ImageNum.i, Width.i=#PB_Default, Height.i=#PB_Default, Flags.i=#False)
  Declare   SetState(GNum.i, State.i)
  
EndDeclareModule

Module ToolTip

	EnableExplicit
	
	#TooltipTimer    = 1867
	#MouseEventTimer = 1868
	
	Enumeration 1
    #MouseX
    #MouseY
    #Gadget
  EndEnumeration

  EnumerationBinary
    #MouseEnter
    #MouseLeave
    #MouseMove
  EndEnumeration
  #MouseEvents = #MouseEnter|#MouseLeave|#MouseMove
	
	;- ============================================================================
	;-   Module - Structures
	;- ============================================================================
  
  Structure MouseEvent_Window_Structure ;{ MouseEvent()\Window\...
    Num.i
    MouseX.i
    MouseY.i
  EndStructure ;}
  
  Structure MouseEvent_Gadget_Structure  ;{ MouseEvent()\Gadget('num')\...
    Num.i
    MouseX.i
    MouseY.i
  EndStructure ;}
  
  Structure MouseEvent_Structure        ;{ MouseEvent('Window')\...
    Window.MouseEvent_Window_Structure
    Map Gadget.MouseEvent_Gadget_Structure()
    lastGadget.i
    lastHandle.i
    Flags.i
  EndStructure ;}
  Global NewMap MouseEvent.MouseEvent_Structure()
    
	Structure Timer_Structure           ;{ Timer()\...
	  GadgetNum.i
	  WindowNum.i
	  Focus.i
	  State.i
	  Active.i
	  Delay.i
	  Value.i
	EndStructure ;}

	Structure ToolTip_Image_Structure   ;{ ToolTip\Image\...
	  Num.i
	  Width.i
	  Height.i
	  Flags.i
	EndStructure ;}
	
	Structure ToolTip_Area_Structure    ;{ ToolTip\Area\...
	  X.i
	  Y.i
	  Width.i
	  Height.i
	EndStructure   ;}
	
	Structure ToolTip_Content_Structure ;{ ToolTip\Content\...
	  Title.s
	  TitleFont.i
	  TextFont.i
	  List Text.s()
	EndStructure ;}
	
	Structure ToolTip_Color_Structure   ;{ ToolTip()\Color\...
		Front.i
		Back.i
		TitleFront.i
		TitleBack.i
		TitleBorder.i
		Border.i
	EndStructure  ;}

	Structure ToolTip_Size_Structure    ;{ ToolTip()\Size\...
		X.f
		Y.f
		Width.f
		Height.f
		Flags.i
	EndStructure ;}
  
	Structure ToolTip_Structure         ;{ ToolTip()\...
	  ID.s
    Quad.i
	  
	  Number.i
	  WindowNum.i
	  CanvasNum.i
	  GadgetNum.i
	  ContainerNum.i
	  
	  MouseX.i
	  MouseY.i
	  
	  Type.i

	  FontID.i
	  
	  PaddingX.f
	  PaddingY.f
	  Spacing.i
	  
	  Visible.i
	  
	  State.i
	  
	  Flags.i
	  
		Area.ToolTip_Area_Structure
		Color.ToolTip_Color_Structure
		Content.ToolTip_Content_Structure
		Image.ToolTip_Image_Structure
		Size.ToolTip_Size_Structure
		
	EndStructure ;}
	Global NewMap ToolTip.ToolTip_Structure()
	
	Global Mutex.i = CreateMutex()
	Global NewMap Timer.Timer_Structure()
	
	;- ============================================================================
	;-   Module - MouseEvents
	;- ============================================================================
	
  ;- _____ Import internal function _____
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    ; Code by mk-soft
    
    Import ""
      PB_Object_EnumerateStart( PB_Objects )
      PB_Object_EnumerateNext( PB_Objects, *ID.Integer )
      PB_Object_EnumerateAbort( PB_Objects )
      PB_Gadget_Objects.i
    EndImport
    
  CompilerElse
    
    ImportC ""
      PB_Object_EnumerateStart( PB_Objects )
      PB_Object_EnumerateNext( PB_Objects, *ID.Integer )
      PB_Object_EnumerateAbort( PB_Objects )
      PB_Gadget_Objects.i
    EndImport
    
  CompilerEndIf
  
  
	;- ============================================================================
	;-   Module - Internal
  ;- ============================================================================
  
	Declare.i GetMouseEventAttribute_(Window.i, Attribute.i, Gadget.i=#PB_Default)
	
	UsePNGImageDecoder()

	Procedure.f dpiX(Num.i)
		ProcedureReturn DesktopScaledX(Num)
	EndProcedure

	Procedure.f dpiY(Num.i)
		ProcedureReturn DesktopScaledY(Num)
	EndProcedure

	Procedure   GetFontID_(FontNum.i) 
	  
	  If FontNum = #PB_Default
	    ProcedureReturn ToolTip()\FontID
	  ElseIf IsFont(FontNum)
	    ProcedureReturn FontID(FontNum)
	  Else
	    ProcedureReturn ToolTip()\FontID
	  EndIf
	  
	EndProcedure
	
	Procedure.i MaxTextWidth(MaxWidth.i)
  	
	  ForEach ToolTip()\Content\Text()
	    If TextWidth(ToolTip()\Content\Text()) > MaxWidth
	      MaxWidth = TextWidth(ToolTip()\Content\Text())
	    EndIf
	  Next
	  
	  ProcedureReturn MaxWidth
	EndProcedure  
	
	Procedure   DeterminePosition_(X.i, Y.i)
	  Define.i gX, gY, wX, wY, gWidth, gHeight, wWidth, wHeight, PosX, PosY, Reverse
	  
	  If IsGadget(ToolTip()\GadgetNum)
  	  wX = dpiX(GadgetX(ToolTip()\GadgetNum, #PB_Gadget_ScreenCoordinate))
  	  wY = dpiY(GadgetY(ToolTip()\GadgetNum, #PB_Gadget_ScreenCoordinate))
  	  gX = dpiX(GadgetX(ToolTip()\GadgetNum, #PB_Gadget_WindowCoordinate))
  	  gY = dpiY(GadgetY(ToolTip()\GadgetNum, #PB_Gadget_WindowCoordinate))
  	  gWidth  = dpiX(GadgetWidth(ToolTip()\GadgetNum))
  	  gHeight = dpiY(GadgetHeight(ToolTip()\GadgetNum)) 
  	EndIf 
  	
  	If IsWindow(ToolTip()\WindowNum)
  	  wWidth  = dpiX(WindowWidth(ToolTip()\WindowNum))
  	  wHeight = dpiY(WindowHeight(ToolTip()\WindowNum))
  	EndIf
  	
  	PosX = X + gX + ToolTip()\Size\Width
  	PosY = Y + gY
  	
  	If PosX < wWidth
  	  ToolTip()\Size\X = X + wX
  	Else
  	  ToolTip()\Size\X = X + wX - ToolTip()\Size\Width
  	  Reverse = #True
  	EndIf
  	
  	If PosY - ToolTip()\Size\Height > 0 
  	  ToolTip()\Size\Y = Y + wY - ToolTip()\Size\Height + dpiY(1)
  	  ToolTip()\Size\X + dpiX(2)
  	ElseIf PosY + ToolTip()\Size\Height > wHeight
  	  ToolTip()\Size\Y = Y + wY - ToolTip()\Size\Height + dpiY(1)
  	  ToolTip()\Size\X + dpiX(2)
  	Else
  	  ToolTip()\Size\Y = Y + wY + dpiY(2)
  	  If Reverse = #False
  	    ToolTip()\Size\X + dpiX(8)
  	  EndIf
  	EndIf
  	
	EndProcedure
	
  Procedure   DetermineSize_()
	  Define.i Rows
	  Define.f MaxWidth, TitleWidth, TitleHeight, textHeight
	  
	  If StartDrawing(CanvasOutput(ToolTip()\CanvasNum))
	    
		  If ToolTip()\Content\Title
		    DrawingFont(GetFontID_(ToolTip()\Content\TitleFont))
  	    TitleWidth  = TextWidth(ToolTip()\Content\Title)  + dpiX(4)
  	    TitleHeight = TextHeight(ToolTip()\Content\Title) + dpiY(4)
    	EndIf
    	
    	Rows = ListSize(ToolTip()\Content\Text())
    	
    	DrawingFont(GetFontID_(ToolTip()\Content\TextFont))
    	
    	textHeight = TextHeight("Abc")
    	MaxWidth   = MaxTextWidth(TitleWidth)
    	
    	ToolTip()\Size\Width  = MaxWidth + (ToolTip()\PaddingX * 2)
    	ToolTip()\Size\Height = TitleHeight + (textHeight * Rows) + (ToolTip()\PaddingY * 2)
    	
    	If IsImage(ToolTip()\Image\Num)
    	  
    	  ToolTip()\Size\Width + ToolTip()\Image\Width + ToolTip()\PaddingY

    	  If ToolTip()\Image\Height + (ToolTip()\PaddingY * 2) > ToolTip()\Size\Height
      	  ToolTip()\Size\Height = ToolTip()\Image\Height + (ToolTip()\PaddingY * 2)
      	EndIf

    	EndIf

	    StopDrawing()
		EndIf  

	EndProcedure
	
	;- __________ Drawing __________

	Procedure.i BlendColor_(Color1.i, Color2.i, Factor.i=50)
		Define.i Red1, Green1, Blue1, Red2, Green2, Blue2
		Define.f Blend = Factor / 100

		Red1 = Red(Color1): Green1 = Green(Color1): Blue1 = Blue(Color1)
		Red2 = Red(Color2): Green2 = Green(Color2): Blue2 = Blue(Color2)

		ProcedureReturn RGB((Red1 * Blend) + (Red2 * (1 - Blend)), (Green1 * Blend) + (Green2 * (1 - Blend)), (Blue1 * Blend) + (Blue2 * (1 - Blend)))
	EndProcedure
	
	Procedure   Draw_()
		Define.i X, Y, Rows, TitleHeight, TextHeight, txtX, txtY, imgY
		
		If StartDrawing(CanvasOutput(ToolTip()\CanvasNum))

		  Rows = ListSize(ToolTip()\Content\Text())
		  
			;{ _____ Background _____
			DrawingMode(#PB_2DDrawing_Default)
			Box(0, 0, ToolTip()\Size\Width, ToolTip()\Size\Height, ToolTip()\Color\Back)
			;}
			
			X = ToolTip()\PaddingX

			If ToolTip()\Content\Title
			  Y = dpiY(2)
			  DrawingFont(GetFontID_(ToolTip()\Content\TitleFont))
			  TitleHeight = TextHeight(ToolTip()\Content\Title) + dpiY(4)
			  If ToolTip()\Color\TitleBack <> #PB_Default
			    DrawingMode(#PB_2DDrawing_Default)
			    Box(0, 0, ToolTip()\Size\Width, TitleHeight, ToolTip()\Color\TitleBack)
			  EndIf 
			  DrawingMode(#PB_2DDrawing_Transparent)
			  txtX = (ToolTip()\Size\Width - (ToolTip()\PaddingX * 2) - TextWidth(ToolTip()\Content\Title)) / 2
			  DrawText(X + txtX, Y, ToolTip()\Content\Title, ToolTip()\Color\TitleFront)
			  Y + TextHeight(ToolTip()\Content\Title)
			EndIf
			
			Y + ToolTip()\PaddingY
			
			If IsImage(ToolTip()\Image\Num)
			  TextHeight = ToolTip()\Size\Height - TitleHeight - (ToolTip()\PaddingX * 2)
			  imgY = (TextHeight - ToolTip()\Image\Height) / 2
			  txtY = (TextHeight - (TextHeight("Abc") * ListSize(ToolTip()\Content\Text()))) / 2
			  DrawingMode(#PB_2DDrawing_AlphaBlend)
			  DrawImage(ImageID(ToolTip()\Image\Num), X, Y + imgY, ToolTip()\Image\Width, ToolTip()\Image\Height) 
			  X + ToolTip()\Image\Width + ToolTip()\PaddingX
			EndIf
			
			DrawingMode(#PB_2DDrawing_Transparent)
			DrawingFont(GetFontID_(ToolTip()\Content\TextFont))
			
			ForEach ToolTip()\Content\Text()
			  DrawText(X, Y + txtY, ToolTip()\Content\Text(), ToolTip()\Color\Front)
			  Y + TextHeight(ToolTip()\Content\Text())
			Next
			
			;{ _____ Border ____
			DrawingMode(#PB_2DDrawing_Outlined)
			Box(0, 0, ToolTip()\Size\Width, ToolTip()\Size\Height, BlendColor_(ToolTip()\Color\Border, ToolTip()\Color\Back, 40))
			If ToolTip()\Content\Title
			  If ToolTip()\Color\TitleBorder <> #PB_Default
			    DrawingMode(#PB_2DDrawing_Outlined)
			    Box(0, 0, ToolTip()\Size\Width, TitleHeight, BlendColor_(ToolTip()\Color\Border, ToolTip()\Color\Back, 40))
			  EndIf 
			  
			EndIf
			;}
			
			StopDrawing()
		EndIf

	EndProcedure

	;- __________ Events __________
	
  CompilerIf Defined(ModuleEx, #PB_Module)
	  
	  Procedure _ThemeHandler()

      ForEach ToolTip()
        
        If IsFont(ModuleEx::ThemeGUI\Font\Num)
          ToolTip()\FontID = FontID(ModuleEx::ThemeGUI\Font\Num)
        EndIf
        
        ToolTip()\Color\Front       = ModuleEx::ThemeGUI\FrontColor
				ToolTip()\Color\Back        = ModuleEx::ThemeGUI\BackColor
				ToolTip()\Color\Border      = ModuleEx::ThemeGUI\BorderColor
				ToolTip()\Color\TitleFront  = ModuleEx::ThemeGUI\Title\FrontColor
				ToolTip()\Color\TitleBack   = ModuleEx::ThemeGUI\Title\BackColor
				ToolTip()\Color\TitleBorder = ModuleEx::ThemeGUI\Title\BorderColor

        Draw_()
      Next
      
    EndProcedure
    
  CompilerEndIf

	Procedure _ToolTipHandler()
	  Define.i GadgetNum = EventGadget()
	  
	  If FindMapElement(ToolTip(), Str(GadgetNum))
	    
	    If ToolTip()\State = #True
	      SetGadgetData(ToolTip()\CanvasNum, GadgetNum)
	      ResizeWindow(ToolTip()\Number, DesktopUnscaledX(ToolTip()\Size\X), DesktopUnscaledY(ToolTip()\Size\Y), DesktopUnscaledX(ToolTip()\Size\Width), DesktopUnscaledY(ToolTip()\Size\Height))
        ResizeGadget(ToolTip()\CanvasNum, 0, 0, DesktopUnscaledX(ToolTip()\Size\Width), DesktopUnscaledY(ToolTip()\Size\Height))
        Draw_()
        ToolTip()\Visible = #True
        HideWindow(ToolTip()\Number,  #False)
        SetActiveWindow(ToolTip()\WindowNum)
      EndIf

	  EndIf
	  
	EndProcedure
	
	Procedure _TimerEventHandler()
    Define.i X, Y, Handle, Window, Gadget, GadgetNum

    Window = GetActiveWindow()
    
    Select EventTimer()
      Case #TooltipTimer    ;{ Tooltip Delay
        
        LockMutex(Mutex)
        
        ForEach Timer()

          If Timer()\Focus And Timer()\State
    
  	        If Timer()\Active
  	          Timer()\Value + 200
  	          If Timer()\Value >= Timer()\Delay
  	            PostEvent(#Event_ToolTip, Timer()\WindowNum, Timer()\GadgetNum)
  	            Timer()\Value  = 0
  	            Timer()\Active = #False
  	          EndIf
  	          
  	        EndIf
  	        
  	      EndIf

  	    Next 
  	    
  	    UnlockMutex(Mutex)
        ;}
      Case #MouseEventTimer ;{ MouseEvents
        
        If FindMapElement(MouseEvent(), Str(Window))
    
          X = WindowMouseX(Window)
          Y = WindowMouseY(Window)
          
          If X <> MouseEvent()\Window\MouseX Or Y <> MouseEvent()\Window\MouseY
            
            MouseEvent()\Window\MouseX = X
            MouseEvent()\Window\MouseY = Y
            
            ; Get Handle under mouse (mk-soft)
            CompilerSelect #PB_Compiler_OS
              CompilerCase #PB_OS_Windows ;{ Windows
                Protected.i DesktopX, DesktopY
                
                DesktopX = DesktopMouseX()
                Desktopy = DesktopMouseY()
                Handle   = WindowFromPoint_(DesktopY << 32 | DesktopX)
                ;}
              CompilerCase #PB_OS_MacOS   ;{ MacOS
                Protected WinID.i, WinCV.i, pt.NSPoint
                
                WinID = WindowID(Window)
                WinCV = CocoaMessage(0, WinID, "contentView")
                CocoaMessage(@pt, WinID, "mouseLocationOutsideOfEventStream")
                Handle = CocoaMessage(0, WinCV, "hitTest:@", @pt)
                ;}
              CompilerCase #PB_OS_Linux   ;{ Linux
                Protected DesktopX.i, DesktopY.i, *GdkWindow.GdkWindowObject
                
                *GdkWindow.GdkWindowObject = gdk_window_at_pointer_(@DesktopX,@Desktopy)
                If *GdkWindow
                  gdk_window_get_user_data_(*GdkWindow, @Handle)
                Else
                  Handle = #False
                EndIf
                ;} 
            CompilerEndSelect
            
            If Handle <> MouseEvent()\lastHandle
              
              ;{ ___ Event: MouseLeave ___ (mk-soft)
              If IsGadget(MouseEvent()\lastGadget)
              
                If MouseEvent()\Flags & #MouseLeave
                  If GadgetType(MouseEvent()\lastGadget) <> #PB_GadgetType_Canvas
                    ForEach MouseEvent()\Gadget()
                      If MouseEvent()\Gadget()\Num = #PB_Default Or MouseEvent()\lastGadget = MouseEvent()\Gadget()\Num
                        PostEvent(#PB_Event_Gadget, MouseEvent()\Window\Num, MouseEvent()\lastGadget, #PB_EventType_MouseLeave)
                        Break
                      EndIf
                    Next
                  EndIf
                EndIf
                
                MouseEvent()\lastGadget = #PB_Default
                
              EndIf ;}
              
              ; Find GadgetID over Handle (mk-soft)
              PB_Object_EnumerateStart(PB_Gadget_Objects)
              
              While PB_Object_EnumerateNext(PB_Gadget_Objects, @Gadget)
                
                If Handle = GadgetID(Gadget)
                  
                  MouseEvent()\lastGadget = Gadget
                  
                  ;{ ___ Event: MouseEnter ___ (mk-soft)
                  If MouseEvent()\Flags & #MouseEnter
                    If GadgetType(MouseEvent()\lastGadget) <> #PB_GadgetType_Canvas
                      ForEach MouseEvent()\Gadget()
                        If MouseEvent()\Gadget()\Num = #PB_Default Or MouseEvent()\lastGadget = MouseEvent()\Gadget()\Num
                          PostEvent(#PB_Event_Gadget, MouseEvent()\Window\Num, MouseEvent()\lastGadget, #PB_EventType_MouseEnter)
                          Break
                        EndIf  
                      Next
                    EndIf
                  EndIf ;}
                  
                  PB_Object_EnumerateAbort(PB_Gadget_Objects)
                  Break
                EndIf
                
              Wend
              
              MouseEvent()\lastHandle = Handle
            EndIf
            
            ;{ ___ Event: MouseMove ___ (mk-soft)
            If MouseEvent()\Flags & #MouseMove
              
              If IsGadget(MouseEvent()\lastGadget)
                If GadgetType(MouseEvent()\lastGadget) <> #PB_GadgetType_Canvas
                  ForEach MouseEvent()\Gadget()
                    If MouseEvent()\Gadget()\Num = #PB_Default Or MouseEvent()\lastGadget = MouseEvent()\Gadget()\Num
                      MouseEvent()\Gadget()\MouseX = MouseEvent()\Window\MouseX - GadgetX(MouseEvent()\lastGadget, #PB_Gadget_WindowCoordinate)
                      MouseEvent()\Gadget()\MouseY = MouseEvent()\Window\MouseY - GadgetY(MouseEvent()\lastGadget, #PB_Gadget_WindowCoordinate)
                      PostEvent(#PB_Event_Gadget, MouseEvent()\Window\Num, MouseEvent()\lastGadget, #PB_EventType_MouseMove)
                      Break
                    EndIf 
                  Next
                EndIf
              EndIf
              
            EndIf ;}
            
          EndIf
          
        EndIf
      ;}
    EndSelect
  
  EndProcedure
	
  Procedure _MouseEnterHandler()
	  Define.i GadgetNum = EventGadget()

	  If FindMapElement(ToolTip(), Str(GadgetNum))
	    LockMutex(Mutex)
	    Timer(Str(GadgetNum))\Focus = #True
	    Timer(Str(GadgetNum))\Value = 0
	    Timer(Str(GadgetNum))\State = #False
	    UnlockMutex(Mutex)
	  EndIf
	  
	EndProcedure
	
	Procedure _MouseLeaveHandler()
	  Define.i GadgetNum = EventGadget()

	  If FindMapElement(ToolTip(), Str(GadgetNum))
	    
	    LockMutex(Mutex)
	    
	    Timer(Str(GadgetNum))\Focus  = #False
	    Timer(Str(GadgetNum))\Active = #True
	    Timer(Str(GadgetNum))\Value  = 0
	    Timer(Str(GadgetNum))\State  = #False
	    
	    UnlockMutex(Mutex)
	    
	    ToolTip()\MouseX  = #PB_Default
	    ToolTip()\MouseY  = #PB_Default
	    ToolTip()\Visible = #False
	    
	    HideWindow(ToolTip()\Number, #True)

	    SetActiveWindow(ToolTip()\WindowNum)
	  EndIf
	  
	EndProcedure
	
	Procedure _MouseMoveHandler()
    Define.i X, Y, aX, aY, aWidth, aHeight, gWidth, gHeight
    Define.i GadgetNum = EventGadget()

    If FindMapElement(ToolTip(), Str(GadgetNum))
      
      If GadgetType(GadgetNum) = #PB_GadgetType_Canvas
        X = GetGadgetAttribute(GadgetNum, #PB_Canvas_MouseX)
        Y = GetGadgetAttribute(GadgetNum, #PB_Canvas_MouseY)
      Else
        X = GetMouseEventAttribute_(ToolTip()\WindowNum, #MouseX, GadgetNum)
        Y = GetMouseEventAttribute_(ToolTip()\WindowNum, #MouseY, GadgetNum)
      EndIf

      If X <> ToolTip()\MouseX Or Y <> ToolTip()\MouseY
        
        ToolTip()\MouseX = X
        ToolTip()\MouseY = Y
        
        ;{ Cursor move
        LockMutex(Mutex)
        
        Timer(Str(GadgetNum))\Active = #True
        Timer(Str(GadgetNum))\Value  = 0
        
        UnlockMutex(Mutex)

        If ToolTip()\Visible
          
          LockMutex(Mutex)
    	    Timer(Str(GadgetNum))\Focus  = #False
    	    Timer(Str(GadgetNum))\Active = #True
    	    Timer(Str(GadgetNum))\Value  = 0
    	    Timer(Str(GadgetNum))\State  = #False
    	    UnlockMutex(Mutex)
	    
    	    ToolTip()\MouseX  = #PB_Default
    	    ToolTip()\MouseY  = #PB_Default
    	    ToolTip()\Visible = #False
    	    
          HideWindow(ToolTip()\Number, #True)
          
          SetActiveWindow(ToolTip()\WindowNum)
        EndIf
        ;}
        
        
        If X >= ToolTip()\Area\X And X <= ToolTip()\Area\X + ToolTip()\Area\Width
          If Y >= ToolTip()\Area\Y And Y <= ToolTip()\Area\Y + ToolTip()\Area\Height
            
      	    DetermineSize_() 
            DeterminePosition_(X, Y)                 
            LockMutex(Mutex)
            Timer(Str(GadgetNum))\State = #True
            UnlockMutex(Mutex)
            
            ProcedureReturn #True
          EndIf 
        EndIf  

        Timer()\State = #False

      EndIf
      
    EndIf
    
  EndProcedure 
  
  Procedure _MouseLeftClickHandler()
    Define.i GadgetNum
    Define.i TooltipNum = EventGadget()
    
    GadgetNum = GetGadgetData(TooltipNum)
    
    If FindMapElement(ToolTip(), Str(GadgetNum))
      
      LockMutex(Mutex)
	    Timer(Str(GadgetNum))\Focus  = #False
	    Timer(Str(GadgetNum))\Active = #True
	    Timer(Str(GadgetNum))\Value  = 0
	    Timer(Str(GadgetNum))\State  = #False
	    UnlockMutex(Mutex)
	    
	    ToolTip()\MouseX  = #PB_Default
	    ToolTip()\MouseY  = #PB_Default
	    ToolTip()\Visible = #False
	    
	    HideWindow(ToolTip()\Number, #True)
	    
	    SetActiveWindow(ToolTip()\WindowNum)
      
	    PostEvent(#PB_Event_Gadget, ToolTip()\WindowNum, ToolTip()\GadgetNum, #PB_EventType_LeftClick)
	    
    EndIf  
    
  EndProcedure
  
  Procedure _MouseRightClickHandler()
    Define.i GadgetNum
    Define.i TooltipNum = EventGadget()
    
    GadgetNum = GetGadgetData(TooltipNum)
    
    If FindMapElement(ToolTip(), Str(GadgetNum))
      
      LockMutex(Mutex)
	    Timer(Str(GadgetNum))\Focus  = #False
	    Timer(Str(GadgetNum))\Active = #True
	    Timer(Str(GadgetNum))\Value  = 0
	    Timer(Str(GadgetNum))\State  = #False
	    UnlockMutex(Mutex)
	    
	    ToolTip()\MouseX  = #PB_Default
	    ToolTip()\MouseY  = #PB_Default
	    ToolTip()\Visible = #False
	    
	    HideWindow(ToolTip()\Number, #True)
	    
	    SetActiveWindow(ToolTip()\WindowNum)
      
	    PostEvent(#PB_Event_Gadget, ToolTip()\WindowNum, ToolTip()\GadgetNum, #PB_EventType_RightClick)
	    
    EndIf  
    
  EndProcedure
  
  Procedure _CloseWindowHandler()
    Define.i WindowNum = EventWindow()
    
    ForEach ToolTip()
      
      If ToolTip()\WindowNum = WindowNum
      
        ;StopTimerThread()  
        RemoveWindowTimer(ToolTip()\WindowNum, #TooltipTimer)
        RemoveWindowTimer(ToolTip()\WindowNum, #MouseEventTimer)
        
        If IsWindow(ToolTip()\Number)
          CloseWindow(ToolTip()\Number)
        EndIf
        
        DeleteMapElement(Timer(),      Str(ToolTip()\GadgetNum))
        DeleteMapElement(MouseEvent(), Str(WindowNum))
        DeleteMapElement(ToolTip())
      EndIf
      
    Next
    
  EndProcedure
  
  ;- _____ Procedures - MouseEvents _____
  
  Procedure.i AddMouseEvents_(Window.i, Gadget.i=#PB_Default, Flags.i=#MouseEvents)
    
    If IsWindow(Window)
      
      If FindMapElement(MouseEvent(), Str(Window)) = #False
        AddMapElement(MouseEvent(), Str(Window))
      EndIf 

      MouseEvent()\Window\Num = Window
      
      If IsGadget(Gadget)
        MouseEvent()\Gadget(Str(Gadget))\Num = Gadget
      Else
        MouseEvent()\Gadget(Str(Gadget))\Num = #PB_Default
      EndIf
      
      MouseEvent()\Flags = Flags
      
      ; Code by mk-soft
      AddWindowTimer(MouseEvent()\Window\Num, #MouseEventTimer, 100)

      ProcedureReturn #True
    EndIf
    
  EndProcedure
  
  Procedure.i GetMouseEventAttribute_(Window.i, Attribute.i, Gadget.i=#PB_Default)
    
    If FindMapElement(MouseEvent(), Str(Window))
      
      If Gadget = #PB_Default Or MouseEvent()\lastGadget = Gadget
        
        Select Attribute
          Case #MouseX
            ProcedureReturn MouseEvent()\Gadget(Str(Gadget))\MouseX
          Case #MouseY
            ProcedureReturn MouseEvent()\Gadget(Str(Gadget))\MouseY
          Case #Gadget
            ProcedureReturn MouseEvent()\lastGadget
        EndSelect

      EndIf  
      
    EndIf
    
    ProcedureReturn #PB_Default
  EndProcedure
  
	;- ==========================================================================
	;-   Module - Declared Procedures
	;- ==========================================================================
  
  Procedure.q GetData(GNum.i)
	  
	  If FindMapElement(ToolTip(), Str(GNum))
	    ProcedureReturn ToolTip()\Quad
	  EndIf  
	  
	EndProcedure	
	
	Procedure.s GetID(GNum.i)
	  
	  If FindMapElement(ToolTip(), Str(GNum))
	    ProcedureReturn ToolTip()\ID
	  EndIf
	  
	EndProcedure

  Procedure   SetData(GNum.i, Value.q)
	  
	  If FindMapElement(ToolTip(), Str(GNum))
	    ToolTip()\Quad = Value
	  EndIf  
	  
	EndProcedure
	
	Procedure   SetID(GNum.i, String.s)
	  
	  If FindMapElement(ToolTip(), Str(GNum))
	    ToolTip()\ID = String
	  EndIf
	  
	EndProcedure
  
  
  Procedure.i Create(Gadget.i, Window.i, Flags.i=#False)
		Define DummyNum, GNum.i, WNum.i
		
		CompilerIf Defined(ModuleEx, #PB_Module)
      If ModuleEx::#Version < #ModuleEx : Debug "Please update ModuleEx.pbi" : EndIf 
    CompilerEndIf

  	If AddMapElement(ToolTip(), Str(Gadget))
 
  	  ToolTip()\Number       = OpenWindow(#PB_Any, 0, 0, 0, 0, "ToolTip", #PB_Window_BorderLess|#PB_Window_Invisible, WindowID(Window))
  		ToolTip()\CanvasNum    = CanvasGadget(#PB_Any, 10, 10, 200, 100)
  		ToolTip()\GadgetNum    = Gadget
  		ToolTip()\WindowNum    = Window
  
  		ToolTip()\Type = #Gadget
  		
  		CompilerSelect #PB_Compiler_OS           ;{ Default Gadget Font
  			CompilerCase #PB_OS_Windows
  				ToolTip()\FontID = GetGadgetFont(#PB_Default)
  			CompilerCase #PB_OS_MacOS
  				DummyNum = TextGadget(#PB_Any, 0, 0, 0, 0, " ")
  				If DummyNum
  					ToolTip()\FontID = GetGadgetFont(DummyNum)
  					FreeGadget(DummyNum)
  				EndIf
  			CompilerCase #PB_OS_Linux
  				ToolTip()\FontID = GetGadgetFont(#PB_Default)
  		CompilerEndSelect ;}
  		
  		ToolTip()\Content\TitleFont = #PB_Default
  		ToolTip()\Content\TextFont  = #PB_Default
  		
  		ToolTip()\Area\X = #PB_Default
  		ToolTip()\Area\Y = #PB_Default
  		ToolTip()\Area\Width  = #PB_Default
  		ToolTip()\Area\Height = #PB_Default
  		
  		ToolTip()\PaddingX = dpiX(5)
  		ToolTip()\PaddingY = dpiY(5)
  		ToolTip()\Spacing  = 0
  		
  		ToolTip()\Flags   = Flags
  
  		ToolTip()\Color\Front       = $000000
  		ToolTip()\Color\Back        = $F0FFFF
  		ToolTip()\Color\Border      = $B4B4B4
  		ToolTip()\Color\TitleFront  = $000000
  		ToolTip()\Color\TitleBack   = #PB_Default
  		ToolTip()\Color\TitleBorder = #PB_Default
  		
  		If GadgetType(ToolTip()\GadgetNum) <> #PB_GadgetType_Canvas
  		  AddMouseEvents_(ToolTip()\WindowNum, ToolTip()\GadgetNum)
  		EndIf
  		
  		If IsGadget(ToolTip()\GadgetNum)
  		  BindGadgetEvent(ToolTip()\GadgetNum, @_MouseEnterHandler(), #PB_EventType_MouseEnter)
  		  BindGadgetEvent(ToolTip()\GadgetNum, @_MouseLeaveHandler(), #PB_EventType_MouseLeave)
  		  BindGadgetEvent(ToolTip()\GadgetNum, @_MouseMoveHandler(),  #PB_EventType_MouseMove)
  		EndIf
  		
  		If IsGadget(ToolTip()\CanvasNum)
  		  BindGadgetEvent(ToolTip()\CanvasNum, @_MouseLeftClickHandler(),  #PB_EventType_LeftClick)
  		  BindGadgetEvent(ToolTip()\CanvasNum, @_MouseRightClickHandler(), #PB_EventType_RightClick)
  		EndIf  
  		
  		BindEvent(#Event_ToolTip, @_ToolTipHandler())
  		
  		CompilerIf Defined(ModuleEx, #PB_Module)
        BindEvent(#Event_Theme, @_ThemeHandler())
      CompilerEndIf
  		
      If IsWindow(ToolTip()\WindowNum)
        AddWindowTimer(ToolTip()\WindowNum, #TooltipTimer, 200)
        BindEvent(#PB_Event_Timer,       @_TimerEventHandler(),  ToolTip()\WindowNum)
        BindEvent(#PB_Event_CloseWindow, @_CloseWindowHandler(), ToolTip()\WindowNum)
      EndIf

      
      If AddMapElement(Timer(), Str(Gadget))
        Timer()\Delay     = 600
        Timer()\GadgetNum = ToolTip()\GadgetNum
        Timer()\WindowNum = ToolTip()\WindowNum
      EndIf
      
      ;SetActiveWindow(ToolTip()\WindowNum)
      
  		ProcedureReturn ToolTip()\CanvasNum
  	EndIf
    
	EndProcedure

	Procedure   SetAttribute(GNum.i, Attribute.i, Value.i) 
    
    If FindMapElement(ToolTip(), Str(GNum))
      
      Select Attribute
        Case #PaddingX
          ToolTip()\PaddingX = dpiX(Value)
        Case #PaddingY  
          ToolTip()\PaddingY = dpiY(Value)
        Case #Spacing  
          ToolTip()\Spacing  = dpiY(Value)
      EndSelect
      
      Draw_()
    EndIf
    
  EndProcedure 
	
  Procedure   SetColor(GNum.i, ColorTyp.i, Value.i)
    
    If FindMapElement(ToolTip(), Str(GNum))
    
      Select ColorTyp
        Case #FrontColor
          ToolTip()\Color\Front  = Value
        Case #BackColor
          ToolTip()\Color\Back   = Value
        Case #BorderColor
          ToolTip()\Color\Border = Value
        Case #TitleColor
          ToolTip()\Color\TitleFront  = Value
	      Case #TitleBackColor  
	        ToolTip()\Color\TitleBack   = Value
	      Case #TitleBorderColor
	        ToolTip()\Color\TitleBorder = Value
      EndSelect

    EndIf
    
  EndProcedure
  
  Procedure   SetContent(GNum.i, Text.s, Title.s="", X.i=#PB_Default, Y.i=#PB_Default, Width.i=#PB_Default, Height.i=#PB_Default)
    Define.i r, Rows
    
    If FindMapElement(ToolTip(), Str(GNum))

      ToolTip()\Content\Title = Title
      
      Rows = CountString(Text, #LF$) + 1
      
      ClearList(ToolTip()\Content\Text())
      For r=1 To Rows
        If AddElement(ToolTip()\Content\Text())
          ToolTip()\Content\Text() = RTrim(StringField(Text, r, #LF$), #CR$)
        EndIf
      Next

      If X = #PB_Default
        ToolTip()\Area\X = 0
      Else  
        ToolTip()\Area\X = dpiX(X)
      EndIf
      
      ToolTip()\Area\Y = Y
      If Y = #PB_Default
        ToolTip()\Area\Y = 0
      Else
        ToolTip()\Area\Y = dpiY(Y)
      EndIf

      If IsGadget(GNum)
        
        If Width  = #PB_Default
          ToolTip()\Area\Width  = dpiX(GadgetWidth(GNum))
        Else  
          ToolTip()\Area\Width  = dpiX(Width)
        EndIf
        
        If Height = #PB_Default
          ToolTip()\Area\Height = dpiY(GadgetHeight(GNum))
        Else
          ToolTip()\Area\Height = dpiY(Height) 
        EndIf
        
      EndIf
    
      DetermineSize_()
      
      ToolTip()\State = #True
      
    EndIf  
    
  EndProcedure
  
  Procedure   SetFont(GNum.i, FontNum.i, FontType.i=#Text) 
    
    If FindMapElement(ToolTip(), Str(GNum))
      
      Select FontType
        Case #Title
          ToolTip()\Content\TitleFont = FontNum
        Case #Text
          ToolTip()\Content\TextFont  = FontNum
      EndSelect
      
    EndIf
    
  EndProcedure  
  
  Procedure   SetImage(GNum.i, ImageNum.i, Width.i=#PB_Default, Height.i=#PB_Default, Flags.i=#False)
    
    If FindMapElement(ToolTip(), Str(GNum))
      
      If IsImage(ImageNum)
        
        If Width  = #PB_Default : Width  = ImageWidth(ImageNum)  : EndIf 
        If Height = #PB_Default : Height = ImageHeight(ImageNum) : EndIf
         
        ToolTip()\Image\Num    = ImageNum
        ToolTip()\Image\Width  = dpiX(Width)
        ToolTip()\Image\Height = dpiY(Height)
        ToolTip()\Image\Flags  = Flags
      EndIf
    
    EndIf  
      
  EndProcedure
  
  Procedure   SetState(GNum.i, State.i)
    
    If FindMapElement(ToolTip(), Str(GNum))
      ToolTip()\State = State
    EndIf
    
  EndProcedure

EndModule

;- ========  Module - Example ========

CompilerIf #PB_Compiler_IsMainFile
  
  UsePNGImageDecoder()
  
  Enumeration 
    #Window
    #Canvas
    #Container
    #Font
    #Image
    #Button
  EndEnumeration
  
  LoadFont(#Font, "Arial", 9, #PB_Font_Bold)
  ;LoadImage(#Image, "Paper.png")
  
  
  If OpenWindow(#Window, 0, 0, 210, 100, "Example", #PB_Window_SystemMenu|#PB_Window_Tool|#PB_Window_ScreenCentered|#PB_Window_SizeGadget)
    
    If CanvasGadget(#Canvas, 10, 10, 80, 80, #PB_Canvas_Border)
      If StartDrawing(CanvasOutput(#Canvas))
        DrawingMode(#PB_2DDrawing_Outlined)
			  Box(DesktopScaledX(30), DesktopScaledY(30), DesktopScaledX(20), DesktopScaledY(20), $800080)
        StopDrawing()
      EndIf  
    EndIf

    ;ButtonGadget(#Button, 100, 35, 90, 30, "Button")
    
    If ContainerGadget(#Container, 100, 35, 100, 50, #PB_Container_Flat)
      ButtonGadget(#Button, 10, 10, 80, 30, "Button")
      ;ButtonImageGadget(#Button, 10, 10, 80, 30, #False)
      CloseGadgetList()
    EndIf 
    
    
   If ToolTip::Create(#Canvas, #Window)
      ToolTip::SetContent(#Canvas, "This is Tooltip area.", "CanvasGadget", 30, 30, 20, 20)
      ToolTip::SetFont(#Canvas, #Font, ToolTip::#Title) 
      ToolTip::SetColor(#Canvas, ToolTip::#BorderColor,      $800000)
      ToolTip::SetColor(#Canvas, ToolTip::#BackColor,        $FFFFFA)
      ToolTip::SetColor(#Canvas, ToolTip::#TitleBorderColor, $800000)
      ToolTip::SetColor(#Canvas, ToolTip::#TitleBackColor,   $B48246)
      ToolTip::SetColor(#Canvas, ToolTip::#TitleColor,       $FFFFFF)
      ;ToolTip::SetImage(#Canvas, #Image)
    EndIf
    
    If ToolTip::Create(#Button, #Window)
      ToolTip::SetContent(#Button, "This is a tooltip.", "ButtonGadget")
      ToolTip::SetFont(#Button, #Font, ToolTip::#Title) 
      ToolTip::SetColor(#Button, ToolTip::#TitleBorderColor, $0B86B8)
      ToolTip::SetColor(#Button, ToolTip::#TitleBackColor,   $00D7FF)
      ToolTip::SetColor(#Button, ToolTip::#TitleColor,       $0B2851)
    EndIf
    
    Repeat
      Event = WaitWindowEvent()
      Select Event
        Case #PB_Event_Gadget  
          Select EventGadget()  
            Case #Button
              If EventType() = #PB_EventType_LeftClick
                Debug "Button clicked"
              EndIf   
          EndSelect
      EndSelect        
    Until Event = #PB_Event_CloseWindow

    CloseWindow(#Window)
  EndIf 
  
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; CursorPosition = 1006
; FirstLine = 257
; Folding = 5BAAACACgA5
; Markers = 752
; EnableXP
; DPIAware