#PARTICLE_MAX = 512
#PARTICLE_VANISH_TIME = 3000.0
#PARTICLE_RENDER_DISTANCE = 32.0

#PARTICLE_TYPE_SEMI = 0
#PARTICLE_TYPE_SMG = 1
#PARTICLE_TYPE_SHOTGUN = 2
#PARTICLE_TYPE_BLOCK = 255

Global particles_used.l = 0

Global Dim particle_x.f(#PARTICLE_MAX)

Global Dim particle_y.f(#PARTICLE_MAX)
Global Dim particle_z.f(#PARTICLE_MAX)
Global Dim particle_vx.f(#PARTICLE_MAX)
Global Dim particle_vy.f(#PARTICLE_MAX)
Global Dim particle_vz.f(#PARTICLE_MAX)
Global Dim particle_size.f(#PARTICLE_MAX)
Global Dim particle_color.l(#PARTICLE_MAX)
Global Dim particle_used.l(#PARTICLE_MAX)
Global Dim particle_block_hit.l(#PARTICLE_MAX)
Global Dim particle_type.l(#PARTICLE_MAX)

Procedure spawnParticleCloud(amount.l,center_x.f,center_y.f,center_z.f,max_spread.f,min_size.f,max_size.f,color.l)
  amount << 1
  Define k,i
  For k=0 To amount-1
    For i=0 To #PARTICLE_MAX-1
      If particle_used(i) = 0
        particle_x(i) = center_x
        particle_y(i) = center_y
        particle_z(i) = center_z
        particle_vx(i) = (Random(2000)-1000)*0.001*max_spread
        particle_vy(i) = (Random(2000)-1000)*0.001*max_spread
        particle_vz(i) = (Random(2000)-1000)*0.001*max_spread
        particle_size(i) = Random(1000)*0.001*(max_size-min_size)+min_size
        particle_color(i) = color
        particle_block_hit(i) = 0
        particle_type(i) = #PARTICLE_TYPE_BLOCK
        particle_used(i) = 1
        Break
      EndIf
    Next
  Next
EndProcedure

Procedure updateParticle(id.l, dt.f)
  Define f5.f = dt * 32.0
  particle_x(id) + particle_vx(id)*f5
  If clipworld(Round(particle_x(id),#PB_Round_Down), 64-Round(particle_y(id),#PB_Round_Down), Round(particle_z(id),#PB_Round_Down))
    particle_x(id) - particle_vx(id)*f5
    particle_vx(id) * -0.5
  EndIf
  particle_vy(id) - dt
  particle_y(id) + particle_vy(id)*f5
  If clipworld(Round(particle_x(id),#PB_Round_Down), 64-Round(particle_y(id),#PB_Round_Down), Round(particle_z(id),#PB_Round_Down))
    particle_y(id) - particle_vy(id)*f5
    particle_vy(id) + dt
    particle_vy(id) * -0.5
    
    particle_vx(id) * Pow(0.1,dt)
    particle_vy(id) * Pow(0.1,dt)
    particle_vz(id) * Pow(0.1,dt)
  Else
    particle_vx(id) * Pow(0.5,dt)
    particle_vy(id) * Pow(0.5,dt)
    particle_vz(id) * Pow(0.5,dt)
  EndIf
  particle_z(id) + particle_vz(id)*f5
  If clipworld(Round(particle_x(id),#PB_Round_Down), 64-Round(particle_y(id),#PB_Round_Down), Round(particle_z(id),#PB_Round_Down))
    particle_z(id) - particle_vz(id)*f5
    particle_vz(id) * -0.5
  EndIf
  
  If particle_vz(id) < 0.005 And particle_vx(id) < 0.005 And particle_vy(id) < 0.005 And particle_block_hit(id) = 0
    particle_block_hit(id) = ElapsedMilliseconds()
  EndIf
  
  If Not particle_block_hit(id) = 0 And ElapsedMilliseconds()-particle_block_hit(id)>#PARTICLE_VANISH_TIME
    particle_used(id) = 0
  EndIf
EndProcedure

Procedure renderParticles(dt.f,shadow.l,x.f,y.f,z.f)
  glBegin_(#GL_QUADS)
  Define count.l = 0
  Define k
  For k=0 To #PARTICLE_MAX-1
    If particle_used(k) = 1
      count + 1
      Define factor.f = 1.0
      If Not particle_block_hit(k) = 0
        factor = 1.0-((ElapsedMilliseconds()-particle_block_hit(k))/#PARTICLE_VANISH_TIME)
      EndIf
      
      If particle_type(k) = #PARTICLE_TYPE_BLOCK And Pow(particle_x(k)-x,2)+Pow(particle_y(k)-y,2)+Pow(particle_z(k)-z,2) < #PARTICLE_RENDER_DISTANCE*#PARTICLE_RENDER_DISTANCE
        Define color = particle_color(k)
        If shadow = 1
          glColor3f(Red(color)/255.0*0.5,Green(color)/255.0*0.5,Blue(color)/255.0*0.5)
        Else
          glColor3f(Red(color)/255.0,Green(color)/255.0,Blue(color)/255.0)
        EndIf
        rendercubeat(particle_x(k),particle_y(k),particle_z(k),particle_size(k)*factor,particle_size(k)*factor,particle_size(k)*factor)
      EndIf
      updateParticle(k,dt)
    EndIf
  Next
  glEnd_()
  particles_used = count
EndProcedure
; IDE Options = PureBasic 5.31 (Windows - x86)
; CursorPosition = 25
; Folding = -
; EnableUnicode
; EnableXP
; UseMainFile = main.pb