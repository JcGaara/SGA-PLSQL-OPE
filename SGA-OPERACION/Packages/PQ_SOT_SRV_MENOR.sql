CREATE OR REPLACE PACKAGE OPERACION.pq_sot_srv_menor is
  /******************************************************************************
     NAME:       pq_sot_srv_menor
     PURPOSE:    manejo de procedimientos para servicios menores

     REVISIONS:
     Ver        Date        Author           Description
     ---------  ----------  ---------------  ------------------------------------
    1.0         11/08/2009  Hector Huaman M  REQ-96885:se modifico el procedimiento p_baja_cambioplan se arreglo el calculo de la fecha de cierre de la instancia de servicio.
    2.0        10/07/2007  Hector Huaman M.  REQ-93190:Se agrego procedimiento p_baja_totalservicio, para  cancelar el servicio con la fecha de la SOT de baja( fecha de compromiso)
    3.0        10/07/2007  Hector Huaman M.  REQ-107236:Se agrego procedimiento p_baja_totalservicio, para no considerar cerrar la tarea de activacion
  ******************************************************************************/

 procedure p_baja_cambioplan(a_idtareawf in number, a_idwf in number, a_tarea in number, a_tareadef in number);
  procedure p_interviene_tarea(a_idtareawf in number, a_idwf in number, a_tarea in number, a_tareadef in number);
  procedure p_interviene_ri(a_idtareawf in number, a_idwf in number, a_tarea in number, a_tareadef in number);

  procedure p_baja_totalservicio(a_idtareawf in number, a_idwf in number, a_tarea in number, a_tareadef in number);
end pq_sot_srv_menor;
/


