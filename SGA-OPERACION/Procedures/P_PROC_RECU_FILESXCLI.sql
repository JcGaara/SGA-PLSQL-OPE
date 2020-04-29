CREATE OR REPLACE PROCEDURE operacion.p_proc_recu_filesxcli(p_numregistro IN VARCHAR2,
                                                            p_tipo        IN INT,
                                                            p_resultado   IN OUT VARCHAR2,
                                                            p_mensaje     IN OUT VARCHAR2) is
/***************************************************************************************************************
NOMBRE:     OPERACION.p_recu_files_alta
PROPOSITO:  Realiza alta.
  
PROGRAMADO EN JOB:  NO
  
REVISIONES:
 Ver        Fecha        Autor            Solicitado por    Descripcion
------   ----------  -------------------  --------------    -----------------------------------------------------
1.0      01/12/2013   Justiniano Condori  Manuel Gallegos   PROY-17565-  Aprovisionamiento DTH Prepago - INTRAWAY
****************************************************************************************************************/
  i                  int;
  check_ok           boolean;
  check_err          boolean;
  p_estado           boolean;
  file_error_copiado boolean;
  -- Ini 1.0
  /*   
  pHost               varchar2(50);
  pPuerto             varchar2(10);
  pUsuario            varchar2(30);
  pPass               varchar2(100);
  pDirectorio         varchar2(100);
  pArchivoLocalrec    varchar2(50); 
  p_errors_local      varchar2(50);
  p_errors_remoto     varchar2(50);  
  */
  pArchivoRemotooK    varchar2(50);
  pArchivoRemotoerror varchar2(50);
  -- Fin 1.0
  pidtarjeta             varchar2(32);
  ln_estado_inst         number;
  l_canfileenv           number;
  l_canfileenv_noproc    number;
  l_canfileenv_con_error number;
  --p_mensaje           varchar2(1000);
  connex_i              operacion.conex_intraway; --1.0

  cursor c_filenameenv is
    select *
      from operacion.reg_archivos_enviados
     where estado = 1
       and numregins = p_numregistro
       and fecenv is not null;

BEGIN
  --ini 1.0
  /*  pHost := '10.245.23.41';
    pPuerto := '22';
    pUsuario := 'peru';
    pPass := '/home/oracle/.ssh/id_rsa';
  --  pDirectorio := '/u02/oracle/BGSGATST/UTL_FILE';
    pDirectorio := '/u03/oracle/PESGAPRD/UTL_FILE';
    p_errors_local :='errors.txt';
    p_errors_remoto:='autreq/err/errors.txt';
  */
  file_error_copiado := false;
  p_resultado        := 'OK';
  connex_i           := operacion.pq_dth.f_crea_conexion_intraway;
  --fin 1.0
  i := 0;

  select count(*)
    into l_canfileenv
    from operacion.reg_archivos_enviados
   where estado = 1
     and numregins = p_numregistro
     and fecenv is not null;

  for c_fileenv in c_filenameenv loop
  
    pArchivoRemotooK    := connex_i.pArchivoRemotooK || c_fileenv.filename;
    pArchivoRemotoerror := connex_i.pArchivoRemotoerror || c_fileenv.filename;
    p_mensaje                    := '';
  
    BEGIN
      LOOP
        i         := i + 1;
        check_ok  := false;
        check_err := false;
      
        BEGIN
          operacion.PQ_DTH_INTERFAZ.p_recibir_archivo_ascii(connex_i.pHost,
                                                            connex_i.pPuerto,
                                                            connex_i.pUsuario,
                                                            connex_i.pPass,
                                                            connex_i.pDirectorioLocal2,
                                                            c_fileenv.filename,
                                                            pArchivoRemotooK);
          check_ok := true;
          p_estado := true;
        
        EXCEPTION
          WHEN OTHERS THEN
            p_resultado := 'ERROR2';
            check_ok    := false;
            p_estado    := false;
          
        END;
      
        IF (check_ok) THEN
          EXIT;
        END IF;
      
        BEGIN
          operacion.PQ_DTH_INTERFAZ.p_recibir_archivo_ascii(connex_i.pHost,
                                                            connex_i.pPuerto,
                                                            connex_i.pUsuario,
                                                            connex_i.pPass,
                                                            connex_i.pDirectorioLocal2,
                                                            c_fileenv.filename,
                                                            pArchivoRemotoerror);
        
          if not file_error_copiado then
            operacion.PQ_DTH_INTERFAZ.p_recibir_archivo_ascii(connex_i.pHost,
                                                              connex_i.pPuerto,
                                                              connex_i.pUsuario,
                                                              connex_i.pPass,
                                                              connex_i.pDirectorioLocal2,
                                                              connex_i.p_errors_local,
                                                              connex_i.p_errors_remoto);
            file_error_copiado := true;
          end if;
        
          check_err := true;
          p_estado  := false;
        
        EXCEPTION
          WHEN OTHERS THEN
            p_resultado := 'ERROR3';
            check_err   := false;
            p_estado    := true;
          
        END;
      
        IF (check_err) THEN
          EXIT;
        END IF;
      
        IF i > 1 THEN
          EXIT;
        END IF;
      END LOOP;
    
      BEGIN
        OPERACION.p_proc_archivo_conax(connex_i.pDirectorioLocal2,
                                       c_fileenv.filename,
                                       'R',
                                       p_estado,
                                       connex_i.p_errors_local,
                                       p_resultado,
                                       p_mensaje);
      
        IF (check_ok) THEN
          begin
            update operacion.reg_archivos_enviados
               set estado = 2
             where numtrans = c_fileenv.numtrans;
            commit;
          Exception
            when others then
              rollback;
          end;
        END IF;
      
        IF (check_err) THEN
          begin
            update operacion.reg_archivos_enviados
               set estado = 3, observacion = p_mensaje
             where numtrans = c_fileenv.numtrans;
            commit;
          Exception
            when others then
              rollback;
          end;
        END IF;
      
      EXCEPTION
        WHEN OTHERS THEN
          p_resultado := 'ERROR4';
        
      END;
    
    END;
  END LOOP;

  select count(*)
    into l_canfileenv_noproc
    from operacion.reg_archivos_enviados
   where estado = 1
     and numregins = p_numregistro
     and fecenv is not null;

  select count(*)
    into l_canfileenv_con_error
    from operacion.reg_archivos_enviados
   where estado = 3
     and numregins = p_numregistro
     and fecenv is not null;

  if l_canfileenv_noproc = l_canfileenv and l_canfileenv > 0 then
    p_resultado := 'ERROR';
  else
  
    select operacion.F_VERIFICA_ESTADO_SER_CONAX(p_numregistro)
      into ln_estado_inst
      from dual;
  
    IF ln_estado_inst = 1 THEN
      begin
      
        select idtarjeta
          into pidtarjeta
          from operacion.reginsdth
         where numregistro = p_numregistro;
      
        if p_tipo = 1 then
          --tipo 1:Verificación de Solicitud de Activación
          update OPERACION.REGINSDTH
             set ESTADO = '02', FECACTCONAX = SYSDATE
           where NUMREGISTRO = p_numregistro;
        
          update EQUIPOTV
             set ESTADO = 5, NUMREGISTRO = p_numregistro
           where CODTIPEQU = '4002179'
             and SERIALNUMBER = pidtarjeta
             and SISTEMA = 1;
        
        elsif p_tipo = 2 then
          --tipo 2:Verificación de Solicitud de Desactivación
          update OPERACION.REGINSDTH
             set ESTADO = '05', fecbajaconax = SYSDATE
           where NUMREGISTRO = p_numregistro;
        
          update EQUIPOTV
             set ESTADO = 3, NUMREGISTRO = null
           where CODTIPEQU = '4002179'
             and SERIALNUMBER = pidtarjeta
             and SISTEMA = 1;
        
        elsif p_tipo = 3 then
          --tipo 3:Verificación de Solicitud de Corte
          update OPERACION.REGINSDTH
             set ESTADO = '16'
           where NUMREGISTRO = p_numregistro;
        
        elsif p_tipo = 4 then
          --tipo 4:Verificación de Solicitud de Reconexión
          update OPERACION.REGINSDTH
             set ESTADO = '17'
           where NUMREGISTRO = p_numregistro;
        
        else
          --tipo 5:Verificación de Solicitud de Corte Total del Servicio
          update OPERACION.REGINSDTH
             set ESTADO = '18'
           where NUMREGISTRO = p_numregistro;
        
        end if;
      
        commit;
      
      Exception
        when others then
          rollback;
      end;
      p_resultado := 'OK';
    ELSE
    
      if l_canfileenv_con_error > 0 then
        begin
          if p_tipo = 1 then
            update OPERACION.REGINSDTH
               set ESTADO = '03'
             where NUMREGISTRO = p_numregistro;
          else
            update OPERACION.REGINSDTH
               set ESTADO = '06'
             where NUMREGISTRO = p_numregistro;
          
          end if;
          update EQUIPOTV
             set ESTADO = 3, NUMREGISTRO = null
           where CODTIPEQU = '4002179'
             and SERIALNUMBER = pidtarjeta
             and SISTEMA = 1;
        
          commit;
        Exception
          when others then
            rollback;
        end;
        p_resultado := 'ERROR';
      else
        p_resultado := 'ERROR';
      end if;
    
    END IF;
  end if;

END p_proc_recu_filesxcli;

/
