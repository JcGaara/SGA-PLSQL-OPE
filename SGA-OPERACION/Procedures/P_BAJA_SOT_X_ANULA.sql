CREATE OR REPLACE PROCEDURE OPERACION.P_BAJA_SOT_X_ANULA(a_codsolot      IN NUMBER,
                                                           a_codmot        IN NUMBER,
                                                           a_observacion   IN VARCHAR2
                                                           ) IS
  /**********************************************************************
  Cambia estado de SOT, OT y crea nueva SOT
  20070815 Roy Concepcion Creación del procedimiento
  20071213 Sergio Le Roux creacion opcional de solot de anulacion
  **********************************************************************/
  l_observa  solot.observacion%TYPE;
  l_motivo   motot.descripcion%TYPE;
  l_codsolot NUMBER;

BEGIN

  SELECT SOLOT.OBSERVACION, MOTOT.DESCRIPCION
    INTO l_observa, l_motivo
    FROM SOLOT
    LEFT JOIN MOTOT ON (SOLOT.CODMOTOT = MOTOT.CODMOTOT)
   WHERE SOLOT.CODSOLOT = a_codsolot;

  PQ_SOLOT.P_CHG_ESTADO_SOLOT(a_codsolot, 15, '', a_observacion);

  UPDATE SOLOT
     SET --CODMOTOT    = a_codmot,
         OBSERVACION = l_observa || CHR(10) || a_observacion
   WHERE CODSOLOT = a_codsolot;

  UPDATE OT SET ESTOT = 6 WHERE CODSOLOT = a_codsolot;

    OPERACION.P_CREAR_SOLOT_X_ANULA_N(a_codsolot, l_codsolot);
    ----Inicio Actualizado Hector Huaman  22/02/2008
    pq_solot.p_aprobar_solot(l_codsolot,11);
    --Fin Actualizado Hector Huaman 22/02/2008

  INSERT INTO SOLOT_ANULA
    (CODSOLOT, CODSOLOT_ANULA, CODMOT)
  VALUES
    (a_codsolot, l_codsolot, a_codmot);

END;
/


