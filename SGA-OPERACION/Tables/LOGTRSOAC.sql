-- Create table
create table OPERACION.LOGTRSOAC
(
  IDLOG        NUMBER not null,
  IDFAC        VARCHAR2(10),
  IDGRUPOCORTE NUMBER,
  CODSOLOT     NUMBER,
  IDTRANCORTE  NUMBER,
  IDTRSOAC     NUMBER,
  PROCESO      VARCHAR2(250),
  TEXTO        VARCHAR2(4000),
  USUREG       VARCHAR2(30) default user not null,
  FECREG       DATE default sysdate not null,
  USUMOD       VARCHAR2(30) default user not null,
  FECMOD       DATE default sysdate not null,
  IPAPLICACION VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  PCAPLICACION VARCHAR2(100) default SYS_CONTEXT('USERENV', 'TERMINAL')
)
tablespace OPERACION_DAT ;
-- Add comments to the table 
comment on table OPERACION.LOGTRSOAC
  is 'Tabla de registro de log de errores interface OAC';
-- Add comments to the columns 
comment on column OPERACION.LOGTRSOAC.IDLOG
  is 'Identificador unico de la tabla';
comment on column OPERACION.LOGTRSOAC.IDFAC
  is 'Identificador del documento cxctabfac.idfac';
comment on column OPERACION.LOGTRSOAC.IDGRUPOCORTE
  is 'Identificador del grupo de corte. cxc_grupocorte.idgrupocorte';
comment on column OPERACION.LOGTRSOAC.CODSOLOT
  is 'Identificador de SOT';
comment on column OPERACION.LOGTRSOAC.IDTRANCORTE
  is 'Identificador de una transaccion de corte';
comment on column OPERACION.LOGTRSOAC.IDTRSOAC
  is 'Identificador del ticket que viene del OAC';
comment on column OPERACION.LOGTRSOAC.PROCESO
  is 'Procedimiento donde se detecto el error';
comment on column OPERACION.LOGTRSOAC.TEXTO
  is 'Texto descriptivo de error';
comment on column OPERACION.LOGTRSOAC.USUREG
  is 'Usuario de creacion del registro';
comment on column OPERACION.LOGTRSOAC.FECREG
  is 'Fecha de creacion del resgitro';
comment on column OPERACION.LOGTRSOAC.USUMOD
  is 'Usuario ultima modificacion del registro';
comment on column OPERACION.LOGTRSOAC.FECMOD
  is 'Fecha ultima modificacion del registro';
comment on column OPERACION.LOGTRSOAC.IPAPLICACION
  is 'IP Aplicacion';
comment on column OPERACION.LOGTRSOAC.PCAPLICACION
  is 'PC Aplicacion';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.LOGTRSOAC
  add constraint PK_LOGTRSOACCXC primary key (IDLOG)
  using index 
  tablespace OPERACION_DAT ;