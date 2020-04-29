CREATE OR REPLACE TRIGGER "OPERACION"."T_CFG_ENV_CORREO_CONTRATA_AIUD" 
AFTER INSERT OR UPDATE OR DELETE
ON OPERACION.CFG_ENV_CORREO_CONTRATA REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
 /**************************************************************************
   NOMBRE:     T_CFG_ENV_CORREO_CONTRATA_AIUD
   PROPOSITO:  Genera log de Tabla

   REVISIONES:
   Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------   ------------------------
   1.0        16/04/2012  Edilberto Astulle
   2.0        30/01/2013  Miriam Mandujano   Se agrego campos al trigger
   3.0        30/07/2013  Edilberto Astulle         PROY-6471 IDEA-6433 - Agendamiento de Fecha serv Post
   **************************************************************************/

DECLARE
v_accion varchar2(30);
BEGIN
  IF INSERTING THEN
     v_accion := 'I';
    INSERT INTO HISTORICO.CFG_ENV_CORREO_CONTRATA_LOG
    (  IDCFG,
    FASE,
    NOMARCH,
    CUERPO,
    QUERY,
    CABECERA,
    DETALLE1,
    DETALLE2,
    CANT_COLUMNAS,
    GRUPO,
    TABLA,
    ESTADO,
    TIPOFORMATO,--ini MMC 30/01/2013
    CONDICION1,
    CAMPOFECHA,
    CAMPOSOT,
    CAMPOPROY,--fin MMC 30/01/2013
    TIPO_ACC_LOG,ORDEN)--3.0
    VALUES
    (:NEW.IDCFG,
    :NEW.FASE,
    :NEW.NOMARCH,
    :NEW.CUERPO,
    :NEW.QUERY,
    :NEW.CABECERA,
    :NEW.DETALLE1,
    :NEW.DETALLE2,
    :NEW.CANT_COLUMNAS,
    :NEW.GRUPO,
    :NEW.TABLA,
    :NEW.ESTADO,
    :NEW.TIPOFORMATO,--ini MMC 30/01/2013
    :NEW.CONDICION1,
    :NEW.CAMPOFECHA,
    :NEW.CAMPOSOT,
    :NEW.CAMPOPROY,--fin MMC 30/01/2013
    v_accion,:NEW.ORDEN);--3.0
  ELSIF UPDATING THEN
     v_accion := 'U';
    INSERT INTO HISTORICO.CFG_ENV_CORREO_CONTRATA_LOG
    (  IDCFG,
    FASE,
    NOMARCH,
    CUERPO,
    QUERY,
    CABECERA,
    DETALLE1,
    DETALLE2,
    CANT_COLUMNAS,
    GRUPO,
    TABLA,
    ESTADO,
    TIPOFORMATO,--ini MMC 30/01/2013
    CONDICION1,
    CAMPOFECHA,
    CAMPOSOT,
    CAMPOPROY,--fin MMC 30/01/2013
    TIPO_ACC_LOG,ORDEN)--3.0
    VALUES
    (:NEW.IDCFG,
    :NEW.FASE,
    :NEW.NOMARCH,
    :NEW.CUERPO,
    :NEW.QUERY,
    :NEW.CABECERA,
    :NEW.DETALLE1,
    :NEW.DETALLE2,
    :NEW.CANT_COLUMNAS,
    :NEW.GRUPO,
    :NEW.TABLA,
    :NEW.ESTADO,
    :NEW.TIPOFORMATO,--ini MMC 30/01/2013
    :NEW.CONDICION1,
    :NEW.CAMPOFECHA,
    :NEW.CAMPOSOT,
    :NEW.CAMPOPROY,--fin MMC 30/01/2013
    v_accion,:NEW.ORDEN);--3.0
  ELSIF DELETING THEN
     v_accion := 'D';
    INSERT INTO HISTORICO.CFG_ENV_CORREO_CONTRATA_LOG
    (  IDCFG,
    FASE,
    NOMARCH,
    CUERPO,
    QUERY,
    CABECERA,
    DETALLE1,
    DETALLE2,
    CANT_COLUMNAS,
    GRUPO,
    TABLA,
    ESTADO,
    TIPOFORMATO,--ini MMC 30/01/2013
    CONDICION1,
    CAMPOFECHA,
    CAMPOSOT,
    CAMPOPROY,--fin MMC 30/01/2013
    TIPO_ACC_LOG,ORDEN)--3.0
    VALUES
    (:OLD.IDCFG,
    :OLD.FASE,
    :OLD.NOMARCH,
    :OLD.CUERPO,
    :OLD.QUERY,
    :OLD.CABECERA,
    :OLD.DETALLE1,
    :OLD.DETALLE2,
    :OLD.CANT_COLUMNAS,
    :OLD.GRUPO,
    :OLD.TABLA,
    :OLD.ESTADO,
    :OLD.TIPOFORMATO,--ini MMC 30/01/2013
    :OLD.CONDICION1,
    :OLD.CAMPOFECHA,
    :OLD.CAMPOSOT,
    :OLD.CAMPOPROY,--fin MMC 30/01/2013
    v_accion,:NEW.ORDEN);--3.0
  END IF;
END;
/