DECLARE
  ln_count NUMBER;
BEGIN

  UPDATE operacion.opedd
     SET codigon_aux = null
   WHERE tipopedd = (select tipopedd
                       from operacion.tipopedd
                      where descripcion = 'TIPO DE TRABAJO'
                        and abrev = 'TIPTRABAJO')
     AND abreviacion = 'SISACT_FTTH';

  UPDATE operacion.opedd
     SET codigon_aux = null
   WHERE tipopedd = (select tipopedd
                       from operacion.tipopedd
                      where descripcion = 'TIPO DE TRABAJO'
                        and abrev = 'TIPTRABAJO')
     AND abreviacion = 'SISACT';

  ln_count := 0;

  SELECT COUNT(*)
    INTO ln_count
    FROM operacion.opedd
   where CODIGON in
         (select tiptra
            from operacion.tiptrabajo
           where descripcion = 'FTTH/SIAC - SUSPENSION DEL SERVICIO')
     and TIPOPEDD = 1418;

  IF ln_count > 0 THEN
    delete operacion.opedd
     where CODIGON =
           (select tiptra
              from operacion.tiptrabajo
             where descripcion = 'FTTH/SIAC - SUSPENSION DEL SERVICIO')
       and TIPOPEDD = 1418;
  
  end if;

  ln_count := 0;

  SELECT COUNT(*)
    INTO ln_count
    FROM operacion.opedd o, operacion.tipopedd t
   WHERE o.tipopedd = t.tipopedd
     AND t.abrev = 'ASIGNARWFBSCS'
     AND o.codigon_aux = 2
     AND o.codigon =
         (select tiptra
            from operacion.tiptrabajo
           where descripcion = 'FTTH/SIAC - SUSPENSION DEL SERVICIO');

  IF ln_count > 0 THEN
    delete operacion.opedd
     where codigon =
           (select tiptra
              from operacion.tiptrabajo
             where descripcion = 'FTTH/SIAC - SUSPENSION DEL SERVICIO')
       and tipopedd = (SELECT tipopedd
                         from operacion.tipopedd t
                        WHERE t.abrev = 'ASIGNARWFBSCS')
       and codigon_aux = 2;
  
  end if;

  delete from operacion.tipopedd where abrev = 'SUSXTIPTRA';

  delete from operacion.opedd where abreviacion = 'SUSXTIPTRA_HFC';
  delete from operacion.opedd where abreviacion = 'SUSXTIPTRA_FTTH';

  delete FROM operacion.opedd
   where codigon in
         (select tiptra
            from tiptrabajo
           where descripcion = 'FTTH/SIAC - SUSPENSION DEL SERVICIO')
     and tipopedd = 1418;

  delete from operacion.ope_plantillasot
   where descripcion = 'FTTH - BSCS- SUSPENSION';

  delete from operacion.tiptrabajo
   where descripcion = 'FTTH/SIAC - SUSPENSION DEL SERVICIO';

  ln_count := 0;

  SELECT COUNT(1)
    INTO ln_count
    FROM operacion.opedd
   where codigon in
         (select tiptra
            from operacion.tiptrabajo
           where descripcion = 'FTTH/SIAC - RECONEXION DEL SERVICIO')
     and tipopedd =
         (select tipopedd
            from tipopedd
           where descripcion = 'Proceso Corte_Susp_Reconx');

  IF ln_count > 0 THEN
    delete operacion.opedd
     where codigon =
           (select tiptra
              from operacion.tiptrabajo
             where descripcion = 'FTTH/SIAC - RECONEXION DEL SERVICIO')
       and tipopedd =
           (select tipopedd
              from tipopedd
             where descripcion = 'Proceso Corte_Susp_Reconx');
    commit;
  end if;

  ln_count := 0;

  SELECT COUNT(1)
    INTO ln_count
    FROM operacion.opedd o, operacion.tipopedd t
   WHERE o.tipopedd = t.tipopedd
     AND t.abrev = 'ASIGNARWFBSCS'
     AND o.codigon_aux = 3
     AND o.codigon =
         (select tiptra
            from operacion.tiptrabajo
           where descripcion = 'FTTH/SIAC - RECONEXION DEL SERVICIO');

  IF ln_count > 0 THEN
    delete operacion.opedd
     where codigon =
           (select tiptra
              from operacion.tiptrabajo
             where descripcion = 'FTTH/SIAC - RECONEXION DEL SERVICIO')
       and tipopedd = (SELECT tipopedd
                         from operacion.tipopedd t
                        WHERE t.abrev = 'ASIGNARWFBSCS')
       and codigon_aux = 3;
  end if;

  delete from operacion.tipopedd where abrev = 'RECXTIPTRA';

  delete from operacion.tiptrabajo
   where descripcion = 'FTTH/SIAC - RECONEXION DEL SERVICIO';

  delete from operacion.opedd where abreviacion = 'RECXTIPTRA_HFC';
  delete from operacion.opedd where abreviacion = 'RECXTIPTRA_FTTH';

  delete FROM operacion.opedd
   where codigon in
         (select tiptra
            from tiptrabajo
           where descripcion = 'FTTH/SIAC - RECONEXION DEL SERVICIO')
     and tipopedd =
         (select tipopedd
            from tipopedd
           where descripcion = 'Proceso Corte_Susp_Reconx');

  delete from operacion.ope_plantillasot
   where descripcion = 'FTTH - BSCS-RECONEXION';

  ln_count := 0;

  SELECT COUNT(*)
    INTO ln_count
    FROM operacion.opedd
   where codigon in
         (select tiptra
            from operacion.tiptrabajo
           where descripcion = 'FTTH/SIAC - BAJA TOTAL DEL SERVICIO')
     and TIPOPEDD = 1418;

  IF ln_count > 0 THEN
    delete operacion.opedd
     where codigon =
           (select tiptra
              from operacion.tiptrabajo
             where descripcion = 'FTTH/SIAC - BAJA TOTAL DEL SERVICIO')
       and TIPOPEDD = 1418;
  end if;

  ln_count := 0;

  SELECT COUNT(1)
    INTO ln_count
    FROM operacion.opedd o, operacion.tipopedd t
   WHERE o.tipopedd = t.tipopedd
     AND t.abrev = 'ASIGNARWFBSCS'
     AND o.codigon_aux = 1
     AND o.codigon =
         (select tiptra
            from operacion.tiptrabajo
           where descripcion = 'FTTH/SIAC - BAJA TOTAL DEL SERVICIO');

  IF ln_count > 0 THEN
    delete operacion.opedd
     where codigon =
           (select tiptra
              from operacion.tiptrabajo
             where descripcion = 'FTTH/SIAC - BAJA TOTAL DEL SERVICIO')
       and tipopedd = (SELECT tipopedd
                         from operacion.tipopedd t
                        WHERE t.abrev = 'ASIGNARWFBSCS')
       and codigon_aux = 1;
  end if;

  delete from operacion.tipopedd where abrev = 'BAJAXTIPTRA';

  delete from operacion.opedd where abreviacion = 'BAJAXTIPTRA_HFC';
  delete from operacion.opedd where abreviacion = 'BAJAXTIPTRA_FTTH';
  delete from operacion.opedd
   where descripcion =
         'FTTH/SISACT - INSTALACION PAQUETES TODO CLARO DIGITAL';

  delete from operacion.ope_plantillasot
   where descripcion = 'FTTH - BSCS- BAJA';

  delete from operacion.tiptrabajo
   where descripcion = 'FTTH/SIAC - BAJA TOTAL DEL SERVICIO';

  commit;
end;
/
