CREATE OR REPLACE TRIGGER OPERACION.t_tipo_orden_adc_aiud
  AFTER INSERT OR UPDATE OR DELETE ON operacion.tipo_orden_adc
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/*********************************************************************************************************************************
    NOMBRE:       T_TIPO_ORDEN_ADC_AIUD
    REVISIONES:
    Ver        Fecha        Autor             Solicitado por    Descripcion
    ---------  ----------  ----------------  ----------------  ------------------------
    1.0        18/08/2015  Jorge Rivas       Manuel Gallegos   PROY-17652 Adm Manejo de Cuadrillas
    2.0        10/02/2016  Emma Guzman       Lizbeth Portella  PROY- 22818 -IDEA-28605 Administración y manejo de cuadrillas  - TOA Fase 2 ¿ Claro Empresas  
**********************************************************************************************************************************/
DECLARE
  lc_usuario_log VARCHAR2(100);
  lc_accion      CHAR(1);
  ln_id          NUMBER(20);
BEGIN
  SELECT historico.seq_tipo_orden_adc_log.nextval INTO ln_id FROM dual;

  SELECT MAX(osuser) INTO lc_usuario_log
    FROM v$session
   WHERE audsid = (SELECT USERENV('sessionid') FROM dual);

  lc_usuario_log := TRIM(RPAD(USER || '-' || lc_usuario_log, 50));

  IF inserting THEN
     lc_accion := 'i';
     INSERT INTO historico.tipo_orden_adc_log
      ( idlog,
        id_tipo_orden,
        cod_tipo_orden,
        descripcion,
        tipo_tecnologia,
        estado,
        ipcre,
        ipmod,
        fecre,
        fecmod,
        usucre,
        usumod,
        tipo_servicio,
        usulog,
        feclog,
        acclog,
        FLG_TIPO)--2.0
     VALUES
      (ln_id,
       :new.id_tipo_orden,
       :new.cod_tipo_orden,
       :new.descripcion,
       :new.tipo_tecnologia,
       :new.estado,
       :new.ipcre,
       :new.ipmod,
       :new.fecre,
       :new.fecmod,
       :new.usucre,
       :new.usumod,
       :new.tipo_servicio,
       lc_usuario_log,
       SYSDATE,
       lc_accion,
       :new.flg_tipo);--2.0
  ELSIF updating OR deleting THEN
     IF updating THEN
        lc_accion := 'u';
     ELSIF deleting THEN
        lc_accion := 'd';
     END IF;

     INSERT INTO historico.tipo_orden_adc_log
      ( idlog,
        id_tipo_orden,
        cod_tipo_orden,
        descripcion,
        tipo_tecnologia,
        estado,
        ipcre,
        ipmod,
        fecre,
        fecmod,
        usucre,
        usumod,
        tipo_servicio,
        usulog,
        feclog,
        acclog,
        FLG_TIPO)--2.0
     VALUES
      (ln_id,
       :old.id_tipo_orden,
       :old.cod_tipo_orden,
       :old.descripcion,
       :old.tipo_tecnologia,
       :old.estado,
       :old.ipcre,
       :old.ipmod,
       :old.fecre,
       :old.fecmod,
       :old.usucre,
       :old.usumod,
       :old.tipo_servicio,
       lc_usuario_log,
       SYSDATE,
       lc_accion,
       :old.flg_tipo);--2.0
  END IF;
END;
/