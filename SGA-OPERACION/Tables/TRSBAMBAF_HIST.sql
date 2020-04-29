-- Create table
create table OPERACION.TRSBAMBAF_HIST
(
  idbam        NUMBER not null,
  codinssrv    NUMBER(10),
  tiptrs       NUMBER,
  feceje       DATE,
  fecprog      DATE,
  est_envio    NUMBER default 0,
  id_mensaje   VARCHAR2(300),
  observ       VARCHAR2(4000),
  tiptra       NUMBER,
  fecusu       DATE default SYSDATE,
  codusu       VARCHAR2(30) default USER,
  seq_lote_bam NUMBER,
  codsolot     NUMBER,
  fecact       DATE,
  id_conexion  NUMBER,
  id_error     NUMBER,
  tipactpv     NUMBER,
  n_reintentos NUMBER default 0,
  aud_pc       VARCHAR2(30) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  aud_ip       VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  est_bam_bscs NUMBER,
  idtrancorte  NUMBER,
  nrodias      NUMBER default 0,
  numero       VARCHAR2(20)
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
comment on column OPERACION.TRSBAMBAF_HIST.idbam
  is 'ID correlativo de la peticion para sincronizar los planes BAF y BAM';
comment on column OPERACION.TRSBAMBAF_HIST.codinssrv
  is 'SID SGA';
comment on column OPERACION.TRSBAMBAF_HIST.tiptrs
  is 'Identifica el tipo de petición en plan BAF: 1:Activacion,2:Upgrade,3:Suspension,4:Reconexion,5:Cancelacion,6:Creacion,7:Suspensión LC,8:Reconexión LC,9:Activacion - No Factura';
comment on column OPERACION.TRSBAMBAF_HIST.feceje
  is 'De acuerdo al tipo de transacción, este valor representa la fecha de registro de la petición de activación, suspensión, cancelación ó reconexion';
comment on column OPERACION.TRSBAMBAF_HIST.fecprog
  is 'De acuerdo al tipo de transacción, este valor representa la fecha de programación de la petición de activación, suspensión, cancelación ó reconexion. Este valor permite realizar peticiones a futuro';
comment on column OPERACION.TRSBAMBAF_HIST.est_envio
  is 'Estado de la petición: 1: Pendiente, 2: En Ejecucion, 3: Terminado OK, 4: Terminado con error';
comment on column OPERACION.TRSBAMBAF_HIST.id_mensaje
  is 'Mensaje de error que se retorna al intentar ejecutar la peticion';
comment on column OPERACION.TRSBAMBAF_HIST.observ
  is 'Observaciones al registro de la peticion ó resultado de la ejecucion';
comment on column OPERACION.TRSBAMBAF_HIST.tiptra
  is 'Indica el tipo de trabajo para plan BAF';
comment on column OPERACION.TRSBAMBAF_HIST.fecusu
  is 'Fecha de Registro';
comment on column OPERACION.TRSBAMBAF_HIST.codusu
  is 'Usuario de Registro';
comment on column OPERACION.TRSBAMBAF_HIST.seq_lote_bam
  is 'Secuencial que permite lotizar las transacciones de envio a BSCS';
comment on column OPERACION.TRSBAMBAF_HIST.codsolot
  is 'sot';
comment on column OPERACION.TRSBAMBAF_HIST.fecact
  is 'Fecha de actualizacion';
comment on column OPERACION.TRSBAMBAF_HIST.id_conexion
  is 'Id de conexion';
comment on column OPERACION.TRSBAMBAF_HIST.id_error
  is 'ID de Mensaje de error BSCS';
comment on column OPERACION.TRSBAMBAF_HIST.tipactpv
  is 'Identifica el tipo de trabajo Estos valores se tomaran de la tabla TIPTRABAJO del SGA.';
comment on column OPERACION.TRSBAMBAF_HIST.n_reintentos
  is 'Indica el numero de reintentos que una petición puede esperar para que se ejecute correctamente';
comment on column OPERACION.TRSBAMBAF_HIST.aud_pc
  is 'Es el nombre de la PC donde se registro la petición';
comment on column OPERACION.TRSBAMBAF_HIST.aud_ip
  is 'Es la direccion IP de la PC donde se registro la petición';
comment on column OPERACION.TRSBAMBAF_HIST.est_bam_bscs
  is 'Estado de la linea BAM en BSCS, 1: Activo, 2: Suspendido, 3: Cancelado, 4: Sin Activar';
comment on column OPERACION.TRSBAMBAF_HIST.idtrancorte
  is 'Identificador de la transaccion';
comment on column OPERACION.TRSBAMBAF_HIST.nrodias
  is 'Numero de Dias';
comment on column OPERACION.TRSBAMBAF_HIST.numero
  is 'Numero';
-- Create/Recreate indexes 
create index OPERACION.IDX_HISONL_01 on OPERACION.TRSBAMBAF_HIST (EST_ENVIO, FECEJE)
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
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.TRSBAMBAF_HIST
  add constraint TRSBAMBAF_HIST_PK primary key (IDBAM)
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
-- Grant/Revoke object privileges 
-- Grant/Revoke object privileges 
grant update on OPERACION.TRSBAMBAF_HIST to SOPFIJA;
grant select, insert, update, delete, references, alter, index on OPERACION.TRSBAMBAF_HIST to USRSGABSCS;
grant select, insert, update, delete, references, alter, index on OPERACION.TRSBAMBAF_HIST to USRWSBAMBAF;
