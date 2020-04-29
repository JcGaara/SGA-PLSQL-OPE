CREATE OR REPLACE PACKAGE OPERACION.PQ_SEGPROYECTO AS
/******************************************************************************
   NAME:       PQ_BOD
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        09/01/2006             1. Created this package.
******************************************************************************/


PROCEDURE P_CREA_POS_TAREAWF(
	a_idtareawf in number,
	a_tarea in number,
	a_pos_tareas in char,
  a_plazo in number,
  a_feccom in date);


  PROCEDURE P_ACTUALIZA_WF(
	a_idwf in number
) ;
PROCEDURE P_ACT_SOTS;

END PQ_SEGPROYECTO;
/


