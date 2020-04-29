insert into operacion.tipopedd(descripcion, abrev)  
       values('CONFIG. DE CODIGO SNCODE-SIAC', 'CONF_SIACSNCOD');

insert into operacion.opedd(codigoc, descripcion, abreviacion, tipopedd)  
       values(2500,
              'SNCODE DE BSCS',
              'SNCODE',
             (select a.tipopedd
                from operacion.tipopedd a
               where a.abrev = 'CONF_SIACSNCOD'));

insert into operacion.TIPOPEDD(DESCRIPCION, ABREV)
       values('Tip. Trab. Camb. Equipo/Chip', 'TIP_TRAB_EQU_CHIP');

insert into operacion.opedd
  (CODIGOC,
   CODIGON,
   DESCRIPCION,
   ABREVIACION,
   TIPOPEDD,
   CODIGON_AUX)
values
  (null,
   (select tiptra
      from operacion.tiptrabajo
     where descripcion = 'WLL/SIAC - MANTENIMIENTO'),
   'TIPO_TRABAJO_MANTENIMIENTO_LTE',
   'TIP_TRA_MNT_LTE',
   (select tipopedd from operacion.TIPOPEDD WHERE ABREV = 'TIP_TRAB_EQU_CHIP'),
   null);
   
insert into operacion.opedd
  (CODIGOC,
   CODIGON,
   DESCRIPCION,
   ABREVIACION,
   TIPOPEDD,
   CODIGON_AUX)
values
  (null,
   (select tiptra from operacion.tiptrabajo where descripcion = 'WLL/SIAC - RECLAMOS'),
   'TIPO_TRABAJO_RECLAMO_LTE',
   'TIP_TRA_RCM_LTE',
   (select tipopedd from operacion.TIPOPEDD WHERE ABREV = 'TIP_TRAB_EQU_CHIP'),
   null);
   
commit;
/