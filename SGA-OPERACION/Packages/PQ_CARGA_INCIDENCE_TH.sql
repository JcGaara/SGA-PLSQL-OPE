CREATE OR REPLACE PACKAGE OPERACION.PQ_CARGA_INCIDENCE_TH IS
  /*******************************************************************************************************
    NOMBRE:       OPERACION.PQ_CONCILIACION_HFC
    PROPOSITO:
    REVISIONES:
    Version    Fecha       Autor            Solicitado por    Descripcion
    ---------  ----------  ---------------  --------------    -----------------------------------------
     1.0       01/03/2017  Luis Flores      Luis Flores       Cargar incidencias
  *******************************************************************************************************/
    PROCEDURE P_CARGA_INCIDENCE_TMP;

    PROCEDURE p_carga_incidence_ln;

    PROCEDURE p_carga_incidence_bl(an_idproceso NUMBER, an_idtarea NUMBER);

    PROCEDURE p_ThreadRun(av_username  VARCHAR2,
                          av_password  VARCHAR2,
                          av_url       VARCHAR2,
                          av_nsp       VARCHAR2,
                          an_idproceso NUMBER,
                          an_hilos     IN NUMBER);

    FUNCTION f_getConstante(av_constante operacion.constante.constante%TYPE) RETURN VARCHAR2;

    PROCEDURE P_GRABA_LOG_CARGA_INCIDENCE(nIdTipoLog number, vDescripcion varchar2);
    
    PROCEDURE p_genera_imagen_mensual_bl(an_idproceso NUMBER, an_idtarea NUMBER);
END;
/