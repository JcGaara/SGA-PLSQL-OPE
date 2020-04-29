CREATE OR REPLACE TRIGGER OPERACION.T_OPE_EQU_IW_AIUD
AFTER INSERT OR UPDATE OR DELETE
ON OPERACION.OPE_EQU_IW REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
 /**************************************************************************
   NOMBRE:     T_OPE_EQU_IW_AIUD
   PROPOSITO:  Genera log de trsbambaf
   REVISIONES:
   Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------   ------------------------
   1.0        16/10/2010  Edilberto Astulle PROY-3968_Optimizacion de Interface Intraway - SGA para la carga de equipos
   2.0        16/02/2012  Edilberto Astulle PROY-6892_Restriccion de Acceso a Servicios 3Play Edificios
   **************************************************************************/

DECLARE
nSecuencial number;
BEGIN
  SELECT operacion.SEQ_EQU_IW.NEXTVAL  INTO nSecuencial FROM dummy_ope;
  IF INSERTING THEN
     INSERT INTO HISTORICO.OPE_EQU_IW_HIS
      (ID_SEQ_EQU ,
      ID_PRODUCTO ,
      ID_INTERFASE ,
      ID_CLIENTE ,
      IDTRANSACCION ,
      ID_ACTIVACION ,
      MACADDRESS ,
      SERIALNUMBER ,
      MODELO ,
      CODSOLOT ,
      FECUSU ,
      CODUSU ,
      TIP_ACC_LOG,OBJETOIW,ERROR ) --2.0
     VALUES
      (nSecuencial,
      :NEW.ID_PRODUCTO ,
      :NEW.ID_INTERFASE ,
      :NEW.ID_CLIENTE ,
      :NEW.IDTRANSACCION ,
      :NEW.ID_ACTIVACION ,
      :NEW.MACADDRESS ,
      :NEW.SERIALNUMBER ,
      :NEW.MODELO ,
      :NEW.CODSOLOT ,
      SYSDATE ,
      USER,
      'I',:NEW.OBJETOIW,:NEW.ERROR );--2.0
  ELSIF UPDATING THEN
     INSERT INTO HISTORICO.OPE_EQU_IW_HIS
      (ID_SEQ_EQU ,
      ID_PRODUCTO ,
      ID_INTERFASE ,
      ID_CLIENTE ,
      IDTRANSACCION ,
      ID_ACTIVACION ,
      MACADDRESS ,
      SERIALNUMBER ,
      MODELO ,
      CODSOLOT ,
      FECUSU ,
      CODUSU ,
      TIP_ACC_LOG ,OBJETOIW,ERROR ) --2.0
     VALUES
      (nSecuencial,
      :NEW.ID_PRODUCTO ,
      :NEW.ID_INTERFASE ,
      :NEW.ID_CLIENTE ,
      :NEW.IDTRANSACCION ,
      :NEW.ID_ACTIVACION ,
      :NEW.MACADDRESS ,
      :NEW.SERIALNUMBER ,
      :NEW.MODELO ,
      :NEW.CODSOLOT ,
      SYSDATE ,
      USER,
      'U',:NEW.OBJETOIW,:NEW.ERROR );--2.0
  ELSIF DELETING THEN
      INSERT INTO HISTORICO.OPE_EQU_IW_HIS
      (ID_SEQ_EQU ,
      ID_PRODUCTO ,
      ID_INTERFASE ,
      ID_CLIENTE ,
      IDTRANSACCION ,
      ID_ACTIVACION ,
      MACADDRESS ,
      SERIALNUMBER ,
      MODELO ,
      CODSOLOT ,
      FECUSU ,
      CODUSU ,
      TIP_ACC_LOG  ,OBJETOIW,ERROR ) --2.0
     VALUES
      (nSecuencial,
      :old.ID_PRODUCTO ,
      :old.ID_INTERFASE ,
      :old.ID_CLIENTE ,
      :old.IDTRANSACCION  ,
      :old.ID_ACTIVACION ,
      :old.MACADDRESS ,
      :old.SERIALNUMBER ,
      :old.MODELO ,
      :old.CODSOLOT ,
      SYSDATE ,
      USER,
      'D',:NEW.OBJETOIW,:NEW.ERROR );--2.0
  END IF;

END;
/