﻿;/ ==========================
;/ =    PackExModule.pbi    =
;/ ==========================
;/
;/ [ PB V5.7x / 64Bit / All OS]
;/
;/ Encryption based on code of Werner Albus - www.nachtoptik.de
;/ 
;/ © 2019 Thorsten1867 (08/2019)
;/

; [ Extended Packer ]
; - Add or replace a file to an opened archive
; - Remove a file from an open archive
; - Move files back to the archive or update them when the archive is closed. [#MoveBack/#Update]
; - Add encrypted files to the archive or or decrypt files during unpacking
; - Save XML, JSON and Images directly in the archive and load them directly from the archive
; - Add sound, music or sprite files to the archiv and load them directly from the archive


; Last Update: 6.09.2019
;
; - Added: Embed archive in image (steganography)
;


;{ ===== MIT License =====
;
; Copyright (c) 2019 Thorsten Hoeppner
; Copyright (c) 2019 Werner Albus - www.nachtoptik.de
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


;{ _____ PackEx - Commands _____

; PackEx::AddFile()           - similar to AddPackFile()
; PackEx::AddImage()          - similar to SaveImage(), but for archive
; PackEx::AddJSON()           - similar to SaveJSON(), but for archive
; PackEx::AddMemory()         - similar to AddPackMemory()
; PackEx::AddText()           - adds text as file to the archiv
; PackEx::AddXML()            - similar to SaveXML(), but for archive
; PackEx::Close()             - similar to ClosePack()  [#MoveBack/#Update]
; PackEx::Create()            - similar to CreatePack()
; PackEx::DecompressFile()    - similar to UncompressPackFile()
; PackEx::DecompressImage()   - similar to LoadImage(), but for archive
; PackEx::DecompressJSON()    - similar to LoadJSON(), but for archive
; PackEx::DecompressMemory()  - similar to UncompressPackMemory()
; PackEx::DecompressMusic()   - similar to LoadMusic(), but for archive
; PackEx::DecompressSound()   - similar to LoadSound(), but for archive
; PackEx::DecompressText()    - decompress text file from archive as string
; PackEx::DecompressXML()     - similar to LoadXML(), but for archive
; PackEx::IsEncrypted()       - checks if the packed file is encrypted
; PackEx::Open()              - similar to OpenPack()
; PackEx::ProgressProcedure() - define a procedure to show progress
; PackEx::ReadContent()       - Read archive content (-> Map: PackEx::Content_Structure)
; PackEx::RemoveFile()        - remove file from archive
; PackEx::SetSalt()           - add your own salt
; PackEx::CreateSecureKey()   - use secure keys to make brute force attacks more difficult

;}


DeclareModule PackEx
  
  #Version  = 19090600
  
  #Enable_EmbeddingLSB = #True
  
  ;- ==================================
	;-   DeclareModule - Constants
	;- ==================================
  
  Enumeration 1 ; Progress\Flags
    #SecureKey
    #Compress
    #Encrypt
    #Finished
    #Rebuild
  EndEnumeration
  
  EnumerationBinary 
    #Create
    #Open
    #Add
    #Replace
    #Remove
    #Memory
    #File
    #XML
    #JSON
    #IMAGE
    #MoveBack
    #Update
  EndEnumeration
  
  Enumeration 1
    #ERROR_CANT_CREATE_COUNTER
    #ERROR_CANT_CREATE_PACK
    #ERROR_CANT_OPEN_PACK
    #ERROR_CANT_UNCOMPRESS_FILE
    #ERROR_CANT_UNCOMPRESS_PACKMEMORY
    #ERROR_FILE_NOT_EXIST
    #ERROR_CANT_OPEN_FILE
    #ERROR_ENCODING_FAILS
    #ERROR_NOT_ENCRYPTED
    #ERROR_REBUILD_FAILED
    #ERROR_INTEGRITY_CORRUPTED
  EndEnumeration
  
  ;- ==================================
	;-   DeclareModule - Structures
  ;- ==================================
  
  Structure Progress_Structure
    Gadget.i
    State.i
    Row.i
    Index.i
    Label.s
    Compress.s
    Encrypt.s
    Flags.i
  EndStructure
  Global Progress.Progress_Structure
  
  Structure Content_Structure
    FileName.s
    Size.i
    Compressed.i
    Type.i
    Encrypted.i
  EndStructure
  Global NewMap Content.Content_Structure()
  
  ;- ==================================
	;-   DeclareModule
  ;- ==================================
  
  Declare.i AddFile(Pack.i, File.s, PackedFileName.s, Key.s="", ProgressBar.i=#False)
  Declare.i AddImage(Pack.i, Image.i, PackedFileName.s, Key.s="", ProgressBar.i=#False)
  Declare.i AddJSON(Pack.i, JSON.i, PackedFileName.s, Key.s="")
  Declare.i AddMemory(Pack.i, *Buffer, Size.i, PackedFileName.s, Key.s="", ProgressBar.i=#False) 
  Declare.i AddText(ID.i, String.s, PackedFileName.s, Key.s="", ProgressBar.i=#False)
  Declare.i AddXML(Pack.i, XML.i, PackedFileName.s, Key.s="")
  Declare   Close(Pack.i, Flags.i=#False)
  Declare.i Create(Pack.i, File.s, Plugin.i=#PB_PackerPlugin_Zip, Level.i=9)
  Declare.i DecompressFile(Pack.i, File.s, PackedFileName.s, Key.s="", ProgressBar.i=#False)
  Declare.i DecompressImage(Pack.i, Image.i, PackedFileName.s, Key.s="", ProgressBar.i=#False)
  Declare.i DecompressJSON(Pack.i, JSON.i, PackedFileName.s, Key.s="", Flags.i=#False)
  Declare.i DecompressMemory(Pack.i, *Buffer, Size.i, PackedFileName.s, Key.s="", ProgressBar.i=#False)
  Declare.i DecompressMusic(Pack.i, Music.i, PackedFileName.s, Key.s="", Flags.i=#False)
  Declare.s DecompressText(Pack.i, PackedFileName.s, Key.s="", ProgressBar.i=#False)
  Declare.i DecompressSound(Pack.i, Sound.i, PackedFileName.s, Key.s="", ProgressBar.i=#False)
  Declare.i DecompressXML(Pack.i, XML.i, PackedFileName.s, Key.s="", Flags.i=#False, Encoding.i=#PB_UTF8)
  Declare.s FormatBytes(Size.q)
  Declare.i IsEncrypted(Pack.i, PackedFileName.s)
  Declare.i Open(Pack.i, File.s, Plugin.i=#PB_PackerPlugin_Zip)
  Declare   ProgressProcedure(*ProcAddress)
  Declare   ReadContent(Pack.i)
  Declare.i RemoveFile(Pack.i, PackedFileName.s, ProgressBar=#False)
  Declare   SetSalt(String.s)
  Declare.s CreateSecureKey(Key.s, Loops.i=2048, ProgressBar.i=#PB_Default)
  
  CompilerIf #Enable_EmbeddingLSB
	  
    Declare.i EmbedSize(ImageFile.s)
    Declare.i EmbedInImage(ImageFile.s, PackFile.s, ImagePlugin.i=#PB_ImagePlugin_PNG)
    Declare.i ExtractFromImage(ImageFile.s, PackName.s)

	CompilerEndIf
	 
EndDeclareModule

Module PackEx
  
  EnableExplicit
  
  UseSHA3Fingerprint()
  
  ;- ==================================
	;-   Module - Constants
	;- ==================================
  
  Enumeration
    #Binary
    #Ascii
    #Unicode
  EndEnumeration

  #qAES  = 113656983
  #Salt$ = "t8690352cj2p1ch7fgw34u&=)?=)/%&§/&)=?(otmq09745$%()=)&%"
  
  ;- ==================================
  ;-   Module - Structure
	;- ==================================
  
  Global Error.i
  
  Structure AES_Structure         ;{ qAES\...
    Salt.s
    KeyStretching.i
    Loops.i
    Hash.s
    *ProcPtr
  EndStructure ;}
  Global qAES.AES_Structure
  
  Structure PackEx_File_Structure ;{ PackEx()\Files('file')...
    ID.i
    Size.q
    Compressed.q
    Type.i
    Path.s
    Key.s
    Hash.s
    Flags.i
  EndStructure ;}
  
  Structure PackEx_Structure      ;{ PackEx('pack')\...
    ID.i
    Mode.i
    File.s
    Plugin.i
    Level.i
    ProgressBar.i
    TempDir.s
    Map Files.PackEx_File_Structure()
  EndStructure ;}
  Global NewMap PackEx.PackEx_Structure()
    
  ;- ==================================
	;-   Module - Internal Procedures
	;- ==================================
  
  CompilerIf #Enable_EmbeddingLSB
    
    Procedure.i EmbedFile(Image.i, File.s, ImageFile.s, Plugin.i=#PB_ImagePlugin_PNG)
      Define.q Size
      Define.i f, i, FileID, EmbedSize, Result
      Define.a iByte, fByte
      Define   *Image, *File, *fPointer
      
      If IsImage(Image)
        
        If StartDrawing(ImageOutput(Image))
          
          EmbedSize = ((OutputWidth() * OutputHeight() * 3) / 8)
          
          *Image = DrawingBuffer()
          If *Image
            
            FileID = ReadFile(#PB_Any, File)
            If FileID
              
              Size = Lof(FileID)
              
              If EmbedSize > Size + 8
                
                *File = AllocateMemory(Size + 8)
                If *File
                  
                  PokeQ(*File, Size)
    
                  ReadData(FileID, *File + 8, Size)
                  
                  CloseFile(FileID)
                  
                  *fPointer = *File
                  
                  For f=1 To Size + 8
                    
                    fByte = PeekA(*fPointer)
                    
                    For i=0 To 7
                      iByte = PeekA(*Image)
                      iByte & ~1
                      If Bool(fByte & (1 << i)) : iByte | 1 : EndIf
                      PokeA(*Image, iByte)
                      *Image + 1
                    Next
                    
                    *fPointer + 1
                  Next
      
                  Result = Size
                  
                  FreeMemory(*File)
                EndIf
    
              EndIf
              
            EndIf
            
          EndIf
          
          StopDrawing()
        EndIf
    
        SaveImage(Image, ImageFile, Plugin)
     
      EndIf
      
      ProcedureReturn  Result
    EndProcedure
    
    Procedure.i ExtractFile(Image.i, File.s)
      Define.q Size
      Define.i f, i, FileID, EmbedSize, Result
      Define.a iByte, fByte
      Define   *Image, *File, *fPointer
      
      If IsImage(Image)
        
        If StartDrawing(ImageOutput(Image))
          
          EmbedSize = ((OutputWidth() * OutputHeight() * 3) / 8)
          
          *Image = DrawingBuffer()
          If *Image
    
            ;{ Read Size (Quad)
            For i=0 To 63 
              iByte = PeekB(*Image)
              If iByte & 1 : Size | 1 << i : EndIf 
              *Image + 1
            Next
            ;}
            
            If Size > 0 And Size + 8 < EmbedSize
            
              *File = AllocateMemory(Size)
              If *File
                
                *fPointer = *File
                
                For f=1 To Size
                  fByte = 0
                  For i=0 To 7
                    iByte = PeekA(*Image)
                    If iByte & 1 : fByte | 1 << i : EndIf 
                    *Image + 1
                  Next
                  PokeA(*fPointer, fByte)
                  *fPointer + 1
                Next  
                
                FileID = CreateFile(#PB_Any, File)
                If FileID
                  Result = WriteData(FileID, *File, Size)
                  CloseFile(FileID)
                EndIf
                
                FreeMemory(*File)
              EndIf
              
            EndIf
            
          EndIf
          
          StopDrawing()
        EndIf
     
      EndIf
      
      ProcedureReturn Result
    EndProcedure

  CompilerEndIf
  
  
  Procedure.s StrD_(Value.d)
    If Value < 10
      ProcedureReturn RTrim(RTrim(StrD(Value, 2), "0"), ".")
    ElseIf Value < 100
      ProcedureReturn RTrim(RTrim(StrD(Value, 1), "0"), ".")
    Else
      ProcedureReturn RTrim(RTrim(StrD(Value, 0), "0"), ".")
    EndIf
  EndProcedure 
  
  
  Procedure.s EscapeStrg_(String.s)
    
    String = ReplaceString(String, "ä", "a'")
    String = ReplaceString(String, "ö", "o'")
    String = ReplaceString(String, "ü", "u'")
    String = ReplaceString(String, "Ä", "A'")
    String = ReplaceString(String, "Ö", "O'")
    String = ReplaceString(String, "Ü", "U'")
    
    ProcedureReturn ReplaceString(String, "ß", "!3")
  EndProcedure
  
  Procedure.s UnEscapeStrg_(String.s)
    
    String = ReplaceString(String, "a'", "ä")
    String = ReplaceString(String, "o'", "ö")
    String = ReplaceString(String, "u'", "ü")
    String = ReplaceString(String, "A'", "Ä")
    String = ReplaceString(String, "O'", "Ö")
    String = ReplaceString(String, "U'", "Ü")
    
    ProcedureReturn ReplaceString(String, "!3", "ß")
  EndProcedure  
  
  
	Procedure.q GetCounter_()
	  Define.q Counter
	  
	  If OpenCryptRandom()
      CryptRandomData(@Counter, 8)
    Else
      RandomData(@Counter, 8)
    EndIf
    
    ProcedureReturn Counter
	EndProcedure  
	
	Procedure.s KeyStretching_(Key.s, Loops.i, ProgressBar.i=#PB_Default)
    ; Author Werner Albus - www.nachtoptik.de
    Define.i i, Timer
    Define.s Salt$
    
    If qAES\Salt = "" 
	    Salt$ = "59#ö#3:_,.45ß$/($(/=)?=JjB$§/(&=$?=)((/&)%WE/()T&%z#'"
	  Else  
	    Salt$ = qAES\Salt + "59#ö#3:_,.45ß$/($(/=)?=JjB$§/(&=$?=)((/&)%WE/()T&%z#'"
	  EndIf
    
    If IsGadget(ProgressBar)
      Timer = ElapsedMilliseconds()
      SetGadgetState(ProgressBar, 0)
      While WindowEvent() : Wend
    EndIf
    
    For i=1 To Loops
      
      Key = ReverseString(Salt$) + Key + Salt$ + ReverseString(Key)
      Key = Fingerprint(@Key, StringByteLength(Key), #PB_Cipher_SHA3, 512)
      
      If IsGadget(ProgressBar)
        If ElapsedMilliseconds() > Timer + 100
          SetGadgetState(ProgressBar, 100 * i / Loops)
          Timer = ElapsedMilliseconds()
          While WindowEvent() : Wend
        EndIf
      EndIf
      
    Next
    
    Key = ReverseString(Key) + Salt$ + Key + ReverseString(Key)
    Key = Fingerprint(@Key, StringByteLength(Key), #PB_Cipher_SHA3, 512) ; Finalize
    
    If IsGadget(ProgressBar)
      SetGadgetState(ProgressBar, 100)
      While WindowEvent() : Wend
    EndIf
    
    ProcedureReturn Key
  EndProcedure
  
  
  Procedure   CountPackFiles_()
	  Define.i Count = 0
	  
	  If ExaminePack(PackEx()\ID)
	    While NextPackEntry(PackEx()\ID)
	      Count + 1
	    Wend  
	  EndIf
	  
	  ProcedureReturn Count
	EndProcedure
  
  Procedure   SetProgressState_(Gadget.i, State.i, Flag.i)
    
    If IsGadget(Gadget)
      
      If qAES\ProcPtr
        Progress\Gadget = Gadget
        Progress\State  = State
        Progress\Flags   = Flag
        CallFunctionFast(qAES\ProcPtr)
      Else
        SetGadgetState(Gadget, State)
      EndIf
    
      While WindowEvent() : Wend
    EndIf
    
  EndProcedure
  
  Procedure   SetProgressText_(Gadget.i, Flags.i)
    
    If IsGadget(Gadget) And (Progress\Compress Or Progress\Encrypt)
      
      If qAES\ProcPtr
        
        Progress\Gadget = Gadget
        Progress\Flags  = Flags
        CallFunctionFast(qAES\ProcPtr)
        
      Else
        
        If Flags & #Finished
          SetGadgetText(Gadget, "")
        ElseIf Flags & #Encrypt
          SetGadgetText(Gadget, Progress\Encrypt)
        Else
          SetGadgetText(Gadget, Progress\Compress)
        EndIf
        
      EndIf
      
      While WindowEvent() : Wend
    EndIf

  EndProcedure
  
  
	Procedure.i SmartCoder(Mode.i, *Input.word, *Output.word, Size.q, Key.s, CounterKey.q=0, CounterAES.q=0)
	  ; Author: Werner Albus - www.nachtoptik.de (No warranty whatsoever - Use at your own risk)
    ; CounterKey: If you cipher a file blockwise, always set the current block number with this counter (consecutive numbering).
    ; CounterAES: This counter will be automatically used by the coder, but you can change the startpoint.
	  Define.i i, ii, iii, cStep
	  Define.q Rounds, Remaining
	  Define.s Hash$, Salt$
	  Define   *aRegister.ascii, *wRegister.word, *aBufferIn.ascii, *aBufferOut.ascii, *qBufferIn.quad, *qBufferOut.quad
	  Static   FixedKey${64}
	  Static   Dim Register.q(3)
	  
	  If qAES\Salt = ""
	    Salt$ = #Salt$
	  Else
	    Salt$ = qAES\Salt + #Salt$   
	  EndIf
	  
	  Hash$     = Salt$ + Key + Str(CounterKey) + ReverseString(Salt$)
	  FixedKey$ = Fingerprint(@Hash$, StringByteLength(Hash$), #PB_Cipher_SHA3, 256)	  
	  
	  cStep     = SizeOf(character) << 1
	  Rounds    = Size >> 4
	  Remaining = Size % 16
	  
	  For ii = 0 To 31
	    PokeA(@Register(0) + ii, Val("$" + PeekS(@FixedKey$ + iii, 2)))
	    iii + cStep
	  Next
	  
	  Register(1) + CounterAES

	  Select Mode
	    Case #Binary  ;{ Binary content
	      
	      *qBufferIn  = *Input
	      *qBufferOut = *Output
	      
	      If Size < 16 ;{ Size < 16
	        
	        *aBufferOut = *qBufferOut
	        *aBufferIn  = *qBufferIn
	        *aRegister  = @register(0)
	        
	        If Not AESEncoder(@Register(0), @Register(0), 32, @Register(0), 256, 0, #PB_Cipher_ECB)
	          Error = #ERROR_ENCODING_FAILS
	          ProcedureReturn #False
	        EndIf
	        
          For ii=0 To Size - 1
            *aBufferOut\a = *aBufferIn\a ! *aRegister\a
            *aBufferIn  + 1
            *aBufferOut + 1
            *aRegister  + 1
          Next
          
          ProcedureReturn #True
          ;}
        EndIf
        
        While i < Rounds ;{ >= 16 Byte
          
          If Not AESEncoder(@register(0), @register(0), 32, @register(0), 256, 0, #PB_Cipher_ECB)
            Error = #ERROR_ENCODING_FAILS
            ProcedureReturn #False
          EndIf
          
          *qBufferOut\q=*qBufferIn\q ! register(0)
          *qBufferIn  + 8
          *qBufferOut + 8
          *qBufferOut\q = *qBufferIn\q ! register(1)
          *qBufferIn  + 8
          *qBufferOut + 8
          
          i + 1
        Wend ;}
        
        If Remaining
          
          *aBufferOut = *qBufferOut
          *aBufferIn  = *qBufferIn
          *aRegister  = @Register(0)
          
          If Not AESEncoder(@register(0), @register(0), 32, @register(0), 256, 0, #PB_Cipher_ECB)
            Error = #ERROR_ENCODING_FAILS
            ProcedureReturn #False
          EndIf
          
          For ii=0 To Remaining - 1
            *aBufferOut\a = *aBufferIn\a ! *aRegister\a
            *aBufferIn  + 1
            *aBufferOut + 1
            *aRegister  + 1
          Next
          
        EndIf
	      ;}
	    Case #Ascii   ;{ Ascii content
	      
	      *aBufferIn  = *Input
	      *aBufferOut = *Output
	      
	      Repeat
	        
	        If Not AESEncoder(@register(0), @register(0), 32, @register(0), 256, 0, #PB_Cipher_ECB)
	          Error = #ERROR_ENCODING_FAILS
	          ProcedureReturn #False
	        EndIf
	        
	        *aRegister = @Register(0)
	        
	        For ii=0 To 15
	          
            If *aBufferIn\a And *aBufferIn\a ! *aRegister\a
              *aBufferOut\a = *aBufferIn\a ! *aRegister\a
            Else
              *aBufferOut\a = *aBufferIn\a
            EndIf
            
            If i > Size - 2 : Break 2 : EndIf
            
            *aBufferIn  + 1
            *aBufferOut + 1
            *aRegister  + 1
            
            i + 1
          Next ii
          
        ForEver
  	    ;}
	    Case #Unicode ;{ Unicode content
	      
	      Repeat
	        
	        If Not AESEncoder(@Register(0), @Register(0), 32, @Register(0), 256, 0, #PB_Cipher_ECB)
	          Error = #ERROR_ENCODING_FAILS
	          ProcedureReturn #False
	        EndIf
	        
	        *wRegister = @Register(0)
          
	        For ii=0 To 15 Step 2
	          
            If *Input\w And *Input\w ! *wRegister\w
              *Output\w = *Input\w ! *wRegister\w
            Else
              *Output\w = *Input\w
            EndIf
            
            If i > Size - 3 : Break 2 : EndIf
            
            *Input + 2
            *Output + 2
            *wRegister + 2
            
            i + 2
          Next ii
          
        ForEver
	      
	      ;}
	  EndSelect
	  
	  ProcedureReturn #True
	EndProcedure
	
  Procedure   CryptBlockwise(*Input, *Output, Size.i, Key.s, Counter.q, ProgressBar.i=#False)
    Define.i BlockSize, Bytes
    
    Define.q Timer, CounterAES
    BlockSize = 4096 << 2
	  Bytes = 0
	  
    ;{ ___ ProgressBar ___
    If IsGadget(ProgressBar)
      Timer = ElapsedMilliseconds()
      SetProgressState_(ProgressBar, 0, #Encrypt)
    EndIf ;}
	  
	  Repeat
	    
	    If Bytes + BlockSize <= Size
	      SmartCoder(#Binary, *Input + Bytes, *Output + Bytes, BlockSize, Key, Counter, CounterAES)
	    Else
	      SmartCoder(#Binary, *Input + Bytes, *Output + Bytes, Size - Bytes, Key, Counter, CounterAES)
	    EndIf 
	    
	    ;{ ___ ProgressBar ___
      If IsGadget(ProgressBar)
        If ElapsedMilliseconds() > Timer + 30
          SetProgressState_(ProgressBar, 100 * Bytes / Size, #Encrypt)
          Timer = ElapsedMilliseconds()
        EndIf
      EndIf ;}
	    
	    Bytes + BlockSize
	    
	    Counter + 1
	    CounterAES + 1
	    
	  Until Bytes >= Size
	  
	  ;{ ___ ProgressBar ___
	  If IsGadget(ProgressBar)
      SetProgressState_(ProgressBar, 100, #Encrypt)
    EndIf ;}
	  
  EndProcedure	
  
  
	Procedure   EncodeHash_(Hash.s, Counter.q, *Hash)
    Define.i i
    
    Static Dim Hash.q(31)
    
    For i=0 To 31
      PokeA(@Hash(0) + i, Val("$" + PeekS(@Hash + i * SizeOf(character) << 1, 2)))
    Next
    
    SmartCoder(#Binary, @Hash(0), *Hash, 32, Str(Counter))
    
  EndProcedure

  Procedure.s DecodeHash_(Counter.q, *Hash, FreeMemory.i=#True)
    Define.i i
    Define.s Hash$
    
    Static Dim Hash.q(31)
    
    If *Hash
      
      SmartCoder(#Binary, *Hash, @Hash(0), 32, Str(Counter))
      
      For i = 0 To 31
        Hash$ + RSet(Hex(PeekA(@Hash(0) + i)), 2, "0")
      Next i
      
      If FreeMemory : FreeMemory(*Hash) : EndIf
    EndIf
    
    ProcedureReturn LCase(Hash$)
  EndProcedure
  
  
	Procedure.i DecryptMemory_(*Buffer, Size.i, Key.s, ProgressBar.i=#False)
	  Define.q Counter, qAES_ID
	  
	  Counter   = PeekQ(*Buffer + Size - 8)
    qAES_ID   = PeekQ(*Buffer + Size - 16)
    qAES\Hash = DecodeHash_(Counter, *Buffer + Size - 48, #False)
    
    SmartCoder(#Binary, @qAES_ID, @qAES_ID, 8, Str(Counter))
    
    If qAES_ID = #qAES
      
      Size - 48
      
      CryptBlockwise(*Buffer, *Buffer, Size, Key, Counter, ProgressBar)
      
      If qAES\Hash <> Fingerprint(*Buffer, Size, #PB_Cipher_SHA3)
        Error = #ERROR_INTEGRITY_CORRUPTED
        qAES\Hash  = Fingerprint(*Buffer, Size, #PB_Cipher_SHA3)
        ProcedureReturn #False
      EndIf

    Else
      Error = #ERROR_NOT_ENCRYPTED
    EndIf 
    
	  ProcedureReturn Size
	EndProcedure
	
	Procedure.i AddCryptMemory_(PackID, *Buffer, Size.i, PackedFileName.s, Key.s, ProgressBar.i=#False)
	  Define.i Size, Result
	  Define.q Counter,qAES_ID = #qAES
	  Define   *Buffer, *Hash

	  Counter = GetCounter_()
    
    qAES\Hash = Fingerprint(*Buffer, Size, #PB_Cipher_SHA3)
    *Hash = AllocateMemory(32)
    If *Hash : EncodeHash_(qAES\Hash, Counter, *Hash) : EndIf
    
    CryptBlockwise(*Buffer, *Buffer, Size, Key, Counter, ProgressBar)
    
    SmartCoder(#Binary, @qAES_ID, @qAES_ID, 8, Str(Counter))
    
    CopyMemory(*Hash, *Buffer + Size, 32)
    PokeQ(*Buffer + Size + 32, qAES_ID)
    PokeQ(*Buffer + Size + 40, Counter)

    Size + 48
    
    SetProgressText_(ProgressBar, #Compress)
    Result = AddPackMemory(PackID, *Buffer, Size, PackedFileName)
    SetProgressText_(ProgressBar, #Compress|#Finished)
    
    ProcedureReturn Result
	EndProcedure
	
	Procedure.i AddCryptFile_(PackID, File.s, PackedFileName.s, Key.s, ProgressBar.i=#False) 
	  Define.i FileID, Size, Result
    Define.q Counter, cCounter, checkID, qAES_ID = #qAES
    Define   *Buffer, *Hash
    
    Counter = GetCounter_()
    
    FileID = ReadFile(#PB_Any, File)
    If FileID
      
      Size = Lof(FileID)
      If Size > 0
        
        *Buffer  = AllocateMemory(Size + 48)
        If *Buffer

          If ReadData(FileID, *Buffer, Size)
            
            CloseFile(FileID)
          
            checkID  = PeekQ(*Buffer + Size - 16)
            cCounter = PeekQ(*Buffer + Size - 8)
            SmartCoder(#Binary, @checkID, @checkID, 8, Str(cCounter))
            
            If checkID <> #qAES
              
              qAES\Hash = Fingerprint(*Buffer, Size, #PB_Cipher_SHA3)
              *Hash = AllocateMemory(32)
              If *Hash : EncodeHash_(qAES\Hash, Counter, *Hash) : EndIf
              
              CryptBlockwise(*Buffer, *Buffer, Size, Key, Counter, ProgressBar)
              
              SmartCoder(#Binary, @qAES_ID, @qAES_ID, 8, Str(Counter))
              
              CopyMemory(*Hash, *Buffer + Size, 32)
              PokeQ(*Buffer + Size + 32, qAES_ID)
              PokeQ(*Buffer + Size + 40, Counter)
              
              Size + 48
            EndIf
            
            SetProgressText_(ProgressBar, #Compress)
            Result = AddPackMemory(PackID, *Buffer, Size, PackedFileName)
            SetProgressText_(ProgressBar, #Compress|#Finished)
            
          EndIf
          
          FreeMemory(*Buffer)
        EndIf
        
      EndIf
      
    EndIf  
    
    If Result : ProcedureReturn Size : EndIf
    
	  ProcedureReturn #False
	EndProcedure
	

	Procedure.i AddMemory2Pack_(*Buffer, Size.i, PackedFileName.s, Key.s, ProgressBar=#False) ; only OpenPack()
	  Define.i PackID, PackEntrySize, Size, pResult, Result, Files, Count
	  Define.s PackFile, PackEntryName
	  Define   *Buffer
	  
	  PackFile = PackEx()\TempDir + GetFilePart(PackEx()\File)
	  
	  PackID = CreatePack(#PB_Any, PackFile, PackEx()\Plugin, PackEx()\Level)
	  If PackID
	    
	    If IsGadget(ProgressBar) : Files = CountPackFiles_() : EndIf
	    
	    If ExaminePack(PackEx()\ID)
	      
	      Result = #True
	      
	      SetProgressState_(ProgressBar, 0, #Rebuild)
	      SetProgressText_(ProgressBar, #Rebuild)
	      
	      While NextPackEntry(PackEx()\ID)
	        
	        PackEntryName = PackEntryName(PackEx()\ID)

	        If PackEntryName = PackedFileName ;{ Ignore PackedFileName
	          Continue ;}
	        Else                              ;{ Copy other files
	          
	          PackEntrySize = PackEntrySize(PackEx()\ID)
	          
	          *Buffer = AllocateMemory(PackEntrySize)
	          If *Buffer
	            
	            If UncompressPackMemory(PackEx()\ID, *Buffer, PackEntrySize, PackEntryName) <> -1
	              pResult = AddPackMemory(PackID, *Buffer, PackEntrySize, PackEntryName)
	              If Not pResult : Result = #False : EndIf
	            Else
	              Result = #False
                Error  = #ERROR_CANT_UNCOMPRESS_PACKMEMORY
              EndIf

	            FreeMemory(*Buffer)
	          EndIf
  	        ;}
	        EndIf
	        
	        If Files
            Count + 1
            SetProgressState_(ProgressBar, 100 * Count / Files, #Rebuild)
          EndIf  
	        
	      Wend
	      
	      SetProgressText_(ProgressBar, #Rebuild|#Finished)
	      SetProgressState_(ProgressBar, 100, #Rebuild)

	      ClosePack(PackEx()\ID)
	    EndIf
	    
	    ; Add *Buffer to new pack
	    If Key
	      pResult = AddCryptMemory_(PackID, *Buffer, Size, PackedFileName, Key, ProgressBar)
	    Else
	      SetProgressText_(ProgressBar, #Compress)
	      pResult = AddPackMemory(PackID, *Buffer, Size, PackedFileName)
	      SetProgressText_(ProgressBar, #Compress|#Finished)
	    EndIf
	    
	    If Not pResult : Result = #False : EndIf
	    
	    ClosePack(PackID)
	  EndIf
	  
	  If Result : CopyFile(PackFile, PackEx()\File) : EndIf
	  
	  PackEx()\ID = OpenPack(#PB_Any, PackEx()\File, PackEx()\Plugin)
	  
	  If Result : ProcedureReturn pResult : EndIf
 
	  ProcedureReturn #False
	EndProcedure
	
	Procedure.i AddFile2Pack_(File.s, PackedFileName.s, Key.s, ProgressBar=#False)     ; only OpenPack()
	  Define.i PackID, PackEntrySize, Size, pResult, Result, Files, Count
	  Define.s PackFile, PackEntryName
	  Define   *Buffer
	  
	  PackFile = PackEx()\TempDir + GetFilePart(PackEx()\File)
	  
	  PackID = CreatePack(#PB_Any, PackFile, PackEx()\Plugin, PackEx()\Level)
	  If PackID
	    
	    If IsGadget(ProgressBar) : Files = CountPackFiles_() : EndIf
	    
	    If ExaminePack(PackEx()\ID)
	      
	      Result = #True
	      
	      SetProgressState_(ProgressBar, 0, #Rebuild)
	      SetProgressText_(ProgressBar, #Rebuild)
	      
	      While NextPackEntry(PackEx()\ID)
	        
	        PackEntryName = PackEntryName(PackEx()\ID)

	        If PackEntryName = PackedFileName ;{ Ignore PackedFileName
	          Continue ;}
	        Else                              ;{ Copy other files
	          
	          PackEntrySize = PackEntrySize(PackEx()\ID)
	          
	          *Buffer = AllocateMemory(PackEntrySize)
	          If *Buffer
	            
	            If UncompressPackMemory(PackEx()\ID, *Buffer, PackEntrySize, PackEntryName) <> -1
	              pResult = AddPackMemory(PackID, *Buffer, PackEntrySize, PackEntryName)
	              If Not pResult : Result = #False : EndIf
	            Else
	              Result = #False
                Error  = #ERROR_CANT_UNCOMPRESS_PACKMEMORY
              EndIf
              
	            FreeMemory(*Buffer)
	          EndIf
  	        ;}
	        EndIf
	        
	        If Files
            Count + 1
            SetProgressState_(ProgressBar, 100 * Count / Files, #Rebuild)
          EndIf 
	        
	      Wend
	      
	      SetProgressText_(ProgressBar, #Rebuild|#Finished)
	      SetProgressState_(ProgressBar, 100, #Rebuild)
	      
	      ClosePack(PackEx()\ID)
	    EndIf
	    
	    ; Add file to new pack
	    If Key
	      pResult = AddCryptFile_(PackID, File, PackedFileName, Key, ProgressBar)
	      Size = pResult
	    Else
	      pResult = AddPackFile(PackID, File, PackedFileName)
	      Size = FileSize(File)
	    EndIf
	    
	    If Not pResult : Result = #False : EndIf
	    
	    ClosePack(PackID)
	  EndIf
	  
	  If Result : CopyFile(PackFile, PackEx()\File) : EndIf
	  
	  PackEx()\ID = OpenPack(#PB_Any, PackEx()\File, PackEx()\Plugin)
	  
	  If Result : ProcedureReturn Size : EndIf
	  
	  ProcedureReturn #False
	EndProcedure

	Procedure.i RemoveFile_(PackedFileName.s, ProgressBar=#False)                      ; only OpenPack()
	  Define.i PackID, PackEntrySize, Size, pResult, Result, Files, Count
	  Define.s PackFile, PackEntryName
	  Define.s EscapeName = EscapeStrg_(PackedFileName)
	  Define   *Buffer
	  
	  If PackEx()\Mode = #Create : ProcedureReturn #False : EndIf 
	  
	  PackFile = PackEx()\TempDir + GetFilePart(PackEx()\File)
	  
	  PackID = CreatePack(#PB_Any, PackFile, PackEx()\Plugin, PackEx()\Level)
	  If PackID
	    
	    If IsGadget(ProgressBar) : Files = CountPackFiles_() : EndIf
	    
	    If ExaminePack(PackEx()\ID)
	      
	      Result = #True
	      
	      SetProgressState_(ProgressBar, 0, #Rebuild)
	      SetProgressText_(ProgressBar, #Rebuild)
	      
	      While NextPackEntry(PackEx()\ID)
	        
	        PackEntryName = PackEntryName(PackEx()\ID)

	        If PackEntryName = EscapeName    ;{ Ignore PackedFileName
	          Continue ;}
	        Else                              ;{ Copy other files
	          
	          PackEntrySize = PackEntrySize(PackEx()\ID)
	          
	          *Buffer = AllocateMemory(PackEntrySize)
	          If *Buffer
	            
	            If UncompressPackMemory(PackEx()\ID, *Buffer, PackEntrySize, PackEntryName) <> -1
	              pResult = AddPackMemory(PackID, *Buffer, PackEntrySize, PackEntryName)
	              If Not pResult : Result = #False : EndIf
	            Else
	              Result = #False
                Error  = #ERROR_CANT_UNCOMPRESS_PACKMEMORY
              EndIf
              
	            FreeMemory(*Buffer)
	          EndIf
  	        ;}
	        EndIf
	        
	        If Files
            Count + 1
            SetProgressState_(ProgressBar, 100 * Count / Files, #Rebuild)
          EndIf 
	        
	      Wend
	      
	      SetProgressText_(ProgressBar, #Rebuild|#Finished)
	      SetProgressState_(ProgressBar, 100, #Rebuild)
	      
	      ClosePack(PackEx()\ID)
	    EndIf
	    
	    ClosePack(PackID)
	  EndIf
	  
	  If Result : CopyFile(PackFile, PackEx()\File) : EndIf
	  
	  PackEx()\ID = OpenPack(#PB_Any, PackEx()\File, PackEx()\Plugin)
	  
	  If Result : ProcedureReturn #True : EndIf
	  
	  ProcedureReturn #False
	EndProcedure
	
	
	Procedure   ReadContent_()
	  Define.s PackedFileName
	  
	  ClearMap(PackEx()\Files())
    
    If ExaminePack(PackEx()\ID)
      While NextPackEntry(PackEx()\ID)
        PackedFileName = UnEscapeStrg_(PackEntryName(PackEx()\ID))
        If AddMapElement(PackEx()\Files(), PackedFileName)
          PackEx()\Files()\Size       = PackEntrySize(PackEx()\ID, #PB_Packer_UncompressedSize)
          PackEx()\Files()\Compressed = PackEntrySize(PackEx()\ID, #PB_Packer_CompressedSize)
          PackEx()\Files()\Type       = PackEntryType(PackEx()\ID)
        EndIf
      Wend
    EndIf
    
	EndProcedure
	
	Procedure.i TempDir_(Pack.i)
	  
	  PackEx()\TempDir = GetTemporaryDirectory() + "PackEx" + RSet(Str(Pack), 4, "0") + #PS$
    If CreateDirectory(PackEx()\TempDir)
      ProcedureReturn #True
    EndIf
	  
	EndProcedure
	
	
	Procedure.i IsEncrypted_(PackedFileName.s, Size.i)
    Define.i Result = -1
    Define.q Counter, qAES_ID
    Define.s EscapeName = EscapeStrg_(PackedFileName)
    Define   *Buffer  
    
    If Size <= 0 : ProcedureReturn #False : EndIf 
    
    *Buffer = AllocateMemory(Size)
    If *Buffer
      
      If UncompressPackMemory(PackEx()\ID, *Buffer, Size, EscapeName) <> -1
       
        qAES_ID = PeekQ(*Buffer + Size - 16)
        Counter = PeekQ(*Buffer + Size - 8)
        SmartCoder(#Binary, @qAES_ID, @qAES_ID, 8, Str(Counter))
        
        If qAES_ID = #qAES
          Result = #True
        Else
          Result = #False
        EndIf 
       
      EndIf
      
      FreeMemory(*Buffer)
    EndIf
      
    ProcedureReturn Result
  EndProcedure
	
	
  ;- ==================================
	;-   Module - Declared Procedures
	;- ==================================
  
  Procedure.s FormatBytes(Size.q)
    Define i.i, Calc.d
    Define.s Units = "KB|MB|GB"
    
    If Size < 1024
      ProcedureReturn Str(Size) + " Byte"  
    EndIf
    
    Calc = Size / 1024
    
    For i=1 To 3
      If Calc < 1024
        ProcedureReturn StrD_(Calc) + " " + StringField(Units, i, "|")
      EndIf
      Calc / 1024
    Next 
    
    ProcedureReturn StrD_(Calc) + " TB"
  EndProcedure
  
  Procedure   ProgressProcedure(*ProcAddress)
    
    qAES\ProcPtr = *ProcAddress
    
  EndProcedure
  
  
  Procedure.s CreateSecureKey(Key.s, Loops.i=2048, ProgressBar.i=#PB_Default)
    ProcedureReturn KeyStretching_(Key, Loops, ProgressBar)
  EndProcedure
  
	
	Procedure.i IsEncrypted(Pack.i, PackedFileName.s)
    Define.i Size, Result = -1
    Define.q Counter, qAES_ID
    Define   *Buffer  
   
    If FindMapElement(PackEx(), Str(Pack))
      
      If FindMapElement(PackEx()\Files(), PackedFileName)
        
        Size = PackEx()\Files()\Size
        
        If IsEncrypted_(PackedFileName, Size)
          ProcedureReturn #True
        EndIf
        
      EndIf
      
    EndIf
    
    ProcedureReturn #False
  EndProcedure
  
  Procedure   ReadContent(Pack.i)
    Define PackedFileName.s, Size.i
    
    If FindMapElement(PackEx(), Str(Pack))
    
      ClearMap(Content())
      
  	  If PackEx()\Mode = #Create : ProcedureReturn #False : EndIf
  	  
      If ExaminePack(PackEx()\ID)
        While NextPackEntry(PackEx()\ID)
          PackedFileName = PackEntryName(PackEx()\ID)
          Size = PackEntrySize(PackEx()\ID, #PB_Packer_UncompressedSize)
          If AddMapElement(Content(), UnEscapeStrg_(PackedFileName))
            Content()\FileName   = UnEscapeStrg_(PackedFileName)
            Content()\Size       = Size
            Content()\Compressed = PackEntrySize(PackEx()\ID, #PB_Packer_CompressedSize)
            Content()\Type       = PackEntryType(PackEx()\ID)
            Content()\Encrypted  = IsEncrypted_(PackedFileName, Size)
          EndIf
        Wend
      EndIf
      
    EndIf
    
	EndProcedure
  
	Procedure.i Create(Pack.i, File.s, Plugin.i=#PB_PackerPlugin_Zip, Level.i=9)
	  
	  If Pack = #PB_Any
      Pack = 1 : While FindMapElement(PackEx(), Str(Pack)) : Pack + 1 : Wend
    EndIf
	  
    If AddMapElement(PackEx(), Str(Pack))
      
      PackEx()\ID     = CreatePack(#PB_Any, File, Plugin, Level)
      PackEx()\Plugin = Plugin
      PackEx()\Level  = Level
      PackEx()\File   = File
      PackEx()\Mode   = #Create
      
      TempDir_(Pack)
      
      ProcedureReturn PackEx()\ID
    EndIf
    
  EndProcedure
	
  Procedure.i Open(Pack.i, File.s, Plugin.i=#PB_PackerPlugin_Zip)
    
    If Pack = #PB_Any
      Pack = 1 : While FindMapElement(PackEx(), Str(Pack)) : Pack + 1 : Wend
    EndIf
    
    If AddMapElement(PackEx(), Str(Pack))
      
      PackEx()\ID     = OpenPack(#PB_Any, File, Plugin)
      PackEx()\Plugin = Plugin
      PackEx()\File   = File
      PackEx()\Mode   = #Open
      
      ReadContent_()
      
      TempDir_(Pack)
      
      ProcedureReturn PackEx()\ID
    EndIf
    
  EndProcedure
  

  Procedure.i AddFile(Pack.i, File.s, PackedFileName.s, Key.s="", ProgressBar.i=#False)
    Define.i FileID, Size
    Define.s EscapeName = EscapeStrg_(PackedFileName) 
    
    If FindMapElement(PackEx(), Str(Pack))
      
      If PackEx()\Mode = #Open
        
        Size = AddFile2Pack_(File, EscapeName, Key, ProgressBar)
        
      Else    ; #Create
        
        If Key ; encrypt & pack file
          Size = AddCryptFile_(PackEx()\ID, File, EscapeName, Key, ProgressBar)
        Else   ; pack file
          SetProgressText_(ProgressBar, #Compress)
          If AddPackFile(PackEx()\ID, File, EscapeName)
            Size = FileSize(File)
          EndIf
          SetProgressText_(ProgressBar, #Compress|#Finished)
        EndIf
        
      EndIf
      
      If Size
        PackEx()\Files(PackedFileName)\Size = Size
        PackEx()\Files(PackedFileName)\Type = #PB_Packer_File
        PackEx()\Files(PackedFileName)\Flags | #File
      EndIf
    
    EndIf
    
    ProcedureReturn Size
  EndProcedure
  
  Procedure.i DecompressFile(Pack.i, File.s, PackedFileName.s, Key.s="", ProgressBar.i=#False)
    Define.i FileID, Size, Result = -1
    Define.s EscapeName = EscapeStrg_(PackedFileName)
    Define   *Buffer
    
    If FindMapElement(PackEx(), Str(Pack))
      
      If Key  ;{ decrypt & pack file

        If FindMapElement(PackEx()\Files(), PackedFileName)
          
          Size = PackEx()\Files()\Size
          
          *Buffer = AllocateMemory(Size)
          If *Buffer
            
            SetProgressText_(ProgressBar, #Compress)
            
            If UncompressPackMemory(PackEx()\ID, *Buffer, Size, EscapeName) <> -1
              
              SetProgressText_(ProgressBar, #Compress|#Finished)
              
              Size = DecryptMemory_(*Buffer, Size, Key, ProgressBar)
              
              FileID = CreateFile(#PB_Any, File)
              If FileID 
                If WriteData(FileID, *Buffer, Size)
                  Result = Size
                EndIf
                CloseFile(FileID)
              EndIf
              
              If Result : PackEx()\Files(PackedFileName)\Key = Key : EndIf
              
            Else
              Error = #ERROR_CANT_UNCOMPRESS_PACKMEMORY  
            EndIf
            
            SetProgressText_(ProgressBar, #Compress|#Finished)
            
            FreeMemory(*Buffer)
          EndIf

        EndIf
        ;}
      Else    ;{ pack file
        
        SetProgressText_(ProgressBar, #Compress)
        Result = UncompressPackFile(PackEx()\ID, File, EscapeName)
        SetProgressText_(ProgressBar, #Compress|#Finished)
        ;}
      EndIf
      
      If Result
        PackEx()\Files(PackedFileName)\Path = GetPathPart(File)
        PackEx()\Files(PackedFileName)\Flags | #Open | #File
      EndIf
      
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  
  Procedure.i AddMemory(Pack.i, *Buffer, Size.i, PackedFileName.s, Key.s="", ProgressBar.i=#False) 
    Define.i Result
    Define.q Counter
    Define.s EscapeName = EscapeStrg_(PackedFileName)
    Define   *Buffer, *Output
    
    If FindMapElement(PackEx(), Str(Pack))
      
      If Key  ;{ encrypt & pack file

        Counter = GetCounter_()
        
        If Size > 0
         
          *Output  = AllocateMemory(Size + 48)
          If *Output
            
            If PackEx()\Mode = #Open
              Result = AddMemory2Pack_(*Output, Size, EscapeName, Key, ProgressBar)
            Else
              Result = AddCryptMemory_(PackEx()\ID, *Output, Size, EscapeName, Key, ProgressBar)
            EndIf
            
            Size + 48
            
            FreeMemory(*Output)
          EndIf
          
        EndIf
        ;}
      Else    ;{ pack file
        
        If PackEx()\Mode = #Open 
          Result = AddMemory2Pack_(*Buffer, Size, EscapeName, "", ProgressBar)
        Else
          SetProgressText_(ProgressBar, #Compress)
          Result = AddPackMemory(PackEx()\ID, *Buffer, Size, EscapeName)
          SetProgressText_(ProgressBar, #Compress|#Finished)
        EndIf
        ;}
      EndIf
      
      If Result
        PackEx()\Files(PackedFileName)\Size = Size
        PackEx()\Files(PackedFileName)\Type = #PB_Packer_File
        PackEx()\Files(PackedFileName)\Flags | #Add | #Memory
      EndIf
      
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i DecompressMemory(Pack.i, *Buffer, Size.i, PackedFileName.s, Key.s="", ProgressBar.i=#False)
    Define.i MemSize, Result = -1
    Define.q Counter, qAES_ID
    Define.s EscapeName = EscapeStrg_(PackedFileName)
    Define   *Input, *Buffer
    
    If FindMapElement(PackEx(), Str(Pack))
      
      If Key  ;{ decrypt & pack file

        If FindMapElement(PackEx()\Files(), PackedFileName)
          
          MemSize = PackEx()\Files()\Size
          
          *Input = AllocateMemory(MemSize)
          If *Input
            
            SetProgressText_(ProgressBar, #Compress)
            
            If UncompressPackMemory(PackEx()\ID, *Input, MemSize, EscapeName) <> -1
              
              SetProgressText_(ProgressBar, #Compress|#Finished)
              
          	  Counter   = PeekQ(*Input + Size - 8)
              qAES_ID   = PeekQ(*Input + Size - 16)
              qAES\Hash = DecodeHash_(Counter, *Input + Size - 48, #False)
              
              SmartCoder(#Binary, @qAES_ID, @qAES_ID, 8, Str(Counter))
              
              If qAES_ID = #qAES
                
                Size - 48
                CryptBlockwise(*Input, *Buffer, Size, Key, Counter, ProgressBar)
                
                If qAES\Hash <> Fingerprint(*Buffer, Size, #PB_Cipher_SHA3)
                  Error = #ERROR_INTEGRITY_CORRUPTED
                  qAES\Hash  = Fingerprint(*Buffer, Size, #PB_Cipher_SHA3)
                  FreeMemory(*Input)
                  ProcedureReturn #False
                EndIf
                
                Result = Size
                
              Else
                Error = #ERROR_NOT_ENCRYPTED
              EndIf 

            Else
              Error = #ERROR_CANT_UNCOMPRESS_PACKMEMORY
            EndIf
            
            SetProgressText_(ProgressBar, #Compress|#Finished)
            
            FreeMemory(*Input)  
          EndIf
          
        EndIf
        ;}
      Else    ;{ pack file
        SetProgressText_(ProgressBar, #Compress)
        Result = UncompressPackMemory(PackEx()\ID, *Buffer, Size, EscapeName)
        SetProgressText_(ProgressBar, #Compress|#Finished)
        ;}
      EndIf
      
      If Result
        PackEx()\Files(PackedFileName)\Flags | #Open | #Memory
      EndIf
      
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  
  Procedure.i AddXML(Pack.i, XML.i, PackedFileName.s, Key.s="")
    Define   *Buffer
    Define.s EscapeName = EscapeStrg_(PackedFileName)
    Define.i Size, Result
   
    If FindMapElement(PackEx(), Str(Pack))
      
      If IsXML(XML)
        
        Size = ExportXMLSize(XML)
        If Size
          
          *Buffer = AllocateMemory(Size + 48)
          If *Buffer
            
            If ExportXML(XML, *Buffer, Size)
              
              If PackEx()\Mode = #Open
                Result = AddMemory2Pack_(*Buffer, Size, EscapeName, Key)
                If Result And Key : Size + 48 : EndIf
              Else
                
                If Key
                  Result = AddCryptMemory_(PackEx()\ID, *Buffer, Size, EscapeName, Key)
                  If Result : Size + 48 : EndIf
                Else
                  Result = AddPackMemory(PackEx()\ID, *Buffer, Size, EscapeName)
                EndIf
              
              EndIf
              
            EndIf
            
            FreeMemory(*Buffer)
          EndIf  

        EndIf
        
        If Result
          PackEx()\Files(PackedFileName)\Size = Size
          PackEx()\Files(PackedFileName)\Type = #PB_Packer_File
          PackEx()\Files(PackedFileName)\ID   = XML
          PackEx()\Files(PackedFileName)\Flags | #Add | #XML
        EndIf
        
      EndIf
      
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i DecompressXML(Pack.i, XML.i, PackedFileName.s, Key.s="", Flags.i=#False, Encoding.i=#PB_UTF8)  
    Define.i Size, Result 
    Define.s EscapeName = EscapeStrg_(PackedFileName)
    Define   *Buffer
 
    If FindMapElement(PackEx(), Str(Pack))
      
      If FindMapElement(PackEx()\Files(), PackedFileName)
       
        Size = PackEx()\Files()\Size
    
        *Buffer = AllocateMemory(Size)
        If *Buffer
          
          If UncompressPackMemory(PackEx()\ID, *Buffer, Size, EscapeName) <> -1
            Size = DecryptMemory_(*Buffer, Size, Key)
            Result = CatchXML(XML, *Buffer, Size, Flags, Encoding)
          Else
            Error = #ERROR_CANT_UNCOMPRESS_PACKMEMORY
          EndIf
          
          FreeMemory(*Buffer)
        EndIf
       
      EndIf
      
      If Result
        PackEx()\Files(PackedFileName)\ID = XML
        PackEx()\Files(PackedFileName)\Flags | #Open | #XML
      EndIf
      
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  
  Procedure.i AddJSON(Pack.i, JSON.i, PackedFileName.s, Key.s="")
    Define.i Size, Result
    Define.s EscapeName = EscapeStrg_(PackedFileName)
    Define   *Buffer
    
    If FindMapElement(PackEx(), Str(Pack))
      
      If IsJSON(JSON)
        
        Size = ExportJSONSize(JSON)
        If Size
          
          *Buffer = AllocateMemory(Size + 48)
          If *Buffer
            
            If ExportJSON(JSON, *Buffer, Size)
              
              If PackEx()\Mode = #Open
                Result = AddMemory2Pack_(*Buffer, Size, EscapeName, Key)
                If Result And Key : Size + 48 : EndIf
              Else
                
                If Key
                  Result = AddCryptMemory_(PackEx()\ID, *Buffer, Size, EscapeName, Key)
                  If Result : Size + 48 : EndIf
                Else
                  Result = AddPackMemory(PackEx()\ID, *Buffer, Size, EscapeName)
                EndIf
              
              EndIf
              
            EndIf
            
            FreeMemory(*Buffer)
          EndIf  

        EndIf
        
        If Result
          PackEx()\Files(PackedFileName)\Size = Size
          PackEx()\Files(PackedFileName)\Type = #PB_Packer_File
          PackEx()\Files(PackedFileName)\ID   = JSON
          PackEx()\Files(PackedFileName)\Flags | #Add | #JSON
        EndIf
        
      EndIf
      
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i DecompressJSON(Pack.i, JSON.i, PackedFileName.s, Key.s="", Flags.i=#False)
    Define.i Size, Result
    Define.s EscapeName = EscapeStrg_(PackedFileName)
    Define   *Buffer
    
    If FindMapElement(PackEx(), Str(Pack))
      
      If FindMapElement(PackEx()\Files(), PackedFileName)
       
        Size = PackEx()\Files()\Size
    
        *Buffer = AllocateMemory(Size)
        If *Buffer
          
          If UncompressPackMemory(PackEx()\ID, *Buffer, Size, EscapeName) <> -1
            Size = DecryptMemory_(*Buffer, Size, Key)
            Result = CatchJSON(JSON, *Buffer, Size, Flags)
            If JSON = #PB_Any : JSON = Result : EndIf
          Else
            Error = #ERROR_CANT_UNCOMPRESS_PACKMEMORY  
          EndIf
          
          FreeMemory(*Buffer)
        EndIf
        
      EndIf
      
      If Result
        PackEx()\Files(PackedFileName)\ID = JSON
        PackEx()\Files(PackedFileName)\Flags | #Open | #JSON
      EndIf
      
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  
  Procedure.i AddImage(Pack.i, Image.i, PackedFileName.s, Key.s="", ProgressBar.i=#False)
    Define.i Size, Result
    Define.s EscapeName = EscapeStrg_(PackedFileName)
    Define   *Buffer

    If FindMapElement(PackEx(), Str(Pack))
      
      If IsImage(Image)

        *Buffer = EncodeImage(Image)
        If *Buffer
          
          Size = MemorySize(*Buffer)

          If Key  ;{ encrypt & pack file
            
            *Buffer = ReAllocateMemory(*Buffer, Size + 48)
            If *Buffer

              If PackEx()\Mode = #Open
                Result = AddMemory2Pack_(*Buffer, Size, EscapeName, Key, ProgressBar)
              Else
                Result = AddCryptMemory_(PackEx()\ID, *Buffer, Size, EscapeName, Key, ProgressBar)
              EndIf
              
              Size + 48
              
            EndIf  
            ;}
          Else    ;{ pack file
            
            If PackEx()\Mode = #Open 
              Result = AddMemory2Pack_(*Buffer, Size, EscapeName, "", ProgressBar)
            Else
              SetProgressText_(ProgressBar, #Compress)
              Result = AddPackMemory(PackEx()\ID, *Buffer, Size, EscapeName)
              SetProgressText_(ProgressBar, #Compress|#Finished)
            EndIf
            ;}
          EndIf
          
          FreeMemory(*Buffer)
        EndIf
        
        If Result
          PackEx()\Files(PackedFileName)\Size = Size
          PackEx()\Files(PackedFileName)\Type = #PB_Packer_File
          PackEx()\Files(PackedFileName)\ID   = Image
          PackEx()\Files(PackedFileName)\Flags | #Add | #IMAGE
        EndIf
        
      EndIf
      
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i DecompressImage(Pack.i, Image.i, PackedFileName.s, Key.s="", ProgressBar.i=#False)
    Define.i Size, Result
    Define.s EscapeName = EscapeStrg_(PackedFileName)
    Define   *Buffer
    
    If FindMapElement(PackEx(), Str(Pack))
      
      If FindMapElement(PackEx()\Files(), PackedFileName)
        
        Size = PackEx()\Files()\Size
    
        *Buffer = AllocateMemory(Size)
        If *Buffer
          
          SetProgressText_(ProgressBar, #Compress)
          
          If UncompressPackMemory(PackEx()\ID, *Buffer, Size, EscapeName) <> -1
            SetProgressText_(ProgressBar, #Compress|#Finished)
            Size = DecryptMemory_(*Buffer, Size, Key, ProgressBar)
            Result = CatchImage(Image, *Buffer, Size)
            If Image = #PB_Any : Image = Result : EndIf
          Else
            Error = #ERROR_CANT_UNCOMPRESS_PACKMEMORY  
          EndIf
          
          SetProgressText_(ProgressBar, #Compress|#Finished)
          
          FreeMemory(*Buffer)
        EndIf
       
      EndIf
      
      If Result
        PackEx()\Files(PackedFileName)\ID = Image
        PackEx()\Files(PackedFileName)\Flags | #Open | #Image
      EndIf
      
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  
  Procedure.i AddText(ID.i, String.s, PackedFileName.s, Key.s="", ProgressBar.i=#False)
    Define.i Size, Result
    Define.s EscapeName = EscapeStrg_(PackedFileName)
    Define   *Buffer
    
    If FindMapElement(PackEx(), Str(ID))
      
      If String
        
        Size = StringByteLength(String)
        If Size

          *Buffer = AllocateMemory(Size)
          If *Buffer
            
            CopyMemory(@String, *Buffer, Size)
            
            If Key  ;{ encrypt & pack file

              If PackEx()\Mode = #Open
                Result = AddMemory2Pack_(*Buffer, Size, EscapeName, Key, ProgressBar)
              Else
                Result = AddCryptMemory_(PackEx()\ID, *Buffer, Size, EscapeName, Key, ProgressBar)
              EndIf
              
              Size + 48  
              ;}
            Else    ;{ pack file
              
              If PackEx()\Mode = #Open 
                Result = AddMemory2Pack_(*Buffer, Size, EscapeName, "", ProgressBar)
              Else
                SetProgressText_(PackEx()\ProgressBar, #Compress)
                Result = AddPackMemory(PackEx()\ID, *Buffer, Size, EscapeName)
                SetProgressText_(PackEx()\ProgressBar, #Compress|#Finished)
              EndIf
              ;}
            EndIf

            FreeMemory(*Buffer)
          EndIf
          
        EndIf
        
      EndIf
      
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.s DecompressText(Pack.i, PackedFileName.s, Key.s="", ProgressBar.i=#False)
    Define.i Size
    Define.s String, EscapeName = EscapeStrg_(PackedFileName)
    Define   *Buffer
    
    If FindMapElement(PackEx(), Str(Pack))
      
      If FindMapElement(PackEx()\Files(), PackedFileName)
          
          Size = PackEx()\Files()\Size
      
          *Buffer = AllocateMemory(Size)
          If *Buffer
            
            SetProgressText_(ProgressBar, #Compress|#Finished)
            
            If UncompressPackMemory(PackEx()\ID, *Buffer, Size, EscapeName) <> -1
              SetProgressText_(ProgressBar, #Compress|#Finished)
              Size = DecryptMemory_(*Buffer, Size, Key, ProgressBar)
              String = Space(Size / SizeOf(character))
              CopyMemory(*Buffer, @String, Size)
            Else
              Error = #ERROR_CANT_UNCOMPRESS_PACKMEMORY  
            EndIf
            
            SetProgressText_(ProgressBar, #Compress|#Finished)
            
            FreeMemory(*Buffer)
          EndIf
          
      EndIf
     
    EndIf
    
    ProcedureReturn String
  EndProcedure
  
  
  Procedure.i DecompressSound(Pack.i, Sound.i, PackedFileName.s, Key.s="", ProgressBar.i=#False)
    Define.i Size, Result
    Define.s EscapeName = EscapeStrg_(PackedFileName)
    Define   *Buffer
    
    If FindMapElement(PackEx(), Str(Pack))
      
      If FindMapElement(PackEx()\Files(), PackedFileName)
          
          Size = PackEx()\Files()\Size
      
          *Buffer = AllocateMemory(Size)
          If *Buffer
            
            SetProgressText_(ProgressBar, #Compress|#Finished)
            
            If UncompressPackMemory(PackEx()\ID, *Buffer, Size, EscapeName) <> -1
              SetProgressText_(ProgressBar, #Compress|#Finished)
              Size = DecryptMemory_(*Buffer, Size, Key, ProgressBar)
              Result = CatchSound(Sound, *Buffer, Size)
              If Sound = #PB_Any : Sound = Result : EndIf
            Else
              Error = #ERROR_CANT_UNCOMPRESS_PACKMEMORY  
            EndIf
            
            SetProgressText_(ProgressBar, #Compress|#Finished)
            
            FreeMemory(*Buffer)
          EndIf
          
      EndIf
     
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i DecompressSprite(Pack.i, Sprite.i, PackedFileName.s, Key.s="", Flags.i=#False)
    Define.i Size, Result
    Define.s EscapeName = EscapeStrg_(PackedFileName)
    Define   *Buffer
    
    If FindMapElement(PackEx(), Str(Pack))
      
      If FindMapElement(PackEx()\Files(), PackedFileName)
          
          Size = PackEx()\Files()\Size
      
          *Buffer = AllocateMemory(Size)
          If *Buffer
            
            If UncompressPackMemory(PackEx()\ID, *Buffer, Size, EscapeName) <> -1
              
              If DecryptMemory_(*Buffer, Size, Key)
              
                Result = CatchSprite(Sprite, *Buffer, Flags)
                If Sprite = #PB_Any : Sprite = Result : EndIf
                
              EndIf
            
            Else
              Error = #ERROR_CANT_UNCOMPRESS_PACKMEMORY  
            EndIf
            
            FreeMemory(*Buffer)
          EndIf
          
      EndIf
     
    EndIf
    
    ProcedureReturn Result
  EndProcedure

  Procedure.i DecompressMusic(Pack.i, Music.i, PackedFileName.s, Key.s="", Flags.i=#False)
    Define.i Size, Result
    Define.s EscapeName = EscapeStrg_(PackedFileName)
    Define   *Buffer
    
    If FindMapElement(PackEx(), Str(Pack))
      
      If FindMapElement(PackEx()\Files(), PackedFileName)
          
          Size = PackEx()\Files()\Size
      
          *Buffer = AllocateMemory(Size)
          If *Buffer
            
            If UncompressPackMemory(PackEx()\ID, *Buffer, Size, EscapeName) <> -1
              Size = DecryptMemory_(*Buffer, Size, Key)
              Result = CatchMusic(Music, *Buffer, Size)
              If Music = #PB_Any : Music = Result : EndIf
            Else
              Error = #ERROR_CANT_UNCOMPRESS_PACKMEMORY  
            EndIf
            
            FreeMemory(*Buffer)
          EndIf
          
      EndIf
     
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  

  Procedure.i RemoveFile(Pack.i, PackedFileName.s, ProgressBar=#False) 
    
    
    If FindMapElement(PackEx(), Str(Pack))
      RemoveFile_(PackedFileName, ProgressBar)
    EndIf
    
  EndProcedure
  
  Procedure   Close(Pack.i, Flags.i=#False)
    Define.s File
    
    If FindMapElement(PackEx(), Str(Pack))
      
      If Flags & #MoveBack Or Flags & #Update
        
        ForEach PackEx()\Files()
          
          If PackEx()\Files()\Flags & #Open
            
            If Flags & #File And PackEx()\Files()\Flags & #File ;{ MoveBack files
              
              File = PackEx()\Files()\Path + MapKey(PackEx()\Files())
              
              If FileSize(File) > 0
                
                If AddFile(Pack, File, MapKey(PackEx()\Files()), PackEx()\Files()\Key)
                  
                  If Flags & #MoveBack : DeleteFile(File) : EndIf
                  
                EndIf
                
              EndIf
              ;}
            EndIf
            
          EndIf 
          
        Next
        
      EndIf
      
      ClosePack(PackEx()\ID)
      
      DeleteMapElement(PackEx())
    EndIf
    
  EndProcedure
  
  ;- _____ Encryption _____
  
  Procedure   SetSalt(String.s)
	  qAES\Salt = String
	EndProcedure
	
	;- ___ LSB - Embedding _____
	
	CompilerIf #Enable_EmbeddingLSB
	  
	  Procedure.i EmbedSize(ImageFile.s)
	    Define.i Image, EmbedSize
	    
	    Image = LoadImage(#PB_Any, ImageFile)
  	  If Image
  	    EmbedSize = (ImageHeight(Image) * ImageWidth(Image) * 3) / 8
  	    FreeImage(Image)
  	  EndIf
  	  
  	  ProcedureReturn EmbedSize
	  EndProcedure
	  
  	Procedure.i EmbedInImage(ImageFile.s, PackFile.s, ImagePlugin.i=#PB_ImagePlugin_PNG)
  	  Define.i Image, EmbedSize, PackSize, Result, Bit
  	  Define.s ImgFile
  	  
  	  ImgFile = GetPathPart(ImageFile) + GetFilePart(ImageFile, #PB_FileSystem_NoExtension) + " [LSB]." + GetExtensionPart(ImageFile)

  	  PackSize = FileSize(PackFile)
  	  If PackSize > 0
  	    
    	  Image = LoadImage(#PB_Any, ImageFile)
    	  If Image
    	    
    	    EmbedSize = (ImageHeight(Image) * ImageWidth(Image) * 3) / 8
         
          If EmbedSize > PackSize + 8
    	      Result = EmbedFile(Image, PackFile, ImgFile, ImagePlugin)
    	    EndIf
    	    
    	    FreeImage(Image)
    	  EndIf
    	  
    	EndIf
    	
  	  ProcedureReturn Result
  	EndProcedure
  	
  	Procedure.i ExtractFromImage(ImageFile.s, PackName.s)
  	  Define.i Image, EmbedSize, PackSize, Result
  	  Define.s File

  	  Image = LoadImage(#PB_Any, ImageFile)
  	  If Image

  	    Result = ExtractFile(Image, PackName)
  	    
  	    FreeImage(Image)
  	  EndIf

  	  ProcedureReturn Result
  	EndProcedure

  CompilerEndIf
  
EndModule

;- ========  Module - Example ========

CompilerIf #PB_Compiler_IsMainFile
  
  #Example = 8
  
  ; 1: normal
  ; 2: encrypted
  ; 3: delete
  ; 4: XML
  ; 5: JSON
  ; 6: Image
  ; 7: Read Content
  ; 8: LSB - Embedding
  
  UseZipPacker()

  #Pack = 1
  
  Key$  = "18qAES07PW67"
  
  CompilerSelect #Example
    CompilerCase 1 ;{ pack normal file
      
      If PackEx::Create(#Pack, "TestPack.zip")
        PackEx::AddFile(#Pack, "Test.jpg", "Test1.jpg")
        PackEx::AddFile(#Pack, "Test.txt", "Test.txt")
        PackEx::Close(#Pack)
      EndIf
      
      If PackEx::Open(#Pack, "TestPack.zip")
        
        ;Debug PackEx::DecompressText(#Pack, "Test.txt")
        PackEx::DecompressFile(#Pack, "Test1.jpg", "Test1.jpg")
        PackEx::AddFile(#Pack, "Test.jpg", "Test2.jpg")
        
        ;MessageRequester("PackEx", "Close Pack")
        
        PackEx::Close(#Pack, PackEx::#File|PackEx::#MoveBack) ; close pack & move uncompressed files (Test1.jpg) back to pack
        ;PackEx::Close(#Pack, PackEx::#File|PackEx::#Update) ; close pack & update uncompressed files (Test1.jpg) in pack
      EndIf
      ;}
    CompilerCase 2 ;{ pack encrypted file 
      
      If PackEx::Create(#Pack, "TestCryptPack.zip")
        PackEx::AddFile(#Pack, "Test.jpg", "Test.jpg", Key$)
        PackEx::Close(#Pack)
      EndIf
      
      If PackEx::Open(#Pack, "TestCryptPack.zip")
        If PackEx::IsEncrypted(#Pack, "Test.jpg")
          Debug "Packed file is encrypted"
        Else
          Debug "Packed file is not encrypted"
        EndIf
        PackEx::DecompressFile(#Pack, "Decrypted.jpg", "Test.jpg", Key$)
        PackEx::Close(#Pack)
      EndIf 
      ;}
    CompilerCase 3 ;{ delete packed file
      
      If PackEx::Create(#Pack, "TestPack.zip")
        PackEx::AddFile(#Pack, "Test.jpg", "Test.jpg", Key$)
        PackEx::AddFile(#Pack, "Test.txt", "Test.txt")
        PackEx::Close(#Pack)
      EndIf

      MessageRequester("PackEx", "Remove 'Test.jpg'")
      
      If PackEx::Open(#Pack, "TestPack.zip")
        
        PackEx::ReadContent(#Pack)
        ForEach PackEx::Content()
          Debug ">> " + PackEx::Content()\FileName
        Next
        
        PackEx::RemoveFile(#Pack, "Test.jpg")
        
        PackEx::Close(#Pack)
      EndIf
      ;}
    CompilerCase 4 ;{ pack xml

      #XML  = 1
      
      NewList Shapes$()
      
      AddElement(Shapes$()): Shapes$() = "square"
      AddElement(Shapes$()): Shapes$() = "circle"
      AddElement(Shapes$()): Shapes$() = "triangle"
    
      If CreateXML(#XML)
        InsertXMLList(RootXMLNode(#XML), Shapes$())
        If PackEx::Create(#Pack, "TestXML.zip")
          PackEx::AddXML(#Pack, #XML, "Shapes.xml", Key$)
          PackEx::Close(#Pack)
        EndIf
        FreeXML(#XML)
      EndIf
      
      If PackEx::Open(#Pack, "TestXML.zip")
        If PackEx::DecompressXML(#Pack, #XML, "Shapes.xml", Key$)
          Debug ComposeXML(#XML)
          SaveXML(#XML, "Test.xml")
          FreeXML(#XML)
        EndIf
        PackEx::Close(#Pack) 
      EndIf
      ;}
    CompilerCase 5 ;{ pack json
     
      #JSON = 1
      
      If CreateJSON(#JSON)
        Person.i = SetJSONObject(JSONValue(#JSON))
        SetJSONString(AddJSONMember(Person, "FirstName"), "John")
        SetJSONString(AddJSONMember(Person, "LastName"), "Smith")
        SetJSONInteger(AddJSONMember(Person, "Age"), 42)
        If PackEx::Create(#Pack, "TestJSON.zip")
          PackEx::AddJSON(#Pack, #JSON, "Person.json", Key$)
          PackEx::Close(#Pack) 
        EndIf
        FreeJSON(#JSON)
      EndIf
      
      If PackEx::Open(#Pack, "TestJSON.zip")
        If PackEx::DecompressJSON(#Pack, #JSON, "Person.json", Key$)
          Debug ComposeJSON(#JSON, #PB_JSON_PrettyPrint)
          SaveJSON(#JSON, "Test.json")
          FreeJSON(#JSON)
        EndIf
        PackEx::Close(#Pack) 
      EndIf
      ;}
    CompilerCase 6 ;{ pack image
      
      UseJPEGImageDecoder()
      
      #Image = 1
      
      If LoadImage(#Image, "Test.jpg")
        If PackEx::Create(#Pack, "TestImage.zip")
          PackEx::AddImage(#Pack, #Image, "Test.jpg", Key$)
          PackEx::Close(#Pack) 
        EndIf
      EndIf
      
      If PackEx::Open(#Pack, "TestImage.zip")
        If PackEx::DecompressImage(#Pack, #Image, "Test.jpg", Key$)
          SaveImage(#Image, "DecryptedImage.jpg")
        EndIf
        PackEx::Close(#Pack) 
      EndIf
      ;}
    CompilerCase 7 ;{ ReadContent()
      
      If PackEx::Create(#Pack, "TestPack.zip")
        PackEx::AddFile(#Pack, "Test.jpg", "Test.jpg")
        PackEx::AddFile(#Pack, "Test.txt", "Test.txt", Key$)
        PackEx::Close(#Pack)
      EndIf

      If PackEx::Open(#Pack, "TestPack.zip")
        
        PackEx::ReadContent(#Pack)
        
        ForEach PackEx::Content()
          Entry$ = ">> " + PackEx::Content()\FileName + " (" +PackEx::FormatBytes(PackEx::Content()\Size) + ")"
          If PackEx::Content()\Encrypted : Entry$ + " [Encrypted]" : EndIf
          Debug Entry$
        Next

        PackEx::Close(#Pack)
      EndIf
      
      ;}
    CompilerCase 8 ;{ LSB - Embedding 
      
      UsePNGImageDecoder()
      UsePNGImageEncoder()
      
      If PackEx::Create(#Pack, "TestPack.zip")
        PackEx::AddFile(#Pack, "Test.txt", "Test.txt")
        PackEx::Close(#Pack)
      EndIf
      
      PackEx::EmbedInImage("Test.png", "TestPack.zip")
      PackEx::ExtractFromImage("Test [LSB].png", "LSBPack.zip")
      ;}
  CompilerEndSelect    
  
CompilerEndIf  
; IDE Options = PureBasic 5.71 LTS (Windows - x64)
; CursorPosition = 94
; FirstLine = 18
; Folding = 5oAAAAAGAAAAAARA+
; EnableXP
; DPIAware
; Executable = ..\..\qAES-Packer\qAES-Packer64.exe