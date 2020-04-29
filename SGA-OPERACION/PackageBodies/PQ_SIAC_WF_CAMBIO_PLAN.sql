create or replace package body operacion.PQ_SIAC_WF_CAMBIO_PLAN is
  /************************************************************************************************
  NOMBRE:     OPERACION.PQ_SIAC_CAMBIO_PLAN
  PROPOSITO:  Generar WF Cambio de Plan

  REVISIONES:
   Version   Fecha          Autor            Solicitado por      Descripcion
   -------- ----------  ------------------   -----------------   ------------------------
   1.0      06/08/2014   Alex Alamo           Hector Huaman       Generar WF Cambio de Plan
   2.0      15/09/2014   Jimmy Calle          Hector Huaman       Mejora en Proyecto de SIAC Cambio de Plan
   3.0      2015-07-09   Freddy Gonzales      Hector Huaman       SD-335922 - SOTs con dirección errada
   4.0      15/12/2015   Dorian Sucasaca                          PQT-247649-TSK-76965
   5.0      27/11/2017   Servicio Fallas-HITSS                    INC000000989746
  /************************************************************************************************/

PROCEDURE asigna_numero_siac_cp(p_idtareawf IN NUMBER,
                                p_idwf      IN NUMBER,
                                p_tarea     IN NUMBER,
                                p_tareadef  IN NUMBER) IS

  l_codsolot   solot.codsolot%TYPE;
  l_inssrv     inssrv%ROWTYPE;
  l_inssrv_old inssrv%ROWTYPE;
  l_codnumtel  numtel.codnumtel%TYPE;
  l_stmt       VARCHAR2(32767);
BEGIN
  g_idtareawf := p_idtareawf;
  g_idwf      := p_idwf;
  g_tarea     := p_tarea;
  g_tareadef  := p_tareadef;

  IF NOT existe_telefonia() THEN
    no_interviene();
    RETURN;
  END IF;

  l_codsolot := get_codsolot();

  IF tenia_telefonia_old(l_codsolot) THEN
    l_inssrv_old := get_inssrv_old(l_codsolot);
    l_inssrv     := get_inssrv();

    UPDATE numtel
       SET estnumtel = 2,
           codinssrv = l_inssrv.codinssrv,
           codusuasg = USER,
           fecasg    = SYSDATE
     WHERE codinssrv = l_inssrv_old.codinssrv;

    SELECT codnumtel
      INTO l_codnumtel
      FROM numtel
     WHERE numero = l_inssrv_old.numero;

    UPDATE reservatel
       SET estnumtel = 2, numslc = l_inssrv.numslc, codcli = l_inssrv.codcli
     WHERE codnumtel = l_codnumtel;

    UPDATE inssrv
       SET numero = l_inssrv_old.numero
     WHERE codinssrv = l_inssrv.codinssrv;

  ELSE
    --Asignar Numero Tefonico
    /*    intraway.pq_sots_agendadas.p_asignar_numero(g_idtareawf,
    g_idwf,
    g_tarea,
    g_tareadef);*/
    -- ini 4.0
    if operacion.pq_siac_cambio_plan_lte.fnc_valida_cp_lte(l_codsolot) = 0 then 
      operacion.pq_cuspe_ope.p_asig_numtelef_wf(g_idtareawf,
                                                g_idwf,
                                                g_tarea,
                                                g_tareadef);
    end if;
    -- fin 4.0
  END IF;

  cierre_tarea();

EXCEPTION
  WHEN OTHERS THEN
    l_stmt := 'OPERACION.PQ_SIAC_WF_CAMBIO_PLAN :' || l_codsolot ||
              ' Error en la Asignacion del Numero Telefonico: ' || SQLERRM;

    opewf.pq_send_mail_job.p_send_mail('OPERACION.PQ_SIAC_WF_CAMBIO_PLAN.asigna_numero_siac_cp',
                                       'DL-PE-ITSoportealNegocio@claro.com.pe',
                                       l_stmt);
END;
/* **********************************************************************************************/

FUNCTION existe_telefonia RETURN BOOLEAN IS
  l_count PLS_INTEGER;

BEGIN
  SELECT COUNT(*)
    INTO l_count
    FROM wf w, solotpto s, inssrv i
   WHERE w.idwf = g_idwf
     AND w.codsolot = s.codsolot
     AND s.codinssrv = i.codinssrv
     AND i.tipinssrv = 3;

  RETURN l_count > 0;
END;
/* ***************************************************************************/
PROCEDURE no_interviene IS
BEGIN
  opewf.pq_wf.p_chg_status_tareawf(pq_int_telefonia.g_idtareawf,
                                   4, --Cerrada
                                   8, --No interviene
                                   0,
                                   SYSDATE,
                                   SYSDATE);
EXCEPTION
  WHEN OTHERS THEN
    raise_application_error(-20000,
                            $$PLSQL_UNIT || '.NO_INTERVIENE: ' || SQLERRM);
END;
/* ***************************************************************************/

FUNCTION get_codsolot RETURN solot.codsolot%TYPE IS
  l_codsolot solot.codsolot%TYPE;

BEGIN
  SELECT t.codsolot INTO l_codsolot FROM wf t WHERE t.idwf = g_idwf;
  RETURN l_codsolot;

EXCEPTION
  WHEN OTHERS THEN
    raise_application_error(-20000,
                            $$PLSQL_UNIT || '.GET_CODSOLOT: ' || SQLERRM);
END;
  --------------------------------------------------------------------------------
  function tenia_telefonia_old(p_codsolot solot.codsolot%type) return boolean is
    c_telefonia constant tipinssrv.tipinssrv%type := 3;
    l_count pls_integer;
  
  begin
    select count(*)
      into l_count
      from inssrv i,
           (select r.numslc_ori
              from regvtamentab r, solot s
             where r.numslc = s.numslc
               and s.codsolot = p_codsolot) a
     where i.numslc = a.numslc_ori
       and i.tipinssrv = c_telefonia
       and i.estinssrv in (select d.codigon
                             from tipopedd c,
                                  opedd    d
                            where c.tipopedd = d.tipopedd
                              and c.abrev = 'EST_CAMB_PLAN'
                              and d.abreviacion = 'ESTINSSRV_CP'
                              and d.codigon_aux = 1); --5.0
  
    return l_count > 0;
  end;
  --------------------------------------------------------------------------------
  function get_inssrv_old(p_codsolot solot.codsolot%type) return inssrv%rowtype is
    c_telefonia constant tipinssrv.tipinssrv%type := 3;
    l_inssrv inssrv%rowtype;
  
  begin
    select distinct i.*
      into l_inssrv
      from inssrv i,
           numtel t,
           (select r.numslc_ori
              from regvtamentab r, solot s
             where r.numslc = s.numslc
               and s.codsolot = p_codsolot) a
     where i.numslc = a.numslc_ori
       and i.codinssrv = t.codinssrv(+)
       and i.tipinssrv = C_TELEFONIA
       and rownum < 2;
  
    return l_inssrv;
  
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.' || 'get_inssrv_old: ' ||
                              'p_codsolot = ' || p_codsolot || ' - ' || sqlerrm);
  end;
/* **********************************************************************************************/
FUNCTION get_inssrv RETURN inssrv%ROWTYPE IS
  c_telefonia CONSTANT tipinssrv.tipinssrv%TYPE := 3;
  C_CANCELADO CONSTANT inssrv.estinssrv%TYPE:= 3;
  l_inssrv inssrv%ROWTYPE;

BEGIN

  SELECT distinct i.*
    INTO l_inssrv
    FROM wf w, solotpto s, inssrv i
   WHERE w.idwf = g_idwf
     AND w.codsolot = s.codsolot
     AND s.codinssrv = i.codinssrv
     AND i.tipinssrv = c_telefonia
     AND i.estinssrv != C_CANCELADO;

  RETURN l_inssrv;

EXCEPTION
  WHEN OTHERS THEN
    raise_application_error(-20000,
                            $$PLSQL_UNIT || '.' || 'get_inssrv: ' || SQLERRM);
END;
/* **********************************************************************************************/
PROCEDURE cierre_tarea IS
BEGIN
  opewf.pq_wf.p_chg_status_tareawf(g_idtareawf,
                                   4, --Cerrada
                                   4, --Cerrada
                                   0,
                                   SYSDATE,
                                   SYSDATE);
EXCEPTION
  WHEN OTHERS THEN
    raise_application_error(-20000,
                            $$PLSQL_UNIT || '.CIERRE_TAREA: ' || SQLERRM);
END;
/* **********************************************************************************************/
PROCEDURE baja_sisac_cp(p_idtareawf IN NUMBER,
                        p_idwf      IN NUMBER,
                        p_tarea     IN NUMBER,
                        p_tareadef  IN NUMBER) IS
  l_reason   NUMBER;
  l_username VARCHAR(50);

  l_request_id NUMBER;
  l_co_id      inssrv.co_id%TYPE;
  l_msj        tareawfseg.observacion%TYPE;

BEGIN
  g_idtareawf := p_idtareawf;
  g_idwf      := p_idwf;
  g_tarea     := p_tarea;
  g_tareadef  := p_tareadef;

  l_co_id := get_co_id();

  SELECT o.codigoc
    INTO l_reason
    FROM opedd o, tipopedd t
   WHERE o.tipopedd = t.tipopedd
     AND t.abrev = 'BAJA_HFC_BSCS'
     AND o.abreviacion = 'REASON';

  SELECT o.codigoc
    INTO l_username
    FROM opedd o, tipopedd t
   WHERE o.tipopedd = t.tipopedd
     AND t.abrev = 'BAJA_HFC_BSCS'
     AND o.abreviacion = 'USERNAME';

  --Envio a BSCS para la baja total
  TIM.TIM111_PKG_ACCIONES.SP_CONTRACT_DEACTIVATION@DBL_BSCS_BF(l_co_id,
                                                               l_reason,
                                                               l_username,
                                                               l_request_id);

  --   DBL_BSCS_BF.SP_CONTRACT_DEACTIVATION(l_co_id,C_REASON,C_USERNAME,l_request_id);

  IF l_request_id != 1 THEN
    l_msj := 'Error al realizar la Baja Total del Servicio por BSCS';
    crear_tareawfseg(l_msj);
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    raise_application_error(-20000,
                            $$PLSQL_UNIT || '.BAJA_SISAC_CP: ' || SQLERRM);

END;
/* **********************************************************************************************/
FUNCTION get_co_id RETURN inssrv.co_id%TYPE IS
  l_co_id inssrv.co_id%TYPE;
  C_CANCELADO CONSTANT inssrv.estinssrv%TYPE:= 3;

BEGIN

  SELECT i.co_id
    INTO l_co_id
    FROM wf w, solotpto s, inssrv i
   WHERE w.idwf = g_idwf
     AND w.codsolot = s.codsolot
     AND s.codinssrv = i.codinssrv
     AND i.estinssrv != C_CANCELADO
     AND rownum = 1
     AND i.co_id IS NOT NULL;

  RETURN l_co_id;

EXCEPTION
  WHEN OTHERS THEN
    raise_application_error(-20000,
                            $$PLSQL_UNIT || '.' || 'get_co_id: ' || SQLERRM);
END;
/* **********************************************************************************************/
PROCEDURE insert_tareawfseg(p_tareawfseg IN OUT NOCOPY tareawfseg%ROWTYPE) IS
BEGIN
  p_tareawfseg.fecusu := SYSDATE;
  p_tareawfseg.codusu := USER;
  p_tareawfseg.flag   := 0;

  INSERT INTO tareawfseg VALUES p_tareawfseg;

EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20000,
                            $$PLSQL_UNIT || '.INSERT_TAREAWFSEG: ' || SQLERRM);
END;
/****************************************************************************/
PROCEDURE crear_tareawfseg(p_mensaje tareawfseg.observacion%TYPE) IS
  l_tareawfseg tareawfseg%ROWTYPE;
BEGIN
  l_tareawfseg.idtareawf   := g_idtareawf;
  l_tareawfseg.observacion := p_mensaje;

  insert_tareawfseg(l_tareawfseg);

EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20000,
                            $$PLSQL_UNIT || '.CREAR_TAREAWFSEG: ' || SQLERRM);
END;
END;
/