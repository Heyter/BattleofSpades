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

Global drunken_camera_roll.f = 0.0

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
Global key_sneak.l
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
Global texture_player.l
Global texture_vignette.l
Global texture_command.l
Global texture_medical.l

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
Global kv6_playerhead.l
Global kv6_playerarms.l
Global kv6_playertorso.l
Global kv6_playerleg.l
Global kv6_playertorsoc.l
Global kv6_playerlegc.l

Global screen.l = 0

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
    OpenScreen(width, height,24,"Battle of Spades",#PB_Screen_NoSynchronization)
  Else
    OpenWindow(0, 0, 0, width, height, "Battle of Spades",#PB_Window_MinimizeGadget|#PB_Window_ScreenCentered|#PB_Window_SizeGadget|#PB_Window_MaximizeGadget)
    OpenWindowedScreen(WindowID(0),0,0,width,height,#True,0,0,#PB_Screen_NoSynchronization)
    ;OpenGLGadget(0, 0, 0, WindowWidth(0) , WindowHeight(0))
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
  glFogf_(#GL_FOG_START, 60.0)
  glFogf_(#GL_FOG_END, 120.0)
  glEnable_(#GL_FOG)
  glDisable_(#GL_TEXTURE_RECTANGLE)
  glBlendFunc_(#GL_SRC_ALPHA, #GL_ONE_MINUS_SRC_ALPHA)
  glEnable_(#GL_BLEND)
  
  texture_font = loadBMPTextureFile("fonts/"+ReadPreferenceString("font","FixedSys_Bold_36")+".bmp")
  texture_white = loadBMPTextureFile("png/white.png")
  texture_splash = loadPNGTextureFile("png/splash.png")
  texture_target = loadPNGTextureFile("png/target.png")
  texture_background = loadBMPTextureFile("png/loading.png")
  texture_noise = loadBMPTextureFile("png/noise.bmp")
  texture_indicator = loadBMPTextureFile("png/indicator.bmp")
  texture_intel = loadBMPTextureFile("png/intel.bmp")
  texture_player = loadBMPTextureFile("png/player.bmp")
  texture_vignette = loadPNGTextureFile("png/vignette.png")
  texture_command = loadBMPTextureFile("png/command.bmp")
  texture_medical = loadBMPTextureFile("png/medical.bmp")
  kv6_semi = loadKV6("kv6/semi.kv6",Red(255))
  kv6_smg = loadKV6("kv6/smg.kv6",Red(255))
  kv6_shotgun = loadKV6("kv6/shotgun.kv6",Red(255))
  kv6_spade = loadKV6("kv6/spade.kv6",Red(255))
  kv6_grenade = loadKV6("kv6/grenade.kv6",Red(255))
  
  glMatrixMode_(#GL_TEXTURE)
  glScalef_(1.0, -1.0, 1.0)
  glMatrixMode_(#GL_MODELVIEW)
EndProcedure

Procedure.f engineWindowWidth()
  If fullscreen_mode = 0
    ProcedureReturn WindowWidth(0)
  EndIf
  ProcedureReturn screen_width
EndProcedure

Procedure.f engineWindowHeight()
  If fullscreen_mode = 0
    ProcedureReturn WindowHeight(0)
  EndIf
  ProcedureReturn screen_height
EndProcedure

Procedure drawRectSub(x.f, y.f, w.f, h.f, a.f, b.f, c.f, d.f)
	Define x_pos.f = x
  Define y_pos.f = engineWindowHeight()-y
  Define x_s.f = w
  Define y_s.f = -h
    
  x_pos = x_pos/engineWindowWidth()
  y_pos = y_pos/engineWindowHeight()
  x_s = x_s/engineWindowWidth()
  y_s = y_s/engineWindowHeight()
  Define x2.f = -1.0+(x_pos*2.0)
  Define y2.f = 1.0-(y_pos*2.0)
  Define x3.f = x2+(x_s*2.0)
  Define y3.f = y2-(y_s*2.0)
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
  Define k
  For k=0 To Len(text$)-1
    Define index.l = Asc(Mid(text$,k+1,1))-32
    If index > 0
	    Define a.l = (Int(index)%16)
	    Define b.l = (Int(index)/16)
	    drawRectSub(x+k*0.5*h, y, 0.5*h, h, 0.0625*a, 0.0714*b, 0.0625, 0.0714)
	  EndIf
	Next
	glBindTexture_(#GL_TEXTURE_2D,0)
EndProcedure

Procedure stringWidth(h.f, text$)
  ProcedureReturn Len(text$)*0.5*h
EndProcedure

Procedure subDraw(x2.f,y2.f,x3.f,y3.f,rot.f)
  If rot = 0.0
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
  Else
    rot = Radian(rot)
    Define ox.f = (x2+x3)/2.0
    Define oy.f = (y2+y3)/2.0
    Define top_left_x.f = Cos(rot) * (x2-ox) - Sin(rot) * (y2-oy) + ox
    Define top_left_y.f = Sin(rot) * (x2-ox) + Cos(rot) * (y2-oy) + oy
    Define top_right_x.f = Cos(rot) * (x3-ox) - Sin(rot) * (y2-oy) + ox
    Define top_right_y.f = Sin(rot) * (x3-ox) + Cos(rot) * (y2-oy) + oy
    Define bottom_right_x.f = Cos(rot) * (x3-ox) - Sin(rot) * (y3-oy) + ox
    Define bottom_right_y.f = Sin(rot) * (x3-ox) + Cos(rot) * (y3-oy) + oy
    Define bottom_left_x.f = Cos(rot) * (x2-ox) - Sin(rot) * (y3-oy) + ox
    Define bottom_left_y.f = Sin(rot) * (x2-ox) + Cos(rot) * (y3-oy) + oy
    
    glBegin_(#GL_TRIANGLE_FAN)
    glTexCoord2f_(0.0,0.0)
    glVertex3f_(top_left_x, top_left_y, 0.0)
    glTexCoord2f_(1.0,0.0)
    glVertex3f_(top_right_x, top_right_y, 0.0)
    glTexCoord2f_(1.0,1.0)
    glVertex3f_(bottom_right_x, bottom_right_y, 0.0)
    glTexCoord2f_(0.0,1.0)
    glVertex3f_(bottom_left_x, bottom_left_y, 0.0)
    glEnd_()
  EndIf
EndProcedure

Procedure drawRect(x.f,y.f,w.f,h.f)
  Define x_pos.f = x
	Define y_pos.f = engineWindowHeight()-y
	Define x_s.f = w
	Define y_s.f = -h
	    
	x_pos = x_pos/engineWindowWidth()
	y_pos = y_pos/engineWindowHeight()
	x_s = x_s/engineWindowWidth()
	y_s = y_s/engineWindowHeight()
	Define x2.f = -1.0+(x_pos*2.0)
	Define y2.f = 1.0-(y_pos*2.0)
	Define x3.f = x2+(x_s*2.0)
	Define y3.f = y2-(y_s*2.0)
	subDraw((x2*0.5+0.5)*engineWindowWidth(),(y2*0.5+0.5)*engineWindowHeight(),(x3*0.5+0.5)*engineWindowWidth(),(y3*0.5+0.5)*engineWindowHeight(),0.0)
EndProcedure

Procedure drawRectRotated(x.f,y.f,w.f,h.f,rot.f)
  Define x_pos.f = x
	Define y_pos.f = engineWindowHeight()-y
	Define x_s.f = w
	Define y_s.f = -h
	    
	x_pos = x_pos/engineWindowWidth()
	y_pos = y_pos/engineWindowHeight()
	x_s = x_s/engineWindowWidth()
	y_s = y_s/engineWindowHeight()
	Define x2.f = -1.0+(x_pos*2.0)
	Define y2.f = 1.0-(y_pos*2.0)
	Define x3.f = x2+(x_s*2.0)
	Define y3.f = y2-(y_s*2.0)
	subDraw((x2*0.5+0.5)*engineWindowWidth(),(y2*0.5+0.5)*engineWindowHeight(),(x3*0.5+0.5)*engineWindowWidth(),(y3*0.5+0.5)*engineWindowHeight(),rot)
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
  key_sneak = 0
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
    If KeyboardPushed(#PB_Key_V)
      key_sneak = 1
    EndIf
    If KeyboardPushed(#PB_Key_Space)
      key_space = 1
      If spectate = 1 And spectate_stick_to_player = 1
        spectate_stick_to_player = 0
        camera_x = player_x(spectate_player)
        camera_y = player_y(spectate_player)
        camera_z = player_z(spectate_player)
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
        If ElapsedMilliseconds()>action_lock
          own_item = 0
          sendTool(0)
        EndIf
      EndIf
    EndIf
    If KeyboardReleased(#PB_Key_2)
      If KeyboardPushed(#PB_Key_0)
        joingame(1)
      Else
        If ElapsedMilliseconds()>action_lock
          own_item = 1
          sendTool(1)
        EndIf
      EndIf
    EndIf
    If KeyboardReleased(#PB_Key_3)
      If KeyboardPushed(#PB_Key_0)
        joingame(-1)
      Else
        If ElapsedMilliseconds()>action_lock
          own_item = 2
          sendTool(2)
        EndIf
      EndIf
    EndIf
    If KeyboardReleased(#PB_Key_4)
      If Not KeyboardPushed(#PB_Key_0)
        If ElapsedMilliseconds()>action_lock
          own_item = 3
          sendTool(3)
        EndIf
      EndIf
    EndIf
    If own_item = 2 And KeyboardReleased(#PB_Key_R) And ElapsedMilliseconds()>action_lock
      action_lock = ElapsedMilliseconds()+reload_times(own_weapon)
      Define left_to_max.l = mag_size(own_weapon)-player_ammo(own_player_id)
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
      Define k
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
      Define key$ = KeyboardInkey()
      If Not FindString(" 1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!§$%&/()=?@-_.:,;#'+*~<>|{[]}\^°"+Chr(34),key$) = 0
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

Global m_chunk_buffer = AllocateMemory(1024*1024*4)
Global m_color_buffer = AllocateMemory(1024*1024*4)
Global m_texture_buffer = AllocateMemory(1024*1024*4)

Procedure drawChunk(chunk_x, chunk_z, shadowed.l)
  DisableDebugger
  Define data_size = 0
  Define x,y,z
    For z = chunk_z*8 To chunk_z*8+7
      For x = chunk_x*8 To chunk_x*8+7
        Define found_solid_block.l = 0
        For y = 63 To 0 Step -1
          setLightLevel(x,y,z,0)
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
            found_solid_block = 1
          Else
            If found_solid_block = 0
              setLightLevel(x,y,z,4)
            EndIf
          EndIf
      	Next
      Next
    Next
    
    Define k
    For k=4 To 1 Step -1
      For z = chunk_z*8 To chunk_z*8+7
        For x = chunk_x*8 To chunk_x*8+7
          For y = 0 To 63
            If getLightLevel(x,y,z) = 0 And getBlockSafe(x,y,z) = $FFFFFFFF
              If getLightLevel(x,y,z+1) = k And getBlockSafe(x,y,z+1) = $FFFFFFFF
                setLightLevel(x,y,z,k-1)
              EndIf
              If getLightLevel(x,y,z-1) = k And getBlockSafe(x,y,z-1) = $FFFFFFFF
                setLightLevel(x,y,z,k-1)
              EndIf
              If getLightLevel(x,y-1,z) = k And getBlockSafe(x,y-1,z) = $FFFFFFFF
                setLightLevel(x,y,z,k-1)
              EndIf
              If getLightLevel(x+1,y,z) = k And getBlockSafe(x+1,y,z) = $FFFFFFFF
                setLightLevel(x,y,z,k-1)
              EndIf
              If getLightLevel(x-1,y,z) = k And getBlockSafe(x-1,y,z) = $FFFFFFFF
                setLightLevel(x,y,z,k-1)
              EndIf
              If getLightLevel(x,y+1,z) = k And getBlockSafe(x,y+1,z) = $FFFFFFFF
                setLightLevel(x,y,z,k-1)
              EndIf
            EndIf
      	  Next
        Next
      Next
    Next
    
    Define chunk_buffer = m_chunk_buffer
    Define chunk_buffer_start = chunk_buffer
    Define color_buffer = m_color_buffer
    Define color_buffer_start = color_buffer
    Define texture_buffer = m_texture_buffer
    Define texture_buffer_start = texture_buffer
    
  StartDrawing(ImageOutput(map_overview_tmp_image))
  Define triangle_count = 0
  For z = chunk_z*8 To chunk_z*8+7
          For x = chunk_x*8 To chunk_x*8+7
            For y = 0 To 63
              Define j = blocks(x,y,z)
              If Not j = $FFFFFFFF
                Define red.f = Red(j)/255.0
                Define green.f = Green(j)/255.0
                Define blue.f = Blue(j)/255.0
                Plot(x,z,j)
                Define shadow.f = (getLightLevel(x,y,z+1)/4.0)*0.75+0.25
                If shadowed = 1
                  shadow * 0.5
                EndIf
                Define offset_a.f = 0.0;Sin(x*0.3927)*0.25-0.5
                Define offset_b.f = 0.0;Sin((x+1)*0.3927)*0.25-0.5
                If getBlockSafe(x,y,z+1) = $FFFFFFFF
                  Define light_a.f = vertexAO(getBlockSafe(x+1,y,z+1),getBlockSafe(x,y+1,z+1),getBlockSafe(x+1,y+1,z+1))*shadow
                  Define light_b.f = vertexAO(getBlockSafe(x-1,y,z+1),getBlockSafe(x,y-1,z+1),getBlockSafe(x-1,y-1,z+1))*shadow
                  Define light_c.f = vertexAO(getBlockSafe(x+1,y,z+1),getBlockSafe(x,y-1,z+1),getBlockSafe(x+1,y-1,z+1))*shadow
                  Define light_d.f = vertexAO(getBlockSafe(x-1,y,z+1),getBlockSafe(x,y+1,z+1),getBlockSafe(x-1,y+1,z+1))*shadow
                  
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
                shadow.f = (getLightLevel(x,y,z-1)/4.0)*0.75+0.25 : If shadowed = 1 : shadow * 0.5 : EndIf
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
                shadow.f = (getLightLevel(x,y-1,z)/4.0)*0.75+0.25 : If shadowed = 1 : shadow * 0.5 : EndIf
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
                shadow.f = (getLightLevel(x+1,y,z)/4.0)*0.75+0.25 : If shadowed = 1 : shadow * 0.5 : EndIf
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
                shadow.f = (getLightLevel(x-1,y,z)/4.0)*0.75+0.25 : If shadowed = 1 : shadow * 0.5 : EndIf
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
                shadow.f = (getLightLevel(x,y+1,z)/4.0)*0.75+0.25 : If shadowed = 1 : shadow * 0.5 : EndIf
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
      	;glTexCoordPointer_(2,#GL_FLOAT,0,texture_buffer_start)
      	glDrawArrays_(#GL_TRIANGLES,0,triangle_count)
      	;FreeMemory(color_buffer_start)
      	;FreeMemory(chunk_buffer_start)
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
      
      Define shadow_factor.f = 1.0
      If shadowed = 1
        shadow_factor = 0.5
      EndIf
  
      If teamlist(id) = 0
        glColor3f(team_1_red/255.0*shadow_factor,team_1_green/255.0*shadow_factor,team_1_blue/255.0*shadow_factor)
      EndIf
      If teamlist(id) = 1
        glColor3f(team_2_red/255.0*shadow_factor,team_2_green/255.0*shadow_factor,team_2_blue/255.0*shadow_factor)
      EndIf
      glPushMatrix_()
      glTranslatef_(getPlayerX(id)-1.0*0.12,getPlayerY(id)+0.5,getPlayerZ(id)+1.0*0.12)
      
      
      If player_dead(id) = 1
        Define y.f = getPlayerY(id)
        Define offset_y.f = 0.0
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
        glRotatef_(90.0,0.0,1.0,0.0)
        glTranslatef_(-0.5,-0.125,-0.25)
        glScalef_(0.5,0.5,0.5)
        If team_1_intel_player = id Or team_2_intel_player = id
          glTranslatef_(-0.25,0.0,-0.75)
          glCallList_(kv6_intel+((~teamlist(id))&1))
          glTranslatef_(0.25,0.0,0.75)
        EndIf
        If player_keystates2(id) & #KEY_CROUCH
          glTranslatef_(0.0,0.5-0.125,-1.0)
          glCallList_(kv6_playertorsoc+teamlist(id))
        Else
          glCallList_(kv6_playertorso+teamlist(id))
        EndIf
      EndIf
      glPopMatrix_()
      
      glPushMatrix_()
      glTranslatef_(1.0*0.12,-9.0*0.12,-1.0*0.12)
      glRotatef_(-Degree(ATan2(getPlayerAngleX(id),getPlayerAngleZ(id))),0.0,1.0,0.0)
      glTranslatef_(-0.9*0.12,0.0,-4.25*0.12)
      If isMoving(id)
        glRotatef_(Sin(ElapsedMilliseconds()*0.005)*25.0,0.0,0.0,1.0)
      EndIf
      If Not id = own_player_id
        glRotatef_(90.0,0.0,1.0,0.0)
        glTranslatef_(-0.375,-1.5,-0.125)
        glScalef_(0.5,0.5,0.5)
        If player_keystates2(id) & #KEY_CROUCH
          glTranslatef_(0.0,1.5,-1.0)
          glCallList_(kv6_playerlegc+teamlist(id))
        Else
          glCallList_(kv6_playerleg+teamlist(id))
        EndIf
      EndIf
      glPopMatrix_()
      
      If teamlist(id) = 0
        glColor3f(team_1_red/255.0*shadow_factor,team_1_green/255.0*shadow_factor,team_1_blue/255.0*shadow_factor)
      EndIf
      If teamlist(id) = 1
        glColor3f(team_2_red/255.0*shadow_factor,team_2_green/255.0*shadow_factor,team_2_blue/255.0*shadow_factor)
      EndIf
      
      glPushMatrix_()
      glTranslatef_(1.0*0.12,-9.0*0.12,-1.0*0.12)
      glRotatef_(-Degree(ATan2(getPlayerAngleX(id),getPlayerAngleZ(id))),0.0,1.0,0.0)
      glTranslatef_(-0.9*0.12,0.0,-4.25*0.12)
      If isMoving(id)
        glRotatef_(Sin(-ElapsedMilliseconds()*0.005)*25.0,0.0,0.0,1.0)
      EndIf
      If Not id = own_player_id
        glRotatef_(90.0,0.0,1.0,0.0)
        glTranslatef_(-1.0,-1.5,-0.125)
        glScalef_(0.5,0.5,0.5)
        If player_keystates2(id) & #KEY_CROUCH
          glTranslatef_(0.0,1.5,-1.0)
          glCallList_(kv6_playerlegc+teamlist(id))
        Else
          glCallList_(kv6_playerleg+teamlist(id))
        EndIf
      EndIf
      glPopMatrix_()
      
      glPushMatrix_()
      glTranslatef_(1.0*0.12,0.0*0.12,-1.0*0.12)
      Define offset.f = 0.0
      If ElapsedMilliseconds()-player_dig_anim_start(id)<#PLAYER_SPADE_TIME*player_dig_anim_speed(id)
        offset = 45.0*(ElapsedMilliseconds()-player_dig_anim_start(id))/(#PLAYER_SPADE_TIME*player_dig_anim_speed(id))
      EndIf
      If ElapsedMilliseconds()-player_dig_anim_start(id)>=#PLAYER_SPADE_TIME*player_dig_anim_speed(id) And ElapsedMilliseconds()-player_dig_anim_start(id)<#PLAYER_SPADE_TIME*2*player_dig_anim_speed(id)
        offset = 45.0-45.0*(ElapsedMilliseconds()-player_dig_anim_start(id)-#PLAYER_SPADE_TIME*player_dig_anim_speed(id))/(#PLAYER_SPADE_TIME*player_dig_anim_speed(id))
      EndIf
      glRotatef_(-Degree(ATan2(getPlayerAngleX(id),getPlayerAngleZ(id))),0.0,1.0,0.0)
      glPushMatrix_()
      glRotatef_(-(Degree(ACos(getPlayerAngleY(id)/Sqr(getPlayerAngleX(id)*getPlayerAngleX(id)+getPlayerAngleY(id)*getPlayerAngleY(id)+getPlayerAngleZ(id)*getPlayerAngleZ(id))))-90.0),0.0,0.0,1.0)
      If Not id = own_player_id
        glRotatef_(90.0,0.0,1.0,0.0)
        glTranslatef_(-0.375,-0.125,-0.375)
        glScalef_(0.5,0.5,0.5)
        glCallList_(kv6_playerhead+teamlist(id))
      EndIf
      glPopMatrix_()
      glRotatef_(-(Degree(ACos(getPlayerAngleY(id)/Sqr(getPlayerAngleX(id)*getPlayerAngleX(id)+getPlayerAngleY(id)*getPlayerAngleY(id)+getPlayerAngleZ(id)*getPlayerAngleZ(id))))-90.0)-offset,0.0,0.0,1.0)
      
      glRotatef_(90.0,0.0,1.0,0.0)
      glTranslatef_(-0.75,-1.0,-0.125)
      glScalef_(0.5,0.5,0.5)
      glCallList_(kv6_playerarms+teamlist(id))
      
      If player_item(id) = 0
        glTranslatef_(0.25,-0.75+0.125,2.125)
        glScalef_(0.5,0.5,0.5)
        glCallList_(kv6_spade)
      EndIf
      If player_item(id) = 1
        glColor3f(player_block_color_red(id)/255.0*shadow_factor,player_block_color_green(id)/255.0*shadow_factor,player_block_color_blue(id)/255.0*shadow_factor)
        glBegin_(#GL_QUADS)
        rendercubeat(8.0*0.08,-6.5*0.08,0.0*0.08,8.0*0.08,8.0*0.08,8.0*0.08)
        glEnd_()
      EndIf
      If player_item(id) = 2
        If weaponlist(id) = 0
          glTranslatef_(0.2,1.1,0.25)
          glScalef_(0.5,0.5,0.5)
          glCallList_(kv6_semi)
        EndIf
        If weaponlist(id) = 1
          glTranslatef_(0.2,0.7,0.25)
          glScalef_(0.5,0.5,0.5)
          glCallList_(kv6_smg)
        EndIf
         If weaponlist(id) = 2
          glTranslatef_(0.2,1.1,0.25)
          glScalef_(0.5,0.5,0.5)
          glCallList_(kv6_shotgun)
        EndIf
      EndIf
      If player_item(id) = 3
        glTranslatef_(0.25,1.0,2.0-0.125)
        glScalef_(0.5,0.5,0.5)
        glCallList_(kv6_grenade)
      EndIf
      glPopMatrix_()

      glPopMatrix_()
EndProcedure


Procedure.f shadowFix(x.f)
  Define texelsize.f = 1.0/1024.0
  ProcedureReturn Round(x/10.0,#PB_Round_Nearest)*10.0
EndProcedure

Global depth_texture.l = -1
Global framebuffer.l = -1
Global shadow_map_size.l = -1
Declare drawScene(dt.f,shadowed.l)
Global cameraProjectionMatrix.l = AllocateMemory(16*4)
Global lightProjectionMatrix.l = AllocateMemory(16*4)
Global cameraViewMatrix.l = AllocateMemory(16*4)
Global lightViewMatrix.l = AllocateMemory(16*4)
Global biasMatrix.l = createMatrix(0.5, 0.0, 0.0, 0.0,
                                    0.0, 0.5, 0.0, 0.0,
                                    0.0, 0.0, 0.5, 0.0,
                                    0.5, 0.5, 0.5, 1.0)
Global textureMatrix.l = AllocateMemory(16*4)
Global vector_a.l = createVector(0.0,0.0,0.0,0.0)
Global vector_b.l = createVector(0.0,0.0,0.0,0.0)
Global vector_c.l = createVector(0.0,0.0,0.0,0.0)
Global vector_d.l = createVector(0.0,0.0,0.0,0.0)

Procedure.f cameraPosX()
  If spectate = 1
    If spectate_stick_to_player = 1
      ProcedureReturn player_x(spectate_player)
    Else
      ProcedureReturn camera_x
    EndIf
  Else
    ProcedureReturn player_x(own_player_id)
  EndIf
EndProcedure
  
Procedure.f cameraPosY()
  If spectate = 1
    If spectate_stick_to_player = 1
      ProcedureReturn player_y(spectate_player)
    Else
      ProcedureReturn camera_y
    EndIf
  Else
    ProcedureReturn player_eye_y(own_player_id)+2.0
  EndIf
EndProcedure
  
Procedure.f cameraPosZ()
  If spectate = 1
    If spectate_stick_to_player = 1
      ProcedureReturn player_z(spectate_player)
    Else
      ProcedureReturn camera_z
    EndIf
  Else
    ProcedureReturn player_z(own_player_id)
  EndIf
EndProcedure  

Procedure updateEngineWindow(event, dt.f)
  
  If shadow_map_size = -1
    shadow_map_size = ReadPreferenceInteger("shadow_res",512)
  EndIf
  
  If player_display_list_created = 0 And Not game_mode = -1
    Define a_col.l = RGB(team_1_red,team_1_green,team_1_blue)
    Define b_col.l = RGB(team_2_red,team_2_green,team_2_blue)
    kv6_cp = loadKV6ForTeams("cp.kv6",a_col,b_col)
    kv6_intel = loadKV6ForTeams("intel.kv6",a_col,b_col)
    kv6_playerdead = loadKV6ForTeams("playerdead.kv6",a_col,b_col)
    kv6_playerhead = loadKV6ForTeams("playerhead.kv6",a_col,b_col)
    kv6_playerarms = loadKV6ForTeams("playerarms.kv6",a_col,b_col)
    kv6_playertorso = loadKV6ForTeams("playertorso.kv6",a_col,b_col)
    kv6_playerleg = loadKV6ForTeams("playerleg.kv6",a_col,b_col)
    kv6_playertorsoc = loadKV6ForTeams("playertorsoc.kv6",a_col,b_col)
    kv6_playerlegc = loadKV6ForTeams("playerlegc.kv6",a_col,b_col)
    player_display_list_created = 1
  EndIf
  
  updatemouse(event)
  updatekeyboard(event)
  
  spectate = 0
  If own_team = -1
    spectate = 1
  EndIf
  
  If mouse_button_1 = 1 Or mouse_button_2 = 1
    If spectate = 1 And spectate_stick_to_player = 0
      spectate_stick_to_player = 1
    EndIf
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
  
  If mouse_button_1_released = 1 And spectate = 1
    Define index.l = spectate_player+1
    Define stop.l = 0
    Repeat
      If player_connected(index) = 1 And teamlist(index) > -1 And teamlist(index) < 2
        Break
      EndIf
      index + 1
      If index = 32 And stop = 1
        index = spectate_player
        Break
      EndIf
      If index = 32
        index = 0
        stop = 1
      EndIf
    ForEver
    spectate_player = index
  EndIf
  If mouse_button_2_released = 1 And spectate = 1
    index.l = spectate_player-1
    If index = -1
      index = 31
    EndIf
    stop.l = 0
    Repeat
      If player_connected(index) = 1 And teamlist(index) > -1 And teamlist(index) < 2
        Break
      EndIf
      index - 1
      If index = -1 And stop = 1
        index = spectate_player
        Break
      EndIf
      If index = -1
        index = 31
        stop = 1
      EndIf
    ForEver
    spectate_player = index
  EndIf
  
  If escape_menu = 0
    Define last_camera_rot_x.f = camera_rot_x
    camera_rot_x + mouse_delta_x*0.005
    camera_rot_y - mouse_delta_y*0.005
    
    drunken_camera_roll + (last_camera_rot_x-camera_rot_x)*ReadPreferenceFloat("drunken_cam_factor",25.0)
    If Abs(drunken_camera_roll) <= 0.1
      drunken_camera_roll = 0.0
    Else
      drunken_camera_roll * Pow(0.1,dt)
    EndIf
      
    If camera_rot_y<=0.1
      camera_rot_y = 0.1
    EndIf
    If camera_rot_y>=3.1
      camera_rot_y = 3.1
    EndIf
  EndIf

  Define time = ElapsedMilliseconds()
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
    glViewport_(0, 0, engineWindowWidth(), engineWindowHeight())
  Else
    If GetWindowState(0) = #PB_Window_Normal
      ResizeWindow(0,#PB_Ignore,#PB_Ignore,#PB_Ignore,engineWindowWidth()/16.0*9.0)
    EndIf
    glViewport_(0, 0, engineWindowWidth(), engineWindowHeight())
  EndIf
  glMatrixMode_(#GL_PROJECTION)
  glLoadIdentity_()
  If mouse_button_2 = 1 And own_item = 2
    gluPerspective_(50.0, engineWindowWidth()/engineWindowHeight(), 0.1, 512.0)
  Else
    gluPerspective_(80.0, engineWindowWidth()/engineWindowHeight(), 0.1, 512.0)
  EndIf
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
  
  If ReadPreferenceInteger("drunken_cam",0) = 1
    glRotatef_(drunken_camera_roll,0.0,0.0,1.0)
  EndIf
  
  If spectate = 1
    If spectate_stick_to_player = 1
      Define k
      For k = 0 To 500
        Define look_x.f = getPlayerX(spectate_player)+k*0.01*Sin(camera_rot_x)*Sin(camera_rot_y)
        Define look_y.f = getPlayerY(spectate_player)+k*0.01*Cos(camera_rot_y)
        Define look_z.f = getPlayerZ(spectate_player)+k*0.01*Cos(camera_rot_x)*Sin(camera_rot_y)
        If Not getBlockSafe(look_x,look_y,look_z) = $FFFFFFFF
          look_x.f = getPlayerX(spectate_player)+k*0.01*Sin(camera_rot_x)*Sin(camera_rot_y)
          look_y.f = getPlayerY(spectate_player)+k*0.01*Cos(camera_rot_y)
          look_z.f = getPlayerZ(spectate_player)+k*0.01*Cos(camera_rot_x)*Sin(camera_rot_y)
          Break
        EndIf
      Next
      update_sounds(look_x.f,look_y.f,look_z.f,0.0,0.0,0.0)
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
      
      update_sounds(camera_x,camera_y,camera_z,Sin(camera_rot_x)*Sin(camera_rot_y),Cos(camera_rot_y),Cos(camera_rot_x)*Sin(camera_rot_y))
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
    
    Define vector_x.f = Sin(camera_rot_x)*Sin(camera_rot_y)
    Define vector_y.f = Cos(camera_rot_y)
    Define vector_z.f = Cos(camera_rot_x)*Sin(camera_rot_y)
    
    If own_dead = 0
      positiondata(player_x(own_player_id)+0.5,player_eye_y(own_player_id)-0.4,player_z(own_player_id)+0.5)
      inputdata(key_forward,key_backward,key_left,key_right,key_shift,key_ctrl,key_sneak,key_space)
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
      Define key_states.l = 0
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
      If key_sneak = 1
        key_states + 64
      EndIf
      If key_shift = 1
        key_states + 128
      EndIf
      player_keystates2(own_player_id) = key_states
    EndIf
    gluLookAt_(player_x(own_player_id)+0.5,player_eye_y(own_player_id)+0.75,player_z(own_player_id)+0.5,look_x+0.5,look_y+0.75,look_z+0.5,0.0,1.0,0.0)
    update_sounds(player_x(own_player_id)+0.5,player_eye_y(own_player_id)+0.75,player_z(own_player_id)+0.5,vector_x,vector_y,vector_z)
    glPushMatrix_()
    glLoadIdentity_()
    gluLookAt_(shadowFix(player_x(own_player_id)+0.5+20.0),64.0,shadowFix(player_z(own_player_id)+0.5+70.0),shadowFix(player_x(own_player_id)+0.5),0.0,shadowFix(player_z(own_player_id)+0.5),0.0,1.0,0.0)
    glGetFloatv_(#GL_MODELVIEW_MATRIX, lightViewMatrix)
    glPopMatrix_()
  EndIf
  glGetFloatv_(#GL_MODELVIEW_MATRIX, cameraViewMatrix)
  
  Define offset.f = 0.0
  faced_player = -1
  faced_player_part = -1
  faced_block_x = -1
  faced_block_y = -1
  faced_block_z = -1
  build_block_x = -1
  build_block_y = -1
  build_block_z = -1
  object_distance = 0.0
  Define x_offset.f = 0.0
  Define y_offset.f = 0.0
  Define z_offset.f = 0.0
  If spectate = 0
    x_offset = 0.5
    z_offset = 0.5
    y_offset = 0.75
  EndIf
  Repeat
    look_x.f = cameraPosX()+offset*Sin(camera_rot_x)*Sin(camera_rot_y)+x_offset
    look_y.f = cameraPosY()-2.0+offset*Cos(camera_rot_y)+y_offset
    look_z.f = cameraPosZ()+offset*Cos(camera_rot_x)*Sin(camera_rot_y)+z_offset
    If isBlockSolid(getBlockSafe(Round(look_x,#PB_Round_Down),Round(look_y,#PB_Round_Down),Round(look_z,#PB_Round_Down)))
      faced_block_x = Round(look_x,#PB_Round_Down)
      faced_block_y = Round(look_y,#PB_Round_Down)
      faced_block_z = Round(look_z,#PB_Round_Down)
      look_x = cameraPosX()+(offset-0.2)*Sin(camera_rot_x)*Sin(camera_rot_y)+x_offset
      look_y = cameraPosY()-2.0+(offset-0.2)*Cos(camera_rot_y)+y_offset
      look_z = cameraPosZ()+(offset-0.2)*Cos(camera_rot_x)*Sin(camera_rot_y)+z_offset
      build_block_x = Round(look_x,#PB_Round_Down)
      build_block_y = Round(look_y,#PB_Round_Down)
      build_block_z = Round(look_z,#PB_Round_Down)
      Break
    EndIf
    For k=0 To 31
      If player_connected(k) = 1 And teamlist(k) > -1 And Not k = own_player_id
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
    
  If ReadPreferenceInteger("shadows",0) = 1
    glMatrixMode_(#GL_TEXTURE)
    glScalef_(1.0, -1.0, 1.0)
    glMatrixMode_(#GL_MODELVIEW)
    glPushMatrix_()
    glLoadIdentity_()
    glOrtho_(-64.0,64.0,-64.0,64.0,1.0,128.0)
    glGetFloatv_(#GL_MODELVIEW_MATRIX, lightProjectionMatrix)
    glPopMatrix_()
    
    If depth_texture = -1
      glEnable_(#GL_TEXTURE_2D)
      glGenFramebuffers_(1,@framebuffer)
      glGenTextures_(1,@depth_texture)
      glBindTexture_(#GL_TEXTURE_2D, depth_texture)
      glTexImage2D_(#GL_TEXTURE_2D, 0, #GL_DEPTH_COMPONENT, shadow_map_size, shadow_map_size, 0, #GL_DEPTH_COMPONENT, #GL_UNSIGNED_BYTE, 0)
      glTexParameteri_(#GL_TEXTURE_2D, #GL_TEXTURE_MAG_FILTER, #GL_LINEAR)
      glTexParameteri_(#GL_TEXTURE_2D, #GL_TEXTURE_MIN_FILTER, #GL_LINEAR)
      glTexParameteri_(#GL_TEXTURE_2D, #GL_TEXTURE_WRAP_S, #GL_CLAMP_TO_EDGE)
      glTexParameteri_(#GL_TEXTURE_2D, #GL_TEXTURE_WRAP_T, #GL_CLAMP_TO_EDGE)
      glBindFramebuffer_(#GL_FRAMEBUFFER_EXT, framebuffer)
			glFramebufferTexture2D_(#GL_FRAMEBUFFER_EXT, #GL_DEPTH_ATTACHMENT_EXT, #GL_TEXTURE_2D, depth_texture, 0)
			glBindFramebuffer_(#GL_FRAMEBUFFER_EXT, 0)
      glBindTexture_(#GL_TEXTURE_2D, 0)
      glDisable_(#GL_TEXTURE_2D)
    EndIf
    
    glBindTexture_(#GL_TEXTURE_2D, 0)
    glViewport_(0, 0, shadow_map_size, shadow_map_size)
    glBindFramebuffer_(#GL_FRAMEBUFFER_EXT, framebuffer)
    
    glLoadIdentity_()
    glClear_(#GL_COLOR_BUFFER_BIT | #GL_DEPTH_BUFFER_BIT)
    glMatrixMode_(#GL_PROJECTION)
    glLoadMatrixf_(lightProjectionMatrix)
    glMatrixMode_(#GL_MODELVIEW)
    glLoadMatrixf_(lightViewMatrix)
    glCullFace_(#GL_FRONT)
    glColorMask_(#GL_FALSE, #GL_FALSE, #GL_FALSE, #GL_FALSE)
    glDisable_(#GL_FOG)
    
    glBindFramebuffer_(#GL_FRAMEBUFFER_EXT, framebuffer)
    ;glEnable_(#GL_POLYGON_OFFSET_FILL)
    ;glPolygonOffset_(16.0,1.0)
    drawScene(dt,1)
    ;glDisable_(#GL_POLYGON_OFFSET_FILL)
    glBindFramebuffer_(#GL_FRAMEBUFFER_EXT, 0)
    
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
    glViewport_(0, 0, engineWindowWidth(), engineWindowHeight())
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
    glMatrixMode_(#GL_TEXTURE)
    glScalef_(1.0, -1.0, 1.0)
    glMatrixMode_(#GL_MODELVIEW)
  Else
    drawScene(dt,0)
  EndIf
  
  If spectate = 0
    Define x.f = player_x(own_player_id)
    Define y.f = player_y(own_player_id)
    Define z.f = player_z(own_player_id)
    Define angle.f = player_angle_y(own_player_id)
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
      Define delta.f = (ElapsedMilliseconds()-player_last_shot(own_player_id))/shot_times(own_weapon)*#PI/2.0
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
  
  If Not own_player_id = -1 And player_dead(own_player_id) = 1 And (ElapsedMilliseconds()-player_death_time(own_player_id))>1000 And player_secounds_till_respawn(own_player_id) > 0
    player_secounds_till_respawn(own_player_id) - 1
    If player_secounds_till_respawn(own_player_id) = 0
      createSoundSourceAtCamera(29)
    Else
      createSoundSourceAtCamera(30)
    EndIf
    player_death_time(own_player_id) = ElapsedMilliseconds()
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
	
 glBindTexture_(#GL_TEXTURE_2D,texture_vignette)
 drawRect(0,0,engineWindowWidth(),engineWindowHeight())
 glBindTexture_(#GL_TEXTURE_2D,0)
	
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
    
    Structure Player
      name$
      kills.l
      id.l
    EndStructure
    
    NewList Team.Player()
    
    For k = 0 To 31
      If player_connected(k) = 1 And teamlist(k) = 0
        AddElement(Team())
        Team()\name$ = namelist(k)
        Team()\kills = player_kills(k)
        Team()\id = k
      EndIf
    Next
    
    SortStructuredList(Team(),#PB_Sort_Descending,OffsetOf(Player\kills),#PB_Long)
    
    Define index.l = 0
    ForEach Team()
      If player_dead(Team()\id)
        glColor3f_(1.0,0.2,0.2)
      Else
        glColor3f_(1.0,1.0,1.0)
      EndIf
      If Team()\id = team_1_intel_player Or Team()\id = team_2_intel_player
        glBindTexture_(#GL_TEXTURE_2D,texture_intel)
        drawRect(engineWindowWidth()*0.125-engineWindowHeight()*0.06,engineWindowHeight()*0.25+engineWindowHeight()*0.04*index,engineWindowHeight()*0.04,engineWindowHeight()*0.04)
      EndIf
      drawString(engineWindowWidth()*0.125,engineWindowHeight()*0.25+engineWindowHeight()*0.04*index,engineWindowHeight()*0.04,Team()\name$)
      drawString(engineWindowWidth()*0.3,engineWindowHeight()*0.25+engineWindowHeight()*0.04*index,engineWindowHeight()*0.04,"#"+Str(Team()\id))
      drawString(engineWindowWidth()*0.35,engineWindowHeight()*0.25+engineWindowHeight()*0.04*index,engineWindowHeight()*0.04,Str(Team()\kills))
      index + 1
    Next
    
    ClearList(Team())
    
    For k = 0 To 31
      If player_connected(k) = 1 And teamlist(k) = 1
        AddElement(Team())
        Team()\name$ = namelist(k)
        Team()\kills = player_kills(k)
        Team()\id = k
      EndIf
    Next
    
    SortStructuredList(Team(),#PB_Sort_Descending,OffsetOf(Player\kills),#PB_Long)
    
    index = 0
    ForEach Team()
      If player_dead(Team()\id)
        glColor3f_(1.0,0.2,0.2)
      Else
        glColor3f_(1.0,1.0,1.0)
      EndIf
      If Team()\id = team_1_intel_player Or Team()\id = team_2_intel_player
        glBindTexture_(#GL_TEXTURE_2D,texture_intel)
        drawRect(engineWindowWidth()*0.625-engineWindowHeight()*0.06,engineWindowHeight()*0.25+engineWindowHeight()*0.04*index,engineWindowHeight()*0.04,engineWindowHeight()*0.04)
      EndIf
      drawString(engineWindowWidth()*0.625,engineWindowHeight()*0.25+engineWindowHeight()*0.04*index,engineWindowHeight()*0.04,Team()\name$)
      drawString(engineWindowWidth()*0.8,engineWindowHeight()*0.25+engineWindowHeight()*0.04*index,engineWindowHeight()*0.04,"#"+Str(Team()\id))
      drawString(engineWindowWidth()*0.85,engineWindowHeight()*0.25+engineWindowHeight()*0.04*index,engineWindowHeight()*0.04,Str(Team()\kills))
      index + 1
    Next
    
    glColor3f_(1.0,1.0,1.0)
    index = 0
    For k = 0 To 31
      If player_connected(k) = 1 And teamlist(k) = -1
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
    
    If spectate_stick_to_player = 0 Or spectate = 0
      glBindTexture_(#GL_TEXTURE_2D,texture_target)
      drawRect((engineWindowWidth()-engineWindowHeight()*0.015)/2,(engineWindowHeight()-engineWindowHeight()*0.015)/2,engineWindowWidth()*0.015,engineWindowWidth()*0.015)
      glBindTexture_(#GL_TEXTURE_2D,0)
    EndIf
    
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
    
    If own_team = -1 Or own_team = teamlist(faced_player)
      Define s$ = ""
      If Not faced_player = -1
        s$ = namelist(faced_player)+" #"+Str(faced_player)
      EndIf
      If spectate_stick_to_player = 1
        s$ = namelist(spectate_player)+" #"+Str(spectate_player)
      EndIf
      If Not s$ = ""
        glColor3f_(1.0,1.0,1.0)
        drawString((engineWindowWidth()-stringWidth(engineWindowHeight()*0.04,s$))*0.5,engineWindowHeight()-engineWindowHeight()*0.12,engineWindowHeight()*0.04,s$)
      EndIf
     EndIf
    
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
    
    	
    If map_loaded = 1 And display_list_created = 1 And key_tab = 0
      glColor3f_(1.0,1.0,1.0)
      glBindTexture_(#GL_TEXTURE_2D,map_texture_id)
      If key_m = 1
        drawRect((engineWindowWidth()-engineWindowHeight()*0.8)*0.5,engineWindowHeight()*0.1,engineWindowHeight()*0.8,engineWindowHeight()*0.8)
        If game_mode = #GAMEMODE_TC
          glBindTexture_(#GL_TEXTURE_2D,texture_command)
          Define k
          For k=0 To tent_count-1
            If tent_team(k) = 2
              glColor3f_(1.0,1.0,1.0)
            EndIf
            If tent_team(k) = 0
              glColor3f_(team_1_red/255.0,team_1_green/255.0,team_1_blue/255.0)
            EndIf
            If tent_team(k) = 1
              glColor3f_(team_2_red/255.0,team_2_green/255.0,team_2_blue/255.0)
            EndIf
            drawRect((engineWindowWidth()-engineWindowHeight()*0.8)*0.5+engineWindowHeight()*0.8/512.0*tent_x(k)-engineWindowHeight()*0.01,engineWindowHeight()*0.1+engineWindowHeight()*0.8/512.0*tent_z(k)-engineWindowHeight()*0.01,engineWindowHeight()*0.02,engineWindowHeight()*0.02)
          Next
        EndIf
        
        If game_mode = #GAMEMODE_CTF
          glBindTexture_(#GL_TEXTURE_2D,texture_intel)
          glColor3f_(team_1_red/255.0,team_1_green/255.0,team_1_blue/255.0)
          drawRect((engineWindowWidth()-engineWindowHeight()*0.8)*0.5+engineWindowHeight()*0.8/512.0*team_1_intel_x-engineWindowHeight()*0.01,engineWindowHeight()*0.1+engineWindowHeight()*0.8/512.0*team_1_intel_z-engineWindowHeight()*0.01,engineWindowHeight()*0.02,engineWindowHeight()*0.02)
          glColor3f_(team_2_red/255.0,team_2_green/255.0,team_2_blue/255.0)
          drawRect((engineWindowWidth()-engineWindowHeight()*0.8)*0.5+engineWindowHeight()*0.8/512.0*team_2_intel_x-engineWindowHeight()*0.01,engineWindowHeight()*0.1+engineWindowHeight()*0.8/512.0*team_2_intel_z-engineWindowHeight()*0.01,engineWindowHeight()*0.02,engineWindowHeight()*0.02)
          glBindTexture_(#GL_TEXTURE_2D,texture_medical)
          glColor3f_(team_1_red/255.0,team_1_green/255.0,team_1_blue/255.0)
          drawRect((engineWindowWidth()-engineWindowHeight()*0.8)*0.5+engineWindowHeight()*0.8/512.0*team_1_base_x-engineWindowHeight()*0.01,engineWindowHeight()*0.1+engineWindowHeight()*0.8/512.0*team_1_base_z-engineWindowHeight()*0.01,engineWindowHeight()*0.02,engineWindowHeight()*0.02)
          glColor3f_(team_2_red/255.0,team_2_green/255.0,team_2_blue/255.0)
          drawRect((engineWindowWidth()-engineWindowHeight()*0.8)*0.5+engineWindowHeight()*0.8/512.0*team_2_base_x-engineWindowHeight()*0.01,engineWindowHeight()*0.1+engineWindowHeight()*0.8/512.0*team_2_base_z-engineWindowHeight()*0.01,engineWindowHeight()*0.02,engineWindowHeight()*0.02)
        EndIf
        
        glBindTexture_(#GL_TEXTURE_2D,texture_player)
        For k=0 To 32
          If player_connected(k) = 1 And player_dead(k) = 0 And teamlist(k) > -1 And teamlist(k) < 2 And (teamlist(k) = own_team Or own_team = -1) And Not k = own_player_id
            If teamlist(k) = 0
              glColor3f_(team_1_red/255.0,team_1_green/255.0,team_1_blue/255.0)
            EndIf
            If teamlist(k) = 1
              glColor3f_(team_2_red/255.0,team_2_green/255.0,team_2_blue/255.0)
            EndIf
            drawRectRotated((engineWindowWidth()-engineWindowHeight()*0.8)*0.5+engineWindowHeight()*0.8/512.0*player_x(k)-engineWindowHeight()*0.01,engineWindowHeight()*0.1+engineWindowHeight()*0.8/512.0*player_z(k)-engineWindowHeight()*0.01,engineWindowHeight()*0.02,engineWindowHeight()*0.02,Degree(ATan2(player_angle_x(k),player_angle_z(k)))+90.0)
          EndIf
        Next
        glColor3f_(0.0,1.0,1.0)
        drawRectRotated((engineWindowWidth()-engineWindowHeight()*0.8)*0.5+engineWindowHeight()*0.8/512.0*cameraPosX()-engineWindowHeight()*0.01,engineWindowHeight()*0.1+engineWindowHeight()*0.8/512.0*cameraPosZ()-engineWindowHeight()*0.01,engineWindowHeight()*0.02,engineWindowHeight()*0.02,Degree(-camera_rot_x)+180.0)
      Else
        drawRectSub(engineWindowWidth()-engineWindowHeight()*0.31,engineWindowHeight()*0.01,engineWindowHeight()*0.3,engineWindowHeight()*0.3,Round((cameraPosX()/512.0-0.1)/0.001953125,#PB_Round_Nearest)*0.001953125,Round((cameraPosZ()/512.0-0.1)/0.001953125,#PB_Round_Nearest)*0.001953125,0.2,0.2)
      EndIf
      glBindTexture_(#GL_TEXTURE_2D,0)
    EndIf
    
    If escape_menu = 1
      Select screen
        Case 0:
          glColor3f_(1.0,0.0,0.0)
          drawString((engineWindowWidth()-stringWidth(engineWindowHeight()*0.1,"Exit game? y/n"))/2,(engineWindowHeight()-engineWindowHeight()*0.1)/2,engineWindowHeight()*0.1,"Exit game? y/n")
          Define mx.l = WindowMouseX(0)
          Define my.l = WindowMouseY(0)
          Define button = 0
          If mx>engineWindowWidth()*0.05 And mx<engineWindowWidth()*0.05+engineWindowWidth()*0.3
            If my>engineWindowHeight()-engineWindowHeight()*0.2 And my<engineWindowHeight()-engineWindowHeight()*0.2+engineWindowHeight()*0.1
              button = 1
            EndIf
            If my>engineWindowHeight()-engineWindowHeight()*0.3125 And my<engineWindowHeight()-engineWindowHeight()*0.3125+engineWindowHeight()*0.1
              button = 2
            EndIf
            If my>engineWindowHeight()-engineWindowHeight()*0.425 And my<engineWindowHeight()-engineWindowHeight()*0.425+engineWindowHeight()*0.1
              button = 3
            EndIf
          EndIf
          If event = #PB_Event_LeftClick
            Select button
              Case 1:
                shutdown_game()
              Case 2:
                screen = 1
            EndSelect
          EndIf
          glBindTexture_(#GL_TEXTURE_2D,0)
          If button = 1 : glColor3f_(1.0,0.75,0.125) : Else : glColor3f_(1.0*0.9,0.75*0.9,0.125*0.9) : EndIf
          drawRect(engineWindowWidth()*0.05,engineWindowHeight()-engineWindowHeight()*0.2,engineWindowWidth()*0.3,engineWindowHeight()*0.1)
          If button = 2 : glColor3f_(1.0,0.75,0.125) : Else : glColor3f_(1.0*0.9,0.75*0.9,0.125*0.9) : EndIf
          drawRect(engineWindowWidth()*0.05,engineWindowHeight()-engineWindowHeight()*0.3125,engineWindowWidth()*0.3,engineWindowHeight()*0.1)
          If button = 3 : glColor3f_(1.0,0.75,0.125) : Else : glColor3f_(1.0*0.9,0.75*0.9,0.125*0.9) : EndIf
          drawRect(engineWindowWidth()*0.05,engineWindowHeight()-engineWindowHeight()*0.425,engineWindowWidth()*0.3,engineWindowHeight()*0.1)
          glColor3f_(1.0,1.0,1.0)
          drawString(engineWindowWidth()*0.1,engineWindowHeight()-engineWindowHeight()*0.18,engineWindowHeight()*0.06,"Exit game")
          drawString(engineWindowWidth()*0.1,engineWindowHeight()-engineWindowHeight()*0.2925,engineWindowHeight()*0.06,"Change team")
          drawString(engineWindowWidth()*0.1,engineWindowHeight()-engineWindowHeight()*0.405,engineWindowHeight()*0.06,"Change weapon")
        Case 1:
          glBindTexture_(#GL_TEXTURE_2D,0)
          glColor3f_(team_1_red/255.0,team_1_green/255.0,team_1_blue/255.0)
          drawRect(engineWindowWidth()*0.05,engineWindowHeight()-engineWindowHeight()*0.2,engineWindowWidth()*0.3,engineWindowHeight()*0.1)
          glColor3f_(team_2_red/255.0,team_2_green/255.0,team_2_blue/255.0)
          drawRect(engineWindowWidth()-engineWindowWidth()*0.35,engineWindowHeight()-engineWindowHeight()*0.2,engineWindowWidth()*0.3,engineWindowHeight()*0.1)
          glColor3f_(1.0,1.0,1.0)
          drawString(engineWindowWidth()*0.1,engineWindowHeight()-engineWindowHeight()*0.18,engineWindowHeight()*0.06,"Join "+team_1_name.s)
          drawString(engineWindowWidth()-engineWindowWidth()*0.3,engineWindowHeight()-engineWindowHeight()*0.18,engineWindowHeight()*0.06,"Join "+team_2_name.s)
       EndSelect
    EndIf
    
        
    If Not own_player_id = -1 And player_dead(own_player_id) = 1 And Not own_team = -1
      glColor3f_(1.0,0.0,0.0)
      Define wtime.l = player_secounds_till_respawn(own_player_id)
      If wtime < 0
        wtime = 0
      EndIf
      Define s$ = "INSERT COIN: "+Str(wtime)
      drawString((engineWindowWidth()-stringWidth(engineWindowHeight()*0.1,s$))*0.5,engineWindowHeight()-engineWindowHeight()*0.2,engineWindowHeight()*0.1,s$)
    EndIf
    
    Define tent.l = nearestTent(cameraPosX(),cameraPosY(),cameraPosZ())
    If tent >= 0
      debug_message.s = Str(action_lock-ElapsedMilliseconds())+"ms lock | "+Str(fps)+"fps"+" | "+Str(particles_used)+"particles"+" | "+StrF(tent_progress(tent))
    Else
      debug_message.s = Str(action_lock-ElapsedMilliseconds())+"ms lock | "+Str(fps)+"fps"+" | "+Str(particles_used)+"particles"+" | no tent near"+StrF((ElapsedMilliseconds()-last_damage_source_time)/3000.0)
    EndIf
    glColor3f_(1.0,1.0,1.0)
    drawString((engineWindowWidth()-stringWidth(engineWindowHeight()*0.04,debug_message.s))*0.5,0.0,engineWindowHeight()*0.04,debug_message.s)
    
    If spectate = 0
      If own_hp > 30
        glColor3f_(1.0,1.0,1.0)
      Else
        glColor3f_(1.0,0.0,0.0)
      EndIf
      drawString((engineWindowWidth()-stringWidth(engineWindowHeight()*0.05,Str(own_hp)+" HP"))/2,engineWindowHeight()-engineWindowHeight()*0.075,engineWindowHeight()*0.05,Str(own_hp)+" HP")
      
      glColor3f_(1.0,1.0,1.0)
      If last_damage_source_type = #DAMAGE_SOURCE_WEAPON And ElapsedMilliseconds()-last_damage_source_time<3000
        glBindTexture_(#GL_TEXTURE_2D,texture_indicator)
        glColor4f_(1.0,1.0,1.0,1.0-(ElapsedMilliseconds()-last_damage_source_time)/3000.0)
        Define direction.f = 360.0-((360.0-(Degree(ATan2(cameraPosX()-last_damage_source_x,cameraPosZ()-last_damage_source_z))+180.0)-90.0)-(Degree(camera_rot_x)-Int(Degree(camera_rot_x)/360.0)*360.0)+180.0)
        drawRectRotated((engineWindowWidth()-engineWindowWidth()*0.15)/2,(engineWindowHeight()-engineWindowWidth()*0.15)/2,engineWindowWidth()*0.15,engineWindowWidth()*0.15,direction)
        glBindTexture_(#GL_TEXTURE_2D,0)
        glColor4f_(1.0,1.0,1.0,1.0)
      EndIf
    EndIf
  EndIf
    
	glDisable_(#GL_TEXTURE_2D)
	glEnable_(#GL_CULL_FACE)
	glDepthMask_(#GL_TRUE)
	glEnable_(#GL_DEPTH_TEST)
  
	If map_loaded = 1 And display_list_created = 0
	  Define chunk_x,chunk_z
    For chunk_z = 0 To 63
      For chunk_x = 0 To 63
        display_list_update_flag(chunk_x,chunk_z) = 0
        glDeleteLists_(display_list_ids(chunk_x,chunk_z),1)
        display_list_ids(chunk_x,chunk_z) = glGenLists_(1)
        glNewList_(display_list_ids(chunk_x,chunk_z),#GL_COMPILE)
        glEnableClientState_(#GL_COLOR_ARRAY)
        glEnableClientState_(#GL_VERTEX_ARRAY)
        ;glEnableClientState_(#GL_TEXTURE_COORD_ARRAY)
        drawChunk(chunk_x,chunk_z,0)
        ;glDisableClientState_(#GL_TEXTURE_COORD_ARRAY)
        glDisableClientState_(#GL_VERTEX_ARRAY)
        glDisableClientState_(#GL_COLOR_ARRAY)
        glEndList_()
        glDeleteLists_(display_list_ids_shadowed(chunk_x,chunk_z),1)
        display_list_ids_shadowed(chunk_x,chunk_z) = glGenLists_(1)
        glNewList_(display_list_ids_shadowed(chunk_x,chunk_z),#GL_COMPILE)
        glEnableClientState_(#GL_COLOR_ARRAY)
        glEnableClientState_(#GL_VERTEX_ARRAY)
        ;glEnableClientState_(#GL_TEXTURE_COORD_ARRAY)
        drawChunk(chunk_x,chunk_z,1)
        ;glDisableClientState_(#GL_TEXTURE_COORD_ARRAY)
        glDisableClientState_(#GL_VERTEX_ARRAY)
        glDisableClientState_(#GL_COLOR_ARRAY)
        glEndList_()
      Next
    Next
    
  	display_list_created = 1
  EndIf
EndProcedure

Procedure drawScene(dt.f,shadowed.l)
  If map_loaded = 1 And display_list_created = 1
    Define chunk_x,chunk_z
    Define overview_update_needed.l = 0
     For chunk_z = 0 To 63
       For chunk_x = 0 To 63
         If display_list_update_flag(chunk_x,chunk_z) = 1
           
           glDeleteLists_(display_list_ids(chunk_x,chunk_z),1)
           glDeleteLists_(display_list_ids_shadowed(chunk_x,chunk_z),1)
           
           display_list_ids(chunk_x,chunk_z) = glGenLists_(1)
           glNewList_(display_list_ids(chunk_x,chunk_z),#GL_COMPILE)
           glEnableClientState_(#GL_COLOR_ARRAY)
           glEnableClientState_(#GL_VERTEX_ARRAY)
           ;glEnableClientState_(#GL_TEXTURE_COORD_ARRAY)
           drawChunk(chunk_x,chunk_z,0)
           ;glDisableClientState_(#GL_TEXTURE_COORD_ARRAY)
           glDisableClientState_(#GL_VERTEX_ARRAY)
           glDisableClientState_(#GL_COLOR_ARRAY)
           glEndList_()
           
           display_list_ids_shadowed(chunk_x,chunk_z) = glGenLists_(1)
           glNewList_(display_list_ids_shadowed(chunk_x,chunk_z),#GL_COMPILE)
           glEnableClientState_(#GL_COLOR_ARRAY)
           glEnableClientState_(#GL_VERTEX_ARRAY)
           ;glEnableClientState_(#GL_TEXTURE_COORD_ARRAY)
           drawChunk(chunk_x,chunk_z,1)
           ;glDisableClientState_(#GL_TEXTURE_COORD_ARRAY)
           glDisableClientState_(#GL_VERTEX_ARRAY)
           glDisableClientState_(#GL_COLOR_ARRAY)
           glEndList_()
           
           display_list_update_flag(chunk_x,chunk_z) = 0
           overview_update_needed = 1
         EndIf
       Next
     Next
     
    If overview_update_needed = 1 Or map_texture_id = -1
      If Not map_texture_id = -1
        updateTextureFromImage(map_texture_id,map_overview_tmp_image)
      Else   
        map_texture_id = loadTextureFromImage(map_overview_tmp_image,0,0,0,0,0)
      EndIf
    EndIf
     
    If spectate = 1
      If spectate_stick_to_player = 1
        Define chunk_start_x = Int(getPlayerX(spectate_player)/8.0)
        Define chunk_start_z = Int(getPlayerZ(spectate_player)/8.0)
      Else
        Define chunk_start_x = Int(camera_x/8.0)
        Define chunk_start_z = Int(camera_z/8.0)
      EndIf
    Else
      chunk_start_x = Int(player_x(own_player_id)/8.0)
      chunk_start_z = Int(player_z(own_player_id)/8.0)
    EndIf
    ;glEnable_(#GL_TEXTURE_2D)
    ;glBindTexture_(#GL_TEXTURE_2D,texture_noise)
    ;If shadowed = 1
    ;glUseProgram_(program)
    ;var.s = "time"
    ;glUniform1f_(glGetUniformLocation_(program.l,@var),ElapsedMilliseconds()/1000.0)
    ;EndIf
     For chunk_z = chunk_start_z-16 To chunk_start_z+16
       For chunk_x = chunk_start_x-16 To chunk_start_x+16
         Define a.l = Int(Mod(chunk_x,64))
         Define b.l = Int(Mod(chunk_z,64))
         ;glPushMatrix_()
         ;If a<0
           ;a = 64+a
           ;glTranslatef_(512.0,0.0,0.0)
         ;EndIf
         ;If b<0
           ;b = 64+b
           ;glTranslatef_(0.0,0.0,512.0)
         ;EndIf
         ;If a>63
           ;a - 64
           ;glTranslatef_(-512.0,0.0,0.0)
         ;EndIf
         ;If b>63
           ;b - 64
           ;glTranslatef_(0.0,0.0,-512.0)
           ;EndIf
         If chunk_x>=0 And chunk_z>=0 And chunk_x<64 And chunk_z<64
          If shadowed = 0
            glCallList_(display_list_ids(a,b))
          Else
            glCallList_(display_list_ids_shadowed(a,b))
          EndIf
         EndIf
         ;glPopMatrix_()
       Next
     Next
     ;glBindTexture_(#GL_TEXTURE_2D,0)
     ;glDisable_(#GL_TEXTURE_2D)
     ;If shadowed = 1
      ;glUseProgram_(0)
    ;EndIf
   EndIf
   
   Define k
  For k=0 To 32
    If player_connected(k) = 1 And teamlist(k) > -1 And Not k = own_player_id
      If dt > 0.0
        updatePlayer(k,dt)
      EndIf
      renderplayer(k,shadowed)
    EndIf
    If grenade_alive(k) = 1
      If dt > 0.0
        updateGrenade(k,dt)
      EndIf
      renderGrenade(k)
    EndIf
  Next
  
  renderParticles(dt,shadowed,cameraPosX(),cameraPosY(),cameraPosZ())
  glBegin_(#GL_QUADS)
  updateFallingBlocks(dt)
  glEnd_()
  
  If Not own_player_id = -1 And player_draw_line(own_player_id) = 1 And Not build_block_x = -1 And object_distance < 4.0
    Define count.l = cube_line_native(own_line_start_x,own_line_start_z,64-own_line_start_y,build_block_x,build_block_z,64-build_block_y)
    Define i.l
    glPolygonMode_(#GL_FRONT_AND_BACK,#GL_LINE)
    glBegin_(#GL_QUADS)
    glColor4f_(1.0,1.0,1.0,1.0)
    For i=0 To count-1
      If count > player_blocks(own_player_id)
        glColor4f_(1.0,0.0,0.0,1.0)
      EndIf
      rendercubeat(cube_line_x(i),cube_line_y(i),cube_line_z(i),1.0,1.0,1.0)
    Next
    glEnd_()
    glPolygonMode_(#GL_FRONT_AND_BACK,#GL_FILL)
  EndIf
  
  
  Define tmp_x.f = cameraPosX()+2.0*Sin(camera_rot_x)*Sin(camera_rot_y)
  Define tmp_y.f = cameraPosY()+2.0*Cos(camera_rot_y)
  Define tmp_z.f = cameraPosZ()+2.0*Cos(camera_rot_x)*Sin(camera_rot_y)
  
;   glPushMatrix_()
;   glTranslatef_(tmp_x,tmp_y,tmp_z)
;   glScalef_(0.5,0.5,0.5)
;   glDepthRange_(0.0,0.2)
;   glRotatef_(-Degree(ATan2(Sin(camera_rot_x)*Sin(camera_rot_y),Cos(camera_rot_x)*Sin(camera_rot_y))),0.0,1.0,0.0)
;   glRotatef_(-(Degree(ACos(Cos(camera_rot_y)/Sqr(Sin(camera_rot_x)*Sin(camera_rot_y)*Sin(camera_rot_x)*Sin(camera_rot_y)+Cos(camera_rot_y)*Cos(camera_rot_y)+Cos(camera_rot_x)*Sin(camera_rot_y)*Cos(camera_rot_x)*Sin(camera_rot_y))))-90.0),0.0,0.0,1.0)
;   glTranslatef_(5.0,-2.5,-6.0)
;   glPushMatrix_()
;   glRotatef_(ElapsedMilliseconds()/10.0,0.0,1.0,0.0)
;   glTranslatef_(-kv6_sx(kv6_semi)*0.125,-kv6_sy(kv6_semi)*0.125,-kv6_sz(kv6_semi)*0.125)
;   glCallList_(kv6_semi)
;   glPopMatrix_()
;   glTranslatef_(0.0,0.0,5.0)
;   glPushMatrix_()
;   glRotatef_(ElapsedMilliseconds()/10.0,0.0,1.0,0.0)
;   glTranslatef_(-kv6_sx(kv6_smg)*0.125,-kv6_sy(kv6_smg)*0.125,-kv6_sz(kv6_smg)*0.125)
;   glCallList_(kv6_smg)
;   glPopMatrix_()
;   glTranslatef_(0.0,0.0,5.0)
;   glPushMatrix_()
;   glRotatef_(ElapsedMilliseconds()/10.0,0.0,1.0,0.0)
;   glTranslatef_(-kv6_sx(kv6_shotgun)*0.125,-kv6_sy(kv6_shotgun)*0.125,-kv6_sz(kv6_shotgun)*0.125)
;   glCallList_(kv6_shotgun)
;   glPopMatrix_()
;   glDepthRange_(0.0,1.0)
;   glPopMatrix_()
  
  
  If shadowed = 1
    ;renderplayer(own_player_id,shadowed)
  EndIf
  
  If Not own_player_id = -1 And player_item(own_player_id) = 1 And Not build_block_x = -1 And object_distance < 4.0
    glPolygonMode_(#GL_FRONT_AND_BACK,#GL_LINE)
    glBegin_(#GL_QUADS)
    glColor4f_(1.0,1.0,1.0,1.0)
    rendercubeat(build_block_x,build_block_y,build_block_z,1.0,1.0,1.0)
    glEnd_()
    glPolygonMode_(#GL_FRONT_AND_BACK,#GL_FILL)
  EndIf
;   
   position_time = ElapsedMilliseconds()
;   
  Define time = ElapsedMilliseconds()
  glColor3f_(1.0,1.0,0.0)
  For k=0 To 511
    If tracer_used(k) = 1
      glPushMatrix_()
      glTranslatef_(tracer_x(k),tracer_y(k),tracer_z(k))
      glRotatef_(-Degree(ATan2(tracer_speed_x(k),tracer_speed_z(k))),0.0,1.0,0.0)
      ;glRotatef_(-(Degree(ACos(tracer_speed_y(id)/Sqr(tracer_speed_x(id)*tracer_speed_x(id)+tracer_speed_y(id)*tracer_speed_y(id)+tracer_speed_z(id)*tracer_speed_z(id))))-90.0),0.0,0.0,1.0)
      glBegin_(#GL_QUADS)
      glColor3f(1.0,1.0,0.0)
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
  
  last_tracer_update = ElapsedMilliseconds()
  
  If game_mode = #GAMEMODE_CTF
    glPushMatrix_()
    glTranslatef_(team_1_base_x-1.0,team_1_base_y+0.75,team_1_base_z-0.75)
    glCallList_(kv6_cp)
    glPopMatrix_()
    glPushMatrix_()
    glTranslatef_(team_2_base_x-1.0,team_2_base_y+0.75,team_2_base_z-0.75)
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
  EndIf
  If game_mode = #GAMEMODE_TC
    Define k
    For k=0 To tent_count-1
      glPushMatrix_()
      glTranslatef_(tent_x(k)-1.0,tent_y(k)+0.75,tent_z(k)-0.75)
      glCallList_(kv6_cp+tent_team(k))
      glPopMatrix_()
    Next
  EndIf
EndProcedure
; IDE Options = PureBasic 5.31 (Windows - x86)
; CursorPosition = 1130
; FirstLine = 314
; Folding = AQg7
; EnableUnicode
; EnableXP
; UseMainFile = main.pb
; Executable = aos.exe
; DisableDebugger
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant