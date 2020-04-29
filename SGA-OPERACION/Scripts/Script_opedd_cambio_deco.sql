DECLARE
  ln_count NUMBER;
BEGIN
  ln_count := 0;

  ------------------------------------------------------------------------------------------
  -- Actualizar WLL/SIAC - DES. DECO ADICIONAL a WLL/SIAC - BAJA DECO ALQUILER en opedd
  ------------------------------------------------------------------------------------------
  ln_count := 0;
  
  SELECT COUNT(*)
    INTO ln_count
    FROM operacion.opedd o
    WHERE o.descripcion ='WLL/SIAC - DES. DECO ADICIONAL';
  IF ln_count > 0 THEN
   update operacion.opedd o
     set o.descripcion = 'WLL/SIAC - BAJA DECO ALQUILER'
     where o.descripcion = 'WLL/SIAC - DES. DECO ADICIONAL';
    commit;
  end if;

  ------------------------------------------------------------------------------------------
  -- Actualizar WLL/SIAC - ACT. DECO ADICIONAL a WLL/SIAC - CAMBIO DE DECOS en opedd
  ------------------------------------------------------------------------------------------
  ln_count := 0;
  
  SELECT COUNT(*)
    INTO ln_count
    FROM operacion.opedd o
    WHERE o.descripcion ='WLL/SIAC - ACT. DECO ADICIONAL';
  IF ln_count > 0 THEN
   update operacion.opedd o
     set o.descripcion = 'WLL/SIAC - CAMBIO DE DECOS'
     where o.descripcion = 'WLL/SIAC - ACT. DECO ADICIONAL';
    commit;
  end if;
  
  ------------------------------------------------------------------------------------------
  -- Insertamos  WLL/SIAC - CAMBIO DE DECOS para workflow
  ------------------------------------------------------------------------------------------
  ln_count := 0;
  
  SELECT COUNT(*)
    INTO ln_count
    FROM operacion.opedd o
    WHERE o.descripcion ='WLL/SIAC - CAMBIO DE DECOS'
    AND o.TIPOPEDD = 260;
  IF ln_count = 0 THEN
	insert into operacion.opedd (CODIGON, DESCRIPCION, TIPOPEDD)
	values ( (select wfdef from opewf.wfdef where descripcion='WLL/SIAC - CAMBIO DE DECOS'), 'WLL/SIAC - CAMBIO DE DECOS', 260);
    commit;
  end if;
     
END;
/