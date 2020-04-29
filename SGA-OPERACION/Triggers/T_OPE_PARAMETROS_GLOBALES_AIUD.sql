CREATE OR REPLACE TRIGGER OPERACION.T_OPE_PARAMETROS_GLOBALES_AIUD
AFTER INSERT OR DELETE OR UPDATE
ON OPERACION.OPE_PARAMETROS_GLOBALES_AUX
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
  /*********************************************************************************************
  NOMBRE:            COLLECTIONS.T_OPE_PARAMETROS_GLOBALES_AIUD
  PROPOSITO:
  REVISIONES:
  Ver        Fecha        Autor           Descripcion
  ---------  ----------  ---------------  -----------------------------------
  1.0        03/08/2010  Miguel Aroñe     Creacion REQ 114326
  ***********************************************************************************************/
DECLARE
  V_USUARIO_LOG VARCHAR2(50);
  V_DATA_LOG DATE;
  V_ACAO_LOG CHAR(1);
  V_USER_NOLOG NUMBER(1) :=0;
BEGIN

  IF V_USER_NOLOG = 0 THEN
    SELECT min(OSUSER) INTO V_USUARIO_LOG
    FROM SYS.V_$SESSION
    WHERE AUDSID = USERENV('SESSIONID');
    V_USUARIO_LOG := V_USUARIO_LOG || '-' || USER;

    SELECT SYSDATE INTO V_DATA_LOG FROM DUAL;

    IF INSERTING THEN
       V_ACAO_LOG := 'I';
       INSERT INTO HISTORICO.ope_parametrosglobales_log(
          NOMBRE_PARAMETRO,
          VALORPARAMETRO,
          ACCION,
          USUREG
        )values(
          :NEW.NOMBRE_PARAMETRO,
          :NEW.VALORPARAMETRO,
          V_ACAO_LOG,
          V_USUARIO_LOG
        );
    ELSIF UPDATING THEN
       V_ACAO_LOG := 'U';
       INSERT INTO HISTORICO.ope_parametrosglobales_log(
          NOMBRE_PARAMETRO,
          VALORPARAMETRO,
          ACCION,
          USUREG
       )values(
          :OLD.NOMBRE_PARAMETRO,
          :OLD.VALORPARAMETRO,
          V_ACAO_LOG,
          V_USUARIO_LOG
        );
    ELSIF DELETING THEN
       V_ACAO_LOG := 'D';
       INSERT INTO HISTORICO.ope_parametrosglobales_log(
          NOMBRE_PARAMETRO,
          VALORPARAMETRO,
          ACCION,
          USUREG
       )values(
          :OLD.NOMBRE_PARAMETRO,
          :OLD.VALORPARAMETRO,
          V_ACAO_LOG,
          V_USUARIO_LOG
        );
    END IF;

  end if;

END;
/



