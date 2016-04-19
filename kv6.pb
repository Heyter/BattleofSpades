Global Dim kv6_size_x.l(64)
Global Dim kv6_size_y.l(64)
Global Dim kv6_size_z.l(64)
Global Dim kv6_index.l(64)

#KV6_INDEX_FREE = -1

For k=0 To 64
  kv6_index(k) = #KV6_INDEX_FREE
Next


Procedure.l loadKV6(filename$,custom_color.l)
  ReadFile(256,filename$)
  If Not ReadString(256,#PB_UTF8,4) = "Kvxl"
    ProcedureReturn -1
  EndIf
  Define xsiz.l = ReadLong(256)
  Define ysiz.l = ReadLong(256)
  Define zsiz.l = ReadLong(256)
  Define xpivot.f = ReadFloat(256)
  Define ypivot.f = ReadFloat(256)
  Define zpivot.f = ReadFloat(256)
  Define blklen.l = ReadLong(256)
  Dim blkdata_color(blklen)
  Dim blkdata_zpos(blklen)
  Dim blkdata_visfaces(blklen)
  Dim blockdata_color.l(xsiz,zsiz,ysiz)
  Dim blockdata_visfaces.l(xsiz,zsiz,ysiz)
  Dim blockdata_occupied.l(xsiz,zsiz,ysiz)
  Define k
  For k=0 To blklen-1
    Define color = ReadLong(256)
    Define zpos = ReadWord(256)
    Define visfaces = ReadByte(256)
    Define lighting = ReadByte(256)
    blkdata_color(k) = color
    blkdata_zpos(k) = zpos
    blkdata_visfaces(k) = visfaces
  Next
  For k=0 To xsiz-1
    ReadLong(256)
  Next
  Define offset = 0
  Define x,y,k
  For x=0 To xsiz-1
    For y=0 To ysiz-1
      Define size = ReadWord(256)
      For k=0 To size-1
        Define c = blkdata_color(offset)
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
  
  Define displaylist = glGenLists_(1)
  glNewList_(displaylist,#GL_COMPILE)
  Define vertex_buffer = AllocateMemory(256*1024)
  Define vertex_buffer_start = vertex_buffer
  Define color_buffer = AllocateMemory(256*1024)
  Define color_buffer_start = color_buffer
  Define triangle_count.l = 0
  Define x,y,z
  For x=0 To xsiz-1
    For y=0 To zsiz-1
      For z=0 To ysiz-1
        If blockdata_occupied(x,y,z) = 1
          Define red.f = Red(blockdata_color(x,y,z))/255.0
          Define green.f = Green(blockdata_color(x,y,z))/255.0
          Define blue.f = Blue(blockdata_color(x,y,z))/255.0
          Define x2.f = x*0.25
          Define y2.f = (zsiz-y)*0.25
          Define z2.f = z*0.25
          If z+1>xsiz Or blockdata_occupied(x,y,z+1) = 0
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
          EndIf
          If z-1<0 Or blockdata_occupied(x,y,z-1) = 0
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
          EndIf
          If y-1<0 Or blockdata_occupied(x,y+1,z) = 0
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
          EndIf
          If x+1>=xsiz Or blockdata_occupied(x+1,y,z) = 0
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
          EndIf
          If x-1<0 Or blockdata_occupied(x-1,y,z) = 0
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
          EndIf
          If y-1<0 Or blockdata_occupied(x,y-1,z) = 0
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
          EndIf
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
  
  For k=0 To 64
   If kv6_index(k) = #KV6_INDEX_FREE
     kv6_index(k) = displaylist
     kv6_size_x(k) = xsiz
     kv6_size_y(k) = ysiz
     kv6_size_z(k) = zsiz
     Break
   EndIf
  Next
  
  ProcedureReturn displaylist
EndProcedure

Procedure.l kv6_sx(id.l)
  Define k
  For k=0 To 64
   If kv6_index(k) = id
     ProcedureReturn kv6_size_x(k)
   EndIf
 Next
 ProcedureReturn 0
EndProcedure

Procedure.l kv6_sy(id.l)
  Define k
  For k=0 To 64
   If kv6_index(k) = id
     ProcedureReturn kv6_size_y(k)
   EndIf
 Next
 ProcedureReturn 0
EndProcedure

Procedure.l kv6_sz(id.l)
  Define k
  For k=0 To 64
   If kv6_index(k) = id
     ProcedureReturn kv6_size_z(k)
   EndIf
 Next
 ProcedureReturn 0
EndProcedure

Procedure.l loadKV6ForTeams(filename$,custom_color1.l,custom_color2.l)
  Define id.l = loadKV6("kv6/"+ReadPreferenceString("team_1_skin_prefix","")+filename$,custom_color1)
  loadKV6("kv6/"+ReadPreferenceString("team_2_skin_prefix","")+filename$,custom_color2)
  loadKV6("kv6/"+filename$,0)
  ProcedureReturn id.l
EndProcedure
; IDE Options = PureBasic 5.31 (Windows - x86)
; CursorPosition = 248
; FirstLine = 194
; Folding = -
; EnableUnicode
; EnableXP
; UseMainFile = main.pb
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant