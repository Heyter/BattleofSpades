Global texture_image_buffer = AllocateMemory(1024*1024*4)

Procedure loadTextureFromImage(image,free,alpha,filter,has_alpha,grayscale)
  glPushAttrib_(#GL_ALL_ATTRIB_BITS)
  Define offset = 0
  If grayscale = 1
    StartDrawing(ImageOutput(image))
    DrawingMode(#PB_2DDrawing_AlphaBlend)
    Define y = 0
    Define x = 0
    For y = ImageHeight(image)-1 To 0 Step -1
      For x = 0 To ImageWidth(image)-1
        Define color = Point(x,y)
        PokeA(texture_image_buffer+offset,Red(color))
        PokeA(texture_image_buffer+offset+1,Green(color))
        PokeA(texture_image_buffer+offset+2,Blue(color))
        If alpha = 1
          If color = 0 ;black
            PokeA(texture_image_buffer+offset+3,0)
          Else
            PokeA(texture_image_buffer+offset+3,255)
          EndIf
        Else
          If has_alpha = 1
            PokeA(texture_image_buffer+offset+3,Alpha(color))
          Else
            PokeA(texture_image_buffer+offset+3,255)
          EndIf
        EndIf
        offset + 4
      Next
    Next
    StopDrawing()
  Else
    StartDrawing(ImageOutput(image))
    Define b.l = DrawingBuffer()
    Define f.l = 1
    Define c.l = DrawingBufferPixelFormat()
    Define ogl_mode.l = #GL_RGBA
    If c & #PB_PixelFormat_24Bits_RGB
      f = 3
      ogl_mode = #GL_RGB
    EndIf
    If c & #PB_PixelFormat_24Bits_BGR
      f = 3
      ogl_mode = #GL_BGR_EXT
    EndIf
    If c & #PB_PixelFormat_32Bits_RGB
      f = 4
      ogl_mode = #GL_RGBA
    EndIf
    If c & #PB_PixelFormat_32Bits_BGR
      f = 4
      ogl_mode = #GL_BGRA_EXT
    EndIf
    If c & #PB_PixelFormat_16Bits
      f = 2
      ogl_mode = #GL_RGB16
    EndIf
    If c & #PB_PixelFormat_15Bits
      f = 2
      ogl_mode = #GL_RGB16
    EndIf
    If c & #PB_PixelFormat_8Bits
      f = 1
      ogl_mode = #GL_R3_G3_B2
    EndIf
    StopDrawing()
  EndIf
  glEnable_(#GL_TEXTURE_2D)
  Define texture = -1
  glGenTextures_(1,@texture)
  glBindTexture_(#GL_TEXTURE_2D, texture)
  glTexEnvi_(#GL_TEXTURE_ENV, #GL_TEXTURE_ENV_MODE, #GL_MODULATE)
  If filter = 0
    glTexParameteri_(#GL_TEXTURE_2D, #GL_TEXTURE_MAG_FILTER, #GL_NEAREST)
    glTexParameteri_(#GL_TEXTURE_2D, #GL_TEXTURE_MIN_FILTER, #GL_NEAREST)
  Else
    glTexParameteri_(#GL_TEXTURE_2D, #GL_TEXTURE_MAG_FILTER, #GL_LINEAR)
    glTexParameteri_(#GL_TEXTURE_2D, #GL_TEXTURE_MIN_FILTER, #GL_LINEAR)
  EndIf
  If grayscale = 1 Or ImageWidth(image) = 416
    glTexImage2D_(#GL_TEXTURE_2D, 0, #GL_RGBA, ImageWidth(image), ImageHeight(image), 0, #GL_RGBA, #GL_UNSIGNED_BYTE, texture_image_buffer)
  Else
    glTexImage2D_(#GL_TEXTURE_2D, 0, #GL_RGBA, ImageWidth(image), ImageHeight(image), 0, ogl_mode, #GL_UNSIGNED_BYTE, b)
  EndIf
  glBindTexture_(#GL_TEXTURE_2D, 0)
  glDisable_(#GL_TEXTURE_2D)
  If free = 1
    FreeImage(image)
  EndIf
  glPopAttrib_()
  ProcedureReturn texture
EndProcedure

Procedure updateTextureFromImage(texture,image)
  glPushAttrib_(#GL_ALL_ATTRIB_BITS)
  StartDrawing(ImageOutput(image))
  Define b.l = DrawingBuffer()
  Define c.l = DrawingBufferPixelFormat()
  Define ogl_mode.l = #GL_RGBA
  If c & #PB_PixelFormat_24Bits_RGB
    ogl_mode = #GL_RGB
  EndIf
  If c & #PB_PixelFormat_24Bits_BGR
    ogl_mode = #GL_BGR_EXT
  EndIf
  If c & #PB_PixelFormat_32Bits_RGB
    ogl_mode = #GL_RGBA
  EndIf
  If c & #PB_PixelFormat_32Bits_BGR
    ogl_mode = #GL_BGRA_EXT
  EndIf
  If c & #PB_PixelFormat_16Bits
    ogl_mode = #GL_RGB16
  EndIf
  If c & #PB_PixelFormat_15Bits
    ogl_mode = #GL_RGB16
  EndIf
  If c & #PB_PixelFormat_8Bits
    ogl_mode = #GL_R3_G3_B2
  EndIf
  StopDrawing()
  glEnable_(#GL_TEXTURE_2D)
  glBindTexture_(#GL_TEXTURE_2D, texture)
  glTexSubImage2D_(#GL_TEXTURE_2D, 0, 0, 0, ImageWidth(image), ImageHeight(image), ogl_mode, #GL_UNSIGNED_BYTE, b)
  glBindTexture_(#GL_TEXTURE_2D, 0)
  glDisable_(#GL_TEXTURE_2D)
  glPopAttrib_()
EndProcedure

Procedure texture_free(id.l)
  glDeleteTextures_(1,@id)
EndProcedure

Procedure loadBMPTextureFile(filename$)
  ProcedureReturn loadTextureFromImage(LoadImage(#PB_Any,filename$),1,1,0,1,1)
EndProcedure

Procedure loadPNGTextureFile(filename$)
  ProcedureReturn loadTextureFromImage(LoadImage(#PB_Any,filename$),1,0,1,1,0)
EndProcedure
; IDE Options = PureBasic 5.31 (Windows - x86)
; CursorPosition = 136
; FirstLine = 85
; Folding = -
; EnableUnicode
; EnableXP
; UseMainFile = main.pb