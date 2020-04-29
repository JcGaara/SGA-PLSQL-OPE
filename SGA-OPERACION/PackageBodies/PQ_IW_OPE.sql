CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_IW_OPE AS
  /******************************************************************************
  Version     Fecha       Autor            Descripción.
  ---------  ----------  ---------------   ------------------------------------
  1.0        02/08/2011  Edilberto Astulle Creación
  2.0        15/11/2011  Edilberto Astulle PROY-0670 Optimizacion de procedimiento de registro equipos Intraway SGA
  3.0        15/03/2012  Edilberto Astulle PROY-1850 Correccion del proceso de Suspension Bajas Administrativas
  4.0        15/08/2012  Edilberto Astulle PROY-3968_Optimizacion de Interface Intraway - SGA para la carga de equipos
  5.0        15/11/2012  Edilberto Astulle SD-368112
  6.0        21/12/2012  Edilberto Astulle SD-381939
  7.0        01/01/2013  Edilberto Astulle SD-306536
  8.0        01/02/2013  Edilberto Astulle SD_460264
  9.0        11/02/2013  Edilberto Astulle PROY-6892_Restriccion de Acceso a Servicios 3Play Edificios
  10.0       21/02/2013  Edilberto Astulle PROY-6885_Modificaciones en SGA Operaciones y Sistema Tecnico
 11.0       07/03/2013  Arturo Saavedra   PROY-7284 IDEA-6535 Requerimiento liberación de recursos Intraway TPI
  12.0       27/03/2013  Edilberto Astulle PROY-6254_Recojo de decodificador
  13.0       27/04/2013  Edilberto Astulle PQT-151338-TSK-26649
  14.0       17/06/2013  Edilberto Astulle SD_651069-Registro de Equipos desde IW en SOTs de baja
  15.0       21/08/2013  Edilberto Astulle PQT-166197-TSK-34400
  16.0       21/10/2013  Edilberto Astulle PQT-159305-TSK-30818
  17.0       21/10/2013  Edilberto Astulle SD-969276
  18.0       21/10/2013  Edilberto Astulle SD-973402
  19.0       27/03/2014  Edilberto Astulle SD_978729
  20.0       27/04/2014  Edilberto Astulle Venta Unificada
  21.0       27/04/2014  Edilberto Astulle Venta Unificada2
  22.0       25/09/2014  Miriam Mandujano  SD_55424 OBSERVACION - SERIES EXCEDENTES
  23.0       10/10/2014  Miriam Mandujano  PROY-15142 - IDEA-16213 Mejora en la generación de baja
  24.0       20/12/2014  Jorge Armas       SD_47727 No se realizó carga de equipos en SOTS de Baja de Clientes HFC
  25.0       29/05/2015  Edilberto Astulle SD-307352 Problema con el SGA
  26.0       20/07/2016  Dorian Sucasaca   SD_795618
******************************************************************************/
  PROCEDURE p_iw_baja_total(a_idtareawf in number,
                            a_idwf      in number,
                            a_tarea     in number,
                            a_tareadef  in number)

   IS
    v_codcli          vtatabcli.codcli%type;
    n_codsolot        solot.codsolot%type;
    v_validaregistro  number;
    p_error           NUMBER;
    p_proceso         number;
    p_resultado       VARCHAR2(500);
    p_mensaje         VARCHAR2(3000);
    v_int_ser_itw     int_servicio_intraway%rowtype;
    p_channelmap      VARCHAR2(200);
   p_sendtocontroler VARCHAR2(200);
    p_comando         VARCHAR2(150);

    CURSOR cur_srv IS
      SELECT isw.*
        FROM int_servicio_intraway isw
       WHERE (isw.codinssrv) IN
             (SELECT DISTINCT DECODE(t.tiptra,
                                     412,
                                     sp.codinssrv_tra,
                                     Sp.codinssrv)
                FROM solotpto sp, SOLOT T
               WHERE sp.codsolot = t.codsolot
                 AND sp.codsolot = n_codsolot)
         AND isw.estado = 1
         AND isw.id_interfase not in (830, 2030)
      UNION
      SELECT isw2.*
        FROM int_servicio_intraway isw2
       WHERE isw2.id_producto IN
             (SELECT id_producto_padre
                FROM int_servicio_intraway
               WHERE id_interfase = '824'
                 AND CODINSSRV IN
                     (SELECT DISTINCT DECODE(t.tiptra,
                                             412,
                                             sp.codinssrv_tra,
                                             Sp.codinssrv)
                        FROM solotpto sp, SOLOT T
                       WHERE sp.codsolot = t.codsolot
                         AND sp.codsolot = n_codsolot))
         AND isw2.estado = 1
       ORDER BY 2 DESC;
  BEGIN
    select wf.codsolot, codcli
      into n_codsolot, v_codcli
      from wf, solot
     where wf.codsolot = solot.codsolot
       and idwf = a_idwf;
    --Verificar si ya existe en las tablas intermedias
    select count(1)
      into v_validaregistro
      from intraway.int_solot_itw
     where codsolot = n_codsolot;
    IF v_validaregistro = 0 THEN
      insert into intraway.int_solot_itw
        (codsolot, codcli, estado, flagproc)
      values
        (n_codsolot, v_codcli, 2, 0);
      p_proceso := 4;
      p_error   := 0;
      FOR c_srv IN cur_srv LOOP
        IF c_srv.ID_INTERFASE = '830' THEN
          pq_intraway.P_MTA_FAC_ADMINISTRACION(0,
                                               c_srv.ID_CLIENTE,
                                               c_srv.id_producto,
                                               c_srv.pid_sga,
                                               c_srv.id_producto_padre,
                                               c_srv.codigo_ext,
                                               p_proceso,
                                               n_codsolot,
                                               c_srv.CODINSSRV,
                                              p_resultado,
                                               p_mensaje,
                                               p_error,
                                               0,
                                               'TRUE',
                                               c_srv.id_venta,
                                               c_srv.id_venta_padre);
        ELSIF c_srv.ID_INTERFASE = '824' THEN
          pq_intraway.p_mta_ep_administracion(0,
                                              c_srv.ID_CLIENTE,
                                              c_srv.id_producto,
                                              c_srv.pid_sga,
                                              c_srv.id_producto_padre,
                                             c_srv.nroendpoint,
                                              c_srv.numero,
                                              c_srv.codigo_ext,
                                              p_proceso,
                                              n_codsolot,
                                              c_srv.codinssrv,
                                              p_resultado,
                                              p_mensaje,
                                              p_error,
                                              0,
                                              c_srv.id_venta,
                                              c_srv.id_venta_padre,
                                              'TRUE');
        ELSIF c_srv.ID_INTERFASE = '620' THEN
          BEGIN
            select *
              into v_int_ser_itw
              from int_servicio_intraway
             where id_producto_padre = c_srv.id_producto
               AND id_cliente = c_srv.id_cliente
               AND id_interfase = '820';
            pq_intraway.P_MTA_CREA_ESPACIO(0,
                                           v_int_ser_itw.Id_Cliente,
                                           v_int_ser_itw.ID_PRODUCTO,
                                           v_int_ser_itw.PID_SGA,
                                           v_int_ser_itw.ID_PRODUCTO_PADRE,
                                           v_int_ser_itw.ID_ACTIVACION,
                                           p_proceso,
                                           n_codsolot,
                                           v_int_ser_itw.CODIGO_EXT,
                                           p_resultado,
                                           p_mensaje,
                                           p_error,
                                           0,
                                           v_int_ser_itw.id_venta,
                                           v_int_ser_itw.id_venta_padre); --4.0>
            PQ_INTRAWAY.P_CM_CREA_ESPACIO(0,
                                          c_srv.Id_Cliente,
                                          c_srv.ID_PRODUCTO,
                                          c_srv.Pid_Sga,
                                          c_srv.ID_ACTIVACION,
                                          c_srv.CODIGO_EXT,
                                          2,
                                          p_proceso,
                                          n_codsolot,
                                          c_srv.CODINSSRV,
                                          p_resultado,
                                          p_mensaje,
                                          p_error,
                                          null,
                                          null,
                                          0,
                                          v_int_ser_itw.id_venta,
                                          v_int_ser_itw.id_venta_padre);
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              PQ_INTRAWAY.P_CM_CREA_ESPACIO(0,
                                            c_srv.Id_Cliente,
                                            c_srv.ID_PRODUCTO,
                                            c_srv.Pid_Sga,
                                            c_srv.ID_ACTIVACION,
                                            c_srv.CODIGO_EXT,
                                            2,
                                            p_proceso,
                                            n_codsolot,
                                            c_srv.CODINSSRV,
                                            p_resultado,
                                            p_mensaje,
                                            p_error,
                                            null,
                                            null,
                                            0,
                                            v_int_ser_itw.id_venta,
                                            v_int_ser_itw.id_venta_padre);
            WHEN OTHERS THEN
              NULL;
          END;
        elsif c_srv.id_interfase = '2050' then
             pq_intraway.p_stb_vod_administracion( 0, c_srv.codigo_ext, c_srv.id_cliente, c_srv.id_producto, c_srv.pid_sga, c_srv.id_producto_padre,                  p_proceso, n_codsolot, c_srv.codinssrv,0,0,0,p_resultado,p_mensaje,p_error);
        elsif c_srv.ID_INTERFASE = '2030' then
          PQ_INTRAWAY.P_STB_SA_ADMINISTRACION(0,
                                              c_srv.Id_Cliente,
                                              c_srv.Id_Producto,
                                              c_srv.PID_SGA,
                                              c_srv.ID_PRODUCTO_PADRE,
                                              c_srv.Codigo_Ext,
                                              p_proceso,
                                              n_codsolot,
                                              c_srv.CODINSSRV,
                                              p_resultado,
                                              p_mensaje,
                                              p_error,
                                              0,
                                              'TRUE',
                                              c_srv.id_venta,
                                              c_srv.id_venta_padre);
        ELSIF c_srv.ID_INTERFASE = '2020' THEN
          p_channelmap      := 'BASICO';
          p_sendtocontroler := 'TRUE';
          p_comando         := 'collectppv';
          IF (c_srv.Macaddress IS NOT NULL) AND
             (c_srv.serialnumber IS NOT NULL) then
            INTRAWAY.PQ_INTRAWAY.P_STB_MANTENIMIENTO(c_srv.id_cliente,
                                                     c_srv.id_producto,
                                                     0,
                                                     p_proceso,
                                                     n_codsolot,
                                                     c_srv.CODINSSRV,
                                                     p_comando,
                                                     p_resultado,
                                                     p_mensaje,
                                                     p_error,
                                                     0);
            INTRAWAY.PQ_INTRAWAY.P_STB_CREA_ESPACIO(4,
                                                    c_srv.ID_CLIENTE,
                                                    c_srv.ID_PRODUCTO,
                                                    c_srv.ID_PRODUCTO,
                                                    c_srv.ID_ACTIVACION,
                                                    c_srv.CODIGO_EXT,
                                                    p_channelmap,
                                                    c_srv.Modelo,
                                                    p_sendtocontroler,
                                                    p_proceso,
                                                    n_codsolot,
                                                    c_srv.CODINSSRV,
                                                    p_resultado,
                                                    p_mensaje,
                                                    p_error,
                                                    0,
                                                   c_srv.id_venta,
                                                    0);
            INTRAWAY.PQ_INTRAWAY.P_STB_CREA_ESPACIO(2,
                                                    c_srv.ID_CLIENTE,
                                                    c_srv.ID_PRODUCTO,
                                                    c_srv.ID_PRODUCTO,
                                                    c_srv.ID_ACTIVACION,
                                                    c_srv.CODIGO_EXT,
                                                    p_channelmap,
                                                    'VES_DSP',
                                                    p_sendtocontroler,
                                                    p_proceso,
                                                    n_codsolot,
                                                    c_srv.CODINSSRV,
                                                    p_resultado,
                                                    p_mensaje,
                                                    p_error,
                                                    0,
                                                    c_srv.id_venta,
                                                    0);
            p_sendtocontroler := 'FALSE';
            INTRAWAY.PQ_INTRAWAY.P_STB_CREA_ESPACIO(0,
                                                    c_srv.ID_CLIENTE,
                                                    c_srv.ID_PRODUCTO,
                                                    c_srv.ID_PRODUCTO,
                                                    c_srv.ID_ACTIVACION,
                                                    c_srv.CODIGO_EXT,
                                                    p_channelmap,
                                                    'VES_DSP',
                                                    p_sendtocontroler,
                                                    p_proceso,
                                                    n_codsolot,
                                                    c_srv.CODINSSRV,
                                                    p_resultado,
                                                    p_mensaje,
                                                    p_error,
                                                    0,
                                                    c_srv.id_venta,
                                                    0);
          end if;
        end if;
      end loop;
    END IF;

    --  o_mensaje := p_mensaje;
    --  o_error   := p_error;

  END;

  PROCEDURE p_baja_fact_serv_fec_comp(a_idtareawf in number,
                                      a_idwf      in number,
                                      a_tarea     in number,
                                      a_tareadef  in number) IS
    d_feccom   date;
    n_codsolot number;
    n_codmotot number;--2.0
    n_cont number;--2.0
  BEGIN
    --select wf.codsolot, solot.feccom --2.0
    select wf.codsolot, solot.feccom, solot.codmotot --2.0
      into n_codsolot, d_feccom, n_codmotot --2.0
      from wf, solot
     where wf.codsolot = solot.codsolot
       and idwf = a_idwf;
    --Inicio 2.0
    select count(1) into n_cont
    from motot where codmotot in (select codigon from opedd where tipopedd = 1060);
    --Fin 2.0
    if n_cont = 1 then --2.0
--      if to_char(sysdate, 'yyyymmdd') = to_char(d_feccom, 'yyyymmdd') then 3.0
      if to_char(sysdate, 'yyyymmdd') >= to_char(d_feccom, 'yyyymmdd') then --3.0

        OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                       4,
                                       4,
                                       0,
                                       SYSDATE,
                                       SYSDATE);
      else
        --La tarea sigue abierta y no se realiza ningun proceso
        null;
      end if;
    end if;--2.0
  end;

  PROCEDURE p_ejecuta_job_1_dia IS
    cursor c_wf is
      select a.idtareawf,
             a.tarea,
             a.idwf,
             a.tipesttar,
             a.tareadef
        from tareawf a
       where a.tipesttar in (1,2)
          and a.frecuencia = 1440;
    v_cur_proc varchar2(200);--7.0

  BEGIN
    for c_1 in c_wf loop
      select cur_proc into v_cur_proc from tareawfcpy where idtareawf=c_1.idtareawf;--7.0
      if v_cur_proc is not null then--7.0
        PQ_WF.P_EJECUTA_PROC(v_cur_proc,--7.0
                             c_1.idtareawf,
                             c_1.idwf,
                             c_1.tarea,
                             c_1.tareadef);

      end if;
    end loop;

  end;

--Inicio 5.0
PROCEDURE p_obtener_info_iw(a_id_cliente number,a_idtransaccion number,
    an_tipoaccion in number,
    o_REPORTOBJOUTPUT in varchar2,o_DOCSISREPORT in varchar2,
    o_PACKETCABLEREPORT in varchar2,o_DAC in varchar2,
    o_ENDPOINTS in varchar2, o_SERVICIOS in varchar2,
    o_CALLFEATURES in varchar2, o_SOFTSWITCH in varchar2,
    o_resultado_ws number, o_error_ws varchar2) IS
  n_cont number;
  v_codcli varchar2(4000);
  v_subcadena varchar2(4000);
  n_resultado number;
  v_error varchar2(4000);
  n_codsolot number;--18.0
  --ini 23.0
  n_pidsga       number;
  n_codinssrv    number;
  v_codigo_ext   varchar2(150);
  v_cmcrmid      varchar2(100);
  v_linea        char(2);
  n_interfase    number;
  n_interfase_a  number;
  n_interfase_b  number;
  v_idproducto   varchar2(30);
  n_docsis       number;
  n_packetcable  number;
  n_endpoitns    number;
  n_callfeatures number;
  n_dac          number;
  n_serv_adic    number;
  n_serv_vod     number;
  --fin 23.0
  --Inicio 20.0
  l_tipo number;
  n_enacta number;
  l_cont_equipos number;
  l_orden number;
  v_obs varchar2(2000);--21.0
  l_punto number;
  ln_idagenda number;
  v_cod_sap VARCHAR2(100);
  v_numserie VARCHAR2(100);
  n_codeta number;
  n_tipequ number;
  n_costo tipequ.costo%type;
  cursor c_eq is
  select a.id_cliente,a.id_producto,a.serialnumber,a.codsolot, a.macaddress,
  nvl((select b.cod_sap from Maestro_Series_Equ b
  where a.serialnumber = b.nroserie and rownum=1 ),'-') cod_sap,a.id_seq
  from OPERACION.OPE_EQU_IW  a
  where a.idtransaccion = a_idtransaccion
  and not ( (a.serialnumber= 'null' and a.macaddress='null')
            or (a.serialnumber= 'N/A' and a.macaddress='null')
            or (a.serialnumber is null and a.macaddress is null)
            or (a.serialnumber='N/A' and a.macaddress is null) );
  --Fin 20.0
begin
  --18.0
  select codsolot into n_codsolot from OPERACION.TRS_WS_SGA where IDTRANSACCION=a_idtransaccion;
  update OPERACION.TRS_WS_SGA set reportobjoutput=o_REPORTOBJOUTPUT,
  docsisreport=o_DOCSISREPORT,packetcablereport=o_PACKETCABLEREPORT,dac=o_DAC,
  endpoints=o_ENDPOINTS,servicios=o_SERVICIOS,callfeatures=o_CALLFEATURES,
  softswitch=o_SOFTSWITCH,resultado_WS=o_resultado_ws,error_ws=o_error_ws,fecactws=sysdate
  where IDTRANSACCION=a_idtransaccion;
  COMMIT;
  if an_tipoaccion in(1,3,4) then --Descarga de Equipos
    n_cont:=1;
    v_codcli:= f_cadena(o_REPORTOBJOUTPUT,'|',3);--21.0
    --DOCSISREPORT
    if o_DOCSISREPORT is not null then
      n_cont:=1;
      v_subcadena := f_cadena(o_DOCSISREPORT,'||',n_cont);
      while (v_subcadena is not null) loop
        begin --21.0
          insert into OPERACION.OPE_EQU_IW( ID_PRODUCTO ,ID_INTERFASE ,ID_CLIENTE ,
          ID_ACTIVACION ,MACADDRESS ,SERIALNUMBER,IDTRANSACCION,OBJETOIW,CODSOLOT)--18.0
          values(f_cadena(v_subcadena,'|',2),'620',v_codcli,
          f_cadena(v_subcadena,'|',20),f_cadena(v_subcadena,'|',9),
          f_cadena(v_subcadena,'|',21),a_idtransaccion,substr(o_DOCSISREPORT,1,4000),n_codsolot);--18.0
          n_cont:=n_cont+1;
          v_subcadena := f_cadena(o_DOCSISREPORT,'||',n_cont);
        exception --21.0
          when others then
            v_error:=sqlerrm;
            n_resultado:=sqlcode;
            UPDATE OPERACION.TRS_WS_SGA  --24.0
            SET error_ws= nvl(error_ws,'')||', Error Docsis: '||v_error, resultado=n_resultado
            where IDTRANSACCION=a_idtransaccion;
        end;
        commit;
      end loop;
    end if;
    --DAC
    if o_DAC is not null then
      n_cont:=1;
      v_subcadena := f_cadena(o_DAC,'||',n_cont);
      while (v_subcadena is not null) loop
        begin --21.0
          insert into OPERACION.OPE_EQU_IW( ID_PRODUCTO ,ID_INTERFASE ,ID_CLIENTE , modelo, --21.0
          ID_ACTIVACION ,MACADDRESS ,SERIALNUMBER, IDTRANSACCION,OBJETOIW,CODSOLOT)--18.0
          values(f_cadena(v_subcadena,'|',2),'2020',v_codcli,f_cadena(v_subcadena,'|',9),
          f_cadena(v_subcadena,'|',22),f_cadena(v_subcadena,'|',8),--21.0
          f_cadena(v_subcadena,'|',7),a_idtransaccion,substr(o_DAC,1,4000),n_codsolot);--18.0
          n_cont:=n_cont+1;
          v_subcadena := f_cadena(o_DAC,'||',n_cont);
        exception --21.0
          when others then
            v_error:=sqlerrm;
            n_resultado:=sqlcode;
            UPDATE OPERACION.TRS_WS_SGA   --24.0
            SET error_ws=nvl(error_ws,'')||', Error DAC: '||v_error, resultado=n_resultado
            where IDTRANSACCION=a_idtransaccion;
        end;
        commit;
      end loop;
    end if;
  end if;

  if an_tipoaccion=4 then --18.0
    update OPERACION.OPE_EQU_IW set estado=1 where idtransaccion=a_idtransaccion;
  end if;

  if an_tipoaccion=1 then --20.0
    begin
      select a.codigon_aux into l_tipo
      from opedd a, tipopedd b, solot c
      where a.tipopedd=b.tipopedd and c.codsolot= n_codsolot
      and b.abrev='REDEEQUSGAIW' and a.codigon= c.tiptra;
    exception
      when no_data_found then
      l_tipo:=1;
    end;
    begin
      select IDAGENDA into ln_idagenda from AGENDAMIENTO A, OPEDD B, TIPOPEDD C
      WHERE A.codsolot= n_codsolot AND A.tipo= B.codigoc AND
      B.TIPOPEDD =C.TIPOPEDD AND C.ABREV='TIPOAGENDAEQUIPOS';
    exception
      when no_data_found then
        select max(idagenda) into ln_idagenda
        from agendamiento where codsolot = n_codsolot;
    end;
    n_enacta:=0;
    v_obs:='Carga Equipos desde IW.ws.';    --24.0
    if /*l_tipo = 1 or*/ l_tipo =3 then--Se controlan las Bajas
      for c_e in c_eq loop
          v_numserie:=null;
          if l_tipo = 3 then --Bajas
            l_punto:=1;
            n_enacta:=1;
            n_codeta:=647;
            select count(1) into l_cont_equipos --Validar si el equipo esta registrado en la SOT de Baja
            from solotptoequ a
            where trim(a.numserie) = c_e.serialnumber and a.codsolot=n_codsolot;
          elsif l_tipo=1 then --Para Instalaciones
            select count(1) into l_cont_equipos --Validar si el equipo esta registrado Instalaciones
            from solotptoequ a, solot b
            where a.codsolot=b.codsolot and b.codcli='00'
            and trim(a.numserie) = c_e.serialnumber;
          end if;

          SELECT NVL(MAX(ORDEN), 0) + 1  INTO l_orden
          from solotptoequ
          where codsolot = n_codsolot and punto = l_punto and rownum=1;
          if l_cont_equipos = 0 then
              v_cod_sap:=c_e.cod_sap;
              if c_e.cod_sap='-' then
                begin
                  select b.cod_sap into v_cod_sap
                  from Maestro_Series_Equ b
                  where (( c_e.serialnumber like '%' || b.nroserie   and length(b.nroserie)> 12 )
                  or (c_e.serialnumber like  b.nroserie || '%'   and length(b.nroserie)> 12 )
                  or (trim(upper(replace(replace(c_e.macaddress, ':', ''), '.', ''))) = b.mac1  ) )
                  and rownum=1;

                  if not v_cod_sap is null and not v_cod_sap='-' then--Si existe el codigo sap
                    select b.nroserie into v_numserie
                    from Maestro_Series_Equ b
                    where (( c_e.serialnumber like '%' || b.nroserie   and length(b.nroserie)> 12 )
                    or (c_e.serialnumber like  b.nroserie || '%'   and length(b.nroserie)> 12 )
                    or (trim(upper(replace(replace(c_e.macaddress, ':', ''), '.', ''))) = b.mac1  ) )
                    and rownum=1;
                  end if;
                exception
                   when no_Data_found then
                   n_tipequ := 999;
                   v_obs:=v_obs ||'Equipo no se identifica en la BD.';
                end;
                v_obs:=v_obs ||'Equipo cargado con Serie incompleta.';
              end if;
              begin
                select c1.tipequ , ( select a2.codeta
                from matetapaxfor a2, tiptrabajoxfor b2,solot c2
                where a2.codfor=b2.codfor and b2.tiptra=c2.tiptra
                and c2.codsolot= n_codsolot and a2.codmat= b1.codmat and rownum=1) codeta,
                c1.costo
                into n_tipequ, n_codeta,n_costo
                from almtabmat b1, tipequ c1
                where  b1.codmat=c1.codtipequ(+)
                and trim( b1.cod_sap)= v_cod_sap and rownum=1;
              exception
                when others then
                  n_tipequ:=999;
                  n_codeta:=647;
              end;
              begin
                insert into solotptoequ(codsolot,punto,orden,tipequ,CANTIDAD,TIPPRP,
                COSTO,NUMSERIE,flgsol,flgreq,codeta,tran_solmat,observacion,fecfdis,
                instalado,idagenda,fecins,flg_ingreso,mac,ESTADOEQU,enacta)
                values(n_codsolot,l_punto,l_orden,n_tipequ,1,0,nvl(n_costo,0),
                nvl(v_numserie,c_e.serialnumber),1,0,n_codeta,null,v_obs,Sysdate,1,
                ln_idagenda,sysdate,3,c_e.macaddress,1,n_enacta);
              exception
                when others then
                  v_error:=sqlerrm;
                  n_resultado:=sqlcode;
                  --ini 24.0
                  UPDATE OPERACION.TRS_WS_SGA
                  SET error= 'Equ: '||v_error||chr(13)||nvl(error,''), resultado=n_resultado
                  where IDTRANSACCION=a_idtransaccion;

                  UPDATE OPERACION.OPE_EQU_IW
                  SET error= v_error||chr(13)||'orden:'||to_char(l_orden)||',tipequ:'||to_char(n_tipequ)
                  where id_seq = c_e.id_seq;
                  --fin 24.0
              end;
              commit;
          end if;
      end loop;
    end if;
  end if;

  if an_tipoaccion=2 then --Descarga de Informacion
    begin
      if o_REPORTOBJOUTPUT is not null then
        n_cont:=1;--o_REPORTOBJOUTPUT
        v_subcadena := f_cadena(o_REPORTOBJOUTPUT,'||',n_cont);
        while (v_subcadena is not null) loop--20.0
          INSERT INTO operacion.IW_REPORT(IDTRANSACCION,IDEMPRESACRM,IDCLIENTECRM,
          IDTIPOCLIENTE,EMPRESA,TIPOCLIENTE,NOMBRE,USERNAME,PASSWORD,FECHAALTA,
          EMAILNOTICIAS,CICLOFACTURACION,COM21)VALUES(a_idtransaccion,
          f_cadena(v_subcadena, '|', 1),f_cadena(v_subcadena, '|', 3),
          f_cadena(v_subcadena, '|', 4),f_cadena(v_subcadena, '|', 2),
          f_cadena(v_subcadena, '|', 5),f_cadena(v_subcadena, '|', 6),
          f_cadena(v_subcadena, '|', 7),f_cadena(v_subcadena, '|', 8),
          f_cadena(v_subcadena, '|', 9),f_cadena(v_subcadena, '|', 10),
          f_cadena(v_subcadena, '|', 11),f_cadena(v_subcadena, '|', 12));
          n_cont:=n_cont+1;
          v_subcadena := f_cadena(o_REPORTOBJOUTPUT,'||',n_cont);
        end loop;
      end if;
      if o_DOCSISREPORT is not null then
        n_cont:=1;--o_DOCSIS
        v_subcadena := f_cadena(o_DOCSISREPORT,'||',n_cont);
        while (v_subcadena is not null) loop--20.0
          insert into operacion.IW_DOCSIS(IDTRANSACCION,IDSERVICIO,IDPRODUCTO,
          IDVENTA,IDSERVICIOPADRE,IDPRODUCTOPADRE,IDVENTAPADRE,HUB,NODO,
          MACADDRESS,DOCSISVERSION,CANTCPE,SERVICEPACKAGE,FECHAALTA,
          FECHAACTIVACION,MENSAJES,ACTIVO,ISPCM,ISPCPE,BANDPACKAGE,
          CODIGO,SERIALNUMBER,ACTCODEEXPDATE,ACTCODELASTUSAGE)
          values(a_idtransaccion,f_cadena(v_subcadena,'|',1),f_cadena(v_subcadena,'|',2),
          f_cadena(v_subcadena,'|',3),f_cadena(v_subcadena,'|',4),f_cadena(v_subcadena,'|',5),
          f_cadena(v_subcadena,'|',6),f_cadena(v_subcadena,'|',7),f_cadena(v_subcadena,'|',8),
          f_cadena(v_subcadena,'|',9),f_cadena(v_subcadena,'|',10),f_cadena(v_subcadena,'|',11),
          f_cadena(v_subcadena,'|',12),f_cadena(v_subcadena,'|',13),f_cadena(v_subcadena,'|',14),
          f_cadena(v_subcadena,'|',15),f_cadena(v_subcadena,'|',16),f_cadena(v_subcadena,'|',17),
          f_cadena(v_subcadena,'|',18),f_cadena(v_subcadena,'|',19),f_cadena(v_subcadena,'|',20),
          f_cadena(v_subcadena,'|',21),f_cadena(v_subcadena,'|',22),f_cadena(v_subcadena,'|',28));
          n_cont:=n_cont+1;
          v_subcadena := f_cadena(o_DOCSISREPORT,'||',n_cont);
        end loop;
      end if;
      if o_PACKETCABLEREPORT is not null then
        n_cont:=1;--IW_PACKETCABLE
        v_subcadena := f_cadena(o_PACKETCABLEREPORT,'||',n_cont);
        while (v_subcadena is not null) loop--20.0
          insert into operacion.IW_PACKETCABLE(IDTRANSACCION,IDSERVICIO,IDPRODUCTO,
          IDVENTA,IDSERVICIOPADRE,IDPRODUCTOPADRE,IDVENTAPADRE,MACADDRESS,LINESQTY,
          FECHAALTA,FECHAACTIVACION,ACTIVO,ISPMTA,MTAPROFILE,MTAMODEL,CODIGO,
          ACTCODEEXPDATE,ACTCODELASTUSE)
          values(a_idtransaccion,f_cadena(v_subcadena,'|',1),f_cadena(v_subcadena,'|',2),
          f_cadena(v_subcadena,'|',3),f_cadena(v_subcadena,'|',4),f_cadena(v_subcadena,'|',5),
          f_cadena(v_subcadena,'|',6),f_cadena(v_subcadena,'|',7),f_cadena(v_subcadena,'|',8),
          f_cadena(v_subcadena,'|',9),f_cadena(v_subcadena,'|',10),f_cadena(v_subcadena,'|',11),
          f_cadena(v_subcadena,'|',12),f_cadena(v_subcadena,'|',13),f_cadena(v_subcadena,'|',14),
          f_cadena(v_subcadena,'|',15),f_cadena(v_subcadena,'|',16),f_cadena(v_subcadena,'|',17));
          n_cont:=n_cont+1;
          v_subcadena := f_cadena(o_PACKETCABLEREPORT,'||',n_cont);
        end loop;
      end if;
      if o_DAC is not null then
        n_cont:=1;--IW_DAC
        v_subcadena := f_cadena(o_DAC,'||',n_cont);
        while (v_subcadena is not null) loop--20.0
          insert into operacion.IW_DAC(IDTRANSACCION,IDSERVICIO,IDPRODUCTO,IDVENTA,
          IDSERVICIOPADRE,IDPRODUCTOPADRE,IDVENTAPADRE,SERIALNUMBER,UNITADDRESS,
          CONVERTERTYPE,HEADEND,CHANNELMAP,CONTROLLER,DEFAULTSERVICE,
          DISABLED,PPVENABLED,FECHAALTA,FECHAMODIF,
          FECHAACTIVACION,CODIGO,ACTCODEEXPDATE,ACTCODELASTUSE,nvodenabled,pacenabled,defaultconfig)
          values(a_idtransaccion,f_cadena(v_subcadena,'|',1),f_cadena(v_subcadena,'|',2),
          f_cadena(v_subcadena,'|',3),f_cadena(v_subcadena,'|',4),f_cadena(v_subcadena,'|',5),
          f_cadena(v_subcadena,'|',6),f_cadena(v_subcadena,'|',7),f_cadena(v_subcadena,'|',8),
          f_cadena(v_subcadena,'|',9),f_cadena(v_subcadena,'|',10),f_cadena(v_subcadena,'|',11),
          f_cadena(v_subcadena,'|',12),f_cadena(v_subcadena,'|',13),f_cadena(v_subcadena,'|',15),
          f_cadena(v_subcadena,'|',16),f_cadena(v_subcadena,'|',19),f_cadena(v_subcadena,'|',20),
          f_cadena(v_subcadena,'|',21),f_cadena(v_subcadena,'|',22),f_cadena(v_subcadena,'|',23),
          f_cadena(v_subcadena,'|',24),f_cadena(v_subcadena,'|',17),f_cadena(v_subcadena,'|',18),
          f_cadena(v_subcadena,'|',14));
          n_cont:=n_cont+1;
          v_subcadena := f_cadena(o_DAC,'||',n_cont);
        end loop;
      end if;
      if o_ENDPOINTS is not null then
        n_cont:=1;--IW_ENDPOINTS
        v_subcadena := f_cadena(o_ENDPOINTS,'||',n_cont);
        while (v_subcadena is not null) loop--20.0
          insert into operacion.IW_ENDPOINTS(IDTRANSACCION,IDSERVICIO,IDPRODUCTO,
          IDVENTA,IDSERVICIOPADRE,IDPRODUCTOPADRE,IDVENTAPADRE,ENDPOINTNUMBER,
          TN,EPPROFILE,EPHOMEEXCHANGE,FECHAALTA,FECHAACTIVACION,ACTIVO)
          values(a_idtransaccion,f_cadena(v_subcadena,'|',1),f_cadena(v_subcadena,'|',2),
          f_cadena(v_subcadena,'|',3),f_cadena(v_subcadena,'|',4),f_cadena(v_subcadena,'|',5),
          f_cadena(v_subcadena,'|',6),f_cadena(v_subcadena,'|',7),f_cadena(v_subcadena,'|',8),
          f_cadena(v_subcadena,'|',9),f_cadena(v_subcadena,'|',10),f_cadena(v_subcadena,'|',11),
          f_cadena(v_subcadena,'|',12),f_cadena(v_subcadena,'|',15));
          n_cont:=n_cont+1;
          v_subcadena := f_cadena(o_ENDPOINTS,'||',n_cont);
        end loop;
      end if;
      if o_SERVICIOS is not null then
        n_cont:=1;--IW_SERVICIOS
        v_subcadena := f_cadena(o_SERVICIOS,'||',n_cont);
        while (v_subcadena is not null) loop--20.0
          insert into operacion.IW_SERVICIOS(IDTRANSACCION,IDSERVICIO,IDPRODUCTO,
          IDVENTA,IDSERVICIOPADRE,IDPRODUCTOPADRE,IDVENTAPADRE,SERVICE,FECHAALTA)
          values(a_idtransaccion,f_cadena(v_subcadena,'|',1),f_cadena(v_subcadena,'|',4),
          f_cadena(v_subcadena,'|',2),f_cadena(v_subcadena,'|',3),f_cadena(v_subcadena,'|',5),
          f_cadena(v_subcadena,'|',6),f_cadena(v_subcadena,'|',7),f_cadena(v_subcadena,'|',9));
          n_cont:=n_cont+1;
          v_subcadena := f_cadena(o_SERVICIOS,'||',n_cont);
        end loop;
      end if;
      if o_CALLFEATURES is not null then
        n_cont:=1;--IW_CALLFEATURES
        v_subcadena := f_cadena(o_CALLFEATURES,'||',n_cont);
        while (v_subcadena is not null) loop
          insert into operacion.IW_CALLFEATURES(IDTRANSACCION,IDSERVICIO,IDPRODUCTO,
          IDVENTA,IDSERVICIOPADRE,IDPRODUCTOPADRE,IDVENTAPADRE,
          CFCRMID,CFCMSID,CFNAME,CFSVSUBSCRIBED,CFIWSUBSCRIBED,CFACTIVE)
          values(a_idtransaccion,f_cadena(v_subcadena,'|',1),f_cadena(v_subcadena,'|',2),
          f_cadena(v_subcadena,'|',3),f_cadena(v_subcadena,'|',4),f_cadena(v_subcadena,'|',5),
          f_cadena(v_subcadena,'|',6),f_cadena(v_subcadena,'|',7),f_cadena(v_subcadena,'|',8),
          f_cadena(v_subcadena,'|',9),f_cadena(v_subcadena,'|',10),f_cadena(v_subcadena,'|',11),
          f_cadena(v_subcadena,'|',12));
          n_cont:=n_cont+1;
          v_subcadena := f_cadena(o_CALLFEATURES,'||',n_cont);
        end loop;
      end if;
      if o_SOFTSWITCH is not null then
        n_cont:=1;--IW_SOFTSWITCH
        v_subcadena := f_cadena(o_SOFTSWITCH,'||',n_cont);
        while (v_subcadena is not null) loop--20.0
          insert into operacion.IW_SOFTSWITCH(IDTRANSACCION,SOFTSWITCHTYPE,
          SOFTSWITCHNAME,SOFTSWITCHCRMID,GATEWAYCONTROLLERNAME,GATEWAYCONTROLLERCRMID)
          values(a_idtransaccion,f_cadena(v_subcadena,'|',2),f_cadena(v_subcadena,'|',1),
          f_cadena(v_subcadena,'|',3),f_cadena(v_subcadena,'|',4),f_cadena(v_subcadena,'|',5));
          n_cont:=n_cont+1;
          v_subcadena := f_cadena(o_SOFTSWITCH,'||',n_cont);
        end loop;
      end if;
    exception
      when others then
        v_error:=sqlerrm;
        n_resultado:=sqlcode;
        UPDATE OPERACION.TRS_WS_SGA SET error= '-'||v_error, resultado=n_resultado--18.0
        where IDTRANSACCION=a_idtransaccion;
    end;
  end if;

   --ini 23.0
  if an_tipoaccion=5 then --Descarga de Informacion y Actualización de la información
   begin
      --carga de interfases
      select  valor into n_docsis from OPERACION.CONSTANTE where CONSTANTE='IW_DOCSIS';
      select  valor into n_packetcable from OPERACION.CONSTANTE where CONSTANTE='IW_PACKETCABLE';
      select  valor into n_endpoitns from OPERACION.CONSTANTE where CONSTANTE='IW_ENDPOINTS';
      select  valor into n_callfeatures from OPERACION.CONSTANTE where CONSTANTE='IW_CALLFEATURES';
      select  valor into n_dac from OPERACION.CONSTANTE where CONSTANTE='IW_DAC';
      select  valor into n_serv_adic from OPERACION.CONSTANTE where CONSTANTE='IW_SERV_ADIC';
      select  valor into n_serv_vod from OPERACION.CONSTANTE where CONSTANTE='IW_SERV_VOD';

      --Código del cliente
      v_codcli   := f_cadena(o_REPORTOBJOUTPUT,'|',3);

      --limpiar tabla INT_SERVICIO_INTRAWAY
      v_linea     := '1';
      n_interfase := 0;
      delete from intraway.INT_SERVICIO_INTRAWAY
      where  ID_CLIENTE = v_codcli;

      n_interfase := n_docsis;
      if o_DOCSISREPORT is not null then
        n_cont      := 1;--o_DOCSIS

        v_subcadena := f_cadena(o_DOCSISREPORT,'||',n_cont);
        while (v_subcadena is not null) loop
          v_linea := '2';
          v_idproducto:= f_cadena(v_subcadena,'|',2);

          begin
            select iw.codsolot,iw.pidsga,iw.codinssrv
            into   n_codsolot,n_pidsga,n_codinssrv
            from   int_mensaje_intraway iw
            where  iw.id_Producto  = v_idproducto
            and    iw.id_interfase = n_interfase
            and    iw.id_cliente   = v_codcli
            and    iw.id_interfaz  = (select max(im.id_interfaz) from int_mensaje_intraway im
                                      where  im.id_Producto   = iw.id_Producto
                                      and    im.id_interfase  = n_interfase and im.id_cliente= v_codcli);
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
                n_codsolot :=0;
                n_pidsga   :=0;
                n_codinssrv:=0;
                n_resultado:=sqlcode;
                v_error:=sqlerrm;
                insert into HISTORICO.OPET_INSSERVINTRAWAY_LOG
                (SVIWN_INTERFASE,SVIWN_TRANSACCION,SVIWN_CODSOLOT,SVIWC_CODCLI,SVIWN_ERROR,SVIWV_MENSAJE) values
                (n_interfase,a_idtransaccion,0,v_codcli,n_resultado,'Linea:'||v_linea||' '||v_error);
          end;

          --tabla de intraway
          v_linea     := '3';

          insert into intraway.INT_SERVICIO_INTRAWAY
          (ID_PRODUCTO,ID_INTERFASE,ID_CLIENTE,
           ID_VENTA,ID_ACTIVACION,MACADDRESS,
           MODELO,CODIGO_EXT,CODSOLOT,
           PID_SGA,ESTADO,FECHA_CREACION,
           FECHA_ACTIVACION,ID_PRODUCTO_PADRE,ID_VENTA_PADRE,
           NUMERO,CODINSSRV,PID_OLD_SGA,CANTCPE)
           values
          (v_idproducto,to_char(n_interfase),v_codcli,
           f_cadena(v_subcadena,'|',3),f_cadena(v_subcadena,'|',20),f_cadena(v_subcadena,'|',9),
           f_cadena(v_subcadena,'|',7),substr(f_cadena(v_subcadena,'|',12),1,40),n_codsolot,
           n_pidsga,1,to_date(f_cadena(v_subcadena,'|',13),'dd/mm/yyyy hh24:mi:ss'),
           to_date(f_cadena(v_subcadena,'|',14),'dd/mm/yyyy hh24:mi:ss'),f_cadena(v_subcadena,'|',5),f_cadena(v_subcadena,'|',6),
           substr(f_cadena(v_subcadena,'|',8),1,30),n_codinssrv,n_pidsga,to_number(f_cadena(v_subcadena,'|',11)));

           n_cont:=n_cont+1;
           v_subcadena := f_cadena(o_DOCSISREPORT,'||',n_cont);
        end loop;
      else-- si no existe información
          --tabla log
          v_linea     := '4';
          insert into HISTORICO.OPET_INSSERVINTRAWAY_LOG
         (SVIWN_INTERFASE,SVIWN_TRANSACCION,SVIWN_CODSOLOT,SVIWC_CODCLI,SVIWN_ERROR,SVIWV_MENSAJE) values
         (n_interfase,a_idtransaccion,0,v_codcli,0,'Linea:'||v_linea||' No existe información');

      end if;

      n_interfase := n_packetcable;
      if o_PACKETCABLEREPORT is not null then
        n_cont:=1;--IW_PACKETCABLE

        v_subcadena := f_cadena(o_PACKETCABLEREPORT,'||',n_cont);
        while (v_subcadena is not null) loop
         v_linea     := '5';
         v_idproducto:= f_cadena(v_subcadena,'|',2);

         begin
            select iw.codsolot,iw.pidsga,iw.codinssrv
            into   n_codsolot,n_pidsga,n_codinssrv
            from   int_mensaje_intraway iw
            where  iw.id_Producto  = v_idproducto
            and    iw.id_interfase = n_interfase
            and    iw.id_cliente   = v_codcli
            and    iw.id_interfaz  = (select max(im.id_interfaz) from int_mensaje_intraway im
                                      where  im.id_Producto   = iw.id_Producto
                                      and    im.id_interfase  = n_interfase and im.id_cliente= v_codcli);
         EXCEPTION
         WHEN NO_DATA_FOUND THEN
              n_codsolot :=0;
              n_pidsga   :=0;
              n_codinssrv:=0;
              n_resultado:=sqlcode;
              v_error:=sqlerrm;
              insert into HISTORICO.OPET_INSSERVINTRAWAY_LOG
              (SVIWN_INTERFASE,SVIWN_TRANSACCION,SVIWN_CODSOLOT,SVIWC_CODCLI,SVIWN_ERROR,SVIWV_MENSAJE) values
              (n_interfase,a_idtransaccion,0,v_codcli,n_resultado,'Linea:'||v_linea||' '||v_error);
         END;

         v_linea     := '6';

         BEGIN
            select distinct valor_atributo
            into   v_codigo_ext
            from   int_mensaje_atributo_intraway
            where  nombre_atributo ='ProfileCrmId'
            and    id_mensaje_intraway in (select id_interfaz
                                           from   int_mensaje_intraway
                                           where  id_interfase = n_interfase
                                           and    id_cliente   = v_codcli
                                           and    id_producto  = f_cadena(v_subcadena,'|',2));
         EXCEPTION
         WHEN NO_DATA_FOUND THEN
              v_codigo_ext :=' ';
              n_resultado:=sqlcode;
              v_error:=sqlerrm;
              insert into HISTORICO.OPET_INSSERVINTRAWAY_LOG
              (SVIWN_INTERFASE,SVIWN_TRANSACCION,SVIWN_CODSOLOT,SVIWC_CODCLI,SVIWN_ERROR,SVIWV_MENSAJE) values
              (n_interfase,a_idtransaccion,0,v_codcli,n_resultado,'Linea:'||v_linea||' '||v_error);
         END;

          v_linea     := '7';

         BEGIN --MEJORAR
            select DISTINCT b.softswitchtype
            into   v_cmcrmid
            from   OPERACION.IW_PACKETCABLE a, OPERACION.IW_SOFTSWITCH  b
            where  a.idtransaccion = b.idtransaccion
            AND    a.idtransaccion = a_idtransaccion;

         EXCEPTION
         WHEN NO_DATA_FOUND THEN
              v_cmcrmid :=' ';
              n_resultado:=sqlcode;
              v_error:=sqlerrm;
              insert into HISTORICO.OPET_INSSERVINTRAWAY_LOG
              (SVIWN_INTERFASE,SVIWN_TRANSACCION,SVIWN_CODSOLOT,SVIWC_CODCLI,SVIWN_ERROR,SVIWV_MENSAJE) values
              (n_interfase,a_idtransaccion,0,v_codcli,n_resultado,'Linea:'||v_linea||' '||v_error);
         END;

          --tabla de intraway
          v_linea     := '8';

          insert into intraway.INT_SERVICIO_INTRAWAY
          (ID_PRODUCTO,ID_INTERFASE,ID_CLIENTE,
           ID_VENTA,MACADDRESS,MODELO,
           CODIGO_EXT,CODSOLOT,PID_SGA,
           ESTADO,ID_PRODUCTO_PADRE,ID_VENTA_PADRE,
           CODINSSRV,NROENDPOINT,PID_OLD_SGA,
           CMSCRMID)
           values
           (v_idproducto,to_char(n_interfase),v_codcli,
           f_cadena(v_subcadena,'|',3),substr(f_cadena(v_subcadena,'|',7),1,32),f_cadena(v_subcadena,'|',14),
           v_codigo_ext,n_codsolot,n_pidsga,
           1,f_cadena(v_subcadena,'|',5),f_cadena(v_subcadena,'|',6),
           n_codinssrv,to_number(f_cadena(v_subcadena,'|',8)),n_pidsga,
           v_cmcrmid);

          n_cont:=n_cont+1;
          v_subcadena := f_cadena(o_PACKETCABLEREPORT,'||',n_cont);
        end loop;

      else-- si no existe información
         --tabla log
         v_linea     := '9';
         insert into HISTORICO.OPET_INSSERVINTRAWAY_LOG
         (SVIWN_INTERFASE,SVIWN_TRANSACCION,SVIWN_CODSOLOT,SVIWC_CODCLI,SVIWN_ERROR,SVIWV_MENSAJE) values
         (n_interfase,a_idtransaccion,0,v_codcli,0,'Linea:'||v_linea||' No existe información');

      end if;

      n_interfase := n_dac;
      if o_DAC is not null then
        n_cont:=1;--IW_DAC

        v_subcadena := f_cadena(o_DAC,'||',n_cont);
        while (v_subcadena is not null) loop
          v_linea     := '10';
          v_idproducto:= f_cadena(v_subcadena,'|',2);

          BEGIN
            select iw.codsolot,iw.pidsga,iw.codinssrv
            into   n_codsolot,n_pidsga,n_codinssrv
            from   int_mensaje_intraway iw
            where  iw.id_Producto  = v_idproducto
            and    iw.id_interfase = n_interfase
            and    iw.id_cliente   = v_codcli
            and    iw.id_interfaz  = (select max(im.id_interfaz) from int_mensaje_intraway im
                                      where  im.id_Producto   = iw.id_Producto
                                      and    im.id_interfase  = n_interfase and im.id_cliente= v_codcli);

          EXCEPTION
          WHEN NO_DATA_FOUND THEN
              n_codsolot:=0;
              n_pidsga:=0;
              n_codinssrv:=0;
              n_resultado:=sqlcode;
              v_error:=sqlerrm;
              insert into HISTORICO.OPET_INSSERVINTRAWAY_LOG
              (SVIWN_INTERFASE,SVIWN_TRANSACCION,SVIWN_CODSOLOT,SVIWC_CODCLI,SVIWN_ERROR,SVIWV_MENSAJE) values
              (n_interfase,a_idtransaccion,0,v_codcli,n_resultado,'Linea:'||v_linea||' '||v_error);
          END;

          --tabla de intraway
          v_linea     := '11';

          insert into intraway.INT_SERVICIO_INTRAWAY
          (ID_PRODUCTO,ID_INTERFASE,ID_CLIENTE,
           ID_VENTA,ID_ACTIVACION,MACADDRESS,
           SERIALNUMBER,MODELO,CODIGO_EXT,
           CODSOLOT,PID_SGA,ESTADO,
           FECHA_CREACION,FECHA_ACTIVACION,FECHA_MODIFICACION,
           ID_PRODUCTO_PADRE,ID_VENTA_PADRE,CODINSSRV,PID_OLD_SGA)
          values
          (v_idproducto,to_char(n_interfase),v_codcli,
           f_cadena(v_subcadena,'|',3),f_cadena(v_subcadena,'|',22),substr(f_cadena(v_subcadena,'|',7),1,32),
           substr(f_cadena(v_subcadena,'|',8),1,32),f_cadena(v_subcadena,'|',14),f_cadena(v_subcadena,'|',13),
           n_codsolot,n_pidsga,1,
           to_date(f_cadena(v_subcadena,'|',19),'dd/mm/yyyy hh24:mi:ss') ,to_date(f_cadena(v_subcadena,'|',21),'dd/mm/yyyy hh24:mi:ss'),to_date(f_cadena(v_subcadena,'|',20),'dd/mm/yyyy hh24:mi:ss'),
           f_cadena(v_subcadena,'|',5),f_cadena(v_subcadena,'|',6),n_codinssrv,n_pidsga);

          n_cont:=n_cont+1;
          v_subcadena := f_cadena(o_DAC,'||',n_cont);
        end loop;

      else-- si no existe información
          --tabla log
         v_linea     := '12';
         insert into HISTORICO.OPET_INSSERVINTRAWAY_LOG
         (SVIWN_INTERFASE,SVIWN_TRANSACCION,SVIWN_CODSOLOT,SVIWC_CODCLI,SVIWN_ERROR,SVIWV_MENSAJE) values
         (n_interfase,a_idtransaccion,0,v_codcli,0,'Linea:'||v_linea||' No existe información');

      end if;

      n_interfase := n_endpoitns;
      if o_ENDPOINTS is not null then
        n_cont:=1;--IW_ENDPOINTS-

        v_subcadena := f_cadena(o_ENDPOINTS,'||',n_cont);
        while (v_subcadena is not null) loop
          v_linea     := '13';
          v_idproducto:= f_cadena(v_subcadena,'|',2);

         BEGIN
            select iw.codsolot,iw.pidsga,iw.codinssrv
            into   n_codsolot,n_pidsga,n_codinssrv
            from   int_mensaje_intraway iw
            where  iw.id_Producto  = v_idproducto
            and    iw.id_interfase = n_interfase
            and    iw.id_cliente   = v_codcli
            and    iw.id_interfaz  = (select max(im.id_interfaz) from int_mensaje_intraway im
                                      where  im.id_Producto   = iw.id_Producto
                                      and    im.id_interfase  = n_interfase and im.id_cliente= v_codcli);

         EXCEPTION
          WHEN NO_DATA_FOUND THEN
              n_codsolot:=0;
              n_pidsga:=0;
              n_codinssrv:=0;
              n_resultado:=sqlcode;
              v_error:=sqlerrm;
              insert into HISTORICO.OPET_INSSERVINTRAWAY_LOG
              (SVIWN_INTERFASE,SVIWN_TRANSACCION,SVIWN_CODSOLOT,SVIWC_CODCLI,SVIWN_ERROR,SVIWV_MENSAJE) values
              (n_interfase,a_idtransaccion,0,v_codcli,n_resultado,'Linea:'||v_linea||' '||v_error);
          END;

          v_linea     := '14';

          BEGIN      --MEJORAR
            select distinct b.softswitchtype
            into   v_cmcrmid
            from   OPERACION.IW_ENDPOINTS a, OPERACION.IW_SOFTSWITCH  b
            where  a.idtransaccion = b.idtransaccion
            and    a.idtransaccion = a_idtransaccion;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_cmcrmid:=' ';
                v_error:=sqlerrm;
                n_resultado:=sqlcode;
                insert into HISTORICO.OPET_INSSERVINTRAWAY_LOG
                (SVIWN_INTERFASE,SVIWN_TRANSACCION,SVIWN_CODSOLOT,SVIWC_CODCLI,SVIWN_ERROR,SVIWV_MENSAJE) values
                (n_interfase,a_idtransaccion,0,v_codcli,n_resultado,'Linea:'||v_linea||' '||v_error);
          END;

          --tabla de intraway
          v_linea     := '15';

          insert into intraway.INT_SERVICIO_INTRAWAY
          (ID_PRODUCTO,ID_INTERFASE,ID_CLIENTE,
           ID_VENTA,CODIGO_EXT,CODSOLOT,
           PID_SGA,ESTADO,ID_PRODUCTO_PADRE,
           ID_VENTA_PADRE,NUMERO,CODINSSRV,
           NROENDPOINT,PID_OLD_SGA,CMSCRMID)
          values
          (v_idproducto,to_char(n_interfase),v_codcli,
           f_cadena(v_subcadena,'|',3),f_cadena(v_subcadena,'|',10), n_codsolot,
           n_pidsga,1,f_cadena(v_subcadena,'|',5),
           f_cadena(v_subcadena,'|',6),f_cadena(v_subcadena,'|',8),n_codinssrv,
           to_number(f_cadena(v_subcadena,'|',7)),n_pidsga,v_cmcrmid);

           n_cont:=n_cont+1;
           v_subcadena := f_cadena(o_ENDPOINTS,'||',n_cont);

        end loop;

      else-- si no existe información
         v_linea     := '16';
         insert into HISTORICO.OPET_INSSERVINTRAWAY_LOG
         (SVIWN_INTERFASE,SVIWN_TRANSACCION,SVIWN_CODSOLOT,SVIWC_CODCLI,SVIWN_ERROR,SVIWV_MENSAJE) values
         (n_interfase,a_idtransaccion,0,v_codcli,0,'Linea:'||v_linea||' No existe información');

      end if;

      n_interfase :=n_serv_adic;
      if o_SERVICIOS is not null then
        n_cont        := 1;--IW_SERVICIOS
        n_interfase_a := n_serv_adic;
        n_interfase_b := n_serv_vod;

        v_subcadena := f_cadena(o_SERVICIOS,'||',n_cont);
        while (v_subcadena is not null) loop
         v_linea     := '17';
         v_idproducto:= f_cadena(v_subcadena,'|',4);

         if f_cadena(v_subcadena,'|',1)=51 then
            n_interfase := n_interfase_a;
         else
            n_interfase := n_interfase_b;
         end if;

         BEGIN
            select iw.codsolot,iw.pidsga,iw.codinssrv
            into   n_codsolot,n_pidsga,n_codinssrv
            from   int_mensaje_intraway iw
            where  iw.id_Producto  = v_idproducto
            and    iw.id_interfase = n_interfase
            and    iw.id_cliente   = v_codcli
            and    iw.id_interfaz  = (select max(im.id_interfaz) from int_mensaje_intraway im
                                      where  im.id_Producto   = iw.id_Producto
                                      and    im.id_interfase  = n_interfase and im.id_cliente= v_codcli);
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
                n_codsolot:=0;
                n_pidsga:=0;
                n_codinssrv:=0;
                n_resultado:=sqlcode;
                v_error:=sqlerrm;
                insert into HISTORICO.OPET_INSSERVINTRAWAY_LOG
                (SVIWN_INTERFASE,SVIWN_TRANSACCION,SVIWN_CODSOLOT,SVIWC_CODCLI,SVIWN_ERROR,SVIWV_MENSAJE) values
                (n_interfase,a_idtransaccion,0,v_codcli,n_resultado,'Linea:'||v_linea||' '||v_error);
         END;

          v_linea     := '18';

          --tabla de intraway
          insert into intraway.INT_SERVICIO_INTRAWAY
          (ID_PRODUCTO,ID_INTERFASE,ID_CLIENTE,
           ID_VENTA,CODIGO_EXT,CODSOLOT,
           PID_SGA,ESTADO,FECHA_CREACION,
           ID_PRODUCTO_PADRE,ID_VENTA_PADRE,CODINSSRV,PID_OLD_SGA)
          values
          (v_idproducto,to_char(n_interfase),v_codcli,
           f_cadena(v_subcadena,'|',2),substr(f_cadena(v_subcadena,'|',7),1,INSTR(f_cadena(v_subcadena,'|',7),'(')-1),n_codsolot,
           n_pidsga,1,to_date(f_cadena(v_subcadena,'|',9),'dd/mm/yyyy hh24:mi:ss'),
           f_cadena(v_subcadena,'|',5),f_cadena(v_subcadena,'|',6),n_codinssrv,n_pidsga);

           n_cont:=n_cont+1;
           v_subcadena := f_cadena(o_SERVICIOS,'||',n_cont);

        end loop;

      else-- si no existe información
         --tabla log
         v_linea     := '19';
         insert into HISTORICO.OPET_INSSERVINTRAWAY_LOG
         (SVIWN_INTERFASE,SVIWN_TRANSACCION,SVIWN_CODSOLOT,SVIWC_CODCLI,SVIWN_ERROR,SVIWV_MENSAJE) values
         (n_interfase,a_idtransaccion,0,v_codcli,0,'Linea:'||v_linea||' No existe información');

      end if;

      n_interfase := n_callfeatures;
      if o_CALLFEATURES is not null then
        n_cont:=1;--IW_CALLFEATURES

        v_subcadena := f_cadena(o_CALLFEATURES,'||',n_cont);
        while (v_subcadena is not null) loop
          v_linea     := '20';
          v_idproducto:= f_cadena(v_subcadena,'|',2);

          BEGIN
            select iw.codsolot,iw.pidsga,iw.codinssrv
            into   n_codsolot,n_pidsga,n_codinssrv
            from   int_mensaje_intraway iw
            where  iw.id_Producto  = v_idproducto
            and    iw.id_interfase = n_interfase
            and    iw.id_cliente   = v_codcli
            and    iw.id_interfaz  = (select max(im.id_interfaz) from int_mensaje_intraway im
                                      where  im.id_Producto   = iw.id_Producto
                                      and    im.id_interfase  = n_interfase and im.id_cliente= v_codcli);
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
                n_codsolot:=0;
                n_pidsga:=0;
                n_codinssrv:=0;
                n_resultado:=sqlcode;
                v_error:=sqlerrm;
                insert into HISTORICO.OPET_INSSERVINTRAWAY_LOG
                (SVIWN_INTERFASE,SVIWN_TRANSACCION,SVIWN_CODSOLOT,SVIWC_CODCLI,SVIWN_ERROR,SVIWV_MENSAJE) values
                (n_interfase,a_idtransaccion,0,v_codcli,n_resultado,'Linea:'||v_linea||' '||v_error);
         END;

          --tabla de intraway
          v_linea     := '21';

          insert into intraway.INT_SERVICIO_INTRAWAY
          (ID_PRODUCTO,ID_INTERFASE,ID_CLIENTE,
           ID_VENTA,CODIGO_EXT,CODSOLOT,
           PID_SGA,ESTADO,ID_PRODUCTO_PADRE,
           ID_VENTA_PADRE,CODINSSRV,PID_OLD_SGA)
          values
           (v_idproducto,to_char(n_interfase),v_codcli,
           f_cadena(v_subcadena,'|',3),f_cadena(v_subcadena,'|',7),n_codsolot,
           n_pidsga,1,f_cadena(v_subcadena,'|',5),
           f_cadena(v_subcadena,'|',6),n_codinssrv,n_pidsga);

           n_cont:=n_cont+1;
           v_subcadena := f_cadena(o_CALLFEATURES,'||',n_cont);

        end loop;

      else-- si no existe información
         --tabla log
         v_linea     := '22';
         insert into HISTORICO.OPET_INSSERVINTRAWAY_LOG
         (SVIWN_INTERFASE,SVIWN_TRANSACCION,SVIWN_CODSOLOT,SVIWC_CODCLI,SVIWN_ERROR,SVIWV_MENSAJE) values
         (n_interfase,a_idtransaccion,0,v_codcli,0,'Linea:'||v_linea||' No existe información');

      end if;

    exception
         WHEN OTHERS THEN
          v_error:=sqlerrm;
          n_resultado:=sqlcode;
          insert into HISTORICO.OPET_INSSERVINTRAWAY_LOG
          (SVIWN_INTERFASE,SVIWN_TRANSACCION,SVIWN_CODSOLOT,SVIWC_CODCLI,SVIWN_ERROR,SVIWV_MENSAJE) values
          (n_interfase,a_idtransaccion,0,v_codcli,n_resultado ,'Linea:'||v_linea||' Error :_'||v_error);

    end;
  end if;
  --fin 23.0

  EXCEPTION--21.0
    WHEN OTHERS THEN
      v_error:=sqlerrm;
      n_resultado:=sqlcode;
      UPDATE OPERACION.TRS_WS_SGA   --24.0
      SET error= nvl(error,'')||' Error :_'||v_error||'_Linea:'||nvl(v_linea,'0'), resultado=n_resultado
      where IDTRANSACCION=a_idtransaccion;
      commit;  --24.0
end;

PROCEDURE P_INF_IW_SGA(an_codsolot in number,ac_codcli IN VARCHAR2,an_tipo in number default 1,
an_CODERROR OUT NUMBER,ac_DESCERROR OUT VARCHAR2) AS
  lc_ESQUEMAXML VARCHAR2(30000);
  lc_RESPUESTAXML VARCHAR2(30000);
  lc_target_url varchar2(2000);--:='http://172.19.74.68:8909/CargaEquiposWS/ebsCargaEquiposSB11';
  lc_action varchar2(2000);
  lc_codcli VARCHAR2(100);
  n_idtransaccion number;
  lc_ipAplicacion VARCHAR2(100);
  lc_usuarioApp VARCHAR2(100);
  lc_key_iw VARCHAR2(100);
  lc_idempresacrm VARCHAR2(100);
  ln_idagenda number;
  l_punto number;
  l_punto_ori number;
  l_punto_des number;
  l_orden number;
  l_cont_equipos number;
  v_obs VARCHAR2(200);
  v_cod_sap VARCHAR2(200);
  v_numserie VARCHAR2(200);
  n_valida number;
  n_tipequ number;
  n_codeta number;
  l_tipo number;--10.0
  n_costo tipequ.costo%type;--17.0
  n_enacta number;--18.0
  n_estadoequ number;--18.0
  n_contequ number;--19.0
  --ini 22.0
  n_contador  number;
  n_codsolot     number;
  --fin 22.0
  v_error        varchar(4000); --24.0
  exc_control_iw exception;  --24.0

  cursor c_eq is
  select a.id_cliente,a.id_producto,a.serialnumber,a.codsolot, a.macaddress,
  nvl((select b.cod_sap from Maestro_Series_Equ b
  where a.serialnumber = b.nroserie and rownum=1 ),'-') cod_sap,a.id_seq--10.0
  from OPERACION.OPE_EQU_IW  a
  where a.idtransaccion = n_idtransaccion--10.0
  and not ( (a.serialnumber= 'null' and a.macaddress='null')  --6.0
            or (a.serialnumber= 'N/A' and a.macaddress='null') ) --6.0
  and a.estado=0;--10.0

  n_coderror number;--14.0
  v_deserror varchar2(400);--14.0

  cursor c_eq3 is --18.0
  select distinct macaddress,codsolot, serialnumber,3 estado,--Instalado
  nvl((select b.cod_sap from Maestro_Series_Equ b
  where serialnumber = b.nroserie and rownum=1 ),'-') cod_sap
  from operacion.Ope_Equ_Iw
  where codsolot = an_codsolot and estado=1
  and (codsolot, serialnumber) not in (select distinct codsolot, serialnumber
                                       from operacion.Ope_Equ_Iw
                                       where codsolot = an_codsolot and estado=0)
  union
  select distinct macaddress,codsolot, serialnumber,2 ,--Retirado
  nvl((select b.cod_sap from Maestro_Series_Equ b
  where serialnumber = b.nroserie and rownum=1 ),'-') cod_sap
  from operacion.Ope_Equ_Iw
  where codsolot = an_codsolot and estado=0
  and   (codsolot, serialnumber) not in (select distinct codsolot, serialnumber
                                         from operacion.Ope_Equ_Iw
                                         where codsolot = an_codsolot and estado=1);

BEGIN

  --INI 22.0
  lc_codcli:=ac_codcli;
  
  select count(1)
  into   n_contador
  from   operacion.trs_interface_iw a,solot b
  where a.codsolot=b.codsolot and b.estsol in (29,12) and  b.codcli = lc_codcli; --<26.0>
  -- where  a.codcli = lc_codcli and a.codsolot=b.codsolot and b.estsol in (29,12);--25.0  --<26.0>

  if n_contador>0 then -- con customer_id

     select min(a.codsolot)
     into n_codsolot
     from operacion.trs_interface_iw a,solot b
     where a.codsolot=b.codsolot and b.estsol in (29,12) and  b.codcli = lc_codcli; --<26.0>
     -- where a.codcli = lc_codcli and a.codsolot=b.codsolot and b.estsol in (29,12);--25.0 --<26.0>

     select customer_id
     into   lc_codcli
     from   operacion.solot
     where  codsolot = n_codsolot;

  end if;

  lc_codcli := to_Char(to_number(lc_codcli) -1);
  --FIN 22.0

  lc_ipAplicacion := SYS_CONTEXT('USERENV','IP_ADDRESS');
  lc_usuarioApp := user;--13.0
  select utl_raw.cast_to_varchar2(valor) into lc_key_iw from constante where constante='KEY_IW';
  select valor into lc_idempresacrm from constante where constante='IDEMPRESACRM';
  select valor into lc_target_url from constante where constante='TARGET_URL_IW';
  select valor into lc_action from constante where constante='ACTION_URL_IW';
  select OPERACION.SEQ_IW_IDTRANSACCION.NEXTVAL into n_idtransaccion from dummy_ope;

  --ini 24.0
  BEGIN
    lc_ESQUEMAXML:='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:typ="http://claro.com.pe/eai/ebs/ws/operaciones/cargaequipos/types">
       <soapenv:Header/>
       <soapenv:Body>
          <typ:CargaEquiposRequest>
             <typ:idTransaccion>' || to_char(n_idtransaccion) || '</typ:idTransaccion>
             <typ:ipAplicacion>' || lc_ipAplicacion || '</typ:ipAplicacion>
             <typ:usuarioApp>' || lc_usuarioApp || '</typ:usuarioApp>
             <typ:authKey>' || lc_key_iw || '</typ:authKey>
             <typ:idEmpresaCRM>' || lc_idempresacrm || '</typ:idEmpresaCRM>
             <typ:idClienteCRM>' || lc_codcli || '</typ:idClienteCRM>
             <typ:cantRecords>1</typ:cantRecords>
             <typ:tipoAccion>' || to_char(an_tipo) || '</typ:tipoAccion>
             <typ:collectExternalInfo>TRUE</typ:collectExternalInfo>
             <typ:showDocsis>TRUE</typ:showDocsis>
             <typ:showPacketCable>TRUE</typ:showPacketCable>
             <typ:showSIP>TRUE</typ:showSIP>
             <typ:showTelevision>TRUE</typ:showTelevision>
          </typ:CargaEquiposRequest>
       </soapenv:Body>
    </soapenv:Envelope>';
    --Inicio 18.0
  EXCEPTION
    WHEN OTHERS THEN
      lc_ESQUEMAXML:=null;
      an_CODERROR:=sqlcode;
      ac_DESCERROR:= 'XML : '||SUBSTR(SQLERRM,1,200);
  END;
  insert into OPERACION.TRS_WS_SGA(IDTRANSACCION, TIPOACCION, ID_CLIENTE, CODSOLOT,
              ESQUEMAXML,codigoerror,mensajeError)
  values(n_idtransaccion, an_tipo, lc_codcli, an_codsolot, lc_ESQUEMAXML,
              n_CODERROR, ac_DESCERROR);
  --fin 24.0
  commit;

  IF  lc_ESQUEMAXML is not null THEN
    begin
      lc_RESPUESTAXML := F_CALL_WEBSERVICE(lc_ESQUEMAXML, lc_target_url);
    exception
      when OTHERS then
       an_CODERROR:=sqlcode;
       ac_DESCERROR:= 'F_CALL_WS : '||SUBSTR(SQLERRM,1,200);
       raise_application_error(-20001, ac_DESCERROR);
       update OPERACION.TRS_WS_SGA set codigoerror = an_CODERROR,
       MENSAJEERROR= ac_DESCERROR,RESPUESTAXML= substr(lc_RESPUESTAXML,1,4000),fecmod=sysdate
       where IDTRANSACCION=n_idtransaccion;
     --P_INF_IW_SGA(an_codsolot ,ac_codcli,an_tipo,n_coderror,v_deserror);
    end;
    --Fin 18.0
    update OPERACION.TRS_WS_SGA set RESPUESTAXML= substr(lc_RESPUESTAXML,1,4000)--,ESQUEMAXML= substr(lc_ESQUEMAXML,1,4000), --18.0
    where idtransaccion=n_idtransaccion;--15.0
    update OPERACION.OPE_EQU_IW set codsolot= an_codsolot
    where idtransaccion=n_idtransaccion;

    operacion.P_GET_PUNTO_PRINC_SOLOT(an_codsolot,l_punto,l_punto_ori,l_punto_des);
    --Inicio 20.0
    begin
      select IDAGENDA into ln_idagenda from AGENDAMIENTO A, OPEDD B, TIPOPEDD C
      WHERE A.codsolot= an_codsolot AND A.tipo= B.codigoc AND
      B.TIPOPEDD =C.TIPOPEDD AND C.ABREV='TIPOAGENDAEQUIPOS';
    exception
      when no_data_found then
        select max(idagenda) into ln_idagenda
        from agendamiento where codsolot = an_codsolot;
    end;
    --Fin 20.0

    if an_tipo=1 then--Carga de Equipos
      for c_e in c_eq loop
        begin  --24.0
          v_obs:='Carga Equipos desde IW.';
          SELECT NVL(MAX(ORDEN), 0) + 1  INTO l_orden
          from solotptoequ
          where codsolot = an_codsolot and punto = l_punto and rownum=1;
          --Inicio 10.0
          begin
            select a.codigon_aux into l_tipo
            from opedd a, tipopedd b, solot c
            where a.tipopedd=b.tipopedd and c.codsolot=an_codsolot
            and b.abrev='REDEEQUSGAIW' and a.codigon= c.tiptra;
          exception
            when no_data_found then
            l_tipo:=1;
          end;
          n_enacta:=0;--19.0
          --      if l_tipo = 1 or l_tipo = 3 then --Altas y Bajas  20.0
          if l_tipo = 1 then --Altas y Bajas
            if l_tipo = 1 then --Altas
              select count(1) into l_cont_equipos --Validar si el equipo esta registrado Instalaciones
              from solotptoequ a, solot b
              where a.codsolot=b.codsolot and b.codcli=ac_codcli
              and trim(a.numserie) = c_e.serialnumber;
            elsif l_tipo=3 then --Bajas
              n_enacta:=1;--19.0
              select count(1) into l_cont_equipos --Validar si el equipo esta registrado en la SOT de Baja
              from solotptoequ a
              where trim(a.numserie) = c_e.serialnumber and a.codsolot=an_codsolot;
            end if;
            --Fin 10.0
            if l_cont_equipos = 0 then
              n_valida:=0;
              if (c_e.serialnumber is null and c_e.macaddress is null) or (c_e.serialnumber='N/A' and c_e.macaddress is null) then
                 n_valida:=-1;
              end if;
              if n_valida=0 then
                v_cod_sap:=c_e.cod_sap;
                if v_cod_sap='-' then
                  begin
                    select b.cod_sap into v_cod_sap
                    from Maestro_Series_Equ b
                    where (( c_e.serialnumber like '%' || b.nroserie   and length(b.nroserie)> 12 )
                    or (c_e.serialnumber like  b.nroserie || '%'   and length(b.nroserie)> 12 )
                    or (trim(upper(replace(replace(c_e.macaddress, ':', ''), '.', ''))) = b.mac1  ) )
                    and rownum=1;
                    if not v_cod_sap is null and not v_cod_sap='-' then--Si existe el codigo sap
                      select b.nroserie into v_numserie
                      from Maestro_Series_Equ b
                      where (( c_e.serialnumber like '%' || b.nroserie   and length(b.nroserie)> 12 )
                      or (c_e.serialnumber like  b.nroserie || '%'   and length(b.nroserie)> 12 )
                      or (trim(upper(replace(replace(c_e.macaddress, ':', ''), '.', ''))) = b.mac1  ) )
                      and rownum=1;
                    end if;
                  exception
                    when no_Data_found then
                      n_tipequ := 999;
                      v_obs:=v_obs ||'Equipo no se identifica en la BD.';
                      n_codeta:=647;
                  end;
                  v_obs:=v_obs ||'Equipo cargado con Serie incompleta.';
                end if;
                begin
                  select c1.tipequ , ( select a2.codeta
                    from matetapaxfor a2, tiptrabajoxfor b2,solot c2
                    where a2.codfor=b2.codfor and b2.tiptra=c2.tiptra
                    and c2.codsolot= an_codsolot and a2.codmat= b1.codmat
                    and rownum=1) codeta, c1.costo--17.0
                  into n_tipequ, n_codeta,n_costo--17.0
                  from almtabmat b1, tipequ c1
                  where  b1.codmat=c1.codtipequ(+)
                  and trim( b1.cod_sap)= v_cod_sap and rownum=1;
                exception
                  when NO_DATA_FOUND then
                    n_tipequ:=999;
                    n_codeta:=647;
                  when others then
                    an_CODERROR:=-1;
                    ac_DESCERROR:= 'Tipequ : '||SUBSTR(SQLERRM,1,200);
                end;
                if n_codeta is null then--14.0
                   n_codeta:= 647;
                end if;
                n_tipequ := nvl(n_tipequ,999);
                insert into solotptoequ(codsolot,punto,orden,tipequ,CANTIDAD,TIPPRP,
                COSTO,NUMSERIE,flgsol,flgreq,codeta,tran_solmat,observacion,fecfdis,
                instalado,idagenda,fecins,flg_ingreso,mac,ESTADOEQU,enacta)--19.0
                values(an_codsolot,l_punto,l_orden,n_tipequ,1,0,nvl(n_costo,0),--18.0
                nvl(v_numserie,c_e.serialnumber),1,0,n_codeta,null,v_obs,Sysdate,1,
                ln_idagenda,sysdate,3, c_e.macaddress,1,n_enacta);--19.0
                v_numserie:=null;
              end if;
            end if;--20.0
          end if;
          update  OPERACION.OPE_EQU_IW set estado=1 where id_Seq=c_e.id_Seq;--10.0
        --ini 24.0
        exception
          when others then
            v_error := sqlerrm;
            update OPERACION.OPE_EQU_IW set error = nvl(error,'')||chr(13)||v_error
            where id_Seq=c_e.id_Seq;  --24.0
        end;
        --fin 24.0
      end loop;
      commit;--12.0
    elsif an_tipo=4 then
      for c_e in c_eq3 loop
        v_obs:='Carga Equipos desde IW.';
        SELECT NVL(MAX(ORDEN), 0) + 1  INTO l_orden
        from solotptoequ
        where codsolot = an_codsolot and punto = l_punto and rownum=1;
        n_valida:=0;
        if (c_e.serialnumber is null and c_e.macaddress is null) or (c_e.serialnumber='N/A' and c_e.macaddress is null) then
          n_valida:=-1;
        end if;
        if n_valida=0 then
          v_cod_sap:=c_e.cod_sap;
          if v_cod_sap='-' then
            begin
              select b.cod_sap into v_cod_sap
              from Maestro_Series_Equ b
              where (( c_e.serialnumber like '%' || b.nroserie   and length(b.nroserie)> 12 )
              or (c_e.serialnumber like  b.nroserie || '%'   and length(b.nroserie)> 12 )
              or (trim(upper(replace(replace(c_e.macaddress, ':', ''), '.', ''))) = b.mac1  ) )
              and rownum=1;
              if not v_cod_sap is null and not v_cod_sap='-' then--Si existe el codigo sap
                select b.nroserie into v_numserie
                from Maestro_Series_Equ b
                where (( c_e.serialnumber like '%' || b.nroserie   and length(b.nroserie)> 12 )
                or (c_e.serialnumber like  b.nroserie || '%'   and length(b.nroserie)> 12 )
                or (trim(upper(replace(replace(c_e.macaddress, ':', ''), '.', ''))) = b.mac1  ) )
                and rownum=1;
              end if;
            exception
               when no_Data_found then
               n_tipequ := 999;
               v_obs:=v_obs ||'Equipo no se identifica en la BD.';
               n_codeta:=647;
            end;
            v_obs:=v_obs ||'Equipo cargado con Serie incompleta.';
          end if;
          begin
            select c1.tipequ , ( select a2.codeta
            from matetapaxfor a2, tiptrabajoxfor b2,solot c2
            where a2.codfor=b2.codfor and b2.tiptra=c2.tiptra
            and c2.codsolot= an_codsolot and a2.codmat= b1.codmat and rownum=1) codeta,
            c1.costo
            into n_tipequ, n_codeta,n_costo
            from almtabmat b1, tipequ c1
            where  b1.codmat=c1.codtipequ(+)
            and trim( b1.cod_sap)= v_cod_sap and rownum=1;
          exception
            when others then
            an_CODERROR:=-1;
            ac_DESCERROR:= 'Tipequ : '||SUBSTR(SQLERRM,1,200);
          end;
          if n_codeta is null then--14.0
             n_codeta:= 647;
          end if;
          n_tipequ := nvl(n_tipequ,999);
          --18.0 Inicio
          if c_e.estado=2 then
            n_enacta:=1;
          else
            n_enacta:=0;
          end if;
          begin
            select a.codigon_aux into n_estadoequ
            from opedd a, tipopedd b, solot c
            where a.tipopedd=b.tipopedd and c.codsolot=an_codsolot
            and b.abrev='ESTEQUTIPTRA' and a.codigon= c.tiptra
            and a.codigoc=n_enacta and rownum=1;
          exception
            when no_data_found then
            n_estadoequ:=1;
          end;
          --18.0 Fin
          --19.0 Inicio
          select count(1) into n_contequ from solotptoequ
          where codsolot=an_codsolot and numserie=c_e.serialnumber;
          if n_contequ = 0 then
            insert into solotptoequ(codsolot,punto,orden,tipequ,CANTIDAD,TIPPRP,
            COSTO,NUMSERIE,flgsol,flgreq,codeta,tran_solmat,observacion,fecfdis,
            instalado,idagenda,fecins,flg_ingreso,mac,ESTADOEQU,enacta)--18.0
            values(an_codsolot,l_punto,l_orden,n_tipequ,1,0,nvl(n_costo,0),--18.0
            nvl(v_numserie,c_e.serialnumber),1,0,n_codeta,null,v_obs,Sysdate,1,
            ln_idagenda,sysdate,c_e.estado,c_e.macaddress,n_estadoequ,n_enacta);--18.0
          end if;
          --19.0 Fin
          v_numserie:=null;
        end if;
      end loop;
    end if;
  else
    raise exc_control_iw;     --24.0
  end if;

  EXCEPTION
    WHEN exc_control_iw THEN  --24.0
      goto go_exp;            --24.0

    WHEN OTHERS THEN
      <<go_exp>>              --24.0
      an_CODERROR:=sqlcode;   --14.0
      ac_DESCERROR:= 'PQ_IW_OPE : '||SUBSTR(SQLERRM,1,200);

      update OPERACION.TRS_WS_SGA set codigoerror = an_CODERROR,
      MENSAJEERROR= ac_DESCERROR
      where IDTRANSACCION=n_idtransaccion;
      COMMIT;--14.0
END P_INF_IW_SGA;

FUNCTION F_CALL_WEBSERVICE(ac_payload in varchar2,ac_target_url in varchar2, ac_soap_action in varchar2 default 'process') return varchar2
  is
  lc_soap_request varchar2(30000);
  lc_soap_response varchar2(30000);
  http_req utl_http.req;
  http_resp utl_http.resp;
  begin
    lc_soap_request := ac_payload;
    http_req := utl_http.begin_request( ac_target_url, 'POST', 'HTTP/1.1');
    utl_http.set_header(http_req, 'Content-Type', 'text/xml');
    utl_http.set_header(http_req, 'Content-Length', length(lc_soap_request));
    utl_http.write_text(http_req, lc_soap_request);
    http_resp:= utl_http.get_response(http_req);
    utl_http.read_text(http_resp, lc_soap_response);
    utl_http.end_response(http_resp);
    return lc_soap_response;
    EXCEPTION
    WHEN UTL_HTTP.end_of_body THEN
      UTL_HTTP.end_response(http_resp);
    WHEN OTHERS THEN
     UTL_HTTP.end_response(http_resp);
  end F_CALL_WEBSERVICE;

PROCEDURE p_inf_iw_sga_tarea(a_idtareawf in number,
                                      a_idwf      in number,
                                      a_tarea     in number,
                                      a_tareadef  in number) IS
    v_codcli varchar2(10);
    n_codsolot number;
    n_coderror number;
    v_deserror varchar2(400);
    n_tipo number;--15.0
  BEGIN
    select codsolot into n_codsolot from wf where idwf= a_idwf;
    select codcli into v_codcli from solot where codsolot = n_codsolot;
    --Inicio 15.0
    BEGIN
      select a.codigon into n_tipo from opedd a, tipopedd b
      where a.tipopedd=b.tipopedd
      and b.abrev='IWSGATIPOACCION'
      and a.codigon_aux= a_tarea;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        n_tipo:=1;
    END;
    --Fin 15.0
    begin
       P_INF_IW_SGA(n_codsolot,v_codcli,n_tipo,n_coderror,v_deserror);--15.0
    exception
    when others then
      raise_application_error(-20001,v_deserror);
    end;
  end;
--Fin 4.0

--Inicio 5.0
  function f_cadena(ac_cadena in varchar2,an_caracter in varchar2, an_posicion in number)
    return varchar2 is
  ls_original  varchar2(4000);
  ls_subcadena varchar2(4000);
  li_longitud number;
  j           number;
  p           number;
  li_cont          number;
  li_size_caracter number;
  n_pos number;
  begin
     ls_original := ac_cadena;
     p           := an_posicion;
     j           := 1;
     n_pos :=0;
     li_size_caracter := length(an_caracter);
     li_longitud := length(ls_original);
     FOR li_cont IN 1..li_longitud LOOP
         IF (substr(ls_original,li_cont,li_size_caracter)<> an_caracter) THEN
            IF j = p THEN
              if n_pos=0 then
                ls_subcadena := substr(ls_original,1,li_cont);
              else
                ls_subcadena := substr(ls_original,n_pos + li_size_caracter,li_cont-n_pos+1-li_size_caracter);
              end if;
            END IF;
         ELSE
            n_pos:=li_cont;
            j := j +1;
         END IF;
     END LOOP;
     return ls_subcadena;
  end;
--Fin 5.0
  --Ini 11.0
  procedure p_iw_baja_total_envio(a_idtareawf in number,
                                  a_idwf      in number,
                                  a_tarea     in number,
                                  a_tareadef  in number) is

  ln_codsolot      solot.codsolot%type;
  ls_mensaje       varchar2(4000);
  ln_error         number;

  Begin
     select wf.codsolot
     into ln_codsolot
     from wf, solot
     where wf.codsolot = solot.codsolot
       and idwf = a_idwf;
     --Baja total
     intraway.p_int_baja_total(ln_codsolot,0, ls_mensaje, ln_error);
     --Realiza int_envio
     OPERACION.PQ_CUSPE_OPE2.p_int_iw_solot_anuladas(ln_codsolot);
  Exception
  WHEN others then
      null;
  End;
  --Fin 11.0

function f_sot_desde_sisact(an_codsolot operacion.solot.codsolot%TYPE,an_codigo number default 0)
    return number is
    l_codsolot operacion.solot.codsolot%TYPE;
  begin
    SELECT t.idinstancia
      INTO l_codsolot
      FROM sales.int_negocio_instancia t
     WHERE t.idinstancia = an_codsolot
       AND t.instancia = 'SOT';
    RETURN 1;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN 0;
  end;

END PQ_IW_OPE;

/
