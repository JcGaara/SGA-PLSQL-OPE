CREATE OR REPLACE TRIGGER OPERACION.t_subtipo_orden_adc_aiud
  AFTER INSERT OR UPDATE OR DELETE ON operacion.subtipo_orden_adc
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/*********************************************************************************************************************************
    NOMBRE:       T_SUBTIPO_ORDEN_ADC_AIUD
    REVISIONES:
    Ver        Fecha        Autor             Solicitado por    Descripcion
    ---------  ----------  ----------------  ----------------  ------------------------
    1.0        18/08/2015  Jorge Rivas       Manuel Gallegos   PROY-17652 Adm Manejo de Cuadrillas
    2.0        10/02/2016  Emma Guzman      Lizbeth Portella      PROY- 22818 -IDEA-28605 Administración y manejo de cuadrillas  - TOA Fase 2 – Claro Empresas
**********************************************************************************************************************************/
DECLARE
  lc_usuario_log VARCHAR2(100);
  lc_accion      CHAR(1);
  ln_id          NUMBER(20);
BEGIN
  SELECT historico.seq_subtipo_orden_adc_log.nextval INTO ln_id FROM dual;

  SELECT MAX(osuser) INTO lc_usuario_log
    FROM v$session
   WHERE audsid = (SELECT USERENV('sessionid') FROM dual);

  lc_usuario_log := TRIM(RPAD(USER || '-' || lc_usuario_log, 50));

  IF inserting THEN
     lc_accion := 'i';
     INSERT INTO historico.subtipo_orden_adc_log
      ( idlog,
        id_subtipo_orden,
        cod_subtipo_orden,
        descripcion,
        tiempo_min,
        id_tipo_orden,
        estado,
        ipcre,
        ipmod,
        fecre,
        fecmod,
        usucre,
        usumod,
        id_work_skill,
        grado_dificultad,
        usulog,
        feclog,
        acclog,
        lineas)--2.0
     VALUES
      (ln_id,
       :new.id_subtipo_orden,
       :new.cod_subtipo_orden,
       :new.descripcion,
       :new.tiempo_min,
       :new.id_tipo_orden,
       :new.estado,
       :new.ipcre,
       :new.ipmod,
       :new.fecre,
       :new.fecmod,
       :new.usucre,
       :new.usumod,
       :new.id_work_skill,
       :new.grado_dificultad,
       lc_usuario_log,
       SYSDATE,
       lc_accion,
       :new.lineas);--2.0
  ELSIF updating OR deleting THEN
     IF updating THEN
        lc_accion := 'u';
     ELSIF deleting THEN
        lc_accion := 'd';
     END IF;

     INSERT INTO historico.subtipo_orden_adc_log
      ( idlog,
        id_subtipo_orden,
        cod_subtipo_orden,
        descripcion,
        tiempo_min,
        id_tipo_orden,
        estado,
        ipcre,
        ipmod,
        fecre,
        fecmod,
        usucre,
        usumod,
        id_work_skill,
        grado_dificultad,
        usulog,
        feclog,
        acclog,
        lineas)--2.0
     VALUES
      (ln_id,
       :old.id_subtipo_orden,
       :old.cod_subtipo_orden,
       :old.descripcion,
       :old.tiempo_min,
       :old.id_tipo_orden,
       :old.estado,
       :old.ipcre,
       :old.ipmod,
       :old.fecre,
       :old.fecmod,
       :old.usucre,
       :old.usumod,
       :old.id_work_skill,
       :old.grado_dificultad,
       lc_usuario_log,
       SYSDATE,
       lc_accion,
       :old.lineas); --2.0
  END IF;
END;
/