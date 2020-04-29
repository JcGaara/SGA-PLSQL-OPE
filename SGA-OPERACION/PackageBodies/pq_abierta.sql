CREATE OR REPLACE PACKAGE BODY OPERACION.pq_abierta IS
  /******************************************************************************
   PROPOSITO:
  
   REVISIONES:
     Version  Fecha       Autor          Solicitado por      Descripcion
     -------  -----       -----          --------------      -----------
     1.0      26/02/2014  Mauro Zegarra  Christian Riquelme  version inicial
  /* ***************************************************************************/
  PROCEDURE alta IS
  BEGIN
    IF operacion.pq_int_telefonia.g_operacion = 'ALTA' THEN
      no_interviene();
    END IF;
  END;
  /* ***************************************************************************/
  PROCEDURE baja IS
  BEGIN
    IF operacion.pq_int_telefonia.g_operacion = 'BAJA' THEN
      no_interviene();
    END IF;
  END;
  /* ***************************************************************************/
  PROCEDURE cambio_plan IS
  BEGIN
    IF operacion.pq_int_telefonia.g_origen = 'ABIERTA' AND
       operacion.pq_int_telefonia.g_destino = 'ABIERTA' THEN
      no_interviene();
    END IF;
  END;
  /* ***************************************************************************/
  PROCEDURE no_interviene IS
  BEGIN
    opewf.pq_wf.p_chg_status_tareawf(operacion.pq_int_telefonia.g_idtareawf,
                                     4, --Cerrada
                                     8, --No interviene
                                     0,
                                     SYSDATE,
                                     SYSDATE);
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.NO_INTERVIENE: ' || SQLERRM);
  END;
  /* ***************************************************************************/
END;
/
