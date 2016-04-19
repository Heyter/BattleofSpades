Global map_data.l
Global map_data_size.l
Global map_data_index.l

Global map_data_compressed.l
Global map_data_compressed_size.l
Global map_data_compressed_index.l

Global map_fog_red.l
Global map_fog_green.l
Global map_fog_blue.l

Global team_1_red.l = 0
Global team_1_green.l = 0
Global team_1_blue.l = 255
Global team_1_name.s = "Blue"
Global team_1_score.l = 0
Global team_1_intel_player.l = -1
Global team_1_intel_x.f = 0.0
Global team_1_intel_y.f = 0.0
Global team_1_intel_z.f = 0.0
Global team_1_base_x.f = 256.0
Global team_1_base_y.f = 128.0
Global team_1_base_z.f = 256.0

Global team_2_red.l = 0
Global team_2_green.l = 255
Global team_2_blue.l = 0
Global team_2_name.s = "Green"
Global team_2_score.l = 0
Global team_2_intel_player.l = -1
Global team_2_intel_x.f = 0.0
Global team_2_intel_y.f = 0.0
Global team_2_intel_z.f = 0.0
Global team_2_base_x.f = 256.0
Global team_2_base_y.f = 128.0
Global team_2_base_z.f = 256.0

Global score_max.l = 10

Global map_loaded = 0

Global Dim blocks.l(512,64,512)
Global Dim lightlevels.l(512,64,512)
Global map_overview_tmp_image.l = CreateImage(#PB_Any,512,512,24)
Global map_texture_id.l = -1

Global Dim tracer_used.l(512)
Global Dim tracer_x.f(512)
Global Dim tracer_y.f(512)
Global Dim tracer_z.f(512)
Global Dim tracer_speed_x.f(512)
Global Dim tracer_speed_y.f(512)
Global Dim tracer_speed_z.f(512)
Global Dim tracer_created.l(512)
Global Dim tracer_creator.l(512)
Global last_tracer_update.l
Global last_physics_update.l

Global Dim display_list_ids.l(64,64)
Global Dim display_list_ids_shadowed.l(64,64)
Global Dim display_list_update_flag.l(64,64)
Global display_list_created.l = 0

Global Dim kill_action_message.s(16)
Global Dim kill_action_time.l(16)
Global Dim kill_action_team.l(16)

Global Dim chat_message.s(16)
Global Dim chat_message_time.l(16)
Global Dim chat_message_color.l(16)

Global tent_count.l = 0
Global Dim tent_x.l(16)
Global Dim tent_y.l(16)
Global Dim tent_z.l(16)
Global Dim tent_team.l(16)
Global Dim tent_progress.f(16)
Global Dim tent_progress_team.l(16)

#TENT_RADIUS = 16.0

Procedure.l nearestTent(x.f,y.f,z.f)
  Define k
  For k=0 To tent_count-1
    If Pow(tent_x(k)-x,2)+Pow(tent_y(k)-y,2)+Pow(tent_z(k)-z,2)<#TENT_RADIUS*#TENT_RADIUS
      ProcedureReturn k
    EndIf
  Next
  ProcedureReturn -1
EndProcedure

Procedure flagForUpdate(x.l,z.l)
  Define blockx.l = Int(x/8.0)
  Define blockz.l = Int(z/8.0)
  display_list_update_flag(blockx,blockz) = 1
  If blockx>0
    display_list_update_flag(blockx-1,blockz) = 1
  EndIf
  If blockz>0
    display_list_update_flag(blockx,blockz-1) = 1
  EndIf
  If blockx<63
    display_list_update_flag(blockx+1,blockz) = 1
  EndIf
  If blockz<63
    display_list_update_flag(blockx,blockz+1) = 1
  EndIf
EndProcedure

Procedure.l getBlockSafe(x,y,z)
  If x>-1 And y>-1 And z>-1 And x<512 And y<64 And z<512
    ProcedureReturn blocks(x,y,z)
  EndIf
  If y>63
    ProcedureReturn $FFFFFFFF
  EndIf
  ProcedureReturn $FFFFFF00
EndProcedure

Procedure setBlockSafe(x,y,z,color)
  If x>-1 And y>2 And z>-1 And x<512 And y<64 And z<512
    ;If y>heightmap(x,z)
    ;  heightmap(x,z) = y
    ;EndIf
    blocks(x,y,z) = color
    ;map_createoverview(map_image)
    ;map_texture_id = loadTextureFromImage(map_image,0,0)
    flagForUpdate(x,z)
  EndIf
EndProcedure

Procedure.l getLightLevel(x,y,z)
  If x>-1 And y>-1 And z>-1 And x<512 And y<64 And z<512
    ProcedureReturn lightlevels(x,y,z)
  EndIf
  ProcedureReturn 4
EndProcedure

Procedure setLightLevel(x,y,z,level)
  If x>-1 And y>-1 And z>-1 And x<512 And y<64 And z<512
    lightlevels(x,y,z) = level
  EndIf
EndProcedure

Procedure.l isBlockSolid(color)
  If color = $FFFFFFFF
    ProcedureReturn 0
  Else
    ProcedureReturn 1
  EndIf
EndProcedure

Procedure.l blockAbove(x,y,z)
  Define k
  For k=y To 63
	  If Not blocks(x,k,z) = $FFFFFFFF
	    ProcedureReturn k-y;return distance
	  EndIf
	Next
	ProcedureReturn -1 ;no block found
EndProcedure

Procedure.l blockAboveForShadow(x,y,z)
  Define k
  For k=y To 63
	  If Not getBlockSafe(x+(k-y)/2,k,z) = $FFFFFFFF
	    ProcedureReturn k-y;return distance
	  EndIf
	Next
	ProcedureReturn -1 ;no block found
EndProcedure

Procedure.l clipBox(x.l, y.l, z.l)
		If x < 0 Or x >= 512 Or z < 0 Or z >= 512
			ProcedureReturn 1
		ElseIf y < 0
			ProcedureReturn 0
		EndIf
		Define sy.l = y
		If sy = 63
			sy = 62
		ElseIf sy >= 64
			ProcedureReturn 1
		EndIf
		ProcedureReturn isBlockSolid(getBlockSafe(x,64-sy,z))
EndProcedure
	
Procedure.l clipworld(x.l,y.l,z.l)
  If x < 0 Or x >= 512 Or z < 0 Or z >= 512
    ProcedureReturn 0
  EndIf
  If y < 0
    ProcedureReturn 0
  EndIf
  Define sy.l = y
  If sy = 63
      sy = 62
  ElseIf sy >= 63
      ProcedureReturn 1
  ElseIf sy < 0
    ProcedureReturn 0
  EndIf
  ProcedureReturn isBlockSolid(getBlockSafe(x,64-sy,z))
EndProcedure

Procedure.l clipBoxFloat(x.f, y.f, z.f)
  ProcedureReturn clipBox(Round(x,#PB_Round_Down),Round(y,#PB_Round_Down),Round(z,#PB_Round_Down))
EndProcedure

Global Dim block_visited_x.l(32768)
Global Dim block_visited_y.l(32768)
Global Dim block_visited_z.l(32768)
Global block_visited_index.l = 0
Global block_floating.l = 1

Global Dim falling_block_color.l(2048)
Global Dim falling_block_x.f(2048)
Global Dim falling_block_y.f(2048)
Global Dim falling_block_z.f(2048)
Global Dim falling_block_v.f(2048)
Global Dim falling_block_alive.l(2048)

Define k
For k=0 To 2048
  falling_block_alive(k) = 0
Next

Procedure clear_visited_list()
  block_visited_index = 0
EndProcedure

Procedure.l block_visted(x.l,y.l,z.l)
  Define k
  For k=0 To block_visited_index-1
    If block_visited_x(k) = x And block_visited_y(k) = y And block_visited_z(k) = z
      ProcedureReturn 1
    EndIf
  Next
  ProcedureReturn 0
EndProcedure

Procedure set_block_visted(x.l,y.l,z.l)
  If block_visited_index < 32768-1
    block_visited_x(block_visited_index) = x
    block_visited_y(block_visited_index) = y
    block_visited_z(block_visited_index) = z
    block_visited_index + 1
  EndIf
EndProcedure

Declare isFloatingLoop(x.l,y.l,z.l)

Procedure.l isFloating(x.l,y.l,z.l)
  clear_visited_list()
  block_floating = 1
  isFloatingLoop(x,y,z)
  ProcedureReturn block_floating
EndProcedure

Procedure addFallingBlock(x.f,y.f,z.f,color.l)
  Define k
  For k=0 To 2048
    If falling_block_alive(k) = 0
      falling_block_x(k) = x
      falling_block_y(k) = y
      falling_block_z(k) = z
      falling_block_v(k) = 0.0
      falling_block_color(k) = color
      falling_block_alive(k) = 1
      Break
    EndIf
  Next
EndProcedure

Procedure updateFallingBlocks(dt.f)
  Define k
  For k=0 To 2048
    If falling_block_alive(k) = 1
      glColor4f(Red(falling_block_color(k)),Green(falling_block_color(k)),Blue(falling_block_color(k)),1.0)
      rendercubeat(falling_block_x(k),falling_block_y(k),falling_block_z(k),1.0,1.0,1.0)
      falling_block_v(k) + dt
      falling_block_y(k) - falling_block_v(k)*dt*32.0
      If falling_block_y(k) <= 0.0
        falling_block_alive(k) = 0
      EndIf
    EndIf
  Next
EndProcedure

Procedure destoryFloatingStructure()
  Define k
  For k=0 To block_visited_index-1
    addFallingBlock(block_visited_x(k),block_visited_y(k),block_visited_z(k),blocks(block_visited_x(k),block_visited_y(k),block_visited_z(k)))
    setBlockSafe(block_visited_x(k),block_visited_y(k),block_visited_z(k),$FFFFFFFF)
  Next
EndProcedure
  
Procedure isFloatingLoop(x.l,y.l,z.l)
  set_block_visted(x,y,z)
  If y = 0
    block_floating = 0
  EndIf
  If isBlockSolid(getBlockSafe(x,y-1,z)) And block_floating = 1 And Not block_visted(x,y-1,z)
    isFloatingLoop(x,y-1,z)
  EndIf
  If isBlockSolid(getBlockSafe(x+1,y,z)) And block_floating = 1 And Not block_visted(x+1,y,z)
    isFloatingLoop(x+1,y,z)
  EndIf
  If isBlockSolid(getBlockSafe(x-1,y,z)) And block_floating = 1 And Not block_visted(x-1,y,z)
    isFloatingLoop(x-1,y,z)
  EndIf
  If isBlockSolid(getBlockSafe(x,y,z+1)) And block_floating = 1 And Not block_visted(x,y,z+1)
    isFloatingLoop(x,y,z+1)
  EndIf
  If isBlockSolid(getBlockSafe(x,y,z-1)) And block_floating = 1 And Not block_visted(x,y,z-1)
    isFloatingLoop(x,y,z-1)
  EndIf
  If isBlockSolid(getBlockSafe(x,y+1,z)) And block_floating = 1 And Not block_visted(x,y+1,z)
    isFloatingLoop(x,y+1,z)
  EndIf
EndProcedure

Procedure map_unload()
  map_loaded = 0
EndProcedure

Procedure map_loadfromdata()
  Define pointer = 0
  Define x,y,z
For z = 0 To 511
  For x = 0 To 511
    For y = 0 To 63
	  	 blocks(x,y,z) = $FFFFFFFF
	  Next
	  y = 0
	  Repeat
		  Define color = $FFFFFFFF
		  Define i = 0
		  Define number_4byte_chunks = PeekA(pointer+map_data+0)
		  Define top_color_start = PeekA(pointer+map_data+1)
		  Define top_color_end   = PeekA(pointer+map_data+2)
		  Define bottom_color_start = 0
		  Define bottom_color_end = 0
		  Define len_top = 0
		  Define len_bottom = 0
		  
		  Define offset = 0
		  For y=top_color_start To top_color_end
		    color = PeekA(pointer+map_data+6+offset)+PeekA(pointer+map_data+5+offset)*256+PeekA(pointer+map_data+4+offset)*65536
		    blocks(x,64-y,z) = color
		    offset + 4
		  Next
		  
		  Define pointer_old = pointer
		            
		  len_bottom = top_color_end - top_color_start + 1

		  If number_4byte_chunks = 0
		    pointer + 4 * (len_bottom + 1)
		    Break
		  EndIf

		  len_top = (number_4byte_chunks-1) - len_bottom

		  pointer + PeekA(pointer+map_data+0)*4
		  
		  bottom_color_end   = PeekA(pointer+map_data+3)
		  bottom_color_start = bottom_color_end - len_top
		  
		  For y = bottom_color_start To bottom_color_end-1
		    color = PeekA(pointer_old+map_data+6+offset)+PeekA(pointer_old+map_data+5+offset)*256+PeekA(pointer_old+map_data+4+offset)*65536
		    blocks(x,64-y,z) = color
		    offset + 4
		  Next
		  
		  For y = top_color_end+1 To bottom_color_start-1
		    blocks(x,64-y,z) = RGB(84,52,32)
		  Next
		ForEver
		For y=0 To 64
		 If Not blocks(x,y,z) = $FFFFFFFF
		  Break
		 EndIf
		 blocks(x,y,z) = RGB(84,52,32)
		Next
	Next
Next
FreeMemory(map_data)
FreeMemory(map_data_compressed)
display_list_created = 0
map_loaded = 1
EndProcedure

Global Dim cube_line_x.l(64)
Global Dim cube_line_y.l(64)
Global Dim cube_line_z.l(64)

Procedure.l cube_line_native(x1.l,y1.l,z1.l,x2.l,y2.l,z2.l)
  Define vector_c_x.l = 0
  Define vector_c_y.l = 0
  Define vector_c_z.l = 0
  Define vector_d_x.l = 0
  Define vector_d_y.l = 0
  Define vector_d_z.l = 0
	Define ixi.l = 0
	Define iyi.l = 0
	Define izi.l = 0
	Define dx.l = 0
	Define dy.l = 0
	Define dz.l = 0
	Define dxi.l = 0
	Define dyi.l = 0
	Define dzi.l = 0
	Define count.l = 0

	;Note: positions MUST be rounded towards -inf
	vector_c_x = x1
	vector_c_y = y1
	vector_c_z = z1

	vector_d_x = x2 - x1
	vector_d_y = y2 - y1
	vector_d_z = z2 - z1

	If vector_d_x < 0
	  ixi = -1
	Else
	  ixi = 1
	EndIf
	If vector_d_y < 0
	  iyi = -1
	Else
	  iyi = 1
	EndIf
	If vector_d_z < 0
	  izi = -1
	Else
	  izi = 1
	EndIf

	If Abs(vector_d_x) >= Abs(vector_d_y) And Abs(vector_d_x) >= Abs(vector_d_z)
	  dxi = 1024
	  dx = 512
	  If Not vector_d_y
	    dyi = 1073741823/512
	  Else
	    dyi = Abs(vector_d_x*1024/vector_d_y)
	  EndIf
	  dy = dyi/2
	  If Not vector_d_z
	    dzi = 1073741823/512
	  Else
	    dzi = Abs(vector_d_x*1024/vector_d_z)
	  EndIf
		dz = dzi/2
	ElseIf Abs(vector_d_y) >= Abs(vector_d_z)
	  dyi = 1024
	  dy = 512
	  If Not vector_d_x
	    dxi = 1073741823/512
	  Else
	    dxi = Abs(vector_d_y*1024/vector_d_x)
	  EndIf
	  dx = dxi/2
	  If Not vector_d_z
	    dzi = 1073741823/512
	  Else
	    dzi = Abs(vector_d_y*1024/vector_d_z)
	  EndIf
		dz = dzi/2
	Else
	  dzi = 1024
	  dz = 512
	  If Not vector_d_x
	    dxi = 1073741823/512
	  Else
	    dxi = Abs(vector_d_z*1024/vector_d_x)
		EndIf
		dx = dxi/2
		If Not vector_d_y
		  dyi = 1073741823/512
		Else
		  dyi = Abs(vector_d_z*1024/vector_d_y)
		EndIf
		dy = dyi/2
	EndIf
	If ixi >= 0
	  dx = dxi-dx
	EndIf
	If iyi >= 0
	  dy = dyi-dy
	EndIf
	If izi >= 0
	  dz = dzi-dz
	EndIf

	Repeat
	  cube_line_x(count) = vector_c_x
	  cube_line_y(count) = 64-vector_c_z
	  cube_line_z(count) = vector_c_y
		
		count + 1
		If count = 64
		  ProcedureReturn count
		EndIf

		If vector_c_x = x2 And vector_c_y = y2 And vector_c_z = z2
		  ProcedureReturn count
		EndIf

		If dz <= dx And dz <= dy
			vector_c_z + izi
			If vector_c_z < 0 Or vector_c_z >= 64
			  ProcedureReturn count
			EndIf
			dz + dzi
		Else
		  If dx < dy
				vector_c_x + ixi
				If vector_c_x >= 512
				  ProcedureReturn count
				EndIf
				dx + dxi
			Else
				vector_c_y + iyi
				If vector_c_y >= 512
				  ProcedureReturn count
				EndIf
				dy + dyi
			EndIf
		EndIf
	ForEver
EndProcedure

Procedure.l cube_line(x1.l,y1.l,z1.l,x2.l,y2.l,z2.l,color.l)
  Define count.l = cube_line_native(x1,z1,64-y1,x2,z2,64-y2)
  Define k.l
  For k=0 To count-1
    setBlockSafe(cube_line_x(k),cube_line_y(k),cube_line_z(k),color)
  Next
  ProcedureReturn count
EndProcedure
; IDE Options = PureBasic 5.31 (Windows - x86)
; CursorPosition = 137
; FirstLine = 72
; Folding = Q+---
; EnableUnicode
; EnableXP
; UseMainFile = main.pb
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant