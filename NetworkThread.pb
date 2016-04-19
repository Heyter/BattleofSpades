Global network_connected = 0
Global network_thread_id = 0
Global network_ping = 0
Global connection_error = 0
Global player_update_ongoing.l = 0
Global first_team_join.l = 1

Global game_mode.l = -1

#CONNECTION_ERROR_DISCONNECT = 1
#CONNECTION_ERROR_MAP_DATA_CORRUPTED = 100
#NETWORK_PROTOCOL_VERSION_075 = 3
#NETWORK_PROTOCOL_VERSION_076 = 4

#ENET_NONE = 0
#ENET_CONNECT = 1
#ENET_DISCONNECT = 2
#ENET_RECIEVE = 3

#GAMEMODE_CTF = 0
#GAMEMODE_TC = 1

#DAMAGE_SOURCE_FALL = 0
#DAMAGE_SOURCE_WEAPON = 1

#MAX_CHAT_LENGTH = 90

Declare sendOSHandshakeReturn(a.l)
Declare sendOSVersion()

Procedure sendpacket(packetdata.l, len.l)
  CallCFunction(0,"sendpacketdata", packetdata, len)
EndProcedure

Procedure networkThread(*unused)
  Repeat
    network_ping = CallCFunction(0,"getping")
    Define event = CallCFunction(0,"clientcheckforevent",5000)
  If event = #ENET_RECIEVE ;recieve
    Define packet_pointer = CallCFunction(0,"getpacketdata")
    Define packet_len = CallCFunction(0,"getpacketlen")
    Define packet_id = PeekA(packet_pointer)
    ;Debug "PACKET: "+Str(packet_id)
    If packet_id = 0 ;position update
       player_x(own_player_id) = PeekF(packet_pointer+1)
       player_z(own_player_id) = PeekF(packet_pointer+5)
       player_y(own_player_id) = 64.0-PeekF(packet_pointer+9)+0.5
    EndIf
    If packet_id = 1 ;orientation update
      Debug "orientation update!"
    EndIf
    If packet_id = 2 And ReadPreferenceInteger("use_076",0) = 0 ;position update for all players
      player_update_ongoing = 1
      player_old_position_time = player_new_position_time
      player_new_position_time = ElapsedMilliseconds()
      Define k
      For k=0 To 31
        If Not k = own_player_id
          player_old_x(k) = player_x(k)
          player_old_y(k) = player_y(k)
          player_old_z(k) = player_z(k)
          player_x(k) = PeekF(packet_pointer+1+k*24)
          player_z(k) = PeekF(packet_pointer+5+k*24)
          player_y(k) = (64.0-PeekF(packet_pointer+9+k*24))+0.5
          player_old_angle_x(k) = player_angle_x(k)
          player_old_angle_y(k) = player_angle_y(k)
          player_old_angle_z(k) = player_angle_z(k)
          player_angle_x(k) = PeekF(packet_pointer+13+k*24)
          player_angle_z(k) = PeekF(packet_pointer+17+k*24)
          player_angle_y(k) = -PeekF(packet_pointer+21+k*24)
        EndIf
      Next
      player_update_ongoing = 0
    EndIf
    If packet_id = 2 And ReadPreferenceInteger("use_076",0) = 1 ;position update for all players
      player_update_ongoing = 1
      player_old_position_time = player_new_position_time
      player_new_position_time = ElapsedMilliseconds()
      Define k
      For k=0 To 31
        Define player_id = PeekA(packet_pointer+1)
        If Not player_id = own_player_id And player_id > -1 And player_id < 32
          player_old_x(player_id) = player_x(player_id)
          player_old_y(player_id) = player_y(player_id)
          player_old_z(player_id) = player_z(player_id)
          player_x(player_id) = PeekF(packet_pointer+2+k*25)
          player_z(player_id) = PeekF(packet_pointer+6+k*25)
          player_y(player_id) = (64.0-PeekF(packet_pointer+10+k*25))+0.5
          player_old_angle_x(player_id) = player_angle_x(player_id)
          player_old_angle_y(player_id) = player_angle_y(player_id)
          player_old_angle_z(player_id) = player_angle_z(player_id)
          player_angle_x(player_id) = PeekF(packet_pointer+14+k*25)
          player_angle_z(player_id) = PeekF(packet_pointer+18+k*25)
          player_angle_y(player_id) = -PeekF(packet_pointer+22+k*25)
        EndIf
      Next
      player_update_ongoing = 0
    EndIf
    If packet_id = 3 ;input data
      Define player_id = PeekA(packet_pointer+1)
      Define key_states = PeekA(packet_pointer+2)
      player_keystates2(player_id) = key_states
    EndIf
    If packet_id = 4 ;weapon input
      Define player_id = PeekA(packet_pointer+1)
      Define type = PeekA(packet_pointer+2)
      If type = 0
        player_left_button(player_id) = 0
        player_right_button(player_id) = 0
      EndIf
      If type = 1
        player_left_button(player_id) = 1
        player_right_button(player_id) = 0
      EndIf
      If type = 2
        player_left_button(player_id) = 0
        player_right_button(player_id) = 1
      EndIf
      If type = 3
        player_left_button(player_id) = 1
        player_right_button(player_id) = 1
      EndIf
    EndIf
    If packet_id = 5 ;set hp
      Define hp = PeekA(packet_pointer+1)
      Define type = PeekA(packet_pointer+2)
      Define x_pos = PeekF(packet_pointer+3)
      Define z_pos = PeekF(packet_pointer+7)
      Define y_pos = 64.0-PeekF(packet_pointer+11)
      own_hp = hp
      last_damage_source_time = ElapsedMilliseconds()
      last_damage_source_type = type
      last_damage_source_x = x_pos
      last_damage_source_y = y_pos
      last_damage_source_z = z_pos
      If type = 1
        createSoundSourceAtCamera(24)
      Else
        createSoundSourceAtCamera(26)
      EndIf
    EndIf
    If packet_id = 6 ;spawn grenade
      Define player_id = PeekA(packet_pointer+1) ;not really needed
      Define fuse.f = PeekF(packet_pointer+2)
      Define pos_x.f = PeekF(packet_pointer+6)
      Define pos_z.f = PeekF(packet_pointer+10)
      Define pos_y.f = PeekF(packet_pointer+14)
      Define v_x.f   = PeekF(packet_pointer+18)
      Define v_z.f   = PeekF(packet_pointer+22)
      Define v_y.f   = PeekF(packet_pointer+26)
      spawnGrenade(pos_x,pos_y,pos_z,v_x,v_y,v_z,fuse)
    EndIf
    If packet_id = 7 ;set tool
      Define player_id = PeekA(packet_pointer+1)
      Define tool = PeekA(packet_pointer+2)
      player_item(player_id) = tool
    EndIf
    If packet_id = 8 ;set block color
      Define player_id = PeekA(packet_pointer+1)
      Define block_blue = PeekA(packet_pointer+2)
      Define block_green = PeekA(packet_pointer+3)
      Define block_red = PeekA(packet_pointer+4)
      player_block_color_red(player_id) = block_red
      player_block_color_green(player_id) = block_green
      player_block_color_blue(player_id) = block_blue
    EndIf
    If packet_id = 9 ;existing player
      Define player_id = PeekA(packet_pointer+1)
      Define team = PeekB(packet_pointer+2)
      Define weapon = PeekA(packet_pointer+3)
      Define held_item = PeekA(packet_pointer+4)
      Define kills = PeekL(packet_pointer+5) ;short would fit better here
      Define block_blue = PeekA(packet_pointer+9)
      Define block_green = PeekA(packet_pointer+10)
      Define block_red = PeekA(packet_pointer+11)
      namelist(player_id) = PeekS(packet_pointer+12,16,#PB_UTF8)
      teamlist(player_id) = team
      weaponlist(player_id) = weapon
      player_item(player_id) = held_item
      player_kills(player_id) = kills
      player_deaths(player_id) = 0
      player_block_color_red(player_id) = block_red
      player_block_color_green(player_id) = block_green
      player_block_color_blue(player_id) = block_blue
      player_ammo(player_id) = mag_size(weapon)
	    player_lastJump(player_id) = 0
	    player_lastJumpTime(player_id) = -100
	    player_lastClimbTime(player_id) = -100
	    player_airborne(player_id) = 0
	    player_moveDistance(player_id) = 0.0
	    player_moveSteps(player_id) = 0
	    player_connected(player_id) = 1
	    player_blocks(player_id) = 50
	    player_draw_line(player_id) = 0
	    If player_id = own_player_id
	      own_hp = 100
	    EndIf
    EndIf
    If packet_id = 10 ;short player data
      Debug "Recieved unexpected short player data!"
    EndIf
    If packet_id = 11 ;move object
      Define id = PeekA(packet_pointer+1)
      Define team = PeekA(packet_pointer+2)
      Define pos_x.f = PeekF(packet_pointer+3)
      Define pos_z.f = PeekF(packet_pointer+7)
      Define pos_y.f = 64.0-PeekF(packet_pointer+11)
      If game_mode = #GAMEMODE_CTF
        If id = 0 ;blue intel
          team_1_intel_player = -1
          team_1_intel_x = pos_x
          team_1_intel_y = pos_y
          team_1_intel_z = pos_z
        EndIf
        If id = 1 ;green intel
          team_2_intel_player = -1
          team_2_intel_x = pos_x
          team_2_intel_y = pos_y
          team_2_intel_z = pos_z
        EndIf
        If id = 2 ;blue base
          team_1_base_x = pos_x
          team_1_base_y = pos_y
          team_1_base_z = pos_z
        EndIf
        If id = 3 ;green base
          team_2_base_x = pos_x
          team_2_base_y = pos_y
          team_2_base_z = pos_z
        EndIf
      EndIf
      If game_mode = #GAMEMODE_TC And id>-1 And id<=tent_count
        tent_x(id) = pos_x
        tent_y(id) = pos_y
        tent_z(id) = pos_z
        tent_team(id) = team
      EndIf
    EndIf
    If packet_id = 12 ;create player
      Define player_id = PeekA(packet_pointer+1)
      Define weapon = PeekA(packet_pointer+2)
      Define team = PeekB(packet_pointer+3)
      Define player_pos_x.f = PeekF(packet_pointer+4)
      Define player_pos_z.f = PeekF(packet_pointer+8)
      Define player_pos_y.f = 64.0-PeekF(packet_pointer+12)+0.5
      namelist(player_id) = PeekS(packet_pointer+16,16,#PB_UTF8)
      If player_connected(player_id) = 0
        ;new player, show join message
        For k=0 To 14
          chat_message(k) = chat_message(k+1)
          chat_message_color(k) = chat_message_color(k+1)
          chat_message_time(k) = chat_message_time(k+1)
        Next
        chat_message(15) = namelist(player_id)+" connected"
        chat_message_color(15) = -1
        chat_message_time(15) = ElapsedMilliseconds()
      EndIf
      player_x(player_id) = player_pos_x
      player_y(player_id) = player_pos_y
      player_z(player_id) = player_pos_z
      player_old_x(player_id) = player_pos_x
      player_old_y(player_id) = player_pos_y
      player_old_z(player_id) = player_pos_z
      player_item(player_id) = 2
      weaponlist(player_id) = weapon
      player_dead(player_id) = 0
      player_ammo(player_id) = mag_size(weapon)
      teamlist(player_id) = team
	    player_lastJump(player_id) = 0
	    player_lastJumpTime(player_id) = -100
	    player_lastClimbTime(player_id) = -100
	    player_airborne(player_id) = 0
	    player_moveDistance(player_id) = 0.0
	    player_moveSteps(player_id) = 0
	    player_connected(player_id) = 1
	    player_blocks(player_id) = 50
	    player_draw_line(player_id) = 0
      If player_id = own_player_id
        own_hp = 100
        own_team = team
        own_weapon = weapon
        own_item = 2
        
        own_ammo = mag_size(own_weapon)
        own_max_ammo = max_ammo(own_weapon)
        
        own_dead = 0
      EndIf
    EndIf
    If packet_id = 13 ;block update
      Define player_id = PeekA(packet_pointer+1)
      Define action = PeekA(packet_pointer+2)
      Define x_pos = PeekL(packet_pointer+3)
      Define z_pos = PeekL(packet_pointer+7)
      Define y_pos = 64-PeekL(packet_pointer+11)
      If action > 0 ;destroy
        Define old_color.l = getBlockSafe(x_pos,y_pos,z_pos)
        setBlockSafe(x_pos,y_pos,z_pos,$FFFFFFFF)
        If action = 1
          spawnParticleCloud(64,x_pos+0.5,y_pos+0.5,z_pos+0.5,0.15,0.0625,0.2,old_color)
        EndIf
        If action = 1 Or action = 2
          createSoundSource(20,x_pos+0.5,y_pos+0.5,z_pos+0.5,16.0) ;normal dig sound
          If action = 2 ;big dig
            setBlockSafe(x_pos,y_pos+1,z_pos,$FFFFFFFF)
            setBlockSafe(x_pos,y_pos-1,z_pos,$FFFFFFFF)
          EndIf
        EndIf
        If action = 3
          Define x,y,z
          For y = y_pos-1 To y_pos+1
            For z = z_pos-1 To z_pos+1
              For x = x_pos-1 To x_pos+1
                setBlockSafe(x,y,z,$FFFFFFFF)
              Next
            Next
          Next
        EndIf
        If isBlockSolid(getBlockSafe(x_pos,y_pos+1,z_pos)) And isFloating(x_pos,y_pos+1,z_pos)
          destoryFloatingStructure()
        EndIf
        If isBlockSolid(getBlockSafe(x_pos+1,y_pos,z_pos)) And isFloating(x_pos+1,y_pos,z_pos)
          destoryFloatingStructure()
        EndIf
         If isBlockSolid(getBlockSafe(x_pos-1,y_pos,z_pos)) And isFloating(x_pos-1,y_pos,z_pos)
          destoryFloatingStructure()
        EndIf
         If isBlockSolid(getBlockSafe(x_pos,y_pos,z_pos+1)) And isFloating(x_pos,y_pos,z_pos+1)
          destoryFloatingStructure()
        EndIf
         If isBlockSolid(getBlockSafe(x_pos,y_pos,z_pos-1)) And isFloating(x_pos,y_pos,z_pos-1)
          destoryFloatingStructure()
        EndIf
         If isBlockSolid(getBlockSafe(x_pos,y_pos-1,z_pos)) And isFloating(x_pos,y_pos-1,z_pos)
          destoryFloatingStructure()
        EndIf
      EndIf
      If action = 0 ;build
        setBlockSafe(x_pos,y_pos,z_pos,RGB(player_block_color_red(player_id),player_block_color_green(player_id),player_block_color_blue(player_id)))
        createSoundSource(8,x_pos+0.5,y_pos+0.5,z_pos+0.5,16.0)
      EndIf
    EndIf
    If packet_id = 14 ;block line
      Define player_id = PeekA(packet_pointer+1)
      Define x_start = PeekL(packet_pointer+2)
      Define z_start = PeekL(packet_pointer+6)
      Define y_start = 64-PeekL(packet_pointer+10)
      Define x_end = PeekL(packet_pointer+14)
      Define z_end = PeekL(packet_pointer+18)
      Define y_end = 64-PeekL(packet_pointer+22)
      cube_line(x_start,y_start,z_start,x_end,y_end,z_end,RGB(player_block_color_red(player_id),player_block_color_green(player_id),player_block_color_blue(player_id)))
    EndIf
    If packet_id = 15 ;state data (map transfer complete)
      Define decompression_result =  zlib_inflateInit2(map_data, @map_data_size, map_data_compressed, map_data_compressed_index)
      If decompression_result < 0
        network_connected = 0
        network_ping = 0
        network_thread_id = 0
        connection_error = #CONNECTION_ERROR_MAP_DATA_CORRUPTED-decompression_result
      EndIf
      map_unload()
      map_loadfromdata()
      
      own_player_id = PeekA(packet_pointer+1)
      
      map_fog_blue = PeekA(packet_pointer+2)
      map_fog_green = PeekA(packet_pointer+3)
      map_fog_red = PeekA(packet_pointer+4)
      
      team_1_blue = PeekA(packet_pointer+5)
      team_1_green = PeekA(packet_pointer+6)
      team_1_red = PeekA(packet_pointer+7)
      
      team_2_blue = PeekA(packet_pointer+8)
      team_2_green = PeekA(packet_pointer+9)
      team_2_red = PeekA(packet_pointer+10)
      
      team_1_name.s = PeekS(packet_pointer+11,10,#PB_UTF8)
      team_2_name.s = PeekS(packet_pointer+21,10,#PB_UTF8)
      
      Define gamemode_id = PeekA(packet_pointer+31)
      
      game_mode = gamemode_id
      
      If gamemode_id = #GAMEMODE_CTF
        team_1_score = PeekA(packet_pointer+32)
        team_2_score = PeekA(packet_pointer+33)
        score_max = PeekA(packet_pointer+34)
        Define intel_flag = PeekA(packet_pointer+35)
        If intel_flag = 0
          team_1_intel_player = -1
          team_1_intel_x = PeekF(packet_pointer+36)
          team_1_intel_z = PeekF(packet_pointer+40)
          team_1_intel_y = 64.0-PeekF(packet_pointer+44)
          team_2_intel_player = -1
          team_2_intel_x = PeekF(packet_pointer+48)
          team_2_intel_z = PeekF(packet_pointer+52)
          team_2_intel_y = 64.0-PeekF(packet_pointer+56)
        EndIf
        If intel_flag = 1
          team_1_intel_player = PeekA(packet_pointer+36)
          team_2_intel_player = -1
          team_2_intel_x = PeekF(packet_pointer+48)
          team_2_intel_z = PeekF(packet_pointer+52)
          team_2_intel_y = 64.0-PeekF(packet_pointer+56)
        EndIf
        If intel_flag = 2
          team_1_intel_player = -1
          team_1_intel_x = PeekF(packet_pointer+36)
          team_1_intel_z = PeekF(packet_pointer+40)
          team_1_intel_y = 64.0-PeekF(packet_pointer+44)
          team_2_intel_player = PeekA(packet_pointer+48)
        EndIf
        If intel_flag = 3
          team_1_intel_player = PeekA(packet_pointer+36)
          team_2_intel_player = PeekA(packet_pointer+48)
        EndIf
        team_1_base_x = PeekF(packet_pointer+60)
        team_1_base_z = PeekF(packet_pointer+64)
        team_1_base_y = 64.0-PeekF(packet_pointer+68)
        team_2_base_x = PeekF(packet_pointer+72)
        team_2_base_z = PeekF(packet_pointer+76)
        team_2_base_y = 64.0-PeekF(packet_pointer+80)
      EndIf
      If gamemode_id = #GAMEMODE_TC
        tent_count = PeekA(packet_pointer+32)
        Define k
        For k=0 To tent_count-1
          tent_x(k) = PeekF(packet_pointer+33+k*13)
          tent_z(k) = PeekF(packet_pointer+37+k*13)
          tent_y(k) = 64.0-PeekF(packet_pointer+41+k*13)
          tent_team(k) = PeekA(packet_pointer+42+k*13)
          tent_progress(k) = 1.0
          tent_progress_team(k) = 2
        Next
      EndIf
      If Not gamemode_id = #GAMEMODE_CTF And Not gamemode_id = #GAMEMODE_TC
        MessageRequester("Network thread","Unsupported gamemode "+Str(gamemode_id)+" :(")
      EndIf
      
      For k=0 To 31
        namelist(player_id) = ""
        teamlist(player_id) = 0
        weaponlist(player_id) = 0
        player_x(player_id) = 0.0
        player_y(player_id) = 64.0
        player_z(player_id) = 0.0
        player_old_x(player_id) = 0.0
        player_old_y(player_id) = 64.0
        player_old_z(player_id) = 0.0
        player_dead(player_id) = 0
        player_kills(player_id) = 0
        player_deaths(player_id) = 0
        player_keystates2(player_id) = 0
        player_left_button(player_id) = 0
        player_right_button(player_id) = 0
        player_secounds_till_respawn(player_id) = 0
        player_angle_x(player_id) = 0.0
        player_angle_y(player_id) = 0.0
        player_angle_z(player_id) = 0.0
        player_old_angle_x(player_id) = 0.0
        player_old_angle_y(player_id) = 0.0
        player_old_angle_z(player_id) = 0.0
        player_ammo(player_id) = 0
        player_connected(player_id) = 0
        player_blocks(player_id) = 50
        player_draw_line(player_id) = 0
      Next
      
      own_team = -1
      own_kills = 0
      own_deaths = 0
      own_dead = 0
      own_hp = 100
      own_item = 2
      first_team_join = 1
      
      createSoundSourceAtCamera(21)
      
      Debug "map complete!"
    EndIf
    If packet_id = 16 ;kill action
      Define killed_player_id = PeekA(packet_pointer+1)
      Define killer_id = PeekA(packet_pointer+2)
      Define type = PeekA(packet_pointer+3)
      Define seconds = PeekA(packet_pointer+4)-1
      player_secounds_till_respawn(killed_player_id) = seconds
      player_dead(killed_player_id) = 1
      player_death_time(killed_player_id) = ElapsedMilliseconds()
      player_deaths(killed_player_id) + 1
      player_keystates2(killed_player_id) = 0
      Define free_index = 0
      Define time = 0
      Define a = ElapsedMilliseconds()
      For k = 0 To 15
        If a-kill_action_time(k)>time
          free_index = k
          time = a-kill_action_time(k)
        EndIf
      Next
      kill_action_time(free_index) = ElapsedMilliseconds()
      If type = 4
        kill_action_message(free_index) = namelist(killed_player_id)+" fell too far"
        kill_action_team(free_index) = teamlist(killed_player_id)
        createSoundSource(10,player_x(killed_player_id),player_y(killed_player_id),player_z(killed_player_id),16.0)
      EndIf
      If type = 5
        kill_action_message(free_index) = namelist(killed_player_id)+" changed teams"
        kill_action_team(free_index) = teamlist(killed_player_id)
      EndIf
      If type = 6
        kill_action_message(free_index) = namelist(killed_player_id)+" changed weapons"
        kill_action_team(free_index) = teamlist(killed_player_id)
      EndIf
      If type < 4
        If type = 0
          kill_action_message(free_index) = namelist(killer_id)+" killed "+namelist(killed_player_id)+" ("+weapon_type(weaponlist(killer_id))+")"
        Else
          kill_action_message(free_index) = namelist(killer_id)+" killed "+namelist(killed_player_id)+" ("+kill_type(type)+")"
        EndIf
        player_kills(killer_id) + 1
        kill_action_team(free_index) = teamlist(killer_id)
        createSoundSource(11,player_x(killed_player_id),player_y(killed_player_id),player_z(killed_player_id),16.0)
      EndIf
      If killer_id = own_player_id
        kill_action_team(free_index) = -1
      EndIf
    EndIf
    If packet_id = 17 ;chat message
      Define player_id = PeekA(packet_pointer+1)
      Define chat_type = PeekA(packet_pointer+2)
      If player_id < 0 Or player_id > 32
        chat_type = 2
      EndIf
      For k=0 To 14
        chat_message(k) = chat_message(k+1)
        chat_message_color(k) = chat_message_color(k+1)
        chat_message_time(k) = chat_message_time(k+1)
      Next
      If chat_type < 2
        Define teamname$ = "Spectator"
        If teamlist(player_id) = 0
          teamname$ = team_1_name
        EndIf
        If teamlist(player_id) = 1
          teamname$ = team_2_name
        EndIf
        chat_message(15) = namelist(player_id)+"("+teamname$+"): "+PeekS(packet_pointer+3,packet_len-3,#PB_UTF8)
        chat_message_color(15) = teamlist(player_id)
        chat_message_time(15) = ElapsedMilliseconds()
      EndIf
      If chat_type = 2
        chat_message(15) = PeekS(packet_pointer+3,packet_len-3,#PB_UTF8)
        chat_message_color(15) = -1
        chat_message_time(15) = ElapsedMilliseconds()
      EndIf
    EndIf
    If packet_id = 18 ;map start
      map_data = 0
      map_data_size = 0
      map_data_index = 0
      map_data_compressed = 0
      map_data_compressed_size = 0
      map_data_compressed_index = 0
      
      map_data_size = PeekL(packet_pointer+1)
      Debug map_data_size
      map_data_compressed = AllocateMemory(8*1024*1024) ;just use the uncompressed size (assume compressed is smaller)
      map_data = AllocateMemory(8*1024*1024)
      map_data_compressed_index = 0
      map_data_index = 0
    EndIf
    If packet_id = 19 ;map chunk
      ;Debug "map data!"
      For k=0 To packet_len-2
        PokeB(map_data_compressed+map_data_compressed_index+k,PeekB(packet_pointer+1+k))
      Next
      map_data_compressed_index + packet_len-1
    EndIf
    If packet_id = 20 ;player left
      player_id = PeekA(packet_pointer+1)
      For k=0 To 14
        chat_message(k) = chat_message(k+1)
        chat_message_color(k) = chat_message_color(k+1)
        chat_message_time(k) = chat_message_time(k+1)
      Next
      chat_message(15) = namelist(player_id)+" disconnected"
      chat_message_color(15) = -1
      chat_message_time(15) = ElapsedMilliseconds()
      namelist(player_id) = ""
      teamlist(player_id) = 0
      weaponlist(player_id) = 0
      player_x(player_id) = 0.0
      player_y(player_id) = 0.0
      player_z(player_id) = 0.0
      player_old_x(player_id) = 0.0
      player_old_y(player_id) = 0.0
      player_old_z(player_id) = 0.0
      player_dead(player_id) = 0
      player_kills(player_id) = 0
      player_deaths(player_id) = 0
      player_keystates2(player_id) = 0
      player_left_button(player_id) = 0
      player_right_button(player_id) = 0
      player_secounds_till_respawn(player_id) = 0
      player_angle_x(player_id) = 0.0
      player_angle_y(player_id) = 0.0
      player_angle_z(player_id) = 0.0
      player_old_angle_x(player_id) = 0.0
      player_old_angle_y(player_id) = 0.0
      player_old_angle_z(player_id) = 0.0
      player_ammo(player_id) = 0
      player_connected(player_id) = 0
    EndIf
    If packet_id = 21 And game_mode = #GAMEMODE_TC ;territory capture
      Define object = PeekA(packet_pointer+1)
      Define winning = PeekA(packet_pointer+2)
      Define team = PeekA(packet_pointer+3)
      If object >= 0 And object < 16
        tent_team(object) = team
        tent_progress(object) = 1.0
        tent_progress_team(object) = team
      EndIf
      If winning = 1 And team = own_team
        createSoundSourceAtCamera(25)
      EndIf
    EndIf
    If packet_id = 22 And game_mode = #GAMEMODE_TC ;progressbar
      Define object = PeekA(packet_pointer+1)
      Define team_capturing = PeekA(packet_pointer+2)
      Define rate = PeekA(packet_pointer+3) ;aka capture speed
      Define progress.f = PeekF(packet_pointer+4)
      If object >= 0 And object < 16 And progress >= 0.0 And progress <= 1.0 And team_capturing >= 0 And team_capturing<3
        tent_progress(object) = progress
        tent_progress_team(object) = team_capturing
      EndIf
    EndIf
    If packet_id = 23 And game_mode = #GAMEMODE_CTF ;intel capture
      Define player_id = PeekA(packet_pointer+1)
      Define winning = PeekA(packet_pointer+2)
      player_kills(player_id) + 10
      If teamlist(player_id) = 0
        team_1_score + 1
      EndIf
      If teamlist(player_id) = 1
        team_2_score + 1
      EndIf
      If winning = 1 And teamlist(player_id) = own_team
        createSoundSourceAtCamera(25)
      EndIf
    EndIf
    If packet_id = 24 And game_mode = #GAMEMODE_CTF ;intel pickup
      player_id = PeekA(packet_pointer+1)
      If teamlist(player_id) = 0
        team_2_intel_player = player_id
      EndIf
      If teamlist(player_id) = 1
        team_1_intel_player = player_id
      EndIf
    EndIf
    If packet_id = 25 And game_mode = #GAMEMODE_CTF ;intel drop
      Define player_id = PeekA(packet_pointer+1)
      Define intel_x.f = PeekF(packet_pointer+2)
      Define intel_z.f = PeekF(packet_pointer+6)
      Define intel_y.f = 64.0-PeekF(packet_pointer+10)
      If teamlist(player_id) = 0
        team_2_intel_player = -1
        team_2_intel_x = intel_x
        team_2_intel_y = intel_y
        team_2_intel_z = intel_z
      EndIf
      If teamlist(player_id) = 1
        team_1_intel_player = -1
        team_1_intel_x = intel_x
        team_1_intel_y = intel_y
        team_1_intel_z = intel_z
      EndIf
    EndIf
    If packet_id = 26 ;player restock
      player_id = PeekA(packet_pointer+1)
      player_ammo(player_id) = mag_size(weaponlist(player_id))
      own_ammo = mag_size(own_weapon)
      own_max_ammo = max_ammo(own_weapon)
      own_hp = 100
      player_blocks(own_player_id) = 50
    EndIf
    If packet_id = 27 ;set fog color
      map_fog_blue = PeekA(packet_pointer+2)
      map_fog_green = PeekA(packet_pointer+3)
      map_fog_red = PeekA(packet_pointer+4)
    EndIf
    If packet_id = 28 ;weapon reload
      Define player_id = PeekA(packet_pointer+1)
      Define clip_ammo = PeekA(packet_pointer+2)
      Define reserve_ammo = PeekA(packet_pointer+3)
      player_ammo(player_id) = clip_ammo
      If Not player_id = own_player_id
        createSoundSource(12+weaponlist(player_id),player_x(player_id),player_y(player_id),player_z(player_id),16.0)
      EndIf
    EndIf
    If packet_id = 29 ;change team (only server side)
      
    EndIf
    If packet_id = 30 ;change weapon
      player_id = PeekA(packet_pointer+1)
      weapon = PeekA(packet_pointer+2)
      weaponlist(player_id) = weapon
    EndIf
    
    If packet_id = 31 And ReadPreferenceInteger("use_076",0) = 1 ;map cached
      Define cached.l = PeekA(packet_pointer+1)
      MessageRequester("Network thread",Str(cached))
    EndIf
      
    
    If ReadPreferenceInteger("imitate_openspades",0) = 1
      If packet_id = 31 ;handshake init
        sendOSHandshakeReturn(PeekL(packet_pointer+1))
      EndIf
      If packet_id = 33 ;version get
        sendOSVersion()
      EndIf
    EndIf
    
    
    If packet_id = 40 ;FUTURE: LOAD KV6 FROM URL
      Define kv6_id = PeekA(packet_pointer+1)
      Define url$ = PeekS(packet_pointer+2,packet_len-2,#PB_UTF8)
    EndIf
    If packet_id = 41 ;FUTURE: ASSIGN KV6 TO OBJECT
      Define object_id = PeekA(packet_pointer+1)
      Define kv6_id = PeekA(packet_pointer+2)
    EndIf
    If packet_id = 42 ;FUTURE: ROTATE OBJECT
      Define object_id = PeekA(packet_pointer+1)
      Define rot_x.f = PeekF(packet_pointer+2)
      Define rot_z.f = PeekF(packet_pointer+6)
      Define rot_y.f = 64.0-PeekF(packet_pointer+10)
    EndIf
    If packet_id = 43 ;FUTURE: CREATE OBJECT
      Define object_id = PeekA(packet_pointer+1)
    EndIf
    If packet_id = 44 ;FUTURE: DESTORY OBJECT
      Define object_id = PeekA(packet_pointer+1)
    EndIf
    CallCFunction(0,"destroypacket")
  EndIf
  If event = #ENET_DISCONNECT ;disconnect
    CallCFunction(0,"resetpeer")
    CallCFunction(0,"destroyclient")
    network_connected = 0
    network_ping = 0
    network_thread_id = 0
    connection_error = #CONNECTION_ERROR_DISCONNECT+CallCFunction(0,"geteventdata")
    Break
  EndIf
  ForEver
EndProcedure

Procedure sendOSHandshakeReturn(a.l)
  Define packetdata.l = AllocateMemory(5)
  PokeA(packetdata,32)
  PokeL(packetdata+1,a)
  sendpacket(packetdata,5)
EndProcedure

Procedure sendOSVersion()
  Define packetdata.l = AllocateMemory(16)
  PokeA(packetdata,34)
  PokeA(packetdata+1,'o')
  PokeA(packetdata+2,0)
  PokeA(packetdata+3,0)
  PokeA(packetdata+4,12)
  PokeS(packetdata+5,"Windows XP",Len("Windows XP"),#PB_UTF8)
  PokeA(packetdata+15,0)
  sendpacket(packetdata,16)
EndProcedure


Procedure sendGrenade(x.f, y.f, z.f, defuse_time.l)
  Define packetdata.l = AllocateMemory(30)
  PokeA(packetdata,6) ;spawn grenade
  PokeA(packetdata+1,own_player_id)
  PokeF(packetdata+2,defuse_time)
  PokeF(packetdata+6,x)
  PokeF(packetdata+10,z)
  PokeF(packetdata+14,64.0-y)
  Define vector_x.f = Sin(camera_rot_x)*Sin(camera_rot_y)*100.0
  Define vector_y.f = Cos(camera_rot_y)*100.0
  Define vector_z.f = Cos(camera_rot_x)*Sin(camera_rot_y)*100.0
  PokeF(packetdata+18,vector_x)
  PokeF(packetdata+22,vector_z)
  PokeF(packetdata+26,-vector_y)
  sendpacket(packetdata,30)
EndProcedure

Procedure sendBlockLine(player_id.l,sx.l,sy.l,sz.l,ex.l,ey.l,ez.l)
  Define packetdata.l = AllocateMemory(26)
  PokeA(packetdata,14) ;block line
  PokeA(packetdata+1,player_id)
  PokeL(packetdata+2,sx)
  PokeL(packetdata+6,sz)
  PokeL(packetdata+10,64-sy)
  PokeL(packetdata+14,ex)
  PokeL(packetdata+18,ez)
  PokeL(packetdata+22,64-ey)
  sendpacket(packetdata,26)
EndProcedure

Procedure sendTool(tool.l)
  Define packetdata.l = AllocateMemory(3)
  PokeA(packetdata,7) ;set tool
  PokeA(packetdata+1,own_player_id)
  PokeA(packetdata+2,tool)
  sendpacket(packetdata,3)
EndProcedure

Procedure sendChat(team.l,message$)
  Define k
  For k=0 To Len(message$)/#MAX_CHAT_LENGTH-1
    Define packetdata.l = AllocateMemory(Len(message$)+3)
    PokeA(packetdata,17) ;chat message
    PokeA(packetdata+1,own_player_id)
    PokeA(packetdata+2,team)
    Define len.l = 90
    If k = Len(message$)/#MAX_CHAT_LENGTH-1
      len = Len(message$)-k*90
    EndIf
    PokeS(packetdata+3,Mid(message$,k*90+1,len),len,#PB_UTF8)
    sendpacket(packetdata,Len(message$)+3)
  Next
EndProcedure

Global last_position_update.l
Procedure positiondata(x_pos.f,y_pos.f,z_pos.f)
   If ElapsedMilliseconds()-last_position_update>1000
     
     Define packetdata.l = AllocateMemory(13)
     PokeA(packetdata,0) ;position data
     PokeF(packetdata+1,x_pos)
     PokeF(packetdata+5,z_pos)
     PokeF(packetdata+9,64.0-y_pos)
     sendpacket(packetdata,13)
     
     last_position_update = ElapsedMilliseconds()
   EndIf
EndProcedure

Global last_key_states.l
Procedure inputdata(forward.l,backward.l,left.l,right.l,shift.l,ctrl.l,sneak.l,space.l)
  Define key_states.l = 0
  If forward = 1
    key_states + 1
  EndIf
  If backward = 1
    key_states + 2
  EndIf
  If left = 1
    key_states + 4
  EndIf
  If right = 1
    key_states + 8
  EndIf
  If space = 1
    key_states + 16
  EndIf
  If ctrl = 1
    key_states + 32
  EndIf
  If sneak = 1
    key_states + 64
  EndIf
  If shift = 1
    key_states + 128
  EndIf
  If Not key_states = last_key_states
    Define packetdata.l = AllocateMemory(3)
    PokeA(packetdata,3) ;input data
    PokeA(packetdata+1,own_player_id)
    PokeA(packetdata+2,key_states)
    sendpacket(packetdata,3)
    last_key_states = key_states
  EndIf
EndProcedure

Global last_weapon_input.l
Procedure weaponinput(left.l,right.l)
  Define weapon_input.l = 0
  If left = 1
    weapon_input + 1
  EndIf
  If right = 1
    weapon_input + 2
  EndIf
  If Not weapon_input = last_weapon_input
    Define packetdata.l = AllocateMemory(3)
    PokeA(packetdata,4) ;weapon input
    PokeA(packetdata+1,own_player_id)
    PokeA(packetdata+2,weapon_input)
    sendpacket(packetdata,3)
    last_weapon_input = weapon_input
  EndIf
EndProcedure

Global last_orientation_update.l
Procedure orientationdata(x_o.f,y_o.f,z_o.f)
  If ElapsedMilliseconds()-last_orientation_update>100
    Define packetdata.l = AllocateMemory(13)
    PokeA(packetdata,1) ;orientation data
    PokeF(packetdata+1,x_o)
    PokeF(packetdata+5,z_o)
    PokeF(packetdata+9,-y_o)
    sendpacket(packetdata,13)
    last_orientation_update = ElapsedMilliseconds()
  EndIf
EndProcedure

Procedure sendReloadWeaponPacket()
  Define packetdata.l = AllocateMemory(4)
  PokeA(packetdata,28)              ;weapon reload
  PokeA(packetdata+1,own_player_id) ;own player id
  PokeA(packetdata+2,0)             ;clip ammo
  PokeA(packetdata+3,0)             ;reserve ammo
  sendpacket(packetdata,4)
EndProcedure

Procedure sendHitPacket(id.l,type.l)
  Define packetdata.l = AllocateMemory(3)
  PokeA(packetdata,5)        ;hit packet
  PokeA(packetdata+1,id)     ;player id
  PokeA(packetdata+2,type)   ;hit type
  sendpacket(packetdata,3)
EndProcedure

Procedure sendBlockActionPacket(action.l, x.l, y.l, z.l)
  Define packetdata.l = AllocateMemory(15)
  PokeA(packetdata,13)               ;block action
  PokeA(packetdata+1,own_player_id)  ;own player id
  PokeA(packetdata+2,action)         ;action type
  PokeL(packetdata+3,x)
  PokeL(packetdata+7,z)
  PokeL(packetdata+11,64-y)
  sendpacket(packetdata,15)
EndProcedure

Procedure changeweapon(weapon.l)
  own_weapon = weapon
  Define packetdata.l = AllocateMemory(3)
  PokeA(packetdata,30) ;change weapon
  PokeA(packetdata+1,own_player_id) ;own player id
  PokeA(packetdata+2,weapon) ;new weapon
  sendpacket(packetdata,3)
EndProcedure

Procedure joingame(team.l)
  If first_team_join = 1
    Define packetdata.l = AllocateMemory(28)
    PokeA(packetdata,9) ;existing player
    PokeA(packetdata+1,own_player_id) ;own player_id
    PokeB(packetdata+2,team) ;team
    PokeA(packetdata+3,own_weapon)
    PokeA(packetdata+4,own_item)
    PokeL(packetdata+5,own_kills)  ;kills
    PokeA(packetdata+9,own_block_blue)  ;blue
    PokeA(packetdata+10,own_block_green)  ;green
    PokeA(packetdata+11,own_block_red)  ;red
    PokeS(packetdata+12,own_player_name$,16,#PB_UTF8)
    sendpacket(packetdata,28)
    first_team_join = 0
  Else
    If Not own_team = team
      If own_team = -1
        packetdata.l = AllocateMemory(4)
        PokeA(packetdata,10)              ;short player data
        PokeA(packetdata+1,own_player_id) ;own player id
        PokeB(packetdata+2,team)          ;team id
        PokeA(packetdata+3,own_weapon)    ;weapon
        sendpacket(packetdata,4)
      Else
        packetdata.l = AllocateMemory(3)
        PokeA(packetdata,29)              ;change team
        PokeA(packetdata+1,own_player_id) ;own player id
        PokeB(packetdata+2,team)          ;team id
        sendpacket(packetdata,3)
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure init_enet()
  OpenLibrary(0,"enet.dll")
  CallCFunction(0,"initenet")
  ;Debug "E-net version: "+Str(CallCFunction(0,"getversion"))
EndProcedure

Procedure shutdown_enet()
  CallCFunction(0,"deinitenet")
  CloseLibrary(0)
EndProcedure

Procedure disconnect()
  If network_connected = 0
    ProcedureReturn
  EndIf
  KillThread(network_thread_id)
  CallCFunction(0,"resetpeer")
  CallCFunction(0,"destroyclient")
  network_connected = 0
EndProcedure

Procedure.l connect(ip$, port)
  If network_connected = 1
    disconnect()
  EndIf
  If CallCFunction(0,"createclient",0,0) = 0
    CallCFunction(0,"destroyclient")
    ProcedureReturn 1
  EndIf
  Define ip_pointer = AllocateMemory(Len(ip$)+1)
  PokeS(ip_pointer,ip$,Len(ip$),#PB_UTF8)
  Define ver.l = #NETWORK_PROTOCOL_VERSION_075
  If ReadPreferenceInteger("use_076",0) = 1
    ver = #NETWORK_PROTOCOL_VERSION_076
  EndIf
  Define client_connect_l = CallCFunction(0,"clientconnect",ip_pointer,port,ver)
  Debug client_connect_l
  If client_connect_l = 5000
    ProcedureReturn 2
  EndIf
  If client_connect_l = 5001
    CallCFunction(0,"resetpeer")
    ProcedureReturn 3
  EndIf
  network_connected = 1
  network_thread_id = CreateThread(@networkThread(), 0)
EndProcedure

Procedure.l enet_ping()
  ProcedureReturn network_ping
EndProcedure
; IDE Options = PureBasic 5.31 (Windows - x86)
; CursorPosition = 789
; FirstLine = 763
; Folding = +-f1
; EnableUnicode
; EnableXP
; UseMainFile = main.pb
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant