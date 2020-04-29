-- Create table
create table OPERACION.OPE_TRX_CLAROVIDEO_SVA 
(  
  IDREGISTRO      NUMBER(8,0) NOT NULL ENABLE, 
  IDTRANSACCION VARCHAR2(20), 
  APLICACION VARCHAR2(10), 
  USRAPLICACION VARCHAR2(30), 
  IPAPLICACION VARCHAR2(20), 
  COD_CLI_SGA VARCHAR2(8), 
  TIPO_OPERACION VARCHAR2(10), 
  CRITERIO VARCHAR2(8), 
  NUMSLC_INICIAL CHAR(10),
  NUMSLC_FINAL CHAR(10),
  CODSOLOT NUMBER(8),
  SID_INICIAL NUMBER(10,0),
  SID_FINAL NUMBER(10,0), 
  FECHA_ENVIO VARCHAR2(10), 
  RESULTADO VARCHAR2(30), 
  MENSAJE VARCHAR2(300), 
  ESTADO NUMBER(1,0), 
  NRO_REINTENTO NUMBER(4,0), 
  USUREG VARCHAR2(30) default user not null,
  FECREG DATE default SYSDATE not null, 
  USUMOD VARCHAR2(30), 
  FECMOD DATE, 
  FLAG_ENVIO_EMAIL NUMBER(1,0)
  );
-- Add comments to the table 
comment on table OPERACION.OPE_TRX_CLAROVIDEO_SVA
        is 'Tabla transaccional donde se registran todas las transacciones enviadas a Claro Video';
-- Add comments to the columns 
comment on column OPERACION.OPE_TRX_CLAROVIDEO_SVA.IDREGISTRO 
        is 'Identificador único del registro';
comment on column OPERACION.OPE_TRX_CLAROVIDEO_SVA.IDTRANSACCION 
        is 'Identificador de la transacción realizada en Claro Video';
comment on column OPERACION.OPE_TRX_CLAROVIDEO_SVA.APLICACION 
        is 'Parámetro de entrada del WS Claro Video';
comment on column OPERACION.OPE_TRX_CLAROVIDEO_SVA.USRAPLICACION 
        is 'Parámetro de entrada del WS Claro Video';
comment on column OPERACION.OPE_TRX_CLAROVIDEO_SVA.IPAPLICACION 
        is 'Parámetro de entrada del WS Claro Video';
comment on column OPERACION.OPE_TRX_CLAROVIDEO_SVA.COD_CLI_SGA 
        is 'Código del cliente en SGA';
comment on column OPERACION.OPE_TRX_CLAROVIDEO_SVA.TIPO_OPERACION 
        is 'Tipo de operación (TE:Traslado Externo, BA: Baja, CP:Cambio de plan)';
comment on column OPERACION.OPE_TRX_CLAROVIDEO_SVA.CRITERIO 
        is 'Parámetro de entrada del WS Claro Video';
comment on column OPERACION.OPE_TRX_CLAROVIDEO_SVA.SID_INICIAL 
        is '(campo CODINSSRV de la tabla INSSRV) SID del servicio a actualizar o dar de baja según el tipo de operación.';
comment on column OPERACION.OPE_TRX_CLAROVIDEO_SVA.SID_FINAL 
        is 'SID del servicio nuevo';
comment on column OPERACION.OPE_TRX_CLAROVIDEO_SVA.FECHA_ENVIO 
        is 'Fecha de envío a Claro Video';
comment on column OPERACION.OPE_TRX_CLAROVIDEO_SVA.RESULTADO 
        is 'Código de resultado de respuesta de Claro Video';
comment on column OPERACION.OPE_TRX_CLAROVIDEO_SVA.MENSAJE 
        is 'Mensaje de resultado de respuesta de Claro Video';
comment on column OPERACION.OPE_TRX_CLAROVIDEO_SVA.ESTADO 
        is 'Estado de transacción (0:Registrado, 1:Procesado Ok, 2:Procesado Error)';
comment on column OPERACION.OPE_TRX_CLAROVIDEO_SVA.NRO_REINTENTO 
        is 'Nro de reintentos de envío a Claro Video.';
comment on column OPERACION.OPE_TRX_CLAROVIDEO_SVA.USUREG 
        is 'Usuario de registro';
comment on column OPERACION.OPE_TRX_CLAROVIDEO_SVA.FECREG 
        is 'Fecha de registro';
comment on column OPERACION.OPE_TRX_CLAROVIDEO_SVA.USUMOD 
        is 'Usuario de modificación';
comment on column OPERACION.OPE_TRX_CLAROVIDEO_SVA.FECMOD 
        is 'Fecha de modificación';
comment on column OPERACION.OPE_TRX_CLAROVIDEO_SVA.FLAG_ENVIO_EMAIL 
        is 'Flag de envio de email (0:No enviado, 1:Enviado)';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.OPE_TRX_CLAROVIDEO_SVA
  add constraint PK_OPE_TRX_CLAROVIDEO_SVA primary key (IDREGISTRO);
