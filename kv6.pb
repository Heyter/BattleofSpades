Procedure.l loadKV6(filename$,custom_color.l)
  ReadFile(256,filename$)
  If Not ReadString(256,#PB_UTF8,4) = "Kvxl"
    ProcedureReturn -1
  EndIf
  xsiz.l = ReadLong(256)
  ysiz.l = ReadLong(256)
  zsiz.l = ReadLong(256)
  xpivot.f = ReadFloat(256)
  ypivot.f = ReadFloat(256)
  zpivot.f = ReadFloat(256)
  blklen.l = ReadLong(256)
  Dim blkdata_color(blklen)
  Dim blkdata_zpos(blklen)
  Dim blkdata_visfaces(blklen)
  Dim blockdata_color.l(xsiz,zsiz,ysiz)
  Dim blockdata_visfaces.l(xsiz,zsiz,ysiz)
  Dim blockdata_occupied.l(xsiz,zsiz,ysiz)
  For k=0 To blklen-1
    color = ReadLong(256)
    zpos = ReadWord(256)
    visfaces = ReadByte(256)
    lighting = ReadByte(256)
    blkdata_color(k) = color
    blkdata_zpos(k) = zpos
    blkdata_visfaces(k) = visfaces
  Next
  For k=0 To xsiz-1
    ReadLong(256)
  Next
  offset = 0
  For x=0 To xsiz-1
    For y=0 To ysiz-1
      size = ReadWord(256)
      For k=0 To size-1
        c = blkdata_color(offset)
        blockdata_color(x,blkdata_zpos(offset),y) = RGB(Blue(c),Green(c),Red(c))
        If blockdata_color(x,blkdata_zpos(offset),y) = 0
          blockdata_color(x,blkdata_zpos(offset),y) = custom_color
        EndIf
        blockdata_visfaces(x,blkdata_zpos(offset),y) = blkdata_visfaces(offset)
        blockdata_occupied(x,blkdata_zpos(offset),y) = 1
        offset + 1
      Next
    Next
  Next
  CloseFile(256)
  
  displaylist = glGenLists_(1)
  glNewList_(displaylist,#GL_COMPILE)
  vertex_buffer = AllocateMemory(256*1024)
  vertex_buffer_start = vertex_buffer
  color_buffer = AllocateMemory(256*1024)
  color_buffer_start = color_buffer
  triangle_count.l = 0
  For x=0 To xsiz-1
    For y=0 To zsiz-1
      For z=0 To ysiz-1
        If blockdata_occupied(x,y,z) = 1
          red.f = Red(blockdata_color(x,y,z))/255.0
          green.f = Green(blockdata_color(x,y,z))/255.0
          blue.f = Blue(blockdata_color(x,y,z))/255.0
          x2.f = x*0.25
          y2.f = (zsiz-y)*0.25
          z2.f = z*0.25
          ;If blockdata_visfaces(x,y,z) & 5
            vertex_buffer = writeVertexToBuffer(vertex_buffer,0.25+x2,0.25+y2,0.25+z2)
            vertex_buffer = writeVertexToBuffer(vertex_buffer,0.0+x2,0.25+y2,0.25+z2)
            vertex_buffer = writeVertexToBuffer(vertex_buffer,0.25+x2,0.0+y2,0.25+z2)
                    
            vertex_buffer = writeVertexToBuffer(vertex_buffer,0.0+x2,0.25+y2,0.25+z2)
            vertex_buffer = writeVertexToBuffer(vertex_buffer,0.0+x2,0.0+y2,0.25+z2)
            vertex_buffer = writeVertexToBuffer(vertex_buffer,0.25+x2,0.0+y2,0.25+z2)
                    
            color_buffer = writeColorToBuffer(color_buffer,red*0.7,green*0.7,blue*0.7)
            color_buffer = writeColorToBuffer(color_buffer,red*0.7,green*0.7,blue*0.7)
            color_buffer = writeColorToBuffer(color_buffer,red*0.7,green*0.7,blue*0.7)
                    
            color_buffer = writeColorToBuffer(color_buffer,red*0.7,green*0.7,blue*0.7)
            color_buffer = writeColorToBuffer(color_buffer,red*0.7,green*0.7,blue*0.7)
            color_buffer = writeColorToBuffer(color_buffer,red*0.7,green*0.7,blue*0.7)
            triangle_count + 6
          ;EndIf
          ;If blockdata_visfaces(x,y,z) & 6
            vertex_buffer = writeVertexToBuffer(vertex_buffer,0.0+x2,0.0+y2,0.0+z2)
            vertex_buffer = writeVertexToBuffer(vertex_buffer,0.0+x2,0.25+y2,0.0+z2)
            vertex_buffer = writeVertexToBuffer(vertex_buffer,0.25+x2,0.0+y2,0.0+z2)
                    
            vertex_buffer = writeVertexToBuffer(vertex_buffer,0.0+x2,0.25+y2,0.0+z2)
            vertex_buffer = writeVertexToBuffer(vertex_buffer,0.25+x2,0.25+y2,0.0+z2)
            vertex_buffer = writeVertexToBuffer(vertex_buffer,0.25+x2,0.0+y2,0.0+z2)
                    
            color_buffer = writeColorToBuffer(color_buffer,red*0.7,green*0.7,blue*0.7)
            color_buffer = writeColorToBuffer(color_buffer,red*0.7,green*0.7,blue*0.7)
            color_buffer = writeColorToBuffer(color_buffer,red*0.7,green*0.7,blue*0.7)
                    
            color_buffer = writeColorToBuffer(color_buffer,red*0.7,green*0.7,blue*0.7)
            color_buffer = writeColorToBuffer(color_buffer,red*0.7,green*0.7,blue*0.7)
            color_buffer = writeColorToBuffer(color_buffer,red*0.7,green*0.7,blue*0.7)
            triangle_count + 6
          ;EndIf
          ;If blockdata_visfaces(x,y,z) & 4
            vertex_buffer = writeVertexToBuffer(vertex_buffer,0.0+x2,0.0+y2,0.0+z2)
            vertex_buffer = writeVertexToBuffer(vertex_buffer,0.25+x2,0.0+y2,0.0+z2)
            vertex_buffer = writeVertexToBuffer(vertex_buffer,0.0+x2,0.0+y2,0.25+z2)
                    
            vertex_buffer = writeVertexToBuffer(vertex_buffer,0.25+x2,0.0+y2,0.0+z2)
            vertex_buffer = writeVertexToBuffer(vertex_buffer,0.25+x2,0.0+y2,0.25+z2)
            vertex_buffer = writeVertexToBuffer(vertex_buffer,0.0+x2,0.0+y2,0.25+z2)
                    
            color_buffer = writeColorToBuffer(color_buffer,red*0.5,green*0.5,blue*0.5)
            color_buffer = writeColorToBuffer(color_buffer,red*0.5,green*0.5,blue*0.5)
            color_buffer = writeColorToBuffer(color_buffer,red*0.5,green*0.5,blue*0.5)
                    
            color_buffer = writeColorToBuffer(color_buffer,red*0.5,green*0.5,blue*0.5)
            color_buffer = writeColorToBuffer(color_buffer,red*0.5,green*0.5,blue*0.5)
            color_buffer = writeColorToBuffer(color_buffer,red*0.5,green*0.5,blue*0.5)
            triangle_count + 6
          ;EndIf
          ;If blockdata_visfaces(x,y,z) & 1
            vertex_buffer = writeVertexToBuffer(vertex_buffer,0.25+x2,0.25+y2,0.25+z2)
            vertex_buffer = writeVertexToBuffer(vertex_buffer,0.25+x2,0.0+y2,0.25+z2)
            vertex_buffer = writeVertexToBuffer(vertex_buffer,0.25+x2,0.25+y2,0.0+z2)
                
            vertex_buffer = writeVertexToBuffer(vertex_buffer,0.25+x2,0.0+y2,0.25+z2)
            vertex_buffer = writeVertexToBuffer(vertex_buffer,0.25+x2,0.0+y2,0.0+z2)
            vertex_buffer = writeVertexToBuffer(vertex_buffer,0.25+x2,0.25+y2,0.0+z2)
                    
            color_buffer = writeColorToBuffer(color_buffer,red*0.9,green*0.9,blue*0.9)
            color_buffer = writeColorToBuffer(color_buffer,red*0.9,green*0.9,blue*0.9)
            color_buffer = writeColorToBuffer(color_buffer,red*0.9,green*0.9,blue*0.9)
                   
            color_buffer = writeColorToBuffer(color_buffer,red*0.9,green*0.9,blue*0.9)
            color_buffer = writeColorToBuffer(color_buffer,red*0.9,green*0.9,blue*0.9)
            color_buffer = writeColorToBuffer(color_buffer,red*0.9,green*0.9,blue*0.9)
            triangle_count + 6
          ;EndIf
          ;If blockdata_visfaces(x,y,z) & 2
            vertex_buffer = writeVertexToBuffer(vertex_buffer,0.0+x2,0.0+y2,0.0+z2)
            vertex_buffer = writeVertexToBuffer(vertex_buffer,0.0+x2,0.0+y2,0.25+z2)
            vertex_buffer = writeVertexToBuffer(vertex_buffer,0.0+x2,0.25+y2,0.0+z2)
                    
            vertex_buffer = writeVertexToBuffer(vertex_buffer,0.0+x2,0.0+y2,0.25+z2)
            vertex_buffer = writeVertexToBuffer(vertex_buffer,0.0+x2,0.25+y2,0.25+z2)
            vertex_buffer = writeVertexToBuffer(vertex_buffer,0.0+x2,0.25+y2,0.0+z2)
                   
            color_buffer = writeColorToBuffer(color_buffer,red*0.9,green*0.9,blue*0.9)
            color_buffer = writeColorToBuffer(color_buffer,red*0.9,green*0.9,blue*0.9)
            color_buffer = writeColorToBuffer(color_buffer,red*0.9,green*0.9,blue*0.9)
                    
            color_buffer = writeColorToBuffer(color_buffer,red*0.9,green*0.9,blue*0.9)
            color_buffer = writeColorToBuffer(color_buffer,red*0.9,green*0.9,blue*0.9)
            color_buffer = writeColorToBuffer(color_buffer,red*0.9,green*0.9,blue*0.9)
            triangle_count + 6
          ;EndIf
          ;If blockdata_visfaces(x,y,z) & 3
            vertex_buffer = writeVertexToBuffer(vertex_buffer,0.25+x2,0.25+y2,0.25+z2)
            vertex_buffer = writeVertexToBuffer(vertex_buffer,0.25+x2,0.25+y2,0.0+z2)
            vertex_buffer = writeVertexToBuffer(vertex_buffer,0.0+x2,0.25+y2,0.25+z2)
                    
            vertex_buffer = writeVertexToBuffer(vertex_buffer,0.25+x2,0.25+y2,0.0+z2)
            vertex_buffer = writeVertexToBuffer(vertex_buffer,0.0+x2,0.25+y2,0.0+z2)
            vertex_buffer = writeVertexToBuffer(vertex_buffer,0.0+x2,0.25+y2,0.25+z2)
                    
            color_buffer = writeColorToBuffer(color_buffer,red,green,blue)
            color_buffer = writeColorToBuffer(color_buffer,red,green,blue)
            color_buffer = writeColorToBuffer(color_buffer,red,green,blue)
                   
            color_buffer = writeColorToBuffer(color_buffer,red,green,blue)
            color_buffer = writeColorToBuffer(color_buffer,red,green,blue)
            color_buffer = writeColorToBuffer(color_buffer,red,green,blue)
            triangle_count + 6
          ;EndIf
          ;rendercubeat(x*0.25,(zsiz-y)*0.25,z*0.25,0.25,0.25,0.25)
        EndIf
      Next
    Next
  Next
  glEnableClientState_(#GL_COLOR_ARRAY)
  glEnableClientState_(#GL_VERTEX_ARRAY)
  glColorPointer_(3,#GL_FLOAT,0,color_buffer_start)
  glVertexPointer_(3,#GL_FLOAT,0,vertex_buffer_start)
  glDrawArrays_(#GL_TRIANGLES,0,triangle_count)
  glDisableClientState_(#GL_VERTEX_ARRAY)
  glDisableClientState_(#GL_COLOR_ARRAY)
  glEndList_()
  FreeMemory(vertex_buffer_start)
  FreeMemory(color_buffer_start)
  
  ProcedureReturn displaylist
EndProcedure

Procedure.l loadKV6ForTeams(filename$,custom_color1.l,custom_color2.l)
  id.l = loadKV6(filename$,custom_color1)
  loadKV6(filename$,custom_color2)
  ProcedureReturn id.l
EndProcedure
; IDE Options = PureBasic 5.31 (Windows - x86)
; CursorPosition = 187
; FirstLine = 142
; Folding = -
; EnableUnicode
; EnableXP