declare
  cursor tarea_pre_seleccion is
    select t.tarea,
           t.wfdef,
           (select t1.descripcion
              from opewf.tareawfdef t1
             where trim(t1.descripcion) in
                   ('Activación/Desactivación del servicio',
                    'Activacion de Servicios Inalambricos')
               and t.wfdef = t1.wfdef) descrip_tarea_hfc_lte
      from opewf.tareawfdef t
     where trim(t.descripcion) = 'Pre-Seleccion';

  cursor tarea_pre_seleccion_inv is
    select t.tarea,
           t.wfdef,
           (select t1.descripcion
              from opewf.tareawfdef t1
             where trim(t1.descripcion) in
                   ('Validación del ciclo de facturación',
                    'Gestion documentacion Inalambrico')
               and t.wfdef = t1.wfdef) descrip_tarea_hfc_lte
      from opewf.tareawfdef t
     where trim(t.descripcion) = 'Pre-Selección Inversa';

  cursor campanas is
    select t.idcampanha
      from sales.campanha t
     where trim(t.descripcion) = 'Telefonia Fija Inalambrica';

  cursor tipo_servicios is
    select t.tipsrv
      from sales.tystipsrv t
     where trim(t.dsctipsrv) = 'Telefonia Fija Inalambrica';
begin
  
  ------------------------------------------------------------------------------------------
  --                        Eliminamos los datos registrados en las Tablas  - PROY-28061
  ------------------------------------------------------------------------------------------
  -- Det Validacion  
  ------------------------------------------------------------------------------------------  
  for campana in campanas loop
    update Sales.detvalidacion t
       set t.valor = substr(t.valor, 1, INSTR(t.valor, campana.idcampanha) - 2)
     where t.idvalidacion = 10;
  end loop;

  for tipo_servicio in tipo_servicios loop  
    update Sales.detvalidacion t
       set t.valor = substr(t.valor, 1, INSTR(t.valor, tipo_servicio.tipsrv) - 2)
     where t.idvalidacion = 11;
  end loop;
  
  ------------------------------------------------------------------------------------------
  -- CRMDD
  ------------------------------------------------------------------------------------------  
  delete from crmdd t
   where t.tipcrmdd = (select t.tipcrmdd
                         from sales.tipcrmdd t
                        where t.abrev = 'OC-CON-AUTOMATICA')
     and t.codigoc in
         (select t.tipsrv
            from sales.tystipsrv t
           where trim(t.dsctipsrv) = 'Telefonia Fija Inalambrica');

  delete from crmdd t
   where t.tipcrmdd = (select t.tipcrmdd
                         from sales.tipcrmdd t
                        where t.abrev = 'PRODUCTOS_BSCS_SISACT')
     and t.codigoc in
         (select t.tipsrv
            from sales.tystipsrv t
           where trim(t.dsctipsrv) = 'Telefonia Fija Inalambrica');

  ------------------------------------------------------------------------------------------
  -- Br_Sel_WF
  ------------------------------------------------------------------------------------------
  delete from CUSBRA.BR_SEL_WF t
   where t.tiptra in
         (select t.tiptra
            from operacion.tiptrabajo t
           where trim(t.descripcion) = 'Instalacion paquete Sisact - TFI')
     and t.tipsrv in
         (select t.tipsrv
            from sales.tystipsrv t
           where trim(t.dsctipsrv) = 'Telefonia Fija Inalambrica');

  ------------------------------------------------------------------------------------------
  -- Solucion x Campaña
  ------------------------------------------------------------------------------------------
  delete from sales.solucionxcampanha t
   where t.idsolucion in
         (select t.idsolucion
            from sales.soluciones t
           where trim(t.solucion) = 'Telefonia Fija Inalambrica')
     and t.idcampanha in
         (select t.idcampanha
            from sales.campanha t
           where trim(t.descripcion) = 'Telefonia Fija Inalambrica');

  ------------------------------------------------------------------------------------------
  -- Campaña
  ------------------------------------------------------------------------------------------
  delete from sales.campanha t
   where trim(t.descripcion) = 'Telefonia Fija Inalambrica';

  ------------------------------------------------------------------------------------------
  -- Detalle Paquete
  ------------------------------------------------------------------------------------------
  delete from sales.detalle_paquete t
   where t.idpaq in
         (select t.idpaq
            from sales.paquete_venta t
           where trim(t.observacion) = 'Telefonia Fija Inalambrica')
     and t.idproducto in
         (select t.idproducto
            from billcolper.producto t
           where trim(t.descripcion) = 'SISACT - TFI');

  ------------------------------------------------------------------------------------------     
  -- Paquete Venta
  ------------------------------------------------------------------------------------------
  delete from sales.paquete_venta t
   where t.idsolucion in
         (select t.idsolucion
            from sales.soluciones t
           where trim(t.solucion) = 'Telefonia Fija Inalambrica');

  ------------------------------------------------------------------------------------------          
  --Soluciones
  ------------------------------------------------------------------------------------------     
  delete from sales.soluciones t
   where trim(t.solucion) = 'Telefonia Fija Inalambrica';

  ------------------------------------------------------------------------------------------          
  --Grupo Sisact
  ------------------------------------------------------------------------------------------          
  delete from sales.grupo_sisact t
   where t.idgrupo_sisact = '020'
     and t.idproducto in
         (select t.idproducto
            from billcolper.producto t
           where trim(t.descripcion) = 'SISACT - TFI');

  ------------------------------------------------------------------------------------------          
  --Nivel Producto
  ------------------------------------------------------------------------------------------          
  delete from sales.nivel_producto t
   where t.idprod_orig in
         (select t.idproducto
            from billcolper.producto t
           where trim(t.descripcion) = 'SISACT - TFI');

  ------------------------------------------------------------------------------------------          
  --productoxgrupociclo
  ------------------------------------------------------------------------------------------          
  delete from billcolper.productoxgrupociclo t
   where t.idproducto in
         (select t.idproducto
            from billcolper.producto t
           where trim(t.descripcion) = 'SISACT - TFI');

  ------------------------------------------------------------------------------------------          
  --Producto
  ------------------------------------------------------------------------------------------          
  delete from billcolper.producto t where trim(t.descripcion) = 'SISACT - TFI';

  ------------------------------------------------------------------------------------------            
  --TysTipSrv
  ------------------------------------------------------------------------------------------          
  delete from sales.tystipsrv t
   where trim(t.dsctipsrv) = 'Telefonia Fija Inalambrica';

  ------------------------------------------------------------------------------------------            
  -- TipTrabajo
  ------------------------------------------------------------------------------------------            
  delete from operacion.tiptrabajo t
   where trim(t.descripcion) = 'Instalacion paquete Sisact - TFI';

  ------------------------------------------------------------------------------------------            
  -- Trama Detalle Venta
  ------------------------------------------------------------------------------------------            
  delete from sales.trama_det t
   where t.tramaid in
         (select t.tramaid
            from sales.trama t
           where trim(t.description) = 'VENTA SISACT - TFI');

  ------------------------------------------------------------------------------------------            
  -- Trama Detalle Servicio
  ------------------------------------------------------------------------------------------            
  delete from sales.trama_det t
   where t.tramaid in
         (select t.tramaid
            from sales.trama t
           where trim(t.description) = 'SERVICIO SISACT - TFI');

  ------------------------------------------------------------------------------------------              
  -- Trama Servicio
  ------------------------------------------------------------------------------------------            
  delete from sales.trama t
   where trim(t.description) = 'SERVICIO SISACT - TFI';

  ------------------------------------------------------------------------------------------              
  -- Trama Venta
  ------------------------------------------------------------------------------------------            
  delete from sales.trama t where trim(t.description) = 'VENTA SISACT - TFI';

  ------------------------------------------------------------------------------------------  
  --Actualizar los campos Pos Tareas
  -- HFC / LTE - Pre-Seleccion
  ------------------------------------------------------------------------------------------
  for pre_seleccion in tarea_pre_seleccion loop
    update opewf.tareawfdef tw
       set tw.pos_tareas = substr(tw.pos_tareas,
                                  1,
                                  INSTR(tw.pos_tareas, pre_seleccion.tarea) - 2)
     where tw.wfdef = pre_seleccion.wfdef
       and trim(tw.descripcion) = pre_seleccion.descrip_tarea_hfc_lte;
  
  end loop;

  -- Pre-Seleccion Inversa
  for pre_seleccion_inv in tarea_pre_seleccion_inv loop
    update opewf.tareawfdef tw
       set tw.pos_tareas = substr(tw.pos_tareas,
                                  1,
                                  INSTR(tw.pos_tareas, pre_seleccion_inv.tarea) - 2)
     where tw.wfdef = pre_seleccion_inv.wfdef
       and trim(tw.descripcion) = pre_seleccion_inv.descrip_tarea_hfc_lte;
  
  end loop;

  ------------------------------------------------------------------------------------------
  -- TareaWfDef
  ------------------------------------------------------------------------------------------
  delete from opewf.tareawfdef t
   where t.tareadef in
         (select t.tareadef
            from opewf.tareadef t
           where trim(t.descripcion) = 'Pre-Seleccion');

  delete from opewf.tareawfdef t
   where t.tareadef in
         (select t.tareadef
            from opewf.tareadef t
           where trim(t.descripcion) = 'Pre-Selección Inversa');

  ------------------------------------------------------------------------------------------
  -- TareaDef
  ------------------------------------------------------------------------------------------
  delete from opewf.tareadef t where trim(t.descripcion) = 'Pre-Seleccion';

  delete from opewf.tareadef t
   where trim(t.descripcion) = 'Pre-Selección Inversa';

  ------------------------------------------------------------------------------------------
  -- Opedd
  ------------------------------------------------------------------------------------------
  delete from opedd t
   where t.tipopedd =
         (select t.tipopedd from tipopedd t where t.tipopedd = 260)
     and t.codigon in
         (select t.wfdef
            from opewf.wfdef t
           where trim(t.descripcion) = 'INSTALACION INALAMBRICO - TFI');

  delete from opedd t
   where t.tipopedd in
         (select t.tipopedd from tipopedd t where t.abrev = 'pre_seleccion');

  ------------------------------------------------------------------------------------------
  -- Tipopedd - Pre Seleccion
  ------------------------------------------------------------------------------------------
  delete from tipopedd t where t.abrev = 'pre_seleccion';

  ------------------------------------------------------------------------------------------
  -- WfDef
  ------------------------------------------------------------------------------------------
  delete from opewf.wfdef t
   where trim(t.descripcion) = 'INSTALACION INALAMBRICO - TFI';

  commit;
end;
/

------------------------------------------------------------------------------------------
-- Eliminar los Package y Package Body
------------------------------------------------------------------------------------------
drop package body sales.pkg_trama_tfi;
drop package sales.pkg_trama_tfi;
drop package body sales.pkg_int_sisact_sga_tfi;
drop package sales.pkg_int_sisact_sga_tfi;
drop package body sales.pkg_int_sisact_sga_tfi_setter;
drop package sales.pkg_int_sisact_sga_tfi_setter;
drop package body sales.pkg_cliente_sisact_tfi;
drop package sales.pkg_cliente_sisact_tfi;
drop package body sales.pkg_int_sisact_sga_tfi_utl;
drop package sales.pkg_int_sisact_sga_tfi_utl;
drop package body sales.pkg_servicio_sisact_tfi;
drop package sales.pkg_servicio_sisact_tfi;
drop package body sales.pkg_int_sisact_sga_tfi_log;
drop package sales.pkg_int_sisact_sga_tfi_log;
drop package body sales.pkg_preseleccion;
drop package sales.pkg_preseleccion;
