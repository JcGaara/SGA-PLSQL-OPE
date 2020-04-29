-- Configuraciones

insert into tipopedd ( DESCRIPCION, ABREV)
values ('IW-Config  Fid', 'CONF_FID');

INSERT INTO tiptrabajo
  (tiptra, tiptrs, descripcion, fecusu, codusu, cuenta, coddpt, flgcom,
   flgpryint, codmotinssrv, sotfacturable, bloqueo_desbloqueo, horas, agenda,
   hora_ini, hora_fin, agendable, num_reagenda, horas_antes, corporativo,
   selpuntossot)
VALUES
  ((select max(tiptra) + 1 from tiptrabajo), 1, 'HFC - UPGRADE/DOWNGRADE INTERNET FIDELIZACION', SYSDATE,
   'EMELENDEZ', '', '', 0, 0, NULL, 0, '', NULL, NULL, '', '', 0, NULL, NULL,
   0, 0);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( null, (select tiptra from tiptrabajo where descripcion = 'HFC - UPGRADE/DOWNGRADE INTERNET FIDELIZACION'), 'HFC - UPGRADE/DOWNGRADE INTERNET FIDELIZACION', 'TIPTRA_FID',( select tipopedd from tipopedd where abrev = 'CONF_FID' ), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( ( select tareadef from tareadef where descripcion ='Activación/Desactivación Servicio Fidelizacion' ), null, 'Activación/Desactivación Servicio Fidelizacion', 'TAREA_FID', ( select tipopedd from tipopedd where abrev = 'CONF_FID' ), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, ( select wfdef from opewf.wfdef where descripcion = 'DUPLICIDAD POR FIDELIZACION' ), 'Activacion Y  desactivacion por fidelizacion', null, ( select tipopedd from tipopedd where upper(descripcion) like '%OP-ASIG FLUJO AUTOMATICOS%' ), null);

commit;