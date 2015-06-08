Global Dim grenade_x.f(32)
Global Dim grenade_y.f(32)
Global Dim grenade_z.f(32)
Global Dim grenade_velocity_x.f(32)
Global Dim grenade_velocity_y.f(32)
Global Dim grenade_velocity_z.f(32)
Global Dim grenade_fuse.f(32)
Global Dim grenade_created.l(32)
Global Dim grenade_alive.l(32)

Procedure spawnGrenade(x.f,y.f,z.f,vx.f,vy.f,vz.f,fuse.f)
  For k=0 To 32
    If grenade_alive(k) = 0
      grenade_x(k) = x
      grenade_y(k) = y
      grenade_z(k) = z
      grenade_velocity_x(k) = vx
      grenade_velocity_y(k) = vy
      grenade_velocity_z(k) = vz
      grenade_fuse(k) = fuse
      grenade_created(k) = ElapsedMilliseconds()
      grenade_alive(k) = 1
      Break
    EndIf
  Next
EndProcedure

;returns 1 If there was a collision, 2 If sound should be played
Procedure.l move_grenade(id.l,fsynctics.f)
  fpos_x.f = grenade_x(id)
  fpos_y.f = grenade_y(id)
  fpos_z.f = grenade_z(id)
  ;do velocity & gravity (friction is negligible)
  f5.f = fsynctics * 32.0
  grenade_velocity_y(id) + fsynctics
  grenade_x(id) + grenade_velocity_x(id)*f5
  grenade_y(id) + grenade_velocity_y(id)*f5
  grenade_z(id) + grenade_velocity_z(id)*f5
  
  ;make it bounce (accurate)
  lp_x.l = Round(grenade_x(id),#PB_Round_Down)
  lp_y.l = Round(grenade_y(id),#PB_Round_Down)
  lp_z.l = Round(grenade_z(id),#PB_Round_Down)
  
  lp2_x.l = Round(fpos_x,#PB_Round_Down)
  lp2_y.l = Round(fpos_y,#PB_Round_Down)
  lp2_z.l = Round(fpos_z,#PB_Round_Down)
   
  ret.l = 0
    
  If clipworld(lp_x, lp_y, lp_z) ;hit a wall
      ret = 1
      If Abs(grenade_velocity_x(id)) > 0.1 Or Abs(grenade_velocity_z(id)) > 0.1 Or Abs(grenade_velocity_y(id)) > 0.1
        ret = 2 ;play sound
      EndIf
      
      If Not lp_y = lp2_y And ((lp_x = lp2_x And lp_z = lp2_z) Or Not clipworld(lp_x, lp_y, lp2_z))
        grenade_velocity_y(id) = -grenade_velocity_y(id)
      ElseIf Not lp_x = lp2_x And ((lp_z = lp2_z And lp_y = lp2_y) Or Not clipworld(lp2_x, lp_y, lp_z))
        grenade_velocity_x(id) = -grenade_velocity_x(id)
      ElseIf Not lp_z = lp2_z And ((lp_x = lp2_x And lp_y = lp2_y) Or Not clipworld(lp_x, lp2_y, lp_z))
        grenade_velocity_z(id) = -grenade_velocity_z(id)
      EndIf
      grenade_x(id) = fpos_x
      grenade_y(id) = fpos_y
      grenade_z(id) = fpos_z
      grenade_velocity_x(id) * 0.36
      grenade_velocity_y(id) * 0.36
      grenade_velocity_z(id) * 0.36
  EndIf
  ProcedureReturn ret
EndProcedure

Procedure updateGrenade(id.l, dt.f)
  If ElapsedMilliseconds()-grenade_created(id)>=grenade_fuse(id)*1000.0
    createSoundSource(22,grenade_x(id),grenade_y(id),grenade_z(id),16.0) ;grenade explode sound
    ;TODO spawn smoke particles because of explosion etc.
    grenade_alive(id) = 0
  Else
    If move_grenade(id,dt) = 2
      createSoundSource(28,grenade_x(id),grenade_y(id),grenade_z(id),16.0) ;grenade bounce sound
    EndIf
  EndIf
EndProcedure
; IDE Options = PureBasic 5.31 (Windows - x86)
; CursorPosition = 80
; FirstLine = 27
; Folding = -
; EnableUnicode
; EnableXP
; UseMainFile = main.pb