declare
  l_tipopedd tipopedd.tipopedd%type;

begin
  --ETAdirect - Cabecera
  insert into tipopedd
    (DESCRIPCION, ABREV)
  values
    ('plataforma etadirect', 'etadirect')
  returning tipopedd into l_tipopedd;

  --ETAdirect - Detalle 
  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('09:00 - 11:00', null, 'Franja Horaria', 'AM1', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('11:01 - 13:00', null, 'Franja Horaria', 'AM2', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('14:01 - 16:00', null, 'Franja Horaria', 'PM1', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('16:01 - 18:00', null, 'Franja Horaria', 'PM2', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('18:01 - 20:00', null, 'Franja Horaria', 'PM3', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('f_obtiene_by_work_zone', null, 'Funcion', 'by_work_zone', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('f_obtiene_calculate_travel',
     null,
     'Funcion',
     'calculate_travel',
     l_tipopedd,
     1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('f_obtiene_calcule_work_skill',
     null,
     'Funcion',
     'calcule_work_skill',
     l_tipopedd,
     1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('ws', null, 'ws', 'conexion', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('mock', null, 'objeto simulado', 'conexion', l_tipopedd, 0);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('HFCI', null, 'Constante SGA ', 'constante', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('HFCM',
     null,
     'Subtipo de orden - Post Venta',
     'constante_subtipo_orden',
     l_tipopedd,
     1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('10', null, 'Dias a consultar', 'dias', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('50', null, 'Disponibilidad minima', 'disponibilidad', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('operacion',
     null,
     'Esquema operacion',
     'esquema_operacion',
     l_tipopedd,
     1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('operacion', null, 'funcion original', 'flujo', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('mock', null, 'objeto simulado', 'flujo', l_tipopedd, 0);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('L12025V', null, 'Plano', 'idplano', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null,
     771,
     'Producto - Inst. Deco Adicional Post Instalación',
     'idproducto_deco',
     l_tipopedd,
     1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('1', null, 'Aplica Flujo ETA', 'indicador', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 69, 'Servicio a agendar', 'masivo_analogico', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 66, 'Servicio a agendar', 'masivo_analogico', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 65, 'Servicio a agendar', 'masivo_analogico', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 55, 'Servicio a agendar', 'masivo_analogico', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 51, 'Servicio a agendar', 'masivo_analogico', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 135, 'Servicio a agendar', 'masivo_analogico', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 78, 'Servicio a agendar', 'masivo_analogico', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 134, 'Servicio a agendar', 'masivo_analogico', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 52, 'Servicio a agendar', 'masivo_analogico', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 68, 'Servicio a agendar', 'masivo_analogico', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('0', null, 'No hay capacidad disponible', 'mensaje_error', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('-2',
     null,
     'Por el momento no es posible obtener fechas',
     'mensaje_error',
     l_tipopedd,
     1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('1',
     null,
     'Por el momento no es posible obtener fechas',
     'mensaje_error',
     l_tipopedd,
     1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null,
     null,
     'Por el momento no es posible obtener fechas',
     'mensaje_error',
     l_tipopedd,
     1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('2',
     null,
     'Por el momento no es posible obtener fechas',
     'mensaje_error',
     l_tipopedd,
     1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null,
     null,
     'Agendamiento realizado con éxito',
     'mensaje_exito',
     l_tipopedd,
     1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null,
     0,
     'La fecha x esta fuera del rango solicitado',
     'mensaje_fecha_vta',
     l_tipopedd,
     1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null,
     1,
     'No existe capacidad para la fecha solicitada',
     'mensaje_fecha_vta',
     l_tipopedd,
     1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null,
     2,
     'Para el día de hoy x no se podrá realizar el agendamiento, por favor elegir una fecha entre el rango',
     'mensaje_fecha_vta',
     l_tipopedd,
     1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null,
     0,
     'La fecha x esta fuera del rango configurado',
     'mensaje_fecha_pvta',
     l_tipopedd,
     1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null,
     1,
     'No existe capacidad para la fecha solicitada',
     'mensaje_fecha_pvta',
     l_tipopedd,
     1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null,
     2,
     'La Fecha de Aplicación no puede ser menor o igual a la Fecha Actual',
     'mensaje_fecha_pvta',
     l_tipopedd,
     1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, -5, 'Tipo de servicios es nulo', 'mensaje_flujo', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, -4, 'Tipo de trabajo es nulo', 'mensaje_flujo', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null,
     -3,
     'Los valores de plano y ubigeo son nulos',
     'mensaje_flujo',
     l_tipopedd,
     1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, -2, 'No existe ubigeo', 'mensaje_flujo', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, -1, 'No existe plano', 'mensaje_flujo', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 0, 'No aplica Flujo ETA ', 'mensaje_flujo', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null,
     null,
     'El tiempo de agendamiento expiró favor volver a consultar',
     'mensaje_time_out',
     l_tipopedd,
     1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('604', 432, 'Motivo de Tipo de Trabajo', 'motivo', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('188', 5, 'Motivo de Tipo de Trabajo', 'motivo', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('13', 5, 'Motivo de Tipo de Trabajo', 'motivo', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('188', 448, 'Motivo de Tipo de Trabajo', 'motivo', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('188', 408, 'Motivo de Tipo de Trabajo', 'motivo', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('13', 448, 'Motivo de Tipo de Trabajo', 'motivo', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('12', 432, 'Motivo de Tipo de Trabajo', 'motivo', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('601', 432, 'Motivo de Tipo de Trabajo', 'motivo', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('603', 432, 'Motivo de Tipo de Trabajo', 'motivo', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('989', 432, 'Motivo de Tipo de Trabajo', 'motivo', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('20', 432, 'Motivo de Tipo de Trabajo', 'motivo', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('188', 432, 'Motivo de Tipo de Trabajo', 'motivo', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('864', 432, 'Motivo de Tipo de Trabajo', 'motivo', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('861', 432, 'Motivo de Tipo de Trabajo', 'motivo', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('855', 432, 'Motivo de Tipo de Trabajo', 'motivo', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('845', 432, 'Motivo de Tipo de Trabajo', 'motivo', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('5',
     null,
     'Cantidad de franjas horarias',
     'numero_franjas',
     l_tipopedd,
     1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('O', null, 'Opcion de Operaciones', 'opcion_operacion', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('P', null, 'Opcion de Postventa', 'opcion_postventa', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('V', null, 'Opcion de Venta', 'opcion_venta', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('pq_adm_cuadrilla',
     null,
     'Paquete pq_adm_cuadrilla',
     'paquete_adm_cuadrilla',
     l_tipopedd,
     1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('0061', null, 'Paquete masivo', 'paquete_masivo', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('operacion', null, 'funcion original', 'plano', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('mock', null, 'objeto simulado', 'plano', l_tipopedd, 0);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('Claro TV Digital',
     null,
     'Producto principal - Deco adicional',
     'principal_deco',
     l_tipopedd,
     1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('ok', null, 'Retorna Exito', 'respuesta_xml', l_tipopedd, 0);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('error', null, 'Retorna Error', 'respuesta_xml', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('60', null, 'Tiempo de consulta', 'tiempo', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('mock', null, 'objeto simulado', 'tipo_orden', l_tipopedd, 0);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('operacion', null, 'funcion original', 'tipo_orden', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('baja', 408, 'Baja Total del Servicio', 'tipo_trabajo', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 412, 'Traslado Externo', 'tipo_trabajo', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 427, 'Cambio de plan', 'tipo_trabajo', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 424, 'Deco Adicional', 'tipo_trabajo', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 418, 'Traslado Interno', 'tipo_trabajo', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 404, 'Cable Analógico', 'tipo_trabajo', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 657, 'Instalacion paquetes tpi', 'tipo_trabajo_tpi', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 402, 'Instalacion paquetes tpi', 'tipo_trabajo_tpi', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 450, 'Instalacion paquetes tpi', 'tipo_trabajo_tpi', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 661, 'Instalacion paquetes tpi', 'tipo_trabajo_tpi', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('404', null, 'Tipo de Trabajo Venta', 'tiptra_venta', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('0059', null, 'Telefonía Pública de Interior', 'tpi', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, null, null, 'url', l_tipopedd, 0);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null,
     null,
     'http://limdeseaiv27.tim.com.pe:8903/ebsADMCUAD_Capacity/ebsADMCUAD_CapacitySB11?WSDL',
     'url',
     l_tipopedd,
     1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('ws', null, 'ws', 'xml_req', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('mock', null, 'objeto simulado', 'xml_req', l_tipopedd, 0);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('f_retornar_zona_plano', null, 'Funcion', 'zona_plano', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('baja', 432, 'Baja', 'tipo_trabajo', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('baja', 5, 'Baja', 'tipo_trabajo', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('baja', 448, 'Baja', 'tipo_trabajo', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('ETA', null, 'Flag ETAdirect', 'flag_etadirect', l_tipopedd, 1);

  commit;

end;
/
