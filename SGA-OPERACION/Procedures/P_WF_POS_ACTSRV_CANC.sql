CREATE OR REPLACE PROCEDURE OPERACION.P_WF_POS_ACTSRV_CANC (
a_idtareawf in number,
a_idwf in number,
a_tarea in number,
a_tareadef in number
) IS
/******************************************************************************
POS
Tarea: Activación de servicio
- Ejecuta la generación de SOT de cancelación SCM por traslado.
******************************************************************************/
l_codsolot solot.codsolot%type;
BEGIN

   select codsolot into l_codsolot from wf where idwf = a_idwf ;
   p_gen_solot_traslado_canc ( l_codsolot );

END;
/


