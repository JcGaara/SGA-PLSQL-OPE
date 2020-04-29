CREATE OR REPLACE PROCEDURE operacion.p_recu_files_baja
   is
/***************************************************************************************************************
NOMBRE:     OPERACION.p_recu_files_alta
PROPOSITO:  Realiza alta.
  
PROGRAMADO EN JOB:  NO
  
REVISIONES:
 Ver        Fecha        Autor            Solicitado por    Descripcion
------   ----------  -------------------  --------------    -----------------------------------------------------
1.0      01/12/2013   Justiniano Condori  Manuel Gallegos   PROY-17565-  Aprovisionamiento DTH Prepago - INTRAWAY
****************************************************************************************************************/
   connex_i            operacion.conex_intraway; --1.0
   i                   int;
   check_ok            boolean;
   check_err           boolean;
   p_estado            boolean;
   file_error_copiado  boolean;
--Ini 1.0.
/*   pHost               varchar2(50);
   pPuerto             varchar2(10);
   pUsuario            varchar2(30);
   pPass               varchar2(100);
   pDirectorio         varchar2(100);
   pArchivoLocalrec    varchar2(50);
   p_errors_local      varchar2(50);
   p_errors_remoto     varchar2(50);*/
   pArchivoRemotooK    varchar2(50);
   pArchivoRemotoerror varchar2(50);
-- Fin 1.0.
   p_resultado         varchar2(20);
   LS_NUMREGISTRO      varchar2(10);
   LS_IDTARJETA        varchar2(32);
   ln_estado_baja      number;
   p_mensaje           varchar2(1000);
   cursor c_numslc_baja is
   select distinct a.numslc
   from inssrv a, tystabsrv b ,operacion.reginsdth c
   where a.estinssrv = 3 and
   a.codsrv = b.codsrv and
   b.codigo_ext is not null and
   c.numslc = a.numslc and
   c.estado in ('02','07');

   cursor c_filenameenv   is
   select * from  operacion.reg_archivos_enviados
   where estado = 1 and tipo_proceso = 'B'
   and fecenv is not null;

 BEGIN
   --ini 1.0
  /*
  pHost := '10.245.23.41';
  pPuerto := '22';
  pUsuario := 'peru';
  pPass := '/home/oracle/.ssh/id_rsa';
  --pDirectorio := '/u02/oracle/BGSGATST/UTL_FILE';
  pDirectorio := '/u03/oracle/PESGAPRD/UTL_FILE';
  p_errors_local :='errors.txt';
  p_errors_remoto:='aut/err/errors.txt';
  */
  file_error_copiado:=false;
  p_resultado:='OK';
   connex_i := operacion.pq_dth.f_crea_conexion_intraway;
--fin 1.0
  i := 0;

  for c_fileenv in c_filenameenv loop

    pArchivoRemotooK := connex_i.pArchivoRemotooK || c_fileenv.filename;
    pArchivoRemotoerror := connex_i.pArchivoRemotoerror || c_fileenv.filename;
    p_mensaje := '';

   BEGIN
    LOOP
        i := i + 1;
        check_ok := false;
        check_err := false;

        BEGIN
             -- Ini 1.0
             operacion.PQ_DTH_INTERFAZ.p_recibir_archivo_ascii (connex_i.pHost,
                                                                connex_i.pPuerto,
                                                                connex_i.pUsuario,
                                                                connex_i.pPass,
                                                                connex_i.pDirectorioLocal2,
                                                                c_fileenv.filename,
                                                                pArchivoRemotooK);
             -- Fin 1.0
             check_ok := true;
             p_estado := true;

        EXCEPTION
           WHEN OTHERS THEN
           p_resultado := 'ERROR2';
           check_ok := false;
           p_estado := false;

        END;

        IF (check_ok) THEN
          EXIT;
        END IF;

        BEGIN
             -- Ini 1.0
             operacion.PQ_DTH_INTERFAZ.p_recibir_archivo_ascii(connex_i.pHost,
                                                               connex_i.pPuerto,
                                                               connex_i.pUsuario,
                                                               connex_i.pPass,
                                                               connex_i.pDirectorioLocal2,
                                                               c_fileenv.filename,
                                                               pArchivoRemotoerror);
             -- Fin 1.0

             if not file_error_copiado then
               -- Ini 1.0
               operacion.PQ_DTH_INTERFAZ.p_recibir_archivo_ascii(connex_i.pHost,
                                                                 connex_i.pPuerto,
                                                                 connex_i.pUsuario,
                                                                 connex_i.pPass,
                                                                 connex_i.pDirectorioLocal2,
                                                                 connex_i.p_errors_local,
                                                                 connex_i.p_errors_remoto2);
               -- Fin 1.0
               file_error_copiado := true;
             end if;

             check_err := true;
             p_estado  := false;

        EXCEPTION
           WHEN OTHERS THEN
           p_resultado := 'ERROR3';
           check_err := false;
           p_estado  := true;

        END;

        IF (check_err) THEN
          EXIT;
        END IF;


        IF i > 1 THEN
         EXIT;
        END IF;
    END LOOP;

    BEGIN
         -- Ini 1.0
         OPERACION.p_proc_archivo_conax(connex_i.pDirectorioLocal2,
                                        c_fileenv.filename,
                                        'R', 
                                        p_estado,
                                        connex_i.p_errors_local,
                                        p_resultado , 
                                        p_mensaje);
         -- Fin 1.0

         IF (check_ok) THEN
            begin
              update operacion.reg_archivos_enviados
              set estado = 2
              where NUMTRANS = c_fileenv.numtrans;
              commit;
            Exception
              when others then
              rollback;
            end;
         END IF;


        IF (check_err) THEN
           begin
             update operacion.reg_archivos_enviados
             set estado = 3 , observacion = p_mensaje
             where NUMTRANS = c_fileenv.numtrans;
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



  FOR  c_numslc IN c_numslc_baja loop

       select OPERACION.F_VALIDA_BAJA( c_numslc.numslc ) into ln_estado_baja from dual;

       SELECT NUMREGISTRO,IDTARJETA INTO LS_NUMREGISTRO,LS_IDTARJETA
       FROM operacion.reginsdth
       WHERE NUMSLC = c_numslc.numslc;

       IF ln_estado_baja = 1 THEN
           begin
             update operacion.REGINSDTH
             set ESTADO = '05' , fecbajaconax = sysdate
             where numslc = c_numslc.numslc;

             update EQUIPOTV
             set   ESTADO = 3 , NUMREGISTRO = null
             where CODTIPEQU = '4002179' and
                   SERIALNUMBER = LS_IDTARJETA and
                   SISTEMA = 1;

             commit;
           Exception
             when others then
             rollback;
           end;

       ELSE
           begin
             update operacion.REGINSDTH
             set ESTADO = '03'
             where numslc = c_numslc.numslc;
             commit;

           Exception
             when others then
             rollback;
           end;

       END IF;
   END LOOP;

 END p_recu_files_baja;

/
