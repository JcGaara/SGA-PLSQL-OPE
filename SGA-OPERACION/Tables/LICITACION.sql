-- Create table
create table OPERACION.LICITACION
(
  idlicitacion NUMBER not null,
  tiplic       NUMBER,
  estlic       NUMBER default 1,
  proceso      VARCHAR2(200),
  contrato     VARCHAR2(50),
  fe1rareufact DATE,
  feenvconset  DATE,
  feconst      DATE,
  fefircontra  DATE,
  fekioff      DATE,
  feacconst    DATE,
  fe2dareufact DATE,
  febi         DATE,
  fefiracimp   DATE,
  fefiracconf  DATE,
  plazo        NUMBER,
  ipaplicacion VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcaplicacion VARCHAR2(50) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  codusu       VARCHAR2(30) default user,
  fecusu       DATE default sysdate
)
tablespace OPERACION_DAT;
-- Add comments to the table 
comment on table OPERACION.LICITACION
  is 'Licitaciones Gobierno';
-- Add comments to the columns 
comment on column OPERACION.LICITACION.idlicitacion
  is 'Id Licitacion';
comment on column OPERACION.LICITACION.tiplic
  is 'Tipo Licitacion : 1 Orden de Servicio 2 Licitacion';
comment on column OPERACION.LICITACION.estlic
  is 'Etapa';
comment on column OPERACION.LICITACION.proceso
  is 'Tipo y Numero de Proceso';
comment on column OPERACION.LICITACION.contrato
  is 'Numero de Contrato';
comment on column OPERACION.LICITACION.fe1rareufact
  is 'Fecha1ra Reunion Facturación';
comment on column OPERACION.LICITACION.feenvconset
  is 'Fecha Envio Consentimiento';
comment on column OPERACION.LICITACION.feconst
  is 'Fecha Consentimiento';
comment on column OPERACION.LICITACION.fefircontra
  is 'Fecha firma de contrato';
comment on column OPERACION.LICITACION.fekioff
  is 'Fecha Kick OFF';
comment on column OPERACION.LICITACION.feacconst
  is 'Fecha Acta Constitución';
comment on column OPERACION.LICITACION.fe2dareufact
  is 'Fecha2da Reunion Facturación';
comment on column OPERACION.LICITACION.febi
  is 'Fecha BILLING';
comment on column OPERACION.LICITACION.fefiracimp
  is 'Fecha Firma Acta Implementación';
comment on column OPERACION.LICITACION.fefiracconf
  is 'Fecha Firma Acta Conformidad';
comment on column OPERACION.LICITACION.plazo
  is 'Plazo de Implementacion';
comment on column OPERACION.LICITACION.ipaplicacion
  is 'IP Aplicacion';
comment on column OPERACION.LICITACION.pcaplicacion
  is 'PC Aplicacion';
comment on column OPERACION.LICITACION.codusu
  is 'Usuario de creacion del registro';
comment on column OPERACION.LICITACION.fecusu
  is 'Fecha de creacion del resgitro';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.LICITACION
  add constraint PK_LICITACION001 primary key (IDLICITACION)
  using index 
  tablespace OPERACION_IDX;
grant delete on OPERACION.LICITACION to R_PROD;
grant select on OPERACION.LICITACION to R_SOAP_DB;
