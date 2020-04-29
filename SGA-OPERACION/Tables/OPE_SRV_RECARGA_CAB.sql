CREATE TABLE OPERACION.OPE_SRV_RECARGA_CAB
(
  NUMREGISTRO         CHAR(10 BYTE)             NOT NULL,
  CODIGO_RECARGA      VARCHAR2(8 BYTE),
  FECINIVIG           DATE,
  FECFINVIG           DATE,
  FECALERTA           DATE,
  FECCORTE            DATE,
  FLG_RECARGA         NUMBER(1)                 NOT NULL,
  TIPORECARGA         VARCHAR2(15 BYTE),
  CODCLI              CHAR(8 BYTE)              NOT NULL,
  NUMSLC              CHAR(10 BYTE)             NOT NULL,
  CODSOLOT            NUMBER(8)                 NOT NULL,
  IDPAQ               NUMBER(10)                NOT NULL,
  ESTADO              CHAR(2 BYTE)              NOT NULL,
  CODUSU              VARCHAR2(30 BYTE)         DEFAULT USER                  NOT NULL,
  FECUSU              DATE                      DEFAULT SYSDATE               NOT NULL,
  SERSUT              CHAR(3 BYTE),
  NUMSUT              CHAR(8 BYTE),
  TIPDOCFAC           CHAR(3 BYTE),
  TIPBQD              NUMBER(2),
  FLG_SC              NUMBER(1),
  FLG_TRANS_INT       NUMBER(1)                 DEFAULT 0,
  FEC_TRANS_INT       DATE,
  FLG_TRANS_INT_BAJA  NUMBER(1)                 DEFAULT 0,
  FEC_TRANS_INT_BAJA  DATE
);

COMMENT ON TABLE OPERACION.OPE_SRV_RECARGA_CAB IS 'Contiene los codigos de recarga de los proyectos asociados al cliente';

COMMENT ON COLUMN OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO IS 'Id de registro,se comparte con tabla REGINSDTH';

COMMENT ON COLUMN OPERACION.OPE_SRV_RECARGA_CAB.CODIGO_RECARGA IS 'Codigo de la recarga';

COMMENT ON COLUMN OPERACION.OPE_SRV_RECARGA_CAB.FECINIVIG IS 'Fecha de Inicio de vigencia de recarga';

COMMENT ON COLUMN OPERACION.OPE_SRV_RECARGA_CAB.FECFINVIG IS 'Fecha de Fin de vigencia de recarga';

COMMENT ON COLUMN OPERACION.OPE_SRV_RECARGA_CAB.FECALERTA IS 'Fecha de Alerta de vencimiento de recarga';

COMMENT ON COLUMN OPERACION.OPE_SRV_RECARGA_CAB.FECCORTE IS 'Fecha de corte (1 dia mas de la fecha de fin de vigencia)';

COMMENT ON COLUMN OPERACION.OPE_SRV_RECARGA_CAB.FLG_RECARGA IS 'Indica si el registro pertenece o no al sistema de recarga (1:Pertenece, 0:No pertenece)';

COMMENT ON COLUMN OPERACION.OPE_SRV_RECARGA_CAB.TIPORECARGA IS 'Indica el tipo de recarga';

COMMENT ON COLUMN OPERACION.OPE_SRV_RECARGA_CAB.CODCLI IS 'Codigo de cliente';

COMMENT ON COLUMN OPERACION.OPE_SRV_RECARGA_CAB.NUMSLC IS 'Numero de proyecto asociado a la recarga';

COMMENT ON COLUMN OPERACION.OPE_SRV_RECARGA_CAB.IDPAQ IS 'Codigo de paquete asociado al proyecto';

COMMENT ON COLUMN OPERACION.OPE_SRV_RECARGA_CAB.CODSOLOT IS 'Codigo de SOLOT';

COMMENT ON COLUMN OPERACION.OPE_SRV_RECARGA_CAB.ESTADO IS 'Estado del registro, tabla ope_estado_recarga';

COMMENT ON COLUMN OPERACION.OPE_SRV_RECARGA_CAB.CODUSU IS 'Usuario de registro';

COMMENT ON COLUMN OPERACION.OPE_SRV_RECARGA_CAB.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.OPE_SRV_RECARGA_CAB.SERSUT IS 'Serie de la factura de instalacion';

COMMENT ON COLUMN OPERACION.OPE_SRV_RECARGA_CAB.NUMSUT IS 'Numero de la factura de instalacion';

COMMENT ON COLUMN OPERACION.OPE_SRV_RECARGA_CAB.TIPDOCFAC IS 'Tipo de documento de la factura de instalacion';

COMMENT ON COLUMN OPERACION.OPE_SRV_RECARGA_CAB.TIPBQD IS 'Tipo de busqueda(1:código de Cliente,2:número telefónico,3:Páginas Claro,4:código de recarga)';

COMMENT ON COLUMN OPERACION.OPE_SRV_RECARGA_CAB.FLG_SC IS 'Identificador si es venta de Suma de Cargos';

COMMENT ON COLUMN OPERACION.OPE_SRV_RECARGA_CAB.FEC_TRANS_INT IS 'Fecha de transferencia a INT y CLARIFY.';

COMMENT ON COLUMN OPERACION.OPE_SRV_RECARGA_CAB.FLG_TRANS_INT IS 'Flag de transferencia a INT y CLARIFY, 0: No Transferido, 1: Transferido.';

COMMENT ON COLUMN OPERACION.OPE_SRV_RECARGA_CAB.FLG_TRANS_INT_BAJA IS 'Flag de transferencia de Baja a INT y CLARIFY, 0: No Transferido, 1: Transferido.';

COMMENT ON COLUMN OPERACION.OPE_SRV_RECARGA_CAB.FEC_TRANS_INT_BAJA IS 'Fecha de transferencia de Baja a INT y CLARIFY.';


