CREATE OR REPLACE TRIGGER OPERACION.T_OTPTOETA_BD
 BEFORE delete ON OTPTOETA
 REFERENCING OLD AS OLD
FOR EACH ROW
DECLARE
tmpVar NUMBER;
BEGIN

   delete otptoetapla where codot = :old.codot and punto = :old.punto and codeta = :old.codeta;

END;
/



