/*Creacion de constantes y parametros*/
declare 
   ln_cont number;
   ln_tipopedd number;
begin
  select count(1) into ln_cont from constante c
  where c.constante = 'PAR_SUSP_APC';
  
  if ln_cont = 0 then
    insert into constante(constante, descripcion, tipo, valor)
    values('PAR_SUSP_APC', 'Parametro que identifica el tipo de bloqueo a BSCS (Tipo A: Activo y D: Desactivo la configuracion)', 
    'A', 'SUSP_APC');
  end if;
  
  select count(1) into ln_cont from constante c
  where c.constante = 'ESTPRV_BSCS';
  
  if ln_cont = 0 then
    insert into constante(constante, descripcion, valor)
    values('ESTPRV_BSCS', 'Estado de Provision BSCS', 80);
  end if;
  
  select count(1) into ln_cont 
  from tipopedd t where t.abrev = 'TIPREGCONTIWSGABSCS';
  
  if ln_cont = 0 then
    select max(tipopedd) + 1 into ln_tipopedd from tipopedd;
    
    insert into tipopedd(tipopedd, descripcion, abrev)
    values(ln_tipopedd, 'TIPREGCONTIWSGABSCS', 'TIPREGCONTIWSGABSCS');
    
    insert into opedd(codigon, descripcion, tipopedd, codigon_aux)
    values(412, 'HFC - TRASLADO EXTERNO',ln_tipopedd,1);
    
    insert into opedd(codigon, descripcion, tipopedd, codigon_aux)
    values(427, 'HFC - CAMBIO DE PLAN',ln_tipopedd,1);
    
    insert into opedd(codigon, descripcion, tipopedd, codigon_aux)
    values(658, 'HFC - SISACT INSTALACION PAQUETES TODO CLARO DIGITAL',ln_tipopedd,1);
    
    insert into opedd(codigon, descripcion, tipopedd, codigon_aux)
    values(676, 'HFC - PORTABILIDAD INSTALACIONES PAQUETES CLARO',ln_tipopedd,1);
    
    insert into opedd(codigon, descripcion, tipopedd, codigon_aux)
    values(678, 'HFC/SISACT - MIGRACION SISACT',ln_tipopedd,1);
  else
    
    select t.tipopedd into ln_tipopedd 
    from tipopedd t where t.abrev = 'TIPREGCONTIWSGABSCS';
    
    select count(1) into ln_cont 
    from opedd o where o.codigon = 412 and o.tipopedd = ln_tipopedd;
    
    if ln_cont = 0 then
      insert into opedd(codigon, descripcion, tipopedd, codigon_aux)
      values(412, 'HFC - TRASLADO EXTERNO',ln_tipopedd,1);
    end if;
    
    select count(1) into ln_cont 
    from opedd o where o.codigon = 427 and o.tipopedd = ln_tipopedd;
    
    if ln_cont = 0 then
      insert into opedd(codigon, descripcion, tipopedd, codigon_aux)
      values(427, 'HFC - CAMBIO DE PLAN',ln_tipopedd,1);
    end if;
    
    select count(1) into ln_cont 
    from opedd o where o.codigon = 658 and o.tipopedd = ln_tipopedd;
    
    if ln_cont = 0 then
      insert into opedd(codigon, descripcion, tipopedd, codigon_aux)
      values(658, 'HFC - SISACT INSTALACION PAQUETES TODO CLARO DIGITAL',ln_tipopedd,1);
    end if;
    
    select count(1) into ln_cont 
    from opedd o where o.codigon = 676 and o.tipopedd = ln_tipopedd;
    
    if ln_cont = 0 then
      insert into opedd(codigon, descripcion, tipopedd, codigon_aux)
      values(676, 'HFC - PORTABILIDAD INSTALACIONES PAQUETES CLARO',ln_tipopedd,1);
    end if;
    
    select count(1) into ln_cont 
    from opedd o where o.codigon = 678 and o.tipopedd = ln_tipopedd;
    
    if ln_cont = 0 then
      insert into opedd(codigon, descripcion, tipopedd, codigon_aux)
      values(678, 'HFC/SISACT - MIGRACION SISACT',ln_tipopedd,1);
    end if;
  end if;  

  COMMIT;

end;
/