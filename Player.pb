Global own_player_name$ = "DEV_CLIENT"
Global own_player_id.l = -1
Global own_team.l = -1
Global own_weapon.l = 1
Global own_item.l = 2
Global own_dead.l
Global own_hp.l = 100
Global own_kills.l = 0
Global own_deaths.l = 0
Global own_block_red.l = 112
Global own_block_green.l = 112
Global own_block_blue.l = 112
Global action_lock.l = 0

Global own_ammo.l = 0
Global own_max_ammo.l = 0

Global own_new_position_time.l
Global own_old_position_time.l
Global own_movement_start.l = -1
Global own_movement_stop.l = -1
Global last_movement_anim_state.f

Global last_damage_source_x.f
Global last_damage_source_y.f
Global last_damage_source_z.f
Global last_damage_source_type.l = 0
Global last_damage_source_time.l

Global camera_rot_x.f
Global camera_rot_y.f = 3.1415

Global shooting_recoil_offset.f = 0.0

Global position_time.l

Global Dim namelist.s(32)
Global Dim teamlist.l(32)
Global Dim weaponlist.l(32)

Global Dim player_connected.l(32)

Global Dim player_x.f(32)
Global Dim player_y.f(32)
Global Dim player_z.f(32)
Global Dim player_old_x.f(32)
Global Dim player_old_y.f(32)
Global Dim player_old_z.f(32)

Global Dim player_angle_x.f(32)
Global Dim player_angle_y.f(32)
Global Dim player_angle_z.f(32)
Global Dim player_old_angle_x.f(32)
Global Dim player_old_angle_y.f(32)
Global Dim player_old_angle_z.f(32)

Global Dim player_secounds_till_respawn.l(32)
Global Dim player_death_time.l(32)
Global Dim player_dead.l(32)
Global Dim player_item.l(32)
Global Dim player_block_color_red.l(32)
Global Dim player_block_color_green.l(32)
Global Dim player_block_color_blue.l(32)
Global Dim player_kills.l(32)
Global Dim player_deaths.l(32)
;Global Dim player_keystates.l(32)
Global Dim player_keystates2.l(32)
Global player_new_position_time.l
Global player_old_position_time.l
Global Dim player_last_step_sound_time.l(32)
Global Dim player_step_sound_id.l(32)
Global Dim player_left_button.l(32)
Global Dim player_right_button.l(32)
Global Dim player_last_shot.l(32)
Global Dim player_ammo.l(32)
Global Dim player_dig_anim_start.l(32)
Global Dim player_dig_anim_speed.f(32)
Global Dim player_velocity_x.f(32)
Global Dim player_velocity_y.f(32)
Global Dim player_velocity_z.f(32)
Global Dim player_airborne.l(32)
Global Dim player_wade.l(32)
Global Dim player_moveDistance.f(32)
Global Dim player_moveSteps.l(32)
Global Dim player_climb.l(32)
Global Dim player_lastJump.l(32)
Global Dim player_lastJumpTime.f(32)
Global Dim player_lastClimbTime.f(32)
Global Dim player_eye_y.f(32)

#PLAYER_SPADE_TIME = 150

XIncludeFile "playerphysics.pb"

Procedure.f getPlayerX(player_id)
  ProcedureReturn player_x(player_id)
EndProcedure

Procedure.f getPlayerY(player_id)
  ProcedureReturn player_y(player_id)
EndProcedure

Procedure.f getPlayerZ(player_id)
  ProcedureReturn player_z(player_id)
EndProcedure

Procedure.f getPlayerAngleX(player_id)
  ProcedureReturn player_angle_x(player_id)
EndProcedure

Procedure.f getPlayerAngleY(player_id)
  ProcedureReturn player_angle_y(player_id)
EndProcedure

Procedure.f getPlayerAngleZ(player_id)
  ProcedureReturn player_angle_z(player_id)
EndProcedure

Procedure.l isMoving(player_id)
  If Abs(player_x(player_id)-player_old_x(player_id))>0.0 Or Abs(player_z(player_id)-player_old_z(player_id))>0.0
;      If ElapsedMilliseconds()-player_last_step_sound_time(player_id)>500
;        player_step_sound_id(player_id) = createSoundSource(Random(3),getPlayerX(player_id),getPlayerY(player_id),getPlayerZ(player_id),24.0)
;        player_last_step_sound_time(player_id) = ElapsedMilliseconds()
;      EndIf
    moveSoundSource(player_step_sound_id(player_id),getPlayerX(player_id),getPlayerY(player_id),getPlayerZ(player_id))
    ProcedureReturn 1
  EndIf
  ProcedureReturn 0
EndProcedure


Procedure updatePlayer(player_id, dt.f)
  ;If player_id = own_player_id
    player_old_x(player_id) = player_x(player_id)
    player_old_y(player_id) = player_y(player_id)
    player_old_z(player_id) = player_z(player_id)
    
    player_y(player_id) = 64.0-player_y(player_id)
    player_angle_y(player_id) = -player_angle_y(player_id)
    moveplayer(dt,player_id)
    player_angle_y(player_id) = -player_angle_y(player_id)
    player_y(player_id) = 64.0-player_y(player_id)
    player_eye_y(player_id) = 64.0-player_eye_y(player_id)
    ;EndIf
   
  
;   If player_left_button(player_id) = 0 And player_right_button(player_id) = 0
;     player_last_shot(player_id) = 0
;   EndIf
    If Not player_id = own_player_id Or (ElapsedMilliseconds()>action_lock And player_id = own_player_id)
      If player_left_button(player_id) = 1 And player_item(player_id) = 2 And ElapsedMilliseconds()-player_last_shot(player_id)>=shot_times(weaponlist(player_id)) And player_dead(player_id) = 0 And player_ammo(player_id) > 0
          Define k
          For k=0 To 511
            If tracer_used(k) = 0
              tracer_x(k) = getPlayerX(player_id)+getPlayerAngleX(player_id)+0.5
              tracer_y(k) = getPlayerY(player_id)+getPlayerAngleY(player_id)
              tracer_z(k) = getPlayerZ(player_id)+getPlayerAngleZ(player_id)+0.5
              tracer_speed_x(k) = getPlayerAngleX(player_id)
              tracer_speed_y(k) = getPlayerAngleY(player_id)
              tracer_speed_z(k) = getPlayerAngleZ(player_id)
              tracer_created(k) = ElapsedMilliseconds()
              tracer_creator(k) = player_id
              tracer_used(k) = 1
              Break
            EndIf
        Next
        
        If player_id = own_player_id
          If Not faced_player = -1
            sendHitPacket(faced_player,faced_player_part)
          EndIf
          camera_rot_x + (Sin(shooting_recoil_offset+0.1)-Sin(shooting_recoil_offset))*0.05
          camera_rot_y - recoil(own_weapon)
          shooting_recoil_offset + 0.2
        EndIf
        createSoundSource(15+weaponlist(player_id),getPlayerX(player_id),getPlayerY(player_id),getPlayerZ(player_id),16.0)
        player_last_shot(player_id) = ElapsedMilliseconds()
        player_ammo(player_id) - 1
    EndIf
    If player_left_button(player_id) = 1 And player_item(player_id) = 0 And ElapsedMilliseconds()-player_last_shot(player_id)>=#PLAYER_SPADE_TIME*3 And player_dead(player_id) = 0
      player_dig_anim_start(player_id) = ElapsedMilliseconds()
      player_dig_anim_speed(player_id) = 1.0
      
      If player_id = own_player_id And object_distance < 4.0
        If faced_player = -1
          If Not faced_block_x = -1
            sendBlockActionPacket(1,faced_block_x,faced_block_y,faced_block_z)
          EndIf
        Else
          sendHitPacket(faced_player,4)
          spawnParticleCloud(64,player_x(faced_player),player_y(faced_player)+0.5,player_z(faced_player),0.15,0.0625,0.2,RGB(255,0,0))
        EndIf
      EndIf
      
      createSoundSource(23,getPlayerX(player_id),getPlayerY(player_id),getPlayerZ(player_id),16.0)
      player_last_shot(player_id) = ElapsedMilliseconds()
    EndIf
    If player_right_button(player_id) = 1 And player_item(player_id) = 0 And ElapsedMilliseconds()-player_last_shot(player_id)>=#PLAYER_SPADE_TIME*3*3 And player_dead(player_id) = 0
      player_dig_anim_start(player_id) = ElapsedMilliseconds()
      player_dig_anim_speed(player_id) = 3.0
      
      If player_id = own_player_id And object_distance < 4.0 And Not faced_block_x = -1
        sendBlockActionPacket(2,faced_block_x,faced_block_y,faced_block_z)
      EndIf
      
      createSoundSource(23,getPlayerX(player_id),getPlayerY(player_id),getPlayerZ(player_id),16.0)
      player_last_shot(player_id) = ElapsedMilliseconds()
    EndIf
    If player_left_button(player_id) = 1 And player_item(player_id) = 1 And ElapsedMilliseconds()-player_last_shot(player_id)>=#PLAYER_SPADE_TIME*3 And player_dead(player_id) = 0
      player_dig_anim_start(player_id) = ElapsedMilliseconds()
      player_dig_anim_speed(player_id) = 1.0
      
      If player_id = own_player_id And object_distance < 4.0 And Not build_block_x = -1 And Not isBlockSolid(getBlockSafe(build_block_x,build_block_y,build_block_z))
        sendBlockActionPacket(0,build_block_x,build_block_y,build_block_z)
      EndIf
      
      player_last_shot(player_id) = ElapsedMilliseconds()
    EndIf
    If player_left_button(player_id) = 1 And player_item(player_id) = 3 And ElapsedMilliseconds()-player_last_shot(player_id)>=#PLAYER_SPADE_TIME*3 And player_dead(player_id) = 0
      player_dig_anim_start(player_id) = ElapsedMilliseconds()
      player_dig_anim_speed(player_id) = 1.0
      
      If player_id = own_player_id
        sendGrenade(player_x(own_player_id),player_y(own_player_id),player_z(own_player_id),1.0)
        Define v_x.f = Sin(camera_rot_x)*Sin(camera_rot_y)
        Define v_y.f = Cos(camera_rot_y)
        Define v_z.f = Cos(camera_rot_x)*Sin(camera_rot_y)
        spawnGrenade(player_x(own_player_id),64.0-player_y(own_player_id),player_z(own_player_id),v_x,-v_y,v_z,1.0)
      EndIf
      
      player_last_shot(player_id) = ElapsedMilliseconds()
    EndIf
  EndIf
EndProcedure
; IDE Options = PureBasic 5.31 (Windows - x86)
; CursorPosition = 149
; FirstLine = 45
; Folding = --
; EnableUnicode
; EnableThread
; EnableXP
; UseMainFile = main.pb