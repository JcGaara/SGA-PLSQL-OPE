CREATE OR REPLACE PROCEDURE OPERACION.P_WF_POS_DESNUMTEL (
a_idtareawf in number,
a_idwf in number,
a_tarea in number,
a_tareadef in number
) IS
/******************************************************************************
POS
Tarea: Desactivacion de Numeros Telefonicos
- Para todos los # Telefonicos dentro de la SOT
Los desasocia de Hunting, Grupotel, etc
******************************************************************************/
l_codsolot solot.codsolot%type;

cursor cur (a_codsolot in number) is
   select distinct i.codinssrv from solotpto s, inssrv i
   where s.codsolot = a_codsolot and s.codinssrv = i.codinssrv
   and i.tipinssrv = 3 ;

BEGIN

   select codsolot into l_codsolot from wf where idwf = a_idwf ;
   for c in cur(l_codsolot) loop
      telefonia.P_DESASIGNACIONXINSSRV ( c.codinssrv, 0 );
   end loop;

END;
/


