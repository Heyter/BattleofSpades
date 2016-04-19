#PLAY_ALWAYS = 65536

Global Dim sound_source_used.l(256)
Global Dim sound_source_x.f(256)
Global Dim sound_source_y.f(256)
Global Dim sound_source_z.f(256)
Global Dim sound_source_native_source.l(256)
Global Dim sound_source_native_buffer.l(256)
Global Dim sound_source_range.f(256)
Global Dim sound_source_created.l(256)
Global Dim sound_at_camera.l(256)

Global sound_memory.l
Global Dim sound_offset.l(64)
Global Dim sound_length.l(64)

Global volume.l = 10

Global openal_dll.l = -1
Global sound_supported.l = 0
Global ctx.l,dev.l

Global empty_mem.l = AllocateMemory(4*3)
Global position_mem.l = AllocateMemory(4*3)
Global velocity_mem.l = AllocateMemory(4*3)
Global orientation_mem.l = AllocateMemory(4*6)
Global gain_mem.l = AllocateMemory(4)

Procedure loadSoundIntoMemory(name$,id)
  If FileSize(name$)<0
    Debug "Sound "+name$+" could not be found"
    ProcedureReturn
  EndIf
  If id = 0
    Define index = 0
  Else
    index = sound_offset(id-1)+sound_length(id-1)
  EndIf
  ReadFile(0,name$)
  ReadData(0,sound_memory+index,FileSize(name$))
  sound_offset(id) = index
  sound_length(id) = FileSize(name$)
  CloseFile(0)
EndProcedure

Procedure.l al_GenBuffer()
  Define id.l = -1
  CallCFunction(openal_dll,"alGenBuffers",1,@id)
  If Not CallCFunction(openal_dll,"alGetError") = 0
    MessageRequester("Sound error","Could not generate OpenAL buffer.")
    
    ProcedureReturn -1
  EndIf
  ProcedureReturn id
EndProcedure

Procedure.l al_GenSource()
  Define id.l = -1
  CallCFunction(openal_dll,"alGenSources",1,@id)
  If Not CallCFunction(openal_dll,"alGetError") = 0
    MessageRequester("Sound error","Could not generate OpenAL source.")
    ProcedureReturn -1
  EndIf
  ProcedureReturn id
EndProcedure

Procedure.l createSoundSource(sound_id.l,x_pos.f,y_pos.f,z_pos.f,range.f)
  If sound_supported = 0
    ProcedureReturn
  EndIf
  Define k
  For k=0 To 255
    If sound_source_used(k) = 0
      
      Define buffer.l = sound_source_native_buffer(k)
      Define source.l = sound_source_native_source(k)
      
      CallCFunction(openal_dll,"alSourceStop",source)
      CallCFunction(openal_dll,"alSourcei",source,4105,0)
      
      Define bits_per_sample.l = PeekW(sound_memory+sound_offset(sound_id)+34)
      Define samplerate.l = PeekL(sound_memory+sound_offset(sound_id)+24)
      Define data_length.l = sound_length(sound_id)-44;PeekL(sound_memory+sound_offset(sound_id)+40)
      Define channels.l = PeekW(sound_memory+sound_offset(sound_id)+22)
      Define data_start.l = sound_memory+sound_offset(sound_id)+44
      
      If channels = 2
        channels = 1
        samplerate * 2
      EndIf
      
      Define format.l = (bits_per_sample/8-1)+(channels-1)*2

      CallCFunction(openal_dll,"alBufferData",buffer,format+4352,data_start,data_length,samplerate) ;4353 = AL_FORMAT_MONO16
      
      Define err.l = CallCFunction(openal_dll,"alGetError")
      If Not err = 0
        
        ;MessageRequester("Sound error","Could not fill buffer."+Str(err))
        ProcedureReturn -1
      EndIf
      CallCFunction(openal_dll,"alSourcei",source,4105,buffer) ;4105 = AL_BUFFER
      Define err.l = CallCFunction(openal_dll,"alGetError")
      If Not err = 0
        ;MessageRequester("Sound error","Could not attach buffer to source."+Str(err))
        ProcedureReturn -1
      EndIf
      
      PokeF(velocity_mem,0)
      PokeF(velocity_mem+4,0)
      PokeF(velocity_mem+8,0)
      CallCFunction(openal_dll,"alSourcefv",source,4102,velocity_mem) ;4102 = AL_VELOCITY
      CallCFunction(openal_dll,"alSourcefv",source,4101,empty_mem) ;4101 = AL_DIRECTION
      
      PokeF(position_mem,x_pos)
      PokeF(position_mem+4,y_pos)
      PokeF(position_mem+8,z_pos)
      CallCFunction(openal_dll,"alSourcefv",source,4100,position_mem) ;4100 = AL_POSITION
      
      CallCFunction(openal_dll,"alSourcei",source,4128,1) ;4128 = AL_REFERENCE_DISTANCE
      CallCFunction(openal_dll,"alSourcei",source,4131,48) ;4131 = AL_MAX_DISTANCE
      CallCFunction(openal_dll,"alDistanceModel",53252) ;53252 = AL_LINEAR_DISTANCE_CLAMPED
      CallCFunction(openal_dll,"alSourcei", source, 4129, 1) ;4129 = AL_ROLLOFF_FACTOR
      
      CallCFunction(openal_dll,"alSourcePlay",source)
      
      ;Define id = CatchSound(#PB_Any,sound_memory+sound_offset(sound_id),sound_length(sound_id))
      sound_source_x(k) = x_pos
      sound_source_y(k) = y_pos
      sound_source_z(k) = z_pos
      sound_at_camera(k) = 0
      sound_source_created(k) = ElapsedMilliseconds()
      sound_source_used(k) = 1
      ProcedureReturn k
    EndIf
  Next
  MessageRequester("Sound error","Could find sound space. ERROR_"+Str(err))
EndProcedure

Procedure.l createSoundSourceAtCamera(sound_id)
  If sound_supported = 0
    ProcedureReturn
  EndIf
  Define id.l = createSoundSource(sound_id,0.0,0.0,0.0,0.0)
  sound_at_camera(id) = 1
  ProcedureReturn id
EndProcedure

Procedure moveSoundSource(id,x_pos.f,y_pos.f,z_pos.f)
  If sound_supported = 0
    ProcedureReturn
  EndIf
  sound_source_x(id) = x_pos
  sound_source_y(id) = y_pos
  sound_source_z(id) = z_pos
  PokeF(position_mem,x_pos)
  PokeF(position_mem+4,y_pos)
  PokeF(position_mem+8,z_pos)
  CallCFunction(openal_dll,"alSourcefv",sound_source_native_source(id),4100,position_mem) ;4100 = AL_POSITION
EndProcedure

Procedure.l isSoundSourceStopped(id)
  ProcedureReturn sound_source_used(id)
EndProcedure

Procedure update_sounds(x_pos.f,y_pos.f,z_pos.f,vx.f,vy.f,vz.f)
  If sound_supported = 0
    ProcedureReturn
  EndIf
  PokeF(position_mem,x_pos)
  PokeF(position_mem+4,y_pos)
  PokeF(position_mem+8,z_pos)
  PokeF(orientation_mem,vx)
  PokeF(orientation_mem+4,vy)
  PokeF(orientation_mem+8,vz)
  PokeF(orientation_mem+12,0.0)
  PokeF(orientation_mem+16,1.0)
  PokeF(orientation_mem+20,0.0)
  CallCFunction(openal_dll,"alListenerfv",4100,position_mem) ;4100 = AL_POSITION
  CallCFunction(openal_dll,"alListenerfv",4111,orientation_mem) ;4111 = AL_ORIENTATION
  PokeF(gain_mem,0.1)
  CallCFunction(openal_dll,"alListenerfv",4106,gain_mem) ;4106 = AL_GAIN
  Define k
  Define state.l = 0
  For k=0 To 255
    CallCFunction(openal_dll,"alGetSourcei", sound_source_native_source(k), 4112, @state) ;4112 = AL_SOURCE_STATE
    If sound_source_used(k) = 1 And state = 4116 ;4116 = AL_STOPPED
      sound_source_used(k) = 0
    EndIf
    If sound_source_used(k) = 1 And sound_at_camera(k) = 1
      moveSoundSource(k,x_pos,y_pos,z_pos)
    EndIf
  Next
  ProcedureReturn
  
EndProcedure

Procedure shutdown_sound()
  If sound_supported = 0 Or openal_dll = -1
    ProcedureReturn
  EndIf
  sound_supported = 0
  CallCFunction(openal_dll,"alcMakeContextCurrent",0)
  CallCFunction(openal_dll,"alcDestroyContext",ctx)
  CallCFunction(openal_dll,"alcCloseDevice",dev)
  CloseLibrary(openal_dll)
  openal_dll = -1
EndProcedure

Procedure init_sound()
  openal_dll = OpenLibrary(#PB_Any,"soft_oal.dll")
  sound_supported = 1
  dev = CallCFunction(openal_dll,"alcOpenDevice",0)
  If dev = 0
    MessageRequester("Sound error","Could not create OpenAL device.")
    shutdown_sound()
    ProcedureReturn
  EndIf
  ctx = CallCFunction(openal_dll,"alcCreateContext",dev,0)
  CallCFunction(openal_dll,"alcMakeContextCurrent",ctx)
  If ctx = 0
    MessageRequester("Sound error","Could not create a OpenAL context.")
    shutdown_sound()
    ProcedureReturn
  EndIf
  sound_memory = AllocateMemory(8*1024*1024) ;allocate 8MB of ram for all sound files
  loadSoundIntoMemory("wav/footstep1.wav",0)
  loadSoundIntoMemory("wav/footstep2.wav",1)
  loadSoundIntoMemory("wav/footstep3.wav",2)
  loadSoundIntoMemory("wav/footstep4.wav",3)
  loadSoundIntoMemory("wav/wade1.wav",4)
  loadSoundIntoMemory("wav/wade2.wav",5)
  loadSoundIntoMemory("wav/wade3.wav",6)
  loadSoundIntoMemory("wav/wade4.wav",7)
  loadSoundIntoMemory("wav/build.wav",8)
  loadSoundIntoMemory("wav/jump.wav",9)
  loadSoundIntoMemory("wav/fallhurt.wav",10)
  loadSoundIntoMemory("wav/death.wav",11)
  loadSoundIntoMemory("wav/semireload.wav",12)
  loadSoundIntoMemory("wav/smgreload.wav",13)
  loadSoundIntoMemory("wav/shotgunreload.wav",14)
  loadSoundIntoMemory("wav/semishoot.wav",15)
  loadSoundIntoMemory("wav/smgshoot.wav",16)
  loadSoundIntoMemory("wav/shotgunshoot.wav",17)
  loadSoundIntoMemory("wav/impact.wav",18)
  loadSoundIntoMemory("wav/chat.wav",19)
  loadSoundIntoMemory("wav/hitground.wav",20)
  loadSoundIntoMemory("wav/intro.wav",21)
  loadSoundIntoMemory("wav/explode.wav",22)
  loadSoundIntoMemory("wav/woosh.wav",23)
  loadSoundIntoMemory("wav/hitplayer.wav",24)
  loadSoundIntoMemory("wav/horn.wav",25)
  loadSoundIntoMemory("wav/fallhurt.wav",26)
  loadSoundIntoMemory("wav/debris.wav",27)
  loadSoundIntoMemory("wav/grenadebounce.wav",28)
  loadSoundIntoMemory("wav/beep1.wav",29)
  loadSoundIntoMemory("wav/beep2.wav",30)
  Define k
  For k=0 To 255
    sound_source_native_buffer(k) = al_GenBuffer()
    sound_source_native_source(k) = al_GenSource()
    sound_source_used(k) = 0
  Next
EndProcedure
; IDE Options = PureBasic 5.31 (Windows - x86)
; CursorPosition = 183
; FirstLine = 168
; Folding = --
; EnableUnicode
; EnableXP
; UseMainFile = main.pb
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant