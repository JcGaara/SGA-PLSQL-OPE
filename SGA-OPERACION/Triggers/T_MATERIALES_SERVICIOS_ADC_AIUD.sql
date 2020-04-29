CREATE OR REPLACE TRIGGER OPERACION.t_MATE_SERVICIOS_ADC_aiud
  AFTER INSERT OR UPDATE OR DELETE ON OPERACION.MATERIALES_SERVICIOS_ADC
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/*********************************************************************************************************************************
    NOMBRE:       t_bucket_contrata_adc_aiud
    REVISIONES:
    Ver        Fecha        Autor             Solicitado por    Descripcion
    ---------  ----------  ----------------  ----------------  ------------------------
    1.0        08/03/2016  Lizbeth Portella  Lizbeth Portella   PROY- 22818 Administración y manejo de cuadrillas  - TOA Fase 2 ¿ CE
  ***********************************************************************************************************************************/

DECLARE
  lc_usuario_log VARCHAR2(100);
  lc_accion      CHAR(1);
  ln_id          NUMBER(20);

BEGIN

  SELECT HISTORICO.SEQ_MATE_SERVICIOS_ADC_LOG.nextval
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

    INSERT INTO HISTORICO.MATERIALES_SERVICIOS_ADC_LOG
      (IDLOG,
       id_mat_serv,
       idunicosap,
       cantidad,
       descripcion,
       unidades,
       categoria ,
       id_serv_mat,
       FECREG,
       USUREG,
       FECMOD,
       USUMOD,
       IPCRE,
       IPMOD,
       USULOG,
       FECLOG,
       ACCLOG)
    VALUES
      (ln_id,
       :new.id_mat_serv,
       :new.idunicosap,
       :new.cantidad,
       :new.descripcion,
       :new.unidades,
       :new.categoria,
       :new.id_serv_mat,
       :new.FECREG,
       :new.USUREG,
       :new.FECMOD,
       :new.USUMOD,
       :new.IPCRE,
       :new.IPMOD,
       lc_usuario_log,
       SYSDATE,
       lc_accion);
  ELSIF deleting THEN
    lc_accion := 'd';

    INSERT INTO HISTORICO.MATERIALES_SERVICIOS_ADC_LOG
      (IDLOG,
       id_mat_serv,
       idunicosap,
       cantidad,
       descripcion,
       unidades,
       categoria ,
       id_serv_mat,
       FECREG,
       USUREG,
       FECMOD,
       USUMOD,
       IPCRE,
       IPMOD,
       USULOG,
       FECLOG,
       ACCLOG)
    VALUES
      (ln_id,
       :old.id_mat_serv,
       :old.idunicosap,
       :old.cantidad,
       :old.descripcion,
       :old.unidades,
       :old.categoria ,
       :old.id_serv_mat,
       :old.FECREG,
       :old.USUREG,
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