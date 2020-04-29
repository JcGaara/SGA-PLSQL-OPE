CREATE OR REPLACE TRIGGER OPERACION.T_EQUCOMXOPE_AIUD
AFTER INSERT OR UPDATE OR DELETE
ON OPERACION.EQUCOMXOPE
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW

  /******************************************************************************
     NOMBRE:       OPERACION.T_EQUCOMXOPE_AIUD
     DESCRIPCION:  Trigger para control de Modificaciones.


  ver   Date        Author           Description
  ----  ----------  ---------------  ------------------------------------
  1.0   15/07/2009  Alfonso Perez    Req. 96474 - Creación de Trigger
  ******************************************************************************/
DECLARE

--V_USUARIO_LOG VARCHAR2(30);
--V_DATE_LOG DATE;
V_ACAO_LOG CHAR(3);
--V_USER_NOLOG NUMBER(1) :=0;

BEGIN

IF INSERTING THEN
   V_ACAO_LOG := 'INS';
   INSERT INTO OPERACION.EQUCOMXOPE_LOG
   (  codequcom  ,
codtipequ ,
cantidad ,
esparte  ,
tipequ ,
    ACAO_LOG)
   VALUES
   (:NEW.codequcom  ,
:NEW.codtipequ ,
:NEW.cantidad ,
:NEW.esparte  ,
:NEW.tipequ ,
    V_ACAO_LOG);
ELSIF UPDATING THEN
   V_ACAO_LOG := 'UPD';
   INSERT INTO OPERACION.EQUCOMXOPE_LOG
      (  codequcom  ,
codtipequ ,
cantidad ,
esparte  ,
tipequ ,
    ACAO_LOG)
   VALUES
   (:OLD.codequcom  ,
:OLD.codtipequ ,
:OLD.cantidad ,
:OLD.esparte  ,
:OLD.tipequ ,
    V_ACAO_LOG);
ELSIF DELETING THEN
   V_ACAO_LOG := 'DEL';
   INSERT INTO OPERACION.EQUCOMXOPE_LOG
       (  codequcom  ,
codtipequ ,
cantidad ,
esparte  ,
tipequ ,
    ACAO_LOG)
   VALUES
   (:OLD.codequcom  ,
:OLD.codtipequ ,
:OLD.cantidad ,
:OLD.esparte  ,
:OLD.tipequ ,
    V_ACAO_LOG);
END IF;
END;
/



