;/ =============================
;/ =   MemoryFileModule.pbi    =
;/ =============================
;/
;/ [ PB V5.7x - V6x / 64Bit / All OS ]
;/
;/ Based on an idea by srod & Kingwolf71
;/ 
;/ © 2022  by Thorsten Hoeppner (05/2022)
;/

; Last Update: 

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
; <PureBasicCode@gmx.de> has created this code. 
; If you find the code useful and you want to use it for your programs, 
; you are welcome to support my work with a cup of tea or a pizza
; (or the amount of money for it). 
; [ https://www.paypal.me/Hoeppner1867 ]
;}


;{ _____ MemoryFileModule - Commands _____

  ; MemFile::Create()   - comparable with CreateFile()
  ; MemFile::Open()     - comparable with OpenFile()
  ; MemFile::Close()    - reallocate memory with the actual size
  ; MemFile::Delete()   - comparable with DeleteFile()
  ; MemFile::Free()     - removes the file and frees the memory 
  
  ; MemFile::Load()     - adds a file from HDD
  ; MemFile::Save()     - saves the file to HDD
  ; MemFile::Memory()   - adds a file from memory
  
  ; MemFile::Is()        - comparable with IsFile()
  ; MemFile::Size()      - comparable with FileSize()
  ; MemFile::Examine()   - comparable with ExamineDirectory()
  ; MemFile::NextEntry() - comparable with NextDirectoryEntry()
  ; MemFile::EntryID()   - returns the FileID => MemFile::Open()
  ; MemFile::EntryName() - comparable with DirectoryEntryName()
  ; MemFile::EntrySize() - comparable with DirectoryEntrySize()
  ; MemFile::Finish()    - comparable with FinishDirectory()
  
  ; MemFile::Loc()
  ; MemFile::FileSeek()
  ; MemFile::Lof()
  ; MemFile::Eof()
  
  ; MemFile::ReadStringFormat()
  ; MemFile::WriteStringFormat()
  
  ; MemFile::WriteAsciiCharacter()  
  ; MemFile::WriteByte()
  ; MemFile::WriteWord()
  ; MemFile::WriteUnicodeCharacter()
  ; MemFile::WriteLong()
  ; MemFile::WriteInteger()
  ; MemFile::WriteFloat()
  ; MemFile::WriteDouble()
  ; MemFile::WriteCharacter()
  ; MemFile::WriteString()
  ; MemFile::WriteStringN()
  
  ; MemFile::ReadAsciiCharacter()
  ; MemFile::ReadByte()
  ; MemFile::ReadUnicodeCharacter()
  ; MemFile::ReadWord()
  ; MemFile::ReadLong()
  ; MemFile::ReadInteger()
  ; MemFile::ReadFloat()
  ; MemFile::ReadDouble()
  ; MemFile::ReadCharacter()
  ; MemFile::ReadString()
    
  ; MemFile::Error()    - returns the last error
;}


DeclareModule MemFile
  
  ;- ===========================================================================
  ;-   DeclareModule - Constants
  ;- ===========================================================================
  
  Enumeration 1     ;{ Errors
    #ERROR_MemoryFile_Already_Exists
  EndEnumeration ;}
  
  ;- ===========================================================================
  ;-   DeclareModule - Procedures
  ;- ===========================================================================
  
  Declare.i Create(FileID.i, FileName.s, Flags.i=#False)
  Declare.i Open(FileID.i, Flags.i=#False)
  Declare   Close(FileID.i, Flags.i=#False)
  Declare   Delete(FileID.i, Flags.i=#False)
  Declare   Free(FileID.i, Flags.i=#False)
  
  Declare.i Load(FileID.i, File.s, Flags.i=#False)  
  Declare.i Save(FileID.i, File.s, Flags.i=#False)
  Declare.i Memory(FileID.i, *Buffer, Size.i, FileName.s="", Flags.i=#False) 
  
  Declare.i Is(FileID.i) 
  Declare.q Size(FileID.i)  
  Declare.i Examine()
  Declare.i NextEntry()
  Declare.i EntryID()
  Declare.s EntryName()
  Declare.q EntrySize() 
  Declare   Finish()

  Declare.q Loc_(FileID.i)
  Declare   FileSeek_(FileID.i, NewPosition.q, Mode.i=#PB_Absolute)
  Declare.q Lof_(FileID.i)
  Declare.i Eof_(FileID.i)
  
  Declare.i ReadStringFormat_(FileID.i)
  Declare.i WriteStringFormat_(FileID.i, Format.i)
  
  Declare.i WriteAsciiCharacter_(FileID.i, Value.a)  
  Declare.i WriteByte_(FileID.i, Value.b)
  Declare.i WriteWord_(FileID.i, Value.w)
  Declare.i WriteUnicodeCharacter_(FileID.i, Value.u)
  Declare.i WriteLong_(FileID.i, Value.l)
  Declare.i WriteInteger_(FileID.i, Value.i)
  Declare.i WriteFloat_(FileID.i, Value.f)
  Declare.i WriteDouble_(FileID.i, Value.d)
  Declare.i WriteCharacter_(FileID.i, Value.c)
  Declare.i WriteString_(FileID.i, Value.s, Format.i=#False)
  Declare.i WriteStringN_(FileID.i, Value.s, Format.i=#False)
  
  Declare.a ReadAsciiCharacter_(FileID.i)
  Declare.b ReadByte_(FileID.i)
  Declare.u ReadUnicodeCharacter_(FileID.i)
  Declare.w ReadWord_(FileID.i)
  Declare.l ReadLong_(FileID.i)
  Declare.i ReadInteger_(FileID.i)
  Declare.f ReadFloat_(FileID.i)
  Declare.d ReadDouble_(FileID.i)
  Declare.c ReadCharacter_(FileID.i)
  Declare.s ReadString_(FileID.i, Flags.i=#False, Length.i=#PB_Default)

  Declare.i Error(FileID.i)
  
  ; ----- Macros ------

  Macro FileSeek(FileID, NewPosition, Mode=#PB_Absolute) : MemFile::FileSeek_(FileID, NewPosition, Mode) : EndMacro
  Macro Loc(FileID) : MemFile::Loc_(FileID) : EndMacro
  Macro Lof(FileID) : MemFile::Lof_(FileID) : EndMacro
  Macro Eof(FileID) : MemFile::Eof_(FileID) : EndMacro
  
  Macro ReadStringFormat(FileID)             : MemFile::ReadStringFormat_(FileID)             : EndMacro
  Macro WriteStringFormat(FileID, Format)    :  MemFile::WriteStringFormat_(FileID, Format)   : EndMacro
  
  Macro WriteAsciiCharacter(FileID, Value)   : MemFile::WriteAsciiCharacter_(FileID, Value)   : EndMacro
  Macro WriteByte(FileID, Value)             : MemFile::WriteByte_(FileID, Value)             : EndMacro
  Macro WriteWord(FileID, Value)             : MemFile::WriteWord_(FileID, Value)             : EndMacro
  Macro WriteUnicodeCharacter(FileID, Value) : MemFile::WriteUnicodeCharacter_(FileID, Value) : EndMacro
  Macro WriteLong(FileID, Value)             : MemFile::WriteLong_(FileID, Value)             : EndMacro
  Macro WriteInteger(FileID, Value)          : MemFile::WriteInteger_(FileID, Value)          : EndMacro
  Macro WriteFloat(FileID, Value)            : MemFile::WriteFloat_(FileID, Value)            : EndMacro
  Macro WriteDouble(FileID, Value)           : MemFile::WriteDouble_(FileID, Value)           : EndMacro
  Macro WriteCharacter(FileID, Value)        : MemFile::WriteCharacter_(FileID, Value)        : EndMacro
  Macro WriteString(FileID, Value, Format=#False)  : MemFile::WriteString_(FileID, Value, Format)  : EndMacro
  Macro WriteStringN(FileID, Value, Format=#False) : MemFile::WriteStringN_(FileID, Value, Format) : EndMacro
  
  Macro ReadAsciiCharacter(FileID)           : MemFile::ReadAsciiCharacter_(FileID)           : EndMacro
  Macro ReadByte(FileID)                     : MemFile::ReadByte_(FileID)                     : EndMacro
  Macro ReadUnicodeCharacter(FileID)         : MemFile::ReadUnicodeCharacter_(FileID)         : EndMacro
  Macro ReadWord(FileID)                     : MemFile::ReadWord_(FileID)                     : EndMacro
  Macro ReadLong(FileID)                     : MemFile::ReadLong_(FileID)                     : EndMacro
  Macro ReadInteger(FileID)                  : MemFile::ReadInteger_(FileID)                  : EndMacro
  Macro ReadFloat(FileID)                    : MemFile::ReadFloat_(FileID)                    : EndMacro
  Macro ReadDouble(FileID)                   : MemFile::ReadDouble_(FileID)                   : EndMacro
  Macro ReadCharacter(FileID)                : MemFile::ReadCharacter_(FileID)                : EndMacro
  Macro ReadString(FileID, Flags=#False, Length=#PB_Default) : MemFile::ReadString_(FileID, Flags, Length) : EndMacro
  
EndDeclareModule

Module MemFile
  
  EnableExplicit
  
  ;- ===========================================================================
  ;-   Module - Constants / Structures
  ;- ===========================================================================  
  
  #InitSize = 8192
  #PageSize = 4096
  
  #NoClear = 1
  #DefaultStrSize = 260
  
  #Ascii   = 1
  #Byte    = 1
  #Word    = 2
  #Unicode = 2
  #Long    = 4
  #Quad    = 8
  #Float   = 4
  #Double  = 8
  
  Structure MemFile_Structure ;{ mFile()\...
    *File 
    BOM.i
    OffSet.i
    Name.s
    Size.q   
    PageSize.i
    Used.q   
    Location.q 
    Format.i
    Error.i 
    Flags.i
  EndStructure ;}
  Global NewMap mFile.MemFile_Structure()
  
  Global NewList Entry.s()
  
  ;- ===========================================================================
  ;-   Module - Internal
  ;- =========================================================================== 
  
  Procedure.i GetFormat(Flags.i)
    
    If Flags & #PB_Ascii
      ProcedureReturn #PB_Ascii
    ElseIf Flags & #PB_Unicode
      ProcedureReturn #PB_Unicode
    Else
      ProcedureReturn #PB_UTF8
    EndIf  
    
  EndProcedure
  
  Procedure.i CalcMemory(Bytes.i)  
    Define.i MemSize, Pages 
    
    If mFile()\Location + Bytes > mFile()\Size
      
      MemSize = mFile()\Location + Bytes - mFile()\Size
      MemSize + mFile()\PageSize - 1
      
      Pages = MemSize / mFile()\PageSize
      
      mFile()\Size + (mFile()\PageSize * Pages)
      
      mFile()\File = ReAllocateMemory(mFile()\File, mFile()\Size)
      
    EndIf
    
  EndProcedure
  
  ;- ==========================================================================
  ;-   Module - Declared Procedures
  ;- ========================================================================== 
  
  Procedure.i Create(FileID.i, FileName.s, Flags.i=#False)
    
    If FindMapElement(mFile(), Str(FileID)) ;{ ERROR: mFile exists
      mFile()\Error = #ERROR_MemoryFile_Already_Exists
      ProcedureReturn #False
    EndIf ;}
    
    If FileID = #PB_Any
      FileID = 1 : While FindMapElement(mFile(), Str(FileID)) : FileID + 1 : Wend
    EndIf

    If AddMapElement(mFile(), Str(FileID))
      
      mFile()\File = AllocateMemory(#InitSize, #PB_Memory_NoClear)
      If mFile()\File
        
        mFile()\Name         = FileName
        mFile()\Size         = #InitSize
        mFile()\PageSize     = #PageSize
        mFile()\Used         = 0
        mFile()\Location     = 0
        mFile()\Format       = GetFormat(Flags)

      EndIf  
      
      ProcedureReturn FileID
    EndIf  
    
  EndProcedure
 
  Procedure.i Open(FileID.i, Flags.i=#False)
    
    
    If FindMapElement(mFile(), Str(FileID))
      
      mFile()\Location = 0 + mFile()\OffSet
      mFile()\Format   = GetFormat(Flags)
      
      ProcedureReturn #True
    EndIf
    
    ProcedureReturn #False
  EndProcedure
  
  Procedure   Close(FileID.i, Flags.i=#False)
    
    If FindMapElement(mFile(), Str(FileID))
      
      mFile()\File = ReAllocateMemory(mFile()\File, mFile()\Used)
      
    EndIf
    
  EndProcedure

  Procedure   Delete(FileID.i, Flags.i=#False)  
    
    If FindMapElement(mFile(), Str(FileID))
      
      If mFile()\File And Flags & #NoClear = #False
        FreeMemory(mFile()\File)
      EndIf
      
      DeleteMapElement(mFile())
      
    EndIf
    
  EndProcedure
  
  Procedure   Free(FileID.i, Flags.i=#False)
    
    If FindMapElement(mFile(), Str(FileID))
      
      If mFile()\File And Flags & #NoClear = #False
        FreeMemory(mFile()\File)
      EndIf
      
      DeleteMapElement(mFile())
      
    EndIf
    
  EndProcedure
  
  
  Procedure.i Load(FileID.i, File.s, Flags.i=#False)  
    Define.i fID

    If FindMapElement(mFile(), Str(FileID)) ;{ ERROR: mFile exists
      mFile()\Error = #ERROR_MemoryFile_Already_Exists
      ProcedureReturn #False
    EndIf ;}
    
    If FileID = #PB_Any
      FileID = 1 : While FindMapElement(mFile(), Str(FileID)) : FileID + 1 : Wend
    EndIf
    
    If AddMapElement(mFile(), Str(FileID))
      
      fID = ReadFile(#PB_Any, File, Flags)
      If fID
        
        mFile()\Name     = GetFilePart(File)
        mFile()\PageSize = #PageSize
        mFile()\Size     = Lof(fID)
        mFile()\Location = 0
        mFile()\Format   = GetFormat(Flags)
        
        mFile()\File = AllocateMemory(mFile()\Size)
        If mFile()\File
          mFile()\Used = ReadData(fID, mFile()\File, mFile()\Size)
        EndIf
        
        CloseFile(fID)
      EndIf   
      
      ProcedureReturn mFile()\Used
    EndIf
    
  EndProcedure
  
  Procedure.i Save(FileID.i, File.s, Flags.i=#False)
    Define.i fID, Bytes
    
    If FindMapElement(mFile(), Str(FileID))
      
      fID = CreateFile(#PB_Any, File, Flags)
      If fID
        WriteData(fID, mFile()\File, mFile()\Used)
        CloseFile(fID)
      EndIf  
      
      ProcedureReturn Bytes
    EndIf
    
  EndProcedure
  
  Procedure.i Memory(FileID.i, *Buffer, Size.i, FileName.s="", Flags.i=#False) 
    
    If FindMapElement(mFile(), Str(FileID)) ;{ ERROR: mFile exists
      mFile()\Error = #ERROR_MemoryFile_Already_Exists
      ProcedureReturn #False
    EndIf ;}
    
    If FileID = #PB_Any
      FileID = 1 : While FindMapElement(mFile(), Str(FileID)) : FileID + 1 : Wend
    EndIf
    
    If AddMapElement(mFile(), Str(FileID))
      
      mFile()\File         = ReAllocateMemory(*Buffer, Size)
      mFile()\Name         = FileName
      mFile()\Size         = Size
      mFile()\PageSize     = #PageSize
      mFile()\Used         = MemorySize(mFile()\File)
      mFile()\Location     = 0
      mFile()\Format       = GetFormat(Flags)
      
      ProcedureReturn mFile()\Used
    EndIf
    
  EndProcedure
  

  Procedure.q Loc_(FileID.i)

    If FindMapElement(mFile(), Str(FileID))
      ProcedureReturn mFile()\Location
    EndIf  

  EndProcedure
  
  Procedure   FileSeek_(FileID.i, NewPosition.q, Mode.i=#PB_Absolute)
    
    If FindMapElement(mFile(), Str(FileID))
      
      Select Mode
        Case #PB_Relative
          mFile()\Location + NewPosition
        Default   
          mFile()\Location = NewPosition + mFile()\OffSet
      EndSelect  
      
    EndIf
    
  EndProcedure
  
  Procedure.q Lof_(FileID.i)
    
    If FindMapElement(mFile(), Str(FileID))
      ProcedureReturn mFile()\Used
    EndIf
    
  EndProcedure
  
  Procedure.i Eof_(FileID.i)
    
    If FindMapElement(mFile(), Str(FileID))
      
      If mFile()\Location >= mFile()\Used
        ProcedureReturn #True
      EndIf
      
      ProcedureReturn #False
    EndIf
    
  EndProcedure 
  
  
  Procedure.i WriteAsciiCharacter_(FileID.i, Value.a)  

    If FindMapElement(mFile(), Str(FileID))
      
      If mFile()\Location <= mFile()\Used
        
        CalcMemory(#Ascii)  
        
        PokeA(mFile()\File + mFile()\Location, Value)
        
        mFile()\Location + #Ascii
        
        If mFile()\Location = mFile()\Used + #Ascii
          mFile()\Used + #Ascii
        EndIf  

        ProcedureReturn mFile()\Location
      EndIf  
      
    EndIf  
    
  EndProcedure 
  
  Procedure.i WriteByte_(FileID.i, Value.b)  

    If FindMapElement(mFile(), Str(FileID))
      
      If mFile()\Location <= mFile()\Used
        
        CalcMemory(#Byte)  
        
        PokeB(mFile()\File + mFile()\Location, Value)
        
        mFile()\Location + #Byte
        
        If mFile()\Location = mFile()\Used + #Byte
          mFile()\Used + #Byte
        EndIf  

        ProcedureReturn mFile()\Location
      EndIf  
      
    EndIf  
    
  EndProcedure
  
  Procedure.i WriteUnicodeCharacter_(FileID.i, Value.u)
    
    If FindMapElement(mFile(), Str(FileID))
      
      If mFile()\Location <= mFile()\Used
        
        CalcMemory(#Unicode)  
        
        PokeU(mFile()\File + mFile()\Location, Value)
        
        mFile()\Location + #Unicode
        
        If mFile()\Location = mFile()\Used + #Unicode
          mFile()\Used + #Unicode
        EndIf  

        ProcedureReturn mFile()\Location
      EndIf  
      
    EndIf  
    
  EndProcedure  
  
  Procedure.i WriteWord_(FileID.i, Value.w)
    
    If FindMapElement(mFile(), Str(FileID))
      
      If mFile()\Location <= mFile()\Used
        
        CalcMemory(#Word)  
        
        PokeW(mFile()\File + mFile()\Location, Value)
        
        mFile()\Location + #Word
        
        If mFile()\Location = mFile()\Used + #Word
          mFile()\Used + #Word
        EndIf  

        ProcedureReturn mFile()\Location
      EndIf  
      
    EndIf  
    
  EndProcedure
  
  Procedure.i WriteLong_(FileID.i, Value.l)
    
    If FindMapElement(mFile(), Str(FileID))
      
      If mFile()\Location <= mFile()\Used
        
        CalcMemory(#Long)  
        
        PokeL(mFile()\File + mFile()\Location, Value)
        
        mFile()\Location + #Long
        
        If mFile()\Location = mFile()\Used + #Long
          mFile()\Used + #Long
        EndIf  

        ProcedureReturn mFile()\Location
      EndIf  
      
    EndIf  
  
  EndProcedure

  Procedure.i WriteInteger_(FileID.i, Value.i)  
    Define.i Integer = SizeOf(Value)
    
    If FindMapElement(mFile(), Str(FileID))
      
      If mFile()\Location <= mFile()\Used
        
        CalcMemory(Integer)  
        
        PokeI(mFile()\File + mFile()\Location, Value)
        
        mFile()\Location + Integer
        
        If mFile()\Location = mFile()\Used + Integer
          mFile()\Used + Integer
        EndIf  

        ProcedureReturn mFile()\Location
      EndIf  
      
    EndIf  
    
  EndProcedure
  
  Procedure.i WriteFloat_(FileID.i, Value.f)
    
    If FindMapElement(mFile(), Str(FileID))
      
      If mFile()\Location <= mFile()\Used
        
        CalcMemory(#Float)  
        
        PokeF(mFile()\File + mFile()\Location, Value)
        
        mFile()\Location + #Float
        
        If mFile()\Location = mFile()\Used + #Float
          mFile()\Used + #Float
        EndIf  

        ProcedureReturn mFile()\Location
      EndIf  
      
    EndIf  
  
  EndProcedure
  
  Procedure.i WriteDouble_(FileID.i, Value.d)
    
    If FindMapElement(mFile(), Str(FileID))
      
      If mFile()\Location <= mFile()\Used
        
        CalcMemory(#Double)  
        
        PokeD(mFile()\File + mFile()\Location, Value)
        
        mFile()\Location + #Double
        
        If mFile()\Location = mFile()\Used + #Double
          mFile()\Used + #Double
        EndIf  

        ProcedureReturn mFile()\Location
      EndIf  
      
    EndIf  
  
  EndProcedure
  
  Procedure.i WriteCharacter_(FileID.i, Value.c)
    Define.i Character = SizeOf(Value)
    
    If FindMapElement(mFile(), Str(FileID))
      
      If mFile()\Location <= mFile()\Used
        
        CalcMemory(Character)  
        
        PokeC(mFile()\File + mFile()\Location, Value)
        
        mFile()\Location + Character
        
        If mFile()\Location = mFile()\Used + Character
          mFile()\Used + Character
        EndIf  

        ProcedureReturn mFile()\Location
      EndIf  
      
    EndIf  
  
  EndProcedure
  
  Procedure.i WriteString_(FileID.i, Value.s, Format.i=#False)
    Define.i Strg
    
    If FindMapElement(mFile(), Str(FileID))
      
      If mFile()\Location <= mFile()\Used
        
        If Format & #PB_Ascii = #False And Format & #PB_UTF8 = #False And Format & #PB_Unicode = #False
          Format = mFile()\Format
        EndIf
        
        Strg = StringByteLength(Value, Format); ohne Null

        CalcMemory(Strg)
        
        PokeS(mFile()\File + mFile()\Location, Value, Strg, Format|#PB_String_NoZero)
        
        mFile()\Location + Strg
        
        If mFile()\Location = mFile()\Used + Strg
          mFile()\Used + Strg
        EndIf  
        
        ProcedureReturn mFile()\Location
      EndIf
      
    EndIf  
    
  EndProcedure
  
  Procedure.i WriteStringN_(FileID.i, Value.s, Format.i=#False)
    Define.i Strg
    
    If FindMapElement(mFile(), Str(FileID))
      
      If mFile()\Location <= mFile()\Used
        
        If Format & #PB_Ascii = #False And Format & #PB_UTF8 = #False And Format & #PB_Unicode = #False
          Format = mFile()\Format
        EndIf
        
        Strg = StringByteLength(Value, Format) + 1

        CalcMemory(Strg)
        
        PokeS(mFile()\File + mFile()\Location, Value, Strg, Format)
        
        mFile()\Location + Strg
        
        If mFile()\Location >= mFile()\Used + Strg
          mFile()\Used + Strg
        EndIf  
        
        ProcedureReturn mFile()\Location
      EndIf
      
    EndIf  
    
  EndProcedure
  
  
  Procedure.a ReadAsciiCharacter_(FileID.i)
    Define.a Value
    
    If FindMapElement(mFile(), Str(FileID))
      
      If mFile()\Location <= mFile()\Used - #Ascii

        Value = PeekA(mFile()\File + mFile()\Location)
        
        mFile()\Location + #Ascii
        
        ProcedureReturn Value
      EndIf  
      
    EndIf  
    
  EndProcedure  
  
  Procedure.b ReadByte_(FileID.i)
    Define.b Value
    
    If FindMapElement(mFile(), Str(FileID))
      
      If mFile()\Location <= mFile()\Used - #Byte

        Value = PeekB(mFile()\File + mFile()\Location)
        
        mFile()\Location + #Byte

        ProcedureReturn Value
      EndIf  
      
    EndIf  
    
  EndProcedure
  
  Procedure.u ReadUnicodeCharacter_(FileID.i)
    Define.u Value
    
    If FindMapElement(mFile(), Str(FileID))
      
      If mFile()\Location <= mFile()\Used - #Unicode

        Value = PeekU(mFile()\File + mFile()\Location)
        
        mFile()\Location + #Unicode
        
        ProcedureReturn Value
      EndIf  
      
    EndIf  
    
  EndProcedure  
  
  Procedure.w ReadWord_(FileID.i)
    Define.w Value
    
    If FindMapElement(mFile(), Str(FileID))
      
      If mFile()\Location <= mFile()\Used - #Word

        Value = PeekW(mFile()\File + mFile()\Location)
        
        mFile()\Location + #Word
        
        ProcedureReturn Value
      EndIf  
      
    EndIf  
    
  EndProcedure
  
  Procedure.l ReadLong_(FileID.i)
    Define.l Value
    
    If FindMapElement(mFile(), Str(FileID))
      
      If mFile()\Location <= mFile()\Used - #Long

        Value = PeekL(mFile()\File + mFile()\Location)
        
        mFile()\Location + #Long

        ProcedureReturn Value
      EndIf  
      
    EndIf  
    
  EndProcedure  

  Procedure.i ReadInteger_(FileID.i)
    Define.i Value, Integer = SizeOf(Value)
    
    If FindMapElement(mFile(), Str(FileID))
      
      If mFile()\Location <= mFile()\Used - Integer

        Value = PeekI(mFile()\File + mFile()\Location)
        
        mFile()\Location + Integer
        
        ProcedureReturn Value
      EndIf  
      
    EndIf  
    
  EndProcedure
  
  Procedure.f ReadFloat_(FileID.i)
    Define.f Value
    
    If FindMapElement(mFile(), Str(FileID))
      
      If mFile()\Location <= mFile()\Used - #Float

        Value = PeekF(mFile()\File + mFile()\Location)
        
        mFile()\Location + #Float
        
        ProcedureReturn Value
      EndIf  
      
    EndIf  
    
  EndProcedure    
  
  Procedure.d ReadDouble_(FileID.i)
    Define.d Value
    
    If FindMapElement(mFile(), Str(FileID))
      
      If mFile()\Location <= mFile()\Used - #Double

        Value = PeekD(mFile()\File + mFile()\Location)
        
        mFile()\Location + #Double

        ProcedureReturn Value
      EndIf  
      
    EndIf  
    
  EndProcedure  
  
  Procedure.c ReadCharacter_(FileID.i)
    Define.c Value
    Define.i Character = SizeOf(Value)
    
    If FindMapElement(mFile(), Str(FileID))
      
      If mFile()\Location <= mFile()\Used - Character

        Value = PeekD(mFile()\File + mFile()\Location)
        
        mFile()\Location + Character

        ProcedureReturn Value
      EndIf  
      
    EndIf  
    
  EndProcedure
  
  Procedure.s ReadString_(FileID.i, Flags.i=#False, Length.i=#PB_Default)
    Define.s Value
    Define.i Format, Strg
    
    If FindMapElement(mFile(), Str(FileID))
      
      If Flags & #PB_Ascii
        Format = #PB_Ascii
      ElseIf Flags & #PB_UTF8
        Format = #PB_UTF8|#PB_ByteLength
      ElseIf Flags & #PB_Unicode
        Format = #PB_Unicode
      Else  
        Format = mFile()\Format
      EndIf
      
      If mFile()\Location <= mFile()\Used
        
        Value = PeekS(mFile()\File + mFile()\Location, Length, Format)
        
        Strg = StringByteLength(Value, Format) + 1
        
        mFile()\Location + Strg

        ProcedureReturn Value
      EndIf  
      
    EndIf  
    
  EndProcedure
  
  
  Procedure.i ReadStringFormat_(FileID.i)
    Define.a Byte1, Byte2, Byte3, Byte4
    
    If FindMapElement(mFile(), Str(FileID))
      
      Byte1 = PeekA(mFile()\File)
      Byte2 = PeekA(mFile()\File + 1)
      Byte3 = PeekA(mFile()\File + 2)
      Byte4 = PeekA(mFile()\File + 3)
      
      If Byte1 = 255 And Byte2 = 254 And Byte3 = 0 And Byte4 = 0
        ; UTF-32 (LE): 255 254 0 0
        mFile()\OffSet = 4
        ProcedureReturn #PB_UTF32
      ElseIf Byte1 = 0 And Byte2 = 0 And Byte3 = 254 And Byte4 = 255
        ; UTF-32 (BE): 0 0 254 255
        mFile()\OffSet = 4
        ProcedureReturn #PB_UTF32BE
      ElseIf Byte1 = 255 And Byte2 = 254 
        ; UTF-16 (LE): 255 254
        mFile()\OffSet = 2
        ProcedureReturn #PB_Unicode
       ElseIf Byte1 = 254 And Byte2 = 255 
        ; UTF-16 (BE): 254 255
        mFile()\OffSet = 2
        ProcedureReturn #PB_UTF16BE
      ElseIf Byte1 = 239 And Byte2 = 187 And Byte3 = 191
        ; UTF-8: 239 187 191
        mFile()\OffSet = 3
        ProcedureReturn #PB_UTF8
      Else
        mFile()\OffSet = 0
        ProcedureReturn #PB_Ascii
      EndIf
      
    EndIf  
   
  EndProcedure
  
  Procedure.i WriteStringFormat_(FileID.i, Format.i)
    
    If FindMapElement(mFile(), Str(FileID))
    
      Select Format
        Case #PB_UTF32
          ; UTF-32 (LE): 255 254 0 0
          PokeA(mFile()\File, 255)
          PokeA(mFile()\File, 254)
          PokeA(mFile()\File, 0)
          PokeA(mFile()\File, 0)
          mFile()\OffSet = 4
          mFile()\Used   + 4
        Case #PB_UTF32BE
          ; UTF-32 (BE): 0 0 254 255
          PokeA(mFile()\File, 0)
          PokeA(mFile()\File, 0)
          PokeA(mFile()\File, 254)
          PokeA(mFile()\File, 255)
          mFile()\OffSet = 4
          mFile()\Used   + 4
        Case #PB_Unicode
          ; UTF-16 (LE): 255 254
          PokeA(mFile()\File, 255)
          PokeA(mFile()\File, 254)
          mFile()\OffSet = 2
          mFile()\Used   + 2
        Case #PB_UTF16BE
          ; UTF-16 (BE): 254 255
          PokeA(mFile()\File, 254)
          PokeA(mFile()\File, 255)
          mFile()\OffSet = 2  
          mFile()\Used   + 2
        Case #PB_UTF8
          ; UTF-8: 239 187 191
          PokeA(mFile()\File, 239)
          PokeA(mFile()\File, 187)
          PokeA(mFile()\File, 191)
          mFile()\OffSet = 3
          mFile()\Used   + 3
        Default
          mFile()\OffSet = 0
      EndSelect

    EndIf
    
  EndProcedure
  

  Procedure.i Is(FileID.i) 
    
    If FindMapElement(mFile(), Str(FileID))
      ProcedureReturn #True
    EndIf
    
    ProcedureReturn #False
  EndProcedure  
 
  Procedure.q Size(FileID.i)  
    
    If FindMapElement(mFile(), Str(FileID))
      
      ProcedureReturn mFile()\Used
      
    EndIf
    
    ProcedureReturn #PB_Default
  EndProcedure
  
  
  Procedure.i Examine()
    
    ClearList(Entry())
    
    ForEach mFile()
      If AddElement(Entry()) : Entry() = MapKey(mFile()) : EndIf
    Next
    
    ResetList(Entry())
    
  EndProcedure
  
  Procedure.i NextEntry()

    ProcedureReturn NextElement(Entry())

  EndProcedure
  
  Procedure.i EntryID()
    
    If FindMapElement(mFile(), Entry())
      ProcedureReturn Val(MapKey(mFile()))
    EndIf   
    
  EndProcedure  
  
  Procedure.s EntryName()
    
    If FindMapElement(mFile(), Entry())
      ProcedureReturn mFile()\Name
    EndIf   
    
  EndProcedure
  
  Procedure.q EntrySize() 
    
    If FindMapElement(mFile(), Entry())
      ProcedureReturn mFile()\Used
    EndIf  
    
  EndProcedure
  
  Procedure   Finish()
    
    ClearList(Entry())
    
  EndProcedure
  
  
  Procedure.i Error(FileID.i)
    
    If FindMapElement(mFile(), Str(FileID))
      ProcedureReturn mFile()\Error
    EndIf
    
  EndProcedure
  
  
EndModule


;- ========  Module - Example ========

CompilerIf #PB_Compiler_IsMainFile
  
  #Example = 0
  
  ; 0: Test different types
  ; 1: MemFile::WriteStringN()
  
  
  #File = 1
 
  Select #Example
    Case 0  
      
      If MemFile::Create(#File, "Test.mem")
        MemFile::WriteAsciiCharacter(#File, 254)
        MemFile::WriteByte(#File, 67)
        MemFile::WriteLong(#File, 1867)
        MemFile::WriteInteger(#File, 180767)
        MemFile::WriteStringN(#File, "Test")
        MemFile::Close(#File)
      EndIf  
      
      If MemFile::Open(#File)
        Debug "Ascii:   " + Str(MemFile::ReadAsciiCharacter(#File))
        Debug "Byte:    " + Str(MemFile::ReadByte(#File))
        Debug "Long:    " + Str(MemFile::ReadLong(#File))
        Debug "Integer: " + Str(MemFile::ReadInteger(#File))
        Debug "String:  " + MemFile::ReadString(#File)
        MemFile::Free(#File)
      EndIf
      
    Case 1
      
      Text1$ = "That is the first line of text."
      Text2$ = "That is the second line of text."
      
      If MemFile::Create(#File, "String.mem")
        MemFile::WriteStringN(#File, Text1$)
        MemFile::WriteStringN(#File, Text2$)
        MemFile::Close(#File)
      EndIf
      
      If MemFile::Open(#File)
        
        While MemFile::Eof(#File) = #False
          Debug "> " + MemFile::ReadString(#File)
        Wend

        MemFile::Free(#File)
      EndIf  

  EndSelect    
  
CompilerEndIf

; IDE Options = PureBasic 6.00 Beta 10 (Windows - x64)
; CursorPosition = 1126
; FirstLine = 156
; Folding = g----HAAAAAAgg-
; EnableXP
; DPIAware