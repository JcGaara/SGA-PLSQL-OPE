CREATE OR REPLACE TRIGGER OPERACION.T_REGINSPROF24H_TBI
  BEFORE INSERT ON OPERACION.REGINSPROF24H
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
DECLARE
  id          number(15);
  ls_codsuc   vtasuccli.codsuc%type;
  ls_tipoplan  reginsprof24h.tipo_plan%type;
BEGIN
  :NEW.fecusu    := SYSDATE;
  :NEW.ESTPROF24H  :='01';
  :NEW.codusu    := USER;
  :NEW.tipdoccon   :='05';
  ls_tipoplan:=:NEW.tipo_plan;

BEGIN
  select  codsuc
  into ls_codsuc
  from inssrv
  where codcli=:NEW.codcli
  and tipinssrv=1
  and estinssrv=1
  and rownum=1;
    EXCEPTION
      WHEN OTHERS THEN
           ls_codsuc:=NULL;
      END;
  :NEW.codsuc:=ls_codsuc;

END;
/



