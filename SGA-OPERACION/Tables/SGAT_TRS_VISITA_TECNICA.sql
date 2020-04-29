-- Create table
create table OPERACION.SGAT_TRS_VISITA_TECNICA
(
  trsn_cod_id       NUMBER not null,
  trsn_customer_id  NUMBER not null,
  trsv_codsrv       VARCHAR2(4),
  trsv_codtipequ    VARCHAR2(15),
  trsv_tipequ       NUMBER,
  trsv_codequcom    VARCHAR2(8),
  trsv_cantidad_equ NUMBER,
  trsv_tipo_srv     VARCHAR2(5),
  trsv_tecnologia   VARCHAR2(10),
  trsv_transaccion  VARCHAR2(20),
  trsv_usureg       VARCHAR2(50) default USER,
  trsd_fecreg       DATE default SYSDATE,
  trsv_ipaplicacion VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  trsv_pcaplicacion VARCHAR2(50) default SYS_CONTEXT('USERENV', 'TERMINAL')
)
tablespace OPERACION_DAT
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
-- Add comments to the columns 
comment on column OPERACION.SGAT_TRS_VISITA_TECNICA.trsn_cod_id
  is 'Codigo de Contrato BSCS';
comment on column OPERACION.SGAT_TRS_VISITA_TECNICA.trsn_customer_id
  is 'Codigo de Cliente BSCS';
comment on column OPERACION.SGAT_TRS_VISITA_TECNICA.trsv_codsrv
  is 'Codigo del Servicio';
comment on column OPERACION.SGAT_TRS_VISITA_TECNICA.trsv_codtipequ
  is 'Codigo del Tipo de Equipo';
comment on column OPERACION.SGAT_TRS_VISITA_TECNICA.trsv_tipequ
  is 'Tipo de Equipo';
comment on column OPERACION.SGAT_TRS_VISITA_TECNICA.trsv_codequcom
  is 'Codigo de Equipo';
comment on column OPERACION.SGAT_TRS_VISITA_TECNICA.trsv_cantidad_equ
  is 'Cantidad de Equipos';
comment on column OPERACION.SGAT_TRS_VISITA_TECNICA.trsv_tipo_srv
  is 'Tipo de Servicio( INT:Internet, TLF: Telefonia, CTV: Cable)';
comment on column OPERACION.SGAT_TRS_VISITA_TECNICA.trsv_tecnologia
  is 'Descripcion de Tecnologia';
comment on column OPERACION.SGAT_TRS_VISITA_TECNICA.trsv_transaccion
  is 'Descripcion de Transaccion';
comment on column OPERACION.SGAT_TRS_VISITA_TECNICA.trsv_usureg
  is 'Usuario que registro';
comment on column OPERACION.SGAT_TRS_VISITA_TECNICA.trsd_fecreg
  is 'Fecha de Registro';
comment on column OPERACION.SGAT_TRS_VISITA_TECNICA.trsv_ipaplicacion
  is 'Ip desde donde se registro';
comment on column OPERACION.SGAT_TRS_VISITA_TECNICA.trsv_pcaplicacion
  is 'PC desde donde se registro';