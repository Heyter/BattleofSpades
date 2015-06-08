#ZLIB_VERSION = "1.2.8"
#WANT_GZIP = 32

#Z_ERRNO         = -1
#Z_STREAM_ERROR  = -2
#Z_DATA_ERROR    = -3
#Z_MEM_ERROR     = -4
#Z_BUF_ERROR     = -5
#Z_VERSION_ERROR = -6
#Z_FINISH        =  4

Structure Z_STREAM Align #PB_Structure_AlignC
  *next_in.Byte
  avail_in.l
  total_in.l
  *next_out.Byte
  avail_out.l
  total_out.l
  *msg.Byte
  *state
  zalloc.l
  zfree.l
  opaque.l
  data_type.i
  adler.l
  reserved.l
  CompilerIf #PB_Compiler_Processor = #PB_Processor_x64
    alignment.l
  CompilerEndIf
EndStructure

ImportC "zlib.lib"
  inflateInit2_(*strm, windowBits.i, version.s, strm_size)
  inflate(*strm, flush.i)
  inflateEnd(*strm)
EndImport

Procedure.l zlib_inflateInit2(*dest, *destLen, *source, sourceLen.l)
  Static strm.Z_STREAM
  With strm
    \zalloc = #Null
    \zfree  = #Null
    \opaque = #Null
   
    \next_in  = *source
    \avail_in = sourceLen
    \total_in = #Null
   
    \next_out   = *dest
    \avail_out  = *destLen
    \total_out  = #Null   
  EndWith
 
  Static err.l
 
  err.l = inflateInit2_(@strm, #WANT_GZIP, #ZLIB_VERSION, SizeOf(Z_STREAM))
  If err <> 0 : ProcedureReturn err : EndIf
 
  err = inflate(@strm,#Z_FINISH)
 
  If err <> 1
    inflateEnd(@strm)
    If err = 0
      ProcedureReturn #Z_BUF_ERROR
    Else
      ProcedureReturn err
    EndIf
  EndIf
  PokeL(*destLen,strm\total_out)
  ProcedureReturn inflateEnd(@strm) 
EndProcedure
; IDE Options = PureBasic 5.31 (Windows - x86)
; CursorPosition = 1
; Folding = -
; EnableUnicode
; EnableXP
; UseMainFile = main.pb