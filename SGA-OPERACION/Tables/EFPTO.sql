CREATE TABLE OPERACION.EFPTO
(
  CODEF              NUMBER(8)                  NOT NULL,
  PUNTO              NUMBER(10)                 NOT NULL,
  DESCRIPCION        VARCHAR2(100 BYTE),
  CODINSSRV          NUMBER(10),
  CODSUC             CHAR(10 BYTE),
  CODUBI             CHAR(10 BYTE),
  POP                NUMBER(10),
  DIRECCION          VARCHAR2(480 BYTE),
  CODSRV             CHAR(4 BYTE),
  BW                 NUMBER(10,2)               DEFAULT 0                     NOT NULL,
  COSMO              NUMBER(10,2)               DEFAULT 0                     NOT NULL,
  COSMAT             NUMBER(10,2)               DEFAULT 0                     NOT NULL,
  COSEQU             NUMBER(10,2)               DEFAULT 0                     NOT NULL,
  COSMOCLI           NUMBER(10,2)               DEFAULT 0                     NOT NULL,
  COSMATCLI          NUMBER(10,2)               DEFAULT 0                     NOT NULL,
  FECINI             DATE                       DEFAULT sysdate,
  NUMDIAPLA          NUMBER(3),
  FECFIN             DATE,
  OBSERVACION        VARCHAR2(500 BYTE),
  COORDX1            VARCHAR2(3 BYTE),
  COORDY1            NUMBER(3),
  COORDX2            VARCHAR2(3 BYTE),
  COORDY2            NUMBER(3),
  FECUSU             DATE                       DEFAULT SYSDATE               NOT NULL,
  CODUSU             VARCHAR2(30 BYTE)          DEFAULT user                  NOT NULL,
  TIPTRA             NUMBER(4),
  NROLINEAS          NUMBER(3),
  NROFACREC          NUMBER(2),
  NROHUNG            NUMBER(2),
  NROIGUAL           NUMBER(2),
  COSMO_S            NUMBER(10,2)               DEFAULT 0                     NOT NULL,
  COSMAT_S           NUMBER(10,2)               DEFAULT 0                     NOT NULL,
  CODTIPFIBRA        NUMBER(2),
  LONFIBRA           NUMBER(8,2),
  ACTCAD             NUMBER(1)                  DEFAULT 0,
  NROCANAL           NUMBER(3)                  DEFAULT 0,
  TIPTRAEF           NUMBER(4),
  TIPRECHAZO_OPE     NUMBER(2),
  TIPRECHAZO_FNZ     NUMBER(2),
  CODCON             NUMBER(6),
  FECCONASIG         DATE,
  FECCONFIN          DATE,
  CONATRASO          NUMBER(5),
  LOGIN              VARCHAR2(50 BYTE),
  DOMINIO            VARCHAR2(50 BYTE),
  MEDIOTX            NUMBER(2),
  PROVENLACE         NUMBER(3),
  FLAGN_WIRELESS     NUMBER,
  CODCONPIN          NUMBER(6),
  ESTCODCONPIN       NUMBER(1),
  FECPINDERIVA       DATE,
  FECPININI          DATE,
  FECPINFIN          DATE,
  FECCONASIG_SOP     DATE,
  DERIVASOPORTEOPER  NUMBER(1)                  DEFAULT 0,
  FECDERIVA_PEXT     DATE
);

COMMENT ON TABLE OPERACION.EFPTO IS 'Detalle del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTO.DERIVASOPORTEOPER IS 'Indica si la factibilidad se derivo para que la atienda Soporte a la Operación';

COMMENT ON COLUMN OPERACION.EFPTO.BW IS 'Ancho de banda';

COMMENT ON COLUMN OPERACION.EFPTO.COSMO IS 'Costo de mano de obra';

COMMENT ON COLUMN OPERACION.EFPTO.COSMAT IS 'Costo del material';

COMMENT ON COLUMN OPERACION.EFPTO.COSEQU IS 'Costo del equipo';

COMMENT ON COLUMN OPERACION.EFPTO.COSMOCLI IS 'Costo de mano de obra';

COMMENT ON COLUMN OPERACION.EFPTO.COSMATCLI IS 'Costo del material';

COMMENT ON COLUMN OPERACION.EFPTO.FECINI IS 'Fecha de inicio';

COMMENT ON COLUMN OPERACION.EFPTO.NUMDIAPLA IS 'Numero de dias de plazo';

COMMENT ON COLUMN OPERACION.EFPTO.FECFIN IS 'Fecha de fin';

COMMENT ON COLUMN OPERACION.EFPTO.OBSERVACION IS 'Observación';

COMMENT ON COLUMN OPERACION.EFPTO.COORDX1 IS 'Indica las coordenadas x';

COMMENT ON COLUMN OPERACION.EFPTO.COORDY1 IS 'Indica las coordenadas y';

COMMENT ON COLUMN OPERACION.EFPTO.COORDX2 IS 'Indica las coordenadas x';

COMMENT ON COLUMN OPERACION.EFPTO.COORDY2 IS 'Indica las coordenadas y';

COMMENT ON COLUMN OPERACION.EFPTO.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.EFPTO.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.EFPTO.TIPTRA IS 'Codigo del tipo de trabajo';

COMMENT ON COLUMN OPERACION.EFPTO.NROLINEAS IS 'Cantidad de lineas';

COMMENT ON COLUMN OPERACION.EFPTO.NROFACREC IS 'Numero de facil recordación';

COMMENT ON COLUMN OPERACION.EFPTO.NROHUNG IS 'Numero hunting';

COMMENT ON COLUMN OPERACION.EFPTO.NROIGUAL IS 'Cantidad de Numero igual entre el hunting y facil recordación';

COMMENT ON COLUMN OPERACION.EFPTO.COSMO_S IS 'Costo de mano de obra en soles';

COMMENT ON COLUMN OPERACION.EFPTO.COSMAT_S IS 'Costo del material en soles';

COMMENT ON COLUMN OPERACION.EFPTO.CODTIPFIBRA IS 'Codigo del tipo de fibra';

COMMENT ON COLUMN OPERACION.EFPTO.LONFIBRA IS 'Longitud de fibra';

COMMENT ON COLUMN OPERACION.EFPTO.ACTCAD IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.EFPTO.NROCANAL IS 'Numero de canal';

COMMENT ON COLUMN OPERACION.EFPTO.TIPTRAEF IS 'Codigo del tipo de trabajo de estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTO.TIPRECHAZO_OPE IS 'Tipo de rechazo de operacion';

COMMENT ON COLUMN OPERACION.EFPTO.TIPRECHAZO_FNZ IS 'Tipo de rechazo financiero';

COMMENT ON COLUMN OPERACION.EFPTO.CODCON IS 'Codigo del contratista';

COMMENT ON COLUMN OPERACION.EFPTO.FECCONASIG IS 'Fecha de contratista asignado';

COMMENT ON COLUMN OPERACION.EFPTO.FECCONFIN IS 'Fecha de contratista final';

COMMENT ON COLUMN OPERACION.EFPTO.CONATRASO IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.EFPTO.LOGIN IS 'Login';

COMMENT ON COLUMN OPERACION.EFPTO.DOMINIO IS 'Dominio del ef';

COMMENT ON COLUMN OPERACION.EFPTO.MEDIOTX IS 'Ultima milla';

COMMENT ON COLUMN OPERACION.EFPTO.PROVENLACE IS 'Proveedor ultima milla';

COMMENT ON COLUMN OPERACION.EFPTO.CODEF IS 'Codigo del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTO.PUNTO IS 'Punto de estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTO.DESCRIPCION IS 'Descripcion del punto del ef';

COMMENT ON COLUMN OPERACION.EFPTO.CODINSSRV IS 'Codigo de instancia de servicio';

COMMENT ON COLUMN OPERACION.EFPTO.CODSUC IS 'Codigo de la sucursal';

COMMENT ON COLUMN OPERACION.EFPTO.CODUBI IS 'Codigo del distrito';

COMMENT ON COLUMN OPERACION.EFPTO.POP IS 'POP';

COMMENT ON COLUMN OPERACION.EFPTO.DIRECCION IS 'DIRECCION';

COMMENT ON COLUMN OPERACION.EFPTO.CODSRV IS 'Codigo de servicio';

COMMENT ON COLUMN OPERACION.EFPTO.FECCONASIG_SOP IS 'Fecha de contratista asignado-SOP';

COMMENT ON COLUMN OPERACION.EFPTO.FECDERIVA_PEXT IS 'Fecha de derivación de Planta Externa.';


