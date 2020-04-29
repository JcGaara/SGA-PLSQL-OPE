CREATE OR REPLACE PACKAGE operacion.pq_sva_claro_video IS
  /************************************************************************************************
  NOMBRE:     OPERACION.PQ_SVA_CLARO_VIDEO
  PROPOSITO:  SVA CLARO VIDEO
  
  REVISIONES:
   Version   Fecha          Autor                 Solicitado por      Descripcion
  --------   ----------    ------------------    -----------------    ------------------------
   1.0       21/04/2014    Luis Polo Benites     Alex Alamo           REQ-164966: Servicios SVA a traves de la Fija-Claro Video.
   2.0       20/08/2015    Luis Polo Benites     Fausto Soriano       SD 425564:  Mejoras en Lista de Proyectos -Servicios SVA a traves de la Fija.   
  /************************************************************************************************/
  cv_ser_internet  CONSTANT VARCHAR2(4) := '0006';
  cv_ser_cable     CONSTANT VARCHAR2(4) := '0062';
  cv_ser_telefonia CONSTANT VARCHAR2(4) := '0004';
  cv_ser_casilla   CONSTANT VARCHAR2(4) := '0025';

  PROCEDURE p_obt_list_proy_pq_hfc(av_codcliente    IN VARCHAR2,
                                   ac_list_proy_hfc OUT SYS_REFCURSOR,
                                   an_resultado     OUT NUMBER,
                                   ac_mensaje       OUT VARCHAR2); --2.0

  PROCEDURE p_obt_sid_principal_hfc(av_numslc    IN VARCHAR2,
                                    an_codinssrv OUT NUMBER,
                                    an_resultado OUT NUMBER,
                                    ac_mensaje   OUT VARCHAR2);

  FUNCTION f_obt_sid(av_numslc IN VARCHAR2) RETURN NUMBER; --2.0

  FUNCTION f_cant_servicios(av_codcliente IN VARCHAR2) RETURN VARCHAR2; --2.0
END;
/