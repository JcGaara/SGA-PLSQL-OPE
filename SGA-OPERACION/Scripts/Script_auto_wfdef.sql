insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, (select wfdef from opewf.wfdef where descripcion='WLL/SIAC - DES. DECO ADICIONAL'), 'WLL/SIAC - DES. DECO ADICIONAL', null, 260, null);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, (select wfdef from opewf.wfdef where descripcion='WLL/SIAC - CAMBIO DE EQUIPO'), 'WLL/SIAC - CAMBIO DE EQUIPO', null, 260, null);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, (select wfdef from opewf.wfdef where descripcion='WLL/SIAC - DECO ADICIONAL'), 'WLL/SIAC - DECO ADICIONAL', null, 260, null);
commit;