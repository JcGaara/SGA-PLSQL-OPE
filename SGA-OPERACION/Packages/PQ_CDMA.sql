CREATE OR REPLACE PACKAGE OPERACION.PQ_CDMA IS
  /************************************************************
  NOMBRE:     PQ_CDMA
  PROPOSITO:   

  REVISIONES:
  Version   Fecha        Autor                   Descripcisn
  --------- ----------  ---------------        ------------------------
  1.0    18/12/2012  Edilberto Astulle
  ***********************************************************/
  type gc_salida is REF CURSOR;	

																	 
  PROCEDURE p_envio_rown(n_row number,
   i_mensaje out number,
   o_mensaje out gc_salida);

PROCEDURE P_ACT_ROWN(A_IDSEQ     NUMBER,
                       A_RESPUESTA NUMBER,
                       O_IDERROR   out NUMBER,
                       O_IDMENSAJE out VARCHAR2); 																 

  PROCEDURE p_carga_trscdma
  (a_idtareawf in number,
   a_idwf      in number,
   a_tarea     in number,
   a_tareadef  in number);
END;
/