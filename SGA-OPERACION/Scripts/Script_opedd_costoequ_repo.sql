update operacion.tiptrabajo 
set descripcion='WLL/SIAC - CAMBIO DE DECOS' 
  where tiptra = (select tiptra from operacion.tiptrabajo where descripcion='WLL/SIAC - ACT. DECO ADICIONAL');
  
update operacion.tiptrabajo 
set descripcion='WLL/SIAC - BAJA DECO ALQUILER' 
  where tiptra = (select tiptra from operacion.tiptrabajo where descripcion='WLL/SIAC - DES. DECO ADICIONAL');

update operacion.opedd o
     set o.abreviacion ='WLL/SIAC - BAJA DECO ALQUILER',
     o.descripcion = 'WLL/SIAC - BAJA DECO ALQUILER'
     where idopedd = (select idopedd from operacion.opedd  where abreviacion ='WLL/SIAC - DES. DECO ADICIONAL');
     
update operacion.opedd o
     set o.abreviacion ='WLL/SIAC - CAMBIO DE DECOS',
      o.descripcion = 'WLL/SIAC - CAMBIO DE DECOS'
     where idopedd = (select idopedd from operacion.opedd  where abreviacion ='WLL/SIAC - ACT. DECO ADICIONAL');

insert into operacion.tipopedd (DESCRIPCION, ABREV)
values ('Penalidad por Reposición Equ', 'PENALIDAD_TIPEQU');

insert into operacion.opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (495, 'DECO GRABADOR DVR ', 'DVR', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'PENALIDAD_TIPEQU'), 2);

insert into operacion.opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (100, 'DECO HD', 'HD', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'PENALIDAD_TIPEQU'), 2);

insert into operacion.opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (85, 'DECO SD', 'SD', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'PENALIDAD_TIPEQU'), 2);

insert into operacion.opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (412, 'Modem (Indoor)', 'Internet_MO', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'PENALIDAD_TIPEQU'), 4);

insert into operacion.opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (120, 'Router / Switch (Outdoor)', 'Internet_RO', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'PENALIDAD_TIPEQU'), 4);

insert into operacion.opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (414, 'Antena Externa (Outdoor)', 'Internet_AN', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'PENALIDAD_TIPEQU'), 4);

insert into operacion.opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (0, 'Simcard', 'Internet_SC', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'PENALIDAD_TIPEQU'), 3);

insert into operacion.opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (0, 'Tarjeta', 'TAR', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'PENALIDAD_TIPEQU'), 1);

insert into operacion.tiptraventana (TIPTRA, IDVENTANA, CONTRATA, TITULO, TIPO, USUREG, FECREG, USUMOD, FECMOD)
values (756, 42, 0, 'Cambio de Estado SOT', 2, user, sysdate, user, sysdate)	 
  
/

commit;
