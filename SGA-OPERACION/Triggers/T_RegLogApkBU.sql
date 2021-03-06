----------Create trigger update----------
CREATE OR REPLACE TRIGGER OPERACION.T_REG_LOG_APK_BU
BEFORE UPDATE
ON OPERACION.REG_LOG_APK
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
  :new.usumod   := user;
  :new.ipmod    := SYS_CONTEXT('USERENV','IP_ADDRESS');
  :new.pcmod    := SYS_CONTEXT('USERENV', 'TERMINAL');
  :new.fecmod   := sysdate;

END;
/