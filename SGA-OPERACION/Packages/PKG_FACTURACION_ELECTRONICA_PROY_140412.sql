CREATE OR REPLACE PACKAGE OPERACION.PKG_FACTURACION_ELECTRONICA IS

/**********************************************************************************
                        HISTORIAL DE REVISIONES
-----------------------------------------------------------------------------------
VERSIÓN   FECHA         AUTOR                  DESCRIPCIÓN
-----------------------------------------------------------------------------------
1.0       02/12/2019    Fernando Villarruel    CREACIÓN
***********************************************************************************/

  PROCEDURE SGASS_GET_REC_PEND_ENVIO_ANU(PI_FECHA         IN DATE,
                                         PO_COD_RESULTADO OUT VARCHAR2,
                                         PO_MSG_RESULTADO OUT VARCHAR2);

  PROCEDURE SGASS_GET_REC_PEND_ENVIO_EMI(PI_FECHA         IN DATE,
                                         PO_COD_RESULTADO OUT VARCHAR2,
                                         PO_MSG_RESULTADO OUT VARCHAR2);

  PROCEDURE SGASS_COUNT_REC_PEND_ENV(PI_FECHA         IN DATE,
                                         PI_TIPO          IN CHAR,
                                         PO_DETALLE       OUT VARCHAR2,
                                         PO_COD_RESULTADO OUT VARCHAR2,
                                         PO_MSG_RESULTADO OUT VARCHAR2);

  PROCEDURE SGASI_DOCS_ELECS(PI_TIPDOC      IN VARCHAR2,
                             PI_SERSUT      IN VARCHAR2,
                             PI_NUMSUT      IN VARCHAR2,
                             PI_NOMBRE_ARCH IN VARCHAR2,
                             PI_TIPO_LOTE   IN VARCHAR2,
                             PI_ESTADO      IN VARCHAR2,
                             PI_OBSERVACION IN VARCHAR2,
                             
                             PI_USUARIO       IN VARCHAR2,
                             PO_COD_RESULTADO OUT VARCHAR2,
                             PO_MSG_RESULTADO OUT VARCHAR2);

END PKG_FACTURACION_ELECTRONICA;
/