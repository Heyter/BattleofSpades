Procedure.f getTime()
  ProcedureReturn ElapsedMilliseconds()/1000.0
EndProcedure

Procedure.l IsOnGroundOrWade(id)
  If (player_velocity_y(id) >= 0.0 And player_velocity_y(id) < 0.017) And player_airborne(id) = 0
    ProcedureReturn 1
  EndIf
  ProcedureReturn 0
EndProcedure
	
Procedure.l IsToolWeapon(id)
  If player_item(id) = 2
    ProcedureReturn 1
  EndIf
  ProcedureReturn 0
EndProcedure

Procedure.f Max(a.f,b.f)
   If a>b
      ProcedureReturn a
   EndIf
   ProcedureReturn b
 EndProcedure
 
 Procedure repositionPlayer(id.l)
	  player_eye_y(id) = player_y(id)
	  Define f5.f = player_lastClimbTime(id) - getTime()
		If f5 > -0.25
			player_eye_y(id) + (f5 + 0.25) / 0.25
		EndIf
EndProcedure
 
 Procedure boxClipMove(fsynctics.f, id.l)
		Define f5.f = fsynctics * 32.0
		Define nx.f = f5 * player_velocity_x(id) + player_x(id)
		Define ny.f = f5 * player_velocity_z(id) + player_z(id)
		player_climb(id) = 0
		Define offset.f = 0.0
		Define m.f = 0.0
		If player_keystates2(id) & #KEY_CROUCH
			offset = 0.45
			m = 0.9
		Else
			offset = 0.9
			m = 1.35
		EndIf
		
		Define nz.f = player_y(id) + offset
		
		Define z.f = 0.0
		
		
		If player_velocity_x(id) < 0.0
			f5 = -0.45
		Else
			f5 = 0.45
		EndIf
		
		z = m
		
		While z >= -1.36 And Not clipBox(nx + f5, nz + z, player_z(id) - 0.45) And Not clipBox(nx + f5, nz + z, player_z(id) + 0.45)
			z - 0.9
		Wend
		If z < -1.36
			player_x(id) = nx
		ElseIf Not player_keystates2(id) & #KEY_CROUCH And player_angle_y(id) < 0.5 And Not player_keystates2(id) & #KEY_SPRINT
			z = 0.35
			While z >= -2.36 And Not clipBox(nx + f5, nz + z, player_z(id) - 0.45) And Not clipBox(nx + f5, nz + z, player_z(id) + 0.45)
				z - 0.9
			Wend
			If z < -2.36
				player_x(id) = nx
				player_climb(id) = 1
			Else
				player_velocity_x(id) = 0.0
			EndIf
		Else
		  player_velocity_x(id) = 0.0
		EndIf
		
		If player_velocity_z(id) < 0.0
			f5 = -0.45
		Else
			f5 = 0.45
		EndIf
		
		z = m
		
		While z >= -1.36 And Not clipBox(player_x(id) - 0.45, nz + z, ny + f5) And Not clipBox(player_x(id) + 0.45, nz + z, ny + f5)
			z - 0.9
		Wend
		If z < -1.36
			player_z(id) = ny
		ElseIf Not player_keystates2(id) & #KEY_CROUCH And player_angle_y(id) < 0.5 And Not player_keystates2(id) & #KEY_SPRINT And Not player_climb(id)
			z = 0.35
			While z >= -2.36 And Not clipBox(player_x(id) - 0.45, nz + z, ny + f5) And Not clipBox(player_x(id) + 0.45, nz + z, ny + f5)
				z - 0.9
			Wend
			If z < -2.36
				player_z(id) = ny
				player_climb(id) = 1
		  Else
				player_velocity_z(id) = 0.0
			EndIf
		ElseIf player_climb(id) = 0
			player_velocity_z(id) = 0.0
		EndIf
		
		If player_climb(id)
			player_velocity_x(id) * 0.5
			player_velocity_z(id) * 0.5
			player_lastClimbTime(id) = getTime()
			nz - 1.0
			m = -1.35
		Else
			If player_velocity_y(id) < 0.0
				m = -m
			EndIf
			nz + player_velocity_y(id) * fsynctics * 32.0
		EndIf
		
		player_airborne(id) = 1
		If clipBox(player_x(id) - 0.45, nz + m, player_z(id) - 0.45) Or clipBox(player_x(id) - 0.45, nz + m, player_z(id) + 0.45) Or clipBox(player_x(id) + 0.45, nz + m, player_z(id) - 0.45) Or clipBox(player_x(id) + 0.45, nz + m, player_z(id) + 0.45)
			If player_velocity_y(id) >= 0.0
			  If player_y(id) > 61.0
			    player_wade(id) = 1
			  Else
			    player_wade(id) = 0
			  EndIf
				player_airborne(id) = 0
			EndIf
			player_velocity_y(id) = 0.0
		Else
			player_y(id) = nz - offset
		EndIf
		repositionPlayer(id)
	EndProcedure
	
Procedure.f player_speed(id.l)
  Define f5.f = 1.0
  If player_airborne(id) = 1
	  f5 * 0.3
  ElseIf player_keystates2(id) & #KEY_CROUCH
	  f5 * 0.6
  ElseIf (player_right_button(id) And IsToolWeapon(id)) Or player_keystates2(id) & #KEY_SNEAK
    f5 * 0.5
  ElseIf player_keystates2(id) & #KEY_SPRINT
    f5 * 1.3
  EndIf
  If (player_keystates2(id) & #KEY_UP Or player_keystates2(id) & #KEY_DOWN) And (player_keystates2(id) & #KEY_RIGHT Or player_keystates2(id) & #KEY_LEFT)
    ;f5 / Sqr(2.0)
  EndIf
  If Not player_keystates2(id) & #KEY_UP And Not player_keystates2(id) & #KEY_DOWN And Not player_keystates2(id) & #KEY_RIGHT And Not player_keystates2(id) & #KEY_LEFT
    f5 = 0.0
  EndIf
  ProcedureReturn f5
EndProcedure
	
Procedure moveplayer(dt.f, id.l)
  If player_keystates2(id) & #KEY_JUMP And Not player_lastJump(id) And IsOnGroundOrWade(id)
			player_velocity_y(id) = -0.36
			player_lastJump(id) = 1
			If getTime() > player_lastJumpTime(id) + 0.1
				player_lastJumpTime(id) = getTime()
			EndIf
		ElseIf Not player_keystates2(id) & #KEY_JUMP
			player_lastJump(id) = 0
		EndIf
				
		Define f5.f = dt
		If player_airborne(id) = 1
			f5 * 0.1
		ElseIf player_keystates2(id) & #KEY_CROUCH
			f5 * 0.3
		ElseIf (player_right_button(id) And IsToolWeapon(id)) Or player_keystates2(id) & #KEY_SNEAK
			f5 * 0.5
		ElseIf player_keystates2(id) & #KEY_SPRINT
			f5 * 1.3
		EndIf
		If (player_keystates2(id) & #KEY_UP Or player_keystates2(id) & #KEY_DOWN) And (player_keystates2(id) & #KEY_RIGHT Or player_keystates2(id) & #KEY_LEFT)
			f5 / Sqr(2.0)
		EndIf
		
		Define front_x.f = player_angle_x(id)
		Define front_z.f = player_angle_z(id)
		
		Define left_x.f = player_angle_z(id)
		Define left_z.f = -player_angle_x(id)
		Define len.f = Sqr(left_x*left_x+left_z*left_z)
		left_x = left_x/len
		left_z = left_z/len

		If player_keystates2(id) & #KEY_UP
		  player_velocity_x(id) + front_x * f5
			player_velocity_z(id) + front_z * f5
		ElseIf player_keystates2(id) & #KEY_DOWN
			player_velocity_x(id) - front_x * f5
			player_velocity_z(id) - front_z * f5
		EndIf
		If player_keystates2(id) & #KEY_LEFT
			player_velocity_x(id) + left_x * f5
			player_velocity_z(id) + left_z * f5
		ElseIf player_keystates2(id) & #KEY_RIGHT
			player_velocity_x(id) - left_x * f5
			player_velocity_z(id) - left_z * f5
		EndIf
		
		f5 = dt + 1.0
		player_velocity_y(id) + dt
		player_velocity_y(id) / f5
				
		If player_wade(id) = 1
			f5 = dt * 6.0 + 1.0
		ElseIf player_airborne(id) = 0
			f5 = dt * 4.0 + 1.0
		EndIf
		
		player_velocity_x(id) / f5
		player_velocity_z(id) / f5
		
		Define f2.f = player_velocity_y(id)
		boxClipMove(dt,id)
		
		;hit ground
		If player_velocity_y(id) = 0.0 And f2 > 0.24
		  player_velocity_x(id) * 0.5
			player_velocity_z(id) * 0.5
			
			If f2 > 0.58
				f2 - 0.58
				;TODO world->GetListener()->PlayerLanded(this, true)
			Else
				;TODO world->GetListener()->PlayerLanded(this, false)
			EndIf
		EndIf
				
		If player_velocity_y(id) >= 0.0 And player_velocity_y(id) < 0.017 And Not player_keystates2(id) & #KEY_SNEAK And Not player_keystates2(id) & #KEY_CROUCH And Not (player_right_button(id) And IsToolWeapon(id))
			;count move distance
			f5 = dt * 32.0
			Define dx.f = f5 * player_velocity_x(id)
			Define dy.f = f5 * player_velocity_z(id)
			Define dist.f = Sqr(dx*dx+dy*dy)
			player_moveDistance(id) + dist * 0.3
			
			Define madeFootstep.l = 0
			While player_moveDistance(id) > 1.0
				player_moveSteps(id) + 1
				player_moveDistance(id) - 1.0
				
				If madeFootstep = 0
				  If player_wade(id) = 1
				    player_step_sound_id(id) = createSoundSource(4+Random(3),player_x(id),player_y(id),player_z(id),24.0)
				  Else
				    player_step_sound_id(id) = createSoundSource(Random(3),player_x(id),player_y(id),player_z(id),24.0)
				  EndIf
					madeFootstep = 1
				EndIf
			Wend
		EndIf
EndProcedure
; IDE Options = PureBasic 5.31 (Windows - x86)
; CursorPosition = 68
; FirstLine = 27
; Folding = --
; EnableUnicode
; EnableXP
; UseMainFile = main.pb