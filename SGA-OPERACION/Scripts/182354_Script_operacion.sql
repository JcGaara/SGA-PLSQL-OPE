/* Pase a produccion 
   VERSION 2: Se reemplazo TIPTRA_RECHAZA_SOT_INST_HFC por TIPTRA_ANULA_SOT_INST_HFC  */
----------------------------------------------------------------------------
insert into operacion.flujoestsol values((select max(idseq) from operacion.flujoestsol)+1,1,22,1);
insert into operacion.flujoestsol values((select max(idseq) from operacion.flujoestsol)+1,1,22,2);
insert into operacion.flujoestsol values((select max(idseq) from operacion.flujoestsol)+1,1,22,3);
insert into operacion.flujoestsol values((select max(idseq) from operacion.flujoestsol)+1,1,22,4);
insert into operacion.flujoestsol values((select max(idseq) from operacion.flujoestsol)+1,1,22,5);
insert into operacion.flujoestsol values((select max(idseq) from operacion.flujoestsol)+1,1,22,6);
insert into operacion.flujoestsol values((select max(idseq) from operacion.flujoestsol)+1,1,22,7);
insert into operacion.flujoestsol values((select max(idseq) from operacion.flujoestsol)+1,1,22,8);
insert into operacion.flujoestsol values((select max(idseq) from operacion.flujoestsol)+1,1,22,9);
insert into operacion.flujoestsol values((select max(idseq) from operacion.flujoestsol)+1,1,22,10);
insert into operacion.flujoestsol values((select max(idseq) from operacion.flujoestsol)+1,1,22,11);
insert into operacion.flujoestsol values((select max(idseq) from operacion.flujoestsol)+1,1,22,12);
insert into operacion.flujoestsol values((select max(idseq) from operacion.flujoestsol)+1,1,22,13);
insert into operacion.flujoestsol values((select max(idseq) from operacion.flujoestsol)+1,1,22,14);
insert into operacion.flujoestsol values((select max(idseq) from operacion.flujoestsol)+1,1,22,15);
insert into operacion.flujoestsol values((select max(idseq) from operacion.flujoestsol)+1,1,22,16);
insert into operacion.flujoestsol values((select max(idseq) from operacion.flujoestsol)+1,1,22,17);
insert into operacion.flujoestsol values((select max(idseq) from operacion.flujoestsol)+1,1,22,18);
insert into operacion.flujoestsol values((select max(idseq) from operacion.flujoestsol)+1,1,22,19);
insert into operacion.flujoestsol values((select max(idseq) from operacion.flujoestsol)+1,1,22,80);
insert into operacion.flujoestsol values((select max(idseq) from operacion.flujoestsol)+1,1,22,89);
commit;

insert into operacion.estsol (ESTSOL,DESCRIPCION,FECUSU,CODUSU,ABREVI,TIPESTSOL)
values ( 22/*VALOR LIBRE SEGUN PRD*/,'Rechazado por Sistemas',sysdate,user,'RXS',7   ) ;

commit;

---
declare
  li_count number;
  li_tipopedd number;
  li_opedd number;
begin
  select count(*) into li_count from tipopedd where abrev = 'MANT_IWAY_HFC';

  if li_count = 0 then
    select max(tipopedd)+1 into li_tipopedd from tipopedd;

    insert into tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
    values (li_tipopedd , 'MANTENIMIENTO DE IWAY Y SOT', 'MANT_IWAY_HFC');

    select max(idopedd)+1 into li_opedd from opedd;

    insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
    values (li_opedd, 'ACTIVO', 22, 'Rechazado a Rechazado por Sistemas', 'RECH_X_SIS', li_tipopedd, null);
   
  end if;

end;
/

commit;

