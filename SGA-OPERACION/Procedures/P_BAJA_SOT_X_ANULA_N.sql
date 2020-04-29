CREATE OR REPLACE PROCEDURE OPERACION.P_BAJA_SOT_X_ANULA_N(a_codsolot      IN NUMBER,
                                                           a_codmot        IN NUMBER,
                                                           a_observacion   IN VARCHAR2,
                                                           a_genera        IN NUMBER,
                                                           a_estsol_rec    in number
                                                           ) IS
  /**********************************************************************
  Cambia estado de SOT, OT y crea nueva SOT
  20070815 Roy Concepcion Creación del procedimiento
  20071213 Sergio Le Roux creacion opcional de solot de anulacion
  20091104 Luis Patiño  se agrego para que en la observacion de la sot de activacion se guarde
                        el numero de sot de anulacion.
  20100218 Alfonso Pérez REQ 120027 se modifica parte de la logica para poder anular sot
  20190401 PROY-140228 - FUNCIONALIDADES SOBRE SERVICIOS FIJA CORPORATIVA EN SGA
  **********************************************************************/
  l_observa  solot.observacion%TYPE;
  l_motivo   motot.descripcion%TYPE;
  l_codsolot NUMBER;
  --INI 20190401
  l_resultado      NUMBER;
  --FIN 20190401
BEGIN

  SELECT SOLOT.OBSERVACION, MOTOT.DESCRIPCION
    INTO l_observa, l_motivo
    FROM SOLOT
    LEFT JOIN MOTOT ON (SOLOT.CODMOTOT = MOTOT.CODMOTOT)
   WHERE SOLOT.CODSOLOT = a_codsolot;

  --<REQ 120027>
  --PQ_SOLOT.P_CHG_ESTADO_SOLOT(a_codsolot, a_estsol_rec, '', a_observacion);
  --</REQ 120027>

  UPDATE SOLOT
     SET --CODMOTOT    = a_codmot,
         OBSERVACION = l_observa || CHR(10) || a_observacion
   WHERE CODSOLOT = a_codsolot;

  UPDATE OT SET ESTOT = 6 WHERE CODSOLOT = a_codsolot;

  IF a_genera = 1 THEN
    OPERACION.P_CREAR_SOLOT_X_ANULA_N(a_codsolot, l_codsolot);
    ----Inicio Actualizado Hector Huaman  22/02/2008
    pq_solot.p_aprobar_solot(l_codsolot,11);
    --Fin Actualizado Hector Huaman 22/02/2008
    --Inicio Cambio Proyecto CDMA Luis Patino  20091104
     UPDATE SOLOT
     SET  OBSERVACION = l_observa || CHR(10) || 'SOT de anulacion: ' || l_codsolot
     WHERE CODSOLOT = a_codsolot;
    --Fin Cambio Proyecto CDMA Luis Patino 20091104
	
    --INI 20190401
    metasolv.pkg_asignacion_pex_unico.sgass_libera_hilo_baja_anula(l_codsolot,l_resultado);
    --FIN 20190401	
  ELSE
    l_codsolot := NULL;
  END IF;

  --<REQ 120027>
  PQ_SOLOT.P_CHG_ESTADO_SOLOT(a_codsolot, a_estsol_rec, '', a_observacion);
  --</REQ 120027>

  INSERT INTO SOLOT_ANULA
    (CODSOLOT, CODSOLOT_ANULA, CODMOT)
  VALUES
    (a_codsolot, l_codsolot, a_codmot);


END;
/


