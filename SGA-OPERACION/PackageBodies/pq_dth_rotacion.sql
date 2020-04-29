create or replace package body operacion.pq_dth_rotacion
/***************************************************************************************************************
  NOMBRE:       OPERACION.PQ_DTH_ROTACION
  DESCRIPCION:  Paquete encargado de las funcionalidades del proceso de Rotacion y Activacion/corte de DTH
                para Claro Perú.

  Ver        Fecha        Autor                 Solicitado por         Descripcion
  ------  ----------  ------------------     ---------------------  ------------------------------------
  1.0     28/08/2014  Justiniano Condori     Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
****************************************************************************************************************/
as
-- Parametros de Validacion de Codigo de Tarjeta
pini              constant varchar2(30) := operacion.pq_dth_rotacion.f_obt_parametro_c('PARAM_ROTA_M','VAL_INI');
plong             constant varchar2(30) := operacion.pq_dth_rotacion.f_obt_parametro_c('PARAM_ROTA_M','VAL_LON');
-- Parametros del Servidor Origen
pdirectorio       constant varchar2(50) := operacion.pq_dth.f_obt_parametro_d('PARAM_DTH','DirectorioLocal');
prutknowhost      constant varchar2(100):= operacion.pq_dth.f_obt_parametro_d('PARAM_DTH','RUT_KH');
-- Parametros del Servidor Destino
phostd            constant varchar2(50) := operacion.pq_dth.f_obt_parametro_d('PARAM_DTH','HOST');
ppuertod          constant varchar2(10) := operacion.pq_dth.f_obt_parametro_d('PARAM_DTH','PUERTO');
pusuariod         constant varchar2(50) := operacion.pq_dth.f_obt_parametro_d('PARAM_DTH','USUARIO');
ppassd            constant varchar2(50) := operacion.pq_dth.f_obt_parametro_d('PARAM_DTH','CLAVE');
pdirectoriod      constant varchar2(50) := operacion.pq_dth.f_obt_parametro_d('PARAM_DTH','Dir.remoto.Req');
pdirectoriok      constant varchar2(50) := operacion.pq_dth.f_obt_parametro_d('PARAM_DTH','Dir.remoto.Ok');
pdirectorior      constant varchar2(50) := operacion.pq_dth.f_obt_parametro_d('PARAM_DTH','Dir.remoto.Error');
/************************************************************************************************
*Tipo               : Funcion
*Descripción        : Encargado de obtener el valor del campo codigoc de la tabla de parametros
                      operacion.opedd
**************************************************************************************************
Ver        Fecha        Autor                 Solicitado por         Descripcion
------  ----------  ------------------     ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori     Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
function f_obt_parametro_c(abrev_tipop varchar2, abrev varchar2)
return varchar2
is
lc_valor varchar2(30);
lc_valor_t number;
begin
  select tipopedd into lc_valor_t
    from operacion.tipopedd t
   where t.abrev=abrev_tipop;

  select codigoc
    into lc_valor
    from operacion.opedd o
   where o.tipopedd = lc_valor_t
     and o.abreviacion= abrev;

  if lc_valor is null then
    lc_valor := null;
  end if;

  return trim(lc_valor);
exception when others then raise_application_error(-20080, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Funcion
*Descripción        : Encargado de obtener el valor del campo descripcion de la tabla de parametros
                      operacion.opedd
**************************************************************************************************
Ver        Fecha        Autor                 Solicitado por         Descripcion
------  ----------  ------------------     ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori     Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
function f_obt_parametro_d(abrev_tipop varchar2, abrev varchar2)
return varchar2
is
lc_valor varchar2(100);
lc_valor_t number;
begin
  select tipopedd into lc_valor_t
    from operacion.tipopedd t
   where t.abrev=abrev_tipop;

  select descripcion
    into lc_valor
    from operacion.opedd o
   where o.tipopedd = lc_valor_t
     and o.abreviacion= abrev;

  if lc_valor is null then
    lc_valor := null;
  end if;

  return trim(lc_valor);
exception when others then raise_application_error(-20080, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Funcion
*Descripción        : Encargado de convertir de número a letras el mes
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
function f_conv_mes(mes in varchar2)
return varchar2
is
mesl varchar2(20);
begin

  if mes='01' then

     mesl:='Enero';

  elsif mes='02' then

     mesl:='Febrero';

  elsif mes='03' then

     mesl:='Marzo';

  elsif mes='04' then

     mesl:='Abril';

  elsif mes='05' then

     mesl:='Mayo';

  elsif mes='06' then

     mesl:='Junio';

  elsif mes='07' then

     mesl:='Julio';

  elsif mes='08' then

     mesl:='Agosto';

  elsif mes='09' then

     mesl:='Septiembre';

  elsif mes='10' then

     mesl:='Octubre';

  elsif mes='11' then

     mesl:='Noviembre';

  elsif mes='12' then

     mesl:='Diciembre';
  else
     mesl:='Mes ingresado no existe';
  end if;

  return mesl;

exception when others then raise_application_error(-20080, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Funcion
*Descripción        : Encargado de Validar el codigo de tarjeta
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
function f_val_cod_tarjeta(cod_tarjeta in varchar2)
return char
is
lv_ini_cod_tar    char(1);
ln_existe_cod_tar number;
ln_valido         char(1);
begin
      ln_valido:='1';
      -- Verificando la Longitud
      if length(cod_tarjeta) <> to_number(plong) then
        ln_valido:='0';
      end if;
      lv_ini_cod_tar:=lpad(cod_tarjeta,1);
      -- Verificando el numero inicial
      if lv_ini_cod_tar <> pini then
        ln_valido:='0';
      end if;
      -- Verificando la existencia en la tabla maestra
      select count(1) into ln_existe_cod_tar
        from operacion.tabequipo_material
       where tipo=1
         and numero_serie=cod_tarjeta;

      if ln_existe_cod_tar=0 then
        ln_valido:='0';
      end if;

return ln_valido;
exception when others then raise_application_error(-20080, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de Eliminar un archivo local
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
PROCEDURE p_eliminar_archivo(p_ruta      IN VARCHAR2,
                             p_nombre    IN VARCHAR2)
is
BEGIN
  UTL_FILE.FREMOVE(p_ruta, p_nombre);
exception when others then raise_application_error(-20080, sqlerrm);
END;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de enviar un archivo remoto
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_enviar_archivo_ascii(pHost          in varchar2,
                                 pPuerto        in varchar2,
                                 pUsuario       in varchar2,
                                 pPass          in varchar2,
                                 pDirectorio    in varchar2,
                                 pArchivoLocal  in varchar2,
                                 pArchivoRemoto in varchar2,
                                 respuesta      out varchar2) is
l_conn       UTL_TCP.connection;
archivolocal varchar2(500);
begin
  if pPuerto = '21' then
    l_conn := ftp.login(pHost, pPuerto, pUsuario, pPass);
    ftp.ascii(p_conn => l_conn);
    ftp.put(p_conn      => l_conn,
            p_from_dir  => pDirectorio,
            p_from_file => pArchivoLocal,
            p_to_file   => pArchivoRemoto);
    ftp.logout(l_conn);
    utl_tcp.close_all_connections;
  elsif pPuerto = '22' then
    archivolocal := pDirectorio || '/' || pArchivoLocal;
    respuesta    := operacion.sftp.enviarArchivo(pUsuario,

                                                 pPass,
                                                 pHost,
                                                 pPuerto,
                                                 prutknowhost,
                                                 archivolocal,
                                                 pArchivoRemoto);
  end if;
exception when others then raise_application_error(-20080, sqlerrm);
end p_enviar_archivo_ascii;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de Eliminar un archivo remoto
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_eliminar_archivo_ascii(pHost          in varchar2,
                                   pPuerto        in varchar2,
                                   pUsuario       in varchar2,
                                   pPass          in varchar2,
                                   pArchivoRemoto in varchar2,
                                   respuesta      out varchar2)
is
l_conn UTL_TCP.connection;
begin
    if pPuerto=21 then
      l_conn := ftp.login(pHost, pPuerto, pUsuario, pPass);
      ftp.ascii(p_conn => l_conn);
      ftp.delete(p_conn => l_conn, p_file => pArchivoRemoto);
      ftp.logout(l_conn);
      utl_tcp.close_all_connections;
      respuesta:='Ok';
    elsif pPuerto=22 then
      respuesta:=operacion.sftp.eliminArchivo(pUsuario,pPass,pHost,pPuerto,prutknowhost,pArchivoRemoto);
    end if;
exception when others then raise_application_error(-20080, sqlerrm);
end p_eliminar_archivo_ascii;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de renombrar un archivo
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_ren_archivo_ascii(pHost          in varchar2,
                              pPuerto        in varchar2,
                              pUsuario       in varchar2,
                              pPass          in varchar2,
                              pArchivoLocal  in varchar2,
                              pArchivoRemoto in varchar2,
                              respuesta      out varchar2)
is
l_conn   UTL_TCP.connection;
begin
      if pPuerto=21 then
         l_conn := operacion.ftp.login(pHost, pPuerto, pUsuario, pPass);
         operacion.ftp.ascii(p_conn => l_conn);
         operacion.ftp.rename(p_conn  => l_conn,
                              p_from  => pArchivoLocal,
                              p_to    => pArchivoRemoto);
         operacion.ftp.logout(l_conn);
         utl_tcp.close_all_connections;
         respuesta:='Ok';
      elsif pPuerto=22 then
         respuesta:=operacion.sftp.renomArchivo(pUsuario,pPass,pHost,pPuerto,prutknowhost,pArchivoLocal,pArchivoRemoto);
      end if;
exception when others then raise_application_error(-20080, sqlerrm);
end p_ren_archivo_ascii;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de verificar la existencia de un archivo
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_vrf_archivo_ascii(pHost          in varchar2,
                              pPuerto        in varchar2,
                              pUsuario       in varchar2,
                              pPass          in varchar2,
                              pDirecarch     in varchar2,
                              respuesta      out varchar2)
is
l_conn   UTL_TCP.connection;
pvrf     operacion.ftp.t_string_table;
begin
      if pPuerto=21 then
         l_conn := operacion.ftp.login(pHost, pPuerto, pUsuario, pPass);
         operacion.ftp.ascii(p_conn => l_conn);
         operacion.ftp.nlst(p_conn => l_conn,
                            p_dir  => pDirecarch,
                            p_list => pvrf);
         operacion.ftp.logout(l_conn);
         utl_tcp.close_all_connections;
         if pvrf.count>0 then
           respuesta:='Ok';
         end if;
      elsif pPuerto=22 then
        respuesta:=operacion.sftp.verifArchivo(pUsuario,pPass,pHost,pPuerto,prutknowhost,pDirecarch);
      end if;
exception when others then raise_application_error(-20080, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de registrar la cabecera de la rotacion de DTH
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_reg_cab_rotacion(id_proc out number)
is
begin

   insert into operacion.cab_rotacion_dth
   (id_proceso,cod_usua,direccion_ip,mes,anho,estado,fecha_reg) values
   (operacion.sq_ope_rotacion.nextval,user,sys_context('USERENV','IP_ADDRESS'),to_char(sysdate,'MM'),to_char(sysdate,'YYYY'),1,sysdate)
   returning id_proceso into id_proc;
   commit;
exception when others then
  rollback;
  raise_application_error(-20002, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de insertar los paquetes declarados en la bscs
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_reg_paq_bscs
is
ln_cnt number;
lv_str varchar2(4000);
bouquets dbms_utility.uncl_array;
cursor c_paq_bscs is
select tar.sncode,
       tar.cod_buquet
  from tim.pp_gmd_buquet@dbl_bscs_bf tar;
begin
    -- Limpiara la tabla temporal de Bouquets
    delete from operacion.rot_paq_postpago;
    commit;
    for c1 in c_paq_bscs loop
        select tar.cod_buquet into lv_str
          from tim.pp_gmd_buquet@dbl_bscs_bf tar
         where tar.sncode=c1.sncode;
         dbms_utility.comma_to_table(trim(REPLACE('"'||lv_str||'"',',','","')) ,ln_cnt, bouquets);
         for i in 1 .. ln_cnt loop
             insert into operacion.rot_paq_postpago(sncode,bouquet) values (to_char(c1.sncode),trim(replace(bouquets(i),'"','')));
         end loop;
    end loop;
    commit;
exception when others then
  rollback;
  raise_application_error(-20080, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de registrar la cabecera de la activacion y corte manual de DTH por
                      Paquete
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_reg_cab_ac_manu_p(descp       in varchar2,
                                tip_proceso in char,
                                paquete     in number,
                                f_ejec      in date,
                                motiv       in varchar2,
                                tip_cliente in char,
                                id_proc     out number)
is
begin
    insert into operacion.cab_atc_cort_manu_dth
    (id_proc_manu,estado,descripcion,tipo_proc,id_paquete,fecha_ejec,motivo,tipo_cliente,direccion_ip,cod_usua,fecha_reg,tip_ac)
    values(operacion.sq_ope_ac_manu.nextval,1,descp,tip_proceso,paquete,f_ejec,motiv,tip_cliente,sys_context('USERENV','IP_ADDRESS'),user,sysdate,'P')
    returning id_proc_manu into id_proc;
exception when others then raise_application_error(-20080, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de registrar la cabecera de la activacion y corte manual de DTH por
                      Bouquet
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_reg_cab_ac_manu_b(descp       in varchar2,
                              tip_proceso in char,
                              f_ejec      in date,
                              motiv       in varchar2,
                              tip_cliente in char,
                              id_proc     out number)
is
begin

    insert into operacion.cab_atc_cort_manu_dth
    (id_proc_manu,estado,descripcion,tipo_proc,fecha_ejec,motivo,tipo_cliente,direccion_ip,cod_usua,fecha_reg,tip_ac)
    values(operacion.sq_ope_ac_manu.nextval,1,descp,tip_proceso,f_ejec,motiv,tip_cliente,sys_context('USERENV','IP_ADDRESS'),user,sysdate,'B')
    returning id_proc_manu into id_proc;
exception when others then raise_application_error(-20080, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de registrar el detalle de la activacion y corte manual de DTH por
                      Bouquet
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_reg_det_ac_manu_b(id_proc in number,
                                bqt in v_bouquet)
is
ln_fila number;
begin
    for ln_fila in 1 .. bqt.count loop
      if bqt(ln_fila)<>0 then
         insert into operacion.det_atc_cort_manu_dth_b(id_proc_manu,bouquet)
         values (id_proc,bqt(ln_fila));
      end if;
    end loop;
exception when others then raise_application_error(-20080, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de registrar el detalle de la activacion y corte manual de DTH por
                      Paquete
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_reg_det_ac_manu(id_proc in number,
                            numtarjeta in v_numtarjeta,
                            total in number)
is
ln_fila number;
begin
    forall ln_fila in 1 .. total
      insert into operacion.det_atc_cort_manu_dth(id_proc_manu,codigo_tarjeta)
      values (id_proc,numtarjeta(ln_fila));
exception when others then raise_application_error(-20080, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de registrar los datos del archivo generado para la rotacion
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_reg_rota_archivo(nom_arch in varchar2,
                             cant_tarj in number,
                             id_proc in number,
                             bqt in number,
                             idarchivo out number)
is
begin
  insert into operacion.rotacion_auto_archivo (id_archivo,nom_archivo,estado_arch,cant_tarjetas,bouquet,id_proceso)
  values (operacion.sq_ope_rota_arch.nextval,nom_arch,'1',cant_tarj,bqt,id_proc)
  returning id_archivo into idarchivo;
  commit;
exception when others then
  rollback;
  raise_application_error(-20080, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de registrar los codigos de tarjetas que contiene el archivo
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_reg_rota_archivo_det(idarchivo in number,
                                 n_tarjeta  in v_ntarjeta)
is
ln_fila number;
begin
    for ln_fila in 1 .. n_tarjeta.count loop
      insert into operacion.rotacion_auto_archivo_det(id_archivo,codigo_tarjeta)
      values (idarchivo,n_tarjeta(ln_fila));
    end loop;
    commit;
exception when others then
  rollback;
  raise_application_error(-20080, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de registrar los datos del archivo generado para la activacion/corte
                      manual.
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_reg_ac_manu_archivo(nom_arch in varchar2,
                                  cant_tarj in number,
                                  id_proc in number,
                                  idarchivo out number)
is
begin

  insert into operacion.cab_atc_cort_archivo (id_archivo,nom_archivo,estado_arch,cant_tarjetas,id_proceso)
  values (operacion.sq_ope_ac_arch.nextval,nom_arch,'1',cant_tarj,id_proc)
  returning id_archivo into idarchivo;
  commit;
exception when others then
  rollback;
  raise_application_error(-20080, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de registrar las tarjetas contenidas en el archivo generado para
                      la activacion/corte manual.
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_reg_ac_manu_archivo_det(idarchivo in number,
                                    n_tarjeta  in v_ntarjeta)
is
ln_fila number;
begin
    for ln_fila in 1 .. n_tarjeta.count loop
      insert into operacion.det_atc_cort_archivo(id_archivo,codigo_tarjeta)
      values (idarchivo,n_tarjeta(ln_fila));
    end loop;
    commit;
exception when others then
  rollback;
  raise_application_error(-20080, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de generar el archivo de rotacion de DTH en base a la tabla
                      operacion.rotacion_datos
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_crea_arch_conax_rota(id_proceso in number)
is
respuestenv varchar2(1000);
respustaren varchar2(1000);
ntarjeta v_ntarjeta;
total number;
i number;
j number;
p_text_io utl_file.file_type;
l_nom_arch varchar2(30);
l_fecini varchar2(12);
l_fecfin varchar2(12);
p_resultado varchar2(100);
p_mensaje varchar2(1000);
l_id_archivo number;
vuelta number;
l_total_tarj_arch number;
residuo number;
cursor c_bouquet is
select distinct(rd.bouquet) as bouquet
  from operacion.rotacion_tarj_bqt rd
order by 1 asc;

cursor c_tarjeta(x number, b varchar2) is
select codigo_tarjeta
  from (select a.*, ROWNUM rnum
          from (select distinct(rd.codigo_tarjeta)
                  from operacion.rotacion_tarj_bqt rd
                 where rd.bouquet=b
              order by 1 asc) a
         where rownum <= (x*4000)+4000)
 where rnum  > (x*4000);

begin
    -- Buscando la fecha de Inicio
    l_fecini:=to_char(trunc(new_time(SYSDATE, 'EST', 'GMT'), 'MM'), 'yyyymmdd') ||'0000';
    -- Buscando la fecha de Fin
    l_fecfin:=to_char(trunc(last_day(new_time(SYSDATE, 'EST', 'GMT'))),'yyyymmdd') || '0000';

    for c1 in c_bouquet loop

      select count(distinct(rd.codigo_tarjeta)) into total
        from operacion.rotacion_tarj_bqt rd
       where rd.bouquet=c1.bouquet;

      residuo:=mod(total,4000);
      vuelta:=trunc(total/4000);
      if residuo>0 then
        vuelta:=trunc(total/4000) + 1;
      end if;

      for i in 0 .. vuelta-1 loop

        --Declarando nombre

        l_nom_arch := operacion.pq_dth.f_genera_nombre_archivo(1, 'ps');
        --Abrir el Archivo
        operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io,pdirectorio,l_nom_arch,'W',p_resultado,p_mensaje);
        --Escribir en Archivo
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, replace(replace(l_nom_arch,'.emm',''),'ps','') ,'1');     -- Codigo del Proceso
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, trim(to_char(c1.bouquet,'00000000')), '1'); -- Código de Bouquet
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, l_fecini, '1');      -- Fecha de Inicio
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, l_fecfin, '1');      -- Fecha de Fin
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'EMM', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');

        select count(codigo_tarjeta) into l_total_tarj_arch
          from (select a.*, ROWNUM rnum
                  from (select distinct(rd.codigo_tarjeta)
                          from operacion.rotacion_tarj_bqt rd
                         where rd.bouquet=c1.bouquet
                      order by 1 asc) a
                 where rownum <= (i*4000)+4000)
         where rnum  > (i*4000);

        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,trim(to_char(l_total_tarj_arch,'000000')),'1'); -- Total de Tarjetas
        j:=1;
        for c2 in c_tarjeta(i,c1.bouquet) loop

          ntarjeta(j):=c2.codigo_tarjeta;
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,c2.codigo_tarjeta,'1');
          j:=j+1;

        end loop;

        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'ZZZ', '1');
        --Cerrar el archivo
        operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io);
        -- Guardamos los datos del archivo en la base de datos
        operacion.pq_dth_rotacion.p_reg_rota_archivo(l_nom_arch,l_total_tarj_arch,id_proceso,c1.bouquet,l_id_archivo);
        -- Guardamos el detalle del archivo en la base de datos
        operacion.pq_dth_rotacion.p_reg_rota_archivo_det(l_id_archivo,ntarjeta);
        commit;
        -- Limpiamos Arreglo
        ntarjeta.delete();
        -- Enviando Archivo como .tmp
        operacion.pq_dth_rotacion.p_enviar_archivo_ascii(phostd,
                                                         ppuertod,
                                                         pusuariod,
                                                         ppassd,
                                                         pdirectorio,
                                                         l_nom_arch,
                                                         pdirectoriod||'/'||replace(l_nom_arch,'.emm','.tmp'),
                                                         respuestenv);
        -- Verificando si se envio archivo
        if respuestenv='Ok' then
        -- Se renombra archivo a .emm
           operacion.pq_dth_rotacion.p_ren_archivo_ascii(phostd,
                                                         ppuertod,
                                                         pusuariod,
                                                         ppassd,
                                                         pdirectoriod||'/'||replace(l_nom_arch,'.emm','.tmp'),
                                                         pdirectoriod||'/'||l_nom_arch,
                                                         respustaren);
           if respustaren='Ok' then
           -- Actualizando archivo como Enviado
              update operacion.rotacion_auto_archivo
                 set nro_intento=1,
                     estado_arch='2'
               where id_archivo=l_id_archivo;
              commit;
           end if;
        end if;
      end loop;
    end loop;
    update operacion.cab_rotacion_dth
       set flg_p=1
     where id_proceso=id_proceso;
    commit;
exception when others then
  rollback;
  raise_application_error(-20080, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de generar el archivo de activacion/corte manual de DTH por Paquete
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_crea_arch_conax_manu_p(id_proceso in number,
                                   paquete in number,
                                   tip_proceso in varchar2)
is
respuestenv varchar2(1000);
respustaren varchar2(1000);
ntarjeta v_ntarjeta;
total number;
i number;
j number;
p_text_io utl_file.file_type;
l_nom_arch varchar2(30);
l_fecini varchar2(12);
l_fecfin varchar2(12);
id_proc_arch varchar2(12);
p_resultado varchar2(100);
p_mensaje varchar2(1000);
l_id_archivo number;
vuelta number;
l_total_tarj_arch number;
l_tipo_cli number;
residuo number;
cursor c_bouquet is
select ogb.codbouquet
  from operacion.ope_grupo_bouquet_det ogb
 where ogb.flg_activo=1
   and ogb.idgrupo=paquete
order by ogb.codbouquet;

cursor c_tarjeta(x number) is
select codigo_tarjeta
  from ( select a.*, ROWNUM rnum
      from ( select distinct(d.codigo_tarjeta)
  from operacion.det_atc_cort_manu_dth d
 where d.id_proc_manu = id_proceso
   and d.flg_verif='1' -- Codigo Valido
order by d.codigo_tarjeta asc) a
      where rownum <= (x*4000)+4000 ) where rnum  > (x*4000);

begin
    -- Buscando la fecha de Inicio
    l_fecini:=to_char(trunc(new_time(SYSDATE, 'EST', 'GMT'), 'MM'), 'yyyymmdd')||'0000';
    -- Buscando la fecha de Fin
    l_fecfin:=to_char(trunc(last_day(new_time(SYSDATE, 'EST', 'GMT'))),'yyyymmdd') || '0000';

    select cac.tipo_cliente into l_tipo_cli
      from operacion.cab_atc_cort_manu_dth cac
     where cac.id_proc_manu=id_proceso;

    for c1 in c_bouquet loop

      select count(distinct(codigo_tarjeta)) into total
        from operacion.det_atc_cort_manu_dth d
       where d.id_proc_manu = id_proceso
         and d.flg_verif='1';
      residuo:=mod(total,4000);
      vuelta:=trunc(total/4000);
      if residuo>0 then
        vuelta:=trunc(total/4000) + 1;
      end if;

      for i in 0 .. vuelta-1 loop

        --Declarando nombre
        if tip_proceso='1' then -- Activacion
           if l_tipo_cli=1 then -- Pre-Pago
              l_nom_arch := operacion.pq_dth.f_genera_nombre_archivo(0, 'ps');

           end if;
           if l_tipo_cli=2 then -- Post-Pago
              l_nom_arch := operacion.pq_dth.f_genera_nombre_archivo(1, 'ps');
           end if;

           id_proc_arch:=replace(replace(l_nom_arch,'.emm',''),'ps','');
        end if;

        if tip_proceso='2' then -- Corte
           if l_tipo_cli=1 then -- Pre-Pago
              l_nom_arch := operacion.pq_dth.f_genera_nombre_archivo(0, 'cs');
           end if;
           if l_tipo_cli=2 then -- Post-Pago
              l_nom_arch := operacion.pq_dth.f_genera_nombre_archivo(1, 'cs');
           end if;
           id_proc_arch:=replace(replace(l_nom_arch,'.emm',''),'cs','');
        end if;
        --Abrir el Archivo
        operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io,pdirectorio,l_nom_arch,'W',p_resultado,p_mensaje);
        --Escribir en Archivo
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, id_proc_arch ,'1');     -- Codigo del Proceso
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, trim(to_char(c1.codbouquet,'00000000')), '1'); -- Código de Bouquet
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, l_fecini, '1');      -- Fecha de Inicio
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, l_fecfin, '1');      -- Fecha de Fin
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'EMM', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');

        select count(codigo_tarjeta) into l_total_tarj_arch
          from ( select a.*, ROWNUM rnum
                   from ( select distinct(d.codigo_tarjeta)
                            from operacion.det_atc_cort_manu_dth d
                           where d.id_proc_manu = id_proceso
                             and d.flg_verif='1'
                        order by d.codigo_tarjeta asc) a
                  where rownum <= (i*4000)+4000)
         where rnum  > (i*4000);

        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,trim(to_char(l_total_tarj_arch,'000000')),'1');          -- Total de Tarjetas
        j:=1;
        for c2 in c_tarjeta(i) loop

          ntarjeta(j):=c2.codigo_tarjeta;
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,c2.codigo_tarjeta,'1');
          j:=j+1;

        end loop;

        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'ZZZ', '1');
        --Cerrar el archivo
        operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io);

        -- Guardamos los datos del archivo en la base de datos
        operacion.pq_dth_rotacion.p_reg_ac_manu_archivo(l_nom_arch,l_total_tarj_arch,id_proceso,l_id_archivo);

        -- Guardamos el detalle del archivo en la base de datos

        operacion.pq_dth_rotacion.p_reg_ac_manu_archivo_det(l_id_archivo,ntarjeta);
        commit;
        -- Limpiamos Arreglo
        ntarjeta.delete();
        -- Enviando Archivo
        operacion.pq_dth_rotacion.p_enviar_archivo_ascii(phostd,
                                                         ppuertod,
                                                         pusuariod,
                                                         ppassd,
                                                         pdirectorio,
                                                         l_nom_arch,
                                                         pdirectoriod||'/'||replace(l_nom_arch,'.emm','.tmp'),
                                                         respuestenv);
        -- Verificando si se envio archivo
        if respuestenv='Ok' then
           operacion.pq_dth_rotacion.p_ren_archivo_ascii(phostd,
                                                         ppuertod,
                                                         pusuariod,
                                                         ppassd,
                                                         pdirectoriod||'/'||replace(l_nom_arch,'.emm','.tmp'),
                                                         pdirectoriod||'/'||l_nom_arch,
                                                         respustaren);
           if respustaren='Ok' then
              update operacion.cab_atc_cort_archivo
                 set nro_intento=1,
                     estado_arch='2'
               where id_archivo=l_id_archivo;
              commit;
           end if;
        end if;
      end loop;
    end loop;
    update operacion.cab_atc_cort_manu_dth
       set flg_p=1
     where id_proc_manu=id_proceso;
    commit;
exception when others then raise_application_error(-20080, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de generar el archivo de activacion/corte manual de DTH por Bouquet
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_crea_arch_conax_manu_b(id_proceso in number,
                                   tip_proceso in varchar2)
is
respuestenv varchar2(1000);
respustaren varchar2(1000);
ntarjeta v_ntarjeta;
total number;
i number;
j number;
p_text_io utl_file.file_type;
l_nom_arch varchar2(30);
l_fecini varchar2(12);
l_fecfin varchar2(12);
id_proc_arch number;
p_resultado varchar2(100);
p_mensaje varchar2(1000);
l_id_archivo number;
vuelta number;
l_total_tarj_arch number;
l_tipo_cli number;
residuo number;
cursor c_bouquet is
select db.bouquet
  from operacion.det_atc_cort_manu_dth_b db
 where db.id_proc_manu=id_proceso;

cursor c_tarjeta(x number) is
select codigo_tarjeta
  from ( select a.*, ROWNUM rnum
      from ( select distinct(d.codigo_tarjeta)
               from operacion.det_atc_cort_manu_dth d
              where d.id_proc_manu = id_proceso
                and d.flg_verif='1' -- Codigo Valido
order by d.codigo_tarjeta asc) a
      where rownum <= (x*4000)+4000 ) where rnum  > (x*4000);

begin
    -- Buscando la fecha de Inicio
    l_fecini:=to_char(trunc(new_time(SYSDATE, 'EST', 'GMT'), 'MM'), 'yyyymmdd') ||'0000';
    -- Buscando la fecha de Fin
    l_fecfin:=to_char(trunc(last_day(new_time(SYSDATE, 'EST', 'GMT'))),'yyyymmdd') || '0000';

    select cac.tipo_cliente into l_tipo_cli
      from operacion.cab_atc_cort_manu_dth cac
     where cac.id_proc_manu=id_proceso;

    for c1 in c_bouquet loop

      select count(distinct(codigo_tarjeta)) into total
        from operacion.det_atc_cort_manu_dth d
       where d.id_proc_manu = id_proceso
         and d.flg_verif='1';

      residuo:=mod(total,4000);
      vuelta:=trunc(total/4000);

      if residuo>0 then
        vuelta:=trunc(total/4000) + 1;
      end if;

      for i in 0 .. vuelta-1 loop

        --Declarando nombre
        if tip_proceso='1' then -- Activacion
           if l_tipo_cli=1 then -- Pre-Pago
              l_nom_arch := operacion.pq_dth.f_genera_nombre_archivo(0, 'ps');
           end if;
           if l_tipo_cli=2 then -- Post-Pago
              l_nom_arch := operacion.pq_dth.f_genera_nombre_archivo(1, 'ps');
           end if;
           id_proc_arch:=replace(replace(l_nom_arch,'.emm',''),'ps','');
        end if;

        if tip_proceso='2' then -- Corte
           if l_tipo_cli=1 then -- Pre-Pago
              l_nom_arch := operacion.pq_dth.f_genera_nombre_archivo(0, 'cs');
           end if;
           if l_tipo_cli=2 then -- Post-Pago
              l_nom_arch := operacion.pq_dth.f_genera_nombre_archivo(1, 'cs');
           end if;
           id_proc_arch:=replace(replace(l_nom_arch,'.emm',''),'cs','');
        end if;
        --Abrir el Archivo
        operacion.pq_dth_interfaz.p_abrir_archivo(p_text_io,pdirectorio,l_nom_arch,'W',p_resultado,p_mensaje);
        --Escribir en Archivo
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, id_proc_arch,'1');     -- Codigo del Proceso
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, trim(to_char(c1.bouquet,'00000000')), '1'); -- Código de Bouquet
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, l_fecini, '1');      -- Fecha de Inicio
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, l_fecfin, '1');      -- Fecha de Fin
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'EMM', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'U', '1');

        select count(codigo_tarjeta) into l_total_tarj_arch
          from ( select a.*, ROWNUM rnum
              from ( select distinct(d.codigo_tarjeta)
          from operacion.det_atc_cort_manu_dth d
         where d.id_proc_manu = id_proceso
           and d.flg_verif='1'
        order by d.codigo_tarjeta asc) a
              where rownum <= (i*4000)+4000 ) where rnum  > (i*4000);

        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,trim(to_char(l_total_tarj_arch,'000000')),'1');
        j:=1;
        for c2 in c_tarjeta(i) loop

          ntarjeta(j):=c2.codigo_tarjeta;
          operacion.pq_dth_interfaz.p_escribe_linea(p_text_io,c2.codigo_tarjeta,'1');
          j:=j+1;

        end loop;

        operacion.pq_dth_interfaz.p_escribe_linea(p_text_io, 'ZZZ', '1');
        --Cerrar el archivo
        operacion.pq_dth_interfaz.p_cerrar_archivo(p_text_io);

        -- Guardamos los datos del archivo en la base de datos
        operacion.pq_dth_rotacion.p_reg_ac_manu_archivo(l_nom_arch,l_total_tarj_arch,id_proceso,l_id_archivo);

        -- Guardamos el detalle del archivo en la base de datos

        operacion.pq_dth_rotacion.p_reg_ac_manu_archivo_det(l_id_archivo,ntarjeta);
        commit;
        -- Limpiamos Arreglo
        ntarjeta.delete();
        -- Enviando Archivo
        operacion.pq_dth_rotacion.p_enviar_archivo_ascii(phostd,
                                                         ppuertod,
                                                         pusuariod,
                                                         ppassd,
                                                         pdirectorio,
                                                         l_nom_arch,
                                                         pdirectoriod||'/'||replace(l_nom_arch,'.emm','.tmp'),
                                                         respuestenv);
        -- Verificando si se envio archivo
        if respuestenv='Ok' then
           operacion.pq_dth_rotacion.p_ren_archivo_ascii(phostd,
                                                         ppuertod,
                                                         pusuariod,
                                                         ppassd,
                                                         pdirectoriod||'/'||replace(l_nom_arch,'.emm','.tmp'),
                                                         pdirectoriod||'/'||l_nom_arch,
                                                         respustaren);
           if respustaren='Ok' then
              update operacion.cab_atc_cort_archivo
                 set nro_intento=1,
                     estado_arch='2'
               where id_archivo=l_id_archivo;
              commit;
           end if;
        end if;
      end loop;
    end loop;
    update operacion.cab_atc_cort_manu_dth
       set flg_p=1
     where id_proc_manu=id_proceso;
    commit;
exception when others then raise_application_error(-20080, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de la validacion de codigos de tarjetas del proceso de activacion/corte
                      manual de DTH
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_val_det_ac_manu(id_proc in number)
is
type matriz_rowid is table of rowid;
type matriz_codtar is table of operacion.det_atc_cort_manu_dth.codigo_tarjeta%type;
type matriz_flg_verif is table of operacion.det_atc_cort_manu_dth.flg_verif%type;
m_rowid matriz_rowid;
m_codtar matriz_codtar;
m_flg_verif matriz_flg_verif;
cursor c_tarj(pr number) is
select rowid as ri,dr.codigo_tarjeta,dr.flg_verif
  from operacion.det_atc_cort_manu_dth dr
 where dr.id_proc_manu=pr;
begin
  open c_tarj(id_proc);
  loop
    exit when c_tarj%notfound;
    fetch c_tarj bulk collect into  m_rowid,m_codtar,m_flg_verif limit 1000;
    for i in 1 .. m_rowid.count
    loop
      m_flg_verif(i):=operacion.pq_dth_rotacion.f_val_cod_tarjeta(m_codtar(i));
    end loop;
    forall i in 1 .. m_rowid.count
       update operacion.det_atc_cort_manu_dth
          set flg_verif=m_flg_verif(i)
        where rowid=m_rowid(i)
          and id_proc_manu=id_proc;
    commit;
  end loop;
  close c_tarj;

exception when others then raise_application_error(-20080, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de generacion de archivo de rotacion de DTH
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_arch_rotacion
is
ln_cant_tarjetas number;
cursor c_rota is
  select cr.id_proceso
    from operacion.cab_rotacion_dth cr
   where cr.fecha_reg<=sysdate
     and cr.estado='1'
     and cr.flg_p=0;
begin
   for c1 in c_rota loop
     -- Creando los Archivos
     operacion.pq_dth_rotacion.p_crea_arch_conax_rota(c1.id_proceso);
     -- Verificando la cantidad de tarjetas trabajadas
     select count(distinct(rd.codigo_tarjeta)) into ln_cant_tarjetas
       from operacion.rotacion_tarj_bqt rd;
     -- Estableciendo la fecha de ejecucion
     update operacion.cab_rotacion_dth
        set fecha_envio=sysdate
      where id_proceso=c1.id_proceso;
     -- Estableciendo la cantidad de tarjetas
     update operacion.cab_rotacion_dth
        set cant_tot_tarj=ln_cant_tarjetas
      where id_proceso=c1.id_proceso;
     commit;
   end loop;

exception when others then raise_application_error(-20080, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de generacion de archivo de activacion/corte manual de
                      DTH
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_arch_manu
is
cursor c_manu is
  select cr.id_proc_manu,
         cr.id_paquete,
         cr.tipo_proc,
         cr.tip_ac
    from operacion.cab_atc_cort_manu_dth cr
   where cr.fecha_ejec<=sysdate
     and cr.estado=1
     and cr.flg_p=0
order by cr.id_proc_manu asc;
begin
   for c1 in c_manu loop
     -- Validando registros
     operacion.pq_dth_rotacion.p_val_det_ac_manu(c1.id_proc_manu);
     -- Creando los Archivos
     -- Por tipo Paquete
     if c1.tip_ac='P' then
       operacion.pq_dth_rotacion.p_crea_arch_conax_manu_p(c1.id_proc_manu,c1.id_paquete,c1.tipo_proc);
     end if;
     -- Por tipo Bouquet
     if c1.tip_ac='B' then
       operacion.pq_dth_rotacion.p_crea_arch_conax_manu_b(c1.id_proc_manu,c1.tipo_proc);
     end if;
   end loop;
exception when others then raise_application_error(-20080, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de activacion/corte manual de DTH
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_act_desac_manu
is
begin
  -- Generación de Archivos a .Emm
  operacion.pq_dth_rotacion.p_gen_arch_manu;
exception when others then raise_application_error(-20080, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de cambio de estado de los archivos de activacion/corte
                      manual de DTH
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_est_act_desac_manu
is
err_cab_act_dsc exception;
err_verif   exception;
b_verif     boolean;
respuestenv varchar2(100);
respuestavrf varchar2(100);
respustaren varchar2(100);
resptel varchar2(100);
cant_tot_tarj number;
cant_ok_tarj number;
cant_err_tarj number;
cursor c_manu_p is
  select cr.id_proc_manu
    from operacion.cab_atc_cort_manu_dth cr
   where cr.estado=1 -- Estado en Proceso
order by cr.id_proc_manu asc;
cursor c_arch(p number) is
select rm.id_archivo,
       rm.nom_archivo,
       rm.estado_arch,
       rm.nro_intento
  from operacion.cab_atc_cort_archivo rm
 where rm.id_proceso=p
order by rm.id_archivo asc;
begin
  for c1 in c_manu_p loop
       for c2 in c_arch(c1.id_proc_manu) loop
         begin
           b_verif:=false;
           if c2.estado_arch='2' then -- Estado Enviado
                -- Verifica Estado Ok
                operacion.pq_dth_rotacion.p_vrf_archivo_ascii(phostd,
                                                              ppuertod,
                                                              pusuariod,
                                                              ppassd,
                                                              pdirectoriok||c2.nom_archivo,
                                                              respuestavrf);
                if respuestavrf='Ok' then
                   update operacion.cab_atc_cort_archivo
                      set estado_arch='3' -- Estado: Enviado Ok
                    where id_archivo=c2.id_archivo;
                   -- Eliminando Archivo de carpeta Ok del servidor destino
                   operacion.pq_dth_rotacion.p_eliminar_archivo_ascii(phostd,
                                                                      ppuertod,
                                                                      pusuariod,
                                                                      ppassd,
                                                                      pdirectoriok||'/'||c2.nom_archivo,
                                                                      resptel);
                 -- Elimino Archivo de Servidor Origen
                 operacion.pq_dth_rotacion.p_eliminar_archivo(pdirectorio,
                                                              c2.nom_archivo);
                 b_verif:=true;
                end if;
                
                if b_verif=false then
                    -- Verifica Estado Err
                    operacion.pq_dth_rotacion.p_vrf_archivo_ascii(phostd,
                                                                  ppuertod,
                                                                  pusuariod,
                                                                  ppassd,
                                                                  pdirectorior||c2.nom_archivo,
                                                                  respuestavrf);
                    if respuestavrf='Ok' then
                       if c2.nro_intento<5 then
                          update operacion.cab_atc_cort_archivo
                             set estado_arch='2',
                                 nro_intento=nro_intento+1 -- Estado: Enviado
                           where id_archivo=c2.id_archivo;
                          -- Eliminando Archivo de la carpeta Error del Servidor destino
                          operacion.pq_dth_rotacion.p_eliminar_archivo_ascii(phostd,
                                                                             ppuertod,
                                                                             pusuariod,
                                                                             ppassd,
                                                                             pdirectorior||'/'||c2.nom_archivo,
                                                                             resptel);
                          -- Reenvio Archivo
                          operacion.pq_dth_rotacion.p_enviar_archivo_ascii(phostd,
                                                                           ppuertod,
                                                                           pusuariod,
                                                                           ppassd,
                                                                           pdirectorio,
                                                                           c2.nom_archivo,
                                                                           pdirectoriod||'/'||replace(c2.nom_archivo,'.emm','.tmp'),
                                                                           respuestenv);
                          -- Renombro Archivo
                          operacion.pq_dth_rotacion.p_ren_archivo_ascii(phostd,
                                                                        ppuertod,
                                                                        pusuariod,
                                                                        ppassd,
                                                                        pdirectoriod||'/'||replace(c2.nom_archivo,'.emm','.tmp'),
                                                                        pdirectoriod||'/'||c2.nom_archivo,
                                                                        respustaren);
                        end if;

                        if c2.nro_intento=5 then
                           update operacion.cab_atc_cort_archivo
                              set estado_arch='4' -- Estado: Enviado con Error
                            where id_archivo=c2.id_archivo;
                            -- Eliminando Archivo de la carpeta Error del Servidor destino
                            operacion.pq_dth_rotacion.p_eliminar_archivo_ascii(phostd,
                                                                               ppuertod,
                                                                               pusuariod,
                                                                               ppassd,
                                                                               pdirectorior||'/'||c2.nom_archivo,
                                                                               resptel);
                             -- Elimino Archivo de Servidor Origen
                             operacion.pq_dth_rotacion.p_eliminar_archivo(pdirectorio,
                                                                          c2.nom_archivo);
                        end if;
                    end if;
                end if;
            end if;
           commit;
         exception when others then raise err_verif;
         end;
       end loop;
           begin
           select count(id_archivo) into cant_tot_tarj
             from operacion.cab_atc_cort_archivo ca
            where ca.id_proceso=c1.id_proc_manu;

           select count(id_archivo) into cant_ok_tarj
             from operacion.cab_atc_cort_archivo ca
            where ca.id_proceso=c1.id_proc_manu
              and ca.estado_arch='3';

           select count(id_archivo) into cant_err_tarj
             from operacion.cab_atc_cort_archivo ca
            where ca.id_proceso=c1.id_proc_manu
              and ca.estado_arch='4';

           if cant_tot_tarj=cant_ok_tarj then
              update operacion.cab_atc_cort_manu_dth
                 set estado=2 -- Estado: Enviado Ok
               where id_proc_manu=c1.id_proc_manu;
           end if;
           if cant_err_tarj>0 then
              if cant_err_tarj+cant_ok_tarj=cant_tot_tarj then
                 update operacion.cab_atc_cort_manu_dth
                    set estado=3 -- Estado: Enviado con Error
                  where id_proc_manu=c1.id_proc_manu;
              end if;
           end if;
           commit;
           exception when others then raise err_cab_act_dsc;
           end;
   end loop;
exception when err_verif then
            raise_application_error(-20060, 'Hubo un error al momento de Verificar el archivo. Se ha producido el error: '||sqlerrm);
            rollback;
          when err_cab_act_dsc then
            raise_application_error(-20070, 'Hubo un error al momento de Actualizar el estado del proceso manual. Se ha producido el error: '||sqlerrm);
            rollback;
          when others then
            raise_application_error(-20080, 'Se ha producido el error: '||sqlerrm);
            rollback;
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de cambio de estado de los archivos de rotacion de DTH
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_est_rotacion
is
err_cab_rot exception;
err_verifr   exception;
b_verif     boolean;
respuestenv varchar2(100);
respuestavrf varchar2(100);
respustaren varchar2(100);
resptel       varchar2(100);
cant_tot_tarj number;
cant_ok_tarj number;
cant_err_tarj number;
cursor c_manu_p is
  select cr.id_proceso
    from operacion.cab_rotacion_dth cr
   where cr.estado='1' -- Estado en Proceso
order by cr.id_proceso asc;
cursor c_arch(p number) is
select rm.id_archivo,
       rm.nom_archivo,
       rm.id_proceso,
       rm.estado_arch,
       rm.nro_intento
  from operacion.rotacion_auto_archivo rm
 where rm.id_proceso=p
order by rm.id_archivo asc;
begin
  for c1 in c_manu_p loop
       for c2 in c_arch(c1.id_proceso) loop
         begin
             b_verif:=false;
             if c2.estado_arch='2' then -- Estado Enviado
                -- Verifica Estado Ok
                operacion.pq_dth_rotacion.p_vrf_archivo_ascii(phostd,
                                                              ppuertod,
                                                              pusuariod,
                                                              ppassd,
                                                              pdirectoriok||c2.nom_archivo,
                                                              respuestavrf);
                if respuestavrf='Ok' then
                   update operacion.rotacion_auto_archivo
                      set estado_arch='3' -- Estado: Ok
                    where id_archivo=c2.id_archivo;
                   -- Elimino Archivo de Servidor Destino de la carpeta Ok
                   operacion.pq_dth_rotacion.p_eliminar_archivo_ascii(phostd,
                                                                      ppuertod,
                                                                      pusuariod,
                                                                      ppassd,
                                                                      pdirectoriok||'/'||c2.nom_archivo,
                                                                      resptel);
                   -- Elimino Archivo de Servidor Origen
                   operacion.pq_dth_rotacion.p_eliminar_archivo(pdirectorio,
                                                                c2.nom_archivo);
                   b_verif:=true;
                end if;

                if b_verif=false then                
                   -- Verifica Estado Err
                   operacion.pq_dth_rotacion.p_vrf_archivo_ascii(phostd,
                                                                 ppuertod,
                                                                 pusuariod,
                                                                 ppassd,
                                                                 pdirectorior||c2.nom_archivo,
                                                                 respuestavrf);
                   if respuestavrf='Ok' then
                      if c2.nro_intento<5 then
                        update operacion.rotacion_auto_archivo
                           set estado_arch='2', -- Estado: Enviado
                               nro_intento=nro_intento+1
                         where id_archivo=c2.id_archivo;
                        -- Elimino Archivo de Servidor Destino de la carpeta error
                        operacion.pq_dth_rotacion.p_eliminar_archivo_ascii(phostd,
                                                                           ppuertod,
                                                                           pusuariod,
                                                                           ppassd,
                                                                           pdirectorior||'/'||c2.nom_archivo,
                                                                           resptel);
                        -- Reenvio Archivo
                        operacion.pq_dth_rotacion.p_enviar_archivo_ascii(phostd,
                                                                         ppuertod,
                                                                         pusuariod,
                                                                         ppassd,
                                                                         pdirectorio,
                                                                         c2.nom_archivo,
                                                                         pdirectoriod||'/'||replace(c2.nom_archivo,'.emm','.tmp'),
                                                                         respuestenv);
                        -- Renombro Archivo
                        operacion.pq_dth_rotacion.p_ren_archivo_ascii(phostd,
                                                                      ppuertod,
                                                                      pusuariod,
                                                                      ppassd,
                                                                      pdirectoriod||'/'||replace(c2.nom_archivo,'.emm','.tmp'),
                                                                      pdirectoriod||'/'||c2.nom_archivo,
                                                                      respustaren);
                     end if;
                     if c2.nro_intento=5 then
                        -- Actualizado estado de archivo
                        update operacion.rotacion_auto_archivo
                           set estado_arch='4' -- Estado: Error
                         where id_archivo=c2.id_archivo;
                        -- Elimino Archivo de Servidor Destino
                        operacion.pq_dth_rotacion.p_eliminar_archivo_ascii(phostd,
                                                                           ppuertod,
                                                                           pusuariod,
                                                                           ppassd,
                                                                           pdirectorior||'/'||c2.nom_archivo,
                                                                           resptel);
                        -- Elimino Archivo de Servidor Origen
                        operacion.pq_dth_rotacion.p_eliminar_archivo(pdirectorio,
                                                                     c2.nom_archivo);
                     end if;
                  end if;
                end if;
             end if;
             commit;
         exception when others then raise err_verifr;
         end;
       end loop;
       begin
       select count(id_archivo) into cant_tot_tarj
         from operacion.rotacion_auto_archivo ca
        where ca.id_proceso=c1.id_proceso;

       select count(id_archivo) into cant_ok_tarj
         from operacion.rotacion_auto_archivo ca
        where ca.id_proceso=c1.id_proceso
          and ca.estado_arch='3';

       select count(id_archivo) into cant_err_tarj
         from operacion.rotacion_auto_archivo ca
        where ca.id_proceso=c1.id_proceso
          and ca.estado_arch='4';

       if cant_tot_tarj=cant_ok_tarj then
          update operacion.cab_rotacion_dth
             set estado=2 -- Estado: Enviado Ok
           where id_proceso=c1.id_proceso;
       end if;
       if cant_err_tarj>0 then
          if cant_err_tarj+cant_ok_tarj=cant_tot_tarj then
             update operacion.cab_rotacion_dth
                set estado=3 -- Estado: Enviado con Error
              where id_proceso=c1.id_proceso;
             -- Se enviara correo de informe de errores
             p_inf_err_rotacion(c1.id_proceso);
          end if;
       end if;
       commit;
       exception when others then raise err_cab_rot;
       end;
   end loop;
exception when err_verifr then
            raise_application_error(-20060, 'Hubo un error al momento de Verificar el archivo. Se ha producido el error: '||sqlerrm);
            rollback;
          when err_cab_rot then
            raise_application_error(-20070, 'Hubo un error al momento de Actualizar el estado de la Rotación. Se ha producido el error: '||sqlerrm);
            rollback;
          when others then
            raise_application_error(-20080, 'Se ha producido el error: '||sqlerrm);
            rollback;
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de envio de informe de error de rotacion
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_inf_err_rotacion(idproceso in number)
is
email_inf varchar2(100);
titulo_inf varchar2(100);
mensaje varchar2(32767);
mes varchar2(2);
anho varchar2(4);
fec_ejec varchar2(50);
total_arch number;
total_arch_err number;
cursor c_arch_bouquet is
select ra.nom_archivo,ra.id_archivo
  from operacion.rotacion_auto_archivo ra
 where ra.id_proceso = idproceso
   and ra.estado_arch='4';-- Estado en Error
begin
  -- Seteando el valor del email para que le enviemos el informe de error
  email_inf:=operacion.pq_dth_rotacion.f_obt_parametro_d('PARAM_ROTA_M','MAILR');
  -- Seteando el Titulo del correo.
  titulo_inf:=operacion.pq_dth_rotacion.f_obt_parametro_d('PARAM_ROTA_M','MAILT');
  -- Estableciendo el mes y el año
  select crd.mes,crd.anho,to_char(crd.fecha_envio) into mes,anho,fec_ejec
    from operacion.cab_rotacion_dth crd
   where crd.id_proceso=idproceso;
  -- Cantidad total de archivos generados
  select count(1) into total_arch
    from operacion.rotacion_auto_archivo raa
   where raa.id_proceso=idproceso;
  -- Cantidad de archivos generados errados
  select count(1) into total_arch_err
    from operacion.rotacion_auto_archivo raa
   where raa.id_proceso=idproceso
     and raa.estado_arch='4';
  -- Seteando el mensaje del correo.
  mensaje:='Estimado Usuario(a),' || chr(13) || chr(13) ||
           'Se ha producido un error durante la ejecución del proceso de rotación con los siguientes datos: ' || chr(13) || chr(13) ||
           '- Identificador: ' || idproceso || chr(13) ||
           '- Proceso: ' || f_conv_mes(mes) || ' ' || anho || chr(13) ||
           '- Fecha de ejecución: '|| fec_ejec || chr(13) ||
           '- Total de archivos generados: ' || total_arch || chr(13) ||
           '- Total de archivos errados: ' || total_arch_err || chr(13) || chr(13) ||
           'Lista de archivos errados: ' || chr(13) || chr(13);
  for c1 in c_arch_bouquet loop
      mensaje:=mensaje||'- ' || c1.nom_archivo || chr(13);
  end loop;
  -- Enviando el mensaje del correo.
  soporte.p_envia_correo_c_attach(titulo_inf,
                                  email_inf,
                                  mensaje,
                                  null);
exception when others then raise_application_error(-20080, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de generacion de datos base para el postpago
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_dat_postpago(id_proc in number)
is
type array_object is table of operacion.rotacion_datos%rowtype index by binary_integer;
var_arreglo array_object;
cursor c_postpago is
select distinct id_proc,
                to_char(dat.customer_id),
                dat.co_id,
                null,
                null,
                dat.status,
                trim(ltrim(tar.nro_tarjeta, '"')),
                to_char(dat.sncode),
                '1'
  from (select co.co_id, dn.dn_num, snh.sncode, ca.customer_id, snh.status
          from contract_all@dbl_bscs_bf        co,
               curr_co_status@dbl_bscs_bf      ch,
               customer_all@dbl_bscs_bf        ca,
               contr_services_cap@dbl_bscs_bf  cp,
               directory_number@dbl_bscs_bf    dn,
               pr_serv_status_hist@dbl_bscs_bf snh
         where co.tmcode = 200
           and ch.co_id = co.co_id
           and ch.ch_status = 'a'
           and cp.co_id = co.co_id
           and cp.sncode = 200
           and cp.seqno = 1
           and dn.dn_id = cp.dn_id
           and ca.customer_id = co.customer_id
           and ca.billcycle < '30'
           and snh.co_id = co.co_id
           and histno = (select max(histno)
                           from pr_serv_status_hist@dbl_bscs_bf
                          where co_id = snh.co_id
                            and sncode = snh.sncode)
           and snh.valid_from_date is not null
           and snh.status = 'A'
           and trunc(snh.valid_from_date) <= trunc(sysdate)
        UNION
        select co.co_id, dn.dn_num, snh.sncode, ca.customer_id, snh.status
          from contract_all@dbl_bscs_bf        co,
               curr_co_status@dbl_bscs_bf      ch,
               customer_all@dbl_bscs_bf        ca,
               contr_services_cap@dbl_bscs_bf  cp,
               directory_number@dbl_bscs_bf    dn,
               pr_serv_status_hist@dbl_bscs_bf snh
         where co.tmcode = 200 -- dthpostpago
           and ch.co_id = co.co_id
           and ch.ch_status in ('o', 'a')
           and cp.co_id = co.co_id
           and cp.sncode = 200
           and cp.seqno = 1
           and dn.dn_id = cp.dn_id
           and ca.customer_id = co.customer_id
           and ca.billcycle < '30'
           and snh.co_id = co.co_id
           and histno = (select max(histno)
                           from pr_serv_status_hist@dbl_bscs_bf snx,
                                mdsrrtab@dbl_bscs_bf            rr
                          where snx.co_id = snh.co_id
                            and snx.sncode = snh.sncode
                            and rr.request = snx.request_id
                            and trunc(rr.action_date) <= trunc(sysdate)
                            and snx.valid_from_date is null)
           and snh.status = 'A'
        UNION
        select co.co_id, dn.dn_num, snh.sncode, ca.customer_id, snh.status
          from contract_all@dbl_bscs_bf        co,
               curr_co_status@dbl_bscs_bf      ch,
               customer_all@dbl_bscs_bf        ca,
               contr_services_cap@dbl_bscs_bf  cp,
               directory_number@dbl_bscs_bf    dn,
               pr_serv_status_hist@dbl_bscs_bf snh
         where co.tmcode = 200
           and ch.co_id = co.co_id
           and ch.ch_status = 'a'
           and cp.co_id = co.co_id
           and cp.sncode = 200
           and cp.seqno = 1
           and dn.dn_id = cp.dn_id
           and ca.customer_id = co.customer_id
           and ca.billcycle < '30'
           and snh.co_id = co.co_id
           and histno = (select max(histno)
                           from pr_serv_status_hist@dbl_bscs_bf snx,
                                mdsrrtab@dbl_bscs_bf            rr
                          where snx.co_id = snh.co_id
                            and snx.sncode = snh.sncode
                            and rr.request = snx.request_id
                            and trunc(rr.action_date) > trunc(sysdate)
                            and snx.valid_from_date is null)
           and snh.status = 'D') dat,
       tim.pp_dth_prov@dbl_bscs_bf prov,
       tim.pp_dth_tarjeta@dbl_bscs_bf tar,
       tim.pp_gmd_buquet@dbl_bscs_bf buq
 where prov.co_id = dat.co_id
   and tar.id_tarjeta = prov.id_tarjeta
   and buq.sncode = dat.sncode
   and tar.nro_tarjeta is not null
   and prov.fecha_desact is null;
begin
   open c_postpago;
   loop
   fetch c_postpago bulk collect into var_arreglo limit 1000;
      exit when var_arreglo.count=0;
      forall i in 1 .. var_arreglo.count
         insert into operacion.rotacion_datos values var_arreglo(i);
      commit;
   end loop;
   close c_postpago;
exception when others then
  rollback;
  raise_application_error(-20004, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de insercion de datos a la tabla temporal de rotacion_datos
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_tb_postpago(id_proc in number)
is
cursor c_post_t is
  select rd.tarjeta,rpp.bouquet
  from operacion.rotacion_datos rd join
       operacion.rot_paq_postpago rpp
    on rd.codsrv=rpp.sncode
   and rd.tipo_servicio='1'
   and rd.id_proceso=id_proc;
type array_object is table of operacion.rotacion_tarj_bqt%rowtype index by binary_integer;
var_arreglo array_object;
begin
   open c_post_t;
   loop
   fetch c_post_t bulk collect into var_arreglo limit 1000;
      exit when var_arreglo.count=0;
      forall i in 1 .. var_arreglo.count
         insert into operacion.rotacion_tarj_bqt values var_arreglo(i);
      commit;
 end loop;
 close c_post_t;
exception when others then
  rollback;
  raise_application_error(-20005, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de eliminar la data de la tabla temporal de postpago
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_trunc_tt_postpago
is
begin
  -- Tabla de datos de bouquet
  execute immediate 'TRUNCATE TABLE operacion.rot_paq_postpago';
exception when others then raise_application_error(-20006, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de generar los datos de postpago
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_data_postpago(id_proc in number)
is
begin
  -- Agregamos los Bouquets desde la BSCS
  operacion.pq_dth_rotacion.p_reg_paq_bscs;  
  -- Datos de Postpago
  operacion.pq_dth_rotacion.p_gen_dat_postpago(id_proc);
  -- Insercion a tabla final
  operacion.pq_dth_rotacion.p_gen_tb_postpago(id_proc);
  -- Limpieza de tabla temporal de Postpago
  operacion.pq_dth_rotacion.p_trunc_tt_postpago;
exception when others then raise_application_error(-20003, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de generar los datos de Prepago con Recarga
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_data_prepago_r(id_proc in number)
is
type array_object is table of operacion.rotacion_datos%rowtype index by binary_integer;
var_arreglo array_object;
cursor c_prep_r is
select id_proc,
       o.codcli,
       i.codinssrv,
       trunc(i.fecini),
       trunc(o.fecfinvig),
       o.estado est_reg,
       trim(se.numserie),
       ip.codsrv,
       '2'
  from operacion.ope_srv_recarga_cab o
  join operacion.ope_srv_recarga_det d
    on o.numregistro = d.numregistro
  join operacion.inssrv i
    on d.codinssrv = i.codinssrv
  join operacion.solotptoequ se
    on o.codsolot = se.codsolot
   and se.numserie is not null
  join operacion.insprd ip
    on i.codinssrv = ip.codinssrv
  join sales.paquete_venta p
    on o.idpaq = p.idpaq
  join sales.tys_tabsrvxbouquet_rel tr
    on ip.codsrv = tr.codsrv
  join (select o.codigon
          from operacion.opedd o
          join operacion.tipopedd t
            on o.tipopedd = t.tipopedd
           and t.abrev = 'PARAM_ROTA_SOL') prs
    on prs.codigon=p.idsolucion
  join (select o.codigon
          from operacion.opedd o
          join operacion.tipopedd t
            on o.tipopedd = t.tipopedd
           and t.abrev = 'PARAM_ROTA_TARJ') prt
    on prt.codigon=se.tipequ
   and tr.stsrvb = '1'
   and o.flg_recarga = 1
   and o.fecfinvig >= trunc(sysdate + 1);
begin
   open c_prep_r;
   loop
   fetch c_prep_r bulk collect into var_arreglo limit 1000;
      exit when var_arreglo.count=0;
      forall i in 1 .. var_arreglo.count
         insert into operacion.rotacion_datos values var_arreglo(i);
      commit;
 end loop;
 close c_prep_r;
exception when others then
  rollback;
  raise_application_error(-20007, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de insertar los datos de tarjetas y bouquets a la
                      tabla de rotacion para los Prepago con Recarga
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_tb_prepago_r(id_proc in number)
is
type array_object is table of operacion.rotacion_tarj_bqt%rowtype index by binary_integer;
var_arreglo array_object;
cursor c_prer_t is
select rd.tarjeta,
       od.codbouquet
  from operacion.rotacion_datos rd
  join sales.tys_tabsrvxbouquet_rel t
    on rd.codsrv=t.codsrv
  join operacion.ope_grupo_bouquet_cab o
    on t.idgrupo = o.idgrupo
  join operacion.ope_grupo_bouquet_det od
    on o.idgrupo = od.idgrupo
   and rd.id_proceso=id_proc
   and rd.tipo_servicio='2';
begin
   open c_prer_t;
   loop
   fetch c_prer_t bulk collect into var_arreglo limit 1000;
      exit when var_arreglo.count=0;
      forall i in 1 .. var_arreglo.count
         insert into operacion.rotacion_tarj_bqt values var_arreglo(i);
      commit;
 end loop;
 close c_prer_t;
exception when others then
  rollback;
  raise_application_error(-20008, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de generar los datos de Prepago con Recibo sin Emitir
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_data_prepago_rse(id_proc in number)
is
type array_object is table of operacion.rotacion_datos%rowtype index by binary_integer;
var_arreglo array_object;
cursor c_prep_rse is
  select id_proc,
         o.codcli,
         i.codinssrv,
         trunc(i.fecini) fecini,
         trunc(o.fecfinvig) fecinivig,
         o.estado est_reg,
         trim(se.numserie),
         ip.codsrv,
         '3'
    from operacion.ope_srv_recarga_cab o
    join operacion.ope_srv_recarga_det d
      on o.numregistro = d.numregistro
    join operacion.inssrv i
      on d.codinssrv = i.codinssrv
    join operacion.solotptoequ se
      on o.codsolot = se.codsolot
     and se.numserie is not null
    join operacion.insprd ip
      on i.codinssrv = ip.codinssrv
    join sales.paquete_venta p
      on o.idpaq = p.idpaq
    join sales.tys_tabsrvxbouquet_rel tr
      on ip.codsrv = tr.codsrv
    join (select o.codigon
            from operacion.opedd o
            join operacion.tipopedd t
              on o.tipopedd = t.tipopedd
             and t.abrev = 'PARAM_ROTA_SOL') prs
      on prs.codigon=p.idsolucion
    join (select o.codigon
            from operacion.opedd o
            join operacion.tipopedd t
              on o.tipopedd = t.tipopedd
             and t.abrev = 'PARAM_ROTA_TARJ') prt
      on prt.codigon=se.tipequ
    join (select o.codigon
            from operacion.opedd o
            join operacion.tipopedd t
              on o.tipopedd = t.tipopedd
             and t.abrev = 'PARAM_ROTA_M'
             and o.abreviacion='DIA_RSE') prm
      on trunc(sysdate,'DD')-trunc(i.fecini,'DD')<=prm.codigon
     and (select count(f.idfac)
            from operacion.insprd         b,
                 billcolper.instxproducto c,
                 billcolper.cr            d,
                 billcolper.bilfac        e,
                 collections.cxctabfac    f,
                 collections.cxcdetfac    j
           where b.pid = c.pid
             and c.idinstprod = d.idinstprod
             and d.idbilfac = e.idbilfac
             and e.idfaccxc = f.idfac
             and f.codcli = i.codcli
             and b.codinssrv = i.codinssrv
             and f.idfac=j.idfac
             and trunc(j.feccorfac)>=trunc(sysdate)
             and f.estfac = '02'
             and b.flgprinc = 1)=0 -- Validar que no se han generado recibos
     and tr.stsrvb = '1'
     and o.flg_recarga = 0
     and i.fecfin is null;
begin
   open c_prep_rse;
   loop
   fetch c_prep_rse bulk collect into var_arreglo limit 1000;
      exit when var_arreglo.count=0;
      forall i in 1 .. var_arreglo.count
         insert into operacion.rotacion_datos values var_arreglo(i);
      commit;
 end loop;
 close c_prep_rse;
exception when others then
  rollback;
  raise_application_error(-20009, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de insertar los datos de tarjetas y bouquets a la
                      tabla de rotacion para los Prepago con Recibo sin Emitir
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_tb_prepago_rse(id_proc in number)
is
type array_object is table of operacion.rotacion_tarj_bqt%rowtype index by binary_integer;
var_arreglo array_object;
cursor c_prep_rse is
select rd.tarjeta,
       od.codbouquet
  from operacion.rotacion_datos rd
  join sales.tys_tabsrvxbouquet_rel t
    on rd.codsrv=t.codsrv
  join operacion.ope_grupo_bouquet_cab o
    on t.idgrupo = o.idgrupo
  join operacion.ope_grupo_bouquet_det od
    on o.idgrupo = od.idgrupo
   and rd.id_proceso=id_proc
   and rd.tipo_servicio='3';
begin
   open c_prep_rse;
   loop
   fetch c_prep_rse bulk collect into var_arreglo limit 1000;
      exit when var_arreglo.count=0;
      forall i in 1 .. var_arreglo.count
         insert into operacion.rotacion_tarj_bqt values var_arreglo(i);
      commit;
   end loop;
   close c_prep_rse;
exception when others then
  rollback;
  raise_application_error(-20010, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de generar los datos de Prepago con Recibo Emitidos
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_data_prepago_re(id_proc in number)
is
type array_object is table of operacion.rotacion_datos%rowtype index by binary_integer;
var_arreglo array_object;
cursor c_prep_re is
  select id_proc,
         o.codcli,
         i.codinssrv,
         trunc(i.fecini) fecini,
         trunc(o.fecfinvig) fecfinvig,
         o.estado est_reg,
         trim(se.numserie),
         ip.codsrv,
         '4'
    from operacion.ope_srv_recarga_cab o
    join operacion.ope_srv_recarga_det d
      on o.numregistro = d.numregistro
    join operacion.inssrv i
      on d.codinssrv = i.codinssrv
    join operacion.solotptoequ se
      on o.codsolot = se.codsolot
     and se.numserie is not null
    join operacion.insprd ip
      on i.codinssrv = ip.codinssrv
    join sales.paquete_venta p
      on o.idpaq = p.idpaq
    join sales.tys_tabsrvxbouquet_rel tr
      on ip.codsrv = tr.codsrv
    join (select o.codigon
            from operacion.opedd o
            join operacion.tipopedd t
              on o.tipopedd = t.tipopedd
             and t.abrev = 'PARAM_ROTA_SOL') prs
      on prs.codigon=p.idsolucion
    join (select o.codigon
            from operacion.opedd o
            join operacion.tipopedd t
              on o.tipopedd = t.tipopedd
             and t.abrev = 'PARAM_ROTA_TARJ') prt
      on prt.codigon=se.tipequ
     and (select count(f.idfac)
            from operacion.insprd         b,
                 billcolper.instxproducto c,
                 billcolper.cr            d,
                 billcolper.bilfac        e,
                 collections.cxctabfac    f,
                 collections.cxcdetfac    j
           where b.pid = c.pid
             and c.idinstprod = d.idinstprod
             and d.idbilfac = e.idbilfac
             and e.idfaccxc = f.idfac
             and f.codcli = i.codcli
             and b.codinssrv = i.codinssrv
             and f.idfac=j.idfac
             and trunc(j.feccorfac)>=trunc(sysdate)
             and f.estfac = '02'
             and b.flgprinc = 1)=1 -- Validar la existencia de factura emitida
     and tr.stsrvb = '1'
     and o.flg_recarga = 0
     and i.fecfin is null;
begin
   open c_prep_re;
   loop
   fetch c_prep_re bulk collect into var_arreglo limit 1000;
      exit when var_arreglo.count=0;
      forall i in 1 .. var_arreglo.count
         insert into operacion.rotacion_datos values var_arreglo(i);
      commit;
   end loop;
 close c_prep_re;
exception when others then
  rollback;
  raise_application_error(-20011, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de validar los datos de Prepago con Recibo Emitidos
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_val_data_prepago_re(id_proc in number)
is
type array_object is table of operacion.rotacion_datos%rowtype index by binary_integer;
var_arreglo array_object;
cursor c_pre_re is
select rd.id_proceso,
       rd.codcli,
       rd.codinssrv,
       rd.fecini,
       rd.fecfinvig,
       rd.estado,
       rd.tarjeta,
       rd.codsrv,
       rd.tipo_servicio
  from operacion.rotacion_datos rd
 where rd.tipo_servicio='4'
   and rd.id_proceso=id_proc;
v_estado varchar2(22);
d_fecven date;
begin
  
   open c_pre_re;
   loop
   fetch c_pre_re bulk collect into var_arreglo limit 1000;
      exit when var_arreglo.count=0;
      for i in var_arreglo.first .. var_arreglo.last loop
        collections.p_est_pag_oac(var_arreglo(i).codcli,var_arreglo(i).codinssrv,v_estado,d_fecven);
          update operacion.rotacion_datos
             set estado=v_estado,
                 fecfinvig=d_fecven
           where id_proceso=id_proc
             and tipo_servicio='4'
             and codcli=var_arreglo(i).codcli
             and codinssrv=var_arreglo(i).codinssrv;
      end loop;
      commit;
 end loop;
 close c_pre_re;
exception when others then
  rollback;
  raise_application_error(-20012, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de insertar los datos de tarjetas y bouquets a la
                      tabla de rotacion para los Prepago con Recibo Emitido
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_tb_prepago_re(id_proc in number)
is
type array_object is table of operacion.rotacion_tarj_bqt%rowtype index by binary_integer;
var_arreglo array_object;
cursor c_prep_re is
select rd.tarjeta,
       od.codbouquet
  from operacion.rotacion_datos rd
  join sales.tys_tabsrvxbouquet_rel t
    on rd.codsrv=t.codsrv
  join operacion.ope_grupo_bouquet_cab o
    on t.idgrupo = o.idgrupo
  join operacion.ope_grupo_bouquet_det od
    on o.idgrupo = od.idgrupo
   and rd.id_proceso=id_proc
   and rd.tipo_servicio='4'
   and trunc(rd.fecfinvig,'DD')>=trunc(sysdate,'DD')
   and rd.estado in ('04','05'); -- Estados de Pago: '04' - Cancelado Parcialmente '05' - Cancelado Totalmente
begin
   open c_prep_re;
   loop
   fetch c_prep_re bulk collect into var_arreglo limit 1000;
      exit when var_arreglo.count=0;
      forall i in 1 .. var_arreglo.count
         insert into operacion.rotacion_tarj_bqt values var_arreglo(i);
      commit;
 end loop;
 close c_prep_re;
exception when others then
  rollback;
  raise_application_error(-20013,sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de generar los datos de Demo
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_data_demos(id_proc in number)
is
type array_object is table of operacion.rotacion_datos%rowtype index by binary_integer;
var_arreglo array_object;
cursor c_demo is
select id_proc,
       i.codcli,
       i.codinssrv,
       orc.fecinivig,
       orc.fecfinvig,
       orc.estado,
       trim(sp.numserie),
       ip.codsrv,
       '5'
  from (select vtc.codcli
          from (select o.descripcion
                  from operacion.opedd o
                  join operacion.tipopedd t
                    on o.tipopedd = t.tipopedd
                   and t.abrev = 'PARAM_ROTA_DEM'
                   and o.abreviacion = 'CLARO') pdc
          join marketing.vtatabcli vtc
            on pdc.descripcion = vtc.nomcli
        union all
        select vtc.codcli
          from (select o.descripcion
                  from operacion.opedd o
                  join operacion.tipopedd t
                    on o.tipopedd = t.tipopedd
                   and t.abrev = 'PARAM_ROTA_DEM'
                   and o.abreviacion = 'MINEDU') pdm
          join marketing.vtatabcli vtc
            on vtc.nomcli like '%' || pdm.descripcion || '%') prd
  join operacion.ope_srv_recarga_cab orc
    on prd.codcli = orc.codcli
  join operacion.ope_srv_recarga_det ord
    on orc.numregistro = ord.numregistro
  join sales.vtatabslcfac vsf
    on orc.numslc = vsf.numslc
  join operacion.inssrv i
    on ord.codinssrv = i.codinssrv
  join operacion.insprd ip
    on i.codinssrv = ip.codinssrv
   and i.estinssrv = 1
   and i.fecfin is null
  join sales.tys_tabsrvxbouquet_rel tr
    on ip.codsrv = tr.codsrv
   and tr.stsrvb = '1'
  join operacion.solot s
    on orc.codsolot = s.codsolot
  join operacion.solotptoequ sp
    on orc.codsolot = sp.codsolot
   and sp.numserie is not null
  join (select o.codigon
          from operacion.opedd o
          join operacion.tipopedd t
            on o.tipopedd = t.tipopedd
           and t.abrev = 'PARAM_ROTA_TARJ') prt
    on prt.codigon = sp.tipequ
  join (select o.codigon
          from operacion.opedd o
          join operacion.tipopedd t
            on o.tipopedd = t.tipopedd
           and t.abrev = 'PARAM_ROTA_SOL') prs
    on prs.codigon = vsf.idsolucion
  join (select o.descripcion
          from operacion.opedd o
          join operacion.tipopedd t
            on o.tipopedd = t.tipopedd
           and t.abrev = 'PARAM_ROTA_TIPS') prts
    on prts.descripcion = i.tipsrv;
begin
   open c_demo;
   loop
   fetch c_demo bulk collect into var_arreglo limit 1000;
      exit when var_arreglo.count=0;
      forall i in 1 .. var_arreglo.count
         insert into operacion.rotacion_datos values var_arreglo(i);
      commit;
 end loop;
 close c_demo;
exception when others then
  rollback;
  raise_application_error(-20014, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de la Insercion de Tarjetas y Bouquets para demos
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_tb_demos(id_proc in number)
is
type array_object is table of operacion.rotacion_tarj_bqt%rowtype index by binary_integer;
var_arreglo array_object;
cursor c_demo_t is
select rd.tarjeta,
       od.codbouquet
  from operacion.rotacion_datos rd
  join sales.tys_tabsrvxbouquet_rel t
    on rd.codsrv = t.codsrv
  join operacion.ope_grupo_bouquet_cab o
    on t.idgrupo = o.idgrupo
  join operacion.ope_grupo_bouquet_det od
    on o.idgrupo = od.idgrupo
   and rd.id_proceso = id_proc
   and rd.tipo_servicio = '5';
begin
   open c_demo_t;
   loop
   fetch c_demo_t bulk collect into var_arreglo limit 1000;
      exit when var_arreglo.count=0;
      forall i in 1 .. var_arreglo.count
         insert into operacion.rotacion_tarj_bqt values var_arreglo(i);
      commit;
 end loop;
 close c_demo_t;
exception when others then
  rollback;
  raise_application_error(-20015, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de generar los datos de Promociones
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_data_promociones(id_proc in number)
is
begin
  -- Creacion datos de Promociones por Venta/Alta
  operacion.pq_dth_rotacion.p_gen_data_prom_va(id_proc);
  -- Creacion de datos de Tarjetas y Bouquets Promociones por Venta/Alta
  operacion.pq_dth_rotacion.p_gen_tb_prom_va(id_proc);
  -- Creacion datos de Promociones por Carga de Informacio y Por Pago/Recarga
  operacion.pq_dth_rotacion.p_gen_data_prom_cp(id_proc);
  -- Creacion de datos de Tarjetas y Bouquets Promociones por Carga de Informacion y Por Pago/Recarga
  operacion.pq_dth_rotacion.p_gen_tb_prom_cp(id_proc);
exception when others then
  rollback;
  raise_application_error(-20016, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de generar los datos de Promociones por Venta/Alta
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_data_prom_va(id_proc in number)
is
type array_object is table of operacion.rotacion_datos%rowtype index by binary_integer;
var_arreglo array_object;
cursor c_prom_va is
select id_proc,
       b.codcli,
       i.codinssrv,
       i.fecini,
       case
         when b.diasvigenciagrupo is not null then
          i.fecini + b.diasvigenciagrupo
         when b.diasvigenciagrupo is null then
          b.fecfinvig_bouquets
       end fecfin_prom,
       to_char(b.flg_activo),
       trim(sp.numserie),
       to_char(prom.idgrupo),
       '6' tipo_servicio -- Promocion por Venta/Alta
  from billcolper.fac_prom_detalle_venta_mae b
  join billcolper.promocion p
    on b.idprom = p.idprom
   and b.flg_activo = 1 -- Promocion Activa
  join fac_promocion_en_linea_mae prom
    on p.idprom_en_linea = prom.idpromocion
   and prom.idgrupo is not null
  join operacion.ope_srv_recarga_cab oc
    on b.numslc = oc.numslc
  join operacion.inssrv i
    on b.numslc = i.numslc
  join operacion.solotptoequ sp
    on oc.codsolot = sp.codsolot
   and sp.numserie is not null
  join (select o.codigon
          from operacion.opedd o
          join operacion.tipopedd t
            on o.tipopedd = t.tipopedd
           and t.abrev = 'PARAM_ROTA_TARJ') prt
    on prt.codigon = sp.tipequ
   and trunc(b.fecreg, 'DD') >= trunc(add_months(sysdate, -12), 'DD')
   and trunc((case
               when b.diasvigenciagrupo is not null then
                i.fecini + b.diasvigenciagrupo
               when b.diasvigenciagrupo is null then
                b.fecfinvig_bouquets
             end),
             'DD') >= trunc(sysdate + 1, 'DD');
begin
   open c_prom_va;
   loop
   fetch c_prom_va bulk collect into var_arreglo limit 1000;
      exit when var_arreglo.count=0;
      forall i in 1 .. var_arreglo.count
         insert into operacion.rotacion_datos values var_arreglo(i);
      commit;
 end loop;
 close c_prom_va;
exception when others then
  rollback;
  raise_application_error(-20017, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de insertar los datos de tarjetas y bouquets a la
                      tabla de rotacion para las Promociones por Venta/Alta
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_tb_prom_va(id_proc in number)
is
type array_object is table of operacion.rotacion_tarj_bqt%rowtype index by binary_integer;
var_arreglo array_object;
cursor c_prom_va_t is
select rd.tarjeta,
       od.codbouquet
  from operacion.rotacion_datos rd
  join operacion.ope_grupo_bouquet_det od
    on to_number(rd.codsrv)=od.idgrupo
   and rd.id_proceso=id_proc
   and rd.tipo_servicio='6';
begin
   open c_prom_va_t;
   loop
   fetch c_prom_va_t bulk collect into var_arreglo limit 1000;
      exit when var_arreglo.count=0;
      forall i in 1 .. var_arreglo.count
         insert into operacion.rotacion_tarj_bqt values var_arreglo(i);
      commit;
 end loop;
 close c_prom_va_t;
exception when others then
  rollback;
  raise_application_error(-20018, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de generar los datos de Promociones por Carga de Informacion
                      y Por Pago/Recarga
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_data_prom_cp(id_proc in number)
is
type array_object is table of operacion.rotacion_datos%rowtype index by binary_integer;
var_arreglo array_object;
cursor c_prom_cp is
select id_proc,
       a.codcli,
       i.codinssrv,
       case
         when a.desde is not null and prom.idgrupo is not null then
          a.desde
         when a.desde is null and prom.idgrupo is not null then
          trunc(a.fecreg)
         when a.desde is not null then
          a.desde
       end fecini_prom,
       case
         when a.desde is not null and prom.idgrupo is not null then
          a.desde + prom.dias_vigencia_bouquet
         when a.desde is not null and prom.idgrupo is null then
          a.desde
         when a.desde is null and prom.idgrupo is not null then
          trunc(a.fecreg) + prom.dias_vigencia_bouquet
         when a.desde is null and prom.idgrupo is null then
          trunc(a.fecreg)
         when a.desde is not null then
          a.desde + prom.dias_vigencia_bouquet
       end fecfin_prom,
       to_char(a.estado),
       trim(sp.numserie),
       to_char(prom.idgrupo),
       case
         when a.idcupon is null then
          '7' --'Por Carga de Informacion'
         when a.idcupon is not null then
          '8' --'Por Pago/Recarga'
       end tipo_servicio
  from v_fac_aplicacion_promocion_rep a
  join fac_promocion_en_linea_mae prom
    on prom.idpromocion = a.idpromocion
   and a.estado = 1 -- Promocion Activa
   and prom.idgrupo is not null
   and trunc(a.fecreg) >= trunc(add_months(sysdate, -12), 'DD')
  join operacion.ope_srv_recarga_cab oc
    on a.numregistro = oc.numregistro
  join operacion.inssrv i
    on oc.numslc=i.numslc
  join operacion.solotptoequ sp
    on oc.codsolot = sp.codsolot
   and sp.numserie is not null
  join (select o.codigon
          from operacion.opedd o
          join operacion.tipopedd t
            on o.tipopedd = t.tipopedd
           and t.abrev = 'PARAM_ROTA_TARJ') prt
    on prt.codigon=sp.tipequ
   and trunc(case
         when a.desde is not null and prom.idgrupo is not null then
          a.desde + prom.dias_vigencia_bouquet
         when a.desde is not null and prom.idgrupo is null then
          a.desde
         when a.desde is null and prom.idgrupo is not null then
          trunc(a.fecreg) + prom.dias_vigencia_bouquet
         when a.desde is null and prom.idgrupo is null then
          trunc(a.fecreg)
         when a.desde is not null then
          a.desde + prom.dias_vigencia_bouquet
       end,'DD')>=trunc(sysdate+1,'DD');
begin
   open c_prom_cp;
   loop
   fetch c_prom_cp bulk collect into var_arreglo limit 1000;
      exit when var_arreglo.count=0;
      forall i in 1 .. var_arreglo.count
         insert into operacion.rotacion_datos values var_arreglo(i);
      commit;
 end loop;
 close c_prom_cp;
exception when others then
  rollback;
  raise_application_error(-20019, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de insertar los datos de tarjetas y bouquets a la
                      tabla de rotacion para las Promociones por Venta/Alta
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_tb_prom_cp(id_proc in number)
is
type array_object is table of operacion.rotacion_tarj_bqt%rowtype index by binary_integer;
var_arreglo array_object;
cursor c_prom_cp_t is
select rd.tarjeta,
       od.codbouquet
  from operacion.rotacion_datos rd
  join operacion.ope_grupo_bouquet_det od
    on to_number(rd.codsrv)=od.idgrupo
   and rd.id_proceso=id_proc
   and rd.tipo_servicio in ('7','8');
begin
   open c_prom_cp_t;
   loop
   fetch c_prom_cp_t bulk collect into var_arreglo limit 1000;
      exit when var_arreglo.count=0;
      forall i in 1 .. var_arreglo.count
         insert into operacion.rotacion_tarj_bqt values var_arreglo(i);
      commit;
 end loop;
 close c_prom_cp_t;
exception when others then
  rollback;
  raise_application_error(-20020, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de generacion de los datos de rotacion
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_data_rotacion
is
id_proc number;
begin
  -- Creando Cabecera de la rotacion
  operacion.pq_dth_rotacion.p_reg_cab_rotacion(id_proc);
  -------------------------------------------------------
  -- Creando datos de Rotacion
  -------------------------------------------------------
  -- Creando datos de los PostPagos
  operacion.pq_dth_rotacion.p_gen_data_postpago(id_proc);
  -- Creacion datos de Prepago con Recarga
  operacion.pq_dth_rotacion.p_gen_data_prepago_r(id_proc);
  -- Creacion de datos de Tarjetas y Bouquets Prepago con Recarga
  operacion.pq_dth_rotacion.p_gen_tb_prepago_r(id_proc);
  -- Creacion datos de Prepago con Recibo sin Emitir
  operacion.pq_dth_rotacion.p_gen_data_prepago_rse(id_proc);
  -- Creacion de datos de Tarjetas y Bouquets Prepago con Recibo sin Emitir
  operacion.pq_dth_rotacion.p_gen_tb_prepago_rse(id_proc);
  -- Creacion datos de Prepago con Recibo Emitido
  operacion.pq_dth_rotacion.p_gen_data_prepago_re(id_proc);
  -- Validacion de pago de los recibos
  operacion.pq_dth_rotacion.p_val_data_prepago_re(id_proc);
  -- Creacion de datos de Tarjetas y Bouquets Prepago con Recibo Emitido
  operacion.pq_dth_rotacion.p_gen_tb_prepago_re(id_proc);
  -- Creacion datos de Demos
  operacion.pq_dth_rotacion.p_gen_data_demos(id_proc);
  -- Creacion datos de Tarjetas y Bouquets Demos
  operacion.pq_dth_rotacion.p_gen_tb_demos(id_proc);
  -- Creacion datos de Promociones
  operacion.pq_dth_rotacion.p_gen_data_promociones(id_proc);
exception when others then
  raise_application_error(-20001, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de eliminacion de los datos de la tabla temporal de
                      rotacion
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_trunc_tt_rotacion
is
begin
  -- Tabla final de datos de rotacion
  execute immediate 'TRUNCATE TABLE operacion.rotacion_tarj_bqt';
exception when others then raise_application_error(-20021, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de eliminacion de los datos de la tabla temporal de
                      rotacion
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_rotacion
is
begin
  -- Generación de Archivos a .Emm
  operacion.pq_dth_rotacion.p_gen_arch_rotacion;
  -- Limpieza tabla final de datos de rotacion
  operacion.pq_dth_rotacion.p_trunc_tt_rotacion;
exception when others then
  raise_application_error(-20080, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de migracion de datos de la activacion/corte manual
                      de DTH
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_migra_act_dsc_manu
is
cursor c_proc_madm is
select c.id_proc_manu,c.tip_ac
  from operacion.cab_atc_cort_manu_dth c
 where c.estado in (2,3);
begin
  for c1 in c_proc_madm loop
    -- Migrando el detalle del archivo
    operacion.pq_dth_rotacion.p_det_atc_cort_archivo(c1.id_proc_manu);
    -- Migrando la cabecera del archivo
    operacion.pq_dth_rotacion.p_cab_atc_cort_archivo(c1.id_proc_manu);
    if c1.tip_ac='B' then
    -- Migrando el detalle del proceso Bouquet
    operacion.pq_dth_rotacion.p_det_atc_cort_manu_dth_b(c1.id_proc_manu); 
    end if;
    -- Migrando el detalle del proceso
    operacion.pq_dth_rotacion.p_det_atc_cort_manu_dth(c1.id_proc_manu);
    -- Migrando la cabecera del proceso act/corte manual
    operacion.pq_dth_rotacion.p_migra_cab_atc_cort_manu_dth(c1.id_proc_manu);
  end loop;

exception when others then
  raise_application_error(-20080, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de migracion de datos de la activacion/corte manual
                      de DTH
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_det_atc_cort_manu_dth_b(id_proc in number)
is
type array_object is table of operacion.det_atc_cort_manu_dth_b%rowtype index by binary_integer;
var_arreglo array_object;
cursor c_dac is
select t.id_proc_manu,
       t.bouquet
  from operacion.det_atc_cort_manu_dth_b t
 where t.id_proc_manu=id_proc;
type matriz_rowid is table of rowid;
m_rowid matriz_rowid;
cursor c_dace is
select rowid
  from operacion.det_atc_cort_manu_dth_b t
 where t.id_proc_manu=id_proc;
begin
 open c_dac;
 loop
   fetch c_dac bulk collect into var_arreglo limit 1000;
      exit when var_arreglo.count=0;
      forall i in 1 .. var_arreglo.count
        insert into migracion.det_atc_cort_manu_dth_b values var_arreglo(i);
      commit;
 end loop;
 close c_dac;
 open c_dace;
 loop
   fetch c_dace bulk collect into  m_rowid limit 1000;
      exit when m_rowid.count=0;
      forall i in 1 .. m_rowid.count
        delete from operacion.det_atc_cort_manu_dth_b
              where rowid=m_rowid(i);
    commit;
  end loop;
  close c_dace;
exception when others then
  rollback;
  raise_application_error(-20080, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de migracion de datos de la activacion/corte manual
                      de DTH
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_det_atc_cort_manu_dth(id_proc in number)
is
type array_object is table of operacion.det_atc_cort_manu_dth%rowtype index by binary_integer;
var_arreglo array_object;
cursor c_dac is
select t.id_proc_manu,
       t.codigo_tarjeta,
       t.flg_verif
  from operacion.det_atc_cort_manu_dth t
 where t.id_proc_manu=id_proc;
type matriz_rowid is table of rowid;
m_rowid matriz_rowid;
cursor c_dace is
select rowid
  from operacion.det_atc_cort_manu_dth t
 where t.id_proc_manu=id_proc;
begin
 open c_dac;
 loop
   fetch c_dac bulk collect into var_arreglo limit 1000;
      exit when var_arreglo.count=0;
      forall i in 1 .. var_arreglo.count
        insert into migracion.det_atc_cort_manu_dth values var_arreglo(i);
      commit;
 end loop;
 close c_dac;
 open c_dace;
 loop
   fetch c_dace bulk collect into  m_rowid limit 1000;
      exit when m_rowid.count=0;
      forall i in 1 .. m_rowid.count
        delete from operacion.det_atc_cort_manu_dth
              where rowid=m_rowid(i);
    commit;
  end loop;
  close c_dace;
exception when others then
  rollback;
  raise_application_error(-20080, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de migracion de datos de la activacion/corte manual
                      de DTH
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_cab_atc_cort_archivo(id_proc in number)
is
type array_object is table of operacion.cab_atc_cort_archivo%rowtype index by binary_integer;
var_arreglo array_object;
cursor c_cac is
select t.id_archivo,
       t.nom_archivo,
       t.estado_arch,
       t.cant_tarjetas,
       t.id_proceso,
       t.nro_intento
  from operacion.cab_atc_cort_archivo t
 where t.id_proceso=id_proc;
cursor c_cace is
select rowid
  from operacion.cab_atc_cort_archivo d
 where d.id_proceso=id_proc;
type matriz_rowid is table of rowid;
m_rowid matriz_rowid;
begin
    open c_cac;
    loop
      fetch c_cac bulk collect into var_arreglo limit 500;
         exit when var_arreglo.count=0;
         forall i in 1 .. var_arreglo.count
           insert into migracion.cab_atc_cort_archivo values var_arreglo(i);
         commit;
    end loop;
    close c_cac;
    
    open c_cace;
    loop
      fetch c_cace bulk collect into  m_rowid limit 500;
      exit when m_rowid.count=0;
         forall i in 1 .. m_rowid.count
           delete from operacion.cab_atc_cort_archivo
                 where rowid=m_rowid(i);
      commit;
    end loop;
    close c_cace;
exception when others then
  rollback;
  raise_application_error(-20080, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de migracion de datos de la activacion/corte manual
                      de DTH
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_det_atc_cort_archivo(id_proc in number)
is
cursor c_daca(id_arch number) is
select d.id_archivo,d.codigo_tarjeta
  from operacion.det_atc_cort_archivo d
 where d.id_archivo=id_arch;
cursor c_cac is
select c.id_proceso,c.id_archivo
  from operacion.cab_atc_cort_archivo c
 where c.id_proceso=id_proc;
cursor c_dace(id_arch number) is
select rowid
  from operacion.det_atc_cort_archivo d
 where d.id_archivo=id_arch;
type array_object is table of operacion.det_atc_cort_archivo%rowtype index by binary_integer;
var_arreglo array_object;
type matriz_rowid is table of rowid;
m_rowid matriz_rowid;
begin
  for c1 in c_cac loop
    open c_daca(c1.id_archivo);
    loop
      fetch c_daca bulk collect into var_arreglo limit 1000;
         exit when var_arreglo.count=0;
         forall i in 1 .. var_arreglo.count
           insert into migracion.det_atc_cort_archivo values var_arreglo(i);
         commit;
    end loop;
    close c_daca;
    open c_dace(c1.id_archivo);
    loop
      fetch c_dace bulk collect into  m_rowid limit 1000;
      exit when m_rowid.count=0;
         forall i in 1 .. m_rowid.count
           delete from operacion.det_atc_cort_archivo
                 where rowid=m_rowid(i);
      commit;
    end loop;
    close c_dace;
  end loop;
exception when others then
  rollback;
  raise_application_error(-20080, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de migracion de la cabecera de los datos de act/corte
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_migra_cab_atc_cort_manu_dth (id_proc in number)
is
type array_object is table of operacion.cab_atc_cort_manu_dth%rowtype index by binary_integer;
var_arreglo array_object;
cursor c_cac is
  select crd.id_proc_manu,
         crd.estado,
         crd.descripcion,
         crd.tipo_proc,
         crd.id_paquete,
         crd.fecha_ejec,
         crd.motivo,
         crd.tipo_cliente,
         crd.direccion_ip,
         crd.cod_usua,
         crd.fecha_reg,
         crd.tip_ac,
         crd.flg_p
    from operacion.cab_atc_cort_manu_dth crd
   where crd.id_proc_manu=id_proc; 
begin
 open c_cac;
 loop
   fetch c_cac bulk collect into var_arreglo limit 1000;
      exit when var_arreglo.count=0;
      for i in var_arreglo.first .. var_arreglo.last loop
        insert into migracion.cab_atc_cort_manu_dth values var_arreglo(i);
        delete from operacion.cab_atc_cort_manu_dth where id_proc_manu=var_arreglo(i).id_proc_manu;
      end loop;
      commit;
 end loop;
 close c_cac;
exception when others then
  rollback;
  raise_application_error(-20026, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de migracion de rotacion de DTH
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_migra_rotacion
is
cursor c_proc_madm is
select c.id_proceso
  from operacion.cab_rotacion_dth c
 where c.estado in (2,3);
begin
  for c1 in c_proc_madm loop
    -- Migrando detalle de archivo
    operacion.pq_dth_rotacion.p_migra_rotac_auto_archivo_det(c1.id_proceso);
    -- Migrando Cabecera de Archivo
    operacion.pq_dth_rotacion.p_migra_rotac_auto_archivo(c1.id_proceso);
    -- Migrando data de tabla de rotacion_datos
    operacion.pq_dth_rotacion.p_migra_rotacion_datos(c1.id_proceso);
    -- Migrando Cabecera de Rotacion
    operacion.pq_dth_rotacion.p_migra_cab_rotacion_dth(c1.id_proceso);
  end loop;
  -- Dejar los tres ultimos procesos
  operacion.pq_dth_rotacion.p_elim_proc_mtres;
exception when others then
  raise_application_error(-20022, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de migracion de la cabecera de los datos de rotacion
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_migra_cab_rotacion_dth (id_proc in number)
is
type array_object is table of operacion.cab_rotacion_dth%rowtype index by binary_integer;
var_arreglo array_object;
cursor c_cac is
  select crd.id_proceso,
         crd.cod_usua,
         crd.direccion_ip,
         crd.fecha_envio,
         crd.mes,
         crd.anho,
         crd.cant_tot_tarj,
         crd.estado,
         crd.fecha_reg,
         crd.flg_p
    from operacion.cab_rotacion_dth crd
   where crd.id_proceso=id_proc; 
begin
 open c_cac;
 loop
   fetch c_cac bulk collect into var_arreglo limit 1000;
      exit when var_arreglo.count=0;
      for i in var_arreglo.first .. var_arreglo.last loop
        insert into migracion.cab_rotacion_dth values var_arreglo(i);
        delete from operacion.cab_rotacion_dth where id_proceso=var_arreglo(i).id_proceso;
      end loop;
      commit;
 end loop;
 close c_cac;
exception when others then
  rollback;
  raise_application_error(-20026, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de migracion de los datos de los archivos de rotacion
                      de DTH
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_migra_rotacion_datos (id_proc in number)
is
cursor c_dac is
select t.id_proceso,
       t.codcli,
       t.codinssrv,
       t.fecini,
       t.fecfinvig,
       t.estado,
       t.tarjeta,
       t.codsrv,
       t.tipo_servicio
  from operacion.rotacion_datos t
 where t.id_proceso=id_proc;
type array_object is table of operacion.rotacion_datos%rowtype index by binary_integer;
var_arreglo array_object;
type matriz_rowid is table of rowid;
m_rowid matriz_rowid;
cursor c_dace is
select rowid
  from operacion.rotacion_datos t
 where t.id_proceso=id_proc;
begin
 open c_dac;
 loop
   fetch c_dac bulk collect into var_arreglo limit 1000;
      exit when var_arreglo.count=0;
      forall i in 1 .. var_arreglo.count
        insert into migracion.rotacion_datos values var_arreglo(i);
      commit;
 end loop;
 close c_dac;
 
 open c_dace;
 loop
   fetch c_dace bulk collect into  m_rowid limit 1000;
      exit when m_rowid.count=0;
      forall i in 1 .. m_rowid.count
        delete from operacion.rotacion_datos
              where rowid=m_rowid(i);
    commit;
  end loop;
  close c_dace;
exception when others then
  rollback;
  raise_application_error(-20025, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de migracion de los datos de los archivos de rotacion
                      de DTH
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_migra_rotac_auto_archivo (id_proc in number)
is
type array_object is table of operacion.rotacion_auto_archivo%rowtype index by binary_integer;
var_arreglo array_object;
cursor c_cac is
select t.id_archivo,
       t.nom_archivo,
       t.estado_arch,
       t.cant_tarjetas,
       t.id_proceso,
       t.bouquet,
       t.nro_intento
  from operacion.rotacion_auto_archivo t
 where t.id_proceso=id_proc;
cursor c_cace is
select rowid
  from operacion.rotacion_auto_archivo d
 where d.id_proceso=id_proc;
type matriz_rowid is table of rowid;
m_rowid matriz_rowid;
begin

    open c_cac;
    loop
      fetch c_cac bulk collect into var_arreglo limit 500;
         exit when var_arreglo.count=0;
         forall i in 1 .. var_arreglo.count
           insert into migracion.rotacion_auto_archivo values var_arreglo(i);
         commit;
    end loop;
    close c_cac;
    
    open c_cace;
    loop
      fetch c_cace bulk collect into  m_rowid limit 500;
      exit when m_rowid.count=0;
         forall i in 1 .. m_rowid.count
           delete from operacion.rotacion_auto_archivo
                 where rowid=m_rowid(i);
      commit;
    end loop;
    close c_cace;
exception when others then
  rollback;
  raise_application_error(-20024, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de migracion de las tarjetas de los archivos de rotacion
                      de DTH
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_migra_rotac_auto_archivo_det (id_proc in number)
is
cursor c_daca(id_arch number) is
select d.id_archivo,d.codigo_tarjeta
  from operacion.rotacion_auto_archivo_det d
 where d.id_archivo=id_arch;
cursor c_cac is
select c.id_proceso,c.id_archivo
  from operacion.rotacion_auto_archivo c
 where c.id_proceso=id_proc;
cursor c_dace(id_arch number) is
select rowid
  from operacion.rotacion_auto_archivo_det d
 where d.id_archivo=id_arch;
type array_object is table of operacion.rotacion_auto_archivo_det%rowtype index by binary_integer;
var_arreglo array_object;
type matriz_rowid is table of rowid;
m_rowid matriz_rowid;
begin
  for c1 in c_cac loop
    open c_daca(c1.id_archivo);
    loop
      fetch c_daca bulk collect into var_arreglo limit 1000;
         exit when var_arreglo.count=0;
         forall i in 1 .. var_arreglo.count
           insert into migracion.rotacion_auto_archivo_det values var_arreglo(i);
         commit;
    end loop;
    close c_daca;
    open c_dace(c1.id_archivo);
    loop
      fetch c_dace bulk collect into  m_rowid limit 1000;
      exit when m_rowid.count=0;
         forall i in 1 .. m_rowid.count
           delete from operacion.rotacion_auto_archivo_det
                 where rowid=m_rowid(i);
      commit;
    end loop;
    close c_dace;
  end loop;
exception when others then
  rollback;
  raise_application_error(-20023, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Proceso de dejar los tres ultimos procesos de rotacion en la tabla de migracion
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_elim_proc_mtres is
cursor c_elim_proc is
  select x.id_proceso
    from (select cr.id_proceso
            from migracion.cab_rotacion_dth cr
           where cr.estado in ('2', '3')
           order by cr.id_proceso desc) x
  minus
  select y.id_proceso
    from (select crd.id_proceso
            from migracion.cab_rotacion_dth crd
           where rownum < 4
             and crd.estado in ('2', '3')
           order by id_proceso desc) y;
begin
  for c1 in c_elim_proc loop
    -- Eliminando rotac_auto_archivo y detalle
    operacion.pq_dth_rotacion.p_elim_rotac_auto_archivo(c1.id_proceso);
    -- Eliminando rotacion_datos
    operacion.pq_dth_rotacion.p_elim_rotac_datos(c1.id_proceso);
    -- Eliminando cab_rotacion_dth
    operacion.pq_dth_rotacion.p_elim_cab_rotac_dth(c1.id_proceso);
  end loop;
exception when others then
  raise_application_error(-20080, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de la eliminacion del registro de la tabla migracion.cab_rotacion.dth
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_elim_cab_rotac_dth(id_proc in number)
is
begin
  delete from migracion.cab_rotacion_dth where id_proceso=id_proc;
  commit;
exception when others then
  rollback;
  raise_application_error(-20080, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de la eliminacion del registro de la tabla migracion.rotacion_datos
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_elim_rotac_datos(id_proc in number)
is
type t_array_rowid is table of rowid;
array_rowid t_array_rowid;
cursor c_rotac_datos is
select rowid
  from migracion.rotacion_datos rad
 where rad.id_proceso=id_proc;
begin
  open c_rotac_datos;
  loop
    fetch c_rotac_datos bulk collect into array_rowid limit 1000;
    exit when c_rotac_datos%notfound;
    forall i in 1 .. array_rowid.count
      delete from migracion.rotacion_datos
            where rowid=array_rowid(i) and id_proceso=id_proc;
      commit;
  end loop;
  close c_rotac_datos;
exception when others then
  rollback;
  raise_application_error(-20080, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de la eliminacion del registro de la tabla migracion.rotacion_auto_archivo
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_elim_rotac_auto_archivo(id_proc in number)
is
cursor c_rotac_auto_archivo is
select raa.id_archivo,raa.id_proceso
  from migracion.rotacion_auto_archivo raa
 where raa.id_proceso=id_proc;
begin
  for c1 in c_rotac_auto_archivo loop
    operacion.pq_dth_rotacion.p_elim_rotac_auto_arch_det(c1.id_archivo);
    operacion.pq_dth_rotacion.p_elim_rotac_auto_arch(c1.id_archivo);
  end loop;
exception when others then
  raise_application_error(-20080, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de la eliminacion del registro de la tabla migracion.rotacion_auto_archivo_det
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_elim_rotac_auto_arch_det(id_arch in number)
is
type t_array_number is table of number;
type t_array_rowid is table of rowid;
array_id_archivo t_array_number;
array_rowid t_array_rowid;
cursor c_rotc_auto_arch_det(id_ar in number) is
select rowid,rad.id_archivo
  from migracion.rotacion_auto_archivo_det rad
 where rad.id_archivo=id_ar;
begin
  open c_rotc_auto_arch_det(id_arch);
  loop
    fetch c_rotc_auto_arch_det bulk collect into array_rowid,array_id_archivo limit 1000;
    exit when c_rotc_auto_arch_det%notfound;
    forall i in 1 .. array_rowid.count
      delete from migracion.rotacion_auto_archivo_det
            where rowid=array_rowid(i) and id_archivo=id_arch;
      commit;
  end loop;
  close c_rotc_auto_arch_det;
exception when others then
  rollback;
  raise_application_error(-20080, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de la eliminacion del registro de la tabla migracion.rotacion_auto_archivo
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_elim_rotac_auto_arch(id_arch in number)
is
begin
   delete from migracion.rotacion_auto_archivo where id_archivo=id_arch;
   commit;
exception when others then
  rollback;
  raise_application_error(-20080, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de la verificación del area del usuario
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori       Henry Quispe      PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_verif_area_usua(cod_usua in varchar2,
                            val      out varchar2)
is
v_area number;
val_area number;
begin
    val:='0';

    select uo.area into v_area
      from opewf.usuarioope uo
     where uo.usuario=cod_usua;

    select count(1) into val_area
      from operacion.tipopedd t
      join operacion.opedd o
        on t.tipopedd=o.tipopedd
       and t.abrev='PARAM_ROTA_M'
       and o.abreviacion='AREA_PQT'
       and o.codigon=v_area;
    if val_area>0 then
      val:='1';
    end if;
exception when others then raise_application_error(-20080, sqlerrm);
end;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de la verificación del usuario para el Proceso de Act/Desac por Bouquet
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_verif_usua(cod_usua in varchar2,val out varchar2)
is
val_usua number;
begin
    val:='0';
    select count(1) into val_usua
      from operacion.tipopedd t
      join operacion.opedd o
        on t.tipopedd=o.tipopedd
       and t.abrev='PARAM_ROTA_M'
       and o.abreviacion='USUA_BQT'
       and o.codigoc=cod_usua;
    if val_usua>0 then
      val:='1';
    end if;
exception when others then raise_application_error(-20080, sqlerrm);
end;

end;
/