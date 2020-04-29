CREATE OR REPLACE TRIGGER OPERACION.T_VTATABCLI_HIS_BU
  BEFORE UPDATE ON OPERACION.VTATABCLI_HIS
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/***********************************************************************
  REVISIONES:
   Versi?n     Fecha         Autor              Solicitado por             Descripcion
  ---------  -----------   ----------------     -----------------    ----------------------------------
     1.0      14/05/2015   Jorge Rivas          NALDA AROTINCO         PROY-17652 Adm Manejo de Cuadrillas
  ************************************************************************/
DECLARE
  lv_ip operacion.vtatabcli_his.ipmod%type;
BEGIN
  SELECT sys_context('userenv', 'ip_address') into lv_ip from dual;

  :new.ipmod  := lv_ip;
  :new.usumod := user;
  :new.fecmod := sysdate;
END;
/
