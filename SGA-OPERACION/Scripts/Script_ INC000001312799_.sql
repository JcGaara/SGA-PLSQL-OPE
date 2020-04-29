
insert into TIPOPEDD (DESCRIPCION, ABREV)
values ( 'Tipo Trabajo Anulacion SOT', 'TIPTRA_ANU_SOT');


insert into OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( null, 744, null, 'TIPTRA_ANU_SOT', (select t.tipopedd from tipopedd t where t.abrev = 'TIPTRA_ANU_SOT'), 1 );

insert into OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( null, 678, null, 'TIPTRA_ANU_SOT',(select t.tipopedd from tipopedd t where t.abrev = 'TIPTRA_ANU_SOT') , 1 );

insert into OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( null, 676, null, 'TIPTRA_ANU_SOT',(select t.tipopedd from tipopedd t where t.abrev = 'TIPTRA_ANU_SOT') , 1 );


insert into TIPOPEDD (DESCRIPCION, ABREV)
values ('Estado Trabajo Anulacion SOT', 'ESTADO_ANU_SOT');

insert into OPEDD ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( null, 22, null, 'ESTADO_ANU_SOT', (select t.tipopedd from tipopedd t where t.abrev = 'ESTADO_ANU_SOT'), 1);

COMMIT
/




