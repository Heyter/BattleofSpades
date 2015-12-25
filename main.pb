EnableExplicit

Procedure ErrorHandler()
 
  Define ErrorMessage$ = "A program error was detected:" + Chr(13) 
  ErrorMessage$ + Chr(13)
  ErrorMessage$ + "Error Message:   " + ErrorMessage()      + Chr(13)
  ErrorMessage$ + "Error Code:      " + Str(ErrorCode())    + Chr(13)  
  ErrorMessage$ + "Code Address:    " + Str(ErrorAddress()) + Chr(13)
 
  If ErrorCode() = #PB_OnError_InvalidMemory   
    ErrorMessage$ + "Target Address:  " + Str(ErrorTargetAddress()) + Chr(13)
  EndIf
 
  If ErrorLine() = -1
    ErrorMessage$ + "Sourcecode line: Enable OnError lines support to get code line information." + Chr(13)
  Else
    ErrorMessage$ + "Sourcecode line: " + Str(ErrorLine()) + Chr(13)
    ErrorMessage$ + "Sourcecode file: " + ErrorFile() + Chr(13)
  EndIf
 
  ErrorMessage$ + Chr(13)
  ErrorMessage$ + "Register content:" + Chr(13)
 
  CompilerSelect #PB_Compiler_Processor 
    CompilerCase #PB_Processor_x86
      ErrorMessage$ + "EAX = " + Str(ErrorRegister(#PB_OnError_EAX)) + Chr(13)
      ErrorMessage$ + "EBX = " + Str(ErrorRegister(#PB_OnError_EBX)) + Chr(13)
      ErrorMessage$ + "ECX = " + Str(ErrorRegister(#PB_OnError_ECX)) + Chr(13)
      ErrorMessage$ + "EDX = " + Str(ErrorRegister(#PB_OnError_EDX)) + Chr(13)
      ErrorMessage$ + "EBP = " + Str(ErrorRegister(#PB_OnError_EBP)) + Chr(13)
      ErrorMessage$ + "ESI = " + Str(ErrorRegister(#PB_OnError_ESI)) + Chr(13)
      ErrorMessage$ + "EDI = " + Str(ErrorRegister(#PB_OnError_EDI)) + Chr(13)
      ErrorMessage$ + "ESP = " + Str(ErrorRegister(#PB_OnError_ESP)) + Chr(13)
 
    CompilerCase #PB_Processor_x64
      ErrorMessage$ + "RAX = " + Str(ErrorRegister(#PB_OnError_RAX)) + Chr(13)
      ErrorMessage$ + "RBX = " + Str(ErrorRegister(#PB_OnError_RBX)) + Chr(13)
      ErrorMessage$ + "RCX = " + Str(ErrorRegister(#PB_OnError_RCX)) + Chr(13)
      ErrorMessage$ + "RDX = " + Str(ErrorRegister(#PB_OnError_RDX)) + Chr(13)
      ErrorMessage$ + "RBP = " + Str(ErrorRegister(#PB_OnError_RBP)) + Chr(13)
      ErrorMessage$ + "RSI = " + Str(ErrorRegister(#PB_OnError_RSI)) + Chr(13)
      ErrorMessage$ + "RDI = " + Str(ErrorRegister(#PB_OnError_RDI)) + Chr(13)
      ErrorMessage$ + "RSP = " + Str(ErrorRegister(#PB_OnError_RSP)) + Chr(13)
      ErrorMessage$ + "Display of registers R8-R15 skipped."         + Chr(13)
 
    CompilerCase #PB_Processor_PowerPC
      ErrorMessage$ + "r0 = " + Str(ErrorRegister(#PB_OnError_r0)) + Chr(13)
      ErrorMessage$ + "r1 = " + Str(ErrorRegister(#PB_OnError_r1)) + Chr(13)
      ErrorMessage$ + "r2 = " + Str(ErrorRegister(#PB_OnError_r2)) + Chr(13)
      ErrorMessage$ + "r3 = " + Str(ErrorRegister(#PB_OnError_r3)) + Chr(13)
      ErrorMessage$ + "r4 = " + Str(ErrorRegister(#PB_OnError_r4)) + Chr(13)
      ErrorMessage$ + "r5 = " + Str(ErrorRegister(#PB_OnError_r5)) + Chr(13)
      ErrorMessage$ + "r6 = " + Str(ErrorRegister(#PB_OnError_r6)) + Chr(13)
      ErrorMessage$ + "r7 = " + Str(ErrorRegister(#PB_OnError_r7)) + Chr(13)
      ErrorMessage$ + "Display of registers r8-R31 skipped."       + Chr(13)
 
  CompilerEndSelect
 
  MessageRequester("OnError example", ErrorMessage$)
  End
 
EndProcedure

OnErrorCall(@ErrorHandler())



UsePNGImageDecoder()

#KEY_UP = 1
#KEY_DOWN = 2
#KEY_LEFT = 4
#KEY_RIGHT = 8
#KEY_JUMP = 16
#KEY_CROUCH = 32
#KEY_SNEAK = 64
#KEY_SPRINT = 128

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

Global Dim reload_times.l(3) ;(in ms)
reload_times(0) = 2500  ;semi
reload_times(1) = 2500  ;smg
reload_times(2) = 500 ;shotgun (per clip)


Global Dim shot_times.l(3) ;(in ms)
shot_times(0) = 500  ;semi
shot_times(1) = 110  ;smg
shot_times(2) = 1000 ;shotgun

Global Dim mag_size.l(3)
mag_size(0) = 10  ;semi
mag_size(1) = 30  ;smg
mag_size(2) = 6   ;shotgun

Global Dim max_ammo.l(3)
max_ammo(0) = 50  ;semi
max_ammo(1) = 120 ;smg
max_ammo(2) = 48  ;shotgun

Global Dim recoil.f(3)
recoil(0) = 0.05  ;semi
recoil(1) = 0.0125;smg
recoil(2) = 0.1   ;shotgun

Global Dim spread.f(3)
spread(0) = 0.006 ;semi
spread(1) = 0.012 ;smg
spread(2) = 0.024 ;shotgun

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

Global fps.l = 0
Global fps_update.l = 0

Global program.l

Declare sendHitPacket(id.l,type.l)
Declare sendBlockActionPacket(action.l, x.l, y.l, z.l)
Declare sendGrenade(x.f, y.f, z.f, defuse_time.l)
Prototype glGenFramebuffers(size.l,ids.l) : Global glGenFramebuffers_.glGenFramebuffers
Prototype glBindFramebuffer(target.l,id.l) : Global glBindFramebuffer_.glBindFramebuffer
Prototype glDeleteFramebuffers(size.l,ids.l) : Global glDeleteFramebuffers_.glDeleteFramebuffers
Prototype glFramebufferTexture2D(target.l,attachmentPoint.l,textureTarget.l,textureId.l,level.l) : Global glFramebufferTexture2D_.glFramebufferTexture2D

;Prototype glCreateProgram() : Global glCreateProgram_.glCreateProgram
;Prototype glCreateShader(shaderType.l) : Global glCreateShader_.glCreateShader
;Prototype glShaderSource(shader.l,count.l,string.l,length.l) : Global glShaderSource_.glShaderSource
;Prototype glCompileShader(shader.l) : Global glCompileShader_.glCompileShader
;Prototype glAttachShader(program.l,shader.l) : Global glAttachShader_.glAttachShader
;Prototype glLinkProgram(program.l) : Global glLinkProgram_.glLinkProgram
;Prototype glUseProgram(program.l) : Global glUseProgram_.glUseProgram
;Prototype glUniform1f(index.l,value.f) : Global glUniform1f_.glUniform1f
;Prototype glGetUniformLocation(program.l,name.l) : Global glGetUniformLocation_.glGetUniformLocation


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
  Define red.f = current_color(0)
  Define green.f = current_color(1)
  Define blue.f = current_color(2)
  Define alpha.f = current_color(3)
  
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
XIncludeFile "ParticleSystem.pb"
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
  shutdown_sound()
  If IsScreenActive() = 1
    CloseScreen()
  EndIf
  If IsWindow(0)
    CloseWindow(0)
  EndIf
  If ReadPreferenceInteger("show_news",1) = 1
    RunProgram(ReadPreferenceString("news_site","http://bytebit.info.tm/battleofspades/"))
  EndIf
  ClosePreferences()
  End
EndProcedure

XIncludeFile "3DEngine.pb"

init_enet()
init_sound()
InitSprite()

OpenPreferences("config.ini",#PB_Preference_GroupSeparator)
PreferenceGroup("client")

If ReadPreferenceString("name","") = "" : WritePreferenceString("name","Deuce") : EndIf
If ReadPreferenceString("xres","") = "" : WritePreferenceInteger("xres",854) : EndIf
If ReadPreferenceString("yres","") = "" : WritePreferenceInteger("yres",480) : EndIf
If ReadPreferenceString("vol","") = "" : WritePreferenceInteger("vol",10) : EndIf
If ReadPreferenceString("inverty","") = "" : WritePreferenceInteger("inverty",0) : EndIf
If ReadPreferenceString("windowed","") = "" : WritePreferenceInteger("windowed",1) : EndIf
If ReadPreferenceString("mouse_sensitivity","") = "" : WritePreferenceFloat("mouse_sensitivity",5.0) : EndIf
If ReadPreferenceString("show_news","") = "" : WritePreferenceInteger("show_news",1) : EndIf
If ReadPreferenceString("news_site","") = "" : WritePreferenceString("news_site","http://bytebit.info.tm/battleofspades/") : EndIf
If ReadPreferenceString("shadows","") = "" : WritePreferenceInteger("shadows",0) : EndIf
If ReadPreferenceString("shadow_res","") = "" : WritePreferenceInteger("shadow_res",512) : EndIf
If ReadPreferenceString("last_server","") = "" : WritePreferenceString("last_server","aos://1379434439:34887:0.75") : EndIf
If ReadPreferenceString("imitate_openspades","") = "" : WritePreferenceInteger("imitate_openspades",0) : EndIf

Define aosip$ = ProgramParameter(0)
If aosip$ = ""
  aosip$ = InputRequester("Manual start","Type in a valid aos ip:",ReadPreferenceString("last_server","aos://1379434439:34887:0.75"))
EndIf
If aosip$ = ""
  shutdown_game()
EndIf
WritePreferenceString("last_server",aosip$)
aosip$ = RemoveString(aosip$,"//")
Define h = Val(StringField(aosip$,2,":"))
Define ip$ = Str(h & 255)+"."+Str((h>>8) & 255)+"."+Str((h>>16) & 255)+"."+Str((h>>24) & 255)
Define port = Val(StringField(aosip$,3,":"))
If StringField(aosip$,3,":") = ""
  port = 32887
EndIf

own_player_name$ = ReadPreferenceString("name","Deuce")
If own_player_name$ = "Deuce"
  own_player_name$ = InputRequester("First start","Type in your name below:",own_player_name$)
  WritePreferenceString("name",own_player_name$)
EndIf

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

openEngineWindow(ReadPreferenceInteger("xres",854),ReadPreferenceInteger("yres",480),(~ReadPreferenceInteger("windowed",1))&1)

 glGenFramebuffers_ = wglGetProcAddress_("glGenFramebuffers")
 glBindFramebuffer_ = wglGetProcAddress_("glBindFramebuffer")
 glDeleteFramebuffers_ = wglGetProcAddress_("glDeleteFramebuffers")
 glFramebufferTexture2D_ = wglGetProcAddress_("glFramebufferTexture2D")
; glCreateProgram_ = wglGetProcAddress_("glCreateProgram")
; glCreateShader_ = wglGetProcAddress_("glCreateShader")
; glShaderSource_ = wglGetProcAddress_("glShaderSource")
; glCompileShader_ = wglGetProcAddress_("glCompileShader")
; glAttachShader_ = wglGetProcAddress_("glAttachShader")
; glLinkProgram_ = wglGetProcAddress_("glLinkProgram")
; glUseProgram_ = wglGetProcAddress_("glUseProgram")
; glUniform1f_ = wglGetProcAddress_("glUniform1f")
; glGetUniformLocation_ = wglGetProcAddress_("glGetUniformLocation")
; 
; program.l = glCreateProgram_()
; vertex_shader = glCreateShader_(#GL_VERTEX_SHADER)
; fragment_shader = glCreateShader_(#GL_FRAGMENT_SHADER)
; #CLRF = Chr(13)+Chr(10)
; vertex.s = "#version 110"+#CLRF
; vertex.s + "uniform float time;"+#CLRF
; vertex.s + "void main() {"+#CLRF
; vertex.s + "	gl_FrontColor = gl_Color;"+#CLRF
; vertex.s + "	float y = gl_Vertex.y;"+#CLRF
; vertex.s + "	if(y==2.0) {"+#CLRF
; vertex.s + "		y = (sin(gl_Vertex.x*1.1+time)*sin(gl_Vertex.z*1.1)*cos(gl_Vertex.x*1.1+time)*cos(gl_Vertex.z*1.1)+1.0)*1.7+0.5;"+#CLRF
; vertex.s + "		gl_FrontColor = gl_FrontColor*(sin(gl_Vertex.x*1.1+time)*sin(gl_Vertex.z*1.1)*cos(gl_Vertex.x*1.1+time)*cos(gl_Vertex.z*1.1)+1.0)*0.5;"+#CLRF
; vertex.s + "    gl_FrontColor.a = 1.0;"+#CLRF
; vertex.s + "	}"+#CLRF
; vertex.s + "	gl_Position = gl_ModelViewProjectionMatrix * vec4(gl_Vertex.x,y,gl_Vertex.z,gl_Vertex.w);"+#CLRF
; vertex.s + "}"
; 
; fragment.s = "#version 110"+#CLRF+"void main() {"+#CLRF+"	gl_FragColor = gl_Color;"+#CLRF+"}";
; Global *TxtPointer
; 
; *TxtPointer = @vertex
; glShaderSource_(vertex_shader,1,@*TxtPointer,0)
; glCompileShader_(vertex_shader)
; *TxtPointer = @fragment
; glShaderSource_(fragment_shader,1,@*TxtPointer,0)
; glCompileShader_(fragment_shader)
; glAttachShader_(program,vertex_shader)
; glAttachShader_(program,fragment_shader)
; glLinkProgram_(program)

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
    Define event = WindowEvent()
  EndIf
  If network_connected = 0
    If connection_error < 100
      Define reason$ = "Kicked/unknown reason"
      connection_error - 1
      If connection_error = 1
        reason$ = "Banned."
      EndIf
      If connection_error = 2
        reason$ = "IP connection limit exceded."
      EndIf
      If connection_error = 3
        reason$ = "Wrong protocol version."
      EndIf
      If connection_error = 4
        reason$ = "Server full."
      EndIf
      If MessageRequester("Network error",reason$+" Try again?",#PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
        disconnect()
        Define a.l = connect(ip$,port)
        If a > 0
          If Not IsScreenActive() = 0
            CloseScreen()
          EndIf  
          If IsWindow(0)
            CloseWindow(0)
          EndIf
          MessageRequester("Network error Code:"+Str(a),"Connection to server failed.")
          shutdown_game()
        EndIf
      Else
        shutdown_game()
      EndIf
    Else
      MessageRequester("Network error","Map data decompression error: "+connection_error)
      shutdown_game()
    EndIf
  EndIf
  Define dt.f = GetTimeDelta(#PB_TIME_MICROSECOND)/1000000.0
  If ElapsedMilliseconds()-fps_update>100
    fps = Round(1.0/dt,#PB_Round_Down)
    fps_update = ElapsedMilliseconds()
  EndIf
  updateEngineWindow(event,dt)
Until event = #PB_Event_CloseWindow

shutdown_game()
; IDE Options = PureBasic 5.31 (Windows - x86)
; CursorPosition = 460
; FirstLine = 271
; Folding = C9
; EnableThread
; EnableXP
; EnableOnError
; UseIcon = bos.ico
; Executable = bos.exe
; SubSystem = OpenGL
; DisableDebugger
; EnableCompileCount = 2832
; EnableBuildCount = 28
; IncludeVersionInfo
; VersionField13 = bytebitgames@googlemail.com
; VersionField14 = http://bytebit.info.tm/
; VersionField15 = VOS_NT_WINDOWS32
; VersionField16 = VFT_APP
; VersionField17 = 0409 English (United States)