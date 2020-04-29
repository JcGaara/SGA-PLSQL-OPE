CREATE OR REPLACE TRIGGER OPERACION.t_matriz_tiptratipsrvmot_aiud
  AFTER INSERT OR UPDATE OR DELETE ON OPERACION.matriz_tiptratipsrvmot_adc
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/*********************************************************************************************************************************
    NOMBRE:      t_matriz_tiptratipsrvmot_aiud
    REVISIONES:
    Ver        Fecha        Autor             Solicitado por    Descripcion
    ---------  ----------  ----------------  ----------------  ------------------------
    1.0        18/08/2015  Steve Panduro     NALDA AROTINCO         PROY-17652 Adm Manejo de Cuadrillas
  ***********************************************************************************************************************************/

DECLARE
  lc_usuario_log VARCHAR2(100);
  lc_accion      CHAR(1);
  ln_id          NUMBER(20);

BEGIN

  SELECT HISTORICO.SEQ_matriz_tiptramot_LOG.nextval
    INTO ln_id
    FROM dummy_atc;

  SELECT MAX(osuser)
    INTO lc_usuario_log
    FROM v$session
   WHERE audsid = (SELECT userenv('sessionid') FROM dummy_atc);

  lc_usuario_log := TRIM(rpad(USER || '-' || lc_usuario_log, 50));

  IF inserting or updating THEN
    IF inserting THEN
      lc_accion := 'i';
    ELSIF updating THEN
      lc_accion := 'u';
    END IF;

    INSERT INTO HISTORICO.matriz_tiptratipsrvmot_LOG
      (IDLOG,
       ID_MATRIZ,
       ID_MOTIVO,
       GEN_OT_AUT,
       ESTADO,
       IPCRE,
       IPMOD,
       FECRE,
       FECMOD,
       USUCRE,
       USUMOD,
       USULOG,
       FECLOG,
       ACCLOG)
    VALUES
      (ln_id,
       :new.ID_MATRIZ,
       :new.ID_MOTIVO,
       :new.GEN_OT_AUT,
       :new.ESTADO,
       :new.IPCRE,
       :new.IPMOD,
       :new.FECRE,
       :new.FECMOD,
       :new.USUCRE,
       :new.USUMOD,
       lc_usuario_log,
       SYSDATE,
       lc_accion);
  ELSIF deleting THEN
    lc_accion := 'd';

    INSERT INTO HISTORICO.matriz_tiptratipsrvmot_LOG
      (IDLOG,
       ID_MATRIZ,
       ID_MOTIVO,
       GEN_OT_AUT,
       ESTADO,
       IPCRE,
       IPMOD,
       FECRE,
       FECMOD,
       USUCRE,
       USUMOD,
       USULOG,
       FECLOG,
       ACCLOG)
    VALUES
      (ln_id,
       :old.ID_MATRIZ,
       :old.ID_MOTIVO,
       :old.GEN_OT_AUT,
       :old.ESTADO,
       :old.IPCRE,
       :old.IPMOD,
       :old.FECRE,
       :old.FECMOD,
       :old.USUCRE,
       :old.USUMOD,
       lc_usuario_log,
       SYSDATE,
       lc_accion);
  END IF;
END;
/
