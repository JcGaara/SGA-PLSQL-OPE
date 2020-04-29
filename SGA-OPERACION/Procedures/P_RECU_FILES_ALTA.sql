CREATE OR REPLACE PROCEDURE operacion.p_recu_files_alta is
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
  /*   pHost               varchar2(50);
  pPuerto             varchar2(10);
  pUsuario            varchar2(30);
  pPass               varchar2(100);
  pDirectorio         varchar2(100);
  pArchivoLocalrec    varchar2(50);
  p_errors_local      varchar2(50);
  p_errors_remoto     varchar2(50);*/
  --pidtarjeta          varchar2(32);
  pArchivoRemotooK    varchar2(50);
  pArchivoRemotoerror varchar2(50);
  -- Fin 1.0
  p_resultado    varchar2(20);
  ln_estado_inst number;
  p_mensaje      varchar2(1000);
  connex_i       operacion.conex_intraway; --1.0

  cursor c_filenameenv is
    select *
      from operacion.reg_archivos_enviados
     where estado = 1
       and tipo_proceso = 'A'
       and fecenv is not null;

  cursor c_numregins is
    select *
      from operacion.reginsdth
     where estado = '08'
       and trunc(fecreg) = trunc(sysdate);

BEGIN
  -- Ini 1.0
  /*pHost := '10.245.23.41';
   pPuerto := '22';
   pUsuario := 'peru';
   pPass := '/home/oracle/.ssh/id_rsa';
   --pDirectorio := '/u02/oracle/BGSGATST/UTL_FILE';
   pDirectorio := '/u03/oracle/PESGAPRD/UTL_FILE';
   p_errors_local :='errors.txt';
   p_errors_remoto:='aut/err/errors.txt';
  */
  file_error_copiado := false;
  p_resultado        := 'OK';
  connex_i           := operacion.pq_dth.f_crea_conexion_intraway;
  -- Fin 1.0

  i := 0;

  for c_fileenv in c_filenameenv loop
  
    pArchivoRemotooK    := connex_i.pArchivoRemotooK || c_fileenv.filename;
    pArchivoRemotoerror := connex_i.pArchivoRemotoerror || c_fileenv.filename;
    p_mensaje           := '';
  
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
                                                              connex_i.p_errors_remoto2);
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
               set estado = 3, 
                   observacion = p_mensaje
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

  FOR c_numreginsconax IN c_numregins loop
  
    ln_estado_inst := operacion.F_VERIFICA_ESTADO_SER_CONAX(c_numreginsconax.numregistro); --1.0
  
    IF ln_estado_inst = 1 THEN
      begin
        update OPERACION.REGINSDTH
           set ESTADO = '02', 
               FECACTCONAX = SYSDATE
         where NUMREGISTRO = c_numreginsconax.numregistro;
      
        update EQUIPOTV
           set ESTADO = 5, 
               NUMREGISTRO = c_numreginsconax.numregistro
         where CODTIPEQU = '4002179'
           and SERIALNUMBER = c_numreginsconax.idtarjeta
           and SISTEMA = 1;
      
        commit;
      Exception
        when others then
          rollback;
      end;
    
    ELSE
      begin
        update OPERACION.REGINSDTH
           set ESTADO = '03'
         where NUMREGISTRO = c_numreginsconax.numregistro;
        commit;
      
        update EQUIPOTV
           set ESTADO = 3, 
               NUMREGISTRO = null
         where CODTIPEQU = '4002179'
           and SERIALNUMBER = c_numreginsconax.idtarjeta
           and SISTEMA = 1;
      
      Exception
        when others then
          rollback;
      end;
    
    END IF;
  
  END LOOP;

END p_recu_files_alta;

/
