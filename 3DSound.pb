#PLAY_ALWAYS = 65536

Global Dim sound_source_used.l(256)
Global Dim sound_source_x.f(256)
Global Dim sound_source_y.f(256)
Global Dim sound_source_z.f(256)
Global Dim sound_source_native_id.l(256)
Global Dim sound_source_range.f(256)
Global Dim sound_source_created.l(256)

Global sound_memory.l
Global Dim sound_offset.l(64)
Global Dim sound_length.l(64)

Global volume.l = 10

Procedure loadSoundIntoMemory(name$,id)
  If FileSize(name$)<0
    Debug "Sound "+name$+" could not be found"
    ProcedureReturn
  EndIf
  If id = 0
    index = 0
  Else
    index = sound_offset(id-1)+sound_length(id-1)
  EndIf
  ReadFile(0,name$)
  ReadData(0,sound_memory+index,FileSize(name$))
  sound_offset(id) = index
  sound_length(id) = FileSize(name$)
  CloseFile(0)
EndProcedure

Procedure.l createSoundSource(sound_id,x_pos.f,y_pos.f,z_pos.f,range.f)
  For k=0 To 255
    If sound_source_used(k) = 0
      id = CatchSound(#PB_Any,sound_memory+sound_offset(sound_id),sound_length(sound_id))
      sound_source_native_id(k) = id
      sound_source_x(k) = x_pos
      sound_source_y(k) = y_pos
      sound_source_z(k) = z_pos
      sound_source_range(k) = 32.0
      PlaySound(id,0,0)
      sound_source_used(k) = 1
      ProcedureReturn k
    EndIf
  Next
EndProcedure

Procedure.l createSoundSourceAtCamera(sound_id)
  For k=0 To 255
    If sound_source_used(k) = 0
      id = CatchSound(#PB_Any,sound_memory+sound_offset(sound_id),sound_length(sound_id))
      sound_source_native_id(k) = id
      sound_source_x(k) = 0.0
      sound_source_y(k) = 0.0
      sound_source_z(k) = 0.0
      sound_source_range(k) = #PLAY_ALWAYS
      PlaySound(id,0,100)
      sound_source_used(k) = 1
      ProcedureReturn k
    EndIf
  Next
EndProcedure

Procedure moveSoundSource(id,x_pos.f,y_pos.f,z_pos.f)
  sound_source_x(id) = x_pos
  sound_source_y(id) = y_pos
  sound_source_z(id) = z_pos
EndProcedure

Procedure.l isSoundSourceStopped(id)
  ProcedureReturn sound_source_used(id)
EndProcedure

Procedure update_sounds(x_pos.f,y_pos.f,z_pos.f)
  For k=0 To 255
    If sound_source_used(k) = 1 And IsSound(sound_source_native_id(k)) And SoundStatus(sound_source_native_id(k)) = #PB_Sound_Stopped
      FreeSound(sound_source_native_id(k))
      sound_source_used(k) = 0
    EndIf
    If sound_source_used(k) = 1 And IsSound(sound_source_native_id(k)) And Not sound_source_range(k) = #PLAY_ALWAYS
      distance_to_sound.f = Sqr((sound_source_x(k)-x_pos)*(sound_source_x(k)-x_pos)+(sound_source_y(k)-y_pos)*(sound_source_y(k)-y_pos)+(sound_source_z(k)-z_pos)*(sound_source_z(k)-z_pos))
      If distance_to_sound > sound_source_range(k)
        SoundVolume(sound_source_native_id(k),0,#PB_All)
      Else
        SoundVolume(sound_source_native_id(k),(1.0-(distance_to_sound/sound_source_range(k)))*(volume/10.0)*100,#PB_All)
      EndIf
    EndIf
  Next
EndProcedure

Procedure init_sound()
  sound_memory = AllocateMemory(8*1024*1024) ;allocate 8MB of ram for all sound files
  InitSound()
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
EndProcedure
; IDE Options = PureBasic 5.31 (Windows - x86)
; CursorPosition = 82
; FirstLine = 70
; Folding = --
; EnableUnicode
; EnableXP
; UseMainFile = main.pb