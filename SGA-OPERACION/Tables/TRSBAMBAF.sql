-- Create table
create table OPERACION.TRSBAMBAF
(
  IDBAM        NUMBER not null,
  CODINSSRV    NUMBER(10),
  TIPTRS       NUMBER,
  FECEJE       DATE,
  FECPROG      DATE,
  EST_ENVIO    NUMBER default 0,
  ID_MENSAJE   VARCHAR2(300),
  OBSERV       VARCHAR2(4000),
  TIPTRA       NUMBER,
  FECUSU       DATE default SYSDATE,
  CODUSU       VARCHAR2(30) default USER,
  SEQ_LOTE_BAM NUMBER,
  CODSOLOT     NUMBER,
  FECACT       DATE,
  ID_CONEXION  NUMBER,
  ID_ERROR     NUMBER,
  TIPACTPV     NUMBER,
  N_REINTENTOS NUMBER default 0,
  AUD_PC       VARCHAR2(30) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  AUD_IP       VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  EST_BAM_BSCS NUMBER,
  IDTRANCORTE  NUMBER
) ;
-- Add comments to the columns 
comment on column OPERACION.TRSBAMBAF.IDBAM
  is 'ID correlativo de la peticion para sincronizar los planes BAF y BAM';
comment on column OPERACION.TRSBAMBAF.CODINSSRV
  is 'SID SGA';
comment on column OPERACION.TRSBAMBAF.TIPTRS
  is 'Identifica el tipo de petición en plan BAF: 1:Activacion,2:Upgrade,3:Suspension,4:Reconexion,5:Cancelacion,6:Creacion,7:Suspensión LC,8:Reconexión LC,9:Activacion - No Factura';
comment on column OPERACION.TRSBAMBAF.FECEJE
  is 'De acuerdo al tipo de transacción, este valor representa la fecha de registro de la petición de activación, suspensión, cancelación ó reconexion';
comment on column OPERACION.TRSBAMBAF.FECPROG
  is 'De acuerdo al tipo de transacción, este valor representa la fecha de programación de la petición de activación, suspensión, cancelación ó reconexion. Este valor permite realizar peticiones a futuro';
comment on column OPERACION.TRSBAMBAF.EST_ENVIO
  is 'Estado de la petición: 1: Pendiente, 2: En Ejecucion, 3: Terminado OK, 4: Terminado con error';
comment on column OPERACION.TRSBAMBAF.ID_MENSAJE
  is 'Mensaje de error que se retorna al intentar ejecutar la peticion';
comment on column OPERACION.TRSBAMBAF.OBSERV
  is 'Observaciones al registro de la peticion ó resultado de la ejecucion';
comment on column OPERACION.TRSBAMBAF.TIPTRA
  is 'Indica el tipo de trabajo para plan BAF';
comment on column OPERACION.TRSBAMBAF.FECUSU
  is 'Fecha de Registro';
comment on column OPERACION.TRSBAMBAF.CODUSU
  is 'Usuario de Registro';
comment on column OPERACION.TRSBAMBAF.SEQ_LOTE_BAM
  is 'Secuencial que permite lotizar las transacciones de envio a BSCS';
comment on column OPERACION.TRSBAMBAF.CODSOLOT
  is 'sot';
comment on column OPERACION.TRSBAMBAF.FECACT
  is 'Fecha de actualizacion';
comment on column OPERACION.TRSBAMBAF.ID_CONEXION
  is 'Id de conexion';
comment on column OPERACION.TRSBAMBAF.ID_ERROR
  is 'ID de Mensaje de error BSCS';
comment on column OPERACION.TRSBAMBAF.TIPACTPV
  is 'Identifica el tipo de trabajo Estos valores se tomaran de la tabla TIPTRABAJO del SGA.';
comment on column OPERACION.TRSBAMBAF.N_REINTENTOS
  is 'Indica el numero de reintentos que una petición puede esperar para que se ejecute correctamente';
comment on column OPERACION.TRSBAMBAF.AUD_PC
  is 'Es el nombre de la PC donde se registro la petición';
comment on column OPERACION.TRSBAMBAF.AUD_IP
  is 'Es la direccion IP de la PC donde se registro la petición';
comment on column OPERACION.TRSBAMBAF.EST_BAM_BSCS
  is 'Estado de la linea BAM en BSCS, 1: Activo, 2: Suspendido, 3: Cancelado, 4: Sin Activar';
comment on column OPERACION.TRSBAMBAF.IDTRANCORTE
  is 'Identificador de la transaccion';





alter table OPERACION.TRSBAMBAF
  add constraint TRSBAMBAF_PK primary key (IDBAM)  ;

create index OPERACION.IDX_ONL_01 on OPERACION.TRSBAMBAF (EST_ENVIO, FECEJE);