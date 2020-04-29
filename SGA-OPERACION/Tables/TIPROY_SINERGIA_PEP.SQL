-- Create table
create table OPERACION.TIPROY_SINERGIA_PEP
(
  id_seq           NUMBER not null,
  tiproy           VARCHAR2(3) not null,
  descripcion      VARCHAR2(50),
  rubroinv         VARCHAR2(5),
  clasif_obra      VARCHAR2(10),
  naturaleza_pep   VARCHAR2(10),
  nivel            NUMBER,
  id_seq_pad       NUMBER,
  estado           NUMBER default 0,
  area             VARCHAR2(10),
  consecutivo      VARCHAR2(2),
  crea_grafo       NUMBER default 0,
  clase_activo     VARCHAR2(10),
  tipoproyecto     VARCHAR2(20),
  ceco_res         VARCHAR2(10),
  ceco_sol         VARCHAR2(10),
  genera_reserva   NUMBER default 0,
  crea_pepn2       VARCHAR2(1) default 1,
  id_seq_hijo_nop  NUMBER,
  asigna_sot_pepn3 NUMBER default 0,
  ipaplicacion     VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcaplicacion     VARCHAR2(50) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  codusu           VARCHAR2(30) default user,
  fecusu           DATE default sysdate,
  tipsrv           VARCHAR2(10),
  asigna_ceco_pry  NUMBER default 0
)
tablespace OPERACION_DAT;
-- Add comments to the table 
comment on table OPERACION.TIPROY_SINERGIA_PEP
  is 'Plantilla de PEPs';
-- Add comments to the columns 
comment on column OPERACION.TIPROY_SINERGIA_PEP.id_seq
  is 'ID Seq';
comment on column OPERACION.TIPROY_SINERGIA_PEP.tiproy
  is 'Tipo Proyecto SINERGIA';
comment on column OPERACION.TIPROY_SINERGIA_PEP.descripcion
  is 'Descripcion';
comment on column OPERACION.TIPROY_SINERGIA_PEP.rubroinv
  is 'Rubro de Inversion';
comment on column OPERACION.TIPROY_SINERGIA_PEP.clasif_obra
  is 'Clasificador de Obra';
comment on column OPERACION.TIPROY_SINERGIA_PEP.naturaleza_pep
  is 'Naturaleza PEP';
comment on column OPERACION.TIPROY_SINERGIA_PEP.nivel
  is 'Nivel PEP';
comment on column OPERACION.TIPROY_SINERGIA_PEP.id_seq_pad
  is 'ID Secuencial Padre';
comment on column OPERACION.TIPROY_SINERGIA_PEP.estado
  is '0:Inactivo 1:Activo';
comment on column OPERACION.TIPROY_SINERGIA_PEP.area
  is 'Area : INGE COME';
comment on column OPERACION.TIPROY_SINERGIA_PEP.consecutivo
  is 'Consecutivo Ultimo Nivel PEP3 si es nulo sera secuencial';
comment on column OPERACION.TIPROY_SINERGIA_PEP.crea_grafo
  is '1 : Crea Grafo 0 No Crea Grafo aplica para PEP3 que se usaran para el grafo';
comment on column OPERACION.TIPROY_SINERGIA_PEP.clase_activo
  is 'Clase de Activo Fijo';
comment on column OPERACION.TIPROY_SINERGIA_PEP.tipoproyecto
  is 'Tipo de Proyecto : PE-RF-HF-PEH';
comment on column OPERACION.TIPROY_SINERGIA_PEP.ceco_res
  is 'Centro de Costo Responsable  o Centro Gestor';
comment on column OPERACION.TIPROY_SINERGIA_PEP.ceco_sol
  is 'Centro de Costo Solicitante o Centro Costo Operativo';
comment on column OPERACION.TIPROY_SINERGIA_PEP.genera_reserva
  is 'Indica si el PEP N3 puede generar Reserva';
comment on column OPERACION.TIPROY_SINERGIA_PEP.crea_pepn2
  is 'Crea PEP Nivel 2 1: SI, 0 NO';
comment on column OPERACION.TIPROY_SINERGIA_PEP.id_seq_hijo_nop
  is 'Plantilla Hijo PEH y CHF PEP N3 para Necesidad Operacional';
comment on column OPERACION.TIPROY_SINERGIA_PEP.asigna_sot_pepn3
  is 'Asigna la SOT al PEPN3 0 : No 1:Si';
comment on column OPERACION.TIPROY_SINERGIA_PEP.ipaplicacion
  is 'IP Aplicacion';
comment on column OPERACION.TIPROY_SINERGIA_PEP.pcaplicacion
  is 'PC Aplicacion';
comment on column OPERACION.TIPROY_SINERGIA_PEP.codusu
  is 'Usuario de creacion del registro';
comment on column OPERACION.TIPROY_SINERGIA_PEP.fecusu
  is 'Fecha de creacion del resgitro';
comment on column OPERACION.TIPROY_SINERGIA_PEP.tipsrv
  is 'Tipo de servicio';
comment on column OPERACION.TIPROY_SINERGIA_PEP.asigna_ceco_pry
  is 'Asigna CECO del Proyecto';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.TIPROY_SINERGIA_PEP
  add constraint PK_TIPROY_PEP_001 primary key (ID_SEQ)
  using index 
  tablespace OPERACION_DAT;
