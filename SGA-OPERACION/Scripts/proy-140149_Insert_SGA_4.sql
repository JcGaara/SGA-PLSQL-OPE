declare
li_tipopedd number;
V_INSERT varchar2(800); 
begin

 insert into operacion.tipopedd (descripcion, abrev)
 values ('TIPO DE EQUIPO A INSTALAR','TYPEQUIPINSTALL'); 

  begin
    select tipopedd into li_tipopedd from operacion.tipopedd
    where descripcion = 'TIPO DE EQUIPO A INSTALAR' and abrev = 'TYPEQUIPINSTALL';
  exception
   when no_data_found then
     li_tipopedd := 0;
   when others then
     li_tipopedd := 0;
  end;

 if li_tipopedd > 0 then
 	
	insert into operacion.opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
	values ('HFC', 'Lista decodificadores', 'DECODIFICADOR', li_tipopedd, 1);
	insert into operacion.opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
	values ('HFC', 'Lista Emta', 'EMTA', li_tipopedd, 1);
	insert into operacion.opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
	values ('LTE', 'Lista Sim Card', 'SIM CARD', li_tipopedd, 0);
	insert into operacion.opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
	values ('LTE', 'Lista Smart Card', 'SMART CARD', li_tipopedd, 0);	

 end if;

 commit;
 
 V_INSERT := 'CREATE GLOBAL TEMPORARY TABLE OPERACION.temp_data_140149 (
 		TIPO_PRODUCTO VARCHAR2(20),
 		descripcion VARCHAR2(200),
 		cantidad NUMBER) ON COMMIT DELETE ROWS';

 EXECUTE IMMEDIATE V_INSERT;

end;
/
 	