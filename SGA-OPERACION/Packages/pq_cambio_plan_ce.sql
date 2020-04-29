CREATE OR REPLACE PACKAGE OPERACION.pq_cambio_plan_ce IS
  /************************************************************************************************
  NOMBRE:     INTRAWAY.PQ_INT_CAMBIOPLAN
  PROPOSITO:  Generacion de Cambio de Plan a Intraway
  
  REVISIONES:
   Version   Fecha          Autor            Solicitado por      Descripcion
   -------- ----------  ------------------   -----------------   ------------------------
   1.0      13/01/2014  Juan Pablo Ramos     Giovanni Vasquez    PROY-17292 Cambio Plan CE en HFC.
  /************************************************************************************************/
  PROCEDURE p_asigna_numero_wf(an_idtareawf IN NUMBER,
                               an_idwf      IN NUMBER,
                               an_tarea     IN NUMBER,
                               an_tareadef  IN NUMBER);

  PROCEDURE p_reserva_numero(an_idtareawf IN NUMBER,
                             an_codsolot  IN solot.codsolot%TYPE);

  PROCEDURE p_asigna_numero(an_idtareawf IN NUMBER,
                            an_codsolot  IN solot.codsolot%TYPE);

  PROCEDURE p_registro_error(an_idtareawf IN tareawf.idtareawf%TYPE,
                             av_mensaje   IN VARCHAR2);

  PROCEDURE p_crea_tareawfseg(an_idtareawf IN tareawf.idtareawf%TYPE,
                              av_mensaje   IN tareawfseg.observacion%TYPE);

  PROCEDURE p_con_error(an_idtareawf IN NUMBER);

  PROCEDURE p_update_estnumtel(an_codnumtel IN numtel.codnumtel%TYPE,
                               an_estnumtel IN numtel.estnumtel%TYPE);

  PROCEDURE p_obtiene_linea_prin(an_codsolot  IN solot.codsolot%TYPE,
                                 an_codinssrv OUT inssrv.codinssrv%TYPE);

  FUNCTION f_existe_telefonia(an_codsolot IN solot.codsolot%TYPE)
    RETURN BOOLEAN;

  FUNCTION f_existe_reserva(av_numslc vtatabslcfac.numslc%TYPE)
    RETURN BOOLEAN;

  FUNCTION f_existe_reserva_num(an_pid IN solotpto.pid%TYPE) RETURN BOOLEAN;

  FUNCTION f_existe_numero_asig(an_codnumtel IN numtel.codnumtel%TYPE)
    RETURN BOOLEAN;

  FUNCTION f_formato_msg(av_mensaje IN VARCHAR2) RETURN VARCHAR2;

  FUNCTION f_obtiene_codnumtel(av_numero IN numtel.numero%TYPE)
    RETURN numtel.codnumtel%TYPE;

  FUNCTION f_obtiene_codinssrv(av_numslc IN vtatabslcfac.numslc%TYPE,
                               av_numpto IN inssrv.numpto%TYPE)
    RETURN inssrv.codinssrv%TYPE;

  FUNCTION f_obtiene_grupotel(an_codnumtel IN NUMBER, an_codcab IN NUMBER)
    RETURN NUMBER;

  FUNCTION f_obtiene_hunting(an_codnumtel IN NUMBER) RETURN NUMBER;

  FUNCTION f_obtiene_numslc(an_codsolot IN solot.codsolot%TYPE)
    RETURN vtatabslcfac.numslc%TYPE;

  FUNCTION f_obtiene_sid_numero(an_codinssrv IN inssrv.codinssrv%TYPE)
    RETURN numtel.numero%TYPE;

  FUNCTION f_obtiene_sot(an_idwf IN NUMBER) RETURN solot.codsolot%TYPE;

  FUNCTION f_obtiene_valor_lista(av_lista  VARCHAR2,
                                 an_indice NUMBER,
                                 ac_delim  VARCHAR2) RETURN VARCHAR2;

  FUNCTION f_obtiene_zona_aut RETURN NUMBER;
END;
/