create table OPERACION.OPE_DESALI_OAC_SGA_TMP
(
  cod_cuenta        VARCHAR2(30),
  id_docfac         NUMBER,
  nro_sot           VARCHAR2(150),
  cod_orden         VARCHAR2(50),
  nro_telefono      VARCHAR2(20),
  motivo            VARCHAR2(240),
  estado            VARCHAR2(20),
  fecha_hora        DATE,
  fecha_cierre      DATE,
  usuario_ejecucion VARCHAR2(20),
  nombre_cliente    VARCHAR2(360),
  cod_accion        VARCHAR2(50),
  origen            VARCHAR2(10),
  estado_origen     VARCHAR2(60),
  accion_cobranza   NUMBER
);
