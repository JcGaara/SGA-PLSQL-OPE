CREATE OR REPLACE TRIGGER OPERACION.t_bucket_contrata_adc_aiud
  AFTER INSERT OR UPDATE OR DELETE ON OPERACION.bucket_contrata_adc
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/*********************************************************************************************************************************
    NOMBRE:       t_bucket_contrata_adc_aiud
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

  SELECT HISTORICO.SEQ_BUCKET_CONTRATA_ADC_LOG.nextval
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

    INSERT INTO HISTORICO.BUCKET_CONTRATA_ADC_LOG
      (IDLOG,
       IDBUCKET,
       CODCON,
       ESTADO,
       FLG_REC_SUBTIPO,
       FECCRE,
       USUCRE,
       FECMOD,
       USUMOD,
       IPCRE,
       IPMOD,
       USULOG,
       FECLOG,
       ACCLOG)
    VALUES
      (ln_id,
       :new.IDBUCKET,
       :new.CODCON,
       :new.ESTADO,
       :new.flg_rec_subtipo,
       :new.FECCRE,
       :new.USUCRE,
       :new.FECMOD,
       :new.USUMOD,
       :new.IPCRE,
       :new.IPMOD,
       lc_usuario_log,
       SYSDATE,
       lc_accion);
  ELSIF deleting THEN
    lc_accion := 'd';

    INSERT INTO HISTORICO.BUCKET_CONTRATA_ADC_LOG
      (IDLOG,
       IDBUCKET,
       CODCON,
       ESTADO,
       flg_rec_subtipo,
       FECCRE,
       USUCRE,
       FECMOD,
       USUMOD,
       IPCRE,
       IPMOD,
       USULOG,
       FECLOG,
       ACCLOG)
    VALUES
      (ln_id,
       :old.IDBUCKET,
       :old.CODCON,
       :old.ESTADO,
       :old.flg_rec_subtipo,
       :old.FECCRE,
       :old.USUCRE,
       :old.FECMOD,
       :old.USUMOD,
       :old.IPCRE,
       :old.IPMOD,
       lc_usuario_log,
       SYSDATE,
       lc_accion);
  END IF;
END;
/
