CREATE OR REPLACE PROCEDURE OPERACION.P_WF_OBSERVACIONES_PEX (
a_codsolot in number,
a_tareadef in number,
a_observacion in varchar2,
a_idobserv in number
) IS
/******************************************************************************
POS
Tarea: Activacion de servicio
- Ejecuta la generacion de SOT de cancelacion por traslado.
- PER: Cambia el estado de la SOT a Atendida

   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        20/12/2006  Gustao Ormeño  Se selecciona sólo el idtareawf que corresponda al wf en un estado siferente a cancelado
******************************************************************************/
l_tareawf tareawf.idtareawf%type;
--l_wf wf.idwf%type;
l_observacion pex_observacion.observacion%type;
l_cont number;
l_contMain number;
BEGIN

   select count(*) into l_contMain
   from wf, tareawf where wf.idwf = tareawf.idwf
   and tareawf.tareadef = a_tareadef and wf.codsolot = a_codsolot;

/*if l_cont = 0 then
     insert into tareawfseg(idtareawf, observacion, idobserv)
     select l_tareawf, pex_observacion.observacion, pex_observacion.idobserv
     FROM pex_observacion  WHERE pex_observacion.codsolot = a_codsolot
     and pex_observacion.idobserv = a_idobserv;
   else
     select observacion into l_observacion from pex_observacion
     where pex_observacion.codsolot = a_codsolot and pex_observacion.idobserv = a_idobserv;

     update tareawfseg set observacion = l_observacion
     where idtareawf = l_tareawf and idobserv = a_idobserv;
   end if; */

   if l_contMain > 0 then

           select tareawf.idtareawf into l_tareawf
           from wf, tareawf where wf.idwf = tareawf.idwf
           and tareawf.tareadef = a_tareadef and wf.codsolot = a_codsolot
           and wf.estwf <> 5; /* se verifica que solo seleccione el wf no cancelado*/

           select count(*) into l_cont from tareawfseg where idobserv = a_idobserv;

       if l_cont = 0 then
         insert into tareawfseg(idtareawf, observacion, idobserv)
         select l_tareawf, a_observacion, a_idobserv from dual   ;
       else

         update tareawfseg set observacion = a_observacion
         where idtareawf = l_tareawf and idobserv = a_idobserv;
       end if;
   end if;

END;
/


