CREATE OR REPLACE TRIGGER OPERACION.T_SOLOTPTO_BI
BEFORE INSERT
ON OPERACION.SOLOTPTO
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
/******************************************************************************
   NAME:       T_SOLOTPTO_BI
   REVISIONS:
   Ver        Fecha       Autor            Descripcion
   ---------  ----------  ---------------  ------------------------------------
   1.0     29/08/2011  Alexander Yong  REQ-160185: SOTs Baja 3Play
*******************************************************************************/
declare
--ini 1.0
--l_cid number;
--l_sid number;
ln_punto solotpto.punto%type;
--fin 1.0
BEGIN

   --:new.codusu := user;
   --:new.fecusu := sysdate;
   --ini 1.0
   if :new.punto is null then
     select F_GET_CLAVE_SOLOTPTO(:new.codsolot)
     into ln_punto from dummy_ope;
     :new.punto := ln_punto;
   end if;
   --fin 1.0

   if :new.codinssrv is not null then
     if :new.descripcion is null then
      begin
       select descripcion, direccion, codubi, cid into
           :new.descripcion, :new.direccion, :new.codubi, :new.cid from inssrv where codinssrv = :new.codinssrv;
      exception
        when others then
           null;
      end;
     end if;
   end if;

   if :new.codinssrv is not null  AND :new.cid is null then
      begin
        select cid into :new.cid from inssrv where codinssrv = :new.codinssrv;
      exception
        when others then
           null;
      end;
   end if;

END;
/



