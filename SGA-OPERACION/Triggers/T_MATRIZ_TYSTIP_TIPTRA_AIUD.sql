CREATE OR REPLACE TRIGGER OPERACION.t_matriz_tystip_tiptra_aiud
  AFTER INSERT OR UPDATE OR DELETE ON OPERACION.matriz_tystipsrv_tiptra_adc
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/*********************************************************************************************************************************
    NOMBRE:      t_matriz_tystipsrv_tiptra_adc_aiud
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

  SELECT HISTORICO.SEQ_MATRIZ_TYSTIP_TIPTRA_LOG.nextval
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

    INSERT INTO HISTORICO.MATRIZ_TYSTIPSRV_TIPTRA_LOG
      (IDLOG,
       ID_MATRIZ,
       TIPSRV,
       TIPTRA,
       CON_CAP_V,
       CON_CAP_P,
       CON_CAP_O,
       GEN_OT_AUT,
       TIPO_AGENDA,
       VALIDA_MOT,
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
       :new.TIPSRV,
       :new.TIPTRA,
       :new.CON_CAP_V,
       :new.CON_CAP_P,
       :new.CON_CAP_O,
       :new.GEN_OT_AUT,
       :new.TIPO_AGENDA,
       :new.VALIDA_MOT,
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

    INSERT INTO HISTORICO.MATRIZ_TYSTIPSRV_TIPTRA_LOG
      (IDLOG,
       ID_MATRIZ,
       TIPSRV,
       TIPTRA,
       CON_CAP_V,
       CON_CAP_P,
       CON_CAP_O,
       GEN_OT_AUT,
       TIPO_AGENDA,
       VALIDA_MOT,
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
       :old.TIPSRV,
       :old.TIPTRA,
       :old.CON_CAP_V,
       :old.CON_CAP_P,
       :old.CON_CAP_O,
       :old.GEN_OT_AUT,
       :old.TIPO_AGENDA,
       :old.VALIDA_MOT,
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
