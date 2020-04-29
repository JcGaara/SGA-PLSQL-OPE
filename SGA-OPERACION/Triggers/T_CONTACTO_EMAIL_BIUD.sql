CREATE OR REPLACE TRIGGER OPERACION.T_CONTACTO_EMAIL_BIUD
/*********************************************************************************************
     NOMBRE:            T_CONTACTO_EMAIL_BIUD
     PROPOSITO:
     REVISIONES:
     Ver        Fecha        Autor            Descripcion
     ---------  ----------  ---------------   -----------------------------------
     1.0       25/04/2011   Juan Ramos Pérez  REQ.157873 Mejoras en bloqueo/desbloqueo por FCO y conciliación de pagos por FCO
***********************************************************************************************/
  AFTER UPDATE OR DELETE ON OPERACION.CONTACTO_EMAIL_BLOQUEO
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
DECLARE
  V_ACCION VARCHAR2(3);
BEGIN

  IF UPDATING OR DELETING THEN
    --Si modifico o Borro

    IF UPDATING THEN
      V_ACCION := 'UPD';
    ELSIF DELETING THEN
      V_ACCION := 'DEL';
    END IF;
    INSERT INTO HISTORICO.CONTACTO_EMAIL_BLOQUEO_LOG
      (IDCONTACTO,
       EMAIL_ORIGEN,
       EMAIL_DESTINO,
       ESTADO,
       MOTIVO,
       USUREG,
       FECREG,
       USUMOD,
       FECMOD,
       USUARIO_LOG,
       DATE_LOG,
       ACCION_LOG)
    VALUES
      (:OLD.IDCONTACTO,
       :OLD.EMAIL_ORIGEN,
       :OLD.EMAIL_DESTINO,
       :OLD.ESTADO,
       :OLD.MOTIVO,
       :OLD.USUREG,
       :OLD.FECREG,
       :OLD.USUMOD,
       :OLD.FECMOD,
       USER,
       SYSDATE,
       V_ACCION);
  END IF;
END;
/



