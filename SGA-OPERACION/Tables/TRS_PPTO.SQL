create table OPERACION.TRS_PPTO
(
  idppto        NUMBER not null,
  tipo          NUMBER(1),
  total_pep     NUMBER(15,2),
  idagenda      NUMBER,
  procesado     VARCHAR2(1),
  recibido      VARCHAR2(1) default 'N',
  idloteppto    NUMBER,
  codsolot      NUMBER,
  pep           VARCHAR2(40),
  proveedor_sap VARCHAR2(30),
  centro        VARCHAR2(4),
  almacen       VARCHAR2(4),
  documento     VARCHAR2(50),
  contrato      VARCHAR2(50),
  RESPUESTA_SAP VARCHAR2(4),
  mensaje_sap   VARCHAR2(50),
  centrosrv     VARCHAR2(4),
  numreserva    VARCHAR2(10),
  punto         NUMBER,
  orden         NUMBER,
  ipaplicacion  VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcaplicacion  VARCHAR2(50) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  codusu        VARCHAR2(30) default user,
  fecusu        DATE default sysdate
)
tablespace OPERACION_DAT;
comment on table OPERACION.TRS_PPTO
  is 'Transacciones para Presupuesto en SAP';
comment on column OPERACION.TRS_PPTO.idppto
  is 'Secuencial Agrupador';
comment on column OPERACION.TRS_PPTO.tipo
  is 'TIPO= 1= Servicios, 2= Consumo, 3= Reserva';
comment on column OPERACION.TRS_PPTO.total_pep
  is 'SubTotal por PEP';
comment on column OPERACION.TRS_PPTO.idagenda
  is 'Id Agenda aplica para Masivos';
comment on column OPERACION.TRS_PPTO.procesado
  is 'Indicador agrupador Presupuestado desde el SAP';
comment on column OPERACION.TRS_PPTO.recibido
  is 'N : No Recibido en SAP, S Recibido en SAP';
comment on column OPERACION.TRS_PPTO.idloteppto
  is 'Lote de Envio a PPTO';
comment on column OPERACION.TRS_PPTO.codsolot
  is 'SOT';
comment on column OPERACION.TRS_PPTO.pep
  is 'PEP';
comment on column OPERACION.TRS_PPTO.proveedor_sap
  is 'CodigoSAP de la Contrata';
comment on column OPERACION.TRS_PPTO.centro
  is 'Centro Material';
comment on column OPERACION.TRS_PPTO.almacen
  is 'Almacen Material';
comment on column OPERACION.TRS_PPTO.documento
  is 'Documento Contable, viene de SAP';
comment on column OPERACION.TRS_PPTO.contrato
  is 'Contrato Marco, viene de SAP';
comment on column OPERACION.TRS_PPTO.mensaje_sap
  is 'Mensaje de Error, viene de SAP';
comment on column OPERACION.TRS_PPTO.centrosrv
  is 'Centro de Servicios';
comment on column OPERACION.TRS_PPTO.numreserva
  is 'Reserva';
comment on column OPERACION.TRS_PPTO.punto
  is 'Punto SOT';
comment on column OPERACION.TRS_PPTO.orden
  is 'Orden SOT';
comment on column OPERACION.TRS_PPTO.ipaplicacion
  is 'IP Aplicacion';
comment on column OPERACION.TRS_PPTO.pcaplicacion
  is 'PC Aplicacion';
comment on column OPERACION.TRS_PPTO.codusu
  is 'Usuario de creacion del registro';
comment on column OPERACION.TRS_PPTO.fecusu
  is 'Fecha de creacion del resgitro';
create index operacion.IDK_TRS_PPTO_001 on OPERACION.TRS_PPTO (IDLOTEPPTO)
  tablespace OPERACION_DAT;
alter table OPERACION.TRS_PPTO
  add constraint PK_TRS_PPTO primary key (IDPPTO)
  using index 
  tablespace OPERACION_DAT;