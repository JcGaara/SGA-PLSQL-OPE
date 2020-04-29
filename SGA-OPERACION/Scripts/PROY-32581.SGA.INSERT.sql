/*****Creación de configuración*****/
--MOTIVO
insert into operacion.motot mt
  (mt.codmotot, mt.descripcion, mt.grupodesc, mt.tipmotot)
  select (select max(codmotot) + 1 from operacion.motot),
         'HFC/CE CAMBIO PLAN (SIN VISITA TECNICA)',
         'VISITA TECNICA CE',
         1
    from dual;

insert into operacion.motot mt
  (mt.codmotot, mt.descripcion, mt.grupodesc, mt.tipmotot)
  select (select max(codmotot) + 1 from operacion.motot),
         'HFC/CE CAMBIO PLAN (CON VISITA TECNICA)',
         'VISITA TECNICA CE',
         1
    from dual;

--TIPOPEDD
insert into operacion.tipopedd tp
  (tp.tipopedd, tp.descripcion, tp.abrev)
  select (select max(tipopedd) + 1 from operacion.tipopedd),
         'Tipo de Motivo Visita HFC/CE',
         'TIPO_MOT_HFC_CE_VIS'
    from dual;

--OPEDD
insert into operacion.opedd op
  (op.idopedd,
   op.codigoc,
   op.codigon,
   op.descripcion,
   op.abreviacion,
   op.tipopedd,
   op.codigon_aux)
  select (select max(idopedd) + 1 from operacion.opedd),
         'HFC',
         (select codmotot
            from operacion.motot
           where descripcion = 'HFC/CE CAMBIO PLAN (SIN VISITA TECNICA)'
             and grupodesc = 'VISITA TECNICA CE'),
         'HFC/CE CAMBIO PLAN (SIN VISITA TECNICA)',
         'HFC_SIN_VISTA_CE',
         (select tipopedd
            from operacion.tipopedd
           where descripcion = 'Tipo de Motivo Visita HFC/CE'
             and abrev = 'TIPO_MOT_HFC_CE_VIS'),
         0
    from dual;

insert into operacion.opedd op
  (op.idopedd,
   op.codigoc,
   op.codigon,
   op.descripcion,
   op.abreviacion,
   op.tipopedd,
   op.codigon_aux)
  select (select max(idopedd) + 1 from operacion.opedd),
         'HFC',
         (select codmotot
            from operacion.motot
           where descripcion = 'HFC/CE CAMBIO PLAN (CON VISITA TECNICA)'
             and grupodesc = 'VISITA TECNICA CE'),
         'HFC/CE CAMBIO PLAN (CON VISITA TECNICA)',
         'HFC_CON_VISTA_CE',
         (select tipopedd
            from operacion.tipopedd
           where descripcion = 'Tipo de Motivo Visita HFC/CE'
             and abrev = 'TIPO_MOT_HFC_CE_VIS'),
         1
    from dual;
    
    commit;
