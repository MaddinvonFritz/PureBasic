;/ ============================
;/ =   DPI-Module.pbi   =
;/ ============================
;/
;/ [ PB V5.7x - V6.0 / 64Bit / all OS / DPI ]
;/
;/ © 2022 Thorsten Hoeppner (06/2022)


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

;{ ===== Additional tea & pizza license =====
; <Thorsten1867@gmx.de> has created this code. 
; If you find the code useful and you want to use it for your programs, 
; you are welcome to support my work with a cup of tea or a pizza
; (or the amount of money for it). 
; [ https://www.paypal.me/Hoeppner1867 ]
;}



;{ _____ DPI - Commands _____

; DPI::X(Num.i)
; DPI::Y(Num.i) 

;- ----- Canvas Gadget -----

; DPI::GetCanvasMouseX(Gadget.i)
; DPI::GetCanvasMouseY(Gadget.i)

;- ----- 2D-Drawing -----

; DPI::Box_(X.i, Y.i, Width.i, Height.i, Color.i=#PB_Ignore)
; DPI::BoxedGradient_(X.i, Y.i, Width.i, Height.i)
; DPI::Circle_(X.i, Y.i, Radius.i, Color.i=#PB_Ignore) 
; DPI::ClipOutput_(X.i, Y.i, Width.i, Height.i) 
; DPI::ConicalGradient_(X.i, Y.i, Angle.f)
; DPI::DrawAlphaImage_(ImageID.i, X.i, Y.i, Alpha.i=0)
; DPI::DrawImage_(ImageID.i, X.i, Y.i, Width.i=#PB_Ignore, Height.i=#PB_Ignore) 
; DPI::DrawRotatedText_(X.i, Y.i, Text$, Angle.f, Color.i=#PB_Ignore)
; DPI::DrawText_(X.i, Y.i, Text$, FrontColor.i=#PB_Ignore, BackColor.i=#PB_Default)
; DPI::Ellipse_(X.i, Y.i, RadiusX.i, RadiusY.i, Color.i=#PB_Ignore) 
; DPI::EllipticalGradient_(X.i, Y.i, RadiusX.i, RadiusY.i) 
; DPI::FillArea_(X.i, Y.i, OutlineColor.i, FillColor.i=#PB_Ignore)
; DPI::Line_(X.i, Y.i, Width.i, Height.i, Color.i=#PB_Ignore) 
; DPI::LineXY_(X1.i, Y1.i, X2.i, Y2.i, Color.i=#PB_Ignore) 
; DPI::LinearGradient_(X1.i, Y1.i, X2.i, Y2.i)
; DPI::Plot_(X.i, Y.i, Color.i=#PB_Ignore)
; DPI::Point_(X.i, Y.i)
; DPI::RoundBox_(X.i, Y.i, Width.i, Height.i, RoundX.i, RoundY.i, Color.i=#PB_Ignore)
; DPI::TextWidth_(Text$)  
; DPI::TextHeight_(Text$)
; DPI::UnclipOutput_()

;- ----- VectorDrawing -----

; DPI::Scale()
; DPI::VectorFont_(FontID.i, Size.i)

;}

DeclareModule DPI
  
  ;- ===========================================================================
	;- DeclareModule - Procedures
	;- ===========================================================================
  
  Declare.f X(Num.i)
  Declare.f Y(Num.i) 
  
  ;- ----- Canvas Gadget -----
  
  Declare.i GetCanvasMouseX(Gadget.i)
  Declare.i GetCanvasMouseY(Gadget.i)
  
  ;- ----- 2D-Drawing -----
  
  Declare   Box_(X.i, Y.i, Width.i, Height.i, Color.i=#PB_Ignore)
  Declare   BoxedGradient_(X.i, Y.i, Width.i, Height.i)
  Declare   Circle_(X.i, Y.i, Radius.i, Color.i=#PB_Ignore) 
  Declare   ClipOutput_(X.i, Y.i, Width.i, Height.i) 
  Declare   ConicalGradient_(X.i, Y.i, Angle.f)
  Declare   DrawAlphaImage_(ImageID.i, X.i, Y.i, Alpha.i=255)
  Declare   DrawImage_(ImageID.i, X.i, Y.i, Width.i=#False, Height.i=#False) 
  Declare   DrawRotatedText_(X.i, Y.i, Text$, Angle.f, Color.i=#PB_Ignore)
  Declare   DrawText_(X.i, Y.i, Text$, FrontColor.i=#PB_Ignore, BackColor.i=#PB_Default)
  Declare   Ellipse_(X.i, Y.i, RadiusX.i, RadiusY.i, Color.i=#PB_Ignore) 
  Declare   EllipticalGradient_(X.i, Y.i, RadiusX.i, RadiusY.i) 
  Declare   FillArea_(X.i, Y.i, OutlineColor.i, FillColor.i=#PB_Ignore)
  Declare   Line_(X.i, Y.i, Width.i, Height.i, Color.i=#PB_Ignore) 
  Declare   LineXY_(X1.i, Y1.i, X2.i, Y2.i, Color.i=#PB_Ignore) 
  Declare   LinearGradient_(X1.i, Y1.i, X2.i, Y2.i)
  Declare   Plot_(X.i, Y.i, Color.i=#PB_Ignore)
  Declare.i Point_(X.i, Y.i)
  Declare   RoundBox_(X.i, Y.i, Width.i, Height.i, RoundX.i, RoundY.i, Color.i=#PB_Ignore)
  Declare.i TextWidth_(Text$)  
  Declare.i TextHeight_(Text$)
  Declare   UnclipOutput_()

  ;- ----- VectorDrawing -----
  
  Declare   Scale()
  Declare   VectorFont_(FontID.i, Size.i)
  
EndDeclareModule

Module DPI
 
  EnableExplicit
  
	;- ==========================================================================
	;- Module - Declared Procedures
	;- ==========================================================================
  
  Procedure.f X(Num.i)
	  ProcedureReturn DesktopScaledX(Num) 
	EndProcedure

	Procedure.f Y(Num.i)
	  ProcedureReturn DesktopScaledY(Num)  
	EndProcedure
	
	
	;- ----- Canvas Gadget -----
	
	Procedure.i GetCanvasMouseX(Gadget.i)
	  ProcedureReturn DesktopUnscaledX(GetGadgetAttribute(Gadget, #PB_Canvas_MouseX))
	EndProcedure
	
	Procedure.i GetCanvasMouseY(Gadget.i)
	  ProcedureReturn DesktopUnscaledY(GetGadgetAttribute(Gadget, #PB_Canvas_MouseY))
	EndProcedure
	
	
	;- ----- 2D-Drawing -----
	
	Procedure   Box_(X.i, Y.i, Width.i, Height.i, Color.i=#PB_Ignore)
    Box(X(X), Y(Y), X(Width), Y(Height), Color)
	EndProcedure
	
	Procedure   BoxedGradient_(X.i, Y.i, Width.i, Height.i)
    BoxedGradient(X(X), Y(Y), X(Width), Y(Height))
	EndProcedure
	
	Procedure   Circle_(X.i, Y.i, Radius.i, Color.i=#PB_Ignore) 
    Circle(X(X), Y(Y), X(Radius), Color)
	EndProcedure
	
	Procedure   CircularGradient_(X.i, Y.i, Radius.i)
	  CircularGradient(X(X), Y(Y), X(Radius))
	EndProcedure
	
	Procedure   ClipOutput_(X.i, Y.i, Width.i, Height.i) 
    ClipOutput(X(X), Y(Y), X(Width), Y(Height)) 
	EndProcedure
	
	Procedure   ConicalGradient_(X.i, Y.i, Angle.f)
    ConicalGradient(X(X), Y(Y), Angle)
	EndProcedure
	
	Procedure   DrawAlphaImage_(ImageID.i, X.i, Y.i, Alpha.i=255)
    DrawAlphaImage(ImageID, X(X), Y(Y), Alpha)
	EndProcedure
	
	Procedure   DrawImage_(ImageID.i, X.i, Y.i, Width.i=#False, Height.i=#False) 
	  DrawImage(ImageID, X(X), Y(Y), X(Width), Y(Height))
	EndProcedure
	
	Procedure   DrawRotatedText_(X.i, Y.i, Text$, Angle.f, Color.i=#PB_Ignore)
    DrawRotatedText(X(X), Y(Y), Text$, Angle, Color)
  EndProcedure
	
  Procedure   DrawText_(X.i, Y.i, Text$, FrontColor.i=#PB_Ignore, BackColor.i=#PB_Default)
    DrawText(X(X), Y(Y), Text$, FrontColor, BackColor)
  EndProcedure  
  
  Procedure   Ellipse_(X.i, Y.i, RadiusX.i, RadiusY.i, Color.i=#PB_Ignore) 
    Ellipse(X(X), Y(Y), X(RadiusX), Y(RadiusY), Color) 
  EndProcedure
  
  Procedure   EllipticalGradient_(X.i, Y.i, RadiusX.i, RadiusY.i) 
    EllipticalGradient(X(X), Y(Y), X(RadiusX), Y(RadiusY)) 
  EndProcedure
  
  Procedure   FillArea_(X.i, Y.i, OutlineColor.i, FillColor.i=#PB_Ignore)
    FillArea(X(X), Y(Y), OutlineColor, FillColor)
  EndProcedure
  
  Procedure   Line_(X.i, Y.i, Width.i, Height.i, Color.i=#PB_Ignore) 
    Line(X(X), Y(Y), X(Width), Y(Height), Color)    
  EndProcedure  
  
  Procedure   LineXY_(X1.i, Y1.i, X2.i, Y2.i, Color.i=#PB_Ignore) 
    LineXY(X(X1), Y(Y1), X(X2), Y(Y2), Color)    
  EndProcedure
  
  Procedure   LinearGradient_(X1.i, Y1.i, X2.i, Y2.i)
    LinearGradient(X(X1), Y(Y1), X(X2), Y(Y2))
  EndProcedure
  
  Procedure   Plot_(X.i, Y.i, Color.i=#PB_Ignore)
    Plot(X(X), Y(Y), Color)
  EndProcedure
  
  Procedure.i Point_(X.i, Y.i)
    ProcedureReturn Point(X(X), Y(Y))    
  EndProcedure
  
  Procedure   RoundBox_(X.i, Y.i, Width.i, Height.i, RoundX.i, RoundY.i, Color.i=#PB_Ignore)
    RoundBox(X(X), Y(Y), X(Width), Y(Height), X(RoundX), Y(RoundY), Color)    
  EndProcedure
  
  Procedure.i TextWidth_(Text$) 
    ProcedureReturn DesktopUnscaledX(TextWidth(Text$)) 
  EndProcedure
  
  Procedure.i TextHeight_(Text$) 
    ProcedureReturn DesktopUnscaledY(TextHeight(Text$))
  EndProcedure
  
  Procedure   UnclipOutput_()
    UnclipOutput()
  EndProcedure
  
  
  ;- ----- VectorDrawing -----
  
  Procedure   Scale()
    ScaleCoordinates(DPI::X(100) / 100, DPI::Y(100) / 100)
  EndProcedure
  
  Procedure  VectorFont_(FontID.i, Size.i)
    VectorFont(FontID, Size * 96 / 72)
  EndProcedure
 
EndModule


;- ======== Module - Example ========

CompilerIf #PB_Compiler_IsMainFile 
  
  Enumeration 
    #Window
    #Canvas
    #Font
    #Image
  EndEnumeration
  
  LoadFont(#Font, "Times New Roman", 60, #PB_Font_Bold)
  LoadImage(#Image, #PB_Compiler_Home + "examples/Sources/Data/PureBasicLogo.bmp")

  
  If OpenWindow(#Window, 0, 0, 300, 280, "Module - Example", #PB_Window_SystemMenu|#PB_Window_Tool|#PB_Window_ScreenCentered|#PB_Window_SizeGadget)

    If CanvasGadget(#Canvas, 10, 10, 280, 260)
      
      If StartDrawing(CanvasOutput(#Canvas)) 

        DrawingMode(#PB_2DDrawing_Outlined)
        
        DrawingFont(FontID(#Font))
        
        FrontColor(#Blue)
        BackColor(#Yellow)
        
        DPI::RoundBox_(60, 60, 150, 70, 5, 5)
        
        StopDrawing()
      EndIf
      
      If StartVectorDrawing(CanvasVectorOutput(#Canvas))

        DPI::Scale()
        
        DPI::VectorFont_(FontID(#Font), 60)

        AddPathBox(60, 60, 150, 70)
        VectorSourceColor(RGBA(255, 0, 0, 255))
        StrokePath(1)
        
        VectorSourceColor(RGBA(0, 0, 255, 128))
        MovePathCursor(65, 50)
        DrawVectorText("Test")    
        
        StopVectorDrawing()
      EndIf

      
    EndIf
    
    Repeat
      Event = WaitWindowEvent()
      ;Select Event
      ;EndSelect        
    Until Event = #PB_Event_CloseWindow

    CloseWindow(#Window)
  EndIf 
  
CompilerEndIf  
; IDE Options = PureBasic 6.00 LTS (Windows - x64)
; CursorPosition = 75
; FirstLine = 39
; Folding = 9BAAA+
; EnableXP
; DPIAware