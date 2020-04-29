CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_JANUS_CE IS
  /******************************************************************************
   PROPOSITO:
  
   REVISIONES:
     Version  Fecha       Autor            Solicitado por      Descripcion
     -------  -----       -----             --------------      -----------
     1.0    2014-06-26    Eustaquio Gibaja  Christian Riquelme  version inicial
     2.0    2014-10-22    Edwin Vasquez     Christian Riquelme  Claro Empresas WiMAX
  /* ***************************************************************************/
  PROCEDURE insert_int_plataforma_bscs(p_int_bscs IN OUT int_plataforma_bscs%ROWTYPE) IS
  BEGIN
    p_int_bscs.codusu := USER;
    p_int_bscs.fecusu := SYSDATE;
  
    INSERT INTO int_plataforma_bscs
    VALUES p_int_bscs
    RETURNING idtrans INTO p_int_bscs.idtrans;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.INSERT_PLATAFORMA_BSCS: ' ||
                              SQLERRM);
  END;
  /* ***************************************************************************/
 PROCEDURE crear_tareawfseg IS
    --l_tareawfseg tareawfseg%ROWTYPE;
  BEGIN
    null;
    /*l_tareawfseg.idtareawf   := pq_telefonia_ce.g_idtareawf;
    l_tareawfseg.observacion := pq_janus_ce_conexion.g_mensaje;
    pq_telefonia_ce.insert_tareawfseg(l_tareawfseg);*/
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CREAR_TAREAWFSEG: ' || SQLERRM);
  END;
  /* ***************************************************************************/  
function insert_int_plataforma_bscs(p_int_plataforma_bscs int_plataforma_bscs%rowtype)
    return int_plataforma_bscs.idtrans%type is
    l_idtrans int_plataforma_bscs.idtrans%type;
  
  begin
    insert into int_plataforma_bscs
      (idtrans,
       codigo_cliente,
       codigo_cuenta,
       ruc,
       nombre,
       apellidos,
       tipdide,
       ntdide,
       razon,
       telefonor1,
       telefonor2,
       email,
       direccion,
       referencia,
       distrito,
       provincia,
       departamento,
       co_id,
       numero,
       imsi,
       ciclo,
       action_id,
       trama,
       plan_base,
       plan_opcional,
       plan_old,
       plan_opcional_old,
       numero_old,
       imsi_old,
       codusu,
       fecusu,
       usumod,
       fecmod,
       resultado,
       message_resul)
    values
      (p_int_plataforma_bscs.idtrans,
       p_int_plataforma_bscs.codigo_cliente,
       p_int_plataforma_bscs.codigo_cuenta,
       p_int_plataforma_bscs.ruc,
       p_int_plataforma_bscs.nombre,
       p_int_plataforma_bscs.apellidos,
       p_int_plataforma_bscs.tipdide,
       p_int_plataforma_bscs.ntdide,
       p_int_plataforma_bscs.razon,
       p_int_plataforma_bscs.telefonor1,
       p_int_plataforma_bscs.telefonor2,
       p_int_plataforma_bscs.email,
       p_int_plataforma_bscs.direccion,
       p_int_plataforma_bscs.referencia,
       p_int_plataforma_bscs.distrito,
       p_int_plataforma_bscs.provincia,
       p_int_plataforma_bscs.departamento,
       p_int_plataforma_bscs.co_id,
       p_int_plataforma_bscs.numero,
       p_int_plataforma_bscs.imsi,
       p_int_plataforma_bscs.ciclo,
       p_int_plataforma_bscs.action_id,
       p_int_plataforma_bscs.trama,
       p_int_plataforma_bscs.plan_base,
       p_int_plataforma_bscs.plan_opcional,
       p_int_plataforma_bscs.plan_old,
       p_int_plataforma_bscs.plan_opcional_old,
       p_int_plataforma_bscs.numero_old,
       p_int_plataforma_bscs.imsi_old,
       p_int_plataforma_bscs.codusu,
       p_int_plataforma_bscs.fecusu,
       p_int_plataforma_bscs.usumod,
       p_int_plataforma_bscs.fecmod,
       p_int_plataforma_bscs.resultado,
       p_int_plataforma_bscs.message_resul)
    returning idtrans into l_idtrans;
  
    return l_idtrans;
  
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.insert_int_plataforma_bscs() ' ||
                              sqlerrm);
  end;
  /* ***************************************************************************/
 FUNCTION get_conf(p_param VARCHAR2) RETURN opedd.codigoc%TYPE IS
    l_conf opedd.codigoc%TYPE;
  
  BEGIN
    SELECT o.codigoc
      INTO l_conf
      FROM tipopedd t, opedd o
     WHERE t.tipopedd = o.tipopedd
       AND t.abrev LIKE '%PAR_PLATAF_JANUS%'
       AND TRIM(o.abreviacion) = TRIM(p_param);
  
    RETURN l_conf;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000, $$PLSQL_UNIT || '.GET_CONF: ' || SQLERRM);
  END;
  /* ***************************************************************************/

PROCEDURE update_int_plataforma_bscs IS
  BEGIN
     null;
    /*UPDATE int_plataforma_bscs
       SET resultado     = pq_janus_ce_conexion.g_codigo,
           message_resul = pq_janus_ce_conexion.g_mensaje
     WHERE idtrans = g_idtrans;*/
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.UPDATE_INT_PLATAFORMA_BSCS: ' ||
                              SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION get_config(p_param opedd.abreviacion%TYPE) RETURN opedd.codigoc%TYPE IS
    l_config opedd.codigoc%TYPE;
  
  BEGIN
    SELECT o.codigoc
      INTO l_config
      FROM tipopedd t, opedd o
     WHERE t.abrev = 'PLAT_JANUS'
       AND t.tipopedd = o.tipopedd
       AND o.abreviacion = p_param
       AND o.codigon = 1;
  
    RETURN l_config;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_CONFIG: ' || SQLERRM);
  END;
  /* ***************************************************************************/
 function get(p_idtrans int_plataforma_bscs.idtrans%type)
    return operacion.int_plataforma_bscs%rowtype is
    l_int_plataforma_bscs operacion.int_plataforma_bscs%rowtype;
  
  begin
    select t.*
      into l_int_plataforma_bscs
      from int_plataforma_bscs t
     where idtrans = p_idtrans;
  
    return l_int_plataforma_bscs;
  
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.get(p_idtrans => ) ' ||
                              p_idtrans || ') ' || sqlerrm);
  end;
  --------------------------------------------------------------------------------
END;
/