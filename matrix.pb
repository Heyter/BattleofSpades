Procedure.l createMatrix(a.f,b.f,c.f,d.f, e.f,f.f,g.f,h.f, i.f,j.f,k.f,l.f, m.f,n.f,o.f,p.f)
  new_matrix_location.l = AllocateMemory(64)
  PokeF(new_matrix_location+0,a)
  PokeF(new_matrix_location+4,b)
  PokeF(new_matrix_location+8,c)
  PokeF(new_matrix_location+12,d)
  
  PokeF(new_matrix_location+16,e)
  PokeF(new_matrix_location+20,f)
  PokeF(new_matrix_location+24,g)
  PokeF(new_matrix_location+28,h)
  
  PokeF(new_matrix_location+32,i)
  PokeF(new_matrix_location+36,j)
  PokeF(new_matrix_location+40,k)
  PokeF(new_matrix_location+44,l)
  
  PokeF(new_matrix_location+48,m)
  PokeF(new_matrix_location+52,n)
  PokeF(new_matrix_location+56,o)
  PokeF(new_matrix_location+60,p)
  ProcedureReturn new_matrix_location
EndProcedure

Procedure.l createVector(a.f,b.f,c.f,d.f)
  new_vector_location.l = AllocateMemory(16)
  PokeF(new_vector_location+0,a)
  PokeF(new_vector_location+4,b)
  PokeF(new_vector_location+8,c)
  PokeF(new_vector_location+12,d)
  ProcedureReturn new_vector_location
EndProcedure

Procedure.l editVector(vector.l,a.f,b.f,c.f,d.f)
  PokeF(vector+0,a)
  PokeF(vector+4,b)
  PokeF(vector+8,c)
  PokeF(vector+12,d)
  ProcedureReturn vector
EndProcedure

Procedure.l multiplyMatrix(dest.l, matrix.l, other_matrix.l)
  new_matrix_location.l = dest
  PokeF(new_matrix_location+0,PeekF(matrix+0)*PeekF(other_matrix+0)+PeekF(matrix+16)*PeekF(other_matrix+4)+PeekF(matrix+32)*PeekF(other_matrix+8)+PeekF(matrix+48)*PeekF(other_matrix+12))
  PokeF(new_matrix_location+4,PeekF(matrix+4)*PeekF(other_matrix+0)+PeekF(matrix+20)*PeekF(other_matrix+4)+PeekF(matrix+36)*PeekF(other_matrix+8)+PeekF(matrix+52)*PeekF(other_matrix+12))
  PokeF(new_matrix_location+8,PeekF(matrix+8)*PeekF(other_matrix+0)+PeekF(matrix+24)*PeekF(other_matrix+4)+PeekF(matrix+40)*PeekF(other_matrix+8)+PeekF(matrix+56)*PeekF(other_matrix+12))
  PokeF(new_matrix_location+12,PeekF(matrix+12)*PeekF(other_matrix+0)+PeekF(matrix+28)*PeekF(other_matrix+4)+PeekF(matrix+44)*PeekF(other_matrix+8)+PeekF(matrix+60)*PeekF(other_matrix+12))
  
  PokeF(new_matrix_location+16,PeekF(matrix+0)*PeekF(other_matrix+16)+PeekF(matrix+16)*PeekF(other_matrix+20)+PeekF(matrix+32)*PeekF(other_matrix+24)+PeekF(matrix+48)*PeekF(other_matrix+28))
  PokeF(new_matrix_location+20,PeekF(matrix+4)*PeekF(other_matrix+16)+PeekF(matrix+20)*PeekF(other_matrix+20)+PeekF(matrix+36)*PeekF(other_matrix+24)+PeekF(matrix+52)*PeekF(other_matrix+28))
  PokeF(new_matrix_location+24,PeekF(matrix+8)*PeekF(other_matrix+16)+PeekF(matrix+24)*PeekF(other_matrix+20)+PeekF(matrix+40)*PeekF(other_matrix+24)+PeekF(matrix+56)*PeekF(other_matrix+28))
  PokeF(new_matrix_location+28,PeekF(matrix+12)*PeekF(other_matrix+16)+PeekF(matrix+28)*PeekF(other_matrix+20)+PeekF(matrix+44)*PeekF(other_matrix+24)+PeekF(matrix+60)*PeekF(other_matrix+28))
  
  PokeF(new_matrix_location+32,PeekF(matrix+0)*PeekF(other_matrix+32)+PeekF(matrix+16)*PeekF(other_matrix+36)+PeekF(matrix+32)*PeekF(other_matrix+40)+PeekF(matrix+48)*PeekF(other_matrix+44))
  PokeF(new_matrix_location+36,PeekF(matrix+4)*PeekF(other_matrix+32)+PeekF(matrix+20)*PeekF(other_matrix+36)+PeekF(matrix+36)*PeekF(other_matrix+40)+PeekF(matrix+52)*PeekF(other_matrix+44))
  PokeF(new_matrix_location+40,PeekF(matrix+8)*PeekF(other_matrix+32)+PeekF(matrix+24)*PeekF(other_matrix+36)+PeekF(matrix+40)*PeekF(other_matrix+40)+PeekF(matrix+56)*PeekF(other_matrix+44))
  PokeF(new_matrix_location+44,PeekF(matrix+12)*PeekF(other_matrix+32)+PeekF(matrix+28)*PeekF(other_matrix+36)+PeekF(matrix+44)*PeekF(other_matrix+40)+PeekF(matrix+60)*PeekF(other_matrix+44))
  
  PokeF(new_matrix_location+48,PeekF(matrix+0)*PeekF(other_matrix+48)+PeekF(matrix+16)*PeekF(other_matrix+52)+PeekF(matrix+32)*PeekF(other_matrix+56)+PeekF(matrix+48)*PeekF(other_matrix+60))
  PokeF(new_matrix_location+52,PeekF(matrix+4)*PeekF(other_matrix+48)+PeekF(matrix+20)*PeekF(other_matrix+52)+PeekF(matrix+36)*PeekF(other_matrix+56)+PeekF(matrix+52)*PeekF(other_matrix+60))
  PokeF(new_matrix_location+56,PeekF(matrix+8)*PeekF(other_matrix+48)+PeekF(matrix+24)*PeekF(other_matrix+52)+PeekF(matrix+40)*PeekF(other_matrix+56)+PeekF(matrix+56)*PeekF(other_matrix+60))
  PokeF(new_matrix_location+60,PeekF(matrix+12)*PeekF(other_matrix+48)+PeekF(matrix+28)*PeekF(other_matrix+52)+PeekF(matrix+44)*PeekF(other_matrix+56)+PeekF(matrix+60)*PeekF(other_matrix+60))
  ProcedureReturn new_matrix_location
EndProcedure

Procedure.l getRow(dest.l, matrix.l,pos.l)
  If pos = 0
    ProcedureReturn editVector(dest,PeekF(matrix+0),PeekF(matrix+16),PeekF(matrix+32),PeekF(matrix+48))
  EndIf
	If pos = 1
	  ProcedureReturn editVector(dest,PeekF(matrix+4),PeekF(matrix+20),PeekF(matrix+36),PeekF(matrix+52))
	EndIf
	If pos = 2
	  ProcedureReturn editVector(dest,PeekF(matrix+8),PeekF(matrix+24),PeekF(matrix+40),PeekF(matrix+56))
	EndIf
	If pos = 3
	  ProcedureReturn editVector(dest,PeekF(matrix+12),PeekF(matrix+28),PeekF(matrix+44),PeekF(matrix+60))
	EndIf
	ProcedureReturn dest
EndProcedure
; IDE Options = PureBasic 5.31 (Windows - x86)
; CursorPosition = 33
; FirstLine = 25
; Folding = -
; EnableUnicode
; EnableXP