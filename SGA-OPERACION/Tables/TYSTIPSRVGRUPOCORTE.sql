-- Create table
create table OPERACION.TYSTIPSRVGRUPOCORTE
(
  IDGRUPOCORTE NUMBER not null,
  TIPSRV       VARCHAR2(4) not null,
  IPAPLICACION VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  USUARIOAPP   VARCHAR2(30) default USER,
  FECUSU       DATE default SYSDATE,
  PCAPLICACION VARCHAR2(100) default SYS_CONTEXT('USERENV', 'TERMINAL')
)
tablespace OPERACION_DAT ;
-- Add comments to the table 
comment on table OPERACION.TYSTIPSRVGRUPOCORTE
  is 'Tabla para excluir los proyectos por tipo de servicio.';
-- Add comments to the columns 
comment on column OPERACION.TYSTIPSRVGRUPOCORTE.IDGRUPOCORTE
  is 'Id grupo corte';
comment on column OPERACION.TYSTIPSRVGRUPOCORTE.TIPSRV
  is 'Tipo de Servicio';
comment on column OPERACION.TYSTIPSRVGRUPOCORTE.IPAPLICACION
  is 'IP Aplicacion';
comment on column OPERACION.TYSTIPSRVGRUPOCORTE.USUARIOAPP
  is 'Usuario APP';
comment on column OPERACION.TYSTIPSRVGRUPOCORTE.FECUSU
  is 'Fecha de Registro';
comment on column OPERACION.TYSTIPSRVGRUPOCORTE.PCAPLICACION
  is 'PC Aplicacion';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.TYSTIPSRVGRUPOCORTE
  add constraint PK_TYSTIPSRVGRUPOCORTE unique (IDGRUPOCORTE, TIPSRV)
  using index 
  tablespace OPERACION_DAT ;