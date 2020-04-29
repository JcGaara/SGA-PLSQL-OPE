create or replace package body operacion.pq_control_sinc_webuni is
  /******************************************************************************
     NAME:       pq_control_sinc_webuni
     Purpose:    --
      Ver        Date        Author            Solicitado por    Description
     ---------  ----------  ---------------   ----------------  --------------------
     1.0        20/11/2011  Kevy Carranza     Guillermo Salcedo REQ-161140 Enviar de errores por correo
     *******************************************************************************/
FUNCTION  F_VUELCA_CSV(p_query     IN VARCHAR2,
                    p_separador    IN VARCHAR2 DEFAULT ',',
                    p_nomdir       IN VARCHAR2 ,
                    p_nomarchivo   IN VARCHAR2 ) RETURN NUMBER
IS
    ls_output        utl_file.file_type;
    ls_Cursor     INTEGER DEFAULT dbms_sql.open_cursor;
    ls_columnValue   VARCHAR2(2000);
    li_status        INTEGER;
    ln_colCnt        NUMBER DEFAULT 0;
    ls_separador     VARCHAR2(10) DEFAULT '';
    l_cnt           NUMBER DEFAULT 0;

    ls_desc_tab   dbms_sql.desc_tab;
    ln_cols       number;

BEGIN

    ls_output := utl_file.fopen( p_nomdir, p_nomarchivo, 'w' );
    ls_Cursor := dbms_sql.open_cursor;
    dbms_sql.parse(  ls_Cursor,  p_query, dbms_sql.native );
    dbms_sql.describe_columns( ls_Cursor, ln_cols, ls_desc_tab );  -- Obtengo los nombres de las columnas

        ls_separador := '';    --escribo el nombre de las columnas para la cebecera
        FOR i IN 1 .. ln_cols LOOP
            utl_file.put( ls_output, ls_separador || ls_desc_tab(i).col_name );
            ls_separador := p_separador;
        END LOOP;
        utl_file.new_line( ls_output );

    FOR I IN 1 .. 255 LOOP
        BEGIN
            dbms_sql.define_column( ls_Cursor, i, ls_columnValue, 2000 );
            ln_colCnt := i;
        EXCEPTION
            WHEN OTHERS THEN
                IF ( SQLCODE = -1007 ) THEN EXIT;
                ELSE
                    RAISE;
                END IF;
        END;
    END LOOP;

    dbms_sql.define_column( ls_Cursor, 1, ls_columnValue, 2000 );
    --Lleno las lineas
    li_status := dbms_sql.execute(ls_Cursor);
    IF li_status  = 0 THEN NULL; END IF;
    LOOP
        EXIT WHEN ( dbms_sql.fetch_rows(ls_Cursor) <= 0 );
        ls_separador := '';
        FOR I IN 1 .. ln_colCnt LOOP
            dbms_sql.column_value( ls_Cursor, i, ls_columnValue );
            utl_file.put( ls_output, ls_separador || ls_columnValue );
            ls_separador := p_separador;
        END LOOP;
        utl_file.new_line( ls_output );
        l_cnt := l_cnt+1;
    END LOOP;
    dbms_sql.close_cursor(ls_Cursor);

    utl_file.fclose( ls_output );
    RETURN l_cnt;
END F_VUELCA_CSV;

--------- Envia reporte ---------
procedure P_ENVIA_REPORTE Is
    lc_filename                 varchar2(1000);
    lc_unixpath_princ           varchar2(1000);
    ln_borro_arch               number(1);
    vcuerpo                     varchar2(200);
    v_lineas number;
    p_query    varchar2(10000);
    ls_email_dest varchar2(50);
    lse varchar2(8000);
    lc_dir varchar2(50);

cursor cur_dest is
  select CORREO
  from operacion.ope_correo_mae
  where flgestado = 1;

  begin
    --armo el query
      p_query:='SELECT T.IDJOB,T.IDPROCESO,
             T.IDLOTE
          FROM SALES.INT_PROCESO_CAB T
         WHERE T.FLG_ERROR = 1
         AND T.IDLOTE IS NOT NULL';

        --GENERA NOMBRE DEL ARCHIVO
        select 'ERROR_WEBUNI'/* || to_char(sysdate,'yyyymmddhhmiss')*/ || '.csv' INTO lc_filename  from dual;
        select VALOR into lc_dir from constante where constante = 'DIRSINCROWEBUNI';

        --OBTIENE RUTA DE ORIGEN
        select directory_path
          into lc_unixpath_princ --CREAR PARA PRODUCCION
          from dba_directories
         where directory_name = lc_dir;

         --ABRE O CREA, PROCESA Y CIERRA EL ARCHIVO
        v_lineas := F_VUELCA_CSV(p_query => p_query,
                             p_separador => ';',
                             p_nomdir       => lc_dir,
                             p_nomarchivo  => lc_filename);

        --ENVIAMOS EL REPORTE DEL UTL_FILE POR EMAIL
         vcuerpo := vcuerpo ||'Se adjunta el reporte de errores. ' || chr(13);

        FOR d IN CUR_dest LOOP
            p_envia_correo_c_attach('Envio de errores - Sincronización de Ventas Masivas DTH',
                                 d.correo,
                                  vcuerpo,
                                  sendmailjpkg.attachments_list(lc_unixpath_princ || '/' ||
                                                                lc_filename),
                                  'SGA');
         END LOOP;

        commit;
      exception
        when others then
        lse:=sqlerrm;
          dbms_output.put_line('Error al generar el reporte: ' || sqlerrm );
          Rollback;
  end P_ENVIA_REPORTE;
end ;
/
