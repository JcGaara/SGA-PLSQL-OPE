create table OPERACION.REG_LOG_SHELL
(
  idseq        		NUMBER NOT NULL,
  idtransaction		NUMBER,
  idenvio           NUMBER,
  tipo				VARCHAR2(500),
  url				VARCHAR2(500),
  metodo			VARCHAR2(500),
  cabecera			CLOB,
  envioxml			CLOB,
  tipo_trs			NUMBER,
  est_envio			NUMBER default 0,
  autenticacion     VARCHAR2(500),
  cant_hilos        NUMBER,
  status_rpta		NUMBER,
  error_rpta		VARCHAR2(500),
  usureg          	VARCHAR2(30) default USER,
  fecreg          	DATE default SYSDATE,
  ipreg          	VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcreg           	VARCHAR2(100) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  usumod          	VARCHAR2(30),
  ipmod            	VARCHAR2(30),
  pcmod           	VARCHAR2(100),
  fecmod          	DATE
);

comment on table OPERACION.REG_LOG_SHELL
  is 'Log de provisión masiva';
comment on column OPERACION.REG_LOG_SHELL.idseq
  is 'Id secuencial';
comment on column OPERACION.REG_LOG_SHELL.idtransaction
  is 'Id Transaccion';
comment on column OPERACION.REG_LOG_SHELL.idenvio
  is 'Id de envio';
comment on column OPERACION.REG_LOG_SHELL.tipo
  is 'Tipo';
comment on column OPERACION.REG_LOG_SHELL.url
  is 'URL del servicio';
comment on column OPERACION.REG_LOG_SHELL.metodo
  is 'Método del servicio';
comment on column OPERACION.REG_LOG_SHELL.cabecera
  is 'Cabecera del servicio';
comment on column OPERACION.REG_LOG_SHELL.envioxml
  is 'Cuerpo del servicio';
comment on column OPERACION.REG_LOG_SHELL.tipo_trs
  is 'Tipo de transacción';
comment on column OPERACION.REG_LOG_SHELL.est_envio
  is 'Estado de envio';
comment on column OPERACION.REG_LOG_SHELL.autenticacion
  is 'Token de autenticación';
comment on column OPERACION.REG_LOG_SHELL.cant_hilos
  is 'Cantidad de hilos de envio';
comment on column OPERACION.REG_LOG_SHELL.status_rpta
  is 'Codigo de respuesta de incognito';
comment on column OPERACION.REG_LOG_SHELL.error_rpta
  is 'Mensaje de respuesta de incognito';
comment on column OPERACION.REG_LOG_SHELL.usureg
  is 'Usuario que registra';
comment on column OPERACION.REG_LOG_SHELL.fecreg
  is 'Fecha de registro';
comment on column OPERACION.REG_LOG_SHELL.ipreg
  is 'Ip usuario que registra';
comment on column OPERACION.REG_LOG_SHELL.pcreg
  is 'Pc de usuario que registra';
comment on column OPERACION.REG_LOG_SHELL.usumod
  is 'Usuario que modifica';
comment on column OPERACION.REG_LOG_SHELL.fecmod
  is 'Fecha de modificación';
comment on column OPERACION.REG_LOG_SHELL.ipmod
  is 'Ip usuario que modifica';
comment on column OPERACION.REG_LOG_SHELL.pcmod
  is 'Pc de usuario que modifica';








