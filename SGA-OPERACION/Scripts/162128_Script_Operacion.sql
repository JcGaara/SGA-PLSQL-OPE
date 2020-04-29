
/* Nota: si algun tipo de trabajo ya existe omitir su creacion y seguir  con el siguiente grupo de scrip del documento*/


insert into OPERACION.TIPTRABAJO (TIPTRA, TIPTRS, DESCRIPCION, CUENTA, CODDPT, FLGCOM, FLGPRYINT, CODMOTINSSRV, SOTFACTURABLE, BLOQUEO_DESBLOQUEO, HORAS, AGENDA, HORA_INI, HORA_FIN, AGENDABLE, NUM_REAGENDA, HORAS_ANTES, CORPORATIVO, SELPUNTOSSOT)
values (( select max(tiptra) + 1  from  tiptrabajo ), 1, 'CAMBIO RECAUDACION TPI - COAXIAL', null, null, 0, 0, null, 0, 'N', null, null, null, null, 0, null, null, 0, 0);

commit;

insert into OPERACION.TIPTRABAJO (TIPTRA, TIPTRS, DESCRIPCION, CUENTA, CODDPT, FLGCOM, FLGPRYINT, CODMOTINSSRV, SOTFACTURABLE, BLOQUEO_DESBLOQUEO, HORAS, AGENDA, HORA_INI, HORA_FIN, AGENDABLE, NUM_REAGENDA, HORAS_ANTES, CORPORATIVO, SELPUNTOSSOT)
values (( select max(tiptra) + 1  from  tiptrabajo ), 1, 'CAMBIO RECAUDACION TPI - WIMAX', null, null, 0, 0, null, 0, 'N', null, null, null, null, 0, null, null, 0, 0);

commit;

insert into OPERACION.TIPTRABAJO (TIPTRA, TIPTRS, DESCRIPCION, CUENTA, CODDPT, FLGCOM, FLGPRYINT, CODMOTINSSRV, SOTFACTURABLE, BLOQUEO_DESBLOQUEO, HORAS, AGENDA, HORA_INI, HORA_FIN, AGENDABLE, NUM_REAGENDA, HORAS_ANTES, CORPORATIVO, SELPUNTOSSOT)
values (( select max(tiptra) + 1  from  tiptrabajo ), 1, 'CAMBIO RECAUDACION TPI - CDMA', null, null, 0, 0, null, 0, 'N', null, null, null, null, 0, null, null, 0, 0);

commit;


insert into OPERACION.TIPTRAXAREA(TIPTRA, CODDPT, AREA, TIPO)
values (( select tiptra from operacion.tiptrabajo  where descripcion ='CAMBIO RECAUDACION TPI - CDMA'), null , 54, 0);

insert into OPERACION.TIPTRAXAREA(TIPTRA, CODDPT, AREA, TIPO)
values (( select tiptra from operacion.tiptrabajo  where descripcion ='CAMBIO RECAUDACION TPI - WIMAX'), null , 54, 0);

insert into OPERACION.TIPTRAXAREA(TIPTRA, CODDPT, AREA, TIPO)
values (( select tiptra from operacion.tiptrabajo  where descripcion ='CAMBIO RECAUDACION TPI - COAXIAL'), null , 54, 0);

commit;

insert into OPERACION.TIPTRAXAREA(TIPTRA, CODDPT, AREA, TIPO)
values (( select tiptra from operacion.tiptrabajo  where descripcion ='CAMBIO RECAUDACION TPI - CDMA'), null , 54, 1);

insert into OPERACION.TIPTRAXAREA(TIPTRA, CODDPT, AREA, TIPO)
values (( select tiptra from operacion.tiptrabajo  where descripcion ='CAMBIO RECAUDACION TPI - WIMAX'), null , 54, 1);

insert into OPERACION.TIPTRAXAREA(TIPTRA, CODDPT, AREA, TIPO)
values (( select tiptra from operacion.tiptrabajo  where descripcion ='CAMBIO RECAUDACION TPI - COAXIAL'), null , 54, 1);

commit;






