-- Create table
create table OPERACION.TRSOACSGA
(
  idtrs        NUMBER not null,
  customer_id  NUMBER,
  nrodoc       VARCHAR2(20),
  idtrancorte  NUMBER,
  idoac        NUMBER,
  usuario      VARCHAR2(50),
  fecinieje    DATE,
  codsolot     NUMBER,
  observacion  VARCHAR2(500),
  codcli       VARCHAR2(10),
  est_envio    NUMBER default 0,
  fecusu       DATE default SYSDATE,
  codusu       VARCHAR2(30) default USER,
  aud_pc       VARCHAR2(30) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  aud_ip       VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  idgrupocorte NUMBER
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
-- Add comments to the table 
comment on table OPERACION.TRSOACSGA  is 'Transacciones de OAC';
comment on column OPERACION.TRSOACSGA.idtrs  is 'ID PK';
comment on column OPERACION.TRSOACSGA.nrodoc is 'ID Documento';
comment on column OPERACION.TRSOACSGA.idtrancorte  is 'Id Tran Corte';
comment on column OPERACION.TRSOACSGA.idoac  is 'Ticket de OAC';
comment on column OPERACION.TRSOACSGA.usuario  is 'Usuario ';
comment on column OPERACION.TRSOACSGA.fecinieje  is 'Fecha de Ejecucion SOT';
comment on column OPERACION.TRSOACSGA.codsolot  is 'SOT';
comment on column OPERACION.TRSOACSGA.observacion  is 'Observaciones';
comment on column OPERACION.TRSOACSGA.codcli  is 'Codigo Cliente';
comment on column OPERACION.TRSOACSGA.est_envio  is 'Estado';
comment on column OPERACION.TRSOACSGA.fecusu  is 'Fecha de Registro';
comment on column OPERACION.TRSOACSGA.codusu  is 'Usuario de Registro';
comment on column OPERACION.TRSOACSGA.aud_pc  is 'Es el nombre de la PC donde se registro la petición';
comment on column OPERACION.TRSOACSGA.aud_ip  is 'Es la direccion IP de la PC donde se registro la petición';

-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.TRSOACSGA
  add constraint PK_TRSOAC_IDTRS primary key (IDTRS)
  using index 
  tablespace OPERACION_DAT
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
  