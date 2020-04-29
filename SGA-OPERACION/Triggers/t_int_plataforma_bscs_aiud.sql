CREATE OR REPLACE TRIGGER operacion.t_int_plataforma_bscs_aiud
  AFTER INSERT OR UPDATE OR DELETE ON operacion.int_plataforma_bscs
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/***************************************************************************************************
    NAME:       operacion.t_int_plataforma_bscs_aiud
    REVISIONS:
    Ver          Date         Author          Description
    ---------    ----------  -------------  --------------------------------------------------------
    1.0          17/01/2013  Roy Concepcion  REQ - 163763
***************************************************************************************************/
DECLARE
  LC_USUARIO_LOG VARCHAR2(100);
  LC_ACCION      CHAR(1);
  LN_ID          NUMBER(20);

BEGIN

  SELECT historico.sq_int_plataforma_bscs_log.NEXTVAL
    INTO LN_ID
    FROM DUAL;

  SELECT MAX(OSUSER)
    INTO LC_USUARIO_LOG
    FROM V$SESSION
   WHERE AUDSID = (SELECT USERENV('SESSIONID') FROM DUAL);

  LC_USUARIO_LOG := TRIM(RPAD(USER || '-' || LC_USUARIO_LOG, 50));

  IF INSERTING THEN
    LC_ACCION := 'I';
    INSERT INTO HISTORICO.Int_Plataforma_Bscs_Log
      (IDTRANSHIS,
      IDTRANS,
      CODIGO_CLIENTE,
      CODIGO_CUENTA,
      RUC,
      NOMBRE,
      APELLIDOS,
      TIPDIDE,
      NTDIDE,
      RAZON,
      TELEFONOR1,
      TELEFONOR2,
      EMAIL,
      DIRECCION,
      REFERENCIA,
      DISTRITO,
      PROVINCIA,
      DEPARTAMENTO,
      CO_ID,
      NUMERO,
      IMSI,
      CICLO,
      ACTION_ID,
      TRAMA,
      PLAN_BASE,
      PLAN_OPCIONAL,
      PLAN_OLD,
      PLAN_OPCIONAL_OLD,
      NUMERO_OLD,
      IMSI_OLD,
      CODUSU,
      FECUSU,
      USUREG,
      FECREG,
      TIPO_LOG,
      RESULTADO,
      MESSAGE_RESUL
      )
    VALUES
      (LN_ID,
      :NEW.IDTRANS,
      :NEW.CODIGO_CLIENTE,
      :NEW.CODIGO_CUENTA,
      :NEW.RUC,
      :NEW.NOMBRE,
      :NEW.APELLIDOS,
      :NEW.TIPDIDE,
      :NEW.NTDIDE,
      :NEW.RAZON,
      :NEW.TELEFONOR1,
      :NEW.TELEFONOR2,
      :NEW.EMAIL,
      :NEW.DIRECCION,
      :NEW.REFERENCIA,
      :NEW.DISTRITO,
      :NEW.PROVINCIA,
      :NEW.DEPARTAMENTO,
      :NEW.CO_ID,
      :NEW.NUMERO,
      :NEW.IMSI,
      :NEW.CICLO,
      :NEW.ACTION_ID,
      :NEW.TRAMA,
      :NEW.PLAN_BASE,
      :NEW.PLAN_OPCIONAL,
      :NEW.PLAN_OLD,
      :NEW.PLAN_OPCIONAL_OLD,
      :NEW.NUMERO_OLD,
      :NEW.IMSI_OLD,
      :NEW.CODUSU,
      :NEW.FECUSU,
       LC_USUARIO_LOG,
       SYSDATE,
       LC_ACCION,
       :NEW.RESULTADO,
       :NEW.Message_Resul);
  ELSIF UPDATING OR DELETING THEN
    IF UPDATING THEN
      LC_ACCION := 'U';
    ELSIF DELETING THEN
      LC_ACCION := 'D';
    END IF;

    INSERT INTO HISTORICO.Int_Plataforma_Bscs_Log
      (IDTRANSHIS,
      IDTRANS,
      CODIGO_CLIENTE,
      CODIGO_CUENTA,
      RUC,
      NOMBRE,
      APELLIDOS,
      TIPDIDE,
      NTDIDE,
      RAZON,
      TELEFONOR1,
      TELEFONOR2,
      EMAIL,
      DIRECCION,
      REFERENCIA,
      DISTRITO,
      PROVINCIA,
      DEPARTAMENTO,
      CO_ID,
      NUMERO,
      IMSI,
      CICLO,
      ACTION_ID,
      TRAMA,
      PLAN_BASE,
      PLAN_OPCIONAL,
      PLAN_OLD,
      PLAN_OPCIONAL_OLD,
      NUMERO_OLD,
      IMSI_OLD,
      CODUSU,
      FECUSU,
      USUREG,
      FECREG,
      TIPO_LOG,
      RESULTADO,
      MESSAGE_RESUL
      )
    VALUES
      (LN_ID,
      :OLD.IDTRANS,
      :OLD.CODIGO_CLIENTE,
      :OLD.CODIGO_CUENTA,
      :OLD.RUC,
      :OLD.NOMBRE,
      :OLD.APELLIDOS,
      :OLD.TIPDIDE,
      :OLD.NTDIDE,
      :OLD.RAZON,
      :OLD.TELEFONOR1,
      :OLD.TELEFONOR2,
      :OLD.EMAIL,
      :OLD.DIRECCION,
      :OLD.REFERENCIA,
      :OLD.DISTRITO,
      :OLD.PROVINCIA,
      :OLD.DEPARTAMENTO,
      :OLD.CO_ID,
      :OLD.NUMERO,
      :OLD.IMSI,
      :OLD.CICLO,
      :OLD.ACTION_ID,
      :OLD.TRAMA,
      :OLD.PLAN_BASE,
      :OLD.PLAN_OPCIONAL,
      :OLD.PLAN_OLD,
      :OLD.PLAN_OPCIONAL_OLD,
      :OLD.NUMERO_OLD,
      :OLD.IMSI_OLD,
      :OLD.CODUSU,
      :OLD.FECUSU,
       LC_USUARIO_LOG,
       SYSDATE,
       LC_ACCION,
       :OLD.RESULTADO,
       :OLD.MESSAGE_RESUL);
  END IF;
END;
/
