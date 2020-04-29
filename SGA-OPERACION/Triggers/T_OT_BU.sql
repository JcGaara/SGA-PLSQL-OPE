CREATE OR REPLACE TRIGGER OPERACION.T_OT_BU
BEFORE UPDATE
ON OPERACION.OT
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
DECLARE
fec_actual date;
RETORNO NUMBER;
ls_texto varchar2(120);
cursor cur_correo is
select a.email
from envcorreo a where a.coddpt = :new.coddpt and a.tipo = 3;
BEGIN
	/********** temporal *********************************/
	if updating ('AREA') then
   	if :old.area is null then
      	return;
      end if;
   end if;

	if updating ('CODDPT') then
		select area into :new.area from areaope where coddpt = :new.coddpt;
   end if;
	/********** Fin temporal *********************************/
   -- SE actualiza la informaciopn del presupuesto
   if ( updating('FECCOM') or updating('TIPTRA') ) and :new.area >= 10 and :new.area <= 14 then
   	update presupuesto set feccom = :new.feccom, tiptra = :new.tiptra
      where codsolot = :new.codsolot;
   end if;


   --Estado Anulado
   IF :OLD.ESTOT = 5 and user <> 'OPERACION' then
   raise_application_error(-20500, 'No se pudo modificar una OT que ya ha sido anulada.');
   END IF;
   -- Estado Ejecutado
   IF :OLD.ESTOT = 4 then
     raise_application_error(-20500, 'No se pudo modificar una OT que ya ha sido concluida.');
  END IF;
  -- Si nuevo estado es Ejecutado o Concluido
  IF updating('ESTOT') and :new.estot <> :old.estot and :new.estot in (3,4) then
     if :new.fecfin is null then
     raise_application_error(-20500, 'No se puede Concluir una OT sin Ingresar la Fecha de Fin.');
     end if;
     begin
        select desdpt into ls_texto from pertabdpt where coddpt = :new.coddpt;
        ls_texto := 'Area: '||ls_texto||', fue concluida por '||user||' Fecha: '||to_char(sysdate,'dd/mm/yyyy hh24:mi:ss')||chr(13);
        ls_texto := ls_texto || F_GET_DETALLE_CORREO_OT(:new.codsolot) ;
        for  ls_correo in cur_correo loop
         P_ENVIA_CORREO_DE_TEXTO_ATT('Orden de Trabajo '||to_char(:new.codot)|| ' concluida', ls_correo.email, ls_texto);
        end  loop;
     exception
        when others then
        null;
     end;
  END IF;
   fec_actual := sysdate;
   if UPDATING('ESTOT') then
   if :new.estot <> :old.estot then
        insert into DOCESTHIS (docid,docest,docestold,fecha) values (:NEW.docid,:NEW.estot,:OLD.estot,fec_actual);
       :new.fecultest := fec_actual;
   end if;
   if (:old.FLAGEJE = 1) and (:new.ESTOT in (2,3,9,10,11)) then
     if :new.estot = 2 then
	      update solot
      		 set estsolope = 6,
                 estsol = 17
			 where codsolot = :OLD.codsolot and derivado = 1;
	  elsif :new.estot = 3 then
	      update solot
      		 set fecfin = :new.fecfin,
                 estsolope = 4,
                 estsol = 12
			 where codsolot = :OLD.codsolot and derivado = 1;
	  elsif :new.estot = 9 then
	      update solot
      		 set estsolope = 3,
                 estsol = 19
			 where codsolot = :OLD.codsolot and derivado = 1;
	  elsif :new.estot = 10 then
	      update solot
      		 set estsolope = 7,
                 estsol = 27
			 where codsolot = :OLD.codsolot and derivado = 1;
	  elsif :new.estot = 11 then
	      update solot
      		 set estsolope = 8,
             estsol = 28
			 where codsolot = :OLD.codsolot and derivado = 1;
	  end if;
   end if;
   end if;
END;
/



