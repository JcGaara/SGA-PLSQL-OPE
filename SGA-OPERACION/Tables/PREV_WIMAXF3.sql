--
-- Create Tabla PREV_WIMAXF3
-- 

create table OPERACION.PREV_WIMAXF3
(
  sec                  VARCHAR2(255),
  sot                  VARCHAR2(255),
  customer_id          NUMBER,
  estado_sot           VARCHAR2(255),
  tipo_sec             VARCHAR2(255),
  canalpdv             VARCHAR2(255),
  canal                VARCHAR2(255),
  proyecto             VARCHAR2(255),
  fecha_gen            VARCHAR2(255),
  nombre               VARCHAR2(255),
  codigo               VARCHAR2(255),
  tipdoc               VARCHAR2(255),
  numdoc               VARCHAR2(255),
  distrito             VARCHAR2(255),
  provincia            VARCHAR2(255),
  departamento         VARCHAR2(255),
  direccion            VARCHAR2(255),
  referencia           VARCHAR2(255),
  telefono1            VARCHAR2(255),
  telefono2            VARCHAR2(255),
  telefono3            VARCHAR2(255),
  paquete              VARCHAR2(255),
  serv_principal       VARCHAR2(255),
  serv_secundario      VARCHAR2(255),
  serv_alquiler        VARCHAR2(255),
  contrata             VARCHAR2(255),
  tipificacion         VARCHAR2(255),
  servicio             VARCHAR2(255),
  internet             VARCHAR2(255),
  telefonia            VARCHAR2(255),
  television           VARCHAR2(255),
  gestion_cliente      VARCHAR2(255),
  fecha                VARCHAR2(255),
  acta                 VARCHAR2(255),
  observacion_contrata VARCHAR2(1000),
  latitud              VARCHAR2(255),
  longitud             VARCHAR2(255),
  rsrp                 VARCHAR2(255),
  sinr                 VARCHAR2(255),
  pci                  VARCHAR2(255),
  iccd_simcard         VARCHAR2(255),
  nro_telefono_simcard VARCHAR2(255),
  password_sip         VARCHAR2(255),
  serie_overall_sn     VARCHAR2(255),
  serie_odu_sn         VARCHAR2(255),
  imei_odu             VARCHAR2(255),
  serie_idu_sn         VARCHAR2(255),
  imei_idu             VARCHAR2(255),
  serie_telefono       VARCHAR2(255),
  kit_anclaje_odu      VARCHAR2(255),
  dni_tecnico          VARCHAR2(255),
  rpc_tecnico          VARCHAR2(255),
  enviado_it_para_act  VARCHAR2(255),
  fecha_envio_act      VARCHAR2(255),
  corte_act            VARCHAR2(255),
  hlr_ims              VARCHAR2(255),
  pcrf                 VARCHAR2(255),
  janus                VARCHAR2(255),
  casilla_voz          VARCHAR2(255),
  fec_validacion       VARCHAR2(255),
  activador            VARCHAR2(255),
  observacion          VARCHAR2(1000),
  tipo_trabajo_lte     VARCHAR2(255),
  distancia            VARCHAR2(255),
  eb                   VARCHAR2(255)
)
tablespace operacion_dat
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

