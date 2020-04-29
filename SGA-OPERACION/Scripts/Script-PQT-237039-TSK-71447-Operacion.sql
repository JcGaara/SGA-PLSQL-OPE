--1.- SCRIPT PARAMETROS DE CLOUD
declare
  ln_tipopedd number;
begin
  select max(tipopedd) into ln_tipopedd from operacion.tipopedd;

  insert into operacion.tipopedd
    (tipopedd, descripcion, abrev)
  values
    (ln_tipopedd + 1, 'Conciliación/Facturación Cloud', 'CONFAC_CLOUD');

  insert into operacion.opedd
    (idopedd, codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    ((select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
     '0087',
     null,
     'Paquetes Cloud',
     'CLOUD',
     (select tipopedd from tipopedd where abrev = 'CONFAC_CLOUD'),
     null);
  
  insert into operacion.opedd
    (idopedd, codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    ((select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
     null,
     1,
     'Instalación',
     'TIPTRA',
     (select tipopedd from tipopedd where abrev = 'CONFAC_CLOUD'),
     null);
  
  insert into operacion.opedd
    (idopedd, codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    ((select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
     null,
     2,
     'Ejecución',
     'ESTTRS',
     (select tipopedd from tipopedd where abrev = 'CONFAC_CLOUD'),
     null);
     
  insert into operacion.opedd
    (idopedd, codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    ((select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
     null,
     5,
     'Cancelado',
     'TIPTRS',
     (select tipopedd from tipopedd where abrev = 'CONFAC_CLOUD'),
     null);
	 
  insert into operacion.opedd
    (idopedd, codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    ((select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
     null,
     12,
     'Cerrada',
     'EST_SOT',
     (select tipopedd from tipopedd where abrev = 'CONFAC_CLOUD'),
     null);

  insert into operacion.opedd
    (idopedd, codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    ((select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
     null,
     29,
     'Atendida',
     'EST_SOT',
     (select tipopedd from tipopedd where abrev = 'CONFAC_CLOUD'),
     null);

  insert into operacion.opedd
    (idopedd, codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    ((select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
     null,
     702,
     'Cloud - Activación de servicios',
     'TIPTRA',
     (select tipopedd from tipopedd where abrev = 'CONFAC_CLOUD'),
     null);
  commit;
end;
/