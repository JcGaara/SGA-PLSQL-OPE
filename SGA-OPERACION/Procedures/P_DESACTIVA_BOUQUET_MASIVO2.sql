CREATE OR REPLACE PROCEDURE operacion.p_desactiva_bouquet_masivo2(p_numregistro IN VARCHAR2,
                                                                  p_bouquets    IN VARCHAR2,
                                                                  p_fecini      IN VARCHAR2,
                                                                  p_fecfin      IN VARCHAR2,
                                                                  p_resultado   IN OUT VARCHAR2,
                                                                  p_mensaje     IN OUT VARCHAR2) is
  /******************************************************************************
     NOMBRE:       p_desactiva_bouquet_masivo2
     PROPOSITO:
  
     REVISIONES:
     Ver        Fecha        Autor           Solicitado por Descripcion
     ---------  ----------  ---------------  -------------  -----------------------
      1.0                                                   Creaci�n
      2.0       14/09/2010  Joseph Asencios  Juan Gallegos  REQ 142589: Adecuaciones por ampliaci�n del campo codigo_ext(tystabsrv)
      3.0      01/12/2014   Jorge Armas      Manuel Gallegos   PROY-17565-  Aprovisionamiento DTH Prepago - INTRAWAY
  *********************************************************************/

  p_text_io         UTL_FILE.FILE_TYPE;
  l_numconax        number;
  l_numtransacconax number(15);
  n_largo           number;
  numbouquets       number;
  lcantidad         number(15);
  s_numconax        varchar2(6);
  --pArchivoLocalenv    varchar2(30);
  /*  pHost               varchar2(50);
  pPuerto             varchar2(10);
  pUsuario            varchar2(50);
  pPass               varchar2(50);
  pDirectorio         varchar2(50);
  pArchivoRemotoreq   varchar2(50);*/
  --ini 2.0
  /*s_bouquets          VARCHAR2(100);*/
  s_bouquets tystabsrv.codigo_ext%type;
  --pArchivoRemotoreq   varchar2(50);
  --fin 2.0
  p_nombre    varchar2(15);
  pcantidad   varchar2(5);
  s_codext    varchar2(10);
  pidtarjeta  varchar2(11);
  l_cantidad1 number;
  connex_i    operacion.conex_intraway; --3.0

  cursor c_tarjetas is
    select distinct idtarjeta
      from operacion.tmp_tarjetas
     where flg_incluido = 1
     order by idtarjeta asc;

BEGIN
  -- Ini 3.0
  /* 
  pHost := '10.245.23.41';
  pPuerto := '22';
  pUsuario := 'peru';
  pPass := '/home/oracle/.ssh/id_rsa';
  --pDirectorio := '/u02/oracle/BGSGATST/UTL_FILE';
  pDirectorio := '/u03/oracle/PESGAPRD/UTL_FILE';
  pArchivoRemotoreq := 'autreq/req';
  */
  p_resultado := 'OK';
  connex_i    := operacion.pq_dth.f_crea_conexion_intraway;
  -- Fin 3.0

  select count(*)
    into l_cantidad1
    from operacion.reg_archivos_enviados
   where numregins = p_numregistro;

  IF l_cantidad1 > 0 THEN
    DELETE operacion.reg_archivos_enviados WHERE NUMREGINS = p_numregistro;
  
    commit;
  END IF;

  s_bouquets  := trim(p_bouquets);
  n_largo     := length(s_bouquets);
  numbouquets := (n_largo + 1) / 4;

  select count(distinct(idtarjeta))
    into lcantidad
    from operacion.tmp_tarjetas
   where flg_incluido = 1;

  pcantidad := LPAD(lcantidad, 5, '0');

  if lcantidad > 0 and lcantidad is not null then
    for i in 1 .. numbouquets loop
      s_codext := LPAD(operacion.f_cb_subcadena2(s_bouquets, i), 8, '0');
      select max(to_number(LASTNUMREGENV))
        into l_numconax
        from operacion.LOG_reg_archivos_enviados;
    
      if l_numconax is null then
        l_numconax := 0;
      end if;
    
      if l_numconax = 999999 then
        l_numconax := 0;
      end if;
    
      l_numconax := l_numconax + 1;
    
      s_numconax := LPAD(l_numconax, 6, '0');
      p_nombre   := 'cs' || s_numconax || '.emm';
    
      --CREACION DE ARCHIVO DE SOLICITUD DE BAJA DEL SERVICIO DE CABLE SATELITAL
    
      --ABRE EL ARCHIVO
      operacion.PQ_DTH_INTERFAZ.p_abrir_archivo(p_text_io,
                                                connex_i.pDirectorioLocal2,
                                                p_nombre,
                                                'W',
                                                p_resultado,
                                                p_mensaje);
      --ESCRIBE EN EL ARCHIVO
      operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io, 'U', '1');
      operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io, s_numconax, '1');
      operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io, s_codext, '1');
      operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io, p_fecini, '1');
      operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io, p_fecfin, '1');
      operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io, 'U', '1');
      operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io, 'EMM', '1');
      operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io, 'U', '1');
      operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io, pcantidad, '1');
      FOR r_cursor in c_tarjetas loop
        pidtarjeta := r_cursor.idtarjeta;
        --ESCRIBE LOS NUMEROS DE LAS TARJETAS A DESACTIVAR
        operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io,
                                                  pidtarjeta,
                                                  '1');
      END LOOP;
      operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io, 'ZZZ', '1');
      --CIERRA EL ARCHIVO DE BAJA DEL SERVICIO DE CABLE SATELITAL
      operacion.PQ_DTH_INTERFAZ.p_cerrar_archivo(p_text_io);
    
      BEGIN
      
        --ENVIO DE ARCHIVO DE BAJA SERVICIO CABLE SATELITAL
        operacion.PQ_DTH_INTERFAZ.p_enviar_archivo_ascii(connex_i.pHost,
                                                         connex_i.pPuerto,
                                                         connex_i.pUsuario,
                                                         connex_i.pPass,
                                                         connex_i.pDirectorioLocal2,
                                                         p_nombre,
                                                         connex_i.pArchivoRemotoreq);
      
        begin
          SELECT OPERACION.SQ_NUMTRANS.NEXTVAL
            INTO l_numtransacconax
            FROM DUAL;
        
          insert into operacion.LOG_reg_archivos_enviados
            (numregenv,
             numregins,
             filename,
             LASTNUMREGENV,
             codigo_ext,
             tipo_proceso,
             numtrans)
          values
            (s_numconax,
             p_numregistro,
             p_nombre,
             s_numconax,
             s_codext,
             'B',
             l_numtransacconax);
        
          insert into operacion.reg_archivos_enviados
            (numregenv,
             numregins,
             filename,
             estado,
             LASTNUMREGENV,
             codigo_ext,
             tipo_proceso,
             numtrans)
          values
            (s_numconax,
             p_numregistro,
             p_nombre,
             1,
             s_numconax,
             s_codext,
             'B',
             l_numtransacconax);
        
          commit;
        exception
          when others then
            rollback;
        end;
      
      EXCEPTION
        WHEN OTHERS THEN
          p_resultado := 'ERROR1';
      END;
    
    end loop;
  end if;
EXCEPTION
  WHEN OTHERS THEN
    p_resultado := 'ERROR';
    p_mensaje   := 'Error al abrir archivo. ' || SQLCODE || ' ' || SQLERRM;
END p_desactiva_bouquet_masivo2;

/
