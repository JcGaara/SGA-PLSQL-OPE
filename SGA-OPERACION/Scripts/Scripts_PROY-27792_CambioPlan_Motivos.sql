Declare
 ln_codmot number;
 ln_count_val number;

Begin
  
  Select max(t.codmotot)
    into ln_codmot
    from operacion.motot t;
      
  ln_codmot := ln_codmot + 1;
    
  insert into operacion.motot (codmotot,descripcion,flgcom)
       values (ln_codmot, 'HFC/SIAC CAMBIO PLAN(SIN VISITA TECNICA)', 0);
              
  Select max(t.codmotot)
    into ln_codmot
    from operacion.motot t;
      
  ln_codmot := ln_codmot + 1;              
              
  insert into operacion.motot (codmotot,descripcion,flgcom)
       values (ln_codmot, 'HFC/SIAC CAMBIO PLAN(CON VISITA TECNICA)', 0);
              
  select count(1)
    into ln_count_val
    from operacion.tipopedd
   where abrev = 'TIPO_MOT_HFC_LTE_VIS';

  if ln_count_val = 0 then
    insert into operacion.tipopedd (descripcion, abrev)
         values('Tipo de Motivo Vista HFC/LTE','TIPO_MOT_HFC_LTE_VIS');
  end if;    
  
  select count(1)
    into ln_count_val
    from operacion.opedd
   where abreviacion = 'HFC_SI_VISTA'
     and tipopedd = (select tipopedd
                       from operacion.tipopedd
                      where abrev = 'TIPO_MOT_HFC_LTE_VIS');

  if ln_count_val = 0 then
      insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd, codigon_aux, abreviacion)
      values  ('HFC',
               (select codmotot
                  from operacion.motot
                 where descripcion = 'HFC/SIAC CAMBIO PLAN(SIN VISITA TECNICA)'),
               'HFC/SIAC CAMBIO PLAN(SIN VISITA TECNICA)',
               (select tipopedd
                  from operacion.tipopedd
                 where abrev = 'TIPO_MOT_HFC_LTE_VIS'),
               0,
               'HFC_SI_VISTA');
  end if;   
  
  
  select count(1)
    into ln_count_val
    from operacion.opedd
   where abreviacion = 'HFC_CON_VISTA'
     and tipopedd = (select tipopedd
                       from operacion.tipopedd
                      where abrev = 'TIPO_MOT_HFC_LTE_VIS');

  if ln_count_val = 0 then
      insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd, codigon_aux, abreviacion)
      values  ('HFC',
               (select codmotot
                  from operacion.motot
                 where descripcion = 'HFC/SIAC CAMBIO PLAN(CON VISITA TECNICA)'),
               'HFC/SIAC CAMBIO PLAN(CON VISITA TECNICA)',
               (select tipopedd
                  from operacion.tipopedd
                 where abrev = 'TIPO_MOT_HFC_LTE_VIS'),
               1,
               'HFC_CON_VISTA');
  end if;     
  
  select count(1)
    into ln_count_val
    from operacion.opedd
   where abreviacion = 'LTE_SI_VISTA'
     and tipopedd = (select tipopedd
                       from operacion.tipopedd
                      where abrev = 'TIPO_MOT_HFC_LTE_VIS');

  if ln_count_val = 0 then
      insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd, codigon_aux, abreviacion)
      values  ('LTE',
               (select codmotot
                  from operacion.motot
                 where descripcion = 'INALAMBRICO - CAMBIO DE PLAN (SIN VISITA TECNICA)'),
               'INALAMBRICO - CAMBIO DE PLAN (SIN VISITA TECNICA)',
               (select tipopedd
                  from operacion.tipopedd
                 where abrev = 'TIPO_MOT_HFC_LTE_VIS'),
               0,
               'LTE_SI_VISTA');
  end if;                

  
  select count(1)
    into ln_count_val
    from operacion.opedd
   where abreviacion = 'LTE_CON_VISTA'
     and tipopedd = (select tipopedd
                       from operacion.tipopedd
                      where abrev = 'TIPO_MOT_HFC_LTE_VIS');

  if ln_count_val = 0 then
      insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd, codigon_aux, abreviacion)
      values  ('LTE',
               (select codmotot
                  from operacion.motot
                 where descripcion = 'INALAMBRICO - CAMBIO DE PLAN (CON VISITA TECNICA)'),
               'INALAMBRICO - CAMBIO DE PLAN (CON VISITA TECNICA)',
               (select tipopedd
                  from operacion.tipopedd
                 where abrev = 'TIPO_MOT_HFC_LTE_VIS'),
               1,
               'LTE_CON_VISTA');
  end if;                
  
  INSERT INTO operacion.mototxtiptra (tiptra, codmotot) 
       values (695,
			   (SELECT codmotot 
			      FROM operacion.motot 
				 WHERE descripcion = 'HFC/SIAC CAMBIO PLAN(SIN VISITA TECNICA)') );
				 
  INSERT INTO operacion.mototxtiptra (tiptra, codmotot) 
       values (695,
			   (SELECT codmotot 
			      FROM operacion.motot 
				 WHERE descripcion = 'HFC/SIAC CAMBIO PLAN(CON VISITA TECNICA)') );			
				   
  INSERT INTO operacion.mototxtiptra (tiptra, codmotot) 
       values (753,
			   (SELECT codmotot 
			      FROM operacion.motot 
				 WHERE descripcion = 'INALAMBRICO - CAMBIO DE PLAN (SIN VISITA TECNICA)') );
				 
  INSERT INTO operacion.mototxtiptra (tiptra, codmotot) 
       values (753,
			   (SELECT codmotot 
			      FROM operacion.motot 
				 WHERE descripcion = 'INALAMBRICO - CAMBIO DE PLAN (CON VISITA TECNICA)') );		
  
  
  commit;
End;
/