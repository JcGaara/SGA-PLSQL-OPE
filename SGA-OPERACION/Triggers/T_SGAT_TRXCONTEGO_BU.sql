CREATE OR REPLACE TRIGGER OPERACION.T_SGAT_TRXCONTEGO_BU
  BEFORE UPDATE ON OPERACION.SGAT_TRXCONTEGO
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
  /***************************************************************************************************
    NAME:       OPERACION.T_SGAT_TRXCONTEGO_BU
    REVISIONS:
    Ver          Date         Author          Description
    ---------    ----------  -------------  --------------------------------------------------------
    1.0          22/08/2017  Jose Arriola   PROY-29955 Alineacion CONTEGO - Campos auditoria
***************************************************************************************************/
declare
LC_USUARIO_MOD varchar2(100);
BEGIN

  SELECT MAX(OSUSER)
    INTO LC_USUARIO_MOD
    FROM V$SESSION
   WHERE AUDSID = (SELECT USERENV('sessionid') FROM DUAL);

  :NEW.TRXV_USUMOD := LC_USUARIO_MOD;
  :NEW.TRXD_FECMOD := SYSDATE;
END;
/