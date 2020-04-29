declare
  n_explog_igual      number;
  n_explog_noigual    number;
  n_explog_or         number;
  
  n_cond_tipo_mul     number;
  n_cond_tipo_scr     number;
  n_cond_tipo_sim     number;
  
  n_proc_tipo_faut    number;
  n_proc_tipo_json    number;
  n_proc_tipo_xml     number;
  n_proc_tipo_sp      number;
  n_proc_tipo_mdb     number;
  
  n_serv_proc_soa1     number;
  n_serv_proc_osb2     number;
  n_serv_proc_eai2     number;
  n_serv_proc_eai1     number;
  n_serv_proc_osb1     number;
  n_serv_proc_soa2     number;
  
  n_flujo_cab_migracion         number;
  n_flujo_cab_activacion        number;
  
  
  n_cond_cab_ok_genconstancia    number;
  n_cond_cab_er_genconstancia    number;
  n_cond_cab_ok_obtdocumento     number;
  n_cond_cab_ok_cardocumento     number;
  n_cond_cab_val_mul_audi        number;
  n_cond_cab_ok_regtipi          number;
  n_cond_cab_ok_regaudi          number;
  n_cond_cab_ok_aute             number;
  n_cond_cab_ok_crearcta	       number;
  
  
  n_proc_cab_regtipi             number;
  n_proc_cab_gencons		         number;
  n_proc_cab_obtdocumento		     number;
  n_proc_cab_procontigencia	     number;
  n_proc_cab_cardocumento        number;
  n_proc_cab_envnoti             number;
  n_proc_cab_regaudi             number;
  n_proc_cab_gensot              number;
  n_proc_cab_fsot				         number;
  n_proc_cab_migra_plan		       number;
  n_proc_cab_aut			   	       number;
  n_proc_cab_crecta		           number;
  n_proc_cab_inthfc		           number;
  n_proc_cab_facthfc		         number;
begin
  
  --SGAT_DF_EXPRESION_LOGICA

  insert into operacion.SGAT_DF_EXPRESION_LOGICA (EXLOV_SIMBOLO, EXLOV_ABREV, EXLOV_DESCRIPCION, EXLON_ESTADO, EXLOC_VALSCRIPT)
  values (null, 'LK', 'LIKE', 1, null);

  insert into operacion.SGAT_DF_EXPRESION_LOGICA (EXLOV_SIMBOLO, EXLOV_ABREV, EXLOV_DESCRIPCION, EXLON_ESTADO, EXLOC_VALSCRIPT)
  values (null, 'NEQ', 'NOT EQUALS', 1, null);

  insert into operacion.SGAT_DF_EXPRESION_LOGICA (EXLOV_SIMBOLO, EXLOV_ABREV, EXLOV_DESCRIPCION, EXLON_ESTADO, EXLOC_VALSCRIPT)
  values (null, 'EQ', 'EQUALS', 1, null);

  insert into operacion.SGAT_DF_EXPRESION_LOGICA (EXLOV_SIMBOLO, EXLOV_ABREV, EXLOV_DESCRIPCION, EXLON_ESTADO, EXLOC_VALSCRIPT)
  values ('<=', 'MEI', 'MENOR O IGUAL', 1, 'begin
    if :v1 >=:v2 then
      :val := 1;
    else
      :val := 0;
    end if;
  end;');

  insert into operacion.SGAT_DF_EXPRESION_LOGICA (EXLOV_SIMBOLO, EXLOV_ABREV, EXLOV_DESCRIPCION, EXLON_ESTADO, EXLOC_VALSCRIPT)
  values ('>=', 'MAI', 'MAYOR O IGUAL', 1, 'begin
    if :v1 >=:v2 then
      :val := 1;
    else
      :val := 0;
    end if;
  end;');

  insert into operacion.SGAT_DF_EXPRESION_LOGICA (EXLOV_SIMBOLO, EXLOV_ABREV, EXLOV_DESCRIPCION, EXLON_ESTADO, EXLOC_VALSCRIPT)
  values ('<', 'ME', 'MENOR', 1, 'begin
    if :v1 <:v2 then
      :val := 1;
    else
      :val := 0;
    end if;
  end;');

  insert into operacion.SGAT_DF_EXPRESION_LOGICA (EXLOV_SIMBOLO, EXLOV_ABREV, EXLOV_DESCRIPCION, EXLON_ESTADO, EXLOC_VALSCRIPT)
  values ('>', 'MA', 'MAYOR', 1, 'begin
    if :v1 >:v2 then
      :val := 1;
    else
      :val := 0;
    end if;
  end;');

  insert into operacion.SGAT_DF_EXPRESION_LOGICA (EXLOV_SIMBOLO, EXLOV_ABREV, EXLOV_DESCRIPCION, EXLON_ESTADO, EXLOC_VALSCRIPT)
  values ('!=', 'NIG', 'NO IGUAL', 1, 'begin
    if :v1 <>:v2 then
      :val := 1;
    else
      :val := 0;
    end if;
  end;')
  returning EXLON_IDEXPLOG into n_explog_noigual;

  insert into operacion.SGAT_DF_EXPRESION_LOGICA (EXLOV_SIMBOLO, EXLOV_ABREV, EXLOV_DESCRIPCION, EXLON_ESTADO, EXLOC_VALSCRIPT)
  values ('=', 'IG', 'IGUAL', 1, 'begin
    if :v1 =:v2 then
      :val := 1;
    else
      :val := 0;
    end if;
  end;')
  returning EXLON_IDEXPLOG into n_explog_igual;

  insert into operacion.SGAT_DF_EXPRESION_LOGICA (EXLOV_SIMBOLO, EXLOV_ABREV, EXLOV_DESCRIPCION, EXLON_ESTADO, EXLOC_VALSCRIPT)
  values (null, 'OR', 'OR', 1, 'begin
    if :v1 = 1 or :v2 = 1 then
      :val := 1;
    else
      :val := 0;
    end if;
  end;')
  returning EXLON_IDEXPLOG into n_explog_or;

  insert into operacion.SGAT_DF_EXPRESION_LOGICA (EXLOV_SIMBOLO, EXLOV_ABREV, EXLOV_DESCRIPCION, EXLON_ESTADO, EXLOC_VALSCRIPT)
  values (null, 'AND', 'AND', 1, 'begin
    if :v1 = 1 and :v2 = 1 then
      :val := 1;
    else
      :val := 0;
    end if;
  end;');

  insert into operacion.SGAT_DF_EXPRESION_LOGICA (EXLOV_SIMBOLO, EXLOV_ABREV, EXLOV_DESCRIPCION, EXLON_ESTADO, EXLOC_VALSCRIPT)
  values (null, 'EL', 'ELSE', 1, null);

  insert into operacion.SGAT_DF_EXPRESION_LOGICA (EXLOV_SIMBOLO, EXLOV_ABREV, EXLOV_DESCRIPCION, EXLON_ESTADO, EXLOC_VALSCRIPT)
  values (null, 'NLK', 'NOT LIKE', 1, null);

  --SGAT_DF_CONDICION_TIPO
  insert into operacion.SGAT_DF_CONDICION_TIPO (CONTV_ABREV, CONTV_DESCRIPCION, CONTN_ESTADO)
  values ('COND MUL', 'CONDICIÓN MÚLTIPLE', 1)
  returning CONTN_IDTIPOCONDICION into n_cond_tipo_mul;

  insert into operacion.SGAT_DF_CONDICION_TIPO (CONTV_ABREV, CONTV_DESCRIPCION, CONTN_ESTADO)
  values ('COND SIM', 'CONDICIÓN SIMPLE', 1)
  returning CONTN_IDTIPOCONDICION into n_cond_tipo_sim;

  insert into operacion.SGAT_DF_CONDICION_TIPO (CONTV_ABREV, CONTV_DESCRIPCION, CONTN_ESTADO)
  values ('COND SCR', 'CONDICIÓN POR SCRIPT', 1)
  returning CONTN_IDTIPOCONDICION into n_cond_tipo_scr;

  --SGAT_DF_PROCESO_TIPO
  insert into operacion.SGAT_DF_PROCESO_TIPO (PROTV_ABREV, PROTV_DESCRIPCION, PROTN_ESTADO)
  values ('FAUT', 'Tipo de Flujo Automático', 1)
  returning PROTN_IDTIPOPROCESO into n_proc_tipo_faut;

  insert into operacion.SGAT_DF_PROCESO_TIPO (PROTV_ABREV, PROTV_DESCRIPCION, PROTN_ESTADO)
  values ('JSON', 'Tipo de WS Rest', 1)
  returning PROTN_IDTIPOPROCESO into n_proc_tipo_json;

  insert into operacion.SGAT_DF_PROCESO_TIPO (PROTV_ABREV, PROTV_DESCRIPCION, PROTN_ESTADO)
  values ('XML', 'Tipo de WS SOAP', 1)
  returning PROTN_IDTIPOPROCESO into n_proc_tipo_xml;

  insert into operacion.SGAT_DF_PROCESO_TIPO (PROTV_ABREV, PROTV_DESCRIPCION, PROTN_ESTADO)
  values ('SP', 'Tipo de Store Procedures', 1)
  returning PROTN_IDTIPOPROCESO into n_proc_tipo_sp;

  insert into operacion.SGAT_DF_PROCESO_TIPO (PROTV_ABREV, PROTV_DESCRIPCION, PROTN_ESTADO)
  values ('MDB', 'Tipo de WS Message Driven Bean', 1)
  returning PROTN_IDTIPOPROCESO into n_proc_tipo_mdb;

  --SGAT_DF_PROCESO_SERVIDOR
  insert into operacion.SGAT_DF_PROCESO_SERVIDOR (PROSV_TORRE, PROSV_CLUSTER, PROSV_ABREV, PROSV_DESCRIPCION, PROSN_NUMNODO, PROSV_IP, PROSN_PUERTO, PROSV_PROTOCOLO, PROSN_ESTADO)
  values ('POSTVENTA', 'SOA', 'POSTVENTA SOA 1', 'dsc', 1, '172.17.26.49', 20000, 'HTTPS', 1)
  returning PROSN_IDSERVPROCESO into n_serv_proc_soa1;

  insert into operacion.SGAT_DF_PROCESO_SERVIDOR (PROSV_TORRE, PROSV_CLUSTER, PROSV_ABREV, PROSV_DESCRIPCION, PROSN_NUMNODO, PROSV_IP, PROSN_PUERTO, PROSV_PROTOCOLO, PROSN_ESTADO)
  values ('POSTVENTA', 'OSB', 'POSTVENTA OSB 2', 'dsc', 2, '172.17.26.32', 21001, 'HTTPS', 1)
  returning PROSN_IDSERVPROCESO into n_serv_proc_osb2;

  insert into operacion.SGAT_DF_PROCESO_SERVIDOR (PROSV_TORRE, PROSV_CLUSTER, PROSV_ABREV, PROSV_DESCRIPCION, PROSN_NUMNODO, PROSV_IP, PROSN_PUERTO, PROSV_PROTOCOLO, PROSN_ESTADO)
  values ('POSTVENTA', 'EAI', 'POSTVENTA EAI 2', 'dsc', 2, '172.17.26.239', 20001, 'HTTPS', 1)
  returning PROSN_IDSERVPROCESO into n_serv_proc_eai2;

  insert into operacion.SGAT_DF_PROCESO_SERVIDOR (PROSV_TORRE, PROSV_CLUSTER, PROSV_ABREV, PROSV_DESCRIPCION, PROSN_NUMNODO, PROSV_IP, PROSN_PUERTO, PROSV_PROTOCOLO, PROSN_ESTADO)
  values ('POSTVENTA', 'EAI', 'POSTVENTA EAI 1', 'dsc', 1, '172.17.26.24', 20000, 'HTTPS', 1)
  returning PROSN_IDSERVPROCESO into n_serv_proc_eai1;

  insert into operacion.SGAT_DF_PROCESO_SERVIDOR (PROSV_TORRE, PROSV_CLUSTER, PROSV_ABREV, PROSV_DESCRIPCION, PROSN_NUMNODO, PROSV_IP, PROSN_PUERTO, PROSV_PROTOCOLO, PROSN_ESTADO)
  values ('POSTVENTA', 'OSB', 'POSTVENTA OSB 1', 'dsc', 1, '172.17.26.29', 21000, 'HTTPS', 1)
  returning PROSN_IDSERVPROCESO into n_serv_proc_osb1;

  insert into operacion.SGAT_DF_PROCESO_SERVIDOR (PROSV_TORRE, PROSV_CLUSTER, PROSV_ABREV, PROSV_DESCRIPCION, PROSN_NUMNODO, PROSV_IP, PROSN_PUERTO, PROSV_PROTOCOLO, PROSN_ESTADO)
  values ('POSTVENTA', 'SOA', 'POSTVENTA SOA 2', 'dsc', 2, '172.17.26.52', 20001, 'HTTPS', 1)
  returning PROSN_IDSERVPROCESO into n_serv_proc_soa2;
  
  --SGAT_DF_FLUJO_CAB
  insert into operacion.SGAT_DF_FLUJO_CAB (FLUCN_TIPTRABAJO, FLUCV_TRANSACCION, FLUCV_TECNOLOGIA, FLUCV_ABREV, FLUCV_DESCRIPCION, FLUCN_ESTADO, FLUCN_TIPO, FLUCV_SEPCAMPO, FLUCV_SEPREGISTRO)
  values (null, 'MIGRACION PLAN', 'HFC', 'MIGRACION PLAN - HFC', 'Flujo de proceso para guardar la migración de plan en HFC', 1, 1, '|', '#')
  returning FLUCN_IDFLUJO into n_flujo_cab_migracion;

  insert into operacion.SGAT_DF_FLUJO_CAB (FLUCN_TIPTRABAJO, FLUCV_TRANSACCION, FLUCV_TECNOLOGIA, FLUCV_ABREV, FLUCV_DESCRIPCION, FLUCN_ESTADO, FLUCN_TIPO, FLUCV_SEPCAMPO, FLUCV_SEPREGISTRO)
  values (null, 'ACTIVACION', 'HFC', 'ACT - HFC', 'ACTIVACION HFC', 1, 1, '|', '#')
  returning FLUCN_IDFLUJO into n_flujo_cab_activacion;

  --SGAT_DF_CONDICION_CAB
  insert into operacion.SGAT_DF_CONDICION_CAB (CONCN_IDTIPOCONDICION, CONCV_ABREV, CONCV_DESCRIPCION, CONCN_ESTADO)
  values (n_cond_tipo_sim, 'OK GENERAR CONSTANCIA', 'Condición para Obtener documento', 1)
  returning CONCN_IDCONDICION into n_cond_cab_ok_genconstancia;

  insert into operacion.SGAT_DF_CONDICION_CAB (CONCN_IDTIPOCONDICION, CONCV_ABREV, CONCV_DESCRIPCION, CONCN_ESTADO)
  values (n_cond_tipo_sim, 'ERROR GENERAR CONSTANCIA', 'Condición para Procesar constancia', 1)
  returning CONCN_IDCONDICION into n_cond_cab_er_genconstancia;

  insert into operacion.SGAT_DF_CONDICION_CAB (CONCN_IDTIPOCONDICION, CONCV_ABREV, CONCV_DESCRIPCION, CONCN_ESTADO)
  values (n_cond_tipo_sim, 'OK OBTENER DOCUMENTO', 'Condición para Cargar documento', 1)
  returning CONCN_IDCONDICION into n_cond_cab_ok_obtdocumento;

  insert into operacion.SGAT_DF_CONDICION_CAB (CONCN_IDTIPOCONDICION, CONCV_ABREV, CONCV_DESCRIPCION, CONCN_ESTADO)
  values (n_cond_tipo_sim, 'OK CARGAR DOCUMENTO', 'Condición para Enviar notificación', 1)
  returning CONCN_IDCONDICION into n_cond_cab_ok_cardocumento;

  insert into operacion.SGAT_DF_CONDICION_CAB (CONCN_IDTIPOCONDICION, CONCV_ABREV, CONCV_DESCRIPCION, CONCN_ESTADO)
  values (n_cond_tipo_mul, 'VAL MUL REGISTRAR AUDITORÍA', 'Condiciones para Registrar auditoría', 1)
  returning CONCN_IDCONDICION into n_cond_cab_val_mul_audi;

  insert into operacion.SGAT_DF_CONDICION_CAB (CONCN_IDTIPOCONDICION, CONCV_ABREV, CONCV_DESCRIPCION, CONCN_ESTADO)
  values (n_cond_tipo_sim, 'OK REGISTRAR TIPIFICACIÓN', 'Condición para Generar constancia', 1)
  returning CONCN_IDCONDICION into n_cond_cab_ok_regtipi;

  insert into operacion.SGAT_DF_CONDICION_CAB (CONCN_IDTIPOCONDICION, CONCV_ABREV, CONCV_DESCRIPCION, CONCN_ESTADO)
  values (n_cond_tipo_sim, 'OK REGISTRAR AUDITORÍA', 'Condición para generar SOT', 1)
  returning CONCN_IDCONDICION into n_cond_cab_ok_regaudi;

  insert into operacion.SGAT_DF_CONDICION_CAB (CONCN_IDTIPOCONDICION, CONCV_ABREV, CONCV_DESCRIPCION, CONCN_ESTADO)
  values (n_cond_tipo_sim, 'OK AUTENTICACION', 'Condición para crear cuenta OK', 1)
  returning CONCN_IDCONDICION into n_cond_cab_ok_aute;

  insert into operacion.SGAT_DF_CONDICION_CAB (CONCN_IDTIPOCONDICION, CONCV_ABREV, CONCV_DESCRIPCION, CONCN_ESTADO)
  values (n_cond_tipo_sim, 'OK CREAR CUENTA', 'Condición para Activar Internet OK', 1)
  returning CONCN_IDCONDICION into n_cond_cab_ok_crearcta;

  --SGAT_DF_PROCESO_CAB
  insert into operacion.SGAT_DF_PROCESO_CAB (PROCN_IDTIPOPROCESO, PROCV_ABREV, PROCV_DESCRIPCION, PROCN_ESTADO, PROCN_IDSERVPROCESO, PROCV_RUTA, PROCC_CABECERA, PROCC_CUERPO, PROCV_METODO, PROCN_TIMEOUT)
  values (n_proc_tipo_json, 'Registra Tipificación', 'Servicio nuevo REST que registra la Tipificación', 1, null, null, null, null, null, 5000)
  returning PROCN_IDPROCESO into n_proc_cab_regtipi;

  insert into operacion.SGAT_DF_PROCESO_CAB (PROCN_IDTIPOPROCESO, PROCV_ABREV, PROCV_DESCRIPCION, PROCN_ESTADO, PROCN_IDSERVPROCESO, PROCV_RUTA, PROCC_CABECERA, PROCC_CUERPO, PROCV_METODO, PROCN_TIMEOUT)
  values (n_proc_tipo_xml, 'Generar Constancia', 'Generar Constancia - EngineService', 1, n_serv_proc_eai2, 'http://172.17.44.39:7001/EngineService/EngineService?wsdl', null, null, 'compose', 5000)
  returning PROCN_IDPROCESO into n_proc_cab_gencons;

  insert into operacion.SGAT_DF_PROCESO_CAB (PROCN_IDTIPOPROCESO, PROCV_ABREV, PROCV_DESCRIPCION, PROCN_ESTADO, PROCN_IDSERVPROCESO, PROCV_RUTA, PROCC_CABECERA, PROCC_CUERPO, PROCV_METODO, PROCN_TIMEOUT)
  values (n_proc_tipo_xml, 'Obtener Documento', 'BSS_ObtencionDocumentoFileServer', 1, n_serv_proc_eai1, 'http://172.19.133.58:21000/BSS_ObtencionDocumentoFileServer/SRV_ObtencionDocumentoFileServer/Resource/WSDL/BSS_ObtenerDocumentoFileServer?WSDL', null, null, 'obtenerDocumentoFileServer', 5000)
  returning PROCN_IDPROCESO into n_proc_cab_obtdocumento;

  insert into operacion.SGAT_DF_PROCESO_CAB (PROCN_IDTIPOPROCESO, PROCV_ABREV, PROCV_DESCRIPCION, PROCN_ESTADO, PROCN_IDSERVPROCESO, PROCV_RUTA, PROCC_CABECERA, PROCC_CUERPO, PROCV_METODO, PROCN_TIMEOUT)
  values (n_proc_tipo_json, 'Procesar Contingencia', 'Procesar Contingencia - ProcesaConstancia.enviarProcesaConstancia', 1, n_serv_proc_eai2, 'http://172.17.26.118:20000/claro-postventa-procesaconstancia-resource/api/postventa/procesaConstancia', null, null, 'POST', 5000)
  returning PROCN_IDPROCESO into n_proc_cab_procontigencia;

  insert into operacion.SGAT_DF_PROCESO_CAB (PROCN_IDTIPOPROCESO, PROCV_ABREV, PROCV_DESCRIPCION, PROCN_ESTADO, PROCN_IDSERVPROCESO, PROCV_RUTA, PROCC_CABECERA, PROCC_CUERPO, PROCV_METODO, PROCN_TIMEOUT)
  values (n_proc_tipo_xml, 'Cargar Documento', 'WsOnBaseCarga', 1, n_serv_proc_eai2, 'http://172.19.84.67/WsOnBaseCarga/svcOnBaseClaroCarga.asmx?WSDL', null, null, 'CargarDocumentoOnBase', 5000)
  returning PROCN_IDPROCESO into n_proc_cab_cardocumento;

  insert into operacion.SGAT_DF_PROCESO_CAB (PROCN_IDTIPOPROCESO, PROCV_ABREV, PROCV_DESCRIPCION, PROCN_ESTADO, PROCN_IDSERVPROCESO, PROCV_RUTA, PROCC_CABECERA, PROCC_CUERPO, PROCV_METODO, PROCN_TIMEOUT)
  values (n_proc_tipo_xml, 'Enviar Notificacion', 'EnviaNotificacionWS', 1, n_serv_proc_eai2, 'http://172.17.26.117:20000/EnviaNotificacionWS/ebsEnviaNotificacionWSSB11?WSDL', null, null, 'enviarNotificacion', 5000)
  returning PROCN_IDPROCESO into n_proc_cab_envnoti;

  insert into operacion.SGAT_DF_PROCESO_CAB (PROCN_IDTIPOPROCESO, PROCV_ABREV, PROCV_DESCRIPCION, PROCN_ESTADO, PROCN_IDSERVPROCESO, PROCV_RUTA, PROCC_CABECERA, PROCC_CUERPO, PROCV_METODO, PROCN_TIMEOUT)
  values (n_proc_tipo_mdb, 'Registrar Auditoria', 'RegistroAuditoriaMDB', 1, n_serv_proc_eai1, '172.19.67.156:7903;172.19.67.157:7903;172.19.67.158:7903', null, null, 'pe.com.claro.esb.services.auditoria.queue', 5000)
  returning PROCN_IDPROCESO into n_proc_cab_regaudi;

  insert into operacion.SGAT_DF_PROCESO_CAB (PROCN_IDTIPOPROCESO, PROCV_ABREV, PROCV_DESCRIPCION, PROCN_ESTADO, PROCN_IDSERVPROCESO, PROCV_RUTA, PROCC_CABECERA, PROCC_CUERPO, PROCV_METODO, PROCN_TIMEOUT)
  values (n_proc_tipo_json, 'Generar SOT', 'Servicio nuevo REST ÚNICO  que GENERA SOT - POSTVENTA FIJA', 1, null, null, null, null, null, 5000)
  returning PROCN_IDPROCESO into n_proc_cab_gensot;

  insert into operacion.SGAT_DF_PROCESO_CAB (PROCN_IDTIPOPROCESO, PROCV_ABREV, PROCV_DESCRIPCION, PROCN_ESTADO, PROCN_IDSERVPROCESO, PROCV_RUTA, PROCC_CABECERA, PROCC_CUERPO, PROCV_METODO, PROCN_TIMEOUT)
  values (n_proc_tipo_faut, 'Flujo SOT Unificado', 'SP Prueba', 1, n_serv_proc_eai1, null, null, null, null, 5000)
  returning PROCN_IDPROCESO into n_proc_cab_fsot;

  insert into operacion.SGAT_DF_PROCESO_CAB (PROCN_IDTIPOPROCESO, PROCV_ABREV, PROCV_DESCRIPCION, PROCN_ESTADO, PROCN_IDSERVPROCESO, PROCV_RUTA, PROCC_CABECERA, PROCC_CUERPO, PROCV_METODO, PROCN_TIMEOUT)
  values (n_proc_tipo_faut, 'FAUT MIGRACIÓN PLAN HFC', 'FAUT MIGRACIÓN PLAN HFC', 1, null, null, null, null, null, 5000)
  returning PROCN_IDPROCESO into n_proc_cab_migra_plan;

  insert into operacion.SGAT_DF_PROCESO_CAB (PROCN_IDTIPOPROCESO, PROCV_ABREV, PROCV_DESCRIPCION, PROCN_ESTADO, PROCN_IDSERVPROCESO, PROCV_RUTA, PROCC_CABECERA, PROCC_CUERPO, PROCV_METODO, PROCN_TIMEOUT)
  values (n_proc_tipo_json, 'Autentificación', 'Autentificación Incógnito', 1, n_serv_proc_eai2, 'http://172.19.91.219:2800/SACRestApi/api/authentication', null, '{
        "username": "RESTAPIHFC",
        "password": "RESTAPIHFC",
        "serviceProvider": "Incognito",
        "language": "English"
  }', 'POST', 5000)
  returning PROCN_IDPROCESO into n_proc_cab_aut;

  insert into operacion.SGAT_DF_PROCESO_CAB (PROCN_IDTIPOPROCESO, PROCV_ABREV, PROCV_DESCRIPCION, PROCN_ESTADO, PROCN_IDSERVPROCESO, PROCV_RUTA, PROCC_CABECERA, PROCC_CUERPO, PROCV_METODO, PROCN_TIMEOUT)
  values (n_proc_tipo_json, 'Crear Cuenta', 'Crear Cuenta Incógnito', 1, n_serv_proc_eai2, 'http://172.19.91.219:2800/SACRestApi/api/accounts', 'ource:PB80.EXE
  transactionId:20191127151556
  authorization:1574885755968734', '{
    "identifier": "41",
    "subscribers": [{
      "identifier": "41",
      "firstName": "GUILLERMO PAREDES ALEGRIA",
      "lastName": "GUILLERMO PAREDES ALEGRIA"
    }]
  }', 'POST', 5000)
  returning PROCN_IDPROCESO into n_proc_cab_crecta;

  insert into operacion.SGAT_DF_PROCESO_CAB (PROCN_IDTIPOPROCESO, PROCV_ABREV, PROCV_DESCRIPCION, PROCN_ESTADO, PROCN_IDSERVPROCESO, PROCV_RUTA, PROCC_CABECERA, PROCC_CUERPO, PROCV_METODO, PROCN_TIMEOUT)
  values (n_proc_tipo_json, 'Internet HFC', 'Internet Incógnito HFC', 1, n_serv_proc_eai2, 'http://172.19.91.219:2800/SACRestApi/api/services', 'authorization:1574885755968734
  transactionId:20191127151618
  source:PB80.EXE', '{
    "identifier": "SGA0000000002665",
    "subscriberIdentifier": "457",
    "serviceType": "BSoD_2M_2M",
    "attributes": [
      {
        "HFC_NODE": "TRUJ154",
        "HUB": "Hub Trujillo",
        "CPE_POOL": "cpe",
        "MAX_CPE": "2",
        "STATIC_IP_COUNT": "1"
      }
    ],
    "device": {
      "identifier": "60:19:71:D5:98:52",
      "type": "DPQ2425 CM"
    }
  }', 'POST', 5000)
  returning PROCN_IDPROCESO into n_proc_cab_inthfc;

  insert into operacion.SGAT_DF_PROCESO_CAB (PROCN_IDTIPOPROCESO, PROCV_ABREV, PROCV_DESCRIPCION, PROCN_ESTADO, PROCN_IDSERVPROCESO, PROCV_RUTA, PROCC_CABECERA, PROCC_CUERPO, PROCV_METODO, PROCN_TIMEOUT)
  values (n_proc_tipo_faut, 'FAUT Activación HFC', 'FAUT Activación HFC', n_serv_proc_eai2, null, null, null, null, null, 5000)
  returning PROCN_IDPROCESO into n_proc_cab_facthfc;

  --SGAT_DF_CONDICION_DET
  insert into operacion.SGAT_DF_CONDICION_DET (CONDN_IDCONDICION, CONDN_ORDEN, CONDV_PARAMETRO, CONDN_IDEXPLOG, CONDV_VALOR, CONDN_IDEXPPOST, CONDN_CANTIDAD, CONDC_SCRIPT, CONDN_ESTADO)
  values (n_cond_cab_ok_regtipi, 1, 'CODRPTA_REGISTRAR_TIPIFICACION', n_explog_igual, '0', null, 1, null, 1);

  insert into operacion.SGAT_DF_CONDICION_DET (CONDN_IDCONDICION, CONDN_ORDEN, CONDV_PARAMETRO, CONDN_IDEXPLOG, CONDV_VALOR, CONDN_IDEXPPOST, CONDN_CANTIDAD, CONDC_SCRIPT, CONDN_ESTADO)
  values (n_cond_cab_ok_genconstancia, 1, 'CODRPTA_GENERAR_CONSTANCIA', n_explog_igual, '0', null, 1, null, 1);

  insert into operacion.SGAT_DF_CONDICION_DET (CONDN_IDCONDICION, CONDN_ORDEN, CONDV_PARAMETRO, CONDN_IDEXPLOG, CONDV_VALOR, CONDN_IDEXPPOST, CONDN_CANTIDAD, CONDC_SCRIPT, CONDN_ESTADO)
  values (n_cond_cab_er_genconstancia, 1, 'CODRPTA_GENERAR_CONSTANCIA', n_explog_noigual, '0', null, 1, null, 1);

  insert into operacion.SGAT_DF_CONDICION_DET (CONDN_IDCONDICION, CONDN_ORDEN, CONDV_PARAMETRO, CONDN_IDEXPLOG, CONDV_VALOR, CONDN_IDEXPPOST, CONDN_CANTIDAD, CONDC_SCRIPT, CONDN_ESTADO)
  values (n_cond_cab_ok_obtdocumento, 1, 'CODRPTA_OBTENER_DOCUMENTO', n_explog_igual, '0', null, 1, null, 1);

  insert into operacion.SGAT_DF_CONDICION_DET (CONDN_IDCONDICION, CONDN_ORDEN, CONDV_PARAMETRO, CONDN_IDEXPLOG, CONDV_VALOR, CONDN_IDEXPPOST, CONDN_CANTIDAD, CONDC_SCRIPT, CONDN_ESTADO)
  values (n_cond_cab_ok_cardocumento, 1, 'CODRPTA_CARGAR_DOCUMENTO', n_explog_igual, '0', null, 1, null, 1);

  insert into operacion.SGAT_DF_CONDICION_DET (CONDN_IDCONDICION, CONDN_ORDEN, CONDV_PARAMETRO, CONDN_IDEXPLOG, CONDV_VALOR, CONDN_IDEXPPOST, CONDN_CANTIDAD, CONDC_SCRIPT, CONDN_ESTADO)
  values (n_cond_cab_ok_regaudi, 1, 'CODRPTA_REGISTRAR_AUDITORIA', n_explog_igual, '0', null, 1, null, 1);

  insert into operacion.SGAT_DF_CONDICION_DET (CONDN_IDCONDICION, CONDN_ORDEN, CONDV_PARAMETRO, CONDN_IDEXPLOG, CONDV_VALOR, CONDN_IDEXPPOST, CONDN_CANTIDAD, CONDC_SCRIPT, CONDN_ESTADO)
  values (n_cond_cab_val_mul_audi, 1, 'CODRPTA_ENVIAR_NOTIFICACION', n_explog_igual, '0', n_explog_or, 1, null, 1);

  insert into operacion.SGAT_DF_CONDICION_DET (CONDN_IDCONDICION, CONDN_ORDEN, CONDV_PARAMETRO, CONDN_IDEXPLOG, CONDV_VALOR, CONDN_IDEXPPOST, CONDN_CANTIDAD, CONDC_SCRIPT, CONDN_ESTADO)
  values (n_cond_cab_val_mul_audi, 2, 'CODRPTA_PROCESAR_CONTINGENCIA', n_explog_igual, '0', null, 1, null, 1);

  insert into operacion.SGAT_DF_CONDICION_DET (CONDN_IDCONDICION, CONDN_ORDEN, CONDV_PARAMETRO, CONDN_IDEXPLOG, CONDV_VALOR, CONDN_IDEXPPOST, CONDN_CANTIDAD, CONDC_SCRIPT, CONDN_ESTADO)
  values (n_cond_cab_ok_aute, 1, 'CORPTA_AUTENTIFICACION', n_explog_igual, '201', null, 1, null, 1);

  insert into operacion.SGAT_DF_CONDICION_DET (CONDN_IDCONDICION, CONDN_ORDEN, CONDV_PARAMETRO, CONDN_IDEXPLOG, CONDV_VALOR, CONDN_IDEXPPOST, CONDN_CANTIDAD, CONDC_SCRIPT, CONDN_ESTADO)
  values (n_cond_cab_ok_crearcta, 1, 'CORPTA_CREAR_CUENTA', n_explog_igual, '201', null, 1, null, 1);
  
  --SGAT_DF_FLUJO_DET
  insert into operacion.SGAT_DF_FLUJO_DET (FLUDN_IDFLUJO, FLUDN_ORDEN, FLUDN_IDPROCESO, FLUDV_PREPROCESO, FLUDV_POSTPROCESO, FLUDC_FLGMANDATORIO, FLUDN_ORDENCONDICION, FLUDN_IDCONDICION, FLUDC_FLGREGTRS, FLUDN_REINTENTOS, FLUDN_IDPROCESOERROR, FLUDN_ESTADO)
  values (n_flujo_cab_migracion, 1, n_proc_cab_regtipi, '0', n_proc_cab_gencons, 'SI', null, null, 'NO', 1, null, 1);

  insert into operacion.SGAT_DF_FLUJO_DET (FLUDN_IDFLUJO, FLUDN_ORDEN, FLUDN_IDPROCESO, FLUDV_PREPROCESO, FLUDV_POSTPROCESO, FLUDC_FLGMANDATORIO, FLUDN_ORDENCONDICION, FLUDN_IDCONDICION, FLUDC_FLGREGTRS, FLUDN_REINTENTOS, FLUDN_IDPROCESOERROR, FLUDN_ESTADO)
  values (n_flujo_cab_migracion, 2, n_proc_cab_gencons, n_proc_cab_regtipi, n_proc_cab_obtdocumento||','||n_proc_cab_procontigencia, 'SI', 1, n_cond_cab_ok_regtipi, 'NO', 3, null, 1);

  insert into operacion.SGAT_DF_FLUJO_DET (FLUDN_IDFLUJO, FLUDN_ORDEN, FLUDN_IDPROCESO, FLUDV_PREPROCESO, FLUDV_POSTPROCESO, FLUDC_FLGMANDATORIO, FLUDN_ORDENCONDICION, FLUDN_IDCONDICION, FLUDC_FLGREGTRS, FLUDN_REINTENTOS, FLUDN_IDPROCESOERROR, FLUDN_ESTADO)
  values (n_flujo_cab_migracion, 3, n_proc_cab_procontigencia, n_proc_cab_gencons, n_proc_cab_regaudi, 'NO', 2, n_cond_cab_er_genconstancia, 'NO', 1, null, 1);

  insert into operacion.SGAT_DF_FLUJO_DET (FLUDN_IDFLUJO, FLUDN_ORDEN, FLUDN_IDPROCESO, FLUDV_PREPROCESO, FLUDV_POSTPROCESO, FLUDC_FLGMANDATORIO, FLUDN_ORDENCONDICION, FLUDN_IDCONDICION, FLUDC_FLGREGTRS, FLUDN_REINTENTOS, FLUDN_IDPROCESOERROR, FLUDN_ESTADO)
  values (n_flujo_cab_migracion, 4, n_proc_cab_obtdocumento, n_proc_cab_gencons, n_proc_cab_cardocumento, 'NO', 1, n_cond_cab_ok_genconstancia, 'NO', 1, null, 1);

  insert into operacion.SGAT_DF_FLUJO_DET (FLUDN_IDFLUJO, FLUDN_ORDEN, FLUDN_IDPROCESO, FLUDV_PREPROCESO, FLUDV_POSTPROCESO, FLUDC_FLGMANDATORIO, FLUDN_ORDENCONDICION, FLUDN_IDCONDICION, FLUDC_FLGREGTRS, FLUDN_REINTENTOS, FLUDN_IDPROCESOERROR, FLUDN_ESTADO)
  values (n_flujo_cab_migracion, 5, n_proc_cab_cardocumento, n_proc_cab_obtdocumento, n_proc_cab_envnoti, 'NO', 1, n_cond_cab_ok_obtdocumento, 'NO', 1, null, 1);

  insert into operacion.SGAT_DF_FLUJO_DET (FLUDN_IDFLUJO, FLUDN_ORDEN, FLUDN_IDPROCESO, FLUDV_PREPROCESO, FLUDV_POSTPROCESO, FLUDC_FLGMANDATORIO, FLUDN_ORDENCONDICION, FLUDN_IDCONDICION, FLUDC_FLGREGTRS, FLUDN_REINTENTOS, FLUDN_IDPROCESOERROR, FLUDN_ESTADO)
  values (n_flujo_cab_migracion, 6, n_proc_cab_envnoti, n_proc_cab_cardocumento, n_proc_cab_regaudi, 'NO', 1, n_cond_cab_ok_cardocumento, 'NO', 1, null, 1);

  insert into operacion.SGAT_DF_FLUJO_DET (FLUDN_IDFLUJO, FLUDN_ORDEN, FLUDN_IDPROCESO, FLUDV_PREPROCESO, FLUDV_POSTPROCESO, FLUDC_FLGMANDATORIO, FLUDN_ORDENCONDICION, FLUDN_IDCONDICION, FLUDC_FLGREGTRS, FLUDN_REINTENTOS, FLUDN_IDPROCESOERROR, FLUDN_ESTADO)
  values (n_flujo_cab_migracion, 7, n_proc_cab_regaudi, n_proc_cab_procontigencia||','||n_proc_cab_envnoti, n_proc_cab_gensot, 'SI', 1, n_cond_cab_val_mul_audi, 'NO', 1, null, 1);

  insert into operacion.SGAT_DF_FLUJO_DET (FLUDN_IDFLUJO, FLUDN_ORDEN, FLUDN_IDPROCESO, FLUDV_PREPROCESO, FLUDV_POSTPROCESO, FLUDC_FLGMANDATORIO, FLUDN_ORDENCONDICION, FLUDN_IDCONDICION, FLUDC_FLGREGTRS, FLUDN_REINTENTOS, FLUDN_IDPROCESOERROR, FLUDN_ESTADO)
  values (n_flujo_cab_migracion, 8, n_proc_cab_gensot, '70', null, 'SI', null, null, 'NO', 1, null, 1);

  insert into operacion.SGAT_DF_FLUJO_DET (FLUDN_IDFLUJO, FLUDN_ORDEN, FLUDN_IDPROCESO, FLUDV_PREPROCESO, FLUDV_POSTPROCESO, FLUDC_FLGMANDATORIO, FLUDN_ORDENCONDICION, FLUDN_IDCONDICION, FLUDC_FLGREGTRS, FLUDN_REINTENTOS, FLUDN_IDPROCESOERROR, FLUDN_ESTADO)
  values (n_flujo_cab_activacion, 1, n_proc_cab_aut, '0', '2', 'SI', null, null, 'SI', 3, null, 1);

  insert into operacion.SGAT_DF_FLUJO_DET (FLUDN_IDFLUJO, FLUDN_ORDEN, FLUDN_IDPROCESO, FLUDV_PREPROCESO, FLUDV_POSTPROCESO, FLUDC_FLGMANDATORIO, FLUDN_ORDENCONDICION, FLUDN_IDCONDICION, FLUDC_FLGREGTRS, FLUDN_REINTENTOS, FLUDN_IDPROCESOERROR, FLUDN_ESTADO)
  values (n_flujo_cab_activacion, 2, n_proc_cab_crecta, '1', '3', 'SI', 1, n_cond_cab_ok_aute, 'SI', 3, null, 1);

  insert into operacion.SGAT_DF_FLUJO_DET (FLUDN_IDFLUJO, FLUDN_ORDEN, FLUDN_IDPROCESO, FLUDV_PREPROCESO, FLUDV_POSTPROCESO, FLUDC_FLGMANDATORIO, FLUDN_ORDENCONDICION, FLUDN_IDCONDICION, FLUDC_FLGREGTRS, FLUDN_REINTENTOS, FLUDN_IDPROCESOERROR, FLUDN_ESTADO)
  values (n_flujo_cab_activacion, 3, n_proc_cab_inthfc, '2', null, 'SI', 1, n_cond_cab_ok_crearcta, 'SI', 3, null, 1);
  
  commit;
end;
/
