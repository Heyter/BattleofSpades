UsePNGImageDecoder()

Global Dim kill_type.s(7)
kill_type(0) = "Weapon"
kill_type(1) = "Headshot"
kill_type(2) = "Spade"
kill_type(3) = "Grenade"
kill_type(4) = "Fall"
kill_type(5) = "Team change"
kill_type(6) = "Weapon change"

Global Dim weapon_type.s(3)
weapon_type(0) = "Rifle"
weapon_type(1) = "SMG"
weapon_type(2) = "Shotgun"

Global Dim shot_times.l(32) ;(in ms)
shot_times(0) = 500  ;semi
shot_times(1) = 100  ;smg
shot_times(2) = 1000 ;shotgun

Global Dim mag_size.l(3)
mag_size(0) = 10 ;semi
mag_size(1) = 30 ;smg
mag_size(2) = 6  ;shotgun

Global Dim max_ammo.l(3)
max_ammo(0) = 50 ;semi
max_ammo(1) = 120 ;smg
max_ammo(2) = 48  ;shotgun

Global spectate.l = 1
Global spectate_stick_to_player.l = 0
Global spectate_player.l = 0

Global debug_message.s

Global faced_player.l = -1
Global faced_player_part.l = -1
Global faced_block_x.l = -1
Global faced_block_y.l = -1
Global faced_block_z.l = -1
Global build_block_x.l = -1
Global build_block_y.l = -1
Global build_block_z.l = -1
Global object_distance.f = 0.0

Declare sendHitPacket(id.l,type.l)
Declare sendBlockActionPacket(action.l, x.l, y.l, z.l)
Declare sendGrenade(x.f, y.f, z.f, defuse_time.l)

Procedure setDebug(text$)
  debug_message = text$
EndProcedure

XIncludeFile "OpenGL.pbi"
XIncludeFile "matrix.pb"

Global Dim current_color.f(4)
Procedure glColor3f(red.f,green.f,blue.f)
  glColor3f_(red,green,blue)
  current_color(0) = red
  current_color(1) = green
  current_color(2) = blue
  current_color(3) = 1.0
EndProcedure
Procedure glColor4f(red.f,green.f,blue.f,alpha.f)
  glColor4f_(red,green,blue,alpha)
  current_color(0) = red
  current_color(1) = green
  current_color(2) = blue
  current_color(3) = alpha
EndProcedure
Procedure rendercubeat(x.f,y.f,z.f,sx.f,sy.f,sz.f)
  
  red.f = current_color(0)
  green.f = current_color(1)
  blue.f = current_color(2)
  alpha.f = current_color(3)
  
  ;glNormal3f_ (0.0,0.0,1.0)
  
  glColor4f_ (red*0.7,green*0.7,blue*0.7,alpha)
  glVertex3f_ (sx+x,sy+y,sz+z)          
  glVertex3f_ (0.0+x,sy+y,sz+z)
  glVertex3f_ (0.0+x,0.0+y,sz+z)
  glVertex3f_ (sx+x,0.0+y,sz+z) 

  ;glNormal3f_ (0.0,0.0,-1.0)
  
  glVertex3f_ (0.0+x,0.0+y,0.0+z)
  glVertex3f_ (0.0+x,sy+y,0.0+z)
  glVertex3f_ (sx+x,sy+y,0.0+z)
  glVertex3f_ (sx+x,0.0+y,0.0+z)

  ;glNormal3f_ (0.0,1.0,0.0)
  
  glColor4f_ (red,green,blue,alpha)
  glVertex3f_ (sx+x,sy+y,sz+z)
  glVertex3f_ (sx+x,sy+y,0.0+z)
  glVertex3f_ (0.0+x,sy+y,0.0+z)
  glVertex3f_ (0.0+x,sy+y,sz+z)

  ;glNormal3f_ (0.0,-1.0,0.0)
  
  glColor4f_ (red*0.5,green*0.5,blue*0.5,alpha)
  glVertex3f_ (0.0+x,0.0+y,0.0+z)
  glVertex3f_ (sx+x,0.0+y,0.0+z)
  glVertex3f_ (sx+x,0.0+y,sz+z)
  glVertex3f_ (0.0+x,0.0+y,sz+z)

  ;glNormal3f_ (1.0,0.0,0.0)
  
  glColor4f_ (red*0.9,green*0.9,blue*0.9,alpha)
  glVertex3f_ (sx+x,sy+y,sz+z)
  glVertex3f_ (sx+x,0.0+y,sz+z)
  glVertex3f_ (sx+x,0.0+y,0.0+z)
  glVertex3f_ (sx+x,sy+y,0.0+z)

  ;glNormal3f_ (-1.0,0.0,0.0)
  
  glVertex3f_ (0.0+x,0.0+y,0.0+z)
  glVertex3f_ (0.0+x,0.0+y,sz+z)
  glVertex3f_ (0.0+x,sy+y,sz+z)
  glVertex3f_ (0.0+x,sy+y,0.0+z)
EndProcedure


XIncludeFile "Texture.pb"
XIncludeFile "3DSound.pb"
XIncludeFile "Map.pb"
XIncludeFile "grenade.pb"
XIncludeFile "Player.pb"
XIncludeFile "ZLIB.pb"
XIncludeFile "NetworkThread.pb"

Procedure.l writeVertexToBuffer(buffer.l, x.f, y.f, z.f)
  PokeF(buffer,x)
  PokeF(buffer+4,y)
  PokeF(buffer+8,z)
  ProcedureReturn buffer+12
EndProcedure

Procedure.l writeTextureToBuffer(buffer.l, x.f, y.f)
  PokeF(buffer,x)
  PokeF(buffer+4,y)
  ProcedureReturn buffer+8
EndProcedure

Procedure.l writeColorToBuffer(buffer.l, red.f, green.f, blue.f)
  PokeF(buffer,red)
  PokeF(buffer+4,green)
  PokeF(buffer+8,blue)
  ProcedureReturn buffer+12
EndProcedure

XIncludeFile "kv6.pb"

Procedure shutdown_game()
  disconnect()
  shutdown_enet()
  If Not IsScreenActive() = 0
    CloseScreen()
  EndIf
  If IsWindow(0)
    CloseWindow(0)
  EndIf
  End
EndProcedure

XIncludeFile "3DEngine.pb"

init_enet()
init_sound()
InitSprite()

aosip$ = ProgramParameter(0)
If aosip$ = ""
  aosip$ = InputRequester("Manual start","Type in a valid aos ip:","aos://1379434439:28887:0.75")
EndIf
If aosip$ = ""
  shutdown_game()
EndIf
aosip$ = RemoveString(aosip$,"//")
h = Val(StringField(aosip$,2,":"))
ip$ = Str(h & 255)+"."+Str((h>>8) & 255)+"."+Str((h>>16) & 255)+"."+Str((h>>24) & 255)
port = Val(StringField(aosip$,3,":"))
If StringField(aosip$,3,":") = ""
  port = 32887
EndIf

own_player_name$ = InputRequester("Manual start","Type in your name","DEV_CLIENT")

If Not StringField(aosip$,4,":") = "" And Not Val(StringField(StringField(aosip$,4,":"),2,".")) = 75
  MessageRequester("Version conflict","This version of Ace of Spades is not supported!")
  shutdown_game()
EndIf

If connect(ip$,port) > 0
  If Not IsScreenActive() = 0
    CloseScreen()
  EndIf
  
  If IsWindow(0)
    CloseWindow(0)
  EndIf
  MessageRequester("Network error","Connection to server failed.")
  shutdown_game()
EndIf

openEngineWindow(854,480,0)

; OpenLibrary(5,"glew32.dll")
; ExamineLibraryFunctions(5)
; While NextLibraryFunction()
;   Debug LibraryFunctionName()
; Wend
; Debug CallCFunction(5,"_glewInit@0")
; buffer.l = AllocateMemory(128)
; PokeL(buffer,$8B31)
; Debug CallCFunction(5,"__glewCreateShader",buffer)
; Debug PeekS(CallFunction(5,"_glewGetErrorString@4",buffer),-1,#PB_UTF8)
; Debug CallCFunction(5,"__glewCreateProgram",buffer)

;CloseLibrary(5)
;shutdown_game()

#PB_TIME_SECOND         = 1
#PB_TIME_DECISECOND     = 2
#PB_TIME_CENTISECOND    = 3
#PB_TIME_MILLISECOND    = 4
#PB_TIME_MICROSECOND    = 5
#PB_TIME_NANOSECOND     = 6

Repeat
  If fullscreen_mode = 0
    event = WindowEvent()
  EndIf
  If network_connected = 0
    If connection_error = 1
      MessageRequester("Network error","Server is full or kicked")
    Else
      MessageRequester("Network error","Map data decompression error: "+connection_error)
    EndIf
    shutdown_game()
  EndIf
  ;networkThread(0)
  updateEngineWindow(event,GetTimeDelta(#PB_TIME_MICROSECOND)/1000000.0)
  ;Delay(10)
Until event = #PB_Event_CloseWindow

shutdown_game()
; IDE Options = PureBasic 5.31 (Windows - x86)
; CursorPosition = 178
; FirstLine = 155
; Folding = 6-
; EnableUnicode
; EnableThread
; EnableXP
; Executable = aos.exe
; SubSystem = OpenGL
; DisableDebugger
; EnableCompileCount = 1982
; EnableBuildCount = 10