CREATE OR REPLACE TRIGGER OPERACION.t_estado_motivo_sga_adc_aiud
  AFTER INSERT OR UPDATE OR DELETE ON OPERACION.estado_motivo_sga_adc
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/*********************************************************************************************************************************
    NOMBRE:       t_estado_motivo_sga_adc_aiud
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

  SELECT HISTORICO.SEQ_ESTADO_MOTIVO_SGA_ADC_LOG.nextval
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

    INSERT INTO HISTORICO.ESTADO_MOTIVO_SGA_ADC_LOG
      (IDLOG,
       IDESTADO_SGA_ORIGEN,
       IDMOTIVO_SGA_ORIGEN,
       IDESTADO_ADC_DESTINO,
       IDMOTIVO_SGA_DESTINO,
       --ESTADO,
       FECCREA,
       USUCREA,
       FECMOD,
       USUMOD,
       USULOG,
       FECLOG,
       ACCLOG)
    VALUES
      (ln_id,
       :new.IDESTADO_SGA_ORIGEN,
       :new.IDMOTIVO_SGA_ORIGEN,
       :new.IDESTADO_ADC_DESTINO,
       :new.IDMOTIVO_SGA_DESTINO,
       --:new.ESTADO,
       :new.FECCREA,
       :new.USUCREA,
       :new.FECMOD,
       :new.USUMOD,
       lc_usuario_log,
       SYSDATE,
       lc_accion);
  ELSIF deleting THEN
    lc_accion := 'd';

    INSERT INTO HISTORICO.ESTADO_MOTIVO_SGA_ADC_LOG
      (IDLOG,
       IDESTADO_SGA_ORIGEN,
       IDMOTIVO_SGA_ORIGEN,
       IDESTADO_ADC_DESTINO,
       IDMOTIVO_SGA_DESTINO,
       --ESTADO,
       FECCREA,
       USUCREA,
       FECMOD,
       USUMOD,
       USULOG,
       FECLOG,
       ACCLOG)
    VALUES
      (ln_id,
       :old.IDESTADO_SGA_ORIGEN,
       :old.IDMOTIVO_SGA_ORIGEN,
       :old.IDESTADO_ADC_DESTINO,
       :old.IDMOTIVO_SGA_DESTINO,
       --:old.ESTADO,
       :old.FECCREA,
       :old.USUCREA,
       :old.FECMOD,
       :old.USUMOD,
       lc_usuario_log,
       SYSDATE,
       lc_accion);
  END IF;
END;
/
