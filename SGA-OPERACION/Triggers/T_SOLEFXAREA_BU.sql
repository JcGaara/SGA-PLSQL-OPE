CREATE OR REPLACE TRIGGER OPERACION.T_SOLEFXAREA_BU
BEFORE UPDATE
ON OPERACION.SOLEFXAREA
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
/******************************************************************************

Date        Author           Description
----------  ---------------  ------------------------------------
18/01/2008  Gustavo Ormeño     Se controla un log cada vez que el EF de cada area cambie de estado.

******************************************************************************/
declare
ls_codcli char(8);


BEGIN
     if updating ('ESTSOLEF') then
        INSERT INTO OPERACION.SOLEFXAREA_LOG_EST VALUES (:NEW.CODEF, :NEW.AREA,SYSDATE,USER,:OLD.ESTSOLEF,:NEW.ESTSOLEF);

        select codcli into ls_codcli from vtatabslcfac where numslc = :new.numslc;

        if :new.estsolef = 1 and nvl(:old.estsolef,0) <> 1 then
           insert into operacion.estsolef_dias_utiles(codef,codcli,codarea,estsolef,fechaini)
           values(:new.codef,ls_codcli,:new.area,:new.estsolef,sysdate);

        else
            if (:new.estsolef = 2 and :old.estsolef <> 2) or (:new.estsolef = 8 and :old.estsolef <> 8) or (:new.estsolef = 3 and :old.estsolef <> 3) or (:new.estsolef = 4 and :old.estsolef <> 4) or (:new.estsolef = 6 and :old.estsolef <> 6) or (:new.estsolef = 7 and :old.estsolef <> 7)  then
               update operacion.estsolef_dias_utiles set fechafin = sysdate
               where codef = :new.codef and codcli = ls_codcli and codarea =:new.area and fechafin is null;
            end if;
        end if;


     END IF;

     if updating ('AREA') then
      --JMAP
      update operacion.estsolef_dias_utiles set codarea = :new.area
      where codef = :old.codef and codarea = :old.area;
      --JMAP
     end if;
END;
/



