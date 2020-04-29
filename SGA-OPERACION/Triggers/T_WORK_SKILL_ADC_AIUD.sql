CREATE OR REPLACE TRIGGER OPERACION.T_Work_Skill_Adc_aiud
  AFTER INSERT OR UPDATE OR DELETE ON OPERACION.Work_Skill_Adc
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/*********************************************************************************************************************************
    NOMBRE:       T_OPERACION.Work_Skill_Adc_aiud
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

  SELECT HISTORICO.SEQ_WORK_SKILL_ADC_LOG.nextval
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

    INSERT INTO HISTORICO.WORK_SKILL_ADC_LOG
      (IDLOG,
       ID_WORK_SKILL,
       COD_WORK_SKILL,
       DESCRIPCION,
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
       :new.ID_WORK_SKILL,
       :new.COD_WORK_SKILL,
       :new.DESCRIPCION,
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

    INSERT INTO HISTORICO.WORK_SKILL_ADC_LOG
      (IDLOG,
       ID_WORK_SKILL,
       COD_WORK_SKILL,
       DESCRIPCION,
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
       :old.ID_WORK_SKILL,
       :old.COD_WORK_SKILL,
       :old.DESCRIPCION,
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
