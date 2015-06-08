Global hdc
Global player_display_list_created.l = 0
Global display_list_leg_left.l
Global display_list_leg_right.l

Global display_list_rifle.l
Global display_list_smg.l
Global display_list_shotgun.l
Global display_list_spade.l
Global display_list_block.l
Global display_list_grenade.l

Global fullscreen_mode.l = 0

Global mouse_x_old.l
Global mouse_y_old.l
Global mouse_x.l
Global mouse_y.l
Global mouse_delta_x.l
Global mouse_delta_y.l
Global mouse_button_1.l
Global mouse_button_2.l
Global mouse_button_1_released.l
Global mouse_button_2_released.l

Global spectate.l = 1
Global spectate_stick_to_player.l = 1
Global spectate_player.l = 0

Global camera_x.f = 256.0
Global camera_y.f = 32.0
Global camera_z.f = 256.0

Global key_forward.l
Global key_backward.l
Global key_left.l
Global key_right.l
Global key_space.l
Global key_shift.l
Global key_shift_time.l
Global key_shift_old.l
Global key_ctrl.l
Global key_tab.l
Global key_m.l

Global hide_hud.l = 0
Global escape_menu.l = 0

Global last_input.l

Global texture_font.l
Global texture_white.l
Global texture_splash.l
Global texture_target.l
Global texture_background.l
Global texture_noise.l
Global texture_indicator.l
Global texture_intel.l

Global chat_opened.l = 0
Global chat_team.l = 0
Global chat_input$

Global kv6_cp.l
Global kv6_intel.l
Global kv6_semi.l
Global kv6_smg.l
Global kv6_shotgun.l
Global kv6_playerdead.l
Global kv6_spade.l
Global kv6_grenade.l

Global Dim LightPos.f(4)
LightPos(0) = 512.0
LightPos(1) = 256.0
LightPos(2) = 256.0
LightPos(3) = 1.0
Global Dim LightPos2.f(4)
LightPos2(0) = -512.0
LightPos2(1) = -256.0
LightPos2(2) = -256.0
LightPos2(3) = 1.0
Global Dim LightColor.f(4)
LightColor(0) = 0.7
LightColor(1) = 0.7
LightColor(2) = 0.7
LightColor(3) = 1.0
Global Dim LightColor2.f(4)
LightColor2(0) = 0.7
LightColor2(1) = 0.7
LightColor2(2) = 0.7
LightColor2(3) = 1.0

Global Dim FogColor.f(4)

Global screen_width.l
Global screen_height.l

Procedure openEngineWindow(width, height, fullscreen)
  screen_width = width
  screen_height = height
  fullscreen_mode = fullscreen
  ;pfd.PIXELFORMATDESCRIPTOR
  InitKeyboard()
  InitMouse()
  If fullscreen_mode = 1
    ExamineScreenModes()
    biggest_width = 0
    biggset_height = 0

    While NextScreenMode()
      If biggest_width*biggset_height<ScreenModeWidth()*ScreenModeHeight() And ScreenModeDepth() >= 16
        biggest_width = ScreenModeWidth()
        biggset_height = ScreenModeHeight()
      EndIf
    Wend
    screen_width = biggest_width
    screen_height = biggset_height
    OpenScreen(screen_width,screen_height,24,"Battle of Spades",#PB_Screen_NoSynchronization)
  Else
    hWnd = OpenWindow(0, 0, 0, width, height, "Battle of Spades",#PB_Window_MinimizeGadget|#PB_Window_ScreenCentered|#PB_Window_SizeGadget|#PB_Window_MaximizeGadget)
    hWnd = OpenWindowedScreen(WindowID(0),0,0,width,height,#True,0,0,#PB_Screen_NoSynchronization)
  EndIf
  KeyboardMode(#PB_Keyboard_International)
;   hdc = GetDC_(hWnd)
;   pfd\nSize        = SizeOf(PIXELFORMATDESCRIPTOR)
;   pfd\nVersion     = 1
;   pfd\dwFlags      = #PFD_SUPPORT_OPENGL | #PFD_DOUBLEBUFFER | #PFD_DRAW_TO_WINDOW
;   pfd\dwLayerMask  = #PFD_MAIN_PLANE
;   pfd\iPixelType   = #PFD_TYPE_RGBA
;   pfd\cColorBits   = 24
;   pfd\cDepthBits   = 24
;   SetPixelFormat_(hdc, ChoosePixelFormat_(hdc, pfd), pfd)
;   wglMakeCurrent_(hdc,wglCreateContext_(hdc))
  glShadeModel_(#GL_SMOOTH)
  glDepthFunc_(#GL_LEQUAL)
  glHint_(#GL_PERSPECTIVE_CORRECTION_HINT, #GL_NICEST)
  glEnable_(#GL_DEPTH_TEST)
  glEnable_(#GL_CULL_FACE)
  glDisable_(#GL_LIGHTING)
  ;glEnable_(#GL_COLOR_MATERIAL)
  ;glEnable_($809D) ;#GL_MULTISAMPLE
  ;glColorMaterial_(#GL_FRONT, #GL_DIFFUSE)
  ;glColorMaterial_(#GL_FRONT, #GL_AMBIENT)
  
  ;glLightfv_(#GL_LIGHT0,#GL_POSITION,LightPos())
  ;glLightfv_(#GL_LIGHT0, #GL_DIFFUSE, LightColor())
  ;glLightfv_(#GL_LIGHT1,#GL_POSITION,LightPos2())
  ;glLightfv_(#GL_LIGHT1, #GL_DIFFUSE, LightColor2())
  ;glLightfv_(#GL_LIGHT0, #GL_AMBIENT, LightAmbient())
  glFogi_(#GL_FOG_MODE, #GL_LINEAR)
  glFogf_(#GL_FOG_START, 80.0)
  glFogf_(#GL_FOG_END, 120.0)
  glEnable_(#GL_FOG)
  glDisable_($84F5) ;same as glDisable(#GL_TEXTURE_RECTANGLE)
  glBlendFunc_(#GL_SRC_ALPHA, #GL_ONE_MINUS_SRC_ALPHA)
  glEnable_(#GL_BLEND)
  
  
  texture_font = loadBMPTextureFile("fonts/FixedSys_Bold_36.bmp")
  texture_white = loadBMPTextureFile("png/white.png")
  texture_splash = loadPNGTextureFile("png/splash.png")
  texture_target = loadPNGTextureFile("png/target.png")
  texture_background = loadBMPTextureFile("png/loading.png")
  texture_noise = loadBMPTextureFile("png/noise.bmp")
  texture_indicator = loadBMPTextureFile("png/indicator.bmp")
  texture_intel = loadBMPTextureFile("png/intel.bmp")
  kv6_semi = loadKV6("kv6/semi.kv6",Red(255))
  kv6_smg = loadKV6("kv6/smg.kv6",Red(255))
  kv6_shotgun = loadKV6("kv6/shotgun.kv6",Red(255))
  kv6_spade = loadKV6("kv6/spade.kv6",Red(255))
  kv6_grenade = loadKV6("kv6/grenade.kv6",Red(255))
EndProcedure

Procedure.f engineWindowWidth()
  ProcedureReturn screen_width
EndProcedure

Procedure.f engineWindowHeight()
  ProcedureReturn screen_height
EndProcedure

Procedure drawRectSub(x.f, y.f, w.f, h.f, a.f, b.f, c.f, d.f)
	x_pos.f = x
  y_pos.f = engineWindowHeight()-y
  x_s.f = w
  y_s.f = -h
    
  x_pos = x_pos/engineWindowWidth()
  y_pos = y_pos/engineWindowHeight()
  x_s = x_s/engineWindowWidth()
  y_s = y_s/engineWindowHeight()
  x2.f = -1.0+(x_pos*2.0)
  y2.f = 1.0-(y_pos*2.0)
  x3.f = x2+(x_s*2.0)
  y3.f = y2-(y_s*2.0)
  x2 = (x2*0.5+0.5)*engineWindowWidth()
  y2 = (y2*0.5+0.5)*engineWindowHeight()
  x3 = (x3*0.5+0.5)*engineWindowWidth()
  y3 = (y3*0.5+0.5)*engineWindowHeight()
  glBegin_(#GL_TRIANGLE_FAN)
	glTexCoord2f_(a,b)
	glVertex3f_(x2, y2, 0.0)
	glTexCoord2f_(a+c,b)
	glVertex3f_(x3, y2, 0.0)
	glTexCoord2f_(a+c,b+d)
	glVertex3f_(x3, y3, 0.0)
	glTexCoord2f_(a,b+d)
	glVertex3f_(x2, y3, 0.0)
	glEnd_()
EndProcedure
	
Procedure drawString(x.f, y.f, h.f, text$)
  glBindTexture_(#GL_TEXTURE_2D,texture_font)
  For k=0 To Len(text$)-1
    index.l = Asc(Mid(text$,k+1,1))-32
    If index > 0
	    a.l = (Int(index)%16)
	    b.l = (Int(index)/16)
	    drawRectSub(x+k*0.5*h, y, 0.5*h, h, 0.0625*a, 0.0714*b, 0.0625, 0.0714)
	  EndIf
	Next
	glBindTexture_(#GL_TEXTURE_2D,0)
EndProcedure

Procedure stringWidth(h.f, text$)
  ProcedureReturn Len(text$)*0.5*h
EndProcedure

Procedure subDraw(x2.f,y2.f,x3.f,y3.f)
  glBegin_(#GL_TRIANGLE_FAN)
  glTexCoord2f_(0.0,0.0)
  glVertex3f_(x2, y2, 0.0)
  glTexCoord2f_(1.0,0.0)
  glVertex3f_(x3, y2, 0.0)
  glTexCoord2f_(1.0,1.0)
  glVertex3f_(x3, y3, 0.0)
  glTexCoord2f_(0.0,1.0)
  glVertex3f_(x2, y3, 0.0)
  glEnd_()
EndProcedure

Procedure drawRect(x.f,y.f,w.f,h.f)
  x_pos.f = x
	y_pos.f = engineWindowHeight()-y
	x_s.f = w
	y_s.f = -h
	    
	x_pos = x_pos/engineWindowWidth()
	y_pos = y_pos/engineWindowHeight()
	x_s = x_s/engineWindowWidth()
	y_s = y_s/engineWindowHeight()
	x2.f = -1.0+(x_pos*2.0)
	y2.f = 1.0-(y_pos*2.0)
	x3.f = x2+(x_s*2.0)
	y3.f = y2-(y_s*2.0)
	subDraw((x2*0.5+0.5)*engineWindowWidth(),(y2*0.5+0.5)*engineWindowHeight(),(x3*0.5+0.5)*engineWindowWidth(),(y3*0.5+0.5)*engineWindowHeight())
EndProcedure

Procedure updatemouse(event)
  ;If fullscreen_mode = 1
    ExamineMouse()
    mouse_x_old = engineWindowWidth()/2
    mouse_y_old = engineWindowHeight()/2
    mouse_x = MouseX()
    mouse_y = MouseY()
    mouse_delta_x = -MouseDeltaX()
    mouse_delta_y = -MouseDeltaY()
    mouse_button_1_released = 0
    mouse_button_2_released = 0
    If mouse_button_1 = 1 And MouseButton(1) = 0
      mouse_button_1_released = 1
    EndIf
    If mouse_button_2 = 1 And MouseButton(2) = 0
      mouse_button_2_released = 1
    EndIf
    mouse_button_1 = MouseButton(1)
    mouse_button_2 = MouseButton(2)
    MouseLocate(engineWindowWidth()/2,engineWindowHeight()/2)
    If Not own_player_id = -1
      player_left_button(own_player_id) = mouse_button_1
      player_right_button(own_player_id) = mouse_button_2
    EndIf
;   Else
;     mouse_x_old = mouse_x
;     mouse_y_old = mouse_y
;     mouse_x = WindowMouseX(0)
;     mouse_y = WindowMouseY(0)
;     mouse_delta_x = mouse_x_old-mouse_x
;     mouse_delta_y = mouse_y_old-mouse_y
;     If event = #WM_LBUTTONDOWN
;       mouse_button_1 = 1
;       SetWindowPos_(WindowID(0),#HWND_TOPMOST,0,0,0,0,#SWP_NOMOVE|#SWP_NOSIZE|#SWP_FRAMECHANGED)
;     EndIf
;     If event = #PB_Event_LeftClick
;       mouse_button_1 = 0
;     EndIf
;     If event = #WM_RBUTTONDOWN
;       mouse_button_2 = 1
;     EndIf
;     If event = #PB_Event_RightClick
;       mouse_button_2 = 0
;     EndIf
;   EndIf
EndProcedure

Procedure updatekeyboard(event)
  ExamineKeyboard()
  key_forward = 0
  key_backward = 0
  key_left = 0
  key_right = 0
  key_space = 0
  key_shift_old = key_shift
  key_shift = 0
  key_ctrl = 0
  key_tab = 0
  key_m = 0
  If chat_opened = 0
    If KeyboardPushed(#PB_Key_W)
      key_forward = 1
    EndIf
    If KeyboardPushed(#PB_Key_S)
      key_backward = 1
    EndIf
    If KeyboardPushed(#PB_Key_A)
      key_left = 1
    EndIf
    If KeyboardPushed(#PB_Key_D)
      key_right = 1
    EndIf
    If KeyboardPushed(#PB_Key_Space)
      key_space = 1
      If spectate = 1 And spectate_stick_to_player = 1
        spectate_stick_to_player = 0
        camera_x = getPlayerX(spectate_player)
        camera_y = getPlayerY(spectate_player)
        camera_z = getPlayerZ(spectate_player)
      EndIf
    EndIf
    If KeyboardPushed(#PB_Key_LeftShift) And Not KeyboardPushed(#PB_Key_LeftControl)
      key_shift = 1
    EndIf
    If Not key_shift_old = key_shift
      key_shift_time = ElapsedMilliseconds()
    EndIf
    If KeyboardPushed(#PB_Key_LeftControl) And Not KeyboardPushed(#PB_Key_LeftShift)
      key_ctrl = 1
    EndIf
    
    If KeyboardReleased(#PB_Key_1)
      If KeyboardPushed(#PB_Key_0)
        joingame(0)
      Else
        own_item = 0
        sendTool(0)
      EndIf
    EndIf
    If KeyboardReleased(#PB_Key_2)
      If KeyboardPushed(#PB_Key_0)
        joingame(1)
      Else
        own_item = 1
        sendTool(1)
      EndIf
    EndIf
    If KeyboardReleased(#PB_Key_3)
      If KeyboardPushed(#PB_Key_0)
        joingame(-1)
      Else
        own_item = 2
        sendTool(2)
      EndIf
    EndIf
    If KeyboardReleased(#PB_Key_4)
      If Not KeyboardPushed(#PB_Key_0)
        own_item = 3
        sendTool(3)
      EndIf
    EndIf
    If KeyboardReleased(#PB_Key_R)
      left_to_max.l = mag_size(own_weapon)-player_ammo(own_player_id)
      player_ammo(own_player_id) + left_to_max
      createSoundSourceAtCamera(12+own_weapon)
      sendReloadWeaponPacket()
    EndIf
    
    If KeyboardPushed(#PB_Key_Tab)
      key_tab = 1
    EndIf
    If KeyboardPushed(#PB_Key_M)
      key_m = 1
    EndIf
    If KeyboardReleased(#PB_Key_F1)
      If hide_hud
        hide_hud = 0
      Else
        hide_hud = 1
      EndIf
    EndIf
    
    If KeyboardReleased(#PB_Key_Add)
      volume + 1
      If volume = 11
        volume = 10
      EndIf
      For k=0 To 14
        chat_message(k) = chat_message(k+1)
        chat_message_color(k) = chat_message_color(k+1)
        chat_message_time(k) = chat_message_time(k+1)
      Next
      chat_message(15) = "Volume: "+volume
      chat_message_color(15) = -1
      chat_message_time(15) = ElapsedMilliseconds()
    EndIf
    If KeyboardReleased(#PB_Key_Subtract)
      volume - 1
      If volume = -1
        volume = 0
      EndIf
      For k=0 To 14
        chat_message(k) = chat_message(k+1)
        chat_message_color(k) = chat_message_color(k+1)
        chat_message_time(k) = chat_message_time(k+1)
      Next
      chat_message(15) = "Volume: "+volume
      chat_message_color(15) = -1
      chat_message_time(15) = ElapsedMilliseconds()
    EndIf
    
    If KeyboardReleased(#PB_Key_I)
      spectate_player + 1
      If spectate_player = 32
        spectate_player = 0
      EndIf
    EndIf
  EndIf
  If KeyboardReleased(#PB_Key_T) And chat_opened = 0
    chat_opened = 1
    chat_team = 0
  EndIf
  If KeyboardReleased(#PB_Key_Y) And chat_opened = 0 And escape_menu = 0
    chat_opened = 1
    chat_team = 1
  EndIf
  If KeyboardReleased(#PB_Key_Return) And chat_opened = 1
    If Not chat_input$ = ""
      sendChat(chat_team,chat_input$)
      createSoundSourceAtCamera(19)
      chat_input$ = ""
    EndIf
    chat_opened = 0
  EndIf
  If chat_opened = 1
    If KeyboardReleased(#PB_Key_Back)  
      chat_input$ = Left(chat_input$,Len(chat_input$)-1)
    Else
      key$ = KeyboardInkey()
      If Not FindString(" 1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!§$%&/()=?@-_.:,;#'+*~<>|{[]}\"+Chr(34),key$) = 0
        chat_input$ + key$
      EndIf
    EndIf
  EndIf
  
  If KeyboardReleased(#PB_Key_Escape)
    If escape_menu = 1
      escape_menu = 0
      ReleaseMouse(0)
    Else
      escape_menu = 1
      ReleaseMouse(1)
    EndIf
  EndIf
  
  If escape_menu = 1 And KeyboardReleased(#PB_Key_N)
    escape_menu = 0
    ReleaseMouse(0)
  EndIf
  
  If escape_menu = 1 And KeyboardReleased(#PB_Key_Y)
    ReleaseMouse(1)
    shutdown_game()
  EndIf
EndProcedure

Procedure.f vertexAO(side1, side2, corner)
  If isBlockSolid(side1) = 1 And isBlockSolid(side2) = 1
    ProcedureReturn 0.25
  EndIf
  ProcedureReturn (3 - (isBlockSolid(side1) + isBlockSolid(side2) + isBlockSolid(corner)))/4.0*0.75+0.25
EndProcedure

Procedure drawChunk(chunk_x, chunk_z, shadowed.l)
  DisableDebugger
  If display_list_buffer_a(chunk_x,chunk_z) = 0 And display_list_buffer_b(chunk_x,chunk_z) = 0
    
    data_size = 0
    For z = chunk_z*8 To chunk_z*8+7
      For x = chunk_x*8 To chunk_x*8+7
        For y = 0 To 63
          If Not blocks(x,y,z) = $FFFFFFFF
            If getBlockSafe(x,y,z+1) = $FFFFFFFF
              data_size + 72
            EndIf
            If getBlockSafe(x,y,z-1) = $FFFFFFFF
              data_size + 72
            EndIf
            If getBlockSafe(x,y-1,z) = $FFFFFFFF
              data_size + 72
            EndIf
            If getBlockSafe(x+1,y,z) = $FFFFFFFF
              data_size + 72
            EndIf
            If getBlockSafe(x-1,y,z) = $FFFFFFFF
              data_size + 72
            EndIf
            If getBlockSafe(x,y+1,z) = $FFFFFFFF
              data_size + 72
            EndIf
          EndIf
      	Next
      Next
    Next
    
    chunk_buffer = AllocateMemory(data_size+16*1024)
    chunk_buffer_start = chunk_buffer
    color_buffer = AllocateMemory(data_size+16*1024)
    color_buffer_start = color_buffer
    texture_buffer = AllocateMemory(data_size/3*2+16*1024)
    texture_buffer_start = texture_buffer
    display_list_buffer_a(chunk_x,chunk_z) = chunk_buffer_start
    display_list_buffer_b(chunk_x,chunk_z) = color_buffer_start
    display_list_buffer_c(chunk_x,chunk_z) = texture_buffer_start
  Else
    chunk_buffer_start = display_list_buffer_a(chunk_x,chunk_z)
    color_buffer_start = display_list_buffer_b(chunk_x,chunk_z)
    texture_buffer_start = display_list_buffer_c(chunk_x,chunk_z)
    chunk_buffer = chunk_buffer_start
    color_buffer = color_buffer_start
    texture_buffer = texture_buffer_start
  EndIf

  StartDrawing(ImageOutput(map_image))
  triangle_count = 0
  For z = chunk_z*8 To chunk_z*8+7
          For x = chunk_x*8 To chunk_x*8+7
            For y = 0 To 63
              j = blocks(x,y,z)
              If Not j = $FFFFFFFF
                red.f = Red(j)/255.0
                green.f = Green(j)/255.0
                blue.f = Blue(j)/255.0
                Plot(x,z,j)
                g.f = blockAboveForShadow(x,y+1,z)
                shadow.f = 1.0
                If Not g = -1
                  shadow.f = g/64.0*0.5+0.5
                EndIf
                shadow.f = 1.0
                If shadowed = 1
                  shadow = 0.5
                EndIf
                offset_a.f = 1.0;Sin(x*0.3927)*0.25-0.5
                offset_b.f = 1.0;Sin((x+1)*0.3927)*0.25-0.5
                If getBlockSafe(x,y,z+1) = $FFFFFFFF
                  light_a.f = vertexAO(getBlockSafe(x+1,y,z+1),getBlockSafe(x,y+1,z+1),getBlockSafe(x+1,y+1,z+1))*shadow
                  light_b.f = vertexAO(getBlockSafe(x-1,y,z+1),getBlockSafe(x,y-1,z+1),getBlockSafe(x-1,y-1,z+1))*shadow
                  light_c.f = vertexAO(getBlockSafe(x+1,y,z+1),getBlockSafe(x,y-1,z+1),getBlockSafe(x+1,y-1,z+1))*shadow
                  light_d.f = vertexAO(getBlockSafe(x-1,y,z+1),getBlockSafe(x,y+1,z+1),getBlockSafe(x-1,y+1,z+1))*shadow
                  
                  If light_b + light_a > light_d + light_c
                    ;generate flipped quad
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,0.0+x,1.0+y+offset_a,1.0+z)
                    texture_buffer = writeTextureToBuffer(texture_buffer,0.0,1.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,0.0+x,0.0+y+offset_a,1.0+z)
                    texture_buffer = writeTextureToBuffer(texture_buffer,0.0,0.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,1.0+x,1.0+y+offset_b,1.0+z)
                    texture_buffer = writeTextureToBuffer(texture_buffer,1.0,1.0)
                    
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,0.0+x,0.0+y+offset_a,1.0+z)
                    texture_buffer = writeTextureToBuffer(texture_buffer,0.0,0.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,1.0+x,0.0+y+offset_b,1.0+z)
                    texture_buffer = writeTextureToBuffer(texture_buffer,1.0,0.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,1.0+x,1.0+y+offset_b,1.0+z)
                    texture_buffer = writeTextureToBuffer(texture_buffer,1.0,1.0)
                    
                    color_buffer = writeColorToBuffer(color_buffer,red*light_d*0.7,green*light_d*0.7,blue*light_d*0.7)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_b*0.7,green*light_b*0.7,blue*light_b*0.7)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_a*0.7,green*light_a*0.7,blue*light_a*0.7)
                    
                    color_buffer = writeColorToBuffer(color_buffer,red*light_b*0.7,green*light_b*0.7,blue*light_b*0.7)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_c*0.7,green*light_c*0.7,blue*light_c*0.7)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_a*0.7,green*light_a*0.7,blue*light_a*0.7)
                  Else
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,1.0+x,1.0+y+offset_b,1.0+z)
                    texture_buffer = writeTextureToBuffer(texture_buffer,1.0,1.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,0.0+x,1.0+y+offset_a,1.0+z)
                    texture_buffer = writeTextureToBuffer(texture_buffer,0.0,1.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,1.0+x,0.0+y+offset_b,1.0+z)
                    texture_buffer = writeTextureToBuffer(texture_buffer,1.0,0.0)
                    
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,0.0+x,1.0+y+offset_a,1.0+z)
                    texture_buffer = writeTextureToBuffer(texture_buffer,0.0,1.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,0.0+x,0.0+y+offset_a,1.0+z)
                    texture_buffer = writeTextureToBuffer(texture_buffer,0.0,0.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,1.0+x,0.0+y+offset_b,1.0+z)
                    texture_buffer = writeTextureToBuffer(texture_buffer,1.0,0.0)
                    
                    color_buffer = writeColorToBuffer(color_buffer,red*light_a*0.7,green*light_a*0.7,blue*light_a*0.7)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_d*0.7,green*light_d*0.7,blue*light_d*0.7)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_c*0.7,green*light_c*0.7,blue*light_c*0.7)
                    
                    color_buffer = writeColorToBuffer(color_buffer,red*light_d*0.7,green*light_d*0.7,blue*light_d*0.7)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_b*0.7,green*light_b*0.7,blue*light_b*0.7)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_c*0.7,green*light_c*0.7,blue*light_c*0.7)
                  EndIf
                  triangle_count + 6
                EndIf
                If getBlockSafe(x,y,z-1) = $FFFFFFFF
                  light_a.f = vertexAO(getBlockSafe(x+1,y,z-1),getBlockSafe(x,y+1,z-1),getBlockSafe(x+1,y+1,z-1))*shadow
                  light_b.f = vertexAO(getBlockSafe(x-1,y,z-1),getBlockSafe(x,y-1,z-1),getBlockSafe(x-1,y-1,z-1))*shadow
                  light_c.f = vertexAO(getBlockSafe(x+1,y,z-1),getBlockSafe(x,y-1,z-1),getBlockSafe(x+1,y-1,z-1))*shadow
                  light_d.f = vertexAO(getBlockSafe(x-1,y,z-1),getBlockSafe(x,y+1,z-1),getBlockSafe(x-1,y+1,z-1))*shadow
                  
                  If light_b + light_a > light_d + light_c
                    ;generate flipped quad
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,1.0+x,0.0+y+offset_b,0.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,1.0,0.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,0.0+x,0.0+y+offset_a,0.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,0.0,0.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,1.0+x,1.0+y+offset_b,0.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,1.0,1.0)
                    
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,0.0+x,0.0+y+offset_b,0.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,0.0,0.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,0.0+x,1.0+y+offset_b,0.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,0.0,1.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,1.0+x,1.0+y+offset_a,0.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,1.0,1.0)
                    
                    color_buffer = writeColorToBuffer(color_buffer,red*light_c*0.7,green*light_c*0.7,blue*light_c*0.7)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_b*0.7,green*light_b*0.7,blue*light_b*0.7)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_a*0.7,green*light_a*0.7,blue*light_a*0.7)
                    
                    color_buffer = writeColorToBuffer(color_buffer,red*light_b*0.7,green*light_b*0.7,blue*light_b*0.7)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_d*0.7,green*light_d*0.7,blue*light_d*0.7)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_a*0.7,green*light_a*0.7,blue*light_a*0.7)
                  Else
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,0.0+x,0.0+y+offset_a,0.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,0.0,0.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,0.0+x,1.0+y+offset_a,0.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,0.0,1.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,1.0+x,0.0+y+offset_b,0.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,1.0,0.0)
                    
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,0.0+x,1.0+y+offset_a,0.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,0.0,1.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,1.0+x,1.0+y+offset_b,0.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,1.0,1.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,1.0+x,0.0+y+offset_b,0.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,1.0,0.0)
                    
                    color_buffer = writeColorToBuffer(color_buffer,red*light_b*0.7,green*light_b*0.7,blue*light_b*0.7)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_d*0.7,green*light_d*0.7,blue*light_d*0.7)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_c*0.7,green*light_c*0.7,blue*light_c*0.7)
                    
                    color_buffer = writeColorToBuffer(color_buffer,red*light_d*0.7,green*light_d*0.7,blue*light_d*0.7)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_a*0.7,green*light_a*0.7,blue*light_a*0.7)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_c*0.7,green*light_c*0.7,blue*light_c*0.7)
                  EndIf
                  triangle_count + 6
                EndIf
                If getBlockSafe(x,y-1,z) = $FFFFFFFF
                  light_a.f = vertexAO(getBlockSafe(x+1,y-1,z),getBlockSafe(x,y-1,z+1),getBlockSafe(x+1,y-1,z+1))*shadow
                  light_b.f = vertexAO(getBlockSafe(x-1,y-1,z),getBlockSafe(x,y-1,z-1),getBlockSafe(x-1,y-1,z-1))*shadow
                  light_c.f = vertexAO(getBlockSafe(x+1,y-1,z),getBlockSafe(x,y-1,z-1),getBlockSafe(x+1,y-1,z-1))*shadow
                  light_d.f = vertexAO(getBlockSafe(x-1,y-1,z),getBlockSafe(x,y-1,z+1),getBlockSafe(x-1,y-1,z+1))*shadow
                  
                  If light_b + light_a > light_d + light_c
                    ;generate flipped quad
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,1.0+x,0.0+y+offset_b,0.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,1.0,0.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,1.0+x,0.0+y+offset_b,1.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,1.0,1.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,0.0+x,0.0+y+offset_a,0.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,0.0,0.0)
                    
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,1.0+x,0.0+y+offset_b,1.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,1.0,1.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,0.0+x,0.0+y+offset_a,1.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,0.0,1.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,0.0+x,0.0+y+offset_a,0.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,0.0,0.0)
                    
                    color_buffer = writeColorToBuffer(color_buffer,red*light_c*0.5,green*light_c*0.5,blue*light_c*0.5)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_a*0.5,green*light_a*0.5,blue*light_a*0.5)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_b*0.5,green*light_b*0.5,blue*light_b*0.5)
                    
                    color_buffer = writeColorToBuffer(color_buffer,red*light_a*0.5,green*light_a*0.5,blue*light_a*0.5)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_d*0.5,green*light_d*0.5,blue*light_d*0.5)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_b*0.5,green*light_b*0.5,blue*light_b*0.5)
                    
                  Else
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,0.0+x,0.0+y+offset_a,0.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,0.0,0.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,1.0+x,0.0+y+offset_b,0.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,1.0,0.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,0.0+x,0.0+y+offset_a,1.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,0.0,1.0)
                    
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,1.0+x,0.0+y+offset_b,0.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,1.0,0.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,1.0+x,0.0+y+offset_b,1.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,1.0,1.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,0.0+x,0.0+y+offset_a,1.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,0.0,1.0)
                    
                    color_buffer = writeColorToBuffer(color_buffer,red*light_b*0.5,green*light_b*0.5,blue*light_b*0.5)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_c*0.5,green*light_c*0.5,blue*light_c*0.5)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_d*0.5,green*light_d*0.5,blue*light_d*0.5)
                    
                    color_buffer = writeColorToBuffer(color_buffer,red*light_c*0.5,green*light_c*0.5,blue*light_c*0.5)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_a*0.5,green*light_a*0.5,blue*light_a*0.5)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_d*0.5,green*light_d*0.5,blue*light_d*0.5)
                  EndIf
                  triangle_count + 6
                EndIf
                If getBlockSafe(x+1,y,z) = $FFFFFFFF
                  light_a.f = vertexAO(getBlockSafe(x+1,y+1,z),getBlockSafe(x+1,y,z+1),getBlockSafe(x+1,y+1,z+1))*shadow
                  light_b.f = vertexAO(getBlockSafe(x+1,y-1,z),getBlockSafe(x+1,y,z-1),getBlockSafe(x+1,y-1,z-1))*shadow
                  light_c.f = vertexAO(getBlockSafe(x+1,y+1,z),getBlockSafe(x+1,y,z-1),getBlockSafe(x+1,y+1,z-1))*shadow
                  light_d.f = vertexAO(getBlockSafe(x+1,y-1,z),getBlockSafe(x+1,y,z+1),getBlockSafe(x+1,y-1,z+1))*shadow
                  
                  If light_b + light_a > light_d + light_c
                    ;generate flipped quad
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,1.0+x,0.0+y+offset_b,1.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,0.0,1.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,1.0+x,0.0+y+offset_b,0.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,0.0,0.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,1.0+x,1.0+y+offset_b,1.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,1.0,1.0)
                    
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,1.0+x,0.0+y+offset_b,0.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,0.0,0.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,1.0+x,1.0+y+offset_b,0.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,1.0,0.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,1.0+x,1.0+y+offset_b,1.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,1.0,1.0)
                    
                    color_buffer = writeColorToBuffer(color_buffer,red*light_d*0.9,green*light_d*0.9,blue*light_d*0.9)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_b*0.9,green*light_b*0.9,blue*light_b*0.9)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_a*0.9,green*light_a*0.9,blue*light_a*0.9)

                    color_buffer = writeColorToBuffer(color_buffer,red*light_b*0.9,green*light_b*0.9,blue*light_b*0.9)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_c*0.9,green*light_c*0.9,blue*light_c*0.9)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_a*0.9,green*light_a*0.9,blue*light_a*0.9)
                  Else
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,1.0+x,1.0+y+offset_b,1.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,1.0,1.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,1.0+x,0.0+y+offset_b,1.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,0.0,1.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,1.0+x,1.0+y+offset_b,0.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,1.0,0.0)
                    
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,1.0+x,0.0+y+offset_b,1.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,0.0,1.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,1.0+x,0.0+y+offset_b,0.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,0.0,0.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,1.0+x,1.0+y+offset_b,0.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,1.0,0.0)
                    
                    color_buffer = writeColorToBuffer(color_buffer,red*light_a*0.9,green*light_a*0.9,blue*light_a*0.9)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_d*0.9,green*light_d*0.9,blue*light_d*0.9)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_c*0.9,green*light_c*0.9,blue*light_c*0.9)
                    
                    color_buffer = writeColorToBuffer(color_buffer,red*light_d*0.9,green*light_d*0.9,blue*light_d*0.9)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_b*0.9,green*light_b*0.9,blue*light_b*0.9)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_c*0.9,green*light_c*0.9,blue*light_c*0.9)
                  EndIf
                  triangle_count + 6
                EndIf
                If getBlockSafe(x-1,y,z) = $FFFFFFFF
                  light_a.f = vertexAO(getBlockSafe(x-1,y+1,z),getBlockSafe(x-1,y,z+1),getBlockSafe(x-1,y+1,z+1))*shadow
                  light_b.f = vertexAO(getBlockSafe(x-1,y-1,z),getBlockSafe(x-1,y,z-1),getBlockSafe(x-1,y-1,z-1))*shadow
                  light_c.f = vertexAO(getBlockSafe(x-1,y+1,z),getBlockSafe(x-1,y,z-1),getBlockSafe(x-1,y+1,z-1))*shadow
                  light_d.f = vertexAO(getBlockSafe(x-1,y-1,z),getBlockSafe(x-1,y,z+1),getBlockSafe(x-1,y-1,z+1))*shadow
                  
                  If light_b + light_a > light_d + light_c
                    ;generate flipped quad
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,0.0+x,1.0+y+offset_a,0.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,1.0,0.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,0.0+x,0.0+y+offset_a,0.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,0.0,0.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,0.0+x,1.0+y+offset_a,1.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,1.0,1.0)
                    
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,0.0+x,0.0+y+offset_a,0.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,0.0,0.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,0.0+x,0.0+y+offset_a,1.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,0.0,1.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,0.0+x,1.0+y+offset_a,1.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,1.0,1.0)
                    
                    color_buffer = writeColorToBuffer(color_buffer,red*light_c*0.9,green*light_c*0.9,blue*light_c*0.9)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_b*0.9,green*light_b*0.9,blue*light_b*0.9)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_a*0.9,green*light_a*0.9,blue*light_a*0.9)
                    
                    color_buffer = writeColorToBuffer(color_buffer,red*light_b*0.9,green*light_b*0.9,blue*light_b*0.9)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_d*0.9,green*light_d*0.9,blue*light_d*0.9)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_a*0.9,green*light_a*0.9,blue*light_a*0.9)
                  Else
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,0.0+x,0.0+y+offset_a,0.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,0.0,0.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,0.0+x,0.0+y+offset_a,1.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,0.0,1.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,0.0+x,1.0+y+offset_a,0.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,1.0,0.0)
                    
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,0.0+x,0.0+y+offset_a,1.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,0.0,1.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,0.0+x,1.0+y+offset_a,1.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,1.0,1.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,0.0+x,1.0+y+offset_a,0.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,1.0,0.0)
                    
                    color_buffer = writeColorToBuffer(color_buffer,red*light_b*0.9,green*light_b*0.9,blue*light_b*0.9)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_d*0.9,green*light_d*0.9,blue*light_d*0.9)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_c*0.9,green*light_c*0.9,blue*light_c*0.9)
                    
                    color_buffer = writeColorToBuffer(color_buffer,red*light_d*0.9,green*light_d*0.9,blue*light_d*0.9)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_a*0.9,green*light_a*0.9,blue*light_a*0.9)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_c*0.9,green*light_c*0.9,blue*light_c*0.9)
                  EndIf
                  triangle_count + 6
                EndIf
                If getBlockSafe(x,y+1,z) = $FFFFFFFF
                  light_a.f = vertexAO(getBlockSafe(x+1,y+1,z),getBlockSafe(x,y+1,z+1),getBlockSafe(x+1,y+1,z+1))
                  light_b.f = vertexAO(getBlockSafe(x-1,y+1,z),getBlockSafe(x,y+1,z-1),getBlockSafe(x-1,y+1,z-1))
                  light_c.f = vertexAO(getBlockSafe(x+1,y+1,z),getBlockSafe(x,y+1,z-1),getBlockSafe(x+1,y+1,z-1))
                  light_d.f = vertexAO(getBlockSafe(x-1,y+1,z),getBlockSafe(x,y+1,z+1),getBlockSafe(x-1,y+1,z+1))
                  
                  If light_b + light_a > light_d + light_c
                    ;generate flipped quad
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,0.0+x,1.0+y+offset_a,1.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,0.0,1.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,1.0+x,1.0+y+offset_b,1.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,1.0,1.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,0.0+x,1.0+y+offset_a,0.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,0.0,0.0)
                    
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,1.0+x,1.0+y+offset_b,1.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,1.0,1.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,1.0+x,1.0+y+offset_b,0.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,1.0,0.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,0.0+x,1.0+y+offset_a,0.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,0.0,0.0)
                    
                    color_buffer = writeColorToBuffer(color_buffer,red*light_d*shadow,green*light_d*shadow,blue*light_d*shadow)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_a*shadow,green*light_a*shadow,blue*light_a*shadow)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_b*shadow,green*light_b*shadow,blue*light_b*shadow)
                    
                    color_buffer = writeColorToBuffer(color_buffer,red*light_a*shadow,green*light_a*shadow,blue*light_a*shadow)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_c*shadow,green*light_c*shadow,blue*light_c*shadow)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_b*shadow,green*light_b*shadow,blue*light_b*shadow)
                  Else
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,1.0+x,1.0+y+offset_b,1.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,1.0,1.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,1.0+x,1.0+y+offset_b,0.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,1.0,0.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,0.0+x,1.0+y+offset_a,1.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,0.0,1.0)
                    
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,1.0+x,1.0+y+offset_b,0.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,1.0,0.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,0.0+x,1.0+y+offset_a,0.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,0.0,0.0)
                    chunk_buffer = writeVertexToBuffer(chunk_buffer,0.0+x,1.0+y+offset_a,1.0+z) : texture_buffer = writeTextureToBuffer(texture_buffer,0.0,1.0)
                    
                    color_buffer = writeColorToBuffer(color_buffer,red*light_a*shadow,green*light_a*shadow,blue*light_a*shadow)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_c*shadow,green*light_c*shadow,blue*light_c*shadow)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_d*shadow,green*light_d*shadow,blue*light_d*shadow)
                    
                    color_buffer = writeColorToBuffer(color_buffer,red*light_c*shadow,green*light_c*shadow,blue*light_c*shadow)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_b*shadow,green*light_b*shadow,blue*light_b*shadow)
                    color_buffer = writeColorToBuffer(color_buffer,red*light_d*shadow,green*light_d*shadow,blue*light_d*shadow)
                  EndIf
                  triangle_count + 6
                EndIf
              EndIf
      	  	Next
      	  Next
      	Next
      	StopDrawing()
      	glColorPointer_(3,#GL_FLOAT,0,color_buffer_start)
      	glVertexPointer_(3,#GL_FLOAT,0,chunk_buffer_start)
      	glTexCoordPointer_(2,#GL_FLOAT,0,texture_buffer_start)
      	glDrawArrays_(#GL_TRIANGLES,0,triangle_count)
      	EnableDebugger
EndProcedure

Procedure renderGrenade(id.l)
  glPushMatrix_()
  glTranslatef_(grenade_x(id),64.0-grenade_y(id)+0.85,grenade_z(id))
  glScalef_(0.25,0.25,0.25)
  glCallList_(kv6_grenade)
  glPopMatrix_()
EndProcedure

Procedure renderplayer(id.l,shadowed.l)
      If player_display_list_created = 0 And Not team_1_base_y = 128.0
        kv6_cp = loadKV6ForTeams("kv6/cp.kv6",RGB(team_1_red,team_1_green,team_1_blue),RGB(team_2_red,team_2_green,team_2_blue))
        kv6_intel = loadKV6ForTeams("kv6/intel.kv6",RGB(team_1_red,team_1_green,team_1_blue),RGB(team_2_red,team_2_green,team_2_blue))
        kv6_playerdead = loadKV6ForTeams("kv6/playerdead.kv6",RGB(team_1_red,team_1_green,team_1_blue),RGB(team_2_red,team_2_green,team_2_blue))
        player_display_list_created = 1
      EndIf
  
      If teamlist(id) = 0
        glColor3f(team_1_red/255.0,team_1_green/255.0,team_1_blue/255.0)
      EndIf
      If teamlist(id) = 1
        glColor3f(team_2_red/255.0,team_2_green/255.0,team_2_blue/255.0)
      EndIf
      glPushMatrix_()
      glTranslatef_(getPlayerX(id)-1.0*0.12,getPlayerY(id)+0.5,getPlayerZ(id)+1.0*0.12)
      
      
      If player_dead(id) = 1
        y.f = getPlayerY(id)
        offset_y.f = 0.0
        Repeat
          y - 0.5
          offset_y - 0.5
        Until y<1.0 Or isBlockSolid(getBlockSafe(getPlayerX(id),y,getPlayerZ(id))) = 1
        If ElapsedMilliseconds()-player_death_time(id) < (offset_y+0.5)*250
          glTranslatef_(0.0,(offset_y)*(ElapsedMilliseconds()-player_death_time(id))/(offset_y+0.5)*250.0,0.0)
        Else
          glTranslatef_(0.0,offset_y,0.0)
        EndIf
        glScalef_(0.5,0.5,0.5)
        glRotatef_(-Degree(ATan2(getPlayerAngleX(id),getPlayerAngleZ(id))),0.0,1.0,0.0)
        glTranslatef_(0.5,0.0,0.5)
        glCallList_(kv6_playerdead+teamlist(id))
        glPopMatrix_()
        ProcedureReturn
      EndIf

      glPushMatrix_()
      glTranslatef_(1.0*0.12,-9.0*0.12,-1.0*0.12)
      glRotatef_(-Degree(ATan2(getPlayerAngleX(id),getPlayerAngleZ(id))),0.0,1.0,0.0)
      If Not id = own_player_id
        glBegin_(#GL_QUADS)
        rendercubeat(-2.0*0.12,0.0,-4.0*0.12,4.0*0.12,9.0*0.12,8.0*0.12) ;torso
        glEnd_()
      EndIf
      glPopMatrix_()
      
      If teamlist(id) = 0
        glColor3f(team_1_red/255.0,team_1_green/255.0,team_1_blue/255.0)
      EndIf
      If teamlist(id) = 1
        glColor3f(team_2_red/255.0,team_2_green/255.0,team_2_blue/255.0)
      EndIf
      
      glPushMatrix_()
      glTranslatef_(1.0*0.12,-9.0*0.12,-1.0*0.12)
      glRotatef_(-Degree(ATan2(getPlayerAngleX(id),getPlayerAngleZ(id))),0.0,1.0,0.0)
      glTranslatef_(-0.9*0.12,0.0,-4.25*0.12)
      If isMoving(id)
        glRotatef_(Sin(ElapsedMilliseconds()*0.005)*25.0,0.0,0.0,1.0)
      EndIf
      If Not id = own_player_id And shadowed = 0
        glBegin_(#GL_QUADS)
        rendercubeat(-0.5*0.12,-8.0*0.12,0.75*0.12,3.0*0.12,9.0*0.12,3.0*0.12) ;leg left
        glColor3f(0.22,0.16,0.11)
        rendercubeat(-0.5*0.12,-11.0*0.12,0.75*0.12,5.0*0.12,3.0*0.12,3.0*0.12) ;boot left
        glEnd_()
      EndIf
      glPopMatrix_()
      
      If teamlist(id) = 0
        glColor3f(team_1_red/255.0,team_1_green/255.0,team_1_blue/255.0)
      EndIf
      If teamlist(id) = 1
        glColor3f(team_2_red/255.0,team_2_green/255.0,team_2_blue/255.0)
      EndIf
      
      glPushMatrix_()
      glTranslatef_(1.0*0.12,-9.0*0.12,-1.0*0.12)
      glRotatef_(-Degree(ATan2(getPlayerAngleX(id),getPlayerAngleZ(id))),0.0,1.0,0.0)
      glTranslatef_(-0.9*0.12,0.0,-4.25*0.12)
      If isMoving(id)
        glRotatef_(Sin(-ElapsedMilliseconds()*0.005)*25.0,0.0,0.0,1.0)
      EndIf
      If Not id = own_player_id And shadowed = 0
        glBegin_(#GL_QUADS)
        rendercubeat(-0.5*0.12,-8.0*0.12,4.75*0.12,3.0*0.12,9.0*0.12,3.0*0.12) ;leg right
        glColor3f(0.22,0.16,0.11)
        rendercubeat(-0.5*0.12,-11.0*0.12,4.75*0.12,5.0*0.12,3.0*0.12,3.0*0.12) ;boot right
        glEnd_()
      EndIf
      glPopMatrix_()
      
      glPushMatrix_()
      glTranslatef_(1.0*0.12,0.0*0.12,-1.0*0.12)
      offset.f = 0.0
      If ElapsedMilliseconds()-player_dig_anim_start(id)<#PLAYER_SPADE_TIME*player_dig_anim_speed(id)
        offset = 45.0*(ElapsedMilliseconds()-player_dig_anim_start(id))/(#PLAYER_SPADE_TIME*player_dig_anim_speed(id))
      EndIf
      If ElapsedMilliseconds()-player_dig_anim_start(id)>=#PLAYER_SPADE_TIME*player_dig_anim_speed(id) And ElapsedMilliseconds()-player_dig_anim_start(id)<#PLAYER_SPADE_TIME*2*player_dig_anim_speed(id)
        offset = 45.0-45.0*(ElapsedMilliseconds()-player_dig_anim_start(id)-#PLAYER_SPADE_TIME*player_dig_anim_speed(id))/(#PLAYER_SPADE_TIME*player_dig_anim_speed(id))
      EndIf
      glRotatef_(-Degree(ATan2(getPlayerAngleX(id),getPlayerAngleZ(id))),0.0,1.0,0.0)
      glPushMatrix_()
      glRotatef_(-(Degree(ACos(getPlayerAngleY(id)/Sqr(getPlayerAngleX(id)*getPlayerAngleX(id)+getPlayerAngleY(id)*getPlayerAngleY(id)+getPlayerAngleZ(id)*getPlayerAngleZ(id))))-90.0),0.0,0.0,1.0)
      If Not id = own_player_id And shadowed = 0
        glBegin_(#GL_QUADS)
        glColor3f(0.99,0.75,0.5)
        rendercubeat(-3.0*0.12,0.0,-3.0*0.12,6.0*0.12,6.0*0.12,6.0*0.12) ;head
        glColor3f(0.03125,0.03125,0.03125)
        rendercubeat(0.25*0.12,-0.125*0.12,-3.125*0.12,1.0*0.12,3.125*0.12,6.25*0.12) ;helmet (string)
        rendercubeat(2.125*0.12,2.0*0.12,1.0*0.12,1.0*0.12,1.0*0.12,1.0*0.12) ;eye left
        rendercubeat(2.125*0.12,2.0*0.12,-2.0*0.12,1.0*0.12,1.0*0.12,1.0*0.12) ;eye right
        If teamlist(id) = 0
          glColor3f(team_1_red/255.0,team_1_green/255.0,team_1_blue/255.0)
        EndIf
        If teamlist(id) = 1
          glColor3f(team_2_red/255.0,team_2_green/255.0,team_2_blue/255.0)
        EndIf
        rendercubeat(-3.25*0.12,3.0*0.12,-3.25*0.12,6.5*0.12,3.25*0.12,6.5*0.12) ;helmet (top)
        rendercubeat(-3.25*0.12,2.0*0.12,-3.25*0.12,3.5*0.12,1.0*0.12,6.5*0.12) ;helmet (bottom)
        glEnd_()
      EndIf
      glPopMatrix_()
      glRotatef_(-(Degree(ACos(getPlayerAngleY(id)/Sqr(getPlayerAngleX(id)*getPlayerAngleX(id)+getPlayerAngleY(id)*getPlayerAngleY(id)+getPlayerAngleZ(id)*getPlayerAngleZ(id))))-90.0)-offset,0.0,0.0,1.0)
      
      glRotatef_(-45.0,0.0,0.0,1.0)
      glBegin_(#GL_QUADS)
      rendercubeat(0.5*0.12,-1.5*0.12,4.0*0.12,5.0*0.12,2.0*0.12,2.0*0.12) ;arm left (first part)
      glEnd_()
      glRotatef_(90.0,0.0,0.0,1.0)
      glBegin_(#GL_QUADS)
      rendercubeat(-1.5*0.12,-7.5*0.12,4.0*0.12,4.0*0.12,2.0*0.12,2.0*0.12) ;arm left (second part)
      glColor3f(0.99,0.75,0.5)
      rendercubeat(2.5*0.12,-7.5*0.12,4.0*0.12,2.0*0.12,2.0*0.12,2.0*0.12) ;arm left (hand)
      glEnd_()
      glRotatef_(-45.0,0.0,0.0,1.0)
      
      If teamlist(id) = 0
        glColor3f(team_1_red/255.0,team_1_green/255.0,team_1_blue/255.0)
      EndIf
      If teamlist(id) = 1
        glColor3f(team_2_red/255.0,team_2_green/255.0,team_2_blue/255.0)
      EndIf
      
      glRotatef_(-45.0,0.0,1.0,0.0)
      glBegin_(#GL_QUADS)
      rendercubeat(-4.0*0.12,-2.5*0.12,-4.5*0.12,11.0*0.12,2.0*0.12,2.0*0.12) ;arm right
      glColor3f(0.99,0.75,0.5)
      rendercubeat(7.0*0.12,-2.5*0.12,-4.5*0.12,2.0*0.12,2.0*0.12,2.0*0.12) ;arm right (hand)
      glEnd_()
      glRotatef_(45.0,0.0,1.0,0.0)
      
      If player_item(id) = 0
        glRotatef_(90.0,0.0,1.0,0.0)
        glTranslatef_(-0.7,-1.2,0.9)
        glScalef_(0.25,0.25,0.25)
        glCallList_(kv6_spade)
      EndIf
      If player_item(id) = 1
        glColor3f(player_block_color_red(id)/255.0,player_block_color_green(id)/255.0,player_block_color_blue(id)/255.0)
        glBegin_(#GL_QUADS)
        rendercubeat(8.0*0.08,-6.5*0.08,0.0*0.08,8.0*0.08,8.0*0.08,8.0*0.08)
        glEnd_()
      EndIf
      If player_item(id) = 2
        glRotatef_(90.0,0.0,1.0,0.0)
        If weaponlist(id) = 0
          glTranslatef_(-0.6,-0.35,0.25)
          glScalef_(0.25,0.25,0.25)
          glCallList_(kv6_semi)
        EndIf
        If weaponlist(id) = 1
          glTranslatef_(-0.6,-0.58,0.25)
          glScalef_(0.25,0.25,0.25)
          glCallList_(kv6_smg)
        EndIf
         If weaponlist(id) = 2
          glTranslatef_(-0.6,-0.35,0.25)
          glScalef_(0.25,0.25,0.25)
          glCallList_(kv6_shotgun)
        EndIf
      EndIf
      If player_item(id) = 3
        glRotatef_(90.0,0.0,1.0,0.0)
        glTranslatef_(-0.7,-0.5,0.7)
        glScalef_(0.25,0.25,0.25)
        glCallList_(kv6_grenade)
      EndIf
      glPopMatrix_()

      glPopMatrix_()
EndProcedure


Procedure.f shadowFix(x.f)
  texelsize.f = 1.0/1024.0
  ProcedureReturn Round(x/10.0,#PB_Round_Nearest)*10.0
EndProcedure

Global depth_texture.l = -1
Declare drawScene(dt.f,shadowed.l)
Global cameraProjectionMatrix.l = AllocateMemory(16*4)
Global lightProjectionMatrix.l = AllocateMemory(16*4)
Global cameraViewMatrix.l = AllocateMemory(16*4)
Global lightViewMatrix.l = AllocateMemory(16*4)
Global biasMatrix.l = createMatrix(0.5, 0.0, 0.0, 0.0, 0.0, 0.5, 0.0, 0.0, 0.0, 0.0, 0.5, 0.0, 0.5, 0.5, 0.5, 1.0)
Global textureMatrix.l = AllocateMemory(16*4)
Global vector_a.l = createVector(0.0,0.0,0.0,0.0)
Global vector_b.l = createVector(0.0,0.0,0.0,0.0)
Global vector_c.l = createVector(0.0,0.0,0.0,0.0)
Global vector_d.l = createVector(0.0,0.0,0.0,0.0)
Procedure updateEngineWindow(event, dt.f)
  updatemouse(event)
  updatekeyboard(event)
  
  If fullscreen = 1
    screen_width = ScreenWidth()
    screen_height = ScreenHeight()
  Else
    screen_width = WindowWidth(0)
    screen_height = WindowHeight(0)
  EndIf
  
  spectate = 0
  If own_team = -1
    spectate = 1
  EndIf
  
  If Not own_team = -1 And player_dead(own_player_id) = 1
    spectate = 1
    If spectate_stick_to_player = 0
      spectate_stick_to_player = 1
      spectate_player = own_player_id
    EndIf
  EndIf
    
  If spectate = 1 And spectate_stick_to_player = 0
    spectate_player = 0
  EndIf
  
  If mouse_button_1 = 1 Or mouse_button_2 = 1
    If spectate = 1 And spectate_stick_to_player = 0
      spectate_stick_to_player = 1
    EndIf
  EndIf
  
  If mouse_button_1_released = 1 And spectate = 1
    spectate_player + 1
    If spectate_player = 32
      spectate_player = 0
    EndIf
  EndIf
  If mouse_button_2_released = 1 And spectate = 1
    spectate_player - 1
    If spectate_player = -1
      spectate_player = 31
    EndIf
  EndIf
  
  camera_rot_x + mouse_delta_x*0.005
  camera_rot_y - mouse_delta_y*0.005
    
  If camera_rot_y<0.01
    camera_rot_y = 0.0
  EndIf
  If camera_rot_y>3.1
    camera_rot_y = 3.1
  EndIf
  

  time = ElapsedMilliseconds()
  If spectate = 1
    If key_forward = 1
      camera_x = camera_x+(time-last_physics_update)/100.0*Sin(camera_rot_x)*Sin(camera_rot_y)
      camera_y = camera_y+(time-last_physics_update)/100.0*Cos(camera_rot_y)
      camera_z = camera_z+(time-last_physics_update)/100.0*Cos(camera_rot_x)*Sin(camera_rot_y)
    EndIf
    If key_backward = 1
      camera_x = camera_x-(time-last_physics_update)/100.0*Sin(camera_rot_x)*Sin(camera_rot_y)
      camera_y = camera_y-(time-last_physics_update)/100.0*Cos(camera_rot_y)
      camera_z = camera_z-(time-last_physics_update)/100.0*Cos(camera_rot_x)*Sin(camera_rot_y)
    EndIf
    If key_left = 1
      camera_x = camera_x+(time-last_physics_update)/100.0*Sin(camera_rot_x+1.57075)*Sin(camera_rot_y)
      camera_z = camera_z+(time-last_physics_update)/100.0*Cos(camera_rot_x+1.57075)*Sin(camera_rot_y)
    EndIf
    If key_right = 1
      camera_x = camera_x+(time-last_physics_update)/100.0*Sin(camera_rot_x-1.57075)*Sin(camera_rot_y)
      camera_z = camera_z+(time-last_physics_update)/100.0*Cos(camera_rot_x-1.57075)*Sin(camera_rot_y)
    EndIf
    If key_space = 1
      camera_y = camera_y+(time-last_physics_update)/100.0
    EndIf
    If key_shift = 1
      camera_y = camera_y-(time-last_physics_update)/100.0
    EndIf
  EndIf
  
  last_physics_update = ElapsedMilliseconds()
  
  ;SwapBuffers_(hdc)
  FlipBuffers()
  
  If fullscreen_mode = 1
    glViewport_(0, 0, ScreenWidth(), ScreenHeight())
  Else
    If GetWindowState(0) = #PB_Window_Normal
      ResizeWindow(0,#PB_Ignore,#PB_Ignore,#PB_Ignore,WindowWidth(0)/16.0*9.0)
    EndIf
    glViewport_(0, 0, WindowWidth(0), WindowHeight(0))
  EndIf
  glMatrixMode_(#GL_PROJECTION)
  glLoadIdentity_()
  gluPerspective_(80.0, engineWindowWidth()/engineWindowHeight(), 0.1, 512.0)
  glGetFloatv_(#GL_PROJECTION_MATRIX, cameraProjectionMatrix)
  glMatrixMode_(#GL_MODELVIEW)
  glClear_(#GL_COLOR_BUFFER_BIT | #GL_DEPTH_BUFFER_BIT)
  glClearColor_(map_fog_red/255.0,map_fog_green/255.0,map_fog_blue/255.0,1.0)
  FogColor(0) = map_fog_red/255.0
  FogColor(1) = map_fog_green/255.0
  FogColor(2) = map_fog_blue/255.0
  FogColor(3) = 1.0
  glFogfv_(#GL_FOG_COLOR, FogColor())
  glLoadIdentity_()
  ;glLightfv_(#GL_LIGHT0,#GL_POSITION,LightPos())
  ;glLightfv_(#GL_LIGHT1,#GL_POSITION,LightPos2())
  ;Math.sin(a)*Math.sin(b)
  ;Math.cos(b)
  ;Math.cos(a)*Math.sin(b)
  If spectate = 1
    If spectate_stick_to_player = 1
      For k = 0 To 500
        look_x.f = getPlayerX(spectate_player)+k*0.01*Sin(camera_rot_x)*Sin(camera_rot_y)
        look_y.f = getPlayerY(spectate_player)+k*0.01*Cos(camera_rot_y)
        look_z.f = getPlayerZ(spectate_player)+k*0.01*Cos(camera_rot_x)*Sin(camera_rot_y)
        If Not getBlockSafe(look_x,look_y,look_z) = $FFFFFFFF
          look_x.f = getPlayerX(spectate_player)+(k*0.01)*Sin(camera_rot_x)*Sin(camera_rot_y)
          look_y.f = getPlayerY(spectate_player)+(k*0.01)*Cos(camera_rot_y)
          look_z.f = getPlayerZ(spectate_player)+(k*0.01)*Cos(camera_rot_x)*Sin(camera_rot_y)
          Break
        EndIf
      Next
      update_sounds(look_x.f,look_y.f,look_z.f)
      gluLookAt_(look_x,look_y,look_z,getPlayerX(spectate_player),getPlayerY(spectate_player),getPlayerZ(spectate_player),0.0,1.0,0.0)
      glPushMatrix_()
      glLoadIdentity_()
      gluLookAt_(shadowFix(look_x)+20.0,64.0,shadowFix(look_z+70.0),shadowFix(look_x),0.0,shadowFix(look_z),0.0,1.0,0.0)
      glGetFloatv_(#GL_MODELVIEW_MATRIX, lightViewMatrix)
      glPopMatrix_()
    Else
      look_x.f = camera_x+100.0*Sin(camera_rot_x)*Sin(camera_rot_y)
      look_y.f = camera_y+100.0*Cos(camera_rot_y)
      look_z.f = camera_z+100.0*Cos(camera_rot_x)*Sin(camera_rot_y)
      update_sounds(camera_x,camera_y,camera_z)
      gluLookAt_(camera_x,camera_y,camera_z,look_x,look_y,look_z,0.0,1.0,0.0)
      glPushMatrix_()
      glLoadIdentity_()
      gluLookAt_(shadowFix(camera_x)+20.0,64.0,shadowFix(camera_z)+70.0,shadowFix(camera_x),0.0,shadowFix(camera_z),0.0,1.0,0.0)
      glGetFloatv_(#GL_MODELVIEW_MATRIX, lightViewMatrix)
      glPopMatrix_()
    EndIf
  Else
    look_x.f = player_x(own_player_id)+100.0*Sin(camera_rot_x)*Sin(camera_rot_y)
    look_y.f = player_eye_y(own_player_id)+100.0*Cos(camera_rot_y)
    look_z.f = player_z(own_player_id)+100.0*Cos(camera_rot_x)*Sin(camera_rot_y)
    
    vector_x.f = Sin(camera_rot_x)*Sin(camera_rot_y)
    vector_y.f = Cos(camera_rot_y)
    vector_z.f = Cos(camera_rot_x)*Sin(camera_rot_y)
    
    If own_dead = 0
      positiondata(player_x(own_player_id)+0.5,player_eye_y(own_player_id)-0.4,player_z(own_player_id)+0.5)
      inputdata(key_forward,key_backward,key_left,key_right,key_shift,key_ctrl,key_space)
      If own_item = 0 Or own_item = 1 Or own_item = 3
        weaponinput(mouse_button_1,mouse_button_2)
      EndIf
      If own_item = 2 And player_ammo(own_player_id) > 0
        weaponinput(mouse_button_1,mouse_button_2)
      Else
        If own_item = 2
          weaponinput(0,mouse_button_2)
        EndIf
      EndIf
      orientationdata(vector_x,vector_y,vector_z)
      player_angle_x(own_player_id) = vector_x
      player_angle_y(own_player_id) = vector_y
      player_angle_z(own_player_id) = vector_z
      key_states.l = 0
      If key_forward = 1
        key_states + 1
      EndIf
      If key_backward = 1
        key_states + 2
      EndIf
      If key_left = 1
        key_states + 4
      EndIf
      If key_right = 1
        key_states + 8
      EndIf
      If key_space = 1
        key_states + 16
      EndIf
      If key_ctrl = 1
        key_states + 32
      EndIf
      If key_shift = 1
        key_states + 128
      EndIf
      player_keystates2(own_player_id) = key_states
    EndIf
    gluLookAt_(player_x(own_player_id)+0.5,player_eye_y(own_player_id)+0.75,player_z(own_player_id)+0.5,look_x+0.5,look_y+0.75,look_z+0.5,0.0,1.0,0.0)
    update_sounds(player_x(own_player_id)+0.5,player_eye_y(own_player_id)+0.75,player_z(own_player_id)+0.5)
    glPushMatrix_()
    glLoadIdentity_()
    gluLookAt_(shadowFix(player_x(own_player_id)+0.5+20.0),64.0,shadowFix(player_z(own_player_id)+0.5+70.0),shadowFix(player_x(own_player_id)+0.5),0.0,shadowFix(player_z(own_player_id)+0.5),0.0,1.0,0.0)
    glGetFloatv_(#GL_MODELVIEW_MATRIX, lightViewMatrix)
    glPopMatrix_()
  EndIf
  glGetFloatv_(#GL_MODELVIEW_MATRIX, cameraViewMatrix)
  
  If Not own_player_id = -1
    offset.f = 0.0
    faced_player = -1
    faced_player_part = -1
    faced_block_x = -1
    faced_block_y = -1
    faced_block_z = -1
    build_block_x = -1
    build_block_y = -1
    build_block_z = -1
    object_distance = 0.0
    Repeat
      look_x.f = player_x(own_player_id)+offset*Sin(camera_rot_x)*Sin(camera_rot_y)+0.5
      look_y.f = player_eye_y(own_player_id)+offset*Cos(camera_rot_y)+0.75
      look_z.f = player_z(own_player_id)+offset*Cos(camera_rot_x)*Sin(camera_rot_y)+0.5
      If isBlockSolid(getBlockSafe(Round(look_x,#PB_Round_Down),Round(look_y,#PB_Round_Down),Round(look_z,#PB_Round_Down)))
        faced_block_x = Round(look_x,#PB_Round_Down)
        faced_block_y = Round(look_y,#PB_Round_Down)
        faced_block_z = Round(look_z,#PB_Round_Down)
        look_x = player_x(own_player_id)+(offset-0.2)*Sin(camera_rot_x)*Sin(camera_rot_y)+0.5
        look_y = player_eye_y(own_player_id)+(offset-0.2)*Cos(camera_rot_y)+0.75
        look_z = player_z(own_player_id)+(offset-0.2)*Cos(camera_rot_x)*Sin(camera_rot_y)+0.5
        build_block_x = Round(look_x,#PB_Round_Down)
        build_block_y = Round(look_y,#PB_Round_Down)
        build_block_z = Round(look_z,#PB_Round_Down)
        Break
      EndIf
      For k=0 To 31
        If player_y(k) < 64.0 And teamlist(k) > -1 And Not k = own_player_id
          If Sqr((player_x(k)-look_x)*(player_x(k)-look_x)+(player_y(k)-look_y)*(player_y(k)-look_y)+(player_z(k)-look_z)*(player_z(k)-look_z))<0.5
            faced_player = k
            faced_player_part = 0 ;torso
            Break
          EndIf
          If Sqr((player_x(k)-look_x)*(player_x(k)-look_x)+(player_y(k)+1.0-look_y)*(player_y(k)+1.0-look_y)+(player_z(k)-look_z)*(player_z(k)-look_z))<0.5
            faced_player = k
            faced_player_part = 1 ;head
            Break
          EndIf
          If Sqr((player_x(k)-look_x)*(player_x(k)-look_x)+(player_y(k)-1.0-look_y)*(player_y(k)-1.0-look_y)+(player_z(k)-look_z)*(player_z(k)-look_z))<0.5
            faced_player = k
            faced_player_part = 3 ;legs
            Break
          EndIf
        EndIf
      Next  
      offset + 0.2
    Until offset >= 128.0 Or Not faced_player = -1
    object_distance = offset
    
    If player_item(own_player_id) = 1 And Not build_block_x = -1 And object_distance < 4.0
      glBegin_(#GL_QUADS)
      glColor4f(own_block_red/255.0,own_block_green/255.0,own_block_blue/255.0,0.5)
      rendercubeat(build_block_x,build_block_y,build_block_z,1.0,1.0,1.0)
      glEnd_()
    EndIf
  EndIf
    
  If KeyboardPushed(#PB_Key_B)
    glPushMatrix_()
    glLoadIdentity_()
    ;gluPerspective_(80.0, 1.0, 1.0, 128.0)
    glOrtho_(-64.0,64.0,-64.0,64.0,1.0,128.0)
    glGetFloatv_(#GL_MODELVIEW_MATRIX, lightProjectionMatrix)
    glPopMatrix_()
    
    glLoadIdentity_()
    glClear_(#GL_COLOR_BUFFER_BIT | #GL_DEPTH_BUFFER_BIT)
    glMatrixMode_(#GL_PROJECTION)
    glLoadMatrixf_(lightProjectionMatrix)
    glMatrixMode_(#GL_MODELVIEW)
    glLoadMatrixf_(lightViewMatrix)
    glViewport_(0, 0, 1024, 1024)
    glCullFace_(#GL_FRONT)
    glColorMask_(#GL_FALSE, #GL_FALSE, #GL_FALSE, #GL_FALSE)
    glDisable_(#GL_FOG)
    ;glEnable_(#GL_POLYGON_OFFSET_FILL)
    ;glPolygonOffset_(16.0,1.0)
    drawScene(dt,0)
    ;glDisable_(#GL_POLYGON_OFFSET_FILL)
    
    glEnable_(#GL_TEXTURE_2D)
    tmp = depth_texture
    If tmp = -1
      glGenTextures_(1,@depth_texture)
    EndIf
    glBindTexture_(#GL_TEXTURE_2D, depth_texture)
    If tmp = -1
      texture_data.l = AllocateMemory(1024*1024*4)
      glTexImage2D_(#GL_TEXTURE_2D, 0, #GL_DEPTH_COMPONENT, 1024, 1024, 0, #GL_DEPTH_COMPONENT, #GL_UNSIGNED_BYTE, texture_data)
      glTexParameteri_(#GL_TEXTURE_2D, #GL_TEXTURE_MAG_FILTER, #GL_LINEAR)
      glTexParameteri_(#GL_TEXTURE_2D, #GL_TEXTURE_MIN_FILTER, #GL_LINEAR)
      glTexParameteri_(#GL_TEXTURE_2D, #GL_TEXTURE_WRAP_S, #GL_CLAMP_TO_EDGE)
      glTexParameteri_(#GL_TEXTURE_2D, #GL_TEXTURE_WRAP_T, #GL_CLAMP_TO_EDGE)
    EndIf
    glCopyTexSubImage2D_(#GL_TEXTURE_2D, 0, 0, 0, 0, 0, 1024,1024)
    ;glCopyTexImage2D_(#GL_TEXTURE_2D,0,#GL_DEPTH_COMPONENT,0,0,engineWindowHeight(),engineWindowHeight(),0)
    glBindTexture_(#GL_TEXTURE_2D,0)
    glDisable_(#GL_TEXTURE_2D)
    
    glEnable_(#GL_FOG)
    glCullFace_(#GL_BACK)
    glColorMask_(#GL_TRUE, #GL_TRUE, #GL_TRUE, #GL_TRUE)
    glClear_(#GL_DEPTH_BUFFER_BIT)
    glMatrixMode_(#GL_PROJECTION)
    glLoadMatrixf_(cameraProjectionMatrix)
    If KeyboardPushed(#PB_Key_P)
      glLoadMatrixf_(lightProjectionMatrix)
    EndIf
    glMatrixMode_(#GL_MODELVIEW)
    glLoadMatrixf_(cameraViewMatrix)
    If KeyboardPushed(#PB_Key_P)
      glLoadMatrixf_(lightViewMatrix)
    EndIf
    glViewport_(0, 0, WindowWidth(0), WindowHeight(0))
    ;draw scene in full shadow
    drawScene(0.0,1)
    glEnable_(#GL_TEXTURE_2D)
    
    multiplyMatrix(textureMatrix,lightProjectionMatrix,lightViewMatrix)
    multiplyMatrix(textureMatrix,biasMatrix,textureMatrix)
    
    getRow(vector_a,textureMatrix,0)
    getRow(vector_b,textureMatrix,1)
    getRow(vector_c,textureMatrix,2)
    getRow(vector_d,textureMatrix,3)
  
    glTexGeni_(#GL_S, #GL_TEXTURE_GEN_MODE, #GL_EYE_LINEAR)
    glTexGenfv_(#GL_S, #GL_EYE_PLANE, vector_a)
    glEnable_(#GL_TEXTURE_GEN_S)
  
    glTexGeni_(#GL_T, #GL_TEXTURE_GEN_MODE, #GL_EYE_LINEAR)
    glTexGenfv_(#GL_T, #GL_EYE_PLANE, vector_b)
    glEnable_(#GL_TEXTURE_GEN_T)
  
    glTexGeni_(#GL_R, #GL_TEXTURE_GEN_MODE, #GL_EYE_LINEAR)
    glTexGenfv_(#GL_R, #GL_EYE_PLANE, vector_c)
    glEnable_(#GL_TEXTURE_GEN_R)
  
    glTexGeni_(#GL_Q, #GL_TEXTURE_GEN_MODE, #GL_EYE_LINEAR)
    glTexGenfv_(#GL_Q, #GL_EYE_PLANE, vector_d)
    glEnable_(#GL_TEXTURE_GEN_Q)
    
    glBindTexture_(#GL_TEXTURE_2D, depth_texture)
    glTexParameteri_(#GL_TEXTURE_2D, #GL_TEXTURE_COMPARE_MODE_ARB, #GL_COMPARE_R_TO_TEXTURE)
    glTexParameteri_(#GL_TEXTURE_2D, #GL_TEXTURE_COMPARE_FUNC_ARB, #GL_LEQUAL)
    glTexParameteri_(#GL_TEXTURE_2D, #GL_DEPTH_TEXTURE_MODE_ARB, #GL_INTENSITY)
    glAlphaFunc_(#GL_EQUAL,1.0)
    glEnable_(#GL_ALPHA_TEST)
    glColor3f_(1.0,1.0,1.0)
    glDepthMask_(#GL_FALSE)
    drawScene(0.0,0)
    glDepthMask_(#GL_TRUE)
    glDisable_(#GL_TEXTURE_2D)
    glDisable_(#GL_TEXTURE_GEN_S)
    glDisable_(#GL_TEXTURE_GEN_T)
    glDisable_(#GL_TEXTURE_GEN_R)
    glDisable_(#GL_TEXTURE_GEN_Q)
    glDisable_(#GL_ALPHA_TEST)
  Else
    drawScene(dt,0)
  EndIf
  
  If spectate = 0
    x.f = player_x(own_player_id)
    y.f = player_y(own_player_id)
    z.f = player_z(own_player_id)
    angle.f = player_angle_y(own_player_id)
    If key_shift = 1 And key_ctrl = 0
      If ElapsedMilliseconds()-key_shift_time<500
        player_angle_y(own_player_id) - Sin((ElapsedMilliseconds()-key_shift_time)/500.0)*0.45
      Else
        player_angle_y(own_player_id) - Sin(1.0)*0.45
      EndIf
    EndIf
    If key_shift = 0
      If ElapsedMilliseconds()-key_shift_time<500
        player_angle_y(own_player_id) + Sin((ElapsedMilliseconds()-key_shift_time)/500.0-1.0)*0.45
      EndIf
    EndIf
    If player_speed(own_player_id) = 0.0
      If Not own_movement_start = -1
        own_movement_stop = ElapsedMilliseconds()
      EndIf
      own_movement_start = -1
    EndIf
    If player_speed(own_player_id) > 0.0 And own_movement_start = -1
      own_movement_start = ElapsedMilliseconds()
    EndIf
    If Not own_movement_start = -1
      player_x(own_player_id) = player_x(own_player_id)-player_angle_x(own_player_id)*0.25+player_angle_x(own_player_id)*Sin((ElapsedMilliseconds()-own_movement_start)*0.0045*player_speed(own_player_id))*0.1+0.5
      player_z(own_player_id) = player_z(own_player_id)-player_angle_z(own_player_id)*0.25+player_angle_z(own_player_id)*Sin((ElapsedMilliseconds()-own_movement_start)*0.0045*player_speed(own_player_id))*0.1+0.5
      last_movement_anim_state = Sin((ElapsedMilliseconds()-own_movement_start)*0.0045*player_speed(own_player_id))*0.1
    Else
      If Not own_movement_stop = -1
        player_x(own_player_id) = player_x(own_player_id)-player_angle_x(own_player_id)*0.25+player_angle_x(own_player_id)*last_movement_anim_state-player_angle_x(own_player_id)*Sin((ElapsedMilliseconds()-own_movement_stop)*0.0045)*0.1+0.5
        player_z(own_player_id) = player_z(own_player_id)-player_angle_z(own_player_id)*0.25+player_angle_z(own_player_id)*last_movement_anim_state-player_angle_z(own_player_id)*Sin((ElapsedMilliseconds()-own_movement_stop)*0.0045)*0.1+0.5
      EndIf
      If last_movement_anim_state>0.0 And last_movement_anim_state-Sin((ElapsedMilliseconds()-own_movement_stop)*0.0045)*0.1<=0.0
        own_movement_stop = -1
      EndIf
      If last_movement_anim_state<0.0 And last_movement_anim_state-Sin((ElapsedMilliseconds()-own_movement_stop)*0.0045)*0.1>=0.0
        own_movement_stop = -1
      EndIf
      If own_movement_stop = -1
        player_x(own_player_id) = player_x(own_player_id)-player_angle_x(own_player_id)*0.25+0.5
        player_z(own_player_id) = player_z(own_player_id)-player_angle_z(own_player_id)*0.25+0.5
        own_movement_stop = -1
      EndIf
    EndIf
    If player_item(own_player_id) = 2
      delta.f = (ElapsedMilliseconds()-player_last_shot(own_player_id))/shot_times(own_weapon)*#PI/2.0
      If ElapsedMilliseconds()-player_last_shot(own_player_id)<shot_times(own_weapon)/2
        player_angle_y(own_player_id) + Sin(delta)*0.1
      Else
        If ElapsedMilliseconds()-player_last_shot(own_player_id)>=shot_times(own_weapon)/2 And ElapsedMilliseconds()-player_last_shot(own_player_id)<shot_times(own_weapon)
          player_angle_y(own_player_id) + (1.0-Sin(delta))*0.1
        EndIf
      EndIf
    EndIf
    player_y(own_player_id) = player_eye_y(own_player_id)-player_angle_y(own_player_id)*0.25-0.2+0.25
    player_item(own_player_id) = own_item
    teamlist(own_player_id) = own_team
    weaponlist(own_player_id) = own_weapon
    player_block_color_red(own_player_id) = own_block_red
    player_block_color_green(own_player_id) = own_block_green
    player_block_color_blue(own_player_id) = own_block_blue
    glDepthRange_(0.0,0.2)
    renderplayer(own_player_id,0)
    glDepthRange_(0.0,1.0)
    player_angle_y(own_player_id) = angle
    player_x(own_player_id) = x
    player_y(own_player_id) = y
    player_z(own_player_id) = z
    updatePlayer(own_player_id,dt)
  EndIf
   
  glMatrixMode_(#GL_PROJECTION)
  glLoadIdentity_()
  glOrtho_(0, engineWindowWidth(), engineWindowHeight(), 0, -1, 1)
	glMatrixMode_(#GL_MODELVIEW)
	glLoadIdentity_()
	
	glDepthMask_(#GL_FALSE)
	glDisable_(#GL_DEPTH_TEST)
	glDisable_(#GL_CULL_FACE)
	glEnable_(#GL_TEXTURE_2D)
	glColor3f_(1.0,1.0,1.0)
	
	If key_m = 1 And map_loaded = 1 And display_list_created = 1
    If map_texture_id = -1
      map_texture_id = loadTextureFromImage(map_image,0,0,0)
    EndIf
    glBindTexture_(#GL_TEXTURE_2D,map_texture_id)
    glColor3f_(1.0,1.0,1.0)
    drawRect((engineWindowWidth()-engineWindowHeight()*0.7)/2,engineWindowHeight()*0.15,engineWindowHeight()*0.7,engineWindowHeight()*0.7)
    glBindTexture_(#GL_TEXTURE_2D,0)
  EndIf
	
  If key_tab = 1
    glColor3f_(team_1_red/255.0,team_1_green/255.0,team_1_blue/255.0)
    drawRect(engineWindowWidth()*0.10,engineWindowHeight()*0.08,engineWindowWidth()*0.3,engineWindowHeight()*0.14)
    glColor3f_(team_2_red/255.0,team_2_green/255.0,team_2_blue/255.0)
    drawRect(engineWindowWidth()*0.60,engineWindowHeight()*0.08,engineWindowWidth()*0.3,engineWindowHeight()*0.14)
    glColor3f_(1.0,1.0,1.0)
    drawString(engineWindowWidth()*0.15,engineWindowHeight()*0.11,engineWindowHeight()*0.08,team_1_name.s)
    drawString(engineWindowWidth()*0.35-stringWidth(engineWindowHeight()*0.11,Str(team_1_score)),engineWindowHeight()*0.11,engineWindowHeight()*0.08,Str(team_1_score))
    drawString((engineWindowWidth()-stringWidth(engineWindowHeight()*0.08,"vs."))*0.5,engineWindowHeight()*0.11,engineWindowHeight()*0.08,"vs.")
    drawString(engineWindowWidth()-stringWidth(engineWindowHeight()*0.08,team_2_name.s)-engineWindowWidth()*0.15,engineWindowHeight()*0.11,engineWindowHeight()*0.08,team_2_name.s)
    drawString(engineWindowWidth()*0.65,engineWindowHeight()*0.11,engineWindowHeight()*0.08,Str(team_2_score))
    
    index = 0
    For k = 0 To 31
      If Not player_y(k) = 64.0 And teamlist(k) = 0
        If player_dead(k)
          glColor3f_(1.0,0.2,0.2)
        Else
          glColor3f_(1.0,1.0,1.0)
        EndIf
        If k = team_1_intel_player Or k = team_2_intel_player
          glBindTexture_(#GL_TEXTURE_2D,texture_intel)
          drawRect(engineWindowWidth()*0.125-engineWindowHeight()*0.06,engineWindowHeight()*0.25+engineWindowHeight()*0.04*index,engineWindowHeight()*0.04,engineWindowHeight()*0.04)
        EndIf
        drawString(engineWindowWidth()*0.125,engineWindowHeight()*0.25+engineWindowHeight()*0.04*index,engineWindowHeight()*0.04,namelist(k))
        drawString(engineWindowWidth()*0.3,engineWindowHeight()*0.25+engineWindowHeight()*0.04*index,engineWindowHeight()*0.04,"#"+Str(k))
        drawString(engineWindowWidth()*0.35,engineWindowHeight()*0.25+engineWindowHeight()*0.04*index,engineWindowHeight()*0.04,Str(player_kills(k)))
        index + 1
      EndIf
    Next
    
    index = 0
    For k = 0 To 31
      If Not player_y(k) = 64.0 And teamlist(k) = 1
        If player_dead(k)
          glColor3f_(1.0,0.2,0.2)
        Else
          glColor3f_(1.0,1.0,1.0)
        EndIf
        If k = team_1_intel_player Or k = team_2_intel_player
          glBindTexture_(#GL_TEXTURE_2D,texture_intel)
          drawRect(engineWindowWidth()*0.625-engineWindowHeight()*0.06,engineWindowHeight()*0.25+engineWindowHeight()*0.04*index,engineWindowHeight()*0.04,engineWindowHeight()*0.04)
        EndIf
        drawString(engineWindowWidth()*0.625,engineWindowHeight()*0.25+engineWindowHeight()*0.04*index,engineWindowHeight()*0.04,namelist(k))
        drawString(engineWindowWidth()*0.8,engineWindowHeight()*0.25+engineWindowHeight()*0.04*index,engineWindowHeight()*0.04,"#"+Str(k))
        drawString(engineWindowWidth()*0.85,engineWindowHeight()*0.25+engineWindowHeight()*0.04*index,engineWindowHeight()*0.04,Str(player_kills(k)))
        index + 1
      EndIf
    Next
    
    glColor3f_(1.0,1.0,1.0)
    index = 0
    For k = 0 To 31
      If Not player_y(k) = 64.0 And teamlist(k) = -1
        drawString(engineWindowWidth()*0.425,engineWindowHeight()*0.25+engineWindowHeight()*0.04*index,engineWindowHeight()*0.04,namelist(k))
        drawString(engineWindowWidth()*0.55,engineWindowHeight()*0.25+engineWindowHeight()*0.04*index,engineWindowHeight()*0.04,"#"+Str(k))
        index + 1
      EndIf
    Next
    
    glColor3f_(1.0,0.0,0.0)
    drawString((engineWindowWidth()-stringWidth(engineWindowHeight()*0.05,Str(network_ping)+"ms"))/2,engineWindowHeight()*0.075,engineWindowHeight()*0.05,Str(network_ping)+"ms")
  EndIf
  
  If Not hide_hud
    glColor3f_(1.0,1.0,1.0)
    
    glBindTexture_(#GL_TEXTURE_2D,texture_target)
    drawRect((engineWindowWidth()-engineWindowHeight()*0.015)/2,(engineWindowHeight()-engineWindowHeight()*0.015)/2,engineWindowWidth()*0.015,engineWindowWidth()*0.015)
    glBindTexture_(#GL_TEXTURE_2D,0)
    
    index = 0
    For k = 0 To 15
      If ElapsedMilliseconds()-kill_action_time(k)>10000
        kill_action_message(k) = ""
        kill_action_time(k) = 0
        kill_action_team(k) = 0
      Else
        If kill_action_team(k) = -1
          glColor3f_(1.0,0.0,0.0)
        EndIf
        If kill_action_team(k) = 0
          glColor3f_(team_1_red/255.0,team_1_green/255.0,team_1_blue/255.0)
        EndIf
        If kill_action_team(k) = 1
          glColor3f_(team_2_red/255.0,team_2_green/255.0,team_2_blue/255.0)
        EndIf
        drawString(engineWindowHeight()*0.02,engineWindowHeight()*0.02*index,engineWindowHeight()*0.02,kill_action_message(k))
        index + 1
      EndIf
    Next
    
    ;If own_team = -1 Or own_team = teamlist(faced_player)
      s$ = ""
      If Not faced_player = -1
        s$ = namelist(faced_player)+" #"+Str(faced_player)
      EndIf
      If own_team = -1 And spectate_stick_to_player = 1
        s$ = namelist(spectate_player)+" #"+Str(spectate_player)
      EndIf
      If Not s$ = ""
        glColor3f_(1.0,1.0,1.0)
        drawString((engineWindowWidth()-stringWidth(engineWindowHeight()*0.04,s$))*0.5,engineWindowHeight()-engineWindowHeight()*0.08,engineWindowHeight()*0.04,s$)
      EndIf
    ;EndIf
    
    For k=0 To 15
      If ElapsedMilliseconds()-chat_message_time(k)<10000 Or chat_opened = 1
        If chat_message_color(k) = -1
          glColor3f_(1.0,0.0,0.0)
        EndIf
        If chat_message_color(k) = 0
          glColor3f_(team_1_red/255.0,team_1_green/255.0,team_1_blue/255.0)
        EndIf
        If chat_message_color(k) = 1
          glColor3f_(team_2_red/255.0,team_2_green/255.0,team_2_blue/255.0)
        EndIf
        drawString(engineWindowHeight()*0.02,engineWindowHeight()-engineWindowHeight()*0.02*(18-k),engineWindowHeight()*0.02,chat_message(k))
      EndIf
    Next
    If chat_opened = 1 And chat_team = 0
      glColor3f_(1.0,1.0,1.0)
      drawString(engineWindowHeight()*0.02,engineWindowHeight()-engineWindowHeight()*0.02*2,engineWindowHeight()*0.02,"Global: "+chat_input$)
    EndIf
    If chat_opened = 1 And chat_team = 1
      glColor3f_(1.0,1.0,1.0)
      drawString(engineWindowHeight()*0.02,engineWindowHeight()-engineWindowHeight()*0.02*2,engineWindowHeight()*0.02,"Team: "+chat_input$)
    EndIf
    
    If map_loaded = 0 And display_list_created = 0
      glColor3f_(1.0,1.0,1.0)
      glBindTexture_(#GL_TEXTURE_2D,texture_background)
      drawRect(0,0,engineWindowWidth(),engineWindowHeight())
      glColor3f_(1.0,1.0,1.0)
      drawString(engineWindowWidth()*0.1,engineWindowHeight()*0.85,engineWindowHeight()*0.05,"Loading map...")
      glBindTexture_(#GL_TEXTURE_2D,texture_white)
      glColor3f_(0.25,0.25,0.25)
      drawRect(engineWindowWidth()*0.1,engineWindowHeight()*0.8,engineWindowWidth()*0.8,engineWindowHeight()*0.05)
      glColor3f_(1.0,1.0,0.0)
      drawRect(engineWindowWidth()*0.1,engineWindowHeight()*0.8,engineWindowWidth()*0.8*(map_data_compressed_index/map_data_size),engineWindowHeight()*0.05)
      glBindTexture_(#GL_TEXTURE_2D,0)
      glColor3f_(1.0,1.0,1.0)
    EndIf
    
    If escape_menu = 1
      glColor3f_(1.0,0.0,0.0)
      drawString((engineWindowWidth()-stringWidth(engineWindowHeight()*0.1,"Exit game? y/n"))/2,(engineWindowHeight()-engineWindowHeight()*0.1)/2,engineWindowHeight()*0.1,"Exit game? y/n")
    EndIf
    
    glColor3f_(1.0,1.0,1.0)
    drawString(0.0,0.0,engineWindowHeight()*0.04,debug_message.s)
    If spectate = 0
      If own_hp > 30
        glColor3f_(1.0,1.0,1.0)
      Else
        glColor3f_(1.0,0.0,0.0)
      EndIf
      drawString((engineWindowWidth()-stringWidth(engineWindowHeight()*0.05,Str(own_hp)+" HP"))/2,engineWindowHeight()-engineWindowHeight()*0.075,engineWindowHeight()*0.05,Str(own_hp)+" HP")
      
      glColor3f_(1.0,1.0,1.0)
      glBindTexture_(#GL_TEXTURE_2D,texture_indicator)
      drawRect((engineWindowWidth()-engineWindowWidth()*0.15)/2,(engineWindowHeight()-engineWindowWidth()*0.15)/2,engineWindowWidth()*0.15,engineWindowWidth()*0.15)
      glBindTexture_(#GL_TEXTURE_2D,0)
    EndIf
  EndIf
    
	glDisable_(#GL_TEXTURE_2D)
	glEnable_(#GL_CULL_FACE)
	glDepthMask_(#GL_TRUE)
	glEnable_(#GL_DEPTH_TEST)
  
  If map_loaded = 1 And display_list_created = 0
    For chunk_z = 0 To 63
      For chunk_x = 0 To 63
        display_list_update_flag(chunk_x,chunk_z) = 0
        glDeleteLists_(display_list_ids(chunk_x,chunk_z),1)
        display_list_ids(chunk_x,chunk_z) = glGenLists_(1)
        glNewList_(display_list_ids(chunk_x,chunk_z),#GL_COMPILE)
        glEnableClientState_(#GL_COLOR_ARRAY)
        glEnableClientState_(#GL_VERTEX_ARRAY)
        glEnableClientState_(#GL_TEXTURE_COORD_ARRAY)
        drawChunk(chunk_x,chunk_z,0)
        glDisableClientState_(#GL_TEXTURE_COORD_ARRAY)
        glDisableClientState_(#GL_VERTEX_ARRAY)
        glDisableClientState_(#GL_COLOR_ARRAY)
        glEndList_()
        glDeleteLists_(display_list_ids_shadowed(chunk_x,chunk_z),1)
        display_list_ids_shadowed(chunk_x,chunk_z) = glGenLists_(1)
        glNewList_(display_list_ids_shadowed(chunk_x,chunk_z),#GL_COMPILE)
        glEnableClientState_(#GL_COLOR_ARRAY)
        glEnableClientState_(#GL_VERTEX_ARRAY)
        glEnableClientState_(#GL_TEXTURE_COORD_ARRAY)
        drawChunk(chunk_x,chunk_z,1)
        glDisableClientState_(#GL_TEXTURE_COORD_ARRAY)
        glDisableClientState_(#GL_VERTEX_ARRAY)
        glDisableClientState_(#GL_COLOR_ARRAY)
        glEndList_()
        ;Debug Str((chunk_z*64.0+chunk_x)/4096.0*100.0)+"%"
      Next
    Next
    
  	display_list_created = 1
  EndIf
EndProcedure

Procedure drawScene(dt.f,shadowed.l)
    If map_loaded = 1 And display_list_created = 1
     For chunk_z = 0 To 63
       For chunk_x = 0 To 63
         If display_list_update_flag(chunk_x,chunk_z) = 1
           glDeleteLists_(display_list_ids(chunk_x,chunk_z),1)
           glDeleteLists_(display_list_ids_shadowed(chunk_x,chunk_z),1)
           
           display_list_ids(chunk_x,chunk_z) = glGenLists_(1)
           glNewList_(display_list_ids(chunk_x,chunk_z),#GL_COMPILE)
           glEnableClientState_(#GL_COLOR_ARRAY)
           glEnableClientState_(#GL_VERTEX_ARRAY)
           glEnableClientState_(#GL_TEXTURE_COORD_ARRAY)
           drawChunk(chunk_x,chunk_z,0)
           glDisableClientState_(#GL_TEXTURE_COORD_ARRAY)
           glDisableClientState_(#GL_VERTEX_ARRAY)
           glDisableClientState_(#GL_COLOR_ARRAY)
           glEndList_()
           
           display_list_ids_shadowed(chunk_x,chunk_z) = glGenLists_(1)
           glNewList_(display_list_ids_shadowed(chunk_x,chunk_z),#GL_COMPILE)
           glEnableClientState_(#GL_COLOR_ARRAY)
           glEnableClientState_(#GL_VERTEX_ARRAY)
           glEnableClientState_(#GL_TEXTURE_COORD_ARRAY)
           drawChunk(chunk_x,chunk_z,1)
           glDisableClientState_(#GL_TEXTURE_COORD_ARRAY)
           glDisableClientState_(#GL_VERTEX_ARRAY)
           glDisableClientState_(#GL_COLOR_ARRAY)
           glEndList_()
           display_list_update_flag(chunk_x,chunk_z) = 0
         EndIf
       Next
     Next
    If spectate = 1
      If spectate_stick_to_player = 1
        chunk_start_x = Int(getPlayerX(spectate_player)/8.0)
        chunk_start_z = Int(getPlayerZ(spectate_player)/8.0)
      Else
        chunk_start_x = Int(camera_x/8.0)
        chunk_start_z = Int(camera_z/8.0)
      EndIf
    Else
      chunk_start_x = Int(player_x(own_player_id)/8.0)
      chunk_start_z = Int(player_z(own_player_id)/8.0)
    EndIf
    ;glEnable_(#GL_TEXTURE_2D)
    ;glBindTexture_(#GL_TEXTURE_2D,texture_noise)
     For chunk_z = chunk_start_z-16 To chunk_start_z+16
       For chunk_x = chunk_start_x-16 To chunk_start_x+16
         If Int(Abs(chunk_x))>-1 And Int(Abs(chunk_x))<64 And Int(Abs(chunk_z))>-1 And Int(Abs(chunk_z))<64
           If shadowed = 0
             glCallList_(display_list_ids(Int(Abs(chunk_x)),Int(Abs(chunk_z))))
           Else
             glCallList_(display_list_ids_shadowed(Int(Abs(chunk_x)),Int(Abs(chunk_z))))
           EndIf
         EndIf
       Next
     Next
     ;glBindTexture_(#GL_TEXTURE_2D,0)
     ;glDisable_(#GL_TEXTURE_2D)
   EndIf
   
  For k=0 To 32
    If player_y(k) < 64.0 And teamlist(k) > -1 And Not k = own_player_id
      If dt > 0.0
        updatePlayer(k,dt)
      EndIf
      renderplayer(k,0)
    EndIf
    If grenade_alive(k) = 1
      If dt > 0.0
        updateGrenade(k,dt)
      EndIf
      renderGrenade(k)
    EndIf
  Next
  
  If shadowed = 1
    ;renderplayer(own_player_id,shadowed)
  EndIf
;   glBegin_(#GL_QUADS)
;   updateFallingBlocks(dt)
;   glEnd_()
;   
   position_time = ElapsedMilliseconds()
;   
  time = ElapsedMilliseconds()
  glColor3f_(1.0,1.0,0.0)
  For k=0 To 511
    If tracer_used(k) = 1
      glPushMatrix_()
      glTranslatef_(tracer_x(k),tracer_y(k),tracer_z(k))
      glRotatef_(-Degree(ATan2(tracer_speed_x(k),tracer_speed_z(k))),0.0,1.0,0.0)
      glRotatef_(-(Degree(ACos(tracer_speed_y(id)/Sqr(tracer_speed_x(id)*tracer_speed_x(id)+tracer_speed_y(id)*tracer_speed_y(id)+tracer_speed_z(id)*tracer_speed_z(id))))-90.0),0.0,0.0,1.0)
      glBegin_(#GL_QUADS)
      rendercubeat(0.0,0.0,0.0,0.8,0.1,0.1)
      glEnd_()
      glPopMatrix_()
      tracer_x(k) + tracer_speed_x(k)*dt*300.0
      tracer_y(k) + tracer_speed_y(k)*dt*300.0
      tracer_z(k) + tracer_speed_z(k)*dt*300.0
      If time-tracer_created(k)>20000
        tracer_used(k) = 0
      EndIf
      If tracer_used(k) = 1 And Not getBlockSafe(tracer_x(k),tracer_y(k),tracer_z(k)) = $FFFFFFFF
        createSoundSource(18,tracer_x(k),tracer_y(k),tracer_z(k),12.0)
        tracer_used(k) = 0
      EndIf
    EndIf
  Next
;    
   last_tracer_update = ElapsedMilliseconds()
;   
  glPushMatrix_()
  glTranslatef_(team_1_base_x,team_1_base_y+0.75,team_1_base_z)
  glCallList_(kv6_cp)
  glPopMatrix_()
  glPushMatrix_()
  glTranslatef_(team_2_base_x,team_2_base_y+0.75,team_2_base_z)
  glCallList_(kv6_cp+1)
  glPopMatrix_()
  If team_1_intel_player = -1
    glPushMatrix_()
    glTranslatef_(team_1_intel_x,team_1_intel_y+0.75,team_1_intel_z)
    glCallList_(kv6_intel)
    glPopMatrix_()
  EndIf
  If team_2_intel_player = -1
    glPushMatrix_()
    glTranslatef_(team_2_intel_x,team_2_intel_y+0.75,team_2_intel_z)
    glCallList_(kv6_intel+1)
    glPopMatrix_()
  EndIf
EndProcedure
; IDE Options = PureBasic 5.31 (Windows - x86)
; CursorPosition = 1330
; FirstLine = 856
; Folding = Bko
; EnableUnicode
; EnableXP
; UseMainFile = main.pb
; Executable = aos.exe
; DisableDebugger