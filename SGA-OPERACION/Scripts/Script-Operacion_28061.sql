declare
  l_tareadef_pre_sel     opewf.tareadef.tareadef%type;
  l_tareadef_pre_sel_inv opewf.tareadef.tareadef%type;
  l_tiptra_tfi           operacion.tiptrabajo.tiptra%type;
  l_tramaid_venta_tfi    sales.trama.tramaid%type;
  l_tramaid_servicio_tfi sales.trama.tramaid%type;
  l_tipsrv_tfi           sales.tystipsrv.tipsrv%type;
  l_idproducto_tfi       billcolper.producto.idproducto%type;
  l_idsolucion_tfi       sales.soluciones.idsolucion%type;
  l_idcampanha_tfi       sales.campanha.idcampanha%type;
  l_idpaq_tfi            sales.paquete_venta.idpaq%type;
  l_tipopedd             operacion.tipopedd.tipopedd%type;
  l_wfdef_tfi            OPEWF.WFDEF.WFDEF%type;
  l_wfdef_1147           opewf.wfdef.wfdef%type;
  l_wfdef_1195           opewf.wfdef.wfdef%type;
  l_wfdef_1237           opewf.wfdef.wfdef%type;
  l_pos_tareas           opewf.tareawfdef.pos_tareas%type;
  l_tarea                opewf.tareawfdef.tarea%type;

begin
  --- PROY-28061
  ------------------------------------------------------------------------------------------  
  -- Asignacion de WF
  ------------------------------------------------------------------------------------------
  select t.wfdef into l_wfdef_1147 from opewf.wfdef t where t.wfdef = 1147;
  select t.wfdef into l_wfdef_1195 from opewf.wfdef t where t.wfdef = 1195;
  select t.wfdef into l_wfdef_1237 from opewf.wfdef t where t.wfdef = 1237;

  ------------------------------------------------------------------------------------------
  -- Insercion de las tareas: Pre-Selección / Pre-Selección Inversa 
  ------------------------------------------------------------------------------------------
  insert into opewf.tareadef
    (tareadef, tipo, descripcion, pre_proc, pos_proc, flg_ft)
  values
    ((select max(t.tareadef) + 1 from OPEWF.tareadef t),
     0,
     'Pre-Seleccion',
     'sales.pkg_preseleccion.sgass_asignacion_pre_seleccion',
     null,
     0)
  returning tareadef into l_tareadef_pre_sel;
  commit;

  insert into opewf.tareadef
    (tareadef, tipo, descripcion, pre_proc, pos_proc, flg_ft)
  values
    ((select max(t.tareadef) + 1 from OPEWF.tareadef t),
     0,
     'Pre-Selección Inversa',
     'sales.pkg_preseleccion.sgass_asigna_pre_selec_inv',
     null,
     0)
  returning tareadef into l_tareadef_pre_sel_inv;
  commit;

  ------------------------------------------------------------------------------------------
  -- Insert del Tipo de Trabajo
  ------------------------------------------------------------------------------------------
  insert into operacion.tiptrabajo
    (tiptra,
     tiptrs,
     descripcion,
     flgcom,
     flgpryint,
     sotfacturable,
     agenda,
     corporativo,
     selpuntossot)
  values
    ((select max(tiptra) + 1 from tiptrabajo),
     1,
     'Instalacion paquete Sisact - TFI',
     0,
     0,
     0,
     0,
     0,
     0)
  returning tiptra into l_tiptra_tfi;

  ------------------------------------------------------------------------------------------
  --Insert de la definicion del WorkFlok
  ------------------------------------------------------------------------------------------  
  insert into opewf.wfdef
    (wfdef, estado, clasewf, descripcion, version)
  values
    ((select max(wfdef) + 1 from opewf.wfdef),
     1,
     0,
     'INSTALACION INALAMBRICO - TFI',
     1)
  returning wfdef into l_wfdef_tfi;

  ------------------------------------------------------------------------------------------
  -- Insert de la Trama - Venta Sisact - TFI
  ------------------------------------------------------------------------------------------
  insert into sales.trama
    (tramaid, description, type)
  values
    ((select max(t.tramaid) + 1 from sales.trama t),
     'VENTA SISACT - TFI',
     'RECORD')
  returning tramaid into l_tramaid_venta_tfi;
  commit;

  ------------------------------------------------------------------------------------------
  -- Insert de la Trama - Servicio Sisact - TFI
  ------------------------------------------------------------------------------------------
  insert into sales.trama
    (tramaid, description, type)
  values
    ((select max(t.tramaid) + 1 from sales.trama t),
     'SERVICIO SISACT - TFI',
     'ARRAY')
  returning tramaid into l_tramaid_servicio_tfi;
  commit;

  ------------------------------------------------------------------------------------------
  -- Insert del Detalle de la Trama - Venta Sisact - TFI
  ------------------------------------------------------------------------------------------
  insert into sales.trama_det
    (tramaid, orden, column_name, column_type, column_length, description)
    (select l_tramaid_venta_tfi,
            orden,
            column_name,
            column_type,
            column_length,
            description
       from sales.trama_det t
      where t.tramaid = 1);

  ------------------------------------------------------------------------------------------
  -- Insert del Detalle de la Trama - Servicio Sisact - TFI
  ------------------------------------------------------------------------------------------
  insert into sales.trama_det
    (tramaid, orden, column_name, column_type, column_length, description)
    (select l_tramaid_servicio_tfi,
            orden,
            column_name,
            column_type,
            column_length,
            description
       from sales.trama_det t
      where t.tramaid = 2);

  ------------------------------------------------------------------------------------------
  -- Insert del Tipo de Servicio - TFI
  ------------------------------------------------------------------------------------------
  insert into sales.tystipsrv
    (dsctipsrv, nomabr, estado, moneda_id, reservadesde)
  values
    ('Telefonia Fija Inalambrica', 'TFI', 1, 2, 0)
  returning tipsrv into l_tipsrv_tfi;
  commit;

  ------------------------------------------------------------------------------------------
  -- Insert del Producto - TFI
  ------------------------------------------------------------------------------------------
  insert into billcolper.producto
    (idtipperiodo,
     idfamilia,
     idlinea,
     nivel,
     prorrateorec,
     usacalser,
     usanivser,
     usaclaser,
     estado,
     chproductnumber,
     descripcion,
     idconceptoimpcr,
     idconceptoimpcnr,
     idtipinstserv,
     flagporcteledata,
     flgcrretroactivo,
     flgciclocompleto,
     flgcrcredito,
     flgprincipal,
     tipsrv,
     flgcantuno,
     flgenlprc,
     flgismst,
     flgnsrvm,
     flgupgrade,
     venta_adicional_cnr,
     flgdevintp,
     flgipxjuris,
     usaclaprd,
     usatipprd,
     usamodprd,
     visible,
     idprodxsrvsicorp,
     flg_sisact_sga,
     idgrupociclo)
  values
    (1,
     1,
     1,
     1,
     1,
     0,
     0,
     0,
     1,
     '0',
     'SISACT - TFI',
     1,
     4,
     3,
     0,
     0,
     0,
     0,
     0,
     l_tipsrv_tfi,
     0,
     0,
     0,
     0,
     0,
     0,
     0,
     0,
     0,
     0,
     0,
     1,
     0,
     0,
     2)
  returning idproducto into l_idproducto_tfi;
  commit;

  ------------------------------------------------------------------------------------------
  -- Insert del Grupo - TFI
  ------------------------------------------------------------------------------------------
  insert into sales.grupo_sisact
    (idgrupo_sisact, idproducto, estado)
  values
    ('020', l_idproducto_tfi, 1);

  ------------------------------------------------------------------------------------------
  -- Insert de la Solucion - TFI
  ------------------------------------------------------------------------------------------
  insert into sales.soluciones
    (idsolucion, solucion, estado, tipsrv, flg_sol_sisact, flg_sisact_sga)
  values
    ((select max(s.idsolucion) + 1 from sales.soluciones s),
     'Telefonia Fija Inalambrica',
     1,
     l_tipsrv_tfi,
     0,
     3)
  returning idsolucion into l_idsolucion_tfi;
  commit;

  ------------------------------------------------------------------------------------------
  -- Insert del Paquete de Venta - TFI
  ------------------------------------------------------------------------------------------
  insert into sales.paquete_venta
    (idsolucion, estado, observacion, flg_paq_sisact, flag_vig_indet)
  values
    (l_idsolucion_tfi, 1, 'Telefonia Fija Inalambrica', 0, '0')
  returning idpaq into l_idpaq_tfi;
  commit;

  ------------------------------------------------------------------------------------------
  -- Insert del Detalle de paquete de Venta - TFI
  ------------------------------------------------------------------------------------------
  insert into sales.detalle_paquete
    (idpaq,
     paquete,
     idproducto,
     flgprincipal,
     flg_opcional,
     flg_ti,
     flg_te,
     flgestado,
     flg_cambio_plan,
     flg_det_paq_sisact)
  values
    (l_idpaq_tfi, 1, l_idproducto_tfi, 1, 0, 0, 0, 1, 0, 0);

  ------------------------------------------------------------------------------------------
  -- Insert de la Campaña - TFI
  ------------------------------------------------------------------------------------------
  insert into sales.campanha
    (idcampanha, descripcion, estado)
  values
    ((select max(c.idcampanha) + 1 from sales.campanha c),
     'Telefonia Fija Inalambrica',
     1)
  returning idcampanha into l_idcampanha_tfi;
  commit;

  ------------------------------------------------------------------------------------------
  -- Insert de la Solucion por Campaña - TFI
  ------------------------------------------------------------------------------------------
  insert into solucionxcampanha
    (idsolucion, idcampanha, flgdefecto)
  values
    (l_idsolucion_tfi, l_idcampanha_tfi, 1);

  ------------------------------------------------------------------------------------------
  -- Insert de Configuracion del Cusbra - TFI
  ------------------------------------------------------------------------------------------
  insert into cusbra.br_sel_wf
    (tiptra, wfdef, tipsrv, flg_select)
  values
    (l_tiptra_tfi, l_wfdef_tfi, l_tipsrv_tfi, 0);

  ------------------------------------------------------------------------------------------
  -- Insert de Configuracion del CRMDD - TFI
  ------------------------------------------------------------------------------------------
  insert into sales.crmdd
    (codigoc, descripcion, abreviacion, tipcrmdd)
  values
    (l_tipsrv_tfi,
     'Telefonia Fija Inalambrica',
     'tfi',
     (select t.tipcrmdd
        from sales.tipcrmdd t
       where t.abrev = 'OC-CON-AUTOMATICA'));

  insert into sales.crmdd
    (codigoc, descripcion, tipcrmdd)
  values
    (l_tipsrv_tfi,
     'Telefonia Fija Inalambrica',
     (select t.tipcrmdd
        from sales.tipcrmdd t
       where t.abrev = 'PRODUCTOS_BSCS_SISACT'));

  ------------------------------------------------------------------------------------------
  -- Insert de Configuracion del OPEDD - TFI
  ------------------------------------------------------------------------------------------
  insert into operacion.opedd
    (codigon, descripcion, tipopedd)
  values
    (l_wfdef_tfi,
     'telefonia fija inalambrica',
     (select t.tipopedd from operacion.tipopedd t where t.tipopedd = 260));

  ------------------------------------------------------------------------------------------
  -- Insert de Configuracion del Det Validacion - TFI
  ------------------------------------------------------------------------------------------
  update sales.detvalidacion t
     set t.valor =
         (select t.valor || ',' || l_idcampanha_tfi
            from sales.detvalidacion t
           where t.idvalidacion = 10)
   where t.idvalidacion = 10;

  update sales.detvalidacion t
     set t.valor =
         (select t.valor || ',' || l_tipsrv_tfi
            from sales.detvalidacion t
           where t.idvalidacion = 11)
   where t.idvalidacion = 11;

  ------------------------------------------------------------------------------------------
  -- Insercion de las tareas en TAREAWFDEF para HFC
  ------------------------------------------------------------------------------------------    
  -- 1147 - INSTALACION HFC SISACT
  -- Pre-Seleccion
  ------------------------------------------------------------------------------------------
  insert into opewf.tareawfdef
    (tarea, descripcion, tipo, area, wfdef, tareadef, estado, plazo)
  values
    (f_get_id_tareawfdef(),
     'Pre-Seleccion',
     0,
     200, -- Preguntar que Area va Ir
     l_wfdef_1147,
     l_tareadef_pre_sel,
     1,
     1);

  ------------------------------------------------------------------------------------------    
  -- Actualizar el Pos tarea - Pre-Seleccion
  ------------------------------------------------------------------------------------------    
  select tw.pos_tareas, tw.tarea
    into l_pos_tareas, l_tarea
    from opewf.tareawfdef tw
   where wfdef = l_wfdef_1147
     and trim(tw.descripcion) = 'Activación/Desactivación del servicio';

  if l_pos_tareas is null or l_pos_tareas = '' then
    l_pos_tareas := l_pos_tareas;
  else
    l_pos_tareas := l_pos_tareas || ';';
  end if;

  update opewf.tareawfdef tw
     set tw.pos_tareas = l_pos_tareas ||
                         trim(to_char((select tarea
                                        from opewf.tareawfdef
                                       where wfdef = l_wfdef_1147
                                         and tareadef = l_tareadef_pre_sel),
                                      '999999'))
   where tw.wfdef = l_wfdef_1147
     and trim(tw.descripcion) = 'Activación/Desactivación del servicio';   

  update opewf.tareawfdef tw
     set tw.pre_tareas = l_tarea
   where tw.wfdef = l_wfdef_1147
     and exists
   (select 1
            from opewf.tareadef td
           where td.tareadef = tw.tareadef
             and trim(descripcion) = 'Pre-Seleccion');

  ------------------------------------------------------------------------------------------
  -- Pre-Selección Inversa
  ------------------------------------------------------------------------------------------
  insert into opewf.tareawfdef
    (tarea, descripcion, tipo, area, wfdef, tareadef, estado, plazo)
  values
    (f_get_id_tareawfdef(),
     'Pre-Selección Inversa',
     0,
     200, -- Preguntar que Area va Ir
     l_wfdef_1147,
     l_tareadef_pre_sel_inv,
     1,
     1);

  ------------------------------------------------------------------------------------------    
  -- Actualizar el Pos tarea - Pre-Selección Inversa
  ------------------------------------------------------------------------------------------
  select tw.pos_tareas, tw.tarea
    into l_pos_tareas, l_tarea
    from opewf.tareawfdef tw
   where wfdef = l_wfdef_1147
     and trim(tw.descripcion) = 'Validación del ciclo de facturación';             

  if l_pos_tareas is null or l_pos_tareas = '' then
    l_pos_tareas := l_pos_tareas;
  else
    l_pos_tareas := l_pos_tareas || ';';
  end if;

  update opewf.tareawfdef tw
     set tw.pos_tareas = l_pos_tareas ||
                         trim(to_char((select tarea
                                        from opewf.tareawfdef
                                       where wfdef = l_wfdef_1147
                                         and tareadef = l_tareadef_pre_sel_inv),
                                      '999999'))
   where tw.wfdef = l_wfdef_1147
     and trim(tw.descripcion) = 'Validación del ciclo de facturación';     

  update opewf.tareawfdef tw
     set tw.pre_tareas = l_tarea
   where tw.wfdef = l_wfdef_1147
     and exists
   (select 1
            from opewf.tareadef td
           where td.tareadef = tw.tareadef
             and trim(descripcion) = 'Pre-Selección Inversa');
             
  ------------------------------------------------------------------------------------------    
  -- 1195 - HFC - PORTABILIDAD INSTALACIONES 
  -- Pre-Seleccion 
  ------------------------------------------------------------------------------------------    
  insert into opewf.tareawfdef
    (tarea, descripcion, tipo, area, wfdef, tareadef, estado, plazo)
  values
    (f_get_id_tareawfdef(),
     'Pre-Seleccion',
     0,
     330, -- Preguntar que Area va Ir
     l_wfdef_1195,
     l_tareadef_pre_sel,
     1,
     1);

  ------------------------------------------------------------------------------------------    
  -- Actualizar el Pos tarea - Pre-Seleccion
  ------------------------------------------------------------------------------------------ 
  select tw.pos_tareas, tw.tarea
    into l_pos_tareas, l_tarea
    from opewf.tareawfdef tw
   where wfdef = l_wfdef_1195
     and trim(tw.descripcion) = 'Activación/Desactivación del servicio';

  if l_pos_tareas is null or l_pos_tareas = '' then
    l_pos_tareas := l_pos_tareas;
  else
    l_pos_tareas := l_pos_tareas || ';';
  end if;

  update opewf.tareawfdef tw
     set tw.pos_tareas = l_pos_tareas ||
                         trim(to_char((select tarea
                                        from opewf.tareawfdef
                                       where wfdef = l_wfdef_1195
                                         and tareadef = l_tareadef_pre_sel),
                                      '999999'))
   where tw.wfdef = l_wfdef_1195
     and trim(tw.descripcion) = 'Activación/Desactivación del servicio';   

  update opewf.tareawfdef tw
     set tw.pre_tareas = l_tarea
   where tw.wfdef = l_wfdef_1195
     and exists
   (select 1
            from opewf.tareadef td
           where td.tareadef = tw.tareadef
             and trim(descripcion) = 'Pre-Seleccion');

  ------------------------------------------------------------------------------------------
  -- Pre-Selección Inversa
  ------------------------------------------------------------------------------------------             
  insert into opewf.tareawfdef
    (tarea, descripcion, tipo, area, wfdef, tareadef, estado, plazo)
  values
    (f_get_id_tareawfdef(),
     'Pre-Selección Inversa',
     0,
     330, -- Preguntar que Area va Ir
     l_wfdef_1195,
     l_tareadef_pre_sel_inv,
     1,
     1);

  ------------------------------------------------------------------------------------------    
  -- Actualizar el Pos tarea - Pre Seleccion Inversa
  ------------------------------------------------------------------------------------------ 
  select tw.pos_tareas, tw.tarea
    into l_pos_tareas, l_tarea
    from opewf.tareawfdef tw
   where wfdef = l_wfdef_1195
     and trim(tw.descripcion) = 'Validación del ciclo de facturación';             

  if l_pos_tareas is null or l_pos_tareas = '' then
    l_pos_tareas := l_pos_tareas;
  else
    l_pos_tareas := l_pos_tareas || ';';
  end if;

  update opewf.tareawfdef tw
     set tw.pos_tareas = l_pos_tareas ||
                         trim(to_char((select tarea
                                        from opewf.tareawfdef
                                       where wfdef = l_wfdef_1195
                                         and tareadef = l_tareadef_pre_sel_inv),
                                      '999999'))
   where tw.wfdef = l_wfdef_1195
     and trim(tw.descripcion) = 'Validación del ciclo de facturación';     
            
  update opewf.tareawfdef tw
     set tw.pre_tareas = l_tarea
   where tw.wfdef = l_wfdef_1195
     and exists
   (select 1
            from opewf.tareadef td
           where td.tareadef = tw.tareadef
             and trim(descripcion) = 'Pre-Selección Inversa');             
  ------------------------------------------------------------------------------------------
  -- Insercion de las tareas en TAREAWFDEF para LTE
  ------------------------------------------------------------------------------------------  
  -- 1237 - INSTALACION 3 PLAY INALAMBRICO
  -- Pre-Seleccion
  ------------------------------------------------------------------------------------------
    insert into opewf.tareawfdef
        (tarea, descripcion, tipo, area, wfdef, tareadef, estado, plazo)
      values
        (f_get_id_tareawfdef(),
         'Pre-Seleccion',
         0,
         325, -- Preguntar que Area va Ir
         l_wfdef_1237,
         l_tareadef_pre_sel,
         1, 
         1);       
  
  ------------------------------------------------------------------------------------------    
  -- Actualizar el Pos tarea - Pre-Seleccion
  ------------------------------------------------------------------------------------------ 
     select tw.pos_tareas, tw.tarea
      into l_pos_tareas, l_tarea
        from opewf.tareawfdef tw
       where wfdef = l_wfdef_1237
         and trim(tw.descripcion) = 'Activacion de Servicios Inalambricos';
       
      if l_pos_tareas is null or l_pos_tareas = '' then
        l_pos_tareas := l_pos_tareas;
      else
        l_pos_tareas := l_pos_tareas || ';';
      end if;
        
      update opewf.tareawfdef tw
         set tw.pos_tareas = l_pos_tareas ||
                             trim(to_char((select tarea
                                            from opewf.tareawfdef
                                           where wfdef = l_wfdef_1237
                                             and tareadef = l_tareadef_pre_sel),
                                          '999999'))
       where tw.wfdef = l_wfdef_1237
         and trim(tw.descripcion) = 'Activacion de Servicios Inalambricos';       


  update opewf.tareawfdef tw
     set tw.pre_tareas = l_tarea
   where tw.wfdef = l_wfdef_1237
     and exists
   (select 1
            from opewf.tareadef td
           where td.tareadef = tw.tareadef
             and trim(descripcion) = 'Pre-Seleccion');
  
  ------------------------------------------------------------------------------------------
  -- Insert Pre-Selección Inversa
  ------------------------------------------------------------------------------------------  
      insert into opewf.tareawfdef
        (tarea, descripcion, tipo, area, wfdef, tareadef, estado, plazo)
      values
        (f_get_id_tareawfdef(),
         'Pre-Selección Inversa',
         0,
         325, -- Preguntar que Area va Ir
         l_wfdef_1237,
         l_tareadef_pre_sel_inv,
         1,
         1);   
  
  ------------------------------------------------------------------------------------------    
  -- Actualizar el Pos tarea - Pre Seleccion Inversa
  ------------------------------------------------------------------------------------------   
      select tw.pos_tareas, tw.tarea
        into l_pos_tareas, l_tarea
        from opewf.tareawfdef tw
       where wfdef = l_wfdef_1237
         and trim(tw.descripcion) = 'Gestion documentacion Inalambrico';

        
      if l_pos_tareas is null or l_pos_tareas = '' then
        l_pos_tareas := l_pos_tareas;
      else
        l_pos_tareas := l_pos_tareas || ';';
      end if;
        
      update opewf.tareawfdef tw
         set tw.pos_tareas = l_pos_tareas ||
                             trim(to_char((select tarea
                                            from opewf.tareawfdef
                                           where wfdef = l_wfdef_1237
                                             and tareadef = l_tareadef_pre_sel_inv),
                                          '999999'))
       where tw.wfdef = l_wfdef_1237
         and trim(tw.descripcion) = 'Gestion documentacion Inalambrico';       
             
  update opewf.tareawfdef tw
     set tw.pre_tareas = l_tarea
   where tw.wfdef = l_wfdef_1237
     and exists
   (select 1
            from opewf.tareadef td
           where td.tareadef = tw.tareadef
             and trim(descripcion) = 'Pre-Selección Inversa');  
  ------------------------------------------------------------------------------------------
  -- Insercion de las tareas en TAREAWFDEF para TFI
  -- Pre Seleccion
  ------------------------------------------------------------------------------------------
  insert into opewf.tareawfdef
    (tarea, descripcion, tipo, area, wfdef, tareadef, estado, plazo)
  values
    (f_get_id_tareawfdef(),
     'Pre-Seleccion',
     0,
     200, -- Preguntar que Area va Ir
     l_wfdef_tfi,
     l_tareadef_pre_sel,
     1,
     1);

  ------------------------------------------------------------------------------------------
  -- Pre-Selección Inversa
  ------------------------------------------------------------------------------------------
  insert into opewf.tareawfdef
    (tarea, descripcion, tipo, area, wfdef, tareadef, estado, plazo)
  values
    (f_get_id_tareawfdef(),
     'Pre-Selección Inversa',
     0,
     200, -- Preguntar que Area va Ir
     l_wfdef_tfi,
     l_tareadef_pre_sel_inv,
     1,
     1);

  ------------------------------------------------------------------------------------------
  -- Insercion de Tipo y Estado
  ------------------------------------------------------------------------------------------  
  insert into tipopedd
    (descripcion, abrev)
  values
    ('Datos Pre Seleccion', 'pre_seleccion')
  returning tipopedd into l_tipopedd;

  ------------------------------------------------------------------------------------------
  -- Tareas
  ------------------------------------------------------------------------------------------  
  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null, l_tareadef_pre_sel, 'Pre-Seleccion', 'tareas', l_tipopedd);

  -- Tarea Pre-Selección Inversa
  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null,
     l_tareadef_pre_sel_inv,
     'Pre-Selección Inversa',
     'tareas',
     l_tipopedd);

  ------------------------------------------------------------------------------------------
  -- WF Asignados
  ------------------------------------------------------------------------------------------
  -- 1147 - INSTALACION HFC SISACT  
  ------------------------------------------------------------------------------------------
  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null, l_wfdef_1147, 'Wf Asignados', 'wf_asignados', l_tipopedd);
  ------------------------------------------------------------------------------------------
  -- 1195 - HFC - PORTABILIDAD INSTALACIONES 
  ------------------------------------------------------------------------------------------  
  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null, l_wfdef_1195, 'Wf Asignados', 'wf_asignados', l_tipopedd);
  ------------------------------------------------------------------------------------------
  -- LTE
  -- 1237 - INSTALACION 3 PLAY INALAMBRICO
  ------------------------------------------------------------------------------------------  
  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null, l_wfdef_1237, 'Wf Asignados', 'wf_asignados', l_tipopedd);
  ------------------------------------------------------------------------------------------
  -- TFI
  ------------------------------------------------------------------------------------------  
  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null, l_wfdef_tfi, 'Wf Asignados', 'wf_asignados', l_tipopedd);

  ------------------------------------------------------------------------------------------
  -- Operadores
  ------------------------------------------------------------------------------------------
  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null, 4, 'Claro', 'operadores', l_tipopedd);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null, 88, 'Llamada por Llamada', 'operadores', l_tipopedd);

  ------------------------------------------------------------------------------------------
  -- Tipo de Trabajo: HFC / LTE / TFI
  ------------------------------------------------------------------------------------------
  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null,
     658,
     'HFC - SISACT INSTALACION PAQUETES TODO CLARO DIGITAL',
     'tiptrab_alta_fija_hfc_lte_tfi',
     l_tipopedd);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null,
     676,
     'HFC - PORTABILIDAD INSTALACIONES PAQUETES CLARO',
     'tiptrab_alta_fija_hfc_lte_tfi',
     l_tipopedd);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null,
     678,
     'HFC/SISACT - MIGRACION SISACT',
     'tiptrab_alta_fija_hfc_lte_tfi',
     l_tipopedd);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null,
     679,
     'HFC - PORTA + CAMBIO DE PLAN SISACT',
     'tiptrab_alta_fija_hfc_lte_tfi',
     l_tipopedd);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null,
     744,
     'INSTALACION 3 PLAY INALAMBRICO1',
     'tiptrab_alta_fija_hfc_lte_tfi',
     l_tipopedd);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null,
     850,
     'HFC/SIAC MIGRACION SGA BSCS VISITA',
     'tiptrab_alta_fija_hfc_lte_tfi',
     l_tipopedd);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null,
     851,
     'HFC/SIAC MIGRACION SGA BSCS SISTEMA',
     'tiptrab_alta_fija_hfc_lte_tfi',
     l_tipopedd);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null,
     l_tiptra_tfi,
     'INSTALACION PAQUETE SISACT - TFI',
     'tiptrab_alta_fija_hfc_lte_tfi',
     l_tipopedd);

  ------------------------------------------------------------------------------------------
  -- Servicios
  ------------------------------------------------------------------------------------------
  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null, 3, 'Numero Telefonico', 'servicios', l_tipopedd);

  ------------------------------------------------------------------------------------------
  -- Estados para cierre de Tarea
  ------------------------------------------------------------------------------------------
  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null, 4, 'Cerrada', 'estado_tarea_cierre', l_tipopedd);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null, 8, 'No interviene', 'estado_tarea_cierre', l_tipopedd);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null, 14, 'Ejecutado Parcialmente', 'estado_tarea_cierre', l_tipopedd);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null, 20, 'Cerrada sin Permiso', 'estado_tarea_cierre', l_tipopedd);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null, 11, 'No Factible', 'estado_tarea_cierre', l_tipopedd);

  ------------------------------------------------------------------------------------------
  -- Estados para cierre de Tarea de Verificacion
  ------------------------------------------------------------------------------------------
  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null, 1, 'Generada', 'estado_para_cierre_verif', l_tipopedd);

  ------------------------------------------------------------------------------------------
  -- Dias para cierre de Tarea de Verificacion
  ------------------------------------------------------------------------------------------
  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null,
     15,
     'Dias para cerrar la tarea de Pre-Selección Inversa',
     'dias_cierre',
     l_tipopedd);

  ------------------------------------------------------------------------------------------
  -- Tipo Operador para envio BSCS
  ------------------------------------------------------------------------------------------
  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (4, null, 'Claro', 'operador_envio_bscs', l_tipopedd);

  ------------------------------------------------------------------------------------------
  -- Estado Tarea para envio BSCS
  ------------------------------------------------------------------------------------------
  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null, 4, 'Cerrada', 'estado_tarea_envio_bscs', l_tipopedd);

  -- Estado verificacion para envio BSCS
  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null, 2, 'Telefono Aprobado', 'estado_verif_envio_bscs', l_tipopedd);

  ------------------------------------------------------------------------------------------
  -- Estado Verificacion
  ------------------------------------------------------------------------------------------
  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null, 2, 'Telefono Aprobado', 'estado_verificacion', l_tipopedd);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null, 3, 'Telefono Rechazado', 'estado_verificacion', l_tipopedd);

  ------------------------------------------------------------------------------------------
  -- Tipo de Trabajo TFI
  ------------------------------------------------------------------------------------------
  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null,
     l_tiptra_tfi,
     'Instalacion paquete Ssisact - TFI',
     'tiptrab_tfi',
     l_tipopedd);

  ------------------------------------------------------------------------------------------
  -- tipo de Servicio TFI
  ------------------------------------------------------------------------------------------
  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (l_tipsrv_tfi,
     null,
     'Telefonia Fija Inalambrica',
     'tipsrv_tfi',
     l_tipopedd);

  ------------------------------------------------------------------------------------------
  -- Tramas TFI
  ------------------------------------------------------------------------------------------
  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null,
     l_tramaid_venta_tfi,
     'VENTA SISACT - TFI',
     'trama_tfi',
     l_tipopedd);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null,
     l_tramaid_servicio_tfi,
     'SERVICIO SISACT - TFI',
     'trama_tfi',
     l_tipopedd);

  commit;
end;
/




