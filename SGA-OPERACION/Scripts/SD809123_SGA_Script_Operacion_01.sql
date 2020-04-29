ALTER TABLE OPERACION.TAB_REC_CSR_LTE_CAB ADD (IDLOTE NUMBER(10),IDSOL NUMBER(20), FLG_RECARGA NUMBER(1), TIPOSOLICITUD VARCHAR2(1), ESTADO NUMBER(1)) ;
ALTER TABLE OPERACION.TAB_REC_CSR_LTE_DET ADD ( IDLOTE NUMBER(10), IDSOL NUMBER(20));
COMMIT;

-- Reconexion de SIAC
UPDATE OPERACION.TIPTRABAJO
   SET DESCRIPCION = 'WLL/SIAC - RECONEXION DE SUSPENSION A SOLIC. DEL CLIENTE'
 WHERE DESCRIPCION = 'WLL/SIAC - RECONEXION A SOLIC. DEL CLIENTE';

insert into operacion.tiptrabajo
  (TIPTRA,
   TIPTRS,
   DESCRIPCION,
   CUENTA,
   CODDPT,
   FLGCOM,
   FLGPRYINT,
   CODMOTINSSRV,
   SOTFACTURABLE,
   BLOQUEO_DESBLOQUEO,
   HORAS,
   AGENDA,
   HORA_INI,
   HORA_FIN,
   AGENDABLE,
   NUM_REAGENDA,
   HORAS_ANTES,
   CORPORATIVO,
   SELPUNTOSSOT,
   ID_TIPO_ORDEN,
   ID_TIPO_ORDEN_CE)
values
  ((select max(tiptra) + 1 from tiptrabajo),
   3,
   'WLL/SIAC - RECONEXION DE CORTE A SOLIC. DEL CLIENTE',
   null,
   null,
   0,
   0,
   null,
   0,
   null,
   null,
   null,
   null,
   null,
   0,
   null,
   null,
   0,
   0,
   null,
   null);

-- Reconexion de OAC

update operacion.tiptrabajo
   set descripcion = 'RECONEXION DE SUSPENSION 3PLAY INALAMBRICO'
 where descripcion = 'RECONEXION 3PLAY INALAMBRICO';

insert into operacion.tiptrabajo
  (TIPTRA,
   TIPTRS,
   DESCRIPCION,
   CUENTA,
   CODDPT,
   FLGCOM,
   FLGPRYINT,
   CODMOTINSSRV,
   SOTFACTURABLE,
   BLOQUEO_DESBLOQUEO,
   HORAS,
   AGENDA,
   HORA_INI,
   HORA_FIN,
   AGENDABLE,
   NUM_REAGENDA,
   HORAS_ANTES,
   CORPORATIVO,
   SELPUNTOSSOT,
   ID_TIPO_ORDEN,
   ID_TIPO_ORDEN_CE)
values
  ((select max(tiptra) + 1 from tiptrabajo),
   3,
   'RECONEXION DE CORTE 3PLAY INALAMBRICO',
   null,
   null,
   0,
   0,
   null,
   0,
   null,
   null,
   null,
   null,
   null,
   0,
   null,
   null,
   0,
   0,
   null,
   null);

insert into operacion.tiptrabajo
  (TIPTRA,
   TIPTRS,
   DESCRIPCION,
   CUENTA,
   CODDPT,
   FLGCOM,
   FLGPRYINT,
   CODMOTINSSRV,
   SOTFACTURABLE,
   BLOQUEO_DESBLOQUEO,
   HORAS,
   AGENDA,
   HORA_INI,
   HORA_FIN,
   AGENDABLE,
   NUM_REAGENDA,
   HORAS_ANTES,
   CORPORATIVO,
   SELPUNTOSSOT,
   ID_TIPO_ORDEN,
   ID_TIPO_ORDEN_CE)
values
  ((select max(tiptra) + 1 from tiptrabajo),
   5,
   'WLL/SIAC - CANCELACION DE SERVICIO',
   null,
   null,
   0,
   0,
   null,
   0,
   null,
   null,
   null,
   null,
   null,
   0,
   null,
   null,
   0,
   0,
   null,
   null);
commit;
/

