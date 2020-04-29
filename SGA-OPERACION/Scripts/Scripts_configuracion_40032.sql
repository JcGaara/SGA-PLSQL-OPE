declare

  v_id_parametro operacion.parametro_cab_adc.id_parametro%type;

begin
  insert into operacion.parametro_cab_adc
    (descripcion, abreviatura, estado)
  values
    ('Integracion FullStack', 'integrar_fullstack', 1)
  returning id_parametro into v_id_parametro;

  --RF01 - Consulta Capacidad
  --Activacion de Nuevos Campos
  insert into operacion.parametro_det_adc
    (id_parametro, codigon, descripcion, abreviatura, estado)
  values
    (v_id_parametro,
     0,
     'Activacion de nuevos campos (Zona Compleja/Flag Vip)',
     'activar_campos_consulta_capac',
     1);

  insert into operacion.parametro_det_adc
    (id_parametro, codigon, descripcion, abreviatura, estado)
  values
    (v_id_parametro, 0, 'Activar busqueda flag Vip', 'activar_flag_vip', 1);

  insert into operacion.parametro_det_adc
    (id_parametro, codigon, descripcion, abreviatura, estado)
  values
    (v_id_parametro, 2, 'flag Vip Default', 'flag_vip_default', 1);


  --RF03
  --Servicios
  insert into operacion.parametro_det_adc
    (id_parametro, codigoc, descripcion, abreviatura, estado)
  values
    (v_id_parametro, 'Int-P', 'Internet - Puerto', 'servicios', 1);

  insert into operacion.parametro_det_adc
    (id_parametro, codigoc, descripcion, abreviatura, estado)
  values
    (v_id_parametro, 'Cab-P', 'Cable - Puerto', 'servicios', 1);

  insert into operacion.parametro_det_adc
    (id_parametro, codigoc, descripcion, abreviatura, estado)
  values
    (v_id_parametro, 'Tel-L', 'Telefonia - Puerto', 'servicios', 1);


  --RF04
  --Activacion de Nuevos Campos
  insert into operacion.parametro_det_adc
    (id_parametro, codigon, descripcion, abreviatura, estado)
  values
    (v_id_parametro,
     0,
     'Activacion de nuevos campos (Telefonos de Contacto/Indicador de Orden/Zona Compleja)',
     'activar_campos_creacion_orden',
     1);

  insert into operacion.parametro_det_adc
    (id_parametro, codigon, descripcion, abreviatura, estado)
  values
    (v_id_parametro, 5, 'Cantidad de Contactos', 'cantidad_contactos', 1);

  --Numero Contactos 
  insert into operacion.ope_cab_xml
    (idcab, programa, rfc, metodo, descripcion, xml)
  values
    ((select max(idcab) + 1 from operacion.ope_cab_xml),
     'XAServices_ToInstall_Cont',
     'Administracion de Numeros de Contactos',
     'XAServices_ToInstall_Cont',
     'Administracion de Numeros de Contactos',
     '<![CDATA[
    <XA_Contact_Phones>
      @ServiceToInstall
    </XA_Contact_Phones>
    ]]>');

  insert into operacion.ope_cab_xml
    (idcab, programa, rfc, metodo, descripcion, xml)
  values
    ((select max(idcab) + 1 from operacion.ope_cab_xml),
     'Services_ToInstall_Cont',
     'Administracion de Numeros de Contactos',
     'Services_ToInstall_Cont',
     'Administracion de Numeros de Contactos',
     '<ContactPhones>
        <Telefono>@Telefono</Telefono>
        <Nro>@NroTelefono</Nro>
      </ContactPhones>');

  --Indicador Orden Completa
  insert into operacion.parametro_det_adc
    (id_parametro, codigon, descripcion, abreviatura, estado)
  values
    (v_id_parametro,
     2,
     'Indicador Orden Completa',
     'indicar_orden_completa',
     1);

  -- Telefonos Contacto
  insert into operacion.parametro_det_adc
    (id_parametro, codigoc, codigon, descripcion, abreviatura, estado)
  values
    (v_id_parametro, '003', 1, 'Telefono Celular 1', 'telefonos_contacto', 1);

  insert into operacion.parametro_det_adc
    (id_parametro, codigoc, codigon, descripcion, abreviatura, estado)
  values
    (v_id_parametro, '016', 1, 'Telefono Celular 2', 'telefonos_contacto', 1);

  insert into operacion.parametro_det_adc
    (id_parametro, codigoc, codigon, descripcion, abreviatura, estado)
  values
    (v_id_parametro, '006', 2, 'Telefono Domicilio 1', 'telefonos_contacto', 1);

  insert into operacion.parametro_det_adc
    (id_parametro, codigoc, codigon, descripcion, abreviatura, estado)
  values
    (v_id_parametro, '007', 2, 'Telefono Domicilio 2', 'telefonos_contacto', 1);

  insert into operacion.parametro_det_adc
    (id_parametro, codigoc, codigon, descripcion, abreviatura, estado)
  values
    (v_id_parametro, '022', 2, 'Telefono Domicilio 3', 'telefonos_contacto', 1);

  insert into operacion.parametro_det_adc
    (id_parametro, codigoc, codigon, descripcion, abreviatura, estado)
  values
    (v_id_parametro, '023', 2, 'Telefono Domicilio 4', 'telefonos_contacto', 1);

  commit;

end;
/
