CREATE OR REPLACE PROCEDURE operacion.p_desactivar_conax
/****************************************************************************************************************
     NOMBRE:       p_desactivar_conax
     PROPOSITO:
  
     REVISIONES:
     Ver        Fecha        Autor           Solicitado por Descripcion
     ---------  ----------  ---------------  -------------  -----------------------
      1.0                                                   Creación
      2.0       14/09/2010  Joseph Asencios  Juan Gallegos  REQ 142589: Adecuaciones por ampliación del campo codigo_ext(tystabsrv)
      3.0      01/12/2014   Jorge Armas      Manuel Gallegos   PROY-17565-  Aprovisionamiento DTH Prepago - INTRAWAY
**********************************************************************************************************************/
 is
  pidtarjeta  OPERACION.reginsdth.idtarjeta%TYPE;
  p_resultado VARCHAR2(20);
  p_mensaje   VARCHAR2(300);
  p_text_io   UTL_FILE.FILE_TYPE;
  p_nombre    VARCHAR2(15);
  l_numconax  NUMBER;
  s_numconax  VARCHAR2(6);
  -- Ini 3.0
  /*
  pArchivoLocalenv    VARCHAR2(30);
  pHost               VARCHAR2(50);
  pPuerto             VARCHAR2(10);
  pUsuario            VARCHAR2(50);
  pPass               VARCHAR2(50);
  pDirectorio         VARCHAR2(50);
  pArchivoRemotoreq   VARCHAR2(50);
  */
  -- Fin 3.0
  p_fecini          VARCHAR2(15);
  p_fecfin          VARCHAR2(15);
  pcantidad         VARCHAR2(5);
  lcantidad         NUMBER(15);
  l_numtransacconax NUMBER(15);
  --ini 2.0
  /*s_bouquets          VARCHAR2(100);*/
  s_bouquets tystabsrv.codigo_ext%type;
  --fin 2.0
  n_largo     number;
  numbouquets number;
  connex_i    operacion.conex_intraway; --3.0

  cursor c_codigo_externo is
    select distinct b.codigo_ext
      from inssrv a, tystabsrv b, operacion.reginsdth c
     where a.estinssrv = 3
       and a.codsrv = b.codsrv
       and b.codigo_ext is not null
       and c.numslc = a.numslc
       and c.estado in ('02', '07')
       and rownum < 4; -- Pruebas se debe quitar para produccion

  cursor c_conax_activos(cod_ext varchar2) is
    select distinct a.idtarjeta
      from OPERACION.reginsdth a,
           paquete_venta,
           detalle_paquete,
           linea_paquete,
           producto,
           tystabsrv,
           inssrv              b
     where paquete_venta.idpaq = a.idpaq
       and paquete_venta.idpaq = detalle_paquete.idpaq
       and detalle_paquete.iddet = linea_paquete.iddet
       and detalle_paquete.idproducto = producto.idproducto
       and detalle_paquete.flgestado = 1
       and linea_paquete.flgestado = 1
       and producto.tipsrv = '0062'
       and --cable
           linea_paquete.codsrv = tystabsrv.codsrv
       and tystabsrv.codigo_ext is not null
       and a.estado in ('02', '07')
       and tystabsrv.codigo_ext = cod_ext
       and a.numslc = b.numslc
       and b.estinssrv = 3
       and rownum < 4 -- Pruebas se debe quitar para produccion
     order by a.idtarjeta asc;

  s_codext varchar2(10);

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
  connex_i := operacion.pq_dth.f_crea_conexion_intraway;
  -- Fin 3.0
  select TO_CHAR(trunc(sysdate, 'MM'), 'yyyymmdd') || '0000'
    into p_fecini
    from dual;
  select TO_CHAR(trunc(last_day(sysdate)), 'yyyymmdd') || '0000'
    into p_fecfin
    from dual;

  p_resultado := 'OK';

  for c_cod_ext in c_codigo_externo loop
  
    s_bouquets := trim(c_cod_ext.codigo_ext);
  
    select count(distinct(a.idtarjeta))
      into lcantidad
      from OPERACION.reginsdth a,
           paquete_venta,
           detalle_paquete,
           linea_paquete,
           producto,
           tystabsrv,
           inssrv              b
     where paquete_venta.idpaq = a.idpaq
       and paquete_venta.idpaq = detalle_paquete.idpaq
       and detalle_paquete.iddet = linea_paquete.iddet
       and detalle_paquete.idproducto = producto.idproducto
       and detalle_paquete.flgestado = 1
       and linea_paquete.flgestado = 1
       and producto.tipsrv = '0062'
       and --cable
           linea_paquete.codsrv = tystabsrv.codsrv
       and tystabsrv.codigo_ext is not null
       and a.estado in ('02', '07')
       and tystabsrv.codigo_ext = s_bouquets
       and a.numslc = b.numslc
       and b.estinssrv = 3;
  
    pcantidad := LPAD(lcantidad, 5, '0');
  
    if lcantidad > 0 and lcantidad is not null then
    
      n_largo     := length(s_bouquets);
      numbouquets := (n_largo + 1) / 4;
    
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
      
        --ABRE EL ARCHIVO    operacion.PQ_DTH_INTERFAZ
        operacion.PQ_DTH_INTERFAZ.p_abrir_archivo(p_text_io,
                                                  connex_i.pDirectorioLocal2,
                                                  p_nombre,
                                                  'W',
                                                  p_resultado,
                                                  p_mensaje);
        --ESCRIBE EN EL ARCHIVO
        operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io, 'U', '1');
        operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io,
                                                  s_numconax,
                                                  '1');
        operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io, s_codext, '1');
        operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io, p_fecini, '1');
        operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io, p_fecfin, '1');
        operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io, 'U', '1');
        operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io, 'EMM', '1');
        operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io, 'U', '1');
        operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io,
                                                  pcantidad,
                                                  '1');
      
        FOR r_cursor in c_conax_activos(c_cod_ext.codigo_ext) loop
          pidtarjeta := r_cursor.idtarjeta;
          --ESCRIBE LOS NUMEROS DE LAS TARJETAS A ACTIVAR
          operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io,
                                                    pidtarjeta,
                                                    '1');
          begin
            update OPERACION.REGINSDTH
               set ESTADO = '04'
             where idtarjeta = pidtarjeta
               and estado in ('02', '07');
            commit;
          exception
            when others then
              rollback;
          end;
        
        END LOOP;
      
        operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io, 'ZZZ', '1');
        operacion.PQ_DTH_INTERFAZ.p_cerrar_archivo(p_text_io);
      
        BEGIN
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
               filename,
               LASTNUMREGENV,
               tipo_proceso,
               numtrans,
               codigo_ext)
            values
              (s_numconax,
               p_nombre,
               s_numconax,
               'B',
               l_numtransacconax,
               s_codext);
          
            insert into operacion.reg_archivos_enviados
              (numregenv,
               filename,
               estado,
               LASTNUMREGENV,
               tipo_proceso,
               numtrans,
               codigo_ext)
            values
              (s_numconax,
               p_nombre,
               1,
               s_numconax,
               'B',
               l_numtransacconax,
               s_codext);
            commit;
          
          exception
            when others then
              rollback;
          end;
        
        EXCEPTION
          WHEN OTHERS THEN
            p_resultado := 'ERROR1';
        END;
      END LOOP;
    
    end if;
  
  end loop;

EXCEPTION
  WHEN OTHERS THEN
    p_resultado := 'ERROR';
    p_mensaje   := 'Error al abrir archivo. ' || SQLCODE || ' ' || SQLERRM;
END p_desactivar_conax;

/
