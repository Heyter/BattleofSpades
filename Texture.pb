Procedure loadTextureFromImage(image,free,alpha,filter,has_alpha)
  glPushAttrib_(#GL_ALL_ATTRIB_BITS)
  Define buffer = AllocateMemory(ImageWidth(image)*ImageHeight(image)*4)
  Define offset = 0
  StartDrawing(ImageOutput(image))
  DrawingMode(#PB_2DDrawing_AlphaBlend)
  Define y = 0
  Define x = 0
  For y = 0 To ImageHeight(image)-1
    For x = 0 To ImageWidth(image)-1
      Define color = Point(x,y)
      PokeA(buffer+offset,Red(color))
      PokeA(buffer+offset+1,Green(color))
      PokeA(buffer+offset+2,Blue(color))
      If alpha = 1
        If color = 0 ;black
          PokeA(buffer+offset+3,0)
        Else
          PokeA(buffer+offset+3,255)
        EndIf
      Else
        If has_alpha = 1
          PokeA(buffer+offset+3,Alpha(color))
        Else
          PokeA(buffer+offset+3,255)
        EndIf
      EndIf
      offset + 4
    Next
  Next
  StopDrawing()
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
  glTexImage2D_(#GL_TEXTURE_2D, 0, #GL_RGBA, ImageWidth(image), ImageHeight(image), 0, #GL_RGBA, #GL_UNSIGNED_BYTE, buffer)
  glBindTexture_(#GL_TEXTURE_2D, 0)
  glDisable_(#GL_TEXTURE_2D)
  If free = 1
    FreeImage(image)
  EndIf
  FreeMemory(buffer)
  glPopAttrib_()
  ProcedureReturn texture
EndProcedure

Procedure texture_free(id.l)
  glDeleteTextures_(1,@id)
EndProcedure

Procedure loadBMPTextureFile(filename$)
  ProcedureReturn loadTextureFromImage(LoadImage(#PB_Any,filename$),1,1,0,1)
EndProcedure

Procedure loadPNGTextureFile(filename$)
  ProcedureReturn loadTextureFromImage(LoadImage(#PB_Any,filename$),1,0,1,1)
EndProcedure
; IDE Options = PureBasic 5.31 (Windows - x86)
; CursorPosition = 24
; Folding = -
; EnableUnicode
; EnableXP
; UseMainFile = main.pb