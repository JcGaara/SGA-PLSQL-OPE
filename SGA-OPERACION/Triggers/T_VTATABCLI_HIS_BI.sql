CREATE OR REPLACE TRIGGER OPERACION.T_VTATABCLI_HIS_BI
  BEFORE INSERT ON OPERACION.VTATABCLI_HIS
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/***********************************************************************
  REVISIONES:
   Versi?n     Fecha         Autor              Solicitado por             Descripcion
  ---------  -----------   ----------------     -----------------    ----------------------------------
     1.0      22/05/2015   Jorge Rivas          NALDA AROTINCO         PROY-17652 Adm Manejo de Cuadrillas
  ************************************************************************/
DECLARE
  lv_ip       operacion.vtatabcli_his.ipcre%type;
  ln_id       operacion.vtatabcli_his.id%type;
BEGIN
  SELECT operacion.SEQ_VTATABCLI_HIS.nextval
    INTO ln_id
    FROM dual;

  SELECT sys_context('userenv', 'ip_address') 
    INTO lv_ip 
    FROM dual;

  :new.id    := ln_id;
  :new.ipcre := lv_ip;
END;
/
