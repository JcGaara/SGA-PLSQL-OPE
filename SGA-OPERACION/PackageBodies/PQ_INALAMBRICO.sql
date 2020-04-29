CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_INALAMBRICO IS
 /********************************************************************************
     NOMBRE:       PQ_INALAMBRICO
     PROPOSITO:

     REVISIONES:
     Ver        Fecha        Autor           Solicitado por Descripcion
     ---------  ----------  ---------------  --------------  ----------------------

      1.0       01/02/2010  Antonio Lagos                    REQ 106908, DTH + CDMA
      2.0       24/03/2010  Antonio Lagos                    REQ 119998, DTH + CDMA, recarga y reconexion
      3.0       22/02/2010  Antonio Lagos    Juan Gallegos   REQ 126937, DTH + CDMA, nuevo campo configurable de
                                                             valor de recarga enviada a OCS
      4.0       16/06/2010  Antonio Lagos    Juan Gallegos   REQ 119999, DTH + CDMA, baja y corte
      5.0       28/05/2010  Vicky Sánchez    Juan Gallegos   Se cambia la forma de obtener el idrecarga en la funcion f_obtener_idrecarga
                                                             y en el proc. p_pos_actualizar recarga se agregó logica para insertar tablas intermedias con INT
      6.0       16/09/2010  Antonio Lagos    Juan Gallegos   REQ.142338, Migracion DTH
      7.0       30/09/2010  Antonio Lagos    Jose Ramos      REQ.144641 correccion en carga de actividades en baja
      8.0       01/10/2010  Joseph Asencios  Juan Gallegos   REQ Migración CDMA
      9.0       05/10/2010  Antonio Lagos    Jose Ramos      REQ.145222 alta baja DTH
      10.0      12/10/2010  Joseph Asencios  Jose Ramos      REQ 145745: Se modifica proc. p_pos_actualizar_recarga para eliminar registro
                                                             de la tabla reginsdth_web cuando se realice una baja.
      11.0      18/10/2010  Joseph Asencios  Manuel Gallegos REQ-145961: Se modificó el proc p_pos_actualizar_recarga
                                                             para actualizar la SOT al estado Atendida.
      12.0      15/10/2010  Alfonso Perez    Yuri Lingán     Se aplica promociones de canales adicionales y fecha de vigencia <Proyecto DTH Venta Nueva>
                                                             REQ 140740
      13.0      26/10/2010  Joseph Asencios  Manuel Gallegos REQ-136578: Creación de función f_obt_tipo_srv_rec que determina si un servicio es DTH/CDMA/BUMDLE
      14.0      15/10/2010  Yuri Lingán      José Ramos      Se migra la tabla bouquetxreginsdth a rec_bouquetxreginsdth_cab
                                                             REQ 148666
      15.0      23/12/2010  Alfonso Pérez    José Ramos      REQ 152200 Error en el caculo de las fechas de vigencia cuando tiene un corte en proceso
      16.0      11/01/2011  Alfonso Pérez    José Ramos      REQ 158549 retornar a la version 14.0
      17.0      17/03/2011  Ronal C.         Melvin Balcazar Proyecto Suma de Cargos
                                                             p_pos_actualizar_recarga() se agrega PQ_PAQUETE_RECARGA.P_INS_SERVICIO(), campos IDGRUPO y PID
      18.0      19/09/2011  Ivan Untiveros   Guillermo Salcedo  REQ-161004 Sincronizacion WEBUNI : FR-10
      19.0      20/12/2011  Carlos Lazarte   Edilberto Astulle  RQM 160993: PQT-40103-TSK-2475 PROY-1508 CIERRE MASIVO DE BAJAS DTH
      20.0      07/11/2011  Widmer Quispe                      Sincronización 11/05/2012 -  REQ 161199 - DTH Post Venta Sincronizacion
      21.0      11/11/2011  Mauro Zegarra   Guillermo Salcedo  Sincronización 11/05/2012 -  REQ-161199 RF-07
      22.0      14/08/2012  Mauro Zegarra   Hector Huaman     SD-243176: Mejoras DTH Postpago
      23.0      12/11/2012  Cristiam Vega   Hector Huaman     Proy - 5731 Se modifico para invocar el web service de envio a BSCS, y actualizacion de las serie de trajetas y decos en sisact
      24.0      27/11/2012  Hector Huaman                      SD-368769 Mejoras DTH Postpago
      25.0      27/11/2012  Hector Huaman                      SD-385969 Mejoras DTH Postpago
      26.0      14/03/2013  Juan C. Ortiz    Hector Huaman     Req 163947 - Diferencia archivos de señal DTH (SGA)
      27.0      15/04/2013  Dorian Sucasaca Francisco Lucar   Req-164175: Activación y desactivación de Servicios DTH
      28.0      25/06/2013  Fernando Pacheco Hector Huaman    REQ-164289 Mejora activaciones DTH - SGA - BSCS
      29.0      28/08/2013  Hector Huaman                     SD-744299 Problemas para Consultas de Tarjetas
      30.0      01/09/2014  Angel Condori    Manuel Gallegos  PROY-12688:Ventas Convergentes
      31.0      01/10/2014  Michael Boza     Alicia Peña    Req: PROY-14342-IDEA-12729
      32.0      30/09/2015  Emma Guzman          PROY-20152
      33.0      30/11/2015  Dorian Sucasaca                   PQT-247649-TSK-76965
      34.0      30/05/2016  Luis Polo B.     Karen Vasquez    SGA-SD-794552
      35.0      01/07/2017  Luis Guzman      Tito Huera       PROY-27792 IDEA-34954 - Proyecto LTE
      36.0      01/06/2018  Marleny Teque/   Justiniano Condori PROY-32581-Postventa LTE/HFC
                            Jose Antonio
      37.0      26/07/2018  Marleny Teque/   Justiniano Condori PROY-32581-Postventa LTE/HFC
    38.0      05/09/2018  Marleny Teque/   Justiniano Condori PROY-32581-Postventa LTE/HFC
    39.0      10/09/2018  Marleny Teque/   Justiniano Condori PROY-32581-Postventa LTE/HFC
    40.0      05/12/2018  Marleny Teque    Luis Flores        PROY-32581-Postventa LTE/HFC
      41.0      04/02/2019  Abel Ojeda       Luis Flores        PROY-32581-Postventa LTE/HFC
      42.0      11/02/2019  Luis Flores      Luis Flores        PROY-32581-Postventa LTE/HFC - Cambio de Plan LTE
      43.0      14/03/2019  Edwin Vasquez    Catherine Aquino   PROY-29215_IDEA-30265 Costo de Instalación para LTE en SISACT
      44.0      22/10/2019  Jose Varillas    Luis Flores        INC
  *********************************************************************/
--se carga informacion para bundle DTH y CDMA
PROCEDURE p_cargar_datos_inalambrico(a_idtareawf IN NUMBER,
                                a_idwf      IN NUMBER,
                                a_tarea     IN NUMBER,
                                a_tareadef  IN NUMBER)

  --  Cuando se ingresa a Opciones por Tarea, en caso haya 0 registros, se inserta un registro en
  --  la tabla sales.vtatabpreope.

 IS
ln_codsolot solot.codsolot%type;
ls_numslc vtatabslcfac.numslc%type;
ls_codcli vtatabcli.codcli%type;
--ini 6.0
ln_num_reg number;
--fin 6.0
BEGIN

    SELECT codsolot INTO ln_codsolot FROM wf WHERE idwf = a_idwf;
  --ini 6.0
  /*  select numslc, codcli
      into ls_numslc, ls_codcli
      from solot
  where codsolot = ln_codsolot;


  insert into vtatabpreope
    (numslc, codcli, codsolot, flg_recarga)
  values
    (ls_numslc, ls_codcli, ln_codsolot, 1);*/

  select count(1) into ln_num_reg
  from ope_srv_recarga_cab
  where codsolot = ln_codsolot;

  if ln_num_reg = 0 then
  --fin 6.0
     p_cargar_recarga(ln_codsolot);
  --ini 6.0
  end if;
  --fin 6.0
exception
  when others then
      raise_application_error(-20500,
                              'Error cargar datos inalambrico.' + sqlerrm);
END;

PROCEDURE p_cerrar_datos_inalambrico(a_idtareawf IN NUMBER,
                                a_idwf      IN NUMBER,
                                a_tarea     IN NUMBER,
                                       a_tareadef  IN NUMBER) IS
ln_codsolot solot.codsolot%type;
--ini 6.0
--lr_datos vtatabpreope%rowtype;
lr_datos ope_srv_recarga_cab%rowtype;
--fin 6.0
BEGIN

    SELECT codsolot INTO ln_codsolot FROM wf WHERE idwf = a_idwf;

  begin
    --ini 6.0
    /*select *
    into lr_datos
    from vtatabpreope
    where codsolot = ln_codsolot;*/
    select * into lr_datos
    from ope_srv_recarga_cab where codsolot = ln_codsolot;
    --fin 6.0
  exception
    when others then
        raise_application_error(-20500,
                                'Error en validacion de datos inalambrico.');
  end;

  --<4.0
  /*if lr_datos.codcon is null or lr_datos.codcon = '' then
      raise_application_error(-20500,
                              'Debe completar informacion del contratista.');
    end if;*/
    --4.0>

    --<4.0
    /*if lr_datos.codinstalador is null or lr_datos.codinstalador = '' then
      raise_application_error(-20500,
                              'Debe completar informacion del instalador.');
  end if;*/
  --4.0>

  --<4.0
  /*if lr_datos.codsuc is null or lr_datos.codsuc = '' then
      raise_application_error(-20500,
                              'Debe completar informacion de la sucursal de instalacion.');
  end if;*/
  --4.0>

  if lr_datos.flg_recarga = 1 and lr_datos.codigo_recarga is null then
     raise_application_error(-20500,'Debe generar un codigo de recarga.');
  end if;
END;

  --este proc. ya no deberia usarse, se reemplaza por equipos configurados en formula para masivo
  procedure p_cargar_equ_dth(a_idtareawf in number,
                             a_idwf      in number,
                             a_tarea     in number,
                             a_tareadef  in number) is

ln_idpaq paquete_venta.idpaq%type;
ln_orden       number;
ln_punto       number;
ln_codsolot    solot.codsolot%type;
ls_tipsrv      tystipsrv.tipsrv%type;
ln_punto_ori   number;
ln_punto_des   number;
v_observacion  varchar2(200);
    --l_estado      solotptoequ.estado%type;--4.0
ls_numslc      vtatabslcfac.numslc%type;
--<4.0
ln_tiptrs tiptrabajo.tiptrs%type;
ln_codsolot_ori solot.codsolot%type;
--ls_numregistro recargaproyectocliente.numregistro%type;
ls_numregistro ope_srv_recarga_cab.numregistro%type;
ln_estado number;
    --ls_error       varchar2(1000);
--4.0>
--equipos en venta inicial
cursor cur_equ is
select  a.idpaq,
        a.codequcom,
        equ.tipequ tipequope,
             (select max(cantidad)
                from linea_paquete
               where iddet = a.iddet
                 and codequcom = a.codequcom) cantidad,
        equ.costo,
        --ini 6.0
        /*     (SELECT count(1)
                FROM OPEDD
               WHERE TIPOPEDD = 201
                 AND ABREVIACION = 'DTH'
         and trim(codigoc) = trim(m.cod_sap)) Seriable,*/
         (SELECT count(1)
                FROM opedd a,tipopedd b
               WHERE a.tipopedd = b.tipopedd
                 and b.abrev = 'TIPEQU_DTH_CONAX'
         and trim(codigon) = equ.tipequ) Equipo,
         m.Preprm_Usd,
             (SELECT count(1)
                FROM opedd a,tipopedd b
               WHERE a.tipopedd = b.tipopedd
                 and b.abrev = 'RECUMASIVO'
                 and a.abreviacion = 'DTH'
         and trim(codigoc) = trim(m.cod_sap)) Recuperable,
         --fin 6.0
             (select codigon
                from opedd
               where tipopedd = 197
                 and trim(codigoc) = trim(m.cod_sap)) codeta
                 --ini 21.0
                 , a.iddet
                 --fin 21.0
        from vtadetptoenl a,
             vtadetptoenl b,
             tystabsrv    c,
             equcomxope   ep,
             --ini 6.0
             --TIPEQUDTH    te,
             --fin 6.0
             tipequ       equ,
             almtabmat    m
where a.codequcom is not null
and a.codequcom=ep.codequcom
--ini 6.0
--and a.codequcom = te.codequcom(+)
--fin 6.0
and a.numslc = ls_numslc
and a.numslc = b.numslc
and a.numpto_prin = b.numpto
and b.codsrv = c.codsrv
and c.tipsrv = ls_tipsrv
and ep.codtipequ = equ.codtipequ
and equ.codtipequ = m.codmat
order by equ.codtipequ;

--<4.0
--equipos DTH de la SOT de instalacion
--ini 6.0
/*cursor cur_equ_sot_ins is
select se.*
        from solotptoequ se,
             solot       s,
             solotpto    sp,
             inssrv      i,
             tipequ      t,
             almtabmat   a,
             tipequdth   td
        where  se.codsolot  = s.codsolot
        and    s.codsolot   = sp.codsolot
        and    se.punto     = sp.punto
        and    sp.codinssrv = i.codinssrv
        and    t.tipequ     = se.tipequ
        and    a.codmat     = t.codtipequ
        and    td.codequcom = se.codequcom
        and    se.codsolot  = ln_codsolot_ori
        and    td.grupoequ in (1,2);*/
--fin 6.0
--4.0>
--ini 6.0
cursor cur_actividad_alta(ac_tipo varchar2) is
select a.codact, 1 cantidad, a.codeta, b.costo,b.moneda_id,b.codprec
from (SELECT to_number(codigoc) codact,codigon codeta
      FROM opedd a,tipopedd b
      WHERE a.tipopedd = b.tipopedd
       and b.abrev = 'ACTMASIVOALTA'
       and a.abreviacion = ac_tipo) a,
     actxpreciario b
 where a.codact = b.codact and b.activo = '1';

cursor cur_actividad_baja(ac_tipo varchar2) is
select a.codact, 1 cantidad, a.codeta, b.costo,b.moneda_id,b.codprec
from (SELECT to_number(codigoc) codact,codigon codeta
      FROM opedd a,tipopedd b
      WHERE a.tipopedd = b.tipopedd
       and b.abrev = 'ACTMASIVOBAJA'
       and a.abreviacion = ac_tipo) a,
     actxpreciario b
 where a.codact = b.codact and b.activo = '1';

ln_idagenda agendamiento.idagenda%type;
ln_cantidad solotptoequ.cantidad%type;
ln_tipprp solotptoequ.tipprp%type;
ln_costo solotptoequ.costo%type;
ln_flgreq solotptoequ.flgreq%type;
ln_num_tarjeta number;
lc_tipo opedd.abreviacion%type;
ln_codeta number;
ln_cont_etapa number;
ln_codcon agendamiento.codcon%type;
lc_observacion varchar2(500);
exception_carga exception;
ln_tipo_tarea tareawfcpy.tipo%type; --0:normal,1:opcional, 2:automatica
ln_tipo_error number; --0:mensaje error, 1:cambia a estado "con errores"
ln_num_error number;
ls_tipesttar esttarea.tipesttar%type;
ln_flgingreso number;
ln_num_equipos number;
--fin 6.0
begin
  select codsolot into ln_codsolot from wf where idwf = a_idwf;
  --<4.0
  --se averigua tipo de transaccion
    select b.tiptrs
      into ln_tiptrs
  from solot a,tiptrabajo b
  where a.tiptra = b.tiptra
  and codsolot = ln_codsolot;

  --ini 6.0
  select max(idagenda) into ln_idagenda
  from agendamiento
  where codsolot = ln_codsolot;

  if ln_idagenda is null then
    --raise_application_error(-20500,'No tiene agenda, por favor genere la agenda.');
    lc_observacion := 'No tiene agenda, por favor genere la agenda.';
    raise exception_carga;
  end if;

  select codcon into ln_codcon from agendamiento where idagenda = ln_idagenda;
  if ln_codcon is null then
    --raise_application_error(-20500,'No tiene agenda, por favor genere la agenda.');
    lc_observacion := 'Agenda no tiene contratista, por favor asignar.';
    raise exception_carga;
  end if;
  --fin 6.0

  if ln_tiptrs = 1 then
    --solo se insertan registros si es instalacion
  --4.0>

    select numslc into ls_numslc from solot where codsolot = ln_codsolot;
    select distinct a.idpaq
      into ln_idpaq
      from vtadetptoenl a, solot b
     where a.numslc = b.numslc
       and b.codsolot = ln_codsolot;

      select valor
        into ls_tipsrv
        from constante
       where constante = 'FAM_CABLE';

    operacion.P_GET_PUNTO_PRINC_SOLOT(ln_codsolot,
                                        ln_punto,
                                        ln_punto_ori,
                                        ln_punto_des,
                                        ls_tipsrv);
    --ini 6.0
    select count(1) into ln_num_equipos
    from solotptoequ
    where codsolot = ln_codsolot;
    --si ya tiene equipos cargados no se inserta
    if ln_num_equipos = 0 then
    --fin 6.0
      --carga de equipos
      for c_e in cur_equ loop

          SELECT NVL(MAX(ORDEN), 0) + 1
          INTO ln_orden
          from solotptoequ
          where codsolot = ln_codsolot
          and punto = ln_punto;

          if c_e.codeta > 0 then
            --ini 6.0
            --if c_e.seriable = 1 then
            if c_e.equipo >= 1 then
            --fin 6.0
                v_observacion := 'ITTELMEX-EQU-DTH';
                ln_costo := nvl(c_e.costo,0);
                ln_tipprp := 0;
                ln_cantidad := 1;
                ln_flgreq := 0;
                ln_flgingreso := 1;
            else
              --MATERIALES son NO Seriables
                v_observacion := 'ITTELMEX-MAT-DTH';
                ln_costo := nvl(c_e.Preprm_Usd,0);
                ln_tipprp := 0;
                ln_cantidad := c_e.cantidad;
                ln_flgreq := 0;
                ln_flgingreso := 2;
            end if;

            insert into solotptoequ
              (codsolot,
                       punto,
                       orden,
                       tipequ,
                       CANTIDAD,
                       TIPPRP,
                       COSTO,
                       flgsol,
                       flgreq,
                       codeta,
                       tran_solmat,
                       observacion,
                       fecfdis,
                       --ini 6.0
                       instalado,
                       flg_ingreso,
                       flginv,
                       idagenda,
                       fecins,
                       recuperable,
                       estado,
                       --fin 6.0
                       codequcom
                       --ini 21.0
                       , iddet
                       --fin 21.0
                       )
            values
              (ln_codsolot,
                       ln_punto,
                       ln_orden,
                       c_e.tipequope,
                       --ini 6.0
                       --c_e.cantidad,
                       ln_cantidad,--cantidad
                       --0,
                       ln_tipprp,--tipprp
                       --nvl(c_e.Costo,0),
                       ln_costo, --costo
                       --fin 6.0
                       1,
                       --ini 6.0
                       --0,
                       ln_flgreq,--flgreq
                       --fin 6.0
                       c_e.codeta,
                       null,--transol mat
                       v_observacion , --observacion
                       sysdate,
                       --ini 6.0
                       1, --instalado
                       ln_flgingreso,--flg ingreso
                       1,--flg inv
                       ln_idagenda,--agenda
                       sysdate,
                       c_e.recuperable,
                       4,
                       --fin 6.0
                       c_e.codequcom
                       --ini 21.0
                       , c_e.iddet
                       --fin 21.0
                       );
         end if;
      end loop;
    --ini 6.0
    else
      --se actualiza con agenda
      update solotptoequ
      set idagenda = ln_idagenda
      where codsolot = ln_codsolot;
    end if;
    --carga de actividades
     select count(1) into ln_num_tarjeta
     from solotptoequ where codsolot = ln_codsolot
     and tipequ in (select a.codigon FROM opedd a,tipopedd b
     WHERE a.tipopedd = b.tipopedd
       and b.abrev = 'TIPOEQU_TARJETA_DTH');

    if ln_num_tarjeta <= 3 then
      if ln_num_tarjeta = 0 then
        lc_observacion := 'Error en obtencion de numero de tarjetas.';
        raise exception_carga;
      elsif ln_num_tarjeta = 1 then
        lc_tipo := 'DTH-1';
      elsif ln_num_tarjeta = 2 then
        lc_tipo := 'DTH-2';
      elsif ln_num_tarjeta = 3 then
        lc_tipo := 'DTH-3';
      end if;

      for reg_actividad_alta in cur_actividad_alta(lc_tipo) loop
        ln_codeta := reg_actividad_alta.codeta;

          select count(1) into ln_cont_etapa from solotptoeta where codsolot = ln_codsolot and codeta = ln_codeta and codcon =ln_codcon;

          if ln_cont_etapa = 1 then--Existe Etapa
             select orden,punto into ln_orden,ln_punto from solotptoeta where codsolot = ln_codsolot and codeta = ln_codeta and codcon =ln_codcon;
          else        --Genera la etapa en estado 15 : Preliquidacion
            SELECT NVL(MAX(ORDEN),0) + 1 INTO ln_orden from SOLOTPTOETA
            where codsolot = ln_codsolot and punto = ln_punto;

            insert into solotptoeta(codsolot,
                                    punto,
                                    orden,
                                    codeta,
                                    porcontrata,
                                    esteta,
                                    obs,
                                    Fecdis,
                                    codcon,
                                    fecini)
                             values(ln_codsolot,
                                    ln_punto,
                                    ln_orden,
                                    ln_codeta,
                                    1,
                                    15,
                                    '',
                                    null,
                                    ln_codcon,
                                    sysdate);
          end if;

          --Inserta la Actividad en la Etapa
          insert into solotptoetaact(codsolot,
                                     punto,
                                     orden,
                                     codact,
                                     canliq,
                                     cosliq,
                                     canins,
                                     candis,
                                     cosdis,
                                     Moneda_Id,
                                     observacion,
                                     codprecdis,
                                     codprecliq,
                                     flg_preliq,
                                     contrata)
                              values(ln_codsolot,
                                     ln_punto,
                                     ln_orden,
                                     reg_actividad_alta.codact,
                                     reg_actividad_alta.cantidad,
                                     reg_actividad_alta.costo,
                                     reg_actividad_alta.cantidad,
                                     reg_actividad_alta.cantidad,
                                     reg_actividad_alta.costo,
                                     reg_actividad_alta.moneda_id,
                                     '',
                                     reg_actividad_alta.codprec,
                                     reg_actividad_alta.codprec,
                                     1,
                                     1);
      end loop;
    end if;
    --fin 6.0
  --<4.0
  elsif ln_tiptrs = 5 then

    ls_numregistro := f_obtener_numregistro(ln_codsolot);

    if ls_numregistro is not null then

        select codsolot
          into ln_codsolot_ori
          from ope_srv_recarga_cab
      where numregistro = ls_numregistro;

        select valor
          into ls_tipsrv
          from constante
         where constante = 'FAM_CABLE';

      --ini 6.0
      --ini 7.0
      --operacion.P_GET_PUNTO_PRINC_SOLOT(ln_codsolot_ori,
      operacion.P_GET_PUNTO_PRINC_SOLOT(ln_codsolot,
      --fin 7.0
                                        ln_punto,
                                        ln_punto_ori,
                                        ln_punto_des,
                                        ls_tipsrv);
      --fin 7.0
      /*  select min(punto)
          into ln_punto
      from solotpto a, inssrv b
      where codsolot = ln_codsolot
      and a.codinssrv = b.codinssrv
      and b.tipsrv = ls_tipsrv;

      if ln_punto > 0 then
        ln_estado := 4;

        for c_equ_ins in  cur_equ_sot_ins loop

          SELECT NVL(MAX(ORDEN), 0) + 1
          INTO ln_orden
          from solotptoequ
          where codsolot = ln_codsolot
          and punto = ln_punto;

            insert into solotptoequ
              (codsolot,
                           punto,
                           orden,
                           tipequ,
                           CANTIDAD,
                           TIPPRP,
                           COSTO,
                           numserie,
                           flgsol,
                           flgreq,
                           codeta,
                           tran_solmat,
                           observacion,
                           fecfdis,
                           estado,
                           mac,
                           codequcom,
                           instalado)
            values
              (ln_codsolot,
                           ln_punto,
                           ln_orden,
                           c_equ_ins.tipequ,
                           c_equ_ins.cantidad,
                           0,
                           nvl(c_equ_ins.costo,0),
                           c_equ_ins.numserie,
                           1,
                           0,
                           c_equ_ins.codeta,
                           c_equ_ins.tran_solmat,
                           c_equ_ins.observacion,
                           sysdate,
                           ln_estado,
                           c_equ_ins.mac,
                           c_equ_ins.codequcom,
                           1);
        end loop;

      else
          raise_application_error(-20500,
                                  'Error en obtencion de punto de detalle al cargar equipos de DTH.');
      end if;*/

      --carga de actividades
      select count(1) into ln_num_tarjeta
      from solotptoequ where codsolot = ln_codsolot_ori
     and tipequ in (select a.codigon FROM opedd a,tipopedd b
     WHERE a.tipopedd = b.tipopedd
       and b.abrev = 'TIPOEQU_TARJETA_DTH');

      if ln_num_tarjeta <= 3 then
        if ln_num_tarjeta = 0 then
          lc_observacion := 'Error en obtencion de numero de tarjetas.';
          raise exception_carga;
        elsif ln_num_tarjeta = 1 then
          lc_tipo := 'DTH-1';
        elsif ln_num_tarjeta = 2 then
          lc_tipo := 'DTH-2';
        elsif ln_num_tarjeta = 3 then
          lc_tipo := 'DTH-3';
        end if;

        for reg_actividad_baja in cur_actividad_baja(lc_tipo) loop

          ln_codeta := reg_actividad_baja.codeta;

          select count(1) into ln_cont_etapa from solotptoeta where codsolot = ln_codsolot and codeta = ln_codeta and codcon =ln_codcon;

          if ln_cont_etapa = 1 then--Existe Etapa
             select orden,punto into ln_orden,ln_punto from solotptoeta where codsolot = ln_codsolot and codeta = ln_codeta and codcon =ln_codcon;
          else        --Genera la etapa en estado 15 : Preliquidacion
            SELECT NVL(MAX(ORDEN),0) + 1 INTO ln_orden from SOLOTPTOETA
            where codsolot = ln_codsolot and punto = ln_punto;

            insert into solotptoeta(codsolot,
                                    punto,
                                    orden,
                                    codeta,
                                    porcontrata,
                                    esteta,
                                    obs,
                                    Fecdis,
                                    codcon,
                                    fecini)
                             values(ln_codsolot,
                                    ln_punto,
                                    ln_orden,
                                    ln_codeta,
                                    1,
                                    15,
                                    '',
                                    null,
                                    ln_codcon,
                                    sysdate);
          end if;

          --Inserta la Actividad en la Etapa
          insert into solotptoetaact(codsolot,
                                     punto,
                                     orden,
                                     codact,
                                     canliq,
                                     cosliq,
                                     canins,
                                     candis,
                                     cosdis,
                                     Moneda_Id,
                                     observacion,
                                     codprecdis,
                                     codprecliq,
                                     flg_preliq,
                                     contrata)
                              values(ln_codsolot,
                                     ln_punto,
                                     ln_orden,
                                     reg_actividad_baja.codact,
                                     reg_actividad_baja.cantidad,
                                     reg_actividad_baja.costo,
                                     reg_actividad_baja.cantidad,
                                     reg_actividad_baja.cantidad,
                                     reg_actividad_baja.costo,
                                     reg_actividad_baja.moneda_id,
                                     '',
                                     reg_actividad_baja.codprec,
                                     reg_actividad_baja.codprec,
                                     1,
                                     1);
        end loop;
      end if;

    else
        lc_observacion := 'Error en obtencion de registro de instalacion al cargar equipos de DTH.';
        raise exception_carga;
        /*raise_application_error(-20500,
                                'Error en obtencion de registro de instalacion al cargar equipos de DTH.');*/
        --fin 6.0
    end if;
  end if;
  --4.0>
exception
  --ini 6.0
  when exception_carga then
    RAISE_APPLICATION_ERROR(-20500, lc_observacion);
  when others then
    --raise_application_error(-20500,'Error en cargar equipos de DTH.');
    raise_application_error(-20500,'Error en cargar equipos de DTH.'||sqlerrm);
  --fin 6.0
end;

function f_obtener_idpaq(a_codsolot solot.codsolot%type) return number is
ln_idpaq number;
begin
 select distinct a.idpaq
    into ln_idpaq
    from inssrv a, solot b
   where a.numslc = b.numslc
     and b.codsolot = a_codsolot;

 return ln_idpaq;

exception
  -- ini 34.0
  WHEN OTHERS THEN
    BEGIN
    SELECT DISTINCT d.idpaq
      INTO ln_idpaq
      FROM operacion.solot    s,
         sales.vtatabslcfac v,
         sales.vtadetptoenl d
     WHERE s.numslc = v.numslc
       AND v.numslc = d.numslc
       AND s.codsolot = a_codsolot;
    RETURN ln_idpaq;
    EXCEPTION
    WHEN OTHERS THEN
       --36.0 Ini
       BEGIN
       select distinct a.idpaq
       into ln_idpaq
       from inssrv a where a.codinssrv = (
       select codinssrv from solotpto
          where codsolot = a_codsolot and punto =
            (select MAX(punto) from solotpto where codsolot = a_codsolot));
       RETURN ln_idpaq;
       EXCEPTION
       WHEN OTHERS THEN
       --36.0 Fin
       raise_application_error(-20500, 'Error en obtencion de paquete.');
       END; --36.0
    END;
    -- fin 34.0
end;

  function f_obtener_numregistro(a_codsolot solot.codsolot%type)
    return varchar2 is
--ls_numregistro recargaproyectocliente.numregistro%type; --4.0
ls_numregistro ope_srv_recarga_cab.numregistro%type; --4.0
ln_num number; --2.0
begin

   --<2.0
    select count(1)
      into ln_num
   --from recargaproyectocliente --4.0
   from ope_srv_recarga_cab --4.0
   where codsolot = a_codsolot;
   if ln_num > 0 then
     --sot de instalacion
   --2.0>
       select a.numregistro
        into ls_numregistro
        --from recargaproyectocliente a, solot b --4.0
        from ope_srv_recarga_cab a, solot b --4.0
       where a.numslc = b.numslc
         and b.codsolot = a_codsolot;
   --<2.0
   else
       --sot diferente a la de instalacion
      select distinct c.numregistro
        into ls_numregistro
       --from solot a, solotpto b, recargaxinssrv c --4.0
       --ini 6.0
       --from solot a, solotpto b, ope_srv_recarga_det c --4.0
       from solot a, solotpto b, ope_srv_recarga_det c,ope_srv_recarga_cab d
       --6.0
       where a.codsolot = b.codsolot
       and a.codsolot = a_codsolot
       --ini 6.0
       and c.numregistro = d.numregistro
       and d.estado not in ('04')
       --fin 6.0
       and b.codinssrv = c.codinssrv;
   end if;
   --2.0>
   return ls_numregistro;
exception
   when others then
      return null;
end;

  function f_valida_transaccion_conax(a_codsolot solot.codsolot%type)
    return number is
    --0 no hay registros enviados
    --1 hay registros pendientes
    --2 OK, completado
ln_num number;
    --<4.0
    --ln_estado      number;
    ls_numregistro ope_srv_recarga_cab.numregistro%type;
    ln_pendientes number;
    --ini 9.0
    --flg_verif_tec ope_envio_conax.flg_verif_tec%type;
    --fin 9.0
    ln_verif_tec number;
    --4.0>
begin
  --<4.0
  ls_numregistro := f_obtener_numregistro(a_codsolot);

 select count(1)
    into ln_num
    from reg_archivos_enviados
    where numregins = ls_numregistro;
   --ini 9.0
   select nvl(flg_verif_tec,0) into ln_verif_tec
   from ope_srv_recarga_det
   where numregistro = ls_numregistro
   and tipsrv = (select valor from constante where constante = 'FAM_CABLE');
   --fin 9.0
    /*from recargaproyectocliente a, reg_archivos_enviados b
   where a.numregistro = b.numregins
     and a.codsolot = a_codsolot;*/
    --4.0>

   if ln_num = 0 then
      --ini 9.0
      if ln_verif_tec > 0 then
         return 2; --ok, tiene verificacion tecnica
      else
      --fin 9.0
        return 0; --no hay registros enviados
      --ini 9.0
      end if;
      --fin 9.0
   else
        --<4.0
      /*begin
        select distinct b.estado into ln_estado
         from recargaproyectocliente a, reg_archivos_enviados b
       where a.numregistro = b.numregins
           and a.codsolot = a_codsolot;
       return ln_estado;
     exception
       when too_many_rows then
          return -1;
      end;*/
      select count(1)
        into ln_pendientes
        from reg_archivos_enviados
       where numregins = ls_numregistro
         and estado <> 2;

      if ln_pendientes > 0 then
        --ini 9.0
        /*select count(1) into ln_verif_tec
        from ope_envio_conax
        where codsolot = a_codsolot
        and flg_verif_tec = 1;*/
        --fin 9.0
        if ln_verif_tec > 0 then
          return 2; --ok, tiene verificacion tecnica
        else
          return 1; --ok,no hay registros pendientes
        end if;
      else
        return 2; --ok, no hay registros pendientes
      end if;
      --4.0>
   end if;
end;

PROCEDURE p_cerrar_transaccion_conax(a_idtareawf IN NUMBER,
                                a_idwf      IN NUMBER,
                                a_tarea     IN NUMBER,
                                       a_tareadef  IN NUMBER) IS
ln_codsolot solot.codsolot%type;
    ln_validacion number; --4.0
-- Ini 21.0
ln_numslc solot.numslc%type;
ln_respt number;
LN_COUNT number;
-- Fin 21.0
-- Ini 22.0
ln_num_tarjeta number;
ln_num_sisact number;
ln_act number;
-- Fin 22.0
--ini 23.0
ls_nro_contrato ope_srv_recarga_cab.nro_contrato%type;
ln_cant number;
ln_resp number;
lc_mensaje varchar2(500);
ll_result number;
ls_tarjeta_serie operacion.ope_srv_reginst_sisact.tarjeta_serie%type;
ln_pos number;
ls_tarjeta_serie_r operacion.ope_srv_reginst_sisact.tarjeta_serie%type;
ls_tarjeta_serie_d operacion.ope_srv_reginst_sisact.tarjeta_serie%type;
ls_tarjeta_serie_n operacion.ope_srv_reginst_sisact.tarjeta_serie%type;
ls_deco_serie      operacion.ope_srv_reginst_sisact.deco_serie%type;
ls_deco_serie_r operacion.ope_srv_reginst_sisact.deco_serie%type;
ls_deco_serie_d operacion.ope_srv_reginst_sisact.deco_serie%type;
ls_deco_serie_n operacion.ope_srv_reginst_sisact.deco_serie%type;
ln_cont number;
--fin 23.0
--<ini 25.0
cursor cur_act(a_codsolot  solot.codsolot%type) is
    select a.nro_serie_deco deco, a.nro_serie_tarjeta tarjeta
      from (select distinct asoc.nro_serie_deco,asoc.nro_serie_tarjeta
       from operacion.tarjeta_deco_asoc asoc,solotptoequ se,tipequ tieq
         where asoc.codsolot=se.codsolot
           and se.mac=asoc.nro_serie_deco
           and se.tipequ=tieq.tipequ
           and tieq.codtipequ IN ('021790','017903')
           and asoc.codsolot=a_codsolot) a;
-- 25.0 fin>
--ini 27.0
li_cnt_reg number;
li_cnt_env number;
--fin 27.0
-- Ini 30.0
ln_flag_cv number;
ln_resp_cierre     NUMBER;
lc_mensaje_cierre  VARCHAR2(500);
-- Fin 30.0
-- Ini 43.0
   l_cod_id       VARCHAR2(50);
   l_customer_id  VARCHAR2(50);
   ln_resp_cci    NUMBER;
   lc_mensaje_cci  VARCHAR2(3000);
   ln_activa_cci  NUMBER;
-- Fin 43.0
BEGIN
 --Ini 21.0
   /* SELECT codsolot INTO ln_codsolot FROM wf WHERE idwf = a_idwf;

    ln_validacion := f_valida_transaccion_conax(ln_codsolot); --4.0
    --if f_valida_transaccion_conax(ln_codsolot) <> 2 then --4.0
    if ln_validacion = 1 then --4.0
      raise_application_error(-20500,
                              'La transaccion no ha sido verificada existosamente.');
    --<4.0
    elsif ln_validacion = 0 then
      raise_application_error(-20500,
                              'No se han enviado archivos a Conax.');
    --4.0>
    end if;*/
  SELECT codsolot INTO ln_codsolot FROM wf WHERE idwf = a_idwf;
    select numslc into ln_numslc from SOLOT where codsolot = ln_codsolot;
    SELECT sales.pq_dth_postventa.f_obt_facturable_dth(ln_numslc) INTO ln_respt FROM DUMMY_SGACRM;

 begin
   select o.nro_contrato
     into ls_nro_contrato
     from ope_srv_recarga_cab o
    where o.numslc = ln_numslc;
  exception
    when others then
      null;
   end;

   IF ln_respt  = 1 THEN
     -- Ini 22.0
   --Se verifica que las tarjetas hayan sido ingresadas
     select count(1) into ln_num_tarjeta
     from solotptoequ where codsolot = ln_codsolot
     and numserie is not null
     and tipequ in (select a.codigon FROM opedd a,tipopedd b
     WHERE a.tipopedd = b.tipopedd
       and b.abrev = 'TIPOEQU_TARJETA_DTH');
      IF ln_num_tarjeta = 0 THEN
          raise_application_error(-20500,
                                'Proceso Fallido, falta ingresar los datos de los equipos');
      END IF;

    --Verificar si se registro en el SISACT
     select count(1) into ln_num_sisact
     from ope_srv_recarga_cab o where o.numslc=ln_numslc and o.flg_envio_sisact=0;

      IF ln_num_sisact = 0 THEN
          raise_application_error(-20500,
                                'Proceso Fallido, no se envio información al SISACT');
      END IF;

     --<24.0
   --Verificar si se envio a provisionar
     /*select count(1) into ln_act
     from ope_srv_recarga_cab o where o.numslc=ln_numslc and o.flg_envio_sisact=0
     and o.flg_envio_act is null;

      IF ln_act > 0 THEN
          raise_application_error(-20500,
                                'Proceso Fallido, no se envio solicitud de activación');
      END IF;*/--24.0>
     /*
     SELECT COUNT(1) INTO LN_COUNT
     FROM OPE_SRV_RECARGA_CAB O WHERE O.NUMSLC = ln_numslc
     AND O.FLG_ENVIO_SISACT <> 0;

    IF LN_COUNT > 0 THEN
        raise_application_error(-20500,
                              'Proceso de Envio de Informacion a SISACT fallido.');
    END IF;*/
    -- Fin 22.0

    --ini 23.0
       --Verificar si se registro en sisact, envio a conax, y se realizo la verificacion de forma existosa
       select count(1) into ln_cant
       from ope_srv_recarga_cab o where o.numslc=ln_numslc and
       (o.id_sisact is null);

       if ln_cant > 0 then

          raise_application_error(-20500,'Proceso Fallido, no se realizo el envio a conax');
       else
           select count(1) into ln_cant
           from ope_srv_recarga_cab o where o.numslc=ln_numslc and
           (o.flag_verif_conax is null or o.flag_verif_conax <> 1);

           if ln_cant > 0 then
              raise_application_error(-20500,'Proceso Fallido, no se realizo la verificacion de forma satisfactoria');
           else
                --sales.pq_dth_postventa.p_ws_activar_dth(ln_numslc,ln_codsolot,ls_nro_contrato,ln_resp,lc_mensaje,a_idtareawf); 26.0

                 --if  ln_resp = 0 then


                          select op.tarjeta_serie, op.deco_serie
                          into ls_tarjeta_serie, ls_deco_serie
                          from operacion.ope_srv_reginst_sisact op
                          where op.codsolot = ln_codsolot and
                          op.id_sisact = ( select r.id_sisact from ope_srv_recarga_cab r
                          where r.codsolot = ln_codsolot
                          and r.id_sisact is not null
                          and r.flag_verif_conax = '1');


                          /*Tarjeta*/

                          if INSTR(ls_tarjeta_serie,',') = 0 then
                               ls_tarjeta_serie_r := ls_tarjeta_serie;

                               select count(1)
                               into ln_cont
                               from solotptoequ e
                               where e.codsolot = ln_codsolot
                               --and e.tipequ in(7113,8450,11519)--Decos
                               and e.tipequ in(7242)
                               and e.numserie = ls_tarjeta_serie_r;


                               if ln_cont = 0 then
                               --<ini 25.0
                                  for c_act in cur_act(ln_codsolot)  loop

                                    update USRPVU.SISACT_AP_CONTRATO_EQUIPO@DBL_PVUDB p
                                    SET P.tarjeta_serie =c_act.tarjeta
                                    where p.tarjeta_serie=ls_tarjeta_serie_r
                                    and deco_serie=c_act.deco
                                    and p.id_contrato in(SELECT r.nro_contrato
                                    FROM ope_srv_recarga_cab r
                                    where r.codsolot = ln_codsolot
                                    and r.numslc = ln_numslc);

                                    /*UPDATE USRPVU.SISACT_AP_CONTRATO_EQUIPO@DBL_PVUDB P
                                    SET P.tarjeta_serie = ls_tarjeta_serie_r
                                    WHERE P.ID_CONTRATO in (SELECT r.nro_contrato
                                    FROM ope_srv_recarga_cab r
                                    where r.codsolot = ln_codsolot
                                    and r.numslc = ln_numslc);*/

                                  end loop;
                                  -- 25.0 fin>
                               end if;

                          else
                                ln_pos := 1;
                                while ln_pos >= 0
                                loop
                                 ls_tarjeta_serie_r := substr(ls_tarjeta_serie,1,INSTR(ls_tarjeta_serie,',')-1 );
                                 ls_tarjeta_serie_n := substr(ls_tarjeta_serie,length(ls_tarjeta_serie_r)+2);
                                 ln_pos := instr(ls_tarjeta_serie_n,',');
                                 if ln_pos = 0 or ln_pos is null then
                                   ls_tarjeta_serie := ls_tarjeta_serie_n || ',';
                                   if ls_tarjeta_serie_n is null or ls_tarjeta_serie_n = '' then
                                      ln_pos := - 1;
                                   end if;
                                 else
                                   ls_tarjeta_serie := ls_tarjeta_serie_n;
                                 end if;

                                 select count(1)
                                 into ln_cont
                                 from solotptoequ e
                                 where e.codsolot = ln_codsolot
                                 --and e.tipequ in(7113,8450,11519)--Decos
                                 and e.tipequ in(7242)
                                 and e.numserie = ls_tarjeta_serie_r;

                                 if ln_cont = 0 then

                                 --<ini 25.0
                                      for c_act in cur_act(ln_codsolot)  loop

                                        update USRPVU.SISACT_AP_CONTRATO_EQUIPO@DBL_PVUDB p
                                        SET P.tarjeta_serie =c_act.tarjeta
                                        where p.tarjeta_serie=ls_tarjeta_serie_r
                                        and deco_serie=c_act.deco
                                        and p.id_contrato in(SELECT r.nro_contrato
                                        FROM ope_srv_recarga_cab r
                                        where r.codsolot = ln_codsolot
                                        and r.numslc = ln_numslc);

                                        /*UPDATE USRPVU.SISACT_AP_CONTRATO_EQUIPO@DBL_PVUDB P
                                        SET P.tarjeta_serie = ls_tarjeta_serie_r
                                        WHERE P.ID_CONTRATO in (SELECT r.nro_contrato
                                        FROM ope_srv_recarga_cab r
                                        where r.codsolot = ln_codsolot
                                        and r.numslc = ln_numslc);*/

                                      end loop;
                                      -- 25.0 fin>
                                 end if;
                                 --<ini 25.0
                                    if  ls_tarjeta_serie <>',' then
                                        ln_pos := instr(ls_tarjeta_serie,',');
                                    else
                                      ln_pos:=-1;
                                    end if;
                                 -- 25.0 fin>
                                 end loop;
                           end if;
                          /*Deco*/

                          if INSTR(ls_deco_serie,',') = 0 then
                               ls_deco_serie_r := ls_deco_serie;

                               select count(1)
                               into ln_cont
                               from solotptoequ e
                               where e.codsolot = ln_codsolot
                               --and e.tipequ in(7242)--Tarjetas
                               and e.tipequ in(7113,8450,11519)
                               and e.mac = ls_deco_serie_r;

                               if ln_cont = 0 then
                                  --<ini 25.0
                                      for c_act in cur_act(ln_codsolot)  loop

                                        update USRPVU.SISACT_AP_CONTRATO_EQUIPO@DBL_PVUDB p
                                        SET P.deco_serie =c_act.deco
                                        where p.deco_serie=ls_deco_serie_r
                                        and tarjeta_serie=c_act.tarjeta
                                        and p.id_contrato in(SELECT r.nro_contrato
                                        FROM ope_srv_recarga_cab r
                                        where r.codsolot = ln_codsolot
                                        and r.numslc = ln_numslc);

                                        /*UPDATE USRPVU.SISACT_AP_CONTRATO_EQUIPO@DBL_PVUDB P
                                        SET P.deco_serie = ls_deco_serie_r
                                        WHERE P.ID_CONTRATO in (SELECT r.nro_contrato
                                        FROM ope_srv_recarga_cab r
                                        where r.codsolot = ln_codsolot
                                        and r.numslc = ln_numslc) ;*/

                                      end loop;
                                  -- 25.0 fin>
                               end if;
                          else

                              ln_pos := 1;
                              while ln_pos > 0
                              loop
                               ls_deco_serie_r := substr(ls_deco_serie,1,INSTR(ls_deco_serie,',')-1 );
                               ls_deco_serie_n := substr(ls_deco_serie,length(ls_deco_serie_r)+2);
                               ln_pos := instr(ls_deco_serie_n,',');
                               if ln_pos = 0 or ln_pos is null then
                                 ls_deco_serie := ls_deco_serie_n || ',';
                                 if ls_deco_serie_n is null or ls_deco_serie_n = '' then
                                    ln_pos := - 1;
                                 end if;
                               else
                                 ls_deco_serie := ls_deco_serie_n;
                               end if;


                               select count(1)
                               into ln_cont
                               from solotptoequ e
                               where e.codsolot = ln_codsolot
                               --and e.tipequ in(7242)--Tarjetas
                               and e.tipequ in(7113,8450,11519)
                               and e.mac = ls_deco_serie_r;

                               if ln_cont = 0 then
                                 --<ini 25.0
                                      for c_act in cur_act(ln_codsolot)  loop

                                        update USRPVU.SISACT_AP_CONTRATO_EQUIPO@DBL_PVUDB p
                                        SET P.deco_serie =c_act.deco
                                        where p.deco_serie=ls_deco_serie_r
                                        and tarjeta_serie=c_act.tarjeta
                                        and p.id_contrato in(SELECT r.nro_contrato
                                        FROM ope_srv_recarga_cab r
                                        where r.codsolot = ln_codsolot
                                        and r.numslc = ln_numslc);

                                        /*UPDATE USRPVU.SISACT_AP_CONTRATO_EQUIPO@DBL_PVUDB P
                                        SET P.deco_serie = ls_deco_serie_r
                                        WHERE P.ID_CONTRATO in (SELECT r.nro_contrato
                                        FROM ope_srv_recarga_cab r
                                        where r.codsolot = ln_codsolot
                                        and r.numslc = ln_numslc) ;*/

                                      end loop;
                                     -- 25.0 fin>
                               end if;
                                --<ini 25.0
                                  if  ls_deco_serie <>',' then
                                      ln_pos := instr(ls_deco_serie,',');
                                  else
                                    ln_pos:=-1;
                                  end if;
                                -- 25.0 fin>
                              end loop;

                         end if;
                      sales.pq_dth_postventa.p_ws_activar_dth(ln_numslc,ln_codsolot,ls_nro_contrato,ln_resp,lc_mensaje,a_idtareawf); --26.0
                    if  ln_resp <> 0 then
                             rollback;
                              insert into tareawfseg
                                (idtareawf, observacion)
                              values
                                (a_idtareawf, lc_mensaje);
                                commit;
                     raise_application_error(-20500,'Proceso Fallido en la activación' || lc_mensaje);
                 end if;

                -- Ini 30.0
                select decode(s.resumen,'VC',1,0) into ln_flag_cv
                  from operacion.solot s
                 where s.codsolot=ln_codsolot;

                if ln_flag_cv=1 then
                   operacion.pkg_sisact.p_informar_cierre(ln_codsolot,
                                                          ln_resp_cierre,
                                                          lc_mensaje_cierre);
                   if ln_resp_cierre <> 0 then
                      rollback;
                      insert into tareawfseg
                        (idtareawf, observacion)
                      values
                        (a_idtareawf, lc_mensaje_cierre);
                      commit;
                      raise_application_error(-20500,'Proceso Fallido al informar Cierre al SISACT, ' ||lc_mensaje);

                   end if;
                end if;
                -- Fin 30.0
           end if;
        end if;
    --fin 23.0

   ELSE
     -- ini 27.0

     select count(*) into li_cnt_reg from operacion.ope_envio_conax where codsolot = ln_codsolot ;
     select count(*) into li_cnt_env from operacion.ope_envio_conax where codsolot = ln_codsolot and estado = 1;

     if (li_cnt_reg <> li_cnt_env) then
         raise_application_error(-20500,
                        'Proceso Fallido, No se puede cerrar la tarea, falta Verificar CONAX.');
     end if;
    -- fin 27.0
    ln_validacion := f_valida_transaccion_conax(ln_codsolot); --4.0
    --if f_valida_transaccion_conax(ln_codsolot) <> 2 then --4.0
    /*if ln_validacion = 1 then --4.0
      raise_application_error(-20500,
                              'La transaccion no ha sido verificada existosamente.');
    --<4.0
    elsif ln_validacion = 0 then
      raise_application_error(-20500,
                              'No se han enviado archivos a Conax.');
    --4.0>
    end if;*/
    null;
   END IF;
   --Fin 21.0
  --ini 28.0 Actualiza Estado de Tarjeta y Deco
    p_act_estado_equ(ln_codsolot);
    --fin 28.0
    -- Ini 43.0
    select t.codigon
      into ln_activa_cci
      from opedd t
     where t.tipopedd =
           (select t.tipopedd from tipopedd t where t.abrev = 'PAR_VAL_CCI')
       and t.abreviacion = 'FLAG_CCI'
       AND t.codigon_aux = 1;

    if ln_activa_cci = 1 then
      BEGIN

        SALES.PKG_VALIDACION_CCI.SGASP_VALIDACCION_CCI(ln_codsolot,
                                                       ln_resp_cci,
                                                       lc_mensaje_cci);

        if lc_mensaje_cci is not null then
          ln_resp_cci := TRIM(SALES.PKG_VALIDACION_CCI.SGAFUN_ATRIBUTO_XML(lc_mensaje_cci,
                                                                               'codRespuesta'));

          lc_mensaje_cci := TRIM(SALES.PKG_VALIDACION_CCI.SGAFUN_ATRIBUTO_XML(lc_mensaje_cci,
                                                                                  'msjRespuesta'));
          if ln_resp_cci <> 0 then
            l_cod_id      := SALES.PKG_VALIDACION_CCI.SGAFUN_GET_DATOS_SOT(ln_codsolot,
                                                                           'CODID');
            l_customer_id := SALES.PKG_VALIDACION_CCI.SGAFUN_GET_DATOS_SOT(ln_codsolot,
                                                                           'CUSTOMERID');

            lc_mensaje_cci:= 'VALIDACION_CCI, ERROR : '||lc_mensaje_cci;

             insert into HISTORICO.SGAT_REGVALCCI(codsolot, codid, customerid, observacion, reintentos )
             values(ln_codsolot, l_cod_id, l_customer_id, lc_mensaje_cci, 1);

            commit;
          end if;

        end if;
      EXCEPTION
        WHEN OTHERS THEN
          lc_mensaje_cci := 'VALIDACION_CCI, ERROR : ' || sqlcode || ' ' || sqlerrm;

           insert into HISTORICO.SGAT_REGVALCCI(codsolot, observacion, reintentos )
           values(ln_codsolot, lc_mensaje_cci, 1);
           
           commit;

      END;
    end if;
  -- Fin 43.0
END;

  procedure p_cargar_recarga(a_codsolot solot.codsolot%type) is
    --ln_codsolot solot.codsolot%type; --4.0
ls_numslc vtatabslcfac.numslc%type;
ln_idpaq number;
lr_preope vtatabpreope%rowtype;
lr_vtatabslcfac vtatabslcfac%rowtype;
--lv_numregistro recargaproyectocliente.numregistro%type; --4.0
lv_numregistro ope_srv_recarga_cab.numregistro%type; --4.0
--ini 6.0
lc_codcli vtatabcli.codcli%type;
ln_tipbqd   ope_srv_recarga_cab.tipbqd%type;
ln_flg_recarga ope_srv_recarga_cab.flg_recarga%type; --20.0
--fin 6.0
cursor cur_servicios is
--<2.0
--select * from inssrv
--where numslc = ls_numslc;
select a.codinssrv,a.codsrv,a.tipsrv,b.pid
from inssrv a, insprd b
where a.numslc = ls_numslc
and a.codinssrv = b.codinssrv
and b.flgprinc = 1;
--2.0>
--Ini 18.0
LN_COUNT NUMBER;
LS_NROBV VARCHAR2(10);
LC_SERSUT CHAR(3);
LC_NUMSUT CHAR(8);
--Fin 18.0
begin

  ln_idpaq := f_obtener_idpaq(a_codsolot);
  --ini 6.0
  --select numslc into ls_numslc from solot where codsolot = a_codsolot;
    select numslc,codcli into ls_numslc,lc_codcli
     from solot where codsolot = a_codsolot;
    --select * into lr_preope from vtatabpreope where numslc = ls_numslc;
    --fin 6.0
    --<20.0
    if sales.pq_dth_postventa.f_obt_facturable_dth(ls_numslc) = 1 then
       ln_flg_recarga := 0;
    else
       ln_flg_recarga := 1;
    end if;
    --20.0>
    --insert into recargaproyectocliente --4.0
    --Ini 18.0
    SELECT COUNT(1)
      INTO LN_COUNT
      FROM SALES.INT_VTAREGVENTA_AUX
      WHERE O_CODSOLOT = a_codsolot;

    IF LN_COUNT>=1 THEN
       SELECT NROBV
       INTO LS_NROBV
       FROM SALES.INT_VTAREGVENTA_AUX
       WHERE O_CODSOLOT = a_codsolot;
       --NROBV:SSS-NNNNNN
       --SSS:Numero de Serie
       --NNNNNN:Numero de Boleta
       LC_SERSUT:= TRIM(LPAD(LS_NROBV,3));
       LC_NUMSUT:= TRIM(SUBSTR(LS_NROBV,5));
       --tipdocfac segun tabla cxctipodoc
       insert into ope_srv_recarga_cab
              (flg_recarga, codcli, numslc, codsolot, idpaq, estado,tipdocfac,sersut,numsut)
       values
         (ln_flg_recarga,
         lc_codcli,
         ls_numslc,
         a_codsolot,
         ln_idpaq,
           '01',
           'B/V',
           LC_SERSUT,
           LC_NUMSUT)

       returning numregistro into lv_numregistro;
    ELSE
     --Fin 18.0

    insert into ope_srv_recarga_cab --4.0
      (flg_recarga, codcli, numslc, codsolot, idpaq, estado)
    values
     --ini 6.0
      /*(lr_preope.flg_recarga,
     lr_preope.codcli,
     lr_preope.numslc,
     lr_preope.codsolot,
     ln_idpaq,
       '01')*/
     (--1, --20.0
      ln_flg_recarga, --20.0
     lc_codcli,
     ls_numslc,
     a_codsolot,
     ln_idpaq,
       '01')
     --fin 6.0
     returning numregistro into lv_numregistro;
     --Ini 18.0
    END IF;
    --Fin 18.0
  for c_serv in cur_servicios loop
      --insert into recargaxinssrv --4.0
      insert into ope_srv_recarga_det --4.0
        (numregistro, codinssrv, tipsrv, codsrv, pid) --2.0
      values
        (lv_numregistro,
           c_serv.codinssrv,
           c_serv.tipsrv,
           c_serv.codsrv,
           c_serv.pid); --2.0
  end loop;

  --ini 6.0
  begin
   ln_tipbqd := f_obtener_tipbqd(lv_numregistro);

   update ope_srv_recarga_cab
   set tipbqd = ln_tipbqd
   where numregistro = lv_numregistro;
  exception
   when others then
      raise_application_error(-20500,
                            'Error en obtención u/o actualización del tipo de búsqueda de servicios recargables');
  end;
  --fin 6.0
exception
  when others then
      raise_application_error(-20500,
                              'Error en generacion de registros de recarga.');
end;

--no utilizado, se reemplaza por ventana de liquidacion --4.0
  procedure p_liquidacion_aut(a_idtareawf in number,
                              a_idwf      in number,
                              a_tarea     in number,
                              a_tareadef  in number) is

ln_codsolot    solot.codsolot%type;
    --lv_observacion    varchar2(200);--4.0
ls_estado       solotptoequ.estado%type;
ln_ExisteNroSerie number;
ln_error number;
ls_mensaje TAREAWFSEG.observacion%type;

cursor cur_equ is
select a.codsolot,a.punto,a.orden,a.numserie, c.cod_sap
        from solotptoequ a, tipequ b, almtabmat c
where codsolot = ln_codsolot
and a.tipequ = b.tipequ
and b.codtipequ = c.codmat;

begin
  select codsolot into ln_codsolot from wf where idwf = a_idwf;

  begin
    ln_error := 0;
    for c_e in cur_equ loop

      ls_estado := 4;

      if c_e.numserie is not null then
          select count(1)
            into ln_ExisteNroSerie
            from maestro_Series_equ m
           where trim(m.nroserie) = trim(c_e.numserie)
             and trim(m.cod_sap) = trim(c_e.cod_sap);

         if ln_ExisteNroSerie = 0 then
           ls_estado := 9;
           update solotptoequ
           set estado = ls_estado,
           observacion = observacion || 'Falta Serie en BD.'
           where codsolot = c_e.codsolot
           and punto = c_e.punto
           and orden = c_e.orden;

           ln_error := ln_error + 1;
            P_ENVIA_CORREO_DE_TEXTO_ATT('Registrar Equipos DTH',
                                        'DL - PE - Carga Equipos Intraway SGA',
                                        '');

            ls_mensaje := 'El numero de serie: ' || trim(c_e.numserie) ||
                          ' y codigo sap: ' || trim(c_e.cod_sap) ||
                          ' no se encuentran en el maestro de numeros de serie.';

            insert into TAREAWFSEG
              (IDTAREAWF, OBSERVACION, FLAG)
            values
              (a_idtareawf, ls_mensaje, 1);

         else
           update solotptoequ
           set estado = ls_estado
           where codsolot = c_e.codsolot
           and punto = c_e.punto
           and orden = c_e.orden;
         end if;
      else
        update solotptoequ
        set estado = ls_estado
        where codsolot = c_e.codsolot
        and punto = c_e.punto
        and orden = c_e.orden;
      end if;
    end loop;

    /*if ln_error = 1 then
       OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                           1,
                                           1,
                                           0,
                                           SYSDATE,
                                           SYSDATE);
       commit;
    end if;*/

  exception
    when others then
        raise_application_error(-20500,
                                'Error en liquidacion automatica de trabajo.');
  end;

  /*if ln_error = 1 then
     raise_application_error(-20500,'Error en validacion de series.');
  end if; */
end;

  procedure p_activar_recarga(a_idtareawf in number,
                              a_idwf      in number,
                              a_tarea     in number,
                              a_tareadef  in number) is
ln_codsolot    solot.codsolot%type;
ls_numslc solot.numslc%type;
ln_diasalerta number;
ln_diasgracia number;
ln_diasvigencia number;
ld_fecinivig date;
ld_fecfinvig date;
ld_fecalerta date;
ld_feccorte date;
ld_fecact_cdma date;
ls_observacion  tareawfseg.observacion%type;
--ls_numregistro recargaproyectocliente.numregistro%type; --4.0
ls_numregistro ope_srv_recarga_cab.numregistro%type; --4.0

begin
  select codsolot into ln_codsolot from wf where idwf = a_idwf;
  select numslc into ls_numslc from solot where codsolot = ln_codsolot;

  --se obtiene informacion de fechas de vigencia de recarga
  ld_fecinivig := trunc(sysdate);
  ln_diasvigencia:= billcolper.f_parametrosfac(655);
  ld_fecfinvig := ld_fecinivig + ln_diasvigencia;
  ln_diasalerta  := billcolper.f_parametrosfac(651); -- dias previos a fin para generar alerta
  ld_fecalerta := ld_fecinivig + ln_diasvigencia - ln_diasalerta;
  ln_diasgracia  := billcolper.f_parametrosfac(652); -- dias despues a fin para generar corte
  ld_feccorte  := ld_fecinivig + ln_diasvigencia + ln_diasgracia;

  --se cambia al estado instalado y se actualizan fechas de vigencia del bundle
  --update recargaproyectocliente --4.0
  update ope_srv_recarga_cab --4.0
  set estado = '02', --instalado
  fecinivig = ld_fecinivig,
  fecfinvig = ld_fecfinvig,
  fecalerta = ld_fecalerta,
  feccorte = ld_feccorte
  where numslc = ls_numslc;

  begin

      select fecfin
        into ld_fecact_cdma
    from tareawf
    where idwf = a_idwf
    and tareadef in (select b.codigon
    from tipopedd a,opedd b
    where a.tipopedd = b.tipopedd
    and a.abrev = 'ACTCDMA');

    ls_numregistro := f_obtener_numregistro(ln_codsolot);

    --update recargaxinssrv --4.0
    update ope_srv_recarga_det --4.0
    set fecact = ld_fecact_cdma
    where numregistro = ls_numregistro
         and tipsrv =
             (select valor from constante where constante = 'FAM_TELEF');
  exception
    when others then
      null; --si no tiene registro de CDMA no hace nada
  end;

  if trunc(ld_fecact_cdma) <> ld_fecinivig then
      ls_observacion := 'SOT: ' || to_char(ln_codsolot) ||
                        ', diferencia de fechas de activacion, OCS:' ||
                        to_char(trunc(ld_fecact_cdma), 'dd/mm/yyyy') ||
                        ', Bundle: ' || to_char(ld_fecinivig, 'dd/mm/yyyy');
      insert into TAREAWFSEG
        (IDTAREAWF, OBSERVACION, FLAG)
      values
        (a_idtareawf, ls_observacion, 1);
    --P_ENVIA_CORREO_DE_TEXTO_ATT('Bundle DTH + CDMA', 'DL - PE - Carga Equipos Intraway SGA', ls_observacion);
  end if;

exception
    when others then
      raise_application_error(-20500,'Error en activacion de recarga.');
end;

--<2.0
  function f_obtener_estado_serv(a_numregistro varchar2) return varchar2 is

  ls_estado varchar2(1000);

  cursor c_estado is
      select distinct (select descripcion
                         from estinsprd
                        where estinsprd = b.estinsprd) estado
    --from recargaxinssrv a, insprd b --4.0
    from ope_srv_recarga_det a, insprd b --4.0
    where a.numregistro = a_numregistro
    and a.pid = b.pid;

  begin
    ls_estado := null;
    for c_est in c_estado loop
      if ls_estado is not null then
         ls_estado := ls_estado || ',' || ls_estado;
      else
         ls_estado := c_est.estado;
      end if;
    end loop;

    return ls_estado;
  exception
    when others then
       ls_estado := 'Error en obtencion de estado.';
       return ls_estado;
  end;

  --actualizacion de vigencia en SGA
  --ini 6.0
  --PROCEDURE p_pos_actualiza_vigencia(a_idtareawf IN NUMBER,
  PROCEDURE p_pos_validacion(a_idtareawf IN NUMBER,
  --fin 6.0
                                a_idwf      IN NUMBER,
                                a_tarea     IN NUMBER,
                                a_tareadef  IN NUMBER) IS
   --<4.0
   /*BEGIN
      --la logica esta en el procedimiento pre
      p_pre_actualiza_vigencia(a_idtareawf,
                                  a_idwf, \*a_tarea*\
                                  null,
                                  a_tareadef);
   END;

  --actualizacion de vigencia en SGA
  procedure p_pre_actualiza_vigencia(a_idtareawf in number, a_idwf in number,a_tarea in number,a_tareadef in number)
  is*/
  --4.0>
  ln_codsolot solot.codsolot%type;
  --ls_numregistro recargaproyectocliente.numregistro%type; --4.0
  ls_numregistro ope_srv_recarga_cab.numregistro%type; --4.0
  lr_reginsdth_web reginsdth_web%rowtype;
  ln_flg_recarga number;
  lv_observacion TAREAWFSEG.observacion%type;
  ls_tipesttar esttarea.tipesttar%TYPE;
  exception_vigencia exception;
  --lr_recarga recargaproyectocliente%rowtype; --4.0
  lr_recarga ope_srv_recarga_cab%rowtype; --4.0
  ln_tiptrs tiptrabajo.tiptrs%type;
  --<4.0
  --ls_estado recargaproyectocliente.estado%type;
  ls_estado ope_srv_recarga_cab.estado%type;
  ln_tipo_tarea tareawfcpy.tipo%type; --0:normal,1:opcional, 2:automatica
  ln_tipo_error number; --0:mensaje error, 1:cambia a estado "con errores"
  ln_num_error number;
  --4.0>

  cursor cur_servicios(a_codsolot number) is
    select d.dscsrv servicio, a.estinssrv, c.descripcion estado
    from inssrv a,solotpto b, estinssrv c,tystabsrv d
    where a.codinssrv = b.codinssrv
    and b.codsolot = a_codsolot
    and a.estinssrv = c.estinssrv
    and a.codsrv = d.codsrv;

  begin
    select codsolot into ln_codsolot from wf where idwf = a_idwf;

    ls_numregistro := f_obtener_numregistro(ln_codsolot);

    if ls_numregistro is not null then
      --se verifica si ya se ejecuto el procedimiento pre
      select *
        into lr_recarga
      --from recargaproyectocliente --4.0
      from ope_srv_recarga_cab --4.0
      where numregistro = ls_numregistro;

      select *
        into lr_reginsdth_web
      from reginsdth_web
      where numregistro = ls_numregistro;

      --4.0
      /*if lr_recarga.fecinivig   <> lr_reginsdth_web.fecinivig and
         lr_recarga.fecfinvig   <> lr_reginsdth_web.fecfinvig and
         lr_recarga.fecalerta   <> lr_reginsdth_web.fecalerta and
         lr_recarga.feccorte    <> lr_reginsdth_web.feccorte then*/
      --4.0

      --si es primera vez que se ejecuta el procedimiento pre
      select nvl(flg_recarga,0), estado
      into ln_flg_recarga,ls_estado
      --from recargaproyectocliente --4.0
      from ope_srv_recarga_cab --4.0
      where numregistro = ls_numregistro;

      --se averigua tipo de transaccion
      --<4.0
      /*select b.tiptrs
      into ln_tiptrs*/
      select nvl(b.tiptrs, 0)
        into ln_tiptrs
      --4.0>
      from solot a,tiptrabajo b
      where a.tiptra = b.tiptra
      and codsolot = ln_codsolot;

      --validaciones segun tipo de transaccion
      if ln_tiptrs = 4 then
        --reconexion
        --validacion de estado del registro de recarga
        --if ls_estado = '02' then --4.0
        if ls_estado <> '03' then
          --4.0
          lv_observacion := 'Estado incorrecto, el registro de recarga ya esta activo.';
          raise exception_vigencia;
        end if;

        --validacion de estado del servicio
        for c_servicios in cur_servicios(ln_codsolot) loop
          if c_servicios.estinssrv <> 2 then
            lv_observacion := 'Estado del Servicio:' ||
                              c_servicios.servicio ||
                              ',es incorrecto para reconexion: ' ||
                              c_servicios.estado;
            raise exception_vigencia;
          end if;
        end loop;
      --<4.0
      elsif ln_tiptrs = 0 then
        --recarga
        --validacion de estado del registro de recarga
        if ls_estado <> '02' then
          lv_observacion := 'Estado incorrecto, el registro de recarga no esta activo.';
          raise exception_vigencia;
        end if;

        --validacion de estado del servicio
        for c_servicios in cur_servicios(ln_codsolot) loop
          if c_servicios.estinssrv <> 1 then
            --diferente de actico
            lv_observacion := 'Estado del Servicio:' ||
                              c_servicios.servicio ||
                              ',es incorrecto para recarga: ' ||
                              c_servicios.estado;
            raise exception_vigencia;
          end if;
        end loop;
        --4.0>
      end if;

      --se actualiza fecha de vigencia
      --update recargaproyectocliente --4.0
      --ini 6.0
      /*update ope_srv_recarga_cab --4.0
      set fecinivig   = lr_reginsdth_web.fecinivig,
         fecfinvig   = lr_reginsdth_web.fecfinvig,
         fecalerta   = lr_reginsdth_web.fecalerta,
         feccorte    = lr_reginsdth_web.feccorte,
         flg_recarga = 1
      where numregistro = ls_numregistro;

      --se da por transferido el registro de recarga
      update reginsdth_web
      set flgtransferir = 2
      where numregistro = ls_numregistro;*/
      --fin 6.0
      --si no esta en facturacion virtual entonces se cambia
      --<4.0
      /*if ln_flg_recarga = 0 then
        pq_control_dth.p_migra_sistema_brightstar(1,
                                                  lr_reginsdth_web.codcli,
                                                  null,
                                                  lr_reginsdth_web.numregistro); --14.0
      end if;*/
      --4.0> --no deberia ocurrir, no utiliza sistema de facturacion
      --end if; --4.0
    else
      lv_observacion := 'Error en obtencion de numero de registro.';
      raise exception_vigencia;
    end if;

    --<4.0
    /*if a_tarea is not null then
      SELECT tipesttar
                INTO ls_tipesttar
                FROM esttarea
               WHERE esttarea = cn_esttarea_cerrado;

      --se cambio a estado error plataforma
              OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                               ls_tipesttar,
                                               cn_esttarea_cerrado,
                                               0,
                                               SYSDATE,
                                               SYSDATE);
    end if;*/
    --4.0>
  exception
      when exception_vigencia then
         --<4.0
         --logica para gestion de errores
      select tipo
        into ln_tipo_tarea
         from tareawfcpy
         where idtareawf = a_idtareawf;

      if ln_tipo_tarea in (0, 1) then
        --si es tarea normal u opcional
           ln_tipo_error := 0; --mensaje error
      else
        --tarea automatica
        select count(1)
          into ln_num_error --se cuenta si paso por estado "con errores"
           from tareawfchg
           where idtareawf = a_idtareawf
           and esttarea = cn_esttarea_error;

        if ln_num_error > 0 then
          --si estuvo en estado error
             ln_tipo_error := 0; --mensaje error
        else
          --si es primera vez que se genera ta tarea
             ln_tipo_error := 1; --cambia a estado "con errores"
           end if;
         end if;
         --4.0>

         --si la tarea es nulo entonces proviene de un cambio de estado
         --if a_tarea is not null then --4.0
      if ln_tipo_error = 1 then
        --4.0
            --si la tarea es nulo entonces proviene de un cambio de estado
        insert into tareawfseg
          (idtareawf, observacion)
        values
          (a_idtareawf, lv_observacion);

            SELECT tipesttar
              INTO ls_tipesttar
              FROM esttarea
             WHERE esttarea = cn_esttarea_error;

        --se cambio a estado error plataforma
            OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                             ls_tipesttar,
                                             cn_esttarea_error,
                                             0,
                                             SYSDATE,
                                             SYSDATE);
         else
            RAISE_APPLICATION_ERROR(-20500, lv_observacion);
         end if;
         return;
  end;

   --recarga de saldo y actualizacion de vigencia en OCS
   PROCEDURE p_chg_recarga_cdma(a_idtareawf in number,
                                      a_idwf      in number,
                                      a_tarea     in number,
                                      a_tareadef  in number,
                                      a_tipesttar in number,
                                      a_esttarea  in number,
                                      a_mottarchg in number,
                                      a_fecini    in date,
                                      a_fecfin    in date) IS

      ls_esttarea_old tareawf.esttarea%type;

   BEGIN
      begin
         select esttarea
           into ls_esttarea_old
           from tareawf
          where idtareawf = a_idtareawf;
      EXCEPTION
         WHEN OTHERS Then
            ls_esttarea_old := null;
      End;
      --ejecuta el proceso si cambia de un estado error a generado.
    IF ls_esttarea_old is not null AND ls_esttarea_old = cn_esttarea_error AND
         a_esttarea = cn_esttarea_new THEN
         --se coloca el a_tarea en null para identificar que proviene de un cambio de estado
      p_pre_recarga_cdma(a_idtareawf, a_idwf, /*a_tarea*/ null, a_tareadef);
      end if;
   END;

  --recarga de saldo y actualizacion de vigencia en OCS
  procedure p_pre_recarga_cdma(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number) is
  ln_codsolot solot.codsolot%type;
  --lv_numregistro recargaproyectocliente.numregistro%type; --4.0
  lv_numregistro ope_srv_recarga_cab.numregistro%type; --4.0
  ln_codinssrv inssrv.codinssrv%type;
  lv_resultado varchar2(10);
  lv_mensaje varchar2(4000);
    --ln_codsolot_ori solot.codsolot%type;--4.0
  lv_subscriber inssrv.numero%type;
  lv_observacion TAREAWFSEG.observacion%type;
  ls_tipesttar esttarea.tipesttar%TYPE;
  exception_recarga exception;
  lv_monto varchar2(10);
  lv_vigencia varchar2(10);
  ln_monto number;
    --ls_tipsrv_cdma     char(4);--4.0
  ln_monto_cdma number;
  ln_idcupon cuponpago_dth.idcupon%type;
  ln_idrecarga number;
  ln_idlote number;
  ln_vigencia number;
  ln_num number;
  lc_operacion VARCHAR2(10);
  lc_tipo_parametro       VARCHAR2(10);
  lc_valor_parametro      VARCHAR2(30);
  ln_pid insprd.pid%type;
  ln_codnumtel numtel.codnumtel%type;
  ln_idseq int_servicio_plataforma.idseq%type;
  ln_tiptrs tiptrabajo.tiptrs%type;
  an_cod_error number;  --5.0
  ac_des_error varchar2(1000); --5.0
  --ini 6.0
  ln_cont            number;
  --fin 6.0
  begin

    select codsolot into ln_codsolot from wf where idwf = a_idwf;

    --se averigua tipo de transaccion
    select b.tiptrs
      into ln_tiptrs
    from solot a,tiptrabajo b
    where a.tiptra = b.tiptra
    and codsolot = ln_codsolot;

    lv_numregistro := f_obtener_numregistro(ln_codsolot);

    --ini 6.0
    select count(1) into ln_cont
    from ope_srv_recarga_det
    where numregistro = lv_numregistro
     and tipsrv = (select valor
                     from constante
                    where constante = 'FAM_TELEF');
    --se ejecuta proceso en OCS solo si tiene servicio CDMA
    if ln_cont > 0 then
    --fin 6.0
      if lv_numregistro is not null then
        --se obtiene instancia de servicio de CDMA
        begin
          select c.numero, c.codnumtel, a.codinssrv, a.pid
            into lv_subscriber, ln_codnumtel, ln_codinssrv, ln_pid
          --from recargaxinssrv a,inssrv b, numtel c --4.0
          from ope_srv_recarga_det a,inssrv b, numtel c --4.0
          where a.numregistro = lv_numregistro
             and a.tipsrv =
                 (select valor from constante where constante = 'FAM_TELEF')
          and a.codinssrv = b.codinssrv
          and b.codinssrv = c.codinssrv;
        exception
          when no_data_found then
             lv_observacion := 'Error en obtencion de numero telefonico.';
             raise exception_recarga;
        end;

        begin
          --se guarda la tarea
          --update recargaxinssrv --4.0
          update ope_srv_recarga_det --4.0
          set ulttareawf = a_idtareawf
          where numregistro = lv_numregistro
          and codinssrv = ln_codinssrv;

          --se monto de la recarga total y la vigencia
          select idcupon, monto, to_number(hasta - desde) vigencia
            into ln_idcupon, ln_monto, ln_vigencia
            from cuponpago_dth
           where codsolot = ln_codsolot;
          if ln_tiptrs is null then
            --para OCS hay que enviar un dia mas para que no cuente el dia de la transaccion en la vigencia
            --porque asi se maneja la vigencia en el SGA
            ln_vigencia := ln_vigencia + 1;
          end if;
          lv_vigencia := to_char(ln_vigencia);
        exception
          when others then
             lv_observacion := 'Error:' || sqlerrm;
             raise exception_recarga;
        end;
        --se obtiene monto para el servicio CDMA
        --Ini 5.0
        --se obtiene el idrecarga
        select idrecarga
          into ln_idrecarga
          from cuponpago_dth_web
         where idcupon = ln_idcupon;
         p_obtener_monto_srv(2,
                                lv_numregistro,
                                ln_idrecarga   ,
                                ln_codinssrv   ,
                                ln_monto_cdma   ,
                                an_cod_error   , --5.0
                                ac_des_error   );--5.0

        --p_obtener_monto_srv(2,lv_numregistro,ln_monto,ln_codinssrv,ln_monto_cdma,ln_idrecarga);
        --Fin 5.0
        if ln_monto_cdma is not null then
          lv_monto := to_char(ln_monto_cdma);
        else
          lv_observacion := 'Error en obtencion de monto de recarga para CDMA: ' || to_char(an_cod_error) || ':' || ac_des_error; --5.0
          raise exception_recarga;
        end if;

        begin
          lc_operacion := OPE_OCS_REC_VIR; -- operacion recarga virtual
          lc_tipo_parametro := TIPO_PARAM_DEF; -- tipo de parametro
          lc_valor_parametro := lv_subscriber || '~' || lv_monto || '~' ||
                                lv_vigencia; -- subscriber;monto

          --se averigua si ya existe el registro
          select count(1)
            into ln_num
          from int_servicio_plataforma
          where codsolot = ln_codsolot
          and idtareawf = a_idtareawf
          and codinssrv = ln_codinssrv
          and pid = ln_pid
          and codnumtel = ln_codnumtel
          and iddefope = lc_operacion;

          if ln_num = 0 then
            --si no existe
            INSERT INTO int_servicio_plataforma
                  (codsolot,
                   idtareawf,
                   codinssrv,
                   pid,
                   codnumtel,
                   iddefope,
                   monto,
                   vigencia)
                VALUES
                  (ln_codsolot,
                   a_idtareawf,
                   ln_codinssrv,
                   ln_pid,
                   ln_codnumtel,
                   lc_operacion,
                   ln_monto_cdma,
               ln_vigencia)
            returning idseq into ln_idseq;
           else
            select idseq
              into ln_idseq
             from int_servicio_plataforma
             where codsolot = ln_codsolot
             and idtareawf = a_idtareawf
             and codinssrv = ln_codinssrv
             and pid = ln_pid
             and codnumtel = ln_codnumtel
             and iddefope = lc_operacion
             and idlote is null;
           end if;

          PQ_INT_COMANDO_PLATAFORMA.p_generar_lote_comando(lc_operacion,
                                                           lc_tipo_parametro,
                                                           lc_valor_parametro,
                                                           lv_resultado,
                                                           lv_mensaje);

          if lv_resultado <> PQ_FND_UTILITARIO_INTERFAZ.FND_ESTADO_EXITO then
            lv_observacion := 'No se pudo generar solicitud a la plataforma, error:' ||
                              lv_mensaje;

             update int_servicio_plataforma
             set estado = 3 --error
             where idseq = ln_idseq;

             raise exception_recarga;
          else
             --se actualiza lote generado
             ln_idlote := to_number(lv_mensaje);
             update int_servicio_plataforma
               set idlote = ln_idlote, estado = 1 --enviado
             where idseq = ln_idseq;

             lv_observacion := 'Se genero IDLOTE: ' || lv_mensaje;

            insert into tareawfseg
              (idtareawf, observacion)
            values
              (a_idtareawf, lv_observacion);
          end if;

        exception
          when others then
            if lv_mensaje is null then
              lv_mensaje := sqlerrm;
            end if;
            lv_observacion := 'Error en ejecución en la plataforma:' ||
                              lv_mensaje;
        end;

      else
        lv_observacion := 'Error en obtencion de numero de registro.';
        raise exception_recarga;
      end if;
    --ini 6.0
    else
    --cambia a estado no interviene
       OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,4,8,0,SYSDATE,SYSDATE);
    end if;
    --fin 6.0
    exception
      when exception_recarga then
         --si la tarea es nulo entonces proviene de un cambio de estado
         if a_tarea is not null then
            --se ingresa el error como anotacion
        insert into tareawfseg
          (idtareawf, observacion)
        values
          (a_idtareawf, lv_observacion);

            SELECT tipesttar
              INTO ls_tipesttar
              FROM esttarea
             WHERE esttarea = cn_esttarea_error;

        --se cambio a estado error plataforma
            OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                             ls_tipesttar,
                                             cn_esttarea_error,
                                             0,
                                             SYSDATE,
                                             SYSDATE);
         else
            RAISE_APPLICATION_ERROR(-20500, lv_observacion);
         end if;
         return;
  end;
--Ini 5.0: Obtiene el monto en base al idrecarga, y no en el monto
procedure p_obtener_monto_srv(an_tipo        number,
                              ac_numregistro varchar2,
                              an_idrecarga   vtatabrecarga.idrecarga%type,
                              an_codinssrv   number,
                              an_monto_srv   out number,
                              an_cod_error   out number,
                              ac_des_error   out varchar2) is

  --tipo 1:monto para factura, 2:monto para recarga
  ln_monto_rec number;
  ln_monto_fac number;
begin
  select e.monto, e.montorec
    into ln_monto_fac, ln_monto_rec
    from ope_srv_recarga_cab     a,
         ope_srv_recarga_det     b,
         vtatabrecargaxpaquete   c,
         vta_det_recarga_paq_mae e,
         vtatabrecarga           f
   where a.numregistro = ac_numregistro
     and a.numregistro = b.numregistro
     and a.idpaq = c.idpaq
     and b.codinssrv = an_codinssrv
     and e.idrecarga = f.idrecarga
     and b.codsrv = e.codsrv
     and c.idpaq = e.idpaq
     and c.idrecarga = an_idrecarga
     -- ini 6.0
     and c.idrecarga = e.idrecarga
     -- fin 6.0
     and e.estado = 1;

  if an_tipo = 1 then
    an_monto_srv := ln_monto_fac;
  else
    an_monto_srv := ln_monto_rec;
  end if;

exception
  when others then
    --an_monto_srv := null;
    an_cod_error:=-20000;
    ac_des_error:=substr(sqlerrm, 12) || '(' ||
                        dbms_utility.format_error_backtrace || ')';
end;
--Fin 5.0

  --Ini 5.0: Obtiene el monto de la recarga por paquete
  function f_obt_monto_recargaxpaquete(an_idrecarga vtatabrecargaxpaquete.idrecarga%type,
                                       an_idpaq     vtatabrecargaxpaquete.idpaq%type)
    return vtatabrecargaxpaquete.monto%type is
    result vtatabrecargaxpaquete.monto%type;
  begin
    select rxp.monto
      into result
      from vtatabrecargaxpaquete rxp
     where rxp.idrecarga = an_idrecarga
       and rxp.idpaq = an_idpaq;
    return result;
  exception
    when no_data_found then
      raise_application_error(-20000,
                              'No se encontró registro para el paquete: ' ||
                              to_char(an_idpaq) || ' y IdRecarga: ' ||
                              to_char(an_idrecarga));
    when others then
      raise_application_error(-20000,
                              substr(sqlerrm, 12) || '(' ||
                              dbms_utility.format_error_backtrace || ')');
  end;
--fin 5.0

  --procedure p_obtener_monto_srv(a_numregistro varchar2,a_monto number,a_codinssrv number,a_monto_srv out number, a_idrecarga out number) is --3.0
  procedure p_obtener_monto_srv(a_tipo        number,
                                a_numregistro varchar2,
                                a_monto       number,
                                a_codinssrv   number,
                                a_monto_srv   out number,
                                a_idrecarga   out number) is
    --3.0
    --tipo 1:monto para factura, 2:monto para recarga --3.0
    --ln_monto_srv number; --3.0
    ln_monto_rec number; --3.0
    ln_monto_fac number; --3.0
    ln_idrecarga number;

  begin

    --select e.monto,f.idrecarga into ln_monto_srv, ln_idrecarga
    select e.monto, e.montorec, f.idrecarga
      into ln_monto_fac, ln_monto_rec, ln_idrecarga --3.0
    --<4.0
    /*from recargaproyectocliente  a,
                           recargaxinssrv          b,*/
      from ope_srv_recarga_cab     a,
           ope_srv_recarga_det b,
           --4.0>
           vtatabrecargaxpaquete   c,
           vta_det_recarga_paq_mae e,
           vtatabrecarga           f
     where a.numregistro = a_numregistro
       and a.numregistro = b.numregistro
       and a.idpaq = c.idpaq
       and b.codinssrv = a_codinssrv
       and e.idrecarga = f.idrecarga
       and b.codsrv = e.codsrv
       and c.idpaq = e.idpaq
       and c.idrecarga = e.idrecarga
       and c.monto = a_monto
       and e.estado = 1;
    --<3.0
    if a_tipo = 1 then
      a_monto_srv := ln_monto_fac;
    else
      a_monto_srv := ln_monto_rec;
    end if;
    --3.0>
    --a_monto_srv := ln_monto_srv; --3.o
    a_idrecarga := ln_idrecarga;
  exception
    when others then
      a_monto_srv := null;
  end;

  function f_obtener_idrecarga(a_idcupon number) return number is

    ln_idrecarga number;

  begin
    --Ini 5.0: se cambia la forma de obtener el idrecarga
    /*select f.idrecarga
     into ln_idrecarga
     from cuponpago_dth_web a, vtatabrecargaxpaquete e, vtatabrecarga f
    where a.idcupon = a_idcupon
      and a.idpaq = e.idpaq
      and e.idrecarga = f.idrecarga
      and e.monto = a.monto;*/
    select e.idrecarga
      into ln_idrecarga
      from cuponpago_dth_web a, vtatabrecargaxpaquete e
     where a.idcupon = a_idcupon
       and a.idrecarga = e.idrecarga
       and a.idpaq = e.idpaq;
    return ln_idrecarga;
    --Fin 5.0
  exception
    when others then
      return null;
  end;
   --se envia reconexion hacia conax
   PROCEDURE p_chg_reconexion_conax(a_idtareawf in number,
                                      a_idwf      in number,
                                      a_tarea     in number,
                                      a_tareadef  in number,
                                      a_tipesttar in number,
                                      a_esttarea  in number,
                                      a_mottarchg in number,
                                      a_fecini    in date,
                                      a_fecfin    in date) IS

      ls_esttarea_old tareawf.esttarea%type;

   BEGIN
      begin
         select esttarea
           into ls_esttarea_old
           from tareawf
          where idtareawf = a_idtareawf;
      EXCEPTION
         WHEN OTHERS Then
            ls_esttarea_old := null;
      End;
      --ejecuta el proceso si cambia de un estado error a generado.
    IF ls_esttarea_old is not null AND ls_esttarea_old = cn_esttarea_error AND
         a_esttarea = cn_esttarea_new THEN
         --se coloca el a_tarea en null para identificar que proviene de un cambio de estado
         p_pre_reconexion_conax(a_idtareawf,
                                  a_idwf, /*a_tarea*/
                                  null,
                                  a_tareadef);
      end if;
   END;

  --se envia reconexion hacia conax
  procedure p_pre_reconexion_conax(a_idtareawf in number,
                                   a_idwf      in number,
                                   a_tarea     in number,
                                   a_tareadef  in number) is

  ln_codsolot solot.codsolot%type;
    --<4.0
    --lv_numregistro recargaproyectocliente.numregistro%type;
    lv_numregistro ope_srv_recarga_cab.numregistro%type;
    --ls_estado recargaproyectocliente.estado%type;
    ls_estado ope_srv_recarga_cab.estado%type;
    --4.0>
  lv_resultado varchar2(10);
  lv_mensaje varchar2(4000);
  ln_pid insprd.pid%type;
  ln_idcupon cuponpago_dth.idcupon%type;
  lv_observacion TAREAWFSEG.observacion%type;
  ls_tipesttar esttarea.tipesttar%TYPE;
  --ln_idseq       number(10);--4.0
  ln_estinsprd insprd.estinsprd%type;
  ls_dscestprd estinsprd.descripcion%type;
  exception_reconexion exception;
  ln_codinssrv inssrv.codinssrv%type;
  ln_num_bouquet number; --4.0
  --ini 6.0
  ln_cont number;
  --fin 6.0
  begin

    select codsolot into ln_codsolot from wf where idwf = a_idwf;

      lv_numregistro := f_obtener_numregistro(ln_codsolot);

      --ini 6.0
      select count(1) into ln_cont
      from ope_srv_recarga_det
      where numregistro = lv_numregistro
       and tipsrv = (select valor
                       from constante
                      where constante = 'FAM_CABLE');
      --se ejecuta proceso en conax solo si tiene servicio DTH
      if ln_cont > 0 then
      --fin 6.0
        if lv_numregistro is not null then

          begin
          select idcupon
            into ln_idcupon
            from cuponpago_dth
            where codsolot = ln_codsolot;

          select a.estado, b.codinssrv, b.pid, c.estinsprd, d.descripcion
            into ls_estado, ln_codinssrv, ln_pid, ln_estinsprd, ls_dscestprd
          --<4.0
          /*from recargaproyectocliente a,
                                                 recargaxinssrv         b,*/
            from ope_srv_recarga_cab a,
                 ope_srv_recarga_det b,
                 --4.0>
                 insprd    c,
                 estinsprd d
            where a.numregistro = lv_numregistro
            and a.numregistro = b.numregistro
            and b.pid = c.pid
             and b.tipsrv =
                 (select valor from constante where constante = 'FAM_CABLE')
            and c.estinsprd = d.estinsprd;

            --se guarda la tarea
            --update recargaxinssrv --4.0
            update ope_srv_recarga_det --4.0
            set ulttareawf = a_idtareawf
            where numregistro = lv_numregistro
            and codinssrv = ln_codinssrv;
          exception
            when others then
              lv_observacion := 'Error: '|| sqlerrm;
              raise exception_reconexion;
          end;
        else
          lv_observacion := 'Error en obtencion de numero de registro.';
          raise exception_reconexion;
        end if;

        --como el pid debe estar en estado suspendido lo reconecta
        operacion.pq_dth.p_reconexion_dth(ln_pid,lv_resultado,lv_mensaje);
        if lv_resultado <> 'OK' then
        lv_observacion := 'Error en proceso de reconexion a conax: ' ||
                          lv_mensaje;
           raise exception_reconexion;
        else
           --se ingresa confirmacion como anotacion
           lv_observacion := 'Se envió el archivo a Conax.';
        insert into tareawfseg
          (idtareawf, observacion)
        values
          (a_idtareawf, lv_observacion);
        end if;
        --<4.0
        --reconexion de bouquests adicionales si aplica
      select count(1)
        into ln_num_bouquet
        from bouquetxreginsdth
        where numregistro = lv_numregistro
        and flg_transferir = 1;

        if ln_num_bouquet > 0 then
        operacion.pq_dth.p_reconexion_adic_dth(lv_numregistro,
                                               lv_resultado,
                                               lv_mensaje);
           if lv_resultado <> 'OK' then
          lv_observacion := 'Error en proceso de reconexion adicional a conax: ' ||
                            lv_mensaje;
             raise exception_reconexion;
           else
             update bouquetxreginsdth
             set flg_transferir = 0, fecultenv = sysdate
             where numregistro = lv_numregistro
               and flg_transferir = 1;

             --se ingresa confirmacion como anotacion
             lv_observacion := 'Se envió archivo adicional a Conax.';
          insert into tareawfseg
            (idtareawf, observacion)
          values
            (a_idtareawf, lv_observacion);

           end if;
        end if;
        --4.0>
    --ini 6.0
    else
    --cambia a estado no interviene
       OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,4,8,0,SYSDATE,SYSDATE);
    end if;
    --fin 6.0
  exception
    when exception_reconexion then
       --si la tarea es nulo entonces proviene de un cambio de estado
       if a_tarea is not null then
          --se ingresa el error como anotacion
        insert into tareawfseg
          (idtareawf, observacion)
        values
          (a_idtareawf, lv_observacion);

          SELECT tipesttar
            INTO ls_tipesttar
            FROM esttarea
           WHERE esttarea = cn_esttarea_error;

          --se cambia a estado error plataforma
          OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                           ls_tipesttar,
                                           cn_esttarea_error,
                                           0,
                                           SYSDATE,
                                           SYSDATE);
       else
          RAISE_APPLICATION_ERROR(-20500,
                                'No se pudo ejecutar la tarea: ' ||
                                lv_observacion);
       end if;
       return;
  end;

  PROCEDURE p_pos_actualizar_recarga(a_idtareawf IN NUMBER,
                                     a_idwf      IN NUMBER,
                                     a_tarea     IN NUMBER,
                                     a_tareadef  IN NUMBER) IS
    --<4.0
    /*IS
    BEGIN
      --la logica esta en el procedimiento pre
      p_pre_actualizar_recarga(a_idtareawf,
                                    a_idwf, \*a_tarea*\
                                    null,
                                    a_tareadef);
    END;

    PROCEDURE p_pre_actualizar_recarga(a_idtareawf IN NUMBER,
                                  a_idwf      IN NUMBER,
                                  a_tarea     IN NUMBER,
                                  a_tareadef  IN NUMBER) IS*/
    --4.0>
    ln_codsolot  solot.codsolot%type;
    ln_tiptrs    tiptrabajo.tiptrs%type;
    --ls_numslc    vtatabslcfac.numslc%type;--4.0
    --ln_num_cupon number;--4.0
    ln_idcupon   number;
    --lv_numregistro recargaproyectocliente.numregistro%type; --4.0
    lv_numregistro ope_srv_recarga_cab.numregistro%type; --4.0
    lv_observacion TAREAWFSEG.observacion%type;
    ls_tipesttar   esttarea.tipesttar%TYPE;
    exception_recarga exception;
    --ls_estado recargaproyectocliente.estado%type; --4.0
    ls_estado       ope_srv_recarga_cab.estado%type; --4.0
    ln_diasalerta   number;
    ln_diasgracia   number;
    ln_diasvigencia number;
    ld_fecinivig    date;
    ld_fecfinvig    date;
    ld_fecalerta    date;
    ld_feccorte     date;
    ld_fecact_cdma  date;
    --<4.0
    ld_fecbaja_cdma date;
    ln_idctrlcorte  control_corte_dth.idctrlcorte%type;
    ln_estinsprd    insprd.estinsprd%type;
    ln_num_web      number;
    ln_flg_recarga  ope_srv_recarga_cab.flg_recarga%type;
    ln_tipo_tarea   tareawfcpy.tipo%type; --0:normal,1:opcional, 2:automatica
    ln_tipo_error   number; --0:mensaje error, 1:cambia a estado "con errores"
    ln_num_error    number;
    --4.0>
    --Ini 16.0
    --Ini 15.0
--    ln_procesar     number;
    --Fin 15.0
    --Fin 16.0
    --Ini 5.0
    --<31.0
      p_idpaq        NUMBER;
      lv_bouquet     VARCHAR2 (500);
    ln_codinssrv   inssrv.codinssrv%type;
      ln_pid         insprd.pid%type;
    --Fin 31.0>
    cursor c_recarga_det(p_numregistro ope_srv_recarga_det.numregistro%type) is
    select a.numregistro,
           a.codinssrv,
           a.tipsrv,
           a.codsrv,
           a.fecact,
           a.fecbaja,
           a.pid,
           a.estado,
           a.ulttareawf
      from ope_srv_recarga_det a
    where a.numregistro = p_numregistro
      and a.tipsrv in
           (select c.valor from constante c where c.constante = 'FAM_CABLE');
    --Fin 5.0
    -- ini 14.0
    cursor c_bouquetxreginsdth(ac_numregistro ope_srv_recarga_det.numregistro%type) is
      select x.*
        from bouquetxreginsdth x
       where x.numregistro = ac_numregistro
         and x.estado = 1; --solo transfiere los activos
    -- fin 14.0
    --ini 6.0
    ln_idcupon_extorno                  cuponpago_dth.idcupon%type;
    ln_cuenta_extorno_reconec           number;
    ld_fecinivig_ant                    ope_srv_recarga_cab.fecinivig%type;
    ld_fecfinvig_ant                    ope_srv_recarga_cab.fecfinvig%type;
    ld_fecalerta_ant                    ope_srv_recarga_cab.fecalerta%type;
    ld_feccorte_ant                     ope_srv_recarga_cab.feccorte%type;
    ln_estinsprd_ant                    estinsprd.estinsprd%type;
    lc_estado_ant                       ope_srv_recarga_cab.estado%type;
    ld_desde cuponpago_dth.desde%type;
    ld_hasta cuponpago_dth.hasta%type;
    ln_tipbqd ope_srv_recarga_cab.tipbqd%type;
    --fin 6.0
    --Ini 12.0
    lc_numslc                           ope_srv_recarga_cab.numslc%type;
    lc_codigo_recarga                   ope_srv_recarga_cab.codigo_recarga%type;
    --Fin 12.0
  begin

    SELECT codsolot INTO ln_codsolot FROM wf WHERE idwf = a_idwf;

    --se averigua tipo de transaccion
    select b.tiptrs
      into ln_tiptrs
      from solot a, tiptrabajo b
     where a.tiptra = b.tiptra
       and codsolot = ln_codsolot;

    lv_numregistro := f_obtener_numregistro(ln_codsolot);

    if lv_numregistro is not null then
        select estado
          into ls_estado
        --from recargaproyectocliente --4.0
          from ope_srv_recarga_cab --4.0
         where numregistro = lv_numregistro;

       --ini 6.0
        --Verificamos si la sot es una sot de extorno de recarga y reconexión
        begin
          select idcupon
            into ln_idcupon_extorno
            from cuponpago_dth
           where codsolot_extorno = ln_codsolot;

          select count(1)
            into ln_cuenta_extorno_reconec
            from cortedth_web
           where idcupon = ln_idcupon_extorno;

        exception
           when others then
           ln_idcupon_extorno := 0;
           ln_cuenta_extorno_reconec := 0;
        end;
        --fin 6.0


      --primera parte: se ejecuta las transacciones en los servicios
      --Ini 16.0
      --ini 6.0
      if ln_tiptrs is not null or ln_cuenta_extorno_reconec > 0 then
      --ini 15.0
      /*if ln_tiptrs is not null then
         ln_procesar := 0;
         if ln_tiptrs <> 3 then
            ln_procesar := 1;
         else
            if ln_cuenta_extorno_reconec > 0 then
               ln_procesar := 1;
            end if;
         end if;*/
      --fin 15.0
      --Fin 16.0
      --if ln_tiptrs is not null then
      --fin 6.0

        --4.0
        --activacion,suspension,reconexion,cancelacion --4.0
        --if ls_estado <> '02' then --4.0
        --Ini 16.0
        --ini 15.0
        --if ln_procesar = 1 then
        --fin 15.0
        --Fin 16.0
        begin
           OPERACION.PQ_SOLOT.P_ACTIVACION_AUTOMATICA(a_idtareawf,
                                                     a_idwf,
                                                     a_tarea,
                                                     a_tareadef);
        exception
          when others then
            lv_observacion := 'Error activacion de servicio: ' || sqlerrm;
            raise exception_recarga;
        end;
        --Ini 16.0
        --ini 15.0
        --end if;
        --fin 15.0
        --Fin 16.0
      end if; --4.0

      --ini 6.0
      --Verificamos si el cupón asociado a la sot esta siendo extornado
      if ln_idcupon_extorno = 0 then
      --fin 6.0
        --segunda parte: se realizan pasos adicionales --4.0
        if ln_tiptrs is not null then
          --4.0
          begin
            --activacion
            if ln_tiptrs = 1 then
              --se obtiene informacion de fechas de vigencia de recarga
              ld_fecinivig    := trunc(sysdate);
              ln_diasvigencia := billcolper.f_parametrosfac(655);
              ld_fecfinvig    := ld_fecinivig + ln_diasvigencia;
              ln_diasalerta   := billcolper.f_parametrosfac(651); -- dias previos a fin para generar alerta
              ld_fecalerta    := ld_fecinivig + ln_diasvigencia -
                                 ln_diasalerta;
              ln_diasgracia   := billcolper.f_parametrosfac(652); -- dias despues a fin para generar corte
              ld_feccorte     := ld_fecinivig + ln_diasvigencia +
                                 ln_diasgracia;

              --se cambia al estado instalado y se actualizan fechas de vigencia del bundle
              --update recargaproyectocliente --4.0
              update ope_srv_recarga_cab --4.0
                 set estado    = '02', --instalado
                     fecinivig = ld_fecinivig,
                     fecfinvig = ld_fecfinvig,
                     fecalerta = ld_fecalerta,
                     feccorte  = ld_feccorte
               where numregistro = lv_numregistro;

              --<4.0 se envia a INT
              --6.0
              /*select flg_recarga
                into ln_flg_recarga*/
                select flg_recarga,tipbqd,numslc,codigo_recarga into ln_flg_recarga,ln_tipbqd,lc_numslc,lc_codigo_recarga  -- 12.0
              --6.0
                from ope_srv_recarga_cab
               where numregistro = lv_numregistro;

              if ln_flg_recarga = 1 then
                --ini 6.0
                if ln_tipbqd = 4 then --solo se envia si es DTH
                --fin 6.0
                  --si esta en sistema recarga se envia a web
                  select count(1)
                    into ln_num_web
                    from reginsdth_web
                   where numregistro = lv_numregistro;

                  if ln_num_web = 0 then
                    ln_estinsprd := 1; --los registros deberian estar activos
                    insert into reginsdth_web
                      (numregistro,
                       fecinivig,
                       fecfinvig,
                       fecalerta,
                       feccorte,
                       estado,
                       dscestdth,
                       nomcli,
                       numslc,
                       codcli,
                       idpaq,
                       codsolot,
                       nrodoc,
                       idcontrato,
                       nrodoc_contrato,
                       estinsprd,
                       flgtransferir,
                       ruc,
                       codigo_recarga
                       )
                      select a.numregistro,
                             a.fecinivig,
                             a.fecfinvig,
                             a.fecalerta,
                             a.feccorte,
                             a.estado,
                             (select e.descripcion
                                from ope_estado_recarga e
                               where e.codestrec = a.estado) descestado,
                             (select nomcli
                                from vtatabcli
                               where codcli = a.codcli) nomcli,
                             a.numslc,
                             a.codcli,
                             a.idpaq,
                             a.codsolot,
                             b.nrodoc,
                             0 idcontrato,
                             null nrodoc_contrato,
                             ln_estinsprd,
                             0 flgtransferir,
                             (select decode(tipdide, '001', ntdide, '0000000000')
                                from vtatabcli
                               where codcli = a.codcli) ruc,
                             a.codigo_recarga
                        from ope_srv_recarga_cab a, vtatabpspcli b
                       where a.numslc = b.numslc
                         and a.numregistro = lv_numregistro;
                     --Ini 5.0: Se registra el detalla en la tabla de INT
                     for r_recarga_det in c_recarga_det(lv_numregistro) loop
                         insert into rec_srv_recarga_det
                           (numregistro,
                            codinssrv,
                            tipsrv,
                            codsrv,
                            fecact,
                            fecbaja,
                            pid,
                            estado,
                            ulttareawf)
                         values
                           (r_recarga_det.numregistro,
                            r_recarga_det.codinssrv,
                            r_recarga_det.tipsrv,
                            r_recarga_det.codsrv,
                            r_recarga_det.fecact,
                            r_recarga_det.fecbaja,
                            r_recarga_det.pid,
                            r_recarga_det.estado,
                            r_recarga_det.ulttareawf);

                      --17.0: Cargamos el REC_INSSRV_CAB y el REC_INSPRD_DET
                      PQ_VTA_PAQUETE_RECARGA.P_INS_SERVICIO(r_recarga_det.codinssrv);

                     end loop;
                     --Fin 5.0
                     --Ini 14.0: Se registra el bouquetxreginsdth en la tabla de INT
                     delete from rec_bouquetxreginsdth_cab
                     where numregistro = lv_numregistro
                     and tipo in (0,1);
                       --<31.0
                              SELECT idpaq
                                INTO p_idpaq
                                FROM ope_srv_recarga_cab
                               WHERE numregistro = lv_numregistro;

                              SELECT DISTINCT
                                     TRIM (
                                        PQ_OPE_BOUQUET.f_conca_bouquet_srv (
                                           linea_paquete.codsrv))
                                        codigo_ext
                                INTO lv_bouquet                         --26.0
                                FROM paquete_venta,
                                     detalle_paquete,
                                     linea_paquete,
                                     producto,
                                     tystabsrv
                               WHERE paquete_venta.idpaq = p_idpaq
                                     AND paquete_venta.idpaq =
                                            detalle_paquete.idpaq
                                     AND detalle_paquete.iddet =
                                            linea_paquete.iddet
                                     AND detalle_paquete.idproducto =
                                            producto.idproducto
                                     AND detalle_paquete.flgestado = 1
                                     AND linea_paquete.flgestado = 1
                                     AND detalle_paquete.flgprincipal = 1
                                     --and producto.tipsrv = '0062' --10.0
                                     AND producto.tipsrv =
                                            (SELECT valor
                                               FROM constante
                                              WHERE constante = 'FAM_CABLE') --10.0
                                     AND linea_paquete.codsrv =
                                            tystabsrv.codsrv;

                              BEGIN
                                 UPDATE bouquetxreginsdth
                                    SET bouquets = lv_bouquet
                                  WHERE numregistro = lv_numregistro
                                        AND estado = 1;

                                 COMMIT;
                              EXCEPTION
                                 WHEN OTHERS
                                 THEN
                                    ROLLBACK;
                              END;

                              --31.0>
                     for c1 in c_bouquetxreginsdth(lv_numregistro) loop
                        insert into rec_bouquetxreginsdth_cab
                          (numregistro,
                           codsrv,
                           bouquets,
                           tipo,
                           estado,
                           codusu,
                           fecusu,
                           flg_transferir,
                           flg_rectransferir,
                           fecultenv,
                           usumod,
                           fecmod,
                           fecha_inicio_vigencia,
                           fecha_fin_vigencia,
                           idgrupo, --17.0
                           pid --17.0
                           )
                        values
                          (c1.numregistro,
                           c1.codsrv,
                           c1.bouquets,
                           c1.tipo,
                           c1.estado,
                           c1.codusu,
                           c1.fecusu,
                           c1.flg_transferir,
                           1,
                           c1.fecultenv,
                           c1.usumod,
                           c1.fecmod,
                           c1.fecha_inicio_vigencia,
                           c1.fecha_fin_vigencia,
                           c1.idgrupo, --17.0
                           c1.pid --17.0
                           );

                     end loop;
                     --Fin 14.0
                  end if;
                  --Ini 12.0
                    /* pq_fac_promo_linea_venta_nueva.p_registra_inst_prom(lc_numslc,2,lc_codigo_recarga,ln_num_error,lv_observacion);
                     if ln_num_error < 0 then
                        raise_application_error(-20500,
                                'Error pq_fac_promo_linea_venta_nueva.p_registra_inst_prom: ' ||
                                lv_observacion);
                     end if;
                     pq_fac_promo_linea_venta_nueva.p_aplica_promocion_activacion (lv_numregistro,ln_num_error,lv_observacion);
                     if ln_num_error < 0 then
                        raise_application_error(-20500,
                                'Error pq_fac_promo_linea_venta_nueva.p_aplica_promocion_activacion: ' ||
                                lv_observacion);
                     end if;
                  --Fin 12.0
                  --Ini 17.0: Actualizamos las fechas para los bouquets adicionales del tipo CNR
                  pq_VTA_paquete_recarga.p_app_servicio_adicional(lv_numregistro,
                                                                  ln_num_error,
                                                                  lv_observacion);

                  if ln_num_error < 0 then
                    raise_application_error(-20500,
                                            'Error en pq_paquete_recarga.p_app_servicio_adic: ' ||
                                            lv_observacion);
                  end if;*/
                  --Fin 17.0
                --ini 6.0
                end if;
                --fin 6.0
              end if;
              --4.0>

              begin
                select fecfin
                  into ld_fecact_cdma
                  from tareawf
                 where idwf = a_idwf
                   and tareadef in (select b.codigon
                                      from tipopedd a, opedd b
                                     where a.tipopedd = b.tipopedd
                                       and a.abrev = 'ACTCDMA');

                --update recargaxinssrv --4.0
                update ope_srv_recarga_det --4.0
                   set fecact = ld_fecact_cdma, estado = '02'
                 where numregistro = lv_numregistro
                   and tipsrv = (select valor
                                   from constante
                                  where constante = 'FAM_TELEF');
              exception
                when others then
                  null; --si no tiene registro de CDMA no hace nada
              end;

              if trunc(ld_fecact_cdma) <> ld_fecinivig then
                lv_observacion := 'SOT: ' || to_char(ln_codsolot) ||
                                  ', diferencia de fechas de activacion, OCS:' ||
                                  to_char(trunc(ld_fecact_cdma), 'dd/mm/yyyy') ||
                                  ', Bundle: ' ||
                                  to_char(ld_fecinivig, 'dd/mm/yyyy');
                insert into TAREAWFSEG
                  (IDTAREAWF, OBSERVACION, FLAG)
                values
                  (a_idtareawf, lv_observacion, 1);
                --P_ENVIA_CORREO_DE_TEXTO_ATT('Bundle DTH + CDMA', 'DL - PE - Carga Equipos Intraway SGA', ls_observacion);
              end if;

              --reconexion
            elsif ln_tiptrs = 4 then
            --ini 6.0
              /*select idcupon
                into ln_idcupon
                from cuponpago_dth
               where codsolot = ln_codsolot;*/
            begin
              select b.idcupon,a.desde, a.hasta into ln_idcupon,ld_desde, ld_hasta
              from cuponpago_dth_web a,cuponpago_dth b
              where a.idcupon = b.idcupon
              and b.codsolot = ln_codsolot;
            exception
              when no_data_found then
                lv_observacion := 'Error en obtención de cupon de pago.';
                raise exception_recarga;
            end;

            update ope_srv_recarga_cab
               set fecinivig   = ld_desde,
                   fecfinvig   = ld_hasta,
                   fecalerta   = ld_hasta - 3,
                   feccorte    = ld_hasta + 1,
                   estado = '02', --activado
                   flg_recarga = 1
            where numregistro = lv_numregistro;
           --fin 6.0

              --se da por procesada la reconexion
              update reconexiondth_web
                 set flgtransferir = 2
               where idcupon = ln_idcupon;
              --ini 6.0
              --update recargaproyectocliente --4.0
              /*update ope_srv_recarga_cab --4.0
                 set estado = '02' --activado
               where numregistro = lv_numregistro;*/
             --fin 6.0
              --<4.0
              --corte de servicio, suspension
            elsif ln_tiptrs = 3 then
              update ope_srv_recarga_cab
                 set estado = '03' --suspendido
               where numregistro = lv_numregistro;

              select max(idctrlcorte)
                into ln_idctrlcorte
                from operacion.control_corte_dth
               where numregistro = lv_numregistro
            --ini 6.0
              --and estcorte = 2;
              and estcorte in (1,2);
            --fin 6.0

              -- Se actualiza el control de los cortes se ha verificado
              update control_corte_dth
                 set estcorte = 3
               where idctrlcorte = ln_idctrlcorte;

              --baja de servicio, cancelacion
            elsif ln_tiptrs = 5 then
              update ope_srv_recarga_cab
                 set estado = '04' --cancelado
               where numregistro = lv_numregistro;

               --ini 10.0
               delete from reginsdth_web where numregistro = lv_numregistro;
               --fin 10.0

              begin
                select fecfin
                  into ld_fecbaja_cdma
                  from tareawf
                 where idwf = a_idwf
                   and tareadef in (select b.codigon
                                      from tipopedd a, opedd b
                                     where a.tipopedd = b.tipopedd
                                       and a.abrev = 'BAJACDMA');

                --update recargaxinssrv --4.0
                update ope_srv_recarga_det --4.0
                   set fecbaja = ld_fecbaja_cdma
                 where numregistro = lv_numregistro
                   and tipsrv = (select valor
                                   from constante
                                  where constante = 'FAM_TELEF');
              exception
                when others then
                  null; --si no tiene registro de CDMA no hace nada
              end;
              --4.0>
        --<31.0
        -- Obtener el valor de los campos PID y CODINSSRV
         select d.codinssrv, d.pid
          into ln_codinssrv, ln_pid
          from ope_srv_recarga_det d
         where d.numregistro = lv_numregistro;

        -- Actualizar el campo ESTINSSRV de la Tabla INSSRV

        update inssrv
           set estinssrv = 3
         where codinssrv = ln_codinssrv;

         -- Actualizar el campo ESTINSPRD de la Tabla INSPRD

        update insprd
           set estinsprd = 3
         where pid = ln_pid;
         --31.0>
         commit;

            end if;
          exception
            when others then
              lv_observacion := 'Error activacion recarga SGA: ' || sqlerrm;
              raise exception_recarga;
          end;
        --ini 6.0
        else
        --si es SOT de recarga
          begin
            select a.desde, a.hasta into ld_desde, ld_hasta
            from cuponpago_dth_web a,cuponpago_dth b
            where a.idcupon = b.idcupon
            and b.codsolot = ln_codsolot;
          exception
            when no_data_found then
              lv_observacion := 'Error en obtención de cupon de pago.';
              raise exception_recarga;
          end;
          update ope_srv_recarga_cab
             set fecinivig   = ld_desde,
                 fecfinvig   = ld_hasta,
                 fecalerta   = ld_hasta - 3,
                 feccorte    = ld_hasta + 1,
                 flg_recarga = 1
           where numregistro = lv_numregistro;

          --se da por transferido el registro de recarga
          update reginsdth_web
             set flgtransferir = 2
           where numregistro = lv_numregistro;
        --fin 6.0
        end if;
      --ini 6.0
      else
      -- Si se trata de una SOT de extorno de cupón
         begin
           select a.fecinivig_ant, a.fecfinvig_ant, a.fecalerta_ant,
                  a.feccorte_ant,  a.estinsprd_ant
             into ld_fecinivig_ant, ld_fecfinvig_ant, ld_fecalerta_ant,
                  ld_feccorte_ant, ln_estinsprd_ant
             from cuponpago_dth_web a
            where a.idcupon = ln_idcupon_extorno;
         exception
            when no_data_found then
              lv_observacion := 'Error en obtención de cupon de pago.';
              raise exception_recarga;
         end;

         if ln_estinsprd_ant = 1 then
            lc_estado_ant := '02';
         elsif ln_estinsprd_ant = 2 then
            lc_estado_ant := '03';
         end if;

         update ope_srv_recarga_cab a
            set fecinivig   = ld_fecinivig_ant,
                fecfinvig   = ld_fecfinvig_ant,
                fecalerta   = ld_fecalerta_ant,
                feccorte    = ld_feccorte_ant,
                estado      = lc_estado_ant,
                flg_recarga = 1
          where numregistro = lv_numregistro;

          --se da por transferido el registro de recarga
         update reginsdth_web
            set flgtransferir = 2
          where numregistro = lv_numregistro;

      end if;
      --fin 6.0

    else
      lv_observacion := 'Error en obtencion de numero de registro.';
      raise exception_recarga;
    end if;

    --<4.0
    /*if a_tarea is not null then
      SELECT tipesttar
                INTO ls_tipesttar
                FROM esttarea
               WHERE esttarea = cn_esttarea_cerrado;

      --se cambia a estado cerrado
              OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                               ls_tipesttar,
                                               cn_esttarea_cerrado,
                                               0,
                                               SYSDATE,
                                               SYSDATE);
    end if;*/
    --4.0>

  --ini 11.0
  begin
    pq_solot.p_chg_estado_solot(ln_codsolot, 29);
  exception
   when others then
    lv_observacion := 'Error al actualizar la SOT al estado Atendida: ' || sqlerrm;
    raise exception_recarga;
  end;
  --fin 11.0
  exception
    when exception_recarga then
      --<4.0
      --logica para gestion de errores
      select tipo
        into ln_tipo_tarea
        from tareawfcpy
       where idtareawf = a_idtareawf;

      if ln_tipo_tarea in (0, 1) then
        --si es tarea normal u opcional
        ln_tipo_error := 0; --mensaje error
      else
        --tarea automatica
        select count(1)
          into ln_num_error --se cuenta si paso por estado "con errores"
          from tareawfchg
         where idtareawf = a_idtareawf
           and esttarea = cn_esttarea_error;

        if ln_num_error > 0 then
          --si estuvo en estado error
          ln_tipo_error := 0; --mensaje error
        else
          --si es primera vez que se genera ta tarea
          ln_tipo_error := 1; --cambia a estado "con errores"
        end if;
      end if;
      --4.0>

      --si la tarea es nulo entonces proviene de un cambio de estado
      --if a_tarea is not null then --4.0
      if ln_tipo_error = 1 then
        --4.0
        --se ingresa el error como anotacion
        insert into tareawfseg
          (idtareawf, observacion)
        values
          (a_idtareawf, lv_observacion);

        SELECT tipesttar
          INTO ls_tipesttar
          FROM esttarea
         WHERE esttarea = cn_esttarea_error;

        --se cambia a estado error plataforma
        OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                         ls_tipesttar,
                                         cn_esttarea_error,
                                         0,
                                         SYSDATE,
                                         SYSDATE);
      else
        RAISE_APPLICATION_ERROR(-20500,
                                'No se pudo ejecutar la tarea: ' ||
                                lv_observacion);
      end if;
      return;
  end;

  --2.0>

--<4.0
   --se envia corte hacia conax
   PROCEDURE p_chg_corte_conax(a_idtareawf in number,
                                      a_idwf      in number,
                                      a_tarea     in number,
                                      a_tareadef  in number,
                                      a_tipesttar in number,
                                      a_esttarea  in number,
                                      a_mottarchg in number,
                                      a_fecini    in date,
                                      a_fecfin    in date) IS

      ls_esttarea_old tareawf.esttarea%type;

   BEGIN
      begin
         select esttarea
           into ls_esttarea_old
           from tareawf
          where idtareawf = a_idtareawf;
      EXCEPTION
         WHEN OTHERS Then
            ls_esttarea_old := null;
      End;
      --ejecuta el proceso si cambia de un estado error a generado.
    IF ls_esttarea_old is not null AND ls_esttarea_old = cn_esttarea_error AND
         a_esttarea = cn_esttarea_new THEN
         --se coloca el a_tarea en null para identificar que proviene de un cambio de estado
      p_pre_corte_conax(a_idtareawf,
                                  a_idwf, /*a_tarea*/
                                  null,
                                  a_tareadef);
      end if;
   END;

  --se envia corte hacia conax
  procedure p_pre_corte_conax(a_idtareawf in number,
                              a_idwf      in number,
                              a_tarea     in number,
                              a_tareadef  in number) is

  ln_codsolot solot.codsolot%type;
  lv_numregistro ope_srv_recarga_cab.numregistro%type;
  ls_estado ope_srv_recarga_cab.estado%type;
  lv_resultado varchar2(10);
  lv_mensaje varchar2(4000);
  ln_pid insprd.pid%type;
    --ln_idcupon     cuponpago_dth.idcupon%type;--4.0
  lv_observacion TAREAWFSEG.observacion%type;
  ls_tipesttar esttarea.tipesttar%TYPE;
    --ln_idseq       number(10);--4.0
  ln_estinsprd insprd.estinsprd%type;
  ls_dscestprd estinsprd.descripcion%type;
  exception_corte exception;
  ln_codinssrv inssrv.codinssrv%type;
  --ini 6.0
  ln_cont number;
  ln_idcupon_extorno                  cuponpago_dth.idcupon%type;
  ln_cuenta_extorno_reconec           number;
  --fin 6.0
  begin

    select codsolot into ln_codsolot from wf where idwf = a_idwf;

    --ini 6.0
    --Verificamos si la sot es una sot de extorno de recarga y reconexión
    begin
      select idcupon
        into ln_idcupon_extorno
        from cuponpago_dth
       where codsolot_extorno = ln_codsolot;

      select count(1)
        into ln_cuenta_extorno_reconec
        from cortedth_web
       where idcupon = ln_idcupon_extorno;

    exception
       when others then
       ln_idcupon_extorno := 0;
       ln_cuenta_extorno_reconec := 0;
    end;

    if (ln_idcupon_extorno = 0 or ln_cuenta_extorno_reconec > 0) then
    --fin 6.0
        lv_numregistro := f_obtener_numregistro(ln_codsolot);

        --ini 6.0
        select count(1) into ln_cont
        from ope_srv_recarga_det
        where numregistro = lv_numregistro
         and tipsrv = (select valor
                         from constante
                        where constante = 'FAM_CABLE');
        --se ejecuta proceso en conax solo si tiene servicio DTH
        if ln_cont > 0 then
        --fin 6.0

          if lv_numregistro is not null then

            begin

              select a.estado,b.codinssrv,b.pid,c.estinsprd,d.descripcion
              into ls_estado,ln_codinssrv,ln_pid ,ln_estinsprd,ls_dscestprd
              from ope_srv_recarga_cab a,
                   ope_srv_recarga_det b,
                   insprd              c,
                   estinsprd           d
              where a.numregistro = lv_numregistro
              and a.numregistro = b.numregistro
              and b.pid = c.pid
               and b.tipsrv =
                   (select valor from constante where constante = 'FAM_CABLE')
              and c.estinsprd = d.estinsprd;

              --se guarda la tarea
              update ope_srv_recarga_det
              set ulttareawf = a_idtareawf
              where numregistro = lv_numregistro
              and codinssrv = ln_codinssrv;
            exception
              when others then
                lv_observacion := 'Error: '|| sqlerrm;
                raise exception_corte;
            end;
          else
            lv_observacion := 'Error en obtencion de numero de registro.';
            raise exception_corte;
          end if;

          --como el pid debe estar en estado activo, lo suspende
           operacion.pq_dth.p_corte_dth(ln_pid,lv_resultado,lv_mensaje);
           if lv_resultado <> 'OK' then
              lv_observacion := 'Error en proceso de corte a conax: '|| lv_mensaje;
              raise exception_corte;
           else
             --6.0
             -- Se actualiza el control de los cortes a enviado
              update control_corte_dth
              set estcorte = 2
              where codsolot = ln_codsolot;
              --6.0
              --se ingresa confirmacion como anotacion
              lv_observacion := 'Se envió el archivo a Conax.';

              insert into tareawfseg
                (idtareawf, observacion)
              values
                (a_idtareawf, lv_observacion);
           end if;

        --ini 6.0
        else
        --cambia a estado no interviene
           OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,4,8,0,SYSDATE,SYSDATE);
        end if;
    elsif (ln_idcupon_extorno > 0 or ln_cuenta_extorno_reconec = 0) then
       --cambia a estado no interviene
       OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,4,8,0,SYSDATE,SYSDATE);
    end if;
    --fin 6.0
  exception
    when exception_corte then
       --si la tarea es nulo entonces proviene de un cambio de estado
       if a_tarea is not null then
          --se ingresa el error como anotacion
        insert into tareawfseg
          (idtareawf, observacion)
        values
          (a_idtareawf, lv_observacion);

          SELECT tipesttar
            INTO ls_tipesttar
            FROM esttarea
           WHERE esttarea = cn_esttarea_error;

          --se cambia a estado error
          OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                           ls_tipesttar,
                                           cn_esttarea_error,
                                           0,
                                           SYSDATE,
                                           SYSDATE);
       else
          RAISE_APPLICATION_ERROR(-20500,
                                'No se pudo ejecutar la tarea: ' ||
                                lv_observacion);
       end if;
       return;
  end;

 --Verifica estado y fechas de vigencia en OCS
 PROCEDURE p_pos_verificacion_ocs(a_idtareawf in number,
                                    a_idwf      IN NUMBER,
                                    a_tarea     IN NUMBER,
                                    a_tareadef  IN NUMBER) IS

  ln_codsolot solot.codsolot%type;
  lv_numregistro ope_srv_recarga_cab.numregistro%type;
  ln_codinssrv inssrv.codinssrv%type;
  lv_resultado varchar2(10);
  lv_mensaje varchar2(4000);
  lv_subscriber inssrv.numero%type;
  lv_observacion TAREAWFSEG.observacion%type;
  ls_tipesttar esttarea.tipesttar%TYPE;
  exception_verificacion exception;
  ln_num number;
  ln_pid insprd.pid%type;
  ln_codnumtel numtel.codnumtel%type;
  ln_tiptrs tiptrabajo.tiptrs%type;
  lv_codcli vtatabcli.codcli%type;
  lr_cuenta_ocs int_informacion_cuenta%rowtype;
  ld_fecini_sga ope_srv_recarga_cab.fecinivig%type;
  ld_fecfin_sga ope_srv_recarga_cab.fecfinvig%type;
  ld_feccorte_sga ope_srv_recarga_cab.feccorte%type;
  ls_desc_estado_ocs opedd.descripcion%type;
  ls_cod_estado_sga ope_estado_recarga.cod_estado_1%type;
  ls_desc_estado_sga ope_estado_recarga.descripcion%type;
  lc_sql varchar2(4000);

  ln_tipo_tarea tareawfcpy.tipo%type; --0:normal,1:opcional, 2:automatica
  ln_tipo_error number; --0:mensaje error, 1:cambia a estado "con errores"
  ln_num_error number;

  begin

    select codsolot into ln_codsolot from wf where idwf = a_idwf;

    --se averigua tipo de transaccion
    select nvl(b.tiptrs, 0)
      into ln_tiptrs
    from solot a,tiptrabajo b
    where a.tiptra = b.tiptra
    and codsolot = ln_codsolot;

    lv_numregistro := f_obtener_numregistro(ln_codsolot);

    if lv_numregistro is not null then
      --se obtiene instancia de servicio de CDMA
      begin
        select c.numero,c.codnumtel,a.codinssrv,a.pid,b.codcli
        into lv_subscriber,ln_codnumtel,ln_codinssrv,ln_pid,lv_codcli
        from ope_srv_recarga_det a,inssrv b, numtel c
        where a.numregistro = lv_numregistro
           and a.tipsrv =
               (select valor from constante where constante = 'FAM_TELEF')
        and a.codinssrv = b.codinssrv
        and b.codinssrv = c.codinssrv;
      exception
        when no_data_found then
           lv_observacion := 'Error en obtencion de numero telefonico.';
           raise exception_verificacion;
      end;

      begin
        --se realiza la consulta a OCS
        null;
        /*PQ_INT_OPERACIONES_COMANDOS.p_maestro_operaciones_apl(OPE_OCS_CONSULTA, --operacion
                                      lv_codcli, --cliente
                                      lv_subscriber, --numero telefonico
                                      PLAT_OCS, --plataforma
                                      null, --numero de dias
                                      null, --saldo
                                      null, --pin
                                      null, --incidencia
                                      null, --departamento
                                      null, --usuario
                                      lv_resultado, --resultado
                                      lv_mensaje); --mensaje*/
      exception
        when others then
           lv_observacion := 'Error de consulta en OCS:' || sqlerrm;
           raise exception_verificacion;
      end;

      if lv_resultado <> PQ_FND_UTILITARIO_INTERFAZ.FND_ESTADO_EXITO then
        lv_observacion := 'No se pudo generar consulta a la plataforma, error:' ||
                          lv_mensaje;
        raise exception_verificacion;
      else
        begin
          --se obtiene la información de la cuenta en OCS
          select a.*
            into lr_cuenta_ocs
          from int_informacion_cuenta a
           where a.idreg = (select max(x.idreg)
          from int_informacion_cuenta x
          where x.codcli = lv_codcli
          and x.idcuenta = lv_subscriber
          and x.idplataforma = PLAT_OCS);

        exception
          when no_data_found then
            lv_observacion := 'No se encontro informacion de cuenta.';
            raise exception_verificacion;
          when others then
            lv_observacion := 'Error en obtencion de informacion de cuenta.';
            raise exception_verificacion;
        end;

        --si es suspension se verifica estado y fecha corte
        if ln_tiptrs = 3 then
          select feccorte
            into ld_feccorte_sga
          from ope_srv_recarga_cab
          where numregistro = lv_numregistro;

          select cod_estado_1,descripcion
          into ls_cod_estado_sga,ls_desc_estado_sga
          from ope_estado_recarga
           --si es suspension se compara con el estado posterior
           --(se actualiza despues en proc: p_pre_actualizar_recarga)
          where codestrec = '03'; --suspendido

          --se verifica fecha de suspension
          if trunc(lr_cuenta_ocs.fechasuspension) <> trunc(ld_feccorte_sga) then
            lv_observacion := 'Error en numero: ' || lv_subscriber ||
                              ', fecha de suspensión en OCS: ' ||
                              to_char(trunc(lr_cuenta_ocs.fechasuspension)) ||
                              ', fecha de suspensión en SGA: ' ||
                              to_char(trunc(ld_feccorte_sga));
            raise exception_verificacion;
          else
            --verificacion de estado, se compara si el estado actual en plataforma OCS
            --se encuentra en los estado de OCS que deberia tener segun el SGA
            lc_sql := 'select count(1) from dummy_ope where ';
            lc_sql := lc_sql || to_char(lr_cuenta_ocs.estado);
            lc_sql := lc_sql || ' in (' || ls_cod_estado_sga || ')';

            execute immediate lc_sql
              into ln_num;

            if ln_num = 0 then
              --se obtiene estado de OCS
              select a.descripcion
                into ls_desc_estado_ocs
              from opedd a, tipopedd b
              where a.tipopedd = b.tipopedd
              and b.abrev = 'ESTADO_OCS'
              and a.codigon = lr_cuenta_ocs.estado;

              lv_observacion := 'Error en numero: ' || lv_subscriber ||
                                ', estado en OCS: ' || ls_desc_estado_ocs ||
                                ', estado en SGA: '||ls_desc_estado_sga;
              raise exception_verificacion;
            end if;
          end if;

        --si es recarga y reconexion se verifica estado y fecha fin antes de recarga
        elsif ln_tiptrs in (0,4) then
          --se obtiene la informacion anterior a actualizacion de vigencia en el SGA
          select a.fecinivig_ant,a.fecfinvig_ant
          into ld_fecini_sga,ld_fecfin_sga
          from cuponpago_dth_web a, cuponpago_dth b
          where b.codsolot = ln_codsolot
          and a.idcupon = b.idcupon;

          --se obtiene estado actual en el SGA de OCS
          select b.cod_estado_1,b.descripcion
          into ls_cod_estado_sga,ls_desc_estado_sga
          from ope_srv_recarga_cab a, ope_estado_recarga b
          where a.numregistro = lv_numregistro
          and a.estado = b.codestrec;

          --verificacion de estado, se compara si el estado actual en plataforma OCS
          --se encuentra en los estado de OCS que deberia tener segun el SGA
          lc_sql := 'select count(1) from dummy_ope where ';
          lc_sql := lc_sql || to_char(lr_cuenta_ocs.estado);
          lc_sql := lc_sql || ' in (' || ls_cod_estado_sga || ')';

          execute immediate lc_sql
            into ln_num;

          if ln_num = 0 then
            --si es cero entonces no se paso verificacion de estado
            --se obtiene estado de OCS
            select a.descripcion
              into ls_desc_estado_ocs
            from opedd a, tipopedd b
            where a.tipopedd = b.tipopedd
            and b.abrev = 'ESTADO_OCS'
            and a.codigon = lr_cuenta_ocs.estado;

            lv_observacion := 'Error en numero: ' || lv_subscriber ||
                              ', estado en OCS: ' || ls_desc_estado_ocs ||
                              ', estado en SGA: '||ls_desc_estado_sga;
            raise exception_verificacion;
          --se verifica fecha de fin
          elsif trunc(lr_cuenta_ocs.valdate) <> trunc(ld_fecfin_sga) then
            lv_observacion := 'Error en numero: ' || lv_subscriber ||
                              ', fecha fin en OCS: ' ||
                              to_char(trunc(lr_cuenta_ocs.valdate)) ||
                              ', fecha fin en SGA: ' ||
                              to_char(trunc(ld_fecfin_sga));
            raise exception_verificacion;
          end if;
        end if;

      end if;
    else
      lv_observacion := 'Error en obtencion de numero de registro.';
      raise exception_verificacion;
    end if;

  exception
    when exception_verificacion then
       --logica para gestion de errores
      select tipo
        into ln_tipo_tarea
       from tareawfcpy
       where idtareawf = a_idtareawf;

      if ln_tipo_tarea in (0, 1) then
        --si es tarea normal u opcional
         ln_tipo_error := 0; --mensaje error
      else
        --tarea automatica
        select count(1)
          into ln_num_error --se cuenta si paso por estado "con errores"
         from tareawfchg
         where idtareawf = a_idtareawf
         and esttarea = cn_esttarea_error;

        if ln_num_error > 0 then
          --si estuvo en estado error
           ln_tipo_error := 0; --mensaje error
        else
          --si es primera vez que se genera ta tarea
           ln_tipo_error := 1; --cambia a estado "con errores"
         end if;
       end if;

       --si la tarea es nulo entonces proviene de un cambio de estado
       if ln_tipo_error = 1 then
            --se ingresa el error como anotacion
        insert into tareawfseg
          (idtareawf, observacion)
        values
          (a_idtareawf, lv_observacion);

            SELECT tipesttar
              INTO ls_tipesttar
              FROM esttarea
             WHERE esttarea = cn_esttarea_error;

            --se cambio a estado error
            OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                             ls_tipesttar,
                                             cn_esttarea_error,
                                             0,
                                             SYSDATE,
                                             SYSDATE);
         else
            RAISE_APPLICATION_ERROR(-20500, lv_observacion);
         end if;
         return;
  end;

 PROCEDURE p_pos_agendamiento(a_idtareawf in number,
                              a_idwf      IN NUMBER,
                              a_tarea     IN NUMBER,
                              a_tareadef  IN NUMBER) IS

    ln_codsolot solot.codsolot%type;
    ln_cont_agenda number;
    ln_tiptrs tiptrabajo.tiptrs%type;
    lv_numregistro ope_srv_recarga_cab.numregistro%type;
    ln_cont_puntos number;
    ln_tipsrv solot.tipsrv%type;
    ln_cont_srv number;
  begin
    select codsolot into ln_codsolot from wf where idwf = a_idwf;

    --se averigua tipo de transaccion
    select nvl(b.tiptrs, 0)
      into ln_tiptrs
    from solot a,tiptrabajo b
    where a.tiptra = b.tiptra
    and codsolot = ln_codsolot;

    select count(1)
      into ln_cont_agenda
    from agendamiento
    where codsolot = ln_codsolot;

    if ln_cont_agenda = 0 then
      RAISE_APPLICATION_ERROR(-20500,
                              'La SOT debe tener asociada una agenda');
    end if;

    --validacion de incluir todos los puntos
    if ln_tiptrs = 5 then

      select tipsrv into ln_tipsrv from solot where codsolot = ln_codsolot;

      if ln_tipsrv = PAQ_INALAMBRICO then

        select count(1)
          into ln_cont_puntos
        from solotpto
        where codsolot = ln_codsolot;

        if ln_cont_puntos > 0 then
          lv_numregistro := f_obtener_numregistro(ln_codsolot);
          if lv_numregistro is not null then
            select count(1)
              into ln_cont_srv
            from ope_srv_recarga_det
            where numregistro = lv_numregistro
               and codinssrv not in
                   (select codinssrv
                      from solotpto
                                 where codsolot = ln_codsolot);
            if ln_cont_srv > 0 then
              RAISE_APPLICATION_ERROR(-20500,
                                      'Faltan registrar puntos de servicio recargables');
            end if;
          else
            RAISE_APPLICATION_ERROR(-20500,
                                    'Error en validacion de puntos de servicio recargables');
          end if;
        else
          RAISE_APPLICATION_ERROR(-20500,
                                  'No se registraron puntos de servicio');
        end if;
      end if;
    end if;
  end;
--4.0>
--ini 6.0
  function f_obtener_tipbqd(a_numregistro ope_srv_recarga_cab.numregistro%type) return number is
   ln_tipbqd                               ope_srv_recarga_cab.tipbqd%type;
   ln_cantidad_srv                         number;
   ln_cantidad_srv_telefonia               number;
   ln_codsolot                        solot.codsolot%TYPE; --34.0
   begin
    select count(1) into ln_cantidad_srv
      from ope_srv_recarga_det
     where numregistro = a_numregistro;

    if ln_cantidad_srv > 1 then
       ln_tipbqd := 4;
    elsif ln_cantidad_srv = 1 then
       select count(1) into ln_cantidad_srv_telefonia
       from ope_srv_recarga_det a, inssrv b, numtel c
       where a.numregistro = a_numregistro
       and a.tipsrv =
          (select valor from constante where constante = 'FAM_TELEF')
       and a.codinssrv = b.codinssrv
       and b.codinssrv = c.codinssrv;

       if ln_cantidad_srv_telefonia = 1 then
          ln_tipbqd := 2;
       else
          ln_tipbqd := 4;
       end if;
    elsif ln_cantidad_srv = 0 then
    -- ini 34.0
      SELECT codsolot
        INTO ln_codsolot
        FROM ope_srv_recarga_cab
       WHERE numregistro = a_numregistro;
      -- Fin 34.0
    end if;

    return ln_tipbqd;

   exception
    when others then
      raise_application_error(-20500, 'Error en obtención del tipo de búsqueda.');
   end;
--fin 6.0

--ini 8.0
procedure p_cargar_equ_cdma( a_idtareawf in number,
                             a_idwf      in number,
                             a_tarea     in number,
                             a_tareadef  in number ) is

ln_idpaq paquete_venta.idpaq%type;
ln_orden       number;
ln_punto       number;
ln_codsolot    solot.codsolot%type;
ls_tipsrv      tystipsrv.tipsrv%type;
ln_punto_ori   number;
ln_punto_des   number;
v_observacion  varchar2(200);
ls_numslc      vtatabslcfac.numslc%type;
ln_tiptrs tiptrabajo.tiptrs%type;
ln_codsolot_ori solot.codsolot%type;
ls_numregistro ope_srv_recarga_cab.numregistro%type;
ln_estado number;

--equipos en venta inicial
cursor cur_equ is
select  a.idpaq,
        a.codequcom,
        equ.tipequ tipequope,
             (select max(cantidad)
                from linea_paquete
               where iddet = a.iddet
                 and codequcom = a.codequcom) cantidad,
        equ.costo,
         (SELECT count(1)
                FROM opedd a,tipopedd b
               WHERE a.tipopedd = b.tipopedd
                 and b.abrev = 'TIPEQU_CDMA'
         and trim(codigon) = equ.tipequ) Equipo,
         m.Preprm_Usd,
             (SELECT count(1)
                FROM opedd a,tipopedd b
               WHERE a.tipopedd = b.tipopedd
                 and b.abrev = 'RECUMASIVO'
                 and a.abreviacion = 'CDMA'
         and trim(codigoc) = trim(m.cod_sap)) Recuperable,
             (select codigon
                from opedd
               where tipopedd = 197
                 and trim(codigoc) = trim(m.cod_sap)) codeta
        from vtadetptoenl a,
             vtadetptoenl b,
             tystabsrv    c,
             equcomxope   ep,
             tipequ       equ,
             almtabmat    m
where a.codequcom is not null
and a.codequcom=ep.codequcom
and a.numslc = ls_numslc
and a.numslc = b.numslc
and a.numpto_prin = b.numpto
and b.codsrv = c.codsrv
and c.tipsrv = ls_tipsrv
and ep.codtipequ = equ.codtipequ
and equ.codtipequ = m.codmat
order by equ.codtipequ;

cursor cur_actividad_alta(ac_tipo varchar2) is
select a.codact, 1 cantidad, a.codeta, b.costo,b.moneda_id,b.codprec
from (SELECT to_number(codigoc) codact,codigon codeta
      FROM opedd a,tipopedd b
      WHERE a.tipopedd = b.tipopedd
       and b.abrev = 'ACTMASIVOALTA'
       and a.abreviacion = ac_tipo) a,
     actxpreciario b
 where a.codact = b.codact and b.activo = '1';

cursor cur_actividad_baja(ac_tipo varchar2) is
select a.codact, 1 cantidad, a.codeta, b.costo,b.moneda_id,b.codprec
from (SELECT to_number(codigoc) codact,codigon codeta
      FROM opedd a,tipopedd b
      WHERE a.tipopedd = b.tipopedd
       and b.abrev = 'ACTMASIVOBAJA'
       and a.abreviacion = ac_tipo) a,
     actxpreciario b
 where a.codact = b.codact and b.activo = '1';

ln_idagenda agendamiento.idagenda%type;
ln_cantidad solotptoequ.cantidad%type;
ln_tipprp solotptoequ.tipprp%type;
ln_costo solotptoequ.costo%type;
ln_flgreq solotptoequ.flgreq%type;
ln_num_tarjeta number;
ln_num_telefono number;
lc_tipo opedd.abreviacion%type;
ln_codeta number;
ln_cont_etapa number;
ln_codcon agendamiento.codcon%type;
lc_observacion varchar2(500);
exception_carga exception;
ln_tipo_tarea tareawfcpy.tipo%type; --0:normal,1:opcional, 2:automatica
ln_tipo_error number; --0:mensaje error, 1:cambia a estado "con errores"
ln_num_error number;
ls_tipesttar esttarea.tipesttar%type;
ln_flgingreso number;
ln_num_equipos number;
begin
  select codsolot into ln_codsolot from wf where idwf = a_idwf;

  select b.tiptrs
  into ln_tiptrs
  from solot a,tiptrabajo b
  where a.tiptra = b.tiptra
  and codsolot = ln_codsolot;

  select max(idagenda) into ln_idagenda
  from agendamiento
  where codsolot = ln_codsolot;

  if ln_idagenda is null then
    lc_observacion := 'No tiene agenda, por favor genere la agenda.';
    raise exception_carga;
  end if;

  select codcon into ln_codcon from agendamiento where idagenda = ln_idagenda;
  if ln_codcon is null then
    lc_observacion := 'Agenda no tiene contratista, por favor asignar.';
    --raise exception_carga;
  end if;

  if ln_tiptrs = 1 then

     select numslc into ls_numslc from solot where codsolot = ln_codsolot;

     select distinct a.idpaq
      into ln_idpaq
      from vtadetptoenl a, solot b
     where a.numslc = b.numslc
       and b.codsolot = ln_codsolot;

     select valor
      into ls_tipsrv
      from constante
     where constante = 'FAM_TELEF';

    operacion.p_get_punto_princ_solot( ln_codsolot,
                                       ln_punto,
                                       ln_punto_ori,
                                       ln_punto_des,
                                       ls_tipsrv);
    --ini 6.0
    select count(1) into ln_num_equipos
    from solotptoequ
    where codsolot = ln_codsolot;
    --si ya tiene equipos cargados no se inserta
    if ln_num_equipos = 0 then
    --fin 6.0
      --carga de equipos
      for c_e in cur_equ loop

          select nvl(max(orden), 0) + 1
          into ln_orden
          from solotptoequ
          where codsolot = ln_codsolot
          and punto = ln_punto;

          if c_e.codeta > 0 then
            if c_e.equipo >= 1 then
                v_observacion := 'ITTELMEX-EQU-CDMA';
                ln_costo := nvl(c_e.costo,0);
                ln_tipprp := 0;
                ln_cantidad := 1;
                ln_flgreq := 0;
                ln_flgingreso := 1;
            else
              --MATERIALES son NO Seriables
                v_observacion := 'ITTELMEX-MAT-CDMA';
                ln_costo := nvl(c_e.Preprm_Usd,0);
                ln_tipprp := 0;
                ln_cantidad := c_e.cantidad;
                ln_flgreq := 0;
                ln_flgingreso := 2;
            end if;

            insert into solotptoequ
             (codsolot,
             punto,
             orden,
             tipequ,
             CANTIDAD,
             TIPPRP,
             COSTO,
             flgsol,
             flgreq,
             codeta,
             tran_solmat,
             observacion,
             fecfdis,
             instalado,
             flg_ingreso,
             flginv,
             idagenda,
             fecins,
             recuperable,
             estado,
             codequcom)
            values
              (ln_codsolot,
               ln_punto,
               ln_orden,
               c_e.tipequope,
               ln_cantidad,
               ln_tipprp,
               ln_costo,
               1,
               ln_flgreq,
               c_e.codeta,
               null,
               v_observacion ,
               sysdate,
               1, --instalado
               ln_flgingreso,--flg ingreso
               1,--flg inv
               ln_idagenda,--agenda
               sysdate,
               c_e.recuperable,
               4,
               c_e.codequcom);
         end if;
      end loop;
    else
      --se actualiza con agenda
      update solotptoequ
      set idagenda = ln_idagenda
      where codsolot = ln_codsolot;
    end if;

  elsif ln_tiptrs = 5 then

    ls_numregistro := f_obtener_numregistro(ln_codsolot);

    if ls_numregistro is not null then
       select codsolot
          into ln_codsolot_ori
          from ope_srv_recarga_cab
       where numregistro = ls_numregistro;

       select valor
         into ls_tipsrv
         from constante
       where constante = 'FAM_TELEF';

       operacion.p_get_punto_princ_solot(ln_codsolot,
                                        ln_punto,
                                        ln_punto_ori,
                                        ln_punto_des,
                                        ls_tipsrv);
      --Carga de actividades
      select count(1)
        into ln_num_telefono
        from solotptoequ
       where codsolot = ln_codsolot_ori
         and tipequ in (select a.codigon
                          FROM opedd a, tipopedd b
                         where a.tipopedd = b.tipopedd
                           and b.abrev = 'TIPOEQU_TEL_CDMA');

      if ln_num_telefono <= 1 then
        if ln_num_telefono = 0 then
          lc_observacion := 'Error en obtención de un tipo de equipo telefónico en el detalle de equipos de la SOT.';
          raise exception_carga;
        elsif ln_num_telefono = 1 then
          lc_tipo := 'CDMA-1';
        end if;

        for reg_actividad_baja in cur_actividad_baja(lc_tipo) loop

          ln_codeta := reg_actividad_baja.codeta;

          select count(1)
            into ln_cont_etapa
            from solotptoeta
           where codsolot = ln_codsolot
             and codeta = ln_codeta
             and codcon = ln_codcon;

          if ln_cont_etapa = 1 then--Existe Etapa
             select orden, punto
               into ln_orden, ln_punto
               from solotptoeta
              where codsolot = ln_codsolot
                and codeta = ln_codeta
                and codcon = ln_codcon;
          else        --Genera la etapa en estado 15 : Preliquidacion
            select nvl(max(orden),0) + 1 into ln_orden from solotptoeta
            where codsolot = ln_codsolot and punto = ln_punto;

            insert into solotptoeta(codsolot,
                                    punto,
                                    orden,
                                    codeta,
                                    porcontrata,
                                    esteta,
                                    obs,
                                    Fecdis,
                                    codcon,
                                    fecini)
                             values(ln_codsolot,
                                    ln_punto,
                                    ln_orden,
                                    ln_codeta,
                                    1,
                                    15,
                                    '',
                                    null,
                                    ln_codcon,
                                    sysdate);
          end if;

          --Inserta la Actividad en la Etapa
          insert into solotptoetaact(codsolot,
                                     punto,
                                     orden,
                                     codact,
                                     canliq,
                                     cosliq,
                                     canins,
                                     candis,
                                     cosdis,
                                     Moneda_Id,
                                     observacion,
                                     codprecdis,
                                     codprecliq,
                                     flg_preliq,
                                     contrata)
                              values(ln_codsolot,
                                     ln_punto,
                                     ln_orden,
                                     reg_actividad_baja.codact,
                                     reg_actividad_baja.cantidad,
                                     reg_actividad_baja.costo,
                                     reg_actividad_baja.cantidad,
                                     reg_actividad_baja.cantidad,
                                     reg_actividad_baja.costo,
                                     reg_actividad_baja.moneda_id,
                                     '',
                                     reg_actividad_baja.codprec,
                                     reg_actividad_baja.codprec,
                                     1,
                                     1);
        end loop;
      end if;

    else
        lc_observacion := 'Error en obtencion de registro de instalación al cargar equipos de CDMA.';
        raise exception_carga;
    end if;
  end if;
exception
  when exception_carga then
    raise_application_error(-20500, lc_observacion);
  when others then
    raise_application_error(-20500,'Error en la carga de equipos de CDMA.'||sqlerrm);
end;
-- fin 8.0

--ini 13.0
  function f_obt_tipo_srv_rec(a_numregistro ope_srv_recarga_cab.numregistro%type) return number is
  /*
  Retorna: Retorna un número que identifica si el servicio es DTH, CDMA ó BUNDLE
  0: Servicio no registrado en las tablas bundle
  1: DTH
  2: CDMA
  3: BUNDLE
  4: Servicio registrado en las tablas bundle pero no es TFI o DTH
  */
   ln_tipo_srv_rec                         number;
   ln_cantidad_srv                         number;
   ln_cantidad_srv_telefonia               number;
   ln_cantidad_srv_tvsat                   number;
   begin
    select count(1) into ln_cantidad_srv
      from ope_srv_recarga_det
     where numregistro = a_numregistro;

    if ln_cantidad_srv > 1 then
       ln_tipo_srv_rec := 3;
    elsif ln_cantidad_srv = 1 then
       select count(1)
         into ln_cantidad_srv_telefonia
         from ope_srv_recarga_det
        where numregistro = a_numregistro
          and tipsrv =
              (select valor from constante where constante = 'FAM_TELEF');

       select count(1)
            into ln_cantidad_srv_tvsat
            from ope_srv_recarga_det
           where numregistro = a_numregistro
             and tipsrv =
                 (select valor from constante where constante = 'FAM_CABLE');

       if ln_cantidad_srv_telefonia = 1 then
          ln_tipo_srv_rec := 2;
       elsif ln_cantidad_srv_tvsat = 1 then
          ln_tipo_srv_rec := 1;
       else
          ln_tipo_srv_rec := 4;
       end if;
    elsif ln_cantidad_srv = 0 then
       ln_tipo_srv_rec := 0;
    end if;

    return ln_tipo_srv_rec;
   end;
--fin 13.0
  --ini 19.0
  procedure p_chg_desactivar_conax_dth( a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number,
                               a_tipesttar in number,
                               a_esttarea  in number,
                               a_mottarchg in number,
                               a_fecini    in date,
                               a_fecfin    in date) is

   ls_numregistro ope_srv_recarga_cab.numregistro%type;
   ln_codsolot solot.codsolot%type;
   begin
     SELECT codsolot INTO ln_codsolot FROM wf WHERE idwf = a_idwf;
     select operacion.pq_inalambrico.f_obtener_numregistro(ln_codsolot) into ls_numregistro from dual;
     --Validacion Tecnica CONAX
     update ope_srv_recarga_det
       set flg_verif_tec = 1
       where numregistro = ls_numregistro
       and tipsrv = (select valor from constante where constante = 'FAM_CABLE');
     /*Se inserto un registro en las anotaciones de la tarea*/
    insert into tareawfseg (idtareawf, observacion)
    values (a_idtareawf,'validacion Tecnica Conax automatica');
   end;
   --fin 19.0
  --ini 28.0
  procedure p_act_estado_equ(a_codsolot solot.codsolot%type) is
  begin
    --actualizar el estado de las tarjetas y decos
    update operacion.tabequipo_material
       set estado = 1
     where numero_serie in (select se.numserie
                              from operacion.solotptoequ se,
                                   (select iddet_deco iddet
                                      from operacion.tarjeta_deco_asoc
                                     where codsolot = a_codsolot
                                    union
                                    select iddet_tarjeta iddet
                                      from operacion.tarjeta_deco_asoc
                                     where codsolot = a_codsolot) tda
                             where se.codsolot = a_codsolot
                               and se.iddet = tda.iddet);

  exception
    when others then
      raise_application_error(-20500,
                              'Error al Actualizar el Estado de los Equipos.');
  end;
  --<29.0
 /*PROCEDURE p_consulta_dth(pv_numero_serie in varchar2,
                           pn_tipo         in number,
                           pv_nomcli       out marketing.vtatabcli.nomcli%type,
                           pv_estado       out varchar2,
                           pv_codresp      out varchar2,
                           pv_mesresp      out varchar2) is

  begin
    tim.sp_consulta_dth@dbl_bscs_bf(pv_numero_serie,
                                    pn_tipo,
                                    pv_nomcli,
                                    pv_estado,
                                    pv_codresp,
                                    pv_mesresp);

  exception
    when others then
      pv_nomcli  := Null;
      pv_codresp := 0;
      pv_mesresp := 'Error de Conexión a BSCS...';

  end;  */
  --29.0>
  --fin 28.0

-- INI 32.0
PROCEDURE p_cargar_datos_inalambrico_lte(a_idtareawf IN NUMBER,
                                         a_idwf      IN NUMBER,
                                         a_tarea     IN NUMBER,
                                         a_tareadef  IN NUMBER)
  --  Cuando se ingresa a Opciones por Tarea, en caso haya 0 registros, se inserta un registro en
  --  la tabla sales.vtatabpreope.
 IS
  ln_codsolot solot.codsolot%type;
  ls_numslc   vtatabslcfac.numslc%type;
  ls_codcli   vtatabcli.codcli%type;
  ln_num_reg  number;
BEGIN

  SELECT codsolot INTO ln_codsolot FROM wf WHERE idwf = a_idwf;

  select count(1)
    into ln_num_reg
    from ope_srv_recarga_cab
   where codsolot = ln_codsolot;

  if ln_num_reg = 0 then
    p_cargar_recarga(ln_codsolot);
  end if;
exception
  when others then
    raise_application_error(-20500,
                            'Error cargar datos inalambrico.' + sqlerrm);
END;

procedure p_cargar_equ_dth_lte(a_idtareawf in number,
                                 a_idwf      in number,
                                 a_tarea     in number,
                                 a_tareadef  in number) is
    ln_orden        number;
    ln_punto        number;
    ln_codsolot     solot.codsolot%type;
    ls_tipsrv       tystipsrv.tipsrv%type;
    ln_punto_ori    number;
    ln_punto_des    number;
    v_observacion   varchar2(200);
    ls_numslc       vtatabslcfac.numslc%type;
    ln_tiptrs       tiptrabajo.tiptrs%type;
    V_DESDECO       NUMBER; --36.0
    V_MIXDECO       NUMBER; --37.0
    ln_codsolot_old solot.codsolot%type;
    ln_cod_id_old   solot.cod_id_old%type;

    -- equipos sot anterior CAMBIO PLAN
    cursor cur_equ_old(lv_codequcom varchar2) is
      select equ_conax.grupo codigo,
             t.descripcion,
             se.numserie,
             se.mac,
             se.cantidad,
             0               sel,
             i.codinssrv,
             se.codsolot,
             se.punto,
             se.orden,
             a.cod_sap,
             se.tipequ,
             se.codequcom,
             se.observacion,
             se.iddet,
             se.recuperable,
             se.tipprp,
             se.costo,
             se.flgsol,
             se.flgreq
        from solotptoequ se,
             solot s,
             solotpto sp,
             inssrv i,
             tipequ t,
             almtabmat a,
             (select a.codigon tipequ, to_number(codigoc) grupo
                from opedd a, tipopedd b
               where a.tipopedd = b.tipopedd
                 and b.abrev in ('TIPEQU_DTH_CONAX', 'TIPEQU_LTE_TLF')) equ_conax
       where se.codsolot = s.codsolot
         and s.codsolot = sp.codsolot
         and se.punto = sp.punto
         and sp.codinssrv = i.codinssrv
         and t.tipequ = se.tipequ
         and a.codmat = t.codtipequ
         and se.codsolot = ln_codsolot_old
         and t.tipequ = equ_conax.tipequ
         and se.codequcom = lv_codequcom;

    --equipos en venta inicial
    cursor cur_equ(cv_tipsrv varchar2) is
      select a.idpaq,
             a.codequcom,
             equ.tipequ tipequope,
             a.cantidad cantidad,
             equ.costo,
             (select count(1)
                from opedd a, tipopedd b
               where a.tipopedd = b.tipopedd
                 and b.abrev in ('TIPEQU_DTH_CONAX', 'TIPEQU_LTE_TLF')
                 and trim(codigon) = equ.tipequ) Equipo,
             m.Preprm_Usd,
             (select count(1)
                from opedd a, tipopedd b
               where a.tipopedd = b.tipopedd
                 and b.abrev = 'RECUMASIVO'
                 and a.abreviacion in ('DTH', 'LTE')
                 and trim(codigoc) = trim(m.cod_sap)) Recuperable,
             (select codigon
                from opedd
               where tipopedd = 197
                 and trim(codigoc) = trim(m.cod_sap)) codeta,
             a.iddet
        from vtadetptoenl a,
             vtadetptoenl b,
             tystabsrv    c,
             equcomxope   ep,
             tipequ       equ,
             almtabmat    m
       where a.codequcom is not null
         and a.codequcom = ep.codequcom
         and a.numslc = ls_numslc
         and a.numslc = b.numslc
         and a.numpto_prin = b.numpto
         and b.codsrv = c.codsrv
         and c.tipsrv = cv_tipsrv
         and ep.codtipequ = equ.codtipequ
         and equ.codtipequ = m.codmat
       order by equ.codtipequ;

    cursor cur_actividad_alta(ac_tipo varchar2) is
      select a.codact,
             1 cantidad,
             a.codeta,
             b.costo,
             b.moneda_id,
             b.codprec
        from (select to_number(codigoc) codact, codigon codeta
                from opedd a, tipopedd b
               where a.tipopedd = b.tipopedd
                 and b.abrev = 'ACTMASIVOALTA'
                 and a.abreviacion = ac_tipo) a,
             actxpreciario b
       where a.codact = b.codact
         and b.activo = '1';

    cursor list_equ_old is
      select distinct codequcom
        from solotptoequ
       where codsolot = ln_codsolot_old;

    cursor cur_tipsrv is
      select i.tipsrv
        from operacion.inssrv i
       where i.codinssrv in
             (select sp.codinssrv
                from operacion.solotpto sp
               where sp.codsolot = ln_codsolot);

    --ini 42.0
    CURSOR C_EQU_OLD IS
      SELECT P.TIPO_SRV,
             P.CODSOLOT_NEW,
             P.CODTIPEQU,
             P.TIPO_ACCION,
             P.ACCION,
             SE.NUMSERIE,
             SE.MAC,
             SE.CANTIDAD,
             SE.CODSOLOT,
             SE.PUNTO,
             SE.ORDEN,
             SE.TIPEQU,
             SE.CODEQUCOM,
             SE.OBSERVACION,
             SE.IDDET,
             SE.RECUPERABLE,
             SE.TIPPRP,
             SE.COSTO,
             SE.FLGSOL,
             SE.FLGREQ
        FROM SOLOTPTOEQU                     SE,
             SOLOT                           S,
             OPERACION.SGAT_VISITA_PROTOTYPE P,
             SOLOT                           SN
       WHERE SE.CODSOLOT = S.CODSOLOT
         AND SE.CODEQUCOM = P.CODEQUCOM
         AND P.CODSOLOT_NEW = SN.CODSOLOT
         AND S.COD_ID = SN.COD_ID_OLD
         AND SN.CODSOLOT = ln_codsolot
         AND P.ACCION = 12;
    -- fin 42.0
    cursor c_equ_dth is
	  select x.numserie,
           x.idequipo,
           x.imei_esn_ua nro_serie_deco,
           (select distinct tma.idequipo
              from operacion.tabequipo_material tma
             where tma.numero_serie = x.nro_serie_tarjeta) idtarjeta,
           x.nro_serie_tarjeta
      from (select distinct equ.numserie,
                            tm.idequipo,
                            tm.imei_esn_ua,
                            (select distinct d.nro_serie_tarjeta
                               from operacion.tabequipo_material c,
                                    operacion.tarjeta_deco_asoc  d,
                                    solot                        sl
                              where sl.codcli = s.codcli
                                and sl.cod_id = s.cod_id_old
                                and sl.estsol in (12, 29)
                                and c.numero_serie = tm.numero_serie
                                and c.imei_esn_ua = tm.imei_esn_ua
                                and sl.codsolot = d.codsolot
                                and d.nro_serie_deco = c.imei_esn_ua
                                and c.tipo = 2
                                and not exists
                              (select 1
                                       from solot                        sot,
                                            solotptoequ                  ptoequ,
                                            operacion.tabequipo_material tem
                                      where sot.codsolot = ptoequ.codsolot
                                        and ptoequ.numserie = tem.numero_serie
                                        and tem.tipo = 2
                                        and sot.estsol in (12, 29)
                                        and sot.cod_id = sl.cod_id
                                        and ptoequ.numserie = c.numero_serie
                                        and ptoequ.estado = 12)) nro_serie_tarjeta
              from solotptoequ                  equ,
                   solot                        s,
                   tipequ                       te,
                   operacion.tabequipo_material tm
             where s.codsolot = equ.codsolot
               and te.tipequ = equ.tipequ
               and equ.numserie = tm.numero_serie
               and s.codsolot = ln_codsolot
               and tm.tipo = 2
               and equ.estado in (4, 15)) x;

    ln_idagenda    agendamiento.idagenda%type;
    ln_cantidad    solotptoequ.cantidad%type;
    ln_tipprp      solotptoequ.tipprp%type;
    ln_costo       solotptoequ.costo%type;
    ln_flgreq      solotptoequ.flgreq%type;
    ln_num_tarjeta number;
    lc_tipo        opedd.abreviacion%type;
    ln_codeta      number;
    ln_cont_etapa  number;
    ln_i           number;
    ln_codcon      agendamiento.codcon%type;
    lc_observacion varchar2(500);
    exception_carga exception;
    ln_flgingreso  number;
    ln_num_equipos number;
    ln_serie       operacion.solotptoequ.numserie%type; -- 33.0
    ln_mac         operacion.solotptoequ.mac%type; -- 33.0
    ln_codigon     NUMBER; --34.0
    ln_tiptra      NUMBER; --34.0
    V_VALOR        NUMBER; --35.0
    V_RPTA         VARCHAR2(200); -- 36.0
    V_CODRPTA      NUMBER; --36.0
    V_CAMBIOEQU    NUMBER; --36.0
    V_REPOSIEQU    NUMBER; --36.0
    ln_porta       number;
    ln_numsec      operacion.solot.numsec%type;
    ln_valida      number;
  begin
    select a.codsolot, b.numsec, t.tiptrs, t.tiptra, b.numslc, b.cod_id_old
      into ln_codsolot,
           ln_numsec,
           ln_tiptrs,
           ln_tiptra,
           ls_numslc,
           ln_cod_id_old
      from wf a, solot b, tiptrabajo t
     where a.idwf = a_idwf
       and a.codsolot = b.codsolot
       and b.tiptra = t.tiptra
       and a.valido = 1;

    select max(idagenda)
      into ln_idagenda
      from agendamiento
     where codsolot = ln_codsolot;

    --ini 35.00
    BEGIN
      SELECT NVL(op.codigoc, '0')
        INTO V_VALOR
        FROM opedd op
       WHERE op.abreviacion = 'ACT_CPLAN'
         AND op.tipopedd =
             (SELECT tipopedd
                FROM operacion.tipopedd b
               WHERE B.ABREV = 'CONF_WLLSIAC_CP');
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_VALOR := '0';
    END;
    --fin 35.00

    if ln_idagenda is null then
      lc_observacion := 'No tiene agenda, por favor genere la agenda.';
      --raise exception_carga; -- 34.0
    end if;
    BEGIN
      --36.0
      select codcon
        into ln_codcon
        from agendamiento
       where idagenda = ln_idagenda;
    EXCEPTION
      --36.0
      WHEN NO_DATA_FOUND THEN
        --36.0
        ln_codcon := null; --36.0
    END; --36.0
    if ln_codcon is null then
      lc_observacion := 'Agenda no tiene contratista, por favor asignar.';
      --raise exception_carga;
    end if;

    --SELECT codigon  --36.0
    SELECT distinct codigon --36.0
      INTO ln_codigon
      FROM opedd
     WHERE tipopedd = (SELECT tipopedd
                         FROM tipopedd
                        WHERE abrev = 'TIPO_TRANS_SIAC_LTE')
       AND abreviacion = 'WLL/SIAC - DECO ADICIONAL';

    --39.0 Ini
    V_DESDECO   := operacion.pq_deco_adicional_lte.get_parametro_deco_lte('WLL/SIAC - BAJA DECO ALQUILER',
                                                                                    0);
    V_CAMBIOEQU := operacion.pq_deco_adicional_lte.get_parametro_deco_lte('WLL/SIAC - CAMBIO DE EQUIPO',
                                                                                    0);
    V_REPOSIEQU := operacion.pq_deco_adicional_lte.get_parametro_deco_lte('WLL/SIAC - REPOSICION EQUIPO',
                                                                                    0);
    V_MIXDECO   := operacion.pq_deco_adicional_lte.get_parametro_deco_lte('WLL/SIAC - CAMBIO DE DECOS',
                                                                                    0);
    --39.0 Fin

    IF ln_tiptra = ln_codigon THEN
      operacion.pq_inalambrico.p_cargar_equ_dth_lte_deco(a_idtareawf,
                                                                   a_idwf,
                                                                   a_tarea,
                                                                   a_tareadef);
      --36.0 Ini
    ELSIF ln_tiptra = V_DESDECO THEN
      operacion.pq_inalambrico.SGASI_CARGA_EQU_DESDECO(ln_codsolot,
                                                                 V_CODRPTA,
                                                                 V_RPTA);
      IF V_CODRPTA <> 0 THEN
        lc_observacion := V_RPTA;
        RAISE exception_carga;
      END IF;
    ELSIF ln_tiptra IN (V_CAMBIOEQU, V_REPOSIEQU) THEN
      operacion.pq_inalambrico.SGASI_SINCR_CAMBIOEQU(ln_codsolot,
                                                               V_CODRPTA,
                                                               V_RPTA);
      IF V_CODRPTA <> 0 THEN
        lc_observacion := V_RPTA;
        RAISE exception_carga;
      END IF;
      --36.0 Fin
      --37.0 Ini
    ELSIF ln_tiptra = V_MIXDECO THEN
      operacion.pq_inalambrico.SGASI_CARGA_EQU_MIX_DECO(ln_codsolot,
                                                                  V_CODRPTA,
                                                                  V_RPTA);
      IF V_CODRPTA <> 0 THEN
        lc_observacion := V_RPTA;
        RAISE exception_carga;
      END IF;
      --37.0 Fin
    ELSE
      if ln_tiptrs = 1 then
        select valor
          into ls_tipsrv
          from constante
         where constante = 'FAM_CABLE';
        --solo se insertan registros si es instalacion

        for c_t in cur_tipsrv loop
          operacion.P_GET_PUNTO_PRINC_SOLOT(ln_codsolot,
                                                      ln_punto,
                                                      ln_punto_ori,
                                                      ln_punto_des,
                                                      c_t.tipsrv);
          select count(1)
            into ln_num_equipos
            from solotptoequ
           where codsolot = ln_codsolot
             and punto = ln_punto;
          --si ya tiene equipos cargados no se inserta
          if ln_num_equipos = 0 then
            --carga de equipos DTH
            for c_e in cur_equ(c_t.tipsrv) loop

              select NVL(max(ORDEN), 0) + 1
                into ln_orden
                from solotptoequ
               where codsolot = ln_codsolot
                 and punto = ln_punto;

              if c_e.codeta > 0 then
                if c_e.equipo >= 1 then
                  v_observacion := 'ITTELMEX-EQU-DTH';
                  ln_costo      := nvl(c_e.costo, 0);
                  ln_tipprp     := 0;
                  ln_cantidad   := 1;
                  ln_flgreq     := 0;
                  ln_flgingreso := 1;
                else
                  --MATERIALES son NO Seriables
                  v_observacion := 'ITTELMEX-MAT-DTH';
                  ln_costo      := nvl(c_e.Preprm_Usd, 0);
                  ln_tipprp     := 0;
                  ln_cantidad   := c_e.cantidad;
                  ln_flgreq     := 0;
                  ln_flgingreso := 2;
                end if;

                FOR ln_i IN 1 .. c_e.cantidad LOOP
                  -- ini 33.0
                  IF V_VALOR = 1 THEN
                    --35.00
                    if operacion.pq_siac_cambio_plan_lte.fnc_valida_cp_lte(ln_codsolot) = 1 then
                      -- 34.0
                      ln_serie := operacion.pq_siac_cambio_plan_lte.fnc_get_datos_cp(ls_numslc,
                                                   c_e.tipequope,
                                                   c_t.tipsrv,
                                                   'NUMSERIE');
                      ln_mac   := operacion.pq_siac_cambio_plan_lte.fnc_get_datos_cp(ls_numslc,
                                                   c_e.tipequope,
                                                   c_t.tipsrv,
                                                   'MAC');
                    end if;
                  END IF; --35.00

                  -- fin 33.0
                  select count(1)
                    into ln_porta
                    from solot s, vtatabslcfac t
                   where s.numslc = t.numslc
                     and t.flg_portable = 1
                     and s.codsolot = ln_codsolot;

                  if ln_porta > 0 and
                     operacion.pq_sga_janus.f_val_serv_tlf_sot(ln_codsolot) > 0 and
                     c_t.tipsrv = '0004' then

                    begin
                      select p.numero_portable
                        into ln_mac
                        from sales.int_negocio_proceso p
                       where p.codsolot = ln_codsolot -- SOT
                         and p.numsec = ln_numsec;
                    exception
                      when others then
                        ln_mac := null;
                    end;

                  end if;

                  insert into solotptoequ
                    (codsolot,
                     punto,
                     orden,
                     tipequ,
                     CANTIDAD,
                     TIPPRP,
                     COSTO,
                     flgsol,
                     flgreq,
                     codeta,
                     tran_solmat,
                     observacion,
                     fecfdis,
                     instalado,
                     flg_ingreso,
                     flginv,
                     idagenda,
                     fecins,
                     recuperable,
                     estado,
                     codequcom,
                     iddet,
                     numserie, -- 33.0
                     mac) -- 33.0
                  values
                    (ln_codsolot,
                     ln_punto,
                     ln_orden,
                     c_e.tipequope,
                     ln_cantidad, --cantidad
                     ln_tipprp, --tipprp
                     ln_costo, --costo
                     1,
                     ln_flgreq, --flgreq
                     c_e.codeta,
                     null, --transol mat
                     v_observacion, --observacion
                     sysdate,
                     1, --instalado
                     ln_flgingreso, --flg ingreso
                     1, --flg inv
                     ln_idagenda, --agenda
                     sysdate,
                     c_e.recuperable,
                     4,
                     c_e.codequcom,
                     c_e.iddet,
                     ln_serie, -- 33.0
                     ln_mac); -- 33.0

                  ln_orden := ln_orden + 1;

                END LOOP;
              end if;
            end loop;

          else
            --se actualiza con agenda
            update solotptoequ
               set idagenda = ln_idagenda
             where codsolot = ln_codsolot;
          end if;

          if ls_tipsrv = c_t.tipsrv then
            -- Solo para DTH - 0062
            --carga de actividades
            select count(1)
              into ln_num_tarjeta
              from solotptoequ
             where codsolot = ln_codsolot
               and tipequ in
                   (select a.codigon
                      from opedd a, tipopedd b
                     where a.tipopedd = b.tipopedd
                       and b.abrev = 'TIPOEQU_TARJETA_DTH');

            if ln_num_tarjeta <= 3 then
              if ln_num_tarjeta = 0 then
                lc_observacion := 'Error en obtencion de numero de tarjetas.';
                raise exception_carga;
              elsif ln_num_tarjeta = 1 then
                lc_tipo := 'DTH-1';
              elsif ln_num_tarjeta = 2 then
                lc_tipo := 'DTH-2';
              elsif ln_num_tarjeta = 3 then
                lc_tipo := 'DTH-3';
              end if;

              for reg_actividad_alta in cur_actividad_alta(lc_tipo) loop
                ln_codeta := reg_actividad_alta.codeta;

                select count(1)
                  into ln_cont_etapa
                  from solotptoeta
                 where codsolot = ln_codsolot
                   and codeta = ln_codeta
                   and codcon = ln_codcon;

                if ln_cont_etapa = 1 then
                  --Existe Etapa
                  select orden, punto
                    into ln_orden, ln_punto
                    from solotptoeta
                   where codsolot = ln_codsolot
                     and codeta = ln_codeta
                     and codcon = ln_codcon;
                else
                  --Genera la etapa en estado 15 : Preliquidacion
                  select NVL(max(ORDEN), 0) + 1
                    into ln_orden
                    from SOLOTPTOETA
                   where codsolot = ln_codsolot
                     and punto = ln_punto;

                  insert into solotptoeta
                    (codsolot,
                     punto,
                     orden,
                     codeta,
                     porcontrata,
                     esteta,
                     obs,
                     Fecdis,
                     codcon,
                     fecini)
                  values
                    (ln_codsolot,
                     ln_punto,
                     ln_orden,
                     ln_codeta,
                     1,
                     15,
                     '',
                     null,
                     ln_codcon,
                     sysdate);
                end if;

                --Inserta la Actividad en la Etapa
                insert into solotptoetaact
                  (codsolot,
                   punto,
                   orden,
                   codact,
                   canliq,
                   cosliq,
                   canins,
                   candis,
                   cosdis,
                   Moneda_Id,
                   observacion,
                   codprecdis,
                   codprecliq,
                   flg_preliq,
                   contrata)
                values
                  (ln_codsolot,
                   ln_punto,
                   ln_orden,
                   reg_actividad_alta.codact,
                   reg_actividad_alta.cantidad,
                   reg_actividad_alta.costo,
                   reg_actividad_alta.cantidad,
                   reg_actividad_alta.cantidad,
                   reg_actividad_alta.costo,
                   reg_actividad_alta.moneda_id,
                   '',
                   reg_actividad_alta.codprec,
                   reg_actividad_alta.codprec,
                   1,
                   1);
              end loop;

            end if;
          end if;

        end loop;

        -- ini 42.0 - Insertamos los Equipos  Dar de  Baja
        FOR C IN C_EQU_OLD LOOP

          SELECT NVL(MAX(PUNTO), 0)
            INTO LN_PUNTO
            FROM SOLOTPTOEQU
           WHERE CODSOLOT = C.CODSOLOT_NEW;

          SELECT NVL(MAX(ORDEN), 0) + 1
            INTO LN_ORDEN
            FROM SOLOTPTOEQU
           WHERE CODSOLOT = C.CODSOLOT_NEW
             AND PUNTO = LN_PUNTO;

          INSERT INTO SOLOTPTOEQU
            (CODSOLOT,
             PUNTO,
             ORDEN,
             TIPEQU,
             CANTIDAD,
             TIPPRP,
             COSTO,
             FLGSOL,
             FLGREQ,
             TRAN_SOLMAT,
             OBSERVACION,
             FECFDIS,
             INSTALADO,
             FLGINV,
             IDAGENDA,
             FECINS,
             RECUPERABLE,
             ESTADO,
             CODEQUCOM,
             IDDET,
             NUMSERIE,
             MAC)
          VALUES
            (C.CODSOLOT_NEW,
             LN_PUNTO,
             LN_ORDEN,
             C.TIPEQU,
             C.CANTIDAD,
             C.TIPPRP,
             C.COSTO,
             C.FLGSOL,
             C.FLGREQ,
             NULL,
             C.OBSERVACION,
             SYSDATE,
             1,
             1,
             LN_IDAGENDA,
             SYSDATE,
             C.RECUPERABLE,
             C.ACCION,
             C.CODEQUCOM,
             C.IDDET,
             C.NUMSERIE,
             C.MAC);

          LN_ORDEN := LN_ORDEN + 1;
          --ASOCIAMOS TARJETA A DAR DE BAJA
          INSERT INTO SOLOTPTOEQU
            (CODSOLOT,
             PUNTO,
             ORDEN,
             IDAGENDA,
             TIPEQU,
             CANTIDAD,
             TIPPRP,
             COSTO,
             FLGSOL,
             FLGREQ,
             TRAN_SOLMAT,
             OBSERVACION,
             FECFDIS,
             INSTALADO,
             FLGINV,
             FECINS,
             RECUPERABLE,
             ESTADO,
             CODEQUCOM,
             IDDET,
             NUMSERIE,
             MAC)
            SELECT DISTINCT C.CODSOLOT_NEW,
                            LN_PUNTO,
                            LN_ORDEN,
                            LN_IDAGENDA,
                            PTO.TIPEQU,
                            PTO.CANTIDAD,
                            PTO.TIPPRP,
                            PTO.COSTO,
                            PTO.FLGSOL,
                            PTO.FLGREQ,
                            PTO.TRAN_SOLMAT,
                            PTO.OBSERVACION,
                            PTO.FECFDIS,
                            PTO.INSTALADO,
                            PTO.FLGINV,
                            PTO.FECINS,
                            PTO.RECUPERABLE,
                            C.ACCION,
                            PTO.CODEQUCOM,
                            PTO.IDDET,
                            PTO.NUMSERIE,
                            PTO.MAC
              FROM SOLOTPTOEQU                 PTO,
                   OPERACION.TARJETA_DECO_ASOC T
             WHERE PTO.CODSOLOT = C.CODSOLOT
               AND T.NRO_SERIE_TARJETA = PTO.NUMSERIE
               AND T.NRO_SERIE_DECO = C.MAC;

        END LOOP;
        --fin 42.0

        --Ini 35.00
        IF V_VALOR = 1 THEN
          if operacion.pq_siac_cambio_plan_lte.sgafun_valida_cb_plan(ln_codsolot) = 1 then
            if operacion.pq_siac_cambio_plan_lte.sgafun_valida_cb_plan_visita(ln_codsolot) = 1 then
              begin
                operacion.pq_siac_cambio_plan_lte.sgasi_carga_equdth_lte_cp(ln_codsolot);
              exception
                when others then
                  null;
              end;
            else
              -- Actualizamos los Estado de los Equipos de CP LTE
              begin
                for c_equ in (select rowid,
                                     pto.codsolot,
                                     pto.tipequ,
                                     pto.estado,
                                     pto.codequcom,
                                     nvl((select distinct t.accion
                                           from OPERACION.SGAT_VISITA_PROTOTYPE T
                                          where t.codequcom = pto.codequcom
                                            and t.tipequ = pto.tipequ
                                            and t.codsolot_new =
                                                pto.codsolot),
                                         pto.estado) estado_new
                                from solotptoequ pto
                               where pto.codsolot = ln_codsolot
                                 and exists
                               (select 1
                                        from OPERACION.SGAT_VISITA_PROTOTYPE T
                                       where t.codequcom = pto.codequcom
                                         and t.tipequ = pto.tipequ
                                         and t.codsolot_new = pto.codsolot)) loop
                  update solotptoequ equ
                     set equ.estado = c_equ.estado_new
                   where rowid = c_equ.rowid;
                end loop;
              exception
                when others then
                  null;
              end;

              -- Update Asocia deco
              begin
                for easoc in c_equ_dth loop

                  select count(1)
                    into ln_valida
                    from operacion.tarjeta_deco_asoc td
                   where td.codsolot = ln_codsolot
                     and td.nro_serie_deco = easoc.nro_serie_deco
                     and td.nro_serie_tarjeta = easoc.nro_serie_tarjeta;

                  if ln_valida = 0 then

                    insert into operacion.tarjeta_deco_asoc
                      (CODSOLOT,
                       IDDET_DECO,
                       NRO_SERIE_DECO,
                       IDDET_TARJETA,
                       NRO_SERIE_TARJETA)
                    values
                      (ln_codsolot,
                       easoc.idequipo,
                       easoc.nro_serie_deco,
                       easoc.idtarjeta,
                       easoc.nro_serie_tarjeta);
                  end if;

                end loop;
              exception
                when others then
                  null;
              end;
            end if;
          end if;
        END IF;
        --fin 35.00
      end if;
    END IF;
    -- Fin 34.0
  exception
    when exception_carga then
      RAISE_APPLICATION_ERROR(-20500, lc_observacion);
    when others then
      raise_application_error(-20500,
                              'Error en cargar equipos de LTE.' || sqlerrm);
  end;

PROCEDURE p_cerrar_datos_inalambrico_lte(a_idtareawf IN NUMBER,
                                         a_idwf      IN NUMBER,
                                         a_tarea     IN NUMBER,
                                         a_tareadef  IN NUMBER)
IS
  ln_codsolot  solot.codsolot%type;
  ln_val_dat_i number;
BEGIN

  SELECT codsolot into ln_codsolot FROM wf WHERE idwf = a_idwf;

  begin
    select count(1)
      into ln_val_dat_i
      from ope_srv_recarga_cab
     where codsolot = ln_codsolot;
    if ln_val_dat_i = 0 then
      raise_application_error(-20500,
                              'Se debe de registrar los datos Inalambricos.');
    end if;
  exception
    when others then
      raise_application_error(-20500,
                              'Error en validacion de datos inalambrico.');
  end;
END;

PROCEDURE p_pos_agendamiento_lte(a_idtareawf in number,
                                 a_idwf      IN NUMBER,
                                 a_tarea     IN NUMBER,

                                 a_tareadef  IN NUMBER)
IS
  ln_codsolot    solot.codsolot%type;
  ln_cont_agenda number;
begin
  select codsolot into ln_codsolot from opewf.wf where idwf = a_idwf;

  select count(1)
    into ln_cont_agenda
    from agendamiento
   where codsolot = ln_codsolot;

  if ln_cont_agenda = 0 then
    RAISE_APPLICATION_ERROR(-20500,
                            'La SOT debe tener asociada una agenda');
  end if;
end;
-- FIN 32.0
  -- ini 34.0
  PROCEDURE p_cargar_equ_dth_lte_deco(a_idtareawf IN NUMBER,
                                      a_idwf      IN NUMBER,
                                      a_tarea     IN NUMBER,
                                      a_tareadef  IN NUMBER) IS
    ln_orden        NUMBER;
    ln_punto        NUMBER;
    ln_codsolot     solot.codsolot%TYPE;
    ls_tipsrv       tystipsrv.tipsrv%TYPE;
    ln_punto_ori    NUMBER;
    ln_punto_des    NUMBER;
    v_observacion   VARCHAR2(200);
    ls_numslc       vtatabslcfac.numslc%TYPE;
    ln_tiptrs       tiptrabajo.tiptrs%TYPE;
    ln_codsolot_ori solot.codsolot%TYPE;
    ls_numregistro  ope_srv_recarga_cab.numregistro%TYPE;
    ln_estado       NUMBER;
    --equipos en venta inicial
    CURSOR cur_equ(cv_tipsrv VARCHAR2) IS
      SELECT a.idpaq,
             a.codequcom,
             equ.tipequ tipequope,
             a.cantidad cantidad,
             equ.costo,
             (SELECT COUNT(1)
                FROM opedd a, tipopedd b
               WHERE a.tipopedd = b.tipopedd
                 AND b.abrev IN ('TIPEQU_DTH_CONAX', 'TIPEQU_LTE_TLF')
                 AND TRIM(codigon) = equ.tipequ) equipo,
             m.preprm_usd,
             (SELECT COUNT(1)
                FROM opedd a, tipopedd b
               WHERE a.tipopedd = b.tipopedd
                 AND b.abrev = 'RECUMASIVO'
                 AND a.abreviacion IN ('DTH', 'LTE')
                 AND TRIM(codigoc) = TRIM(m.cod_sap)) recuperable,
             (SELECT codigon
                FROM opedd
               WHERE tipopedd = 197
                 AND TRIM(codigoc) = TRIM(m.cod_sap)) codeta,
             a.iddet
        FROM vtadetptoenl a,
             vtadetptoenl b,
             tystabsrv    c,
             equcomxope   ep,
             tipequ       equ,
             almtabmat    m
       WHERE a.codequcom IS NOT NULL
         AND a.codequcom = ep.codequcom
         AND a.numslc = ls_numslc
         AND a.numslc = b.numslc
         AND a.numpto_prin = b.numpto
         AND b.codsrv = c.codsrv
         AND c.tipsrv = cv_tipsrv
         AND ep.codtipequ = equ.codtipequ
         AND equ.codtipequ = m.codmat
       ORDER BY equ.codtipequ;

    CURSOR cur_actividad_alta(ac_tipo VARCHAR2) IS
      SELECT a.codact,
             1 cantidad,
             a.codeta,
             b.costo,
             b.moneda_id,
             b.codprec
        FROM (SELECT to_number(codigoc) codact, codigon codeta
                FROM opedd a, tipopedd b
               WHERE a.tipopedd = b.tipopedd
                 AND b.abrev = 'ACTMASIVOALTA'
                 AND a.abreviacion = ac_tipo) a,
             actxpreciario b
       WHERE a.codact = b.codact
         AND b.activo = '1';

    ln_idagenda    agendamiento.idagenda%TYPE;
    ln_cantidad    solotptoequ.cantidad%TYPE;
    ln_tipprp      solotptoequ.tipprp%TYPE;
    ln_costo       solotptoequ.costo%TYPE;
    ln_flgreq      solotptoequ.flgreq%TYPE;
    ln_num_tarjeta NUMBER;
    lc_tipo        opedd.abreviacion%TYPE;
    ln_codeta      NUMBER;
    ln_cont_etapa  NUMBER;
    ln_i           NUMBER;
    ln_codcon      agendamiento.codcon%TYPE;
    lc_observacion VARCHAR2(500);
    exception_carga EXCEPTION;
    ln_tipo_tarea  tareawfcpy.tipo%TYPE;
    ln_tipo_error  NUMBER;
    ln_num_error   NUMBER;
    ls_tipesttar   esttarea.tipesttar%TYPE;
    ln_flgingreso  NUMBER;
    ln_num_equipos NUMBER;

  BEGIN
    SELECT codsolot INTO ln_codsolot FROM wf WHERE idwf = a_idwf;

    SELECT b.tiptrs
      INTO ln_tiptrs
      FROM solot a, tiptrabajo b
     WHERE a.tiptra = b.tiptra
       AND codsolot = ln_codsolot;

    SELECT MAX(idagenda)
      INTO ln_idagenda
      FROM agendamiento
     WHERE codsolot = ln_codsolot;

    IF ln_idagenda IS NULL THEN
      lc_observacion := 'No tiene agenda, por favor genere la agenda.';
      RAISE exception_carga;
    END IF;

    SELECT codcon
      INTO ln_codcon
      FROM agendamiento
     WHERE idagenda = ln_idagenda;
    IF ln_codcon IS NULL THEN
      lc_observacion := 'Agenda no tiene contratista, por favor asignar.';
      -- raise exception_carga;
    END IF;

    IF ln_tiptrs = 1 THEN
      SELECT valor
        INTO ls_tipsrv
        FROM constante
       WHERE constante = 'FAM_COMODATO';

      SELECT numslc INTO ls_numslc FROM solot WHERE codsolot = ln_codsolot;

      operacion.p_get_punto_princ_solot(ln_codsolot,
                                        ln_punto,
                                        ln_punto_ori,
                                        ln_punto_des,
                                        ls_tipsrv);

      SELECT COUNT(1)
        INTO ln_num_equipos
        FROM solotptoequ
       WHERE codsolot = ln_codsolot
         AND punto = ln_punto;

      IF ln_num_equipos = 0 THEN

        FOR c_e IN cur_equ(ls_tipsrv) LOOP

          SELECT nvl(MAX(orden), 0) + 1
            INTO ln_orden
            FROM solotptoequ
           WHERE codsolot = ln_codsolot
             AND punto = ln_punto;

          IF c_e.codeta > 0 THEN
            IF c_e.equipo >= 1 THEN
              v_observacion := 'ITTELMEX-EQU-LTE';
              ln_costo      := nvl(c_e.costo, 0);
              ln_tipprp     := 0;
              ln_cantidad   := 1;
              ln_flgreq     := 0;
              ln_flgingreso := 1;
            ELSE
              --MATERIALES son NO Seriables
              v_observacion := 'ITTELMEX-MAT-LTE';
              ln_costo      := nvl(c_e.preprm_usd, 0);
              ln_tipprp     := 0;
              ln_cantidad   := c_e.cantidad;
              ln_flgreq     := 0;
              ln_flgingreso := 2;
            END IF;

            FOR ln_i IN 1 .. c_e.cantidad LOOP
              INSERT INTO solotptoequ
                (codsolot,
                 punto,
                 orden,
                 tipequ,
                 cantidad,
                 tipprp,
                 costo,
                 flgsol,
                 flgreq,
                 codeta,
                 tran_solmat,
                 observacion,
                 fecfdis,
                 instalado,
                 flg_ingreso,
                 flginv,
                 idagenda,
                 fecins,
                 recuperable,
                 estado,
                 codequcom,
                 iddet)
              VALUES
                (ln_codsolot,
                 ln_punto,
                 ln_orden,
                 c_e.tipequope,
                 ln_cantidad,
                 ln_tipprp,
                 ln_costo,
                 1,
                 ln_flgreq,
                 c_e.codeta,
                 NULL,
                 v_observacion,
                 SYSDATE,
                 1,
                 ln_flgingreso,
                 1,
                 ln_idagenda,
                 SYSDATE,
                 c_e.recuperable,
                 4,
                 c_e.codequcom,
                 c_e.iddet);

              ln_orden := ln_orden + 1;
            END LOOP;
          END IF;
        END LOOP;

      ELSE
        UPDATE solotptoequ
           SET idagenda = ln_idagenda
         WHERE codsolot = ln_codsolot;
      END IF;

      -- Solo para DTH - 0062 -- 0050
      --carga de actividades

      SELECT COUNT(1)
        INTO ln_num_tarjeta
        FROM solotptoequ
       WHERE codsolot = ln_codsolot
         AND tipequ IN (SELECT a.codigon
                          FROM opedd a, tipopedd b
                         WHERE a.tipopedd = b.tipopedd
                           AND b.abrev = 'TIPOEQU_TARJETA_DTH');

      IF ln_num_tarjeta <= 3 THEN
        IF ln_num_tarjeta = 0 THEN
          lc_observacion := 'Error en obtencion de numero de tarjetas.';
          RAISE exception_carga;
        ELSIF ln_num_tarjeta = 1 THEN
          lc_tipo := 'LTE-1';
        ELSIF ln_num_tarjeta = 2 THEN
          lc_tipo := 'LTE-2';
        ELSIF ln_num_tarjeta = 3 THEN
          lc_tipo := 'LTE-3';
        END IF;

        FOR reg_actividad_alta IN cur_actividad_alta(lc_tipo) LOOP
          ln_codeta := reg_actividad_alta.codeta;

          SELECT COUNT(1)
            INTO ln_cont_etapa
            FROM solotptoeta
           WHERE codsolot = ln_codsolot
             AND codeta = ln_codeta
             AND codcon = ln_codcon;

          IF ln_cont_etapa = 1 THEN
            --Existe Etapa
            SELECT orden, punto
              INTO ln_orden, ln_punto
              FROM solotptoeta
             WHERE codsolot = ln_codsolot
               AND codeta = ln_codeta
               AND codcon = ln_codcon;
          ELSE
            --Genera la etapa en estado 15 : Preliquidacion
            SELECT nvl(MAX(orden), 0) + 1
              INTO ln_orden
              FROM solotptoeta
             WHERE codsolot = ln_codsolot
               AND punto = ln_punto;

            INSERT INTO solotptoeta
              (codsolot,
               punto,
               orden,
               codeta,
               porcontrata,
               esteta,
               obs,
               fecdis,
               codcon,
               fecini)
            VALUES
              (ln_codsolot,
               ln_punto,
               ln_orden,
               ln_codeta,
               1,
               15,
               '',
               NULL,
               ln_codcon,
               SYSDATE);
          END IF;

          --Inserta la Actividad en la Etapa
          INSERT INTO solotptoetaact
            (codsolot,
             punto,
             orden,
             codact,
             canliq,
             cosliq,
             canins,
             candis,
             cosdis,
             moneda_id,
             observacion,
             codprecdis,
             codprecliq,
             flg_preliq,
             contrata)
          VALUES
            (ln_codsolot,
             ln_punto,
             ln_orden,
             reg_actividad_alta.codact,
             reg_actividad_alta.cantidad,
             reg_actividad_alta.costo,
             reg_actividad_alta.cantidad,
             reg_actividad_alta.cantidad,
             reg_actividad_alta.costo,
             reg_actividad_alta.moneda_id,
             '',
             reg_actividad_alta.codprec,
             reg_actividad_alta.codprec,
             1,
             1);
        END LOOP;
      END IF;

    END IF;
  EXCEPTION
    WHEN exception_carga THEN
      raise_application_error(-20500, lc_observacion);
    WHEN OTHERS THEN
      raise_application_error(-20500,
                              'Error en cargar equipos de LTE.' || SQLERRM);
  END;
  -- fin 34.0

PROCEDURE sp_cambio_estado_sot(p_idtareawf tareawf.idtareawf%TYPE,
                               p_idwf      tareawf.idwf%TYPE,
                               p_tarea     tareawf.tarea%TYPE,
                               p_tareadef  tareawf.tareadef%TYPE) IS

  l_codsolot solot.codsolot%TYPE;
  l_wfdef    wf.wfdef%type;
  l_tiptra   solot.tiptra%type;
  ln_cont    number;

BEGIN

  SELECT t.codsolot, t.wfdef, s.tiptra
  into l_codsolot , l_wfdef, l_tiptra
  FROM wf t, solot s
  WHERE s.codsolot = t.codsolot
  and t.valido = 1
  and t.idwf = p_idwf;

  select count(1)
  into ln_cont
  from opedd o, tipopedd t
where t.tipopedd = o.tipopedd
   and t.abrev = 'VALCIERRETARMANTO'
   and o.codigon = l_tiptra
   and o.codigon_aux = l_wfdef
   and to_number(o.codigoc) = p_tareadef;

  if ln_cont > 0 then

   operacion.pq_solot.p_chg_estado_solot(l_codsolot, 29);

 end if;

EXCEPTION
  WHEN OTHERS THEN
  NULL;
END;
--36.0 Ini
PROCEDURE SGASI_CARGA_EQU_DESDECO(PI_CODSOLOT IN NUMBER,
                                  PO_COD      OUT NUMBER,
                                  PO_MSG      OUT VARCHAR2) IS

V_IDINTERACCION SALES.SISACT_POSTVENTA_DET_SERV_LTE.IDINTERACCION%TYPE;
V_TIPSRV        TYSTIPSRV.TIPSRV%TYPE;
V_PUNTO         SOLOTPTO.PUNTO%TYPE;
V_PUNTO_ORI     SOLOTPTO.PUNTO%TYPE;
V_PUNTO_DES     SOLOTPTO.PUNTO%TYPE;
V_NUM_EQUIPOS   NUMBER;
V_NUM_TARJETA   NUMBER;
V_NUMREGISTRO   OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE;
V_CODSOLOT_ORI  SOLOT.CODSOLOT%TYPE;
V_TIPO          OPEDD.ABREVIACION%TYPE;
V_CODETA        NUMBER;
V_CONT_ETAPA    NUMBER;
V_ORDEN         NUMBER;
V_COUNTER       NUMBER := 0;
V_AUX           NUMBER :=0;
EX_ERROR EXCEPTION;

CURSOR CUR_ACTIVIDAD(AC_TIPO VARCHAR2, TIPO VARCHAR2) IS
    SELECT A.CODACT, 1 CANTIDAD, A.CODETA, B.COSTO, B.MONEDA_ID, B.CODPREC
      FROM (SELECT TO_NUMBER(CODIGOC) CODACT, CODIGON CODETA
              FROM OPEDD A, TIPOPEDD B
             WHERE A.TIPOPEDD = B.TIPOPEDD
               AND B.ABREV = TIPO
               AND A.ABREVIACION = AC_TIPO) A,
           ACTXPRECIARIO B
     WHERE A.CODACT = B.CODACT
       AND B.ACTIVO = '1';

CURSOR CUR_ACTIVIDAD_BAJA(V_TIPO_TRANS CHAR) IS
      select (select IDPAQ
                from SALES.PAQUETE_VENTA
               WHERE OBSERVACION = 'PAQUETE 3 PLAY INALAMBRICO') IDPAQ,
             NULL CODEQUCOM,
             SPD.TIPEQU TIPEQUOPE,
             1 CANTIDAD,
             EQU.COSTO,
             M.PREPRM_USD,
             (SELECT COUNT(1)
                FROM OPEDD A, TIPOPEDD B
               WHERE A.TIPOPEDD = B.TIPOPEDD
                 AND B.ABREV = 'RECUMASIVO'
                 AND A.ABREVIACION IN ('DTH', 'LTE')
                 AND TRIM(CODIGOC) = TRIM(M.COD_SAP)) RECUPERABLE,
             (SELECT CODIGON
                FROM OPEDD
               WHERE TIPOPEDD = 197
                 AND TRIM(CODIGOC) = TRIM(M.COD_SAP)) CODETA,
             SPD.NUM_SERIE,
             TM.IMEI_ESN_UA MAC,
             'ITTELMEX-EQU-DTH' OBSERVACION,
             NULL TRAN_SOLMAT
        from SALES.SISACT_POSTVENTA_DET_SERV_LTE SPD,
             OPERACION.TIPEQU                    EQU,
             PRODUCCION.ALMTABMAT                M,
             OPERACION.TABEQUIPO_MATERIAL        TM
       WHERE SPD.IDINTERACCION = V_IDINTERACCION
         AND SPD.FLAG_ACCION = V_TIPO_TRANS
         AND EQU.CODTIPEQU = M.CODMAT
         AND TM.NUMERO_SERIE = SPD.NUM_SERIE
         AND EQU.TIPEQU = SPD.TIPEQU;

BEGIN
  PO_COD := 0;
  PO_MSG := 'OK';

  BEGIN
    SELECT DISTINCT S.IDINTERACCION
      INTO V_IDINTERACCION
      FROM OPERACION.SIAC_POSTVENTA_PROCESO  S
     WHERE S.CODSOLOT = PI_CODSOLOT;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      PO_MSG := 'ERROR: NO EXISTE NINGUNA INTERACCION PARA LA SOT ' || PI_CODSOLOT;
      RAISE EX_ERROR;
    WHEN TOO_MANY_ROWS THEN
      PO_MSG := 'ERROR: LA SOT ' || PI_CODSOLOT || ' TIENE CONFIGURADA MAS DE UNA INTERACCION';
      RAISE EX_ERROR;
  END;

  IF V_IDINTERACCION IS NULL THEN
        PO_MSG := 'ERROR: NO EXISTE INTERACCION PARA LA SOT ' || PI_CODSOLOT;
        RAISE EX_ERROR;
  END IF;

  BEGIN
    SELECT VALOR
      INTO V_TIPSRV
      FROM OPERACION.CONSTANTE
     WHERE CONSTANTE = 'FAM_CABLE';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      PO_MSG := 'ERROR: NO EXISTE NINGUN TIPO DE SERVICIO CONFIGURADO PARA LA SOT ' || PI_CODSOLOT;
      RAISE EX_ERROR;
  END;

  OPERACION.P_GET_PUNTO_PRINC_SOLOT(PI_CODSOLOT,
                                    V_PUNTO,
                                    V_PUNTO_ORI,
                                    V_PUNTO_DES,
                                    V_TIPSRV);

  SELECT COUNT(1)
    INTO V_NUM_EQUIPOS
    FROM OPERACION.SOLOTPTOEQU
   WHERE CODSOLOT = PI_CODSOLOT
     AND ESTADO = 12;

  IF V_NUM_EQUIPOS > 0 THEN
    V_NUMREGISTRO := F_OBTENER_NUMREGISTRO(PI_CODSOLOT);
    IF V_NUMREGISTRO IS NULL THEN
      PO_MSG := 'ERROR EN OBTENCION DE REGISTRO DE INSTALACION AL CARGAR EQUIPOS DE DTH';
      RAISE EX_ERROR;
    END IF;

    SELECT CODSOLOT
      INTO V_CODSOLOT_ORI
    FROM OPERACION.OPE_SRV_RECARGA_CAB
    WHERE NUMREGISTRO = V_NUMREGISTRO;

    SELECT COUNT(1)
      INTO V_NUM_TARJETA
    FROM OPERACION.SOLOTPTOEQU
    WHERE CODSOLOT = V_CODSOLOT_ORI
         AND TIPEQU IN (SELECT A.CODIGON
                        FROM OPERACION.OPEDD A, OPERACION.TIPOPEDD B
                       WHERE A.TIPOPEDD = B.TIPOPEDD
                         AND B.ABREV = 'TIPOEQU_TARJETA_DTH');

     IF V_NUM_TARJETA <= 3 THEN

         IF V_NUM_TARJETA = 0 THEN
           PO_MSG := 'ERROR EN OBTENCION DE NUMERO DE TARJETAS';
           RAISE EX_ERROR;
         ELSIF V_NUM_TARJETA = 1 THEN
           V_TIPO := 'DTH-1';
         ELSIF V_NUM_TARJETA = 2 THEN
           V_TIPO := 'DTH-2';
         ELSIF V_NUM_TARJETA = 3 THEN
           V_TIPO := 'DTH-3';
         END IF;

         FOR REG_ACTIVIDAD_BAJA IN CUR_ACTIVIDAD(V_TIPO,'ACTMASIVOBAJA') LOOP

             V_CODETA := REG_ACTIVIDAD_BAJA.CODETA;

             SELECT COUNT(1)
              INTO V_CONT_ETAPA
             FROM OPERACION.SOLOTPTOETA
             WHERE CODSOLOT = PI_CODSOLOT
               AND CODETA = V_CODETA;

             IF V_CONT_ETAPA = 1 THEN
                  --EXISTE ETAPA
                  SELECT ORDEN, PUNTO
                    INTO V_ORDEN, V_PUNTO
                    FROM OPERACION.SOLOTPTOETA
                   WHERE CODSOLOT = PI_CODSOLOT
                     AND CODETA = V_CODETA;
             ELSE
                  --GENERA LA ETAPA EN ESTADO 15 : PRELIQUIDACION
                  SELECT NVL(MAX(ORDEN), 0) + 1
                    INTO V_ORDEN
                    FROM OPERACION.SOLOTPTOETA
                   WHERE CODSOLOT = PI_CODSOLOT
                     AND PUNTO = V_PUNTO;

                  INSERT INTO OPERACION.SOLOTPTOETA
                    (CODSOLOT,
                     PUNTO,
                     ORDEN,
                     CODETA,
                     PORCONTRATA,
                     ESTETA,
                     OBS,
                     FECDIS,
                     CODCON,
                     FECINI)
                  VALUES
                    (PI_CODSOLOT,
                     V_PUNTO,
                     V_ORDEN,
                     V_CODETA,
                     1,
                     15,
                     '',
                     NULL,
                     NULL,
                     SYSDATE);
             END IF;

             --INSERTA LA ACTIVIDAD EN LA ETAPA
            INSERT INTO OPERACION.SOLOTPTOETAACT
              (CODSOLOT,
               PUNTO,
               ORDEN,
               CODACT,
               CANLIQ,
               COSLIQ,
               CANINS,
               CANDIS,
               COSDIS,
               MONEDA_ID,
               OBSERVACION,
               CODPRECDIS,
               CODPRECLIQ,
               FLG_PRELIQ,
               CONTRATA)
            VALUES
              (PI_CODSOLOT,
               V_PUNTO,
               V_ORDEN,
               REG_ACTIVIDAD_BAJA.CODACT,
               REG_ACTIVIDAD_BAJA.CANTIDAD,
               REG_ACTIVIDAD_BAJA.COSTO,
               REG_ACTIVIDAD_BAJA.CANTIDAD,
               REG_ACTIVIDAD_BAJA.CANTIDAD,
               REG_ACTIVIDAD_BAJA.COSTO,
               REG_ACTIVIDAD_BAJA.MONEDA_ID,
               '',
               REG_ACTIVIDAD_BAJA.CODPREC,
               REG_ACTIVIDAD_BAJA.CODPREC,
               1,
               1);
         END LOOP;
     END IF;
     GOTO FIN;
  END IF;

  --Recorremos las bajas
  FOR B IN CUR_ACTIVIDAD_BAJA(C_BAJA) LOOP
    IF V_COUNTER = 0 THEN
      SELECT MIN(PUNTO)
        INTO V_PUNTO
        FROM OPERACION.SOLOTPTO A, OPERACION.INSSRV B
       WHERE CODSOLOT = PI_CODSOLOT
         AND A.CODINSSRV = B.CODINSSRV
         AND B.TIPSRV = V_TIPSRV;

      IF V_PUNTO = 0 THEN
        PO_MSG := 'ERROR EN OBTENCION DE PUNTO DE DETALLE AL CARGAR EQUIPOS DE DTH';
        RAISE EX_ERROR;
      END IF;

      SELECT NVL(MAX(ORDEN), 0) + 1
        INTO V_ORDEN
        FROM OPERACION.SOLOTPTOEQU
       WHERE CODSOLOT = PI_CODSOLOT
         AND PUNTO = V_PUNTO;
    END IF;

    INSERT INTO OPERACION.SOLOTPTOEQU
      (CODSOLOT,
       PUNTO,
       ORDEN,
       TIPEQU,
       CANTIDAD,
       TIPPRP,
       COSTO,
       NUMSERIE,
       FLGSOL,
       FLGREQ,
       CODETA,
       TRAN_SOLMAT,
       OBSERVACION,
       FECFDIS,
       ESTADO,
       MAC,
       CODEQUCOM,
       INSTALADO)
    VALUES
      (PI_CODSOLOT,
       V_PUNTO,
       V_ORDEN,
       B.TIPEQUOPE,
       B.CANTIDAD,
       0,
       NVL(B.COSTO, 0),
       B.NUM_SERIE,
       1,
       0,
       B.CODETA,
       B.TRAN_SOLMAT,
       B.OBSERVACION,
       SYSDATE,
       4,
       B.MAC,
       B.CODEQUCOM,
       1);

    V_ORDEN   := V_ORDEN + 1;
    V_COUNTER := V_COUNTER + 1;
    V_AUX     := V_AUX + 1;
  END LOOP;

 IF V_AUX = 0 THEN
   raise EX_ERROR;
   PO_MSG := 'ERROR AL DAR DE BAJA A EQUIPOS' || CHR(13) ||
             ' Linea Error: ' || dbms_utility.format_error_backtrace;
 END IF;
 <<FIN>>
  NULL;

EXCEPTION
  WHEN EX_ERROR THEN
      PO_COD := -1;
  WHEN OTHERS THEN
      PO_COD := -1;
      PO_MSG := $$PLSQL_UNIT ||
                           '.SGASI_CARGA_EQU_DESDECO: Error en cargar equipos de DTH ' ||
                           ' PI_CODSOLOT : ' || PI_CODSOLOT ||
                           ' Linea Error: ' || dbms_utility.format_error_backtrace ||
                           ' - ' || SQLERRM || '.';

END;

PROCEDURE SGASI_CARGAR_RECARGA(PI_IDTAREAWF IN NUMBER,
                               PI_IDWF      IN NUMBER,
                               PI_TAREA     IN NUMBER,
                               PI_TAREADEF  IN NUMBER) IS

V_FLG_RECARGA ope_srv_recarga_cab.flg_recarga%type := 0;
V_NUMREGISTRO ope_srv_recarga_cab.numregistro%type;
V_TIPBQD      ope_srv_recarga_cab.tipbqd%type;
V_CODSOLOT    operacion.solot.codsolot%type;
V_IDPAQ       NUMBER;
V_NUMSLC      OPERACION.OPE_SRV_RECARGA_CAB.numslc%type;
V_CODCLI      CHAR(8);
EX_ERROR      EXCEPTION;

    cursor cur_servicios is
    select DISTINCT a.codinssrv,a.codsrv,a.tipsrv
    from OPERACION.inssrv a, OPERACION.insprd b
    where a.codinssrv in(
           select distinct lte.codinssrv from sales.sisact_postventa_det_serv_lte lte
                  where lte.codsolot = V_CODSOLOT and lte.codinssrv is not null)
    and a.codinssrv = b.codinssrv
    and b.flgprinc = 1;

BEGIN

    BEGIN
      SELECT w.codsolot
      INTO V_CODSOLOT
      FROM opewf.wf w WHERE w.idwf = PI_IDWF
      AND w.valido = 1;
    EXCEPTION
      WHEN OTHERS THEN
          raise_application_error(-20500,
                            'ERROR AL OBTENER CÓDIGO DE SOT. ' + sqlerrm);
    END;
    BEGIN
      SELECT S.CODCLI
      INTO V_CODCLI
      FROM OPERACION.SOLOT S WHERE S.CODSOLOT = V_CODSOLOT;
    EXCEPTION
      WHEN OTHERS THEN
          raise_application_error(-20500,
                            'ERROR AL OBTENER CÓDIGO DE CLIENTE. ' + sqlerrm);
    END;

    V_IDPAQ := F_OBTENER_IDPAQ(V_CODSOLOT);

    V_NUMSLC := OPERACION.PQ_DECO_ADICIONAL_LTE.F_OBT_DATA_NUMSLC_ORI(V_CODSOLOT);

    INSERT INTO OPERACION.OPE_SRV_RECARGA_CAB
      (FLG_RECARGA, CODCLI, NUMSLC, CODSOLOT, IDPAQ, ESTADO, TIPDOCFAC, SERSUT, NUMSUT)
    VALUES
      (V_FLG_RECARGA,
       V_CODCLI,
       V_NUMSLC,
       V_CODSOLOT,
       V_IDPAQ,
       '01',
       'B/V',
       '00000',
       '00000000'
       )
       RETURNING NUMREGISTRO INTO V_NUMREGISTRO;

    FOR C_SERV IN CUR_SERVICIOS LOOP
      INSERT INTO OPERACION.OPE_SRV_RECARGA_DET
        (NUMREGISTRO, CODINSSRV, TIPSRV, CODSRV)
      VALUES
        (V_NUMREGISTRO,
           C_SERV.CODINSSRV,
           C_SERV.TIPSRV,
           C_SERV.CODSRV);
    END LOOP;

    BEGIN
      V_TIPBQD := F_OBTENER_TIPBQD(V_NUMREGISTRO);

      UPDATE OPERACION.OPE_SRV_RECARGA_CAB
         SET TIPBQD = V_TIPBQD
       WHERE NUMREGISTRO = V_NUMREGISTRO;
    EXCEPTION
      WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20500,
                                'ERROR EN OBTENCIÓN U/O ACTUALIZACIÓN DEL TIPO DE BÚSQUEDA DE SERVICIOS RECARGABLES');
    END;
EXCEPTION
  WHEN OTHERS THEN
      raise_application_error(-20500,
                            'ERROR AL CARGAR RECARGA. ' + sqlerrm);

END;
--36.0 Fin
--INI 36.0
  PROCEDURE SGASI_SINCR_CAMBIOEQU(PI_CODSOLOT IN NUMBER,
                                  PO_COD      OUT NUMBER,
                                  PO_MSG      OUT VARCHAR2) IS

    EX_ERROR EXCEPTION;
    V_PUNTO         SOLOTPTO.PUNTO%TYPE;
    V_PUNTOV        SOLOTPTO.PUNTO%TYPE;
    V_COSTO         OPERACION.TIPEQU.COSTO%TYPE;
    V_CODETA        NUMBER;
    V_OBSERVACION   VARCHAR2(100);
    V_TIPPRP        NUMBER;
    V_CANTIDAD      NUMBER;
    V_FLGREQ        NUMBER;
    V_FLGINGRESO    NUMBER;
    V_ORDEN         NUMBER;
    V_NUM_TARJETA   NUMBER;
    V_TIPO          OPEDD.ABREVIACION%TYPE;
    V_CONT_ETAPA    NUMBER;
    V_TIPSRV        TYSTIPSRV.TIPSRV%TYPE;
    V_IDINTERACCION SALES.SISACT_POSTVENTA_DET_SERV_LTE.IDINTERACCION%TYPE;
    V_COUNTER       NUMBER := 0;
    V_CODSOLOT_ORI  SOLOT.CODSOLOT%TYPE;
    LN_CONT_EQU     NUMBER := 0;
    LN_CONTINUA     NUMBER := 0;
    LN_VAL_DTH      NUMBER := 0;
    C_CA            constant char(2) := 'CA';
    V_COD_ID        SOLOT.COD_ID%TYPE; --44.0
    CURSOR CUR_ACTIVIDAD(AC_TIPO VARCHAR2, TIPO VARCHAR2) IS
      SELECT A.CODACT,
             1 CANTIDAD,
             A.CODETA,
             B.COSTO,
             B.MONEDA_ID,
             B.CODPREC
        FROM (SELECT TO_NUMBER(CODIGOC) CODACT, CODIGON CODETA
                FROM OPEDD A, TIPOPEDD B
               WHERE A.TIPOPEDD = B.TIPOPEDD
                 AND B.ABREV = TIPO
                 AND A.ABREVIACION = AC_TIPO) A,
             ACTXPRECIARIO B
       WHERE A.CODACT = B.CODACT
         AND B.ACTIVO = '1';

    CURSOR CUR_SISACT_POSTV_ALTA(V_TIPO_TRANS CHAR) IS
      SELECT INS.IDPAQ,
             (SELECT DISTINCT EQUC.CODEQUCOM
                FROM EQUCOMXOPE      EQUC,
                     TIPEQU          TE,
                     LINEA_PAQUETE   LP,
                     DETALLE_PAQUETE DP
               WHERE EQUC.TIPEQU = TE.TIPEQU
                 AND EQUC.CODTIPEQU = TE.CODTIPEQU
                 AND TE.TIPEQU = SPD.TIPEQU
                 AND LP.CODEQUCOM = EQUC.CODEQUCOM
                 AND LP.IDDET = DP.IDDET
                 AND DP.IDPAQ = INS.IDPAQ
                 AND ROWNUM = 1) CODEQUCOM,
             (SELECT COUNT(1)
                FROM OPEDD A, TIPOPEDD B
               WHERE A.TIPOPEDD = B.TIPOPEDD
                 AND B.ABREV IN ('TIPEQU_DTH_CONAX', 'TIPEQU_LTE_TLF')
                 AND TRIM(CODIGON) = EQU.TIPEQU) EQUIPO,
             SPD.TIPEQU TIPEQUOPE,
             1 CANTIDAD,
             EQU.COSTO,
             M.PREPRM_USD,
             (SELECT COUNT(1)
                FROM OPEDD A, TIPOPEDD B
               WHERE A.TIPOPEDD = B.TIPOPEDD
                 AND B.ABREV = 'RECUMASIVO'
                 AND A.ABREVIACION IN ('DTH', 'LTE')
                 AND TRIM(CODIGOC) = TRIM(M.COD_SAP)) RECUPERABLE,
             (SELECT CODIGON
                FROM OPEDD
               WHERE TIPOPEDD = 197
                 AND TRIM(CODIGOC) = TRIM(M.COD_SAP)) CODETA,
             SPD.NUM_SERIE,
             --44.0 Ini
             CASE
               WHEN (TM.TIPO = 1) or (TM.TIPO = 2) THEN
                TM.IMEI_ESN_UA
               WHEN (TM.TIPO = 3) or (TM.TIPO = 4) THEN
               (SELECT NUMERO
                  FROM INSSRV
                 WHERE CODINSSRV IN
                       (SELECT CODINSSRV
                          FROM SOLOTPTO
                         WHERE CODSOLOT = OPERACION.PQ_SGA_IW.F_MAX_SOT_X_COD_ID(V_COD_ID))
                   AND TIPSRV = (SELECT CODIGOC
                                   FROM OPEDD A, TIPOPEDD B
                                  WHERE A.TIPOPEDD = B.TIPOPEDD
                                    AND B.ABREV IN ('TRANS_POSTVENTA')
                                    AND TRIM(A.ABREVIACION) = 'TELEFONIA'))
             END MAC,
             CASE
               WHEN (TM.TIPO = 1) or (TM.TIPO = 2) THEN
                'ITCLARO-EQU-DTH'
               WHEN (TM.TIPO = 3) or (TM.TIPO = 4) THEN
                'ITCLARO-EQU-LTE'
             END OBSERVACION,
             --44.0 Fin
             NULL TRAN_SOLMAT,
             INS.TIPSRV,
             TM.IDEQUIPO IDDET
        from SALES.SISACT_POSTVENTA_DET_SERV_LTE SPD,
             OPERACION.TIPEQU                    EQU,
             PRODUCCION.ALMTABMAT                M,
             OPERACION.TABEQUIPO_MATERIAL        TM,
             inssrv                              ins
       WHERE SPD.IDINTERACCION = V_IDINTERACCION
         AND SPD.FLAG_ACCION IN (C_ALTA, C_CA)
         AND EQU.CODTIPEQU = M.CODMAT
         AND TM.NUMERO_SERIE = SPD.NUM_SERIE
         AND INS.CODINSSRV = SPD.CODINSSRV
         AND EQU.TIPEQU = SPD.TIPEQU;

    CURSOR CUR_SISACT_POSTV_BAJA(V_TIPO_TRANS CHAR) IS
      select INS.IDPAQ IDPAQ,
             (SELECT DISTINCT SPE.CODEQUCOM
                FROM OPERACION.SOLOTPTOEQU SPE, SOLOT SOT
               WHERE SPE.CODSOLOT = SOT.CODSOLOT
                 AND SOT.COD_ID = S.COD_ID
                 AND SOT.CUSTOMER_ID = S.CUSTOMER_ID
                 AND SPE.ESTADO IN (4, 15)
                 AND SPE.NUMSERIE = SPD.NUM_SERIE
                 AND SOT.ESTSOL IN (12, 29)) CODEQUCOM,
             SPD.TIPEQU TIPEQUOPE,
             1 CANTIDAD,
             EQU.COSTO,
             (SELECT DISTINCT SPE.IDDET
                FROM OPERACION.SOLOTPTOEQU SPE, SOLOT SOT
               WHERE SPE.CODSOLOT = SOT.CODSOLOT
                 AND SOT.COD_ID = S.COD_ID
                 AND SOT.CUSTOMER_ID = S.CUSTOMER_ID
                 AND SPE.ESTADO IN (4, 15)
                 AND SPE.NUMSERIE = SPD.NUM_SERIE
                 AND SOT.ESTSOL IN (12, 29)) IDDET,
             M.PREPRM_USD,
             (SELECT COUNT(1)
                FROM OPEDD A, TIPOPEDD B
               WHERE A.TIPOPEDD = B.TIPOPEDD
                 AND B.ABREV = 'RECUMASIVO'
                 AND A.ABREVIACION IN ('DTH', 'LTE')
                 AND TRIM(CODIGOC) = TRIM(M.COD_SAP)) RECUPERABLE,
             (SELECT CODIGON
                FROM OPEDD
               WHERE TIPOPEDD = 197
                 AND TRIM(CODIGOC) = TRIM(M.COD_SAP)) CODETA,
             SPD.NUM_SERIE,
             TM.IMEI_ESN_UA MAC,
             CASE TM.TIPO
               WHEN 1 THEN
                'ITCLARO-EQU-DTH'
               WHEN 2 THEN
                'ITCLARO-EQU-DTH'
               WHEN 3 THEN
                'ITCLARO-EQU-LTE'
               WHEN 4 THEN
                'ITCLARO-EQU-LTE'
             END OBSERVACION,
             NULL TRAN_SOLMAT,
             INS.TIPSRV,
             EQU.TIPO
        from SALES.SISACT_POSTVENTA_DET_SERV_LTE SPD,
             OPERACION.TIPEQU                    EQU,
             PRODUCCION.ALMTABMAT                M,
             OPERACION.TABEQUIPO_MATERIAL        TM,
             SOLOT                               S,
             inssrv                              ins
       WHERE SPD.IDINTERACCION = V_IDINTERACCION
         AND SPD.FLAG_ACCION = C_BAJA
         AND SPD.CODSOLOT = S.CODSOLOT
         AND EQU.CODTIPEQU = M.CODMAT
         AND TM.NUMERO_SERIE = SPD.NUM_SERIE
         AND INS.CODINSSRV = SPD.CODINSSRV
         AND EQU.TIPEQU = SPD.TIPEQU;

  BEGIN
    PO_COD := 0;
    PO_MSG := 'OK';

    BEGIN
      SELECT DISTINCT S.IDINTERACCION
        INTO V_IDINTERACCION
        FROM SALES.SISACT_POSTVENTA_DET_SERV_LTE S
       WHERE S.CODSOLOT = PI_CODSOLOT;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        PO_MSG := 'ERROR: NO EXISTE NINGUNA INTERACCIÓN PARA LA SOT ' ||
                  PI_CODSOLOT;
        RAISE EX_ERROR;
      WHEN TOO_MANY_ROWS THEN
        PO_MSG := 'ERROR: LA SOT ' || PI_CODSOLOT ||
                  ' TIENE CONFIGURADA MÁS DE UNA INTERACCIÓN';
    END;

    select valor
      into V_TIPSRV
      from constante
     where constante = 'FAM_CABLE';
    --44.0 Ini
    select cod_id 
      into V_COD_ID 
      from solot 
     where codsolot = PI_CODSOLOT;
    --44.0 Fin
    --Recorremos las altas
    FOR I IN CUR_SISACT_POSTV_ALTA(C_ALTA) LOOP

      OPERACION.P_GET_PUNTO_PRINC_SOLOT(PI_CODSOLOT,
                                        V_PUNTO,
                                        V_PUNTOV,
                                        V_PUNTOV,
                                        I.TIPSRV);

      SELECT NVL(MAX(ORDEN), 0) + 1
        INTO V_ORDEN
        FROM SOLOTPTOEQU
       WHERE CODSOLOT = PI_CODSOLOT
         AND PUNTO = V_PUNTO;

      IF I.CODETA > 0 THEN
        IF I.EQUIPO > 0 THEN
          V_OBSERVACION := 'ITTELMEX-EQU-DTH';
          V_COSTO       := NVL(I.COSTO, 0);
          V_TIPPRP      := 0;
          V_CANTIDAD    := 1;
          V_FLGREQ      := 0;
          V_FLGINGRESO  := 1;
        ELSE
          V_OBSERVACION := 'ITTELMEX-MAT-DTH';
          V_COSTO       := NVL(I.PREPRM_USD, 0);
          V_TIPPRP      := 0;
          V_CANTIDAD    := I.CANTIDAD;
          V_FLGREQ      := 0;
          V_FLGINGRESO  := 2;
        END IF;

        SELECT COUNT(1)
          INTO LN_CONT_EQU
          FROM SOLOTPTOEQU PTOEQU
         WHERE PTOEQU.CODSOLOT = PI_CODSOLOT
           AND PTOEQU.NUMSERIE = I.NUM_SERIE;

        IF LN_CONT_EQU = 0 THEN

          INSERT INTO SOLOTPTOEQU
            (CODSOLOT,
             PUNTO,
             ORDEN,
             TIPEQU,
             CANTIDAD,
             TIPPRP,
             COSTO,
             FLGSOL,
             FLGREQ,
             CODETA,
             TRAN_SOLMAT,
             OBSERVACION,
             FECFDIS,
             INSTALADO,
             FLG_INGRESO,
             FLGINV,
             IDAGENDA,
             FECINS,
             RECUPERABLE,
             ESTADO,
             CODEQUCOM,
             IDDET,
             NUMSERIE,
             MAC)
          VALUES
            (PI_CODSOLOT,
             V_PUNTO,
             V_ORDEN,
             I.TIPEQUOPE,
             V_CANTIDAD,
             V_TIPPRP,
             V_COSTO,
             1,
             V_FLGREQ,
             I.CODETA,
             NULL,
             V_OBSERVACION,
             SYSDATE,
             1,
             V_FLGINGRESO,
             1,
             NULL,
             SYSDATE,
             I.RECUPERABLE,
             4,
             I.CODEQUCOM,
             I.IDDET,
             I.NUM_SERIE,
             I.MAC);
        END IF;
      END IF;

      IF V_TIPSRV = I.TIPSRV THEN
        LN_VAL_DTH := LN_VAL_DTH + 1;
      END IF;

      V_ORDEN := V_ORDEN + 1;

    END LOOP;

    -- Carga de Actividades DTH Alta
    SELECT COUNT(1)
      INTO V_NUM_TARJETA
      FROM OPERACION.SOLOTPTOEQU
     WHERE CODSOLOT = PI_CODSOLOT
       AND TIPEQU IN (SELECT A.CODIGON
                        FROM OPEDD A, TIPOPEDD B
                       WHERE A.TIPOPEDD = B.TIPOPEDD
                         AND B.ABREV = 'TIPOEQU_TARJETA_DTH');

    --Carga para DTH
    IF LN_VAL_DTH > 0 then
      IF V_NUM_TARJETA <= 3 THEN
        IF V_NUM_TARJETA = 0 THEN
          PO_MSG := 'ERROR: ERROR EN OBTENCIÓN DE NÚMERO DE TARJETAS';
          RAISE EX_ERROR;
        ELSIF V_NUM_TARJETA = 1 THEN
          V_TIPO := 'DTH-1';
        ELSIF V_NUM_TARJETA = 2 THEN
          V_TIPO := 'DTH-2';
        ELSIF V_NUM_TARJETA = 3 THEN
          V_TIPO := 'DTH-3';
        END IF;

        FOR REG_ACTIVIDAD_ALTA IN CUR_ACTIVIDAD(V_TIPO, 'ACTMASIVOALTA') LOOP

          V_CODETA := REG_ACTIVIDAD_ALTA.CODETA;

          SELECT COUNT(1)
            INTO V_CONT_ETAPA
            FROM SOLOTPTOETA
           WHERE CODSOLOT = PI_CODSOLOT
             AND CODETA = V_CODETA;

          IF V_CONT_ETAPA = 1 THEN
            SELECT ORDEN, PUNTO
              INTO V_ORDEN, V_PUNTO
              FROM SOLOTPTOETA
             WHERE CODSOLOT = PI_CODSOLOT
               AND CODETA = V_CODETA;
          ELSE
            SELECT NVL(MAX(ORDEN), 0) + 1
              INTO V_ORDEN
              FROM SOLOTPTOETA
             WHERE CODSOLOT = PI_CODSOLOT
               AND PUNTO = V_PUNTO;

            INSERT INTO SOLOTPTOETA
              (CODSOLOT,
               PUNTO,
               ORDEN,
               CODETA,
               PORCONTRATA,
               ESTETA,
               OBS,
               FECINI)
            VALUES
              (PI_CODSOLOT, V_PUNTO, V_ORDEN, V_CODETA, 1, 15, '', SYSDATE);
          END IF;

          --INSERTA LA ACTIVIDAD EN LA ETAPA
          INSERT INTO SOLOTPTOETAACT
            (CODSOLOT,
             PUNTO,
             ORDEN,
             CODACT,
             CANLIQ,
             COSLIQ,
             CANINS,
             CANDIS,
             COSDIS,
             MONEDA_ID,
             OBSERVACION,
             CODPRECDIS,
             CODPRECLIQ,
             FLG_PRELIQ,
             CONTRATA)
          VALUES
            (PI_CODSOLOT,
             V_PUNTO,
             V_ORDEN,
             REG_ACTIVIDAD_ALTA.CODACT,
             REG_ACTIVIDAD_ALTA.CANTIDAD,
             REG_ACTIVIDAD_ALTA.COSTO,
             REG_ACTIVIDAD_ALTA.CANTIDAD,
             REG_ACTIVIDAD_ALTA.CANTIDAD,
             REG_ACTIVIDAD_ALTA.COSTO,
             REG_ACTIVIDAD_ALTA.MONEDA_ID,
             '',
             REG_ACTIVIDAD_ALTA.CODPREC,
             REG_ACTIVIDAD_ALTA.CODPREC,
             1,
             1);
        END LOOP;
      END IF;
    END IF;
    LN_VAL_DTH := 0; -- Reseteamos valor

    --Recorremos las baja dth
    FOR B IN CUR_SISACT_POSTV_BAJA(C_BAJA) LOOP

      OPERACION.P_GET_PUNTO_PRINC_SOLOT(PI_CODSOLOT,
                                        V_PUNTO,
                                        V_PUNTOV,
                                        V_PUNTOV,
                                        B.TIPSRV);

      SELECT NVL(MAX(ORDEN), 0) + 1
        INTO V_ORDEN
        FROM SOLOTPTOEQU
       WHERE CODSOLOT = PI_CODSOLOT
         AND PUNTO = V_PUNTO;

      SELECT COUNT(1)
        INTO LN_CONT_EQU
        FROM SOLOTPTOEQU PTOEQU
       WHERE PTOEQU.CODSOLOT = PI_CODSOLOT
         AND PTOEQU.NUMSERIE = B.NUM_SERIE;

      IF V_TIPSRV != B.TIPSRV THEN
        SELECT COUNT(DISTINCT SPD.NUM_SERIE)
          INTO LN_CONTINUA
          FROM SALES.SISACT_POSTVENTA_DET_SERV_LTE SPD, TIPEQU TE
         WHERE SPD.TIPEQU = TE.TIPEQU
           AND SPD.CODSOLOT = PI_CODSOLOT
           AND SPD.IDINTERACCION = V_IDINTERACCION
           AND SPD.FLAG_ACCION IN ('A', 'CA')
           AND TE.TIPO = B.TIPO;

      ELSE
        LN_CONTINUA := 1;
        LN_VAL_DTH  := LN_VAL_DTH + 1; -- Cable
      END IF;

      IF LN_CONT_EQU = 0 AND LN_CONTINUA != 0 THEN

        INSERT INTO SOLOTPTOEQU
          (CODSOLOT,
           PUNTO,
           ORDEN,
           TIPEQU,
           CANTIDAD,
           TIPPRP,
           COSTO,
           NUMSERIE,
           FLGSOL,
           FLGREQ,
           CODETA,
           TRAN_SOLMAT,
           OBSERVACION,
           FECFDIS,
           ESTADO,
           MAC,
           CODEQUCOM,
           INSTALADO,
           IDDET)
        VALUES
          (PI_CODSOLOT,
           V_PUNTO,
           V_ORDEN,
           B.TIPEQUOPE,
           B.CANTIDAD,
           0,
           NVL(B.COSTO, 0),
           B.NUM_SERIE,
           1,
           0,
           B.CODETA,
           B.TRAN_SOLMAT,
           B.OBSERVACION,
           SYSDATE,
           12,
           B.MAC,
           B.CODEQUCOM,
           1,
           B.IDDET);
      END IF;

      V_ORDEN   := V_ORDEN + 1;
      V_COUNTER := V_COUNTER + 1;

    END LOOP;

    --Carga de Actividades Baja DTH
    IF LN_VAL_DTH > 0 THEN

      SELECT OPERACION.PQ_SGA_IW.F_MAX_SOT_X_COD_ID(S.COD_ID)
        INTO V_CODSOLOT_ORI
        FROM SOLOT S
       WHERE CODSOLOT = PI_CODSOLOT;

      IF V_CODSOLOT_ORI = 0 THEN
        PO_MSG := 'ERROR: ERROR EN OBTENCIÓN SOT DE INSTALACIÓN AL CARGAR EQUIPOS DE DTH BAJA';
        RAISE EX_ERROR;
      END IF;

      SELECT COUNT(1)
        INTO V_NUM_TARJETA
        FROM SOLOTPTOEQU
       WHERE CODSOLOT = V_CODSOLOT_ORI
         AND TIPEQU IN (SELECT A.CODIGON
                          FROM OPEDD A, TIPOPEDD B
                         WHERE A.TIPOPEDD = B.TIPOPEDD
                           AND B.ABREV = 'TIPOEQU_TARJETA_DTH');

      IF V_NUM_TARJETA <= 3 THEN
        IF V_NUM_TARJETA = 0 THEN
          PO_MSG := 'ERROR: ERROR EN OBTENCIÓN DE NÚMERO DE TARJETAS';
          RAISE EX_ERROR;
        ELSIF V_NUM_TARJETA = 1 THEN
          V_TIPO := 'DTH-1';
        ELSIF V_NUM_TARJETA = 2 THEN
          V_TIPO := 'DTH-2';
        ELSIF V_NUM_TARJETA = 3 THEN
          V_TIPO := 'DTH-3';
        END IF;

        FOR REG_ACTIVIDAD_BAJA IN CUR_ACTIVIDAD(V_TIPO, 'ACTMASIVOBAJA') LOOP
          V_CODETA := REG_ACTIVIDAD_BAJA.CODETA;
          SELECT COUNT(1)
            INTO V_CONT_ETAPA
            FROM SOLOTPTOETA
           WHERE CODSOLOT = PI_CODSOLOT
             AND CODETA = V_CODETA;

          IF V_CONT_ETAPA = 1 THEN
            --EXISTE ETAPA
            SELECT ORDEN, PUNTO
              INTO V_ORDEN, V_PUNTO
              FROM SOLOTPTOETA
             WHERE CODSOLOT = PI_CODSOLOT
               AND CODETA = V_CODETA;
          ELSE
            --GENERA LA ETAPA EN ESTADO 15 : PRELIQUIDACION
            SELECT NVL(MAX(ORDEN), 0) + 1
              INTO V_ORDEN
              FROM SOLOTPTOETA
             WHERE CODSOLOT = PI_CODSOLOT
               AND PUNTO = V_PUNTO;

            INSERT INTO SOLOTPTOETA
              (CODSOLOT,
               PUNTO,
               ORDEN,
               CODETA,
               PORCONTRATA,
               ESTETA,
               OBS,
               FECDIS,
               CODCON,
               FECINI)
            VALUES
              (PI_CODSOLOT,
               V_PUNTO,
               V_ORDEN,
               V_CODETA,
               1,
               15,
               '',
               NULL,
               NULL,
               SYSDATE);
          END IF;

          --INSERTA LA ACTIVIDAD EN LA ETAPA
          INSERT INTO SOLOTPTOETAACT
            (CODSOLOT,
             PUNTO,
             ORDEN,
             CODACT,
             CANLIQ,
             COSLIQ,
             CANINS,
             CANDIS,
             COSDIS,
             MONEDA_ID,
             OBSERVACION,
             CODPRECDIS,
             CODPRECLIQ,
             FLG_PRELIQ,
             CONTRATA)
          VALUES
            (PI_CODSOLOT,
             V_PUNTO,
             V_ORDEN,
             REG_ACTIVIDAD_BAJA.CODACT,
             REG_ACTIVIDAD_BAJA.CANTIDAD,
             REG_ACTIVIDAD_BAJA.COSTO,
             REG_ACTIVIDAD_BAJA.CANTIDAD,
             REG_ACTIVIDAD_BAJA.CANTIDAD,
             REG_ACTIVIDAD_BAJA.COSTO,
             REG_ACTIVIDAD_BAJA.MONEDA_ID,
             '',
             REG_ACTIVIDAD_BAJA.CODPREC,
             REG_ACTIVIDAD_BAJA.CODPREC,
             1,
             1);
        END LOOP;
      END IF;
    END IF;

  EXCEPTION
    WHEN EX_ERROR THEN
      PO_COD := -1;
    WHEN OTHERS THEN
      PO_COD := -1;
      PO_MSG := 'Error en el proceso de Carga de Equipo (SGASI_SINCR_CAMBIOEQU)';
  END;
  --FIN 36.0
   --Ini 37.0
PROCEDURE SGASI_CARGA_EQU_MIX_DECO(PI_CODSOLOT IN NUMBER,
                                   PO_COD      OUT NUMBER,
                                   PO_MSG      OUT VARCHAR2) IS

  V_IDINTERACCION SALES.SISACT_POSTVENTA_DET_SERV_LTE.IDINTERACCION%TYPE;
  V_TIPSRVI        TYSTIPSRV.TIPSRV%TYPE;  --39.0
  V_TIPSRVD        TYSTIPSRV.TIPSRV%TYPE;  --39.0
  V_CO_ID         OPERACION.SOLOT.COD_ID%TYPE;
  V_CUSTOMER_ID   OPERACION.SOLOT.CUSTOMER_ID%TYPE;
  V_NUM_TARJETA   NUMBER;
  V_NUM_EQUIPOS   NUMBER;
  V_CONT_ETAPA    NUMBER;
  V_CODETA        NUMBER;
  V_PUNTO         SOLOTPTO.PUNTO%TYPE;
  V_PUNTOV        SOLOTPTO.PUNTO%TYPE;
  V_ORDEN         NUMBER;
  V_TIPO          OPEDD.ABREVIACION%TYPE;
  V_NUMREGISTRO   OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE;
  V_CODSOLOT_ORI  SOLOT.CODSOLOT%TYPE;
  V_COUNTER       NUMBER := 0;
  V_OBSERVACION   VARCHAR2(100);
  V_COSTO         OPERACION.TIPEQU.COSTO%TYPE;
  V_TIPPRP        NUMBER;
  V_CANTIDAD      NUMBER;
  V_FLGREQ        NUMBER;
  V_FLGINGRESO    NUMBER;
  V_NUMSLC       vtatabslcfac.numslc%TYPE;  --39.0
  EX_ERROR EXCEPTION;

  CURSOR CUR_ACTIVIDAD(AC_TIPO VARCHAR2, TIPO VARCHAR2) IS
    SELECT A.CODACT, 1 CANTIDAD, A.CODETA, B.COSTO, B.MONEDA_ID, B.CODPREC
      FROM (SELECT TO_NUMBER(CODIGOC) CODACT, CODIGON CODETA
          FROM OPEDD A, TIPOPEDD B
         WHERE A.TIPOPEDD = B.TIPOPEDD
           AND B.ABREV = TIPO
           AND A.ABREVIACION = AC_TIPO) A,
         ACTXPRECIARIO B
     WHERE A.CODACT = B.CODACT
       AND B.ACTIVO = '1';

  CURSOR CUR_ACTIVIDAD_ALTA(V_TIPO_TRANS CHAR) IS
  --39.0 Ini
  SELECT a.idpaq,
             a.codequcom,
             equ.tipequ tipequope,
             a.cantidad cantidad,
             equ.costo,
             (SELECT COUNT(1)
                FROM opedd a, tipopedd b
               WHERE a.tipopedd = b.tipopedd
                 AND b.abrev IN ('TIPEQU_DTH_CONAX', 'TIPEQU_LTE_TLF')
                 AND TRIM(codigon) = equ.tipequ) equipo,
             m.preprm_usd,
             (SELECT COUNT(1)
                FROM opedd a, tipopedd b
               WHERE a.tipopedd = b.tipopedd
                 AND b.abrev = 'RECUMASIVO'
                 AND a.abreviacion IN ('DTH', 'LTE')
                 AND TRIM(codigoc) = TRIM(m.cod_sap)) recuperable,
             (SELECT codigon
                FROM opedd
               WHERE tipopedd = 197
                 AND TRIM(codigoc) = TRIM(m.cod_sap)) codeta,
             a.iddet
        FROM vtadetptoenl a,
             vtadetptoenl b,
             tystabsrv    c,
             equcomxope   ep,
             tipequ       equ,
             almtabmat    m
       WHERE a.codequcom IS NOT NULL
         AND a.codequcom = ep.codequcom
         AND a.numslc = V_NUMSLC
         AND a.numslc = b.numslc
         AND a.numpto_prin = b.numpto
         AND b.codsrv = c.codsrv
         AND c.tipsrv = V_TIPSRVI
         AND ep.codtipequ = equ.codtipequ
         AND equ.codtipequ = m.codmat
       ORDER BY equ.codtipequ;
  --39.0 Fin


  CURSOR CUR_ACTIVIDAD_BAJA(V_TIPO_TRANS CHAR) IS
      select (select IDPAQ
                from SALES.PAQUETE_VENTA
               WHERE OBSERVACION = 'PAQUETE 3 PLAY INALAMBRICO') IDPAQ,
             NULL CODEQUCOM,
             SPD.TIPEQU TIPEQUOPE,
             1 CANTIDAD,
             EQU.COSTO,
             M.PREPRM_USD,
             (SELECT COUNT(1)
                FROM OPEDD A, TIPOPEDD B
               WHERE A.TIPOPEDD = B.TIPOPEDD
                 AND B.ABREV = 'RECUMASIVO'
                 AND A.ABREVIACION IN ('DTH', 'LTE')
                 AND TRIM(CODIGOC) = TRIM(M.COD_SAP)) RECUPERABLE,
             (SELECT CODIGON
                FROM OPEDD
               WHERE TIPOPEDD = 197
                 AND TRIM(CODIGOC) = TRIM(M.COD_SAP)) CODETA,
             SPD.NUM_SERIE,
             TM.IMEI_ESN_UA MAC,
             'ITTELMEX-EQU-DTH' OBSERVACION,
             NULL TRAN_SOLMAT
        from SALES.SISACT_POSTVENTA_DET_SERV_LTE SPD,
             OPERACION.TIPEQU                    EQU,
             PRODUCCION.ALMTABMAT                M,
             OPERACION.TABEQUIPO_MATERIAL        TM
       WHERE SPD.IDINTERACCION = V_IDINTERACCION
         AND SPD.FLAG_ACCION = V_TIPO_TRANS
         AND EQU.CODTIPEQU = M.CODMAT
         AND TM.NUMERO_SERIE = SPD.NUM_SERIE
         AND EQU.TIPEQU = SPD.TIPEQU;

BEGIN
  PO_COD := 0;
  PO_MSG := 'OK';

  BEGIN
    SELECT DISTINCT S.IDINTERACCION
      INTO V_IDINTERACCION
      FROM SALES.SISACT_POSTVENTA_DET_SERV_LTE S
     WHERE S.CODSOLOT = PI_CODSOLOT;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      PO_MSG := 'ERROR: NO EXISTE NINGUNA INTERACCIÓN PARA LA SOT ' ||
                PI_CODSOLOT;
      RAISE EX_ERROR;
    WHEN TOO_MANY_ROWS THEN
      PO_MSG := 'ERROR: LA SOT ' || PI_CODSOLOT ||
                ' TIENE CONFIGURADA MÁS DE UNA INTERACCIÓN';
  END;
  --39.0 Ini
  BEGIN
      SELECT NUMSLC INTO V_NUMSLC FROM SOLOT WHERE CODSOLOT = PI_CODSOLOT;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      PO_MSG := 'ERROR: NO EXISTE NRO DE PROYECTO PARA LA SOT ' || PI_CODSOLOT;
      RAISE EX_ERROR;
  END;
  --39.0 Fin
  BEGIN
    SELECT VALOR
      INTO V_TIPSRVD --39.0
      FROM CONSTANTE
     WHERE CONSTANTE = 'FAM_CABLE';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      PO_MSG := 'ERROR: NO EXISTE NINGÚN TIPO DE SERVICIO CONFIGURADO PARA LA SOT ' ||
                PI_CODSOLOT;
      RAISE EX_ERROR;
  END;
  --39.0 INI
  BEGIN
    SELECT VALOR
      INTO V_TIPSRVI
      FROM CONSTANTE
     WHERE CONSTANTE = 'FAM_COMODATO';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      PO_MSG := 'ERROR: NO EXISTE NINGÚN TIPO DE SERVICIO CONFIGURADO PARA LA SOT ' ||
                PI_CODSOLOT;
      RAISE EX_ERROR;
  END;
  --39.0 Fin

  SELECT S.COD_ID, S.CUSTOMER_ID
    INTO V_CO_ID, V_CUSTOMER_ID
    FROM OPERACION.SOLOT S
   WHERE S.CODSOLOT = PI_CODSOLOT;

   OPERACION.P_GET_PUNTO_PRINC_SOLOT(PI_CODSOLOT,
                    V_PUNTO,
                    V_PUNTOV,
                    V_PUNTOV,
                    V_TIPSRVI);  --39.0

   SELECT COUNT(1)
     INTO V_NUM_EQUIPOS
     FROM SOLOTPTOEQU
    WHERE CODSOLOT = PI_CODSOLOT
      AND ESTADO = 4;

    IF V_NUM_EQUIPOS > 0 THEN
        SELECT COUNT(1)
          INTO V_NUM_TARJETA
          FROM OPERACION.SOLOTPTOEQU
         WHERE CODSOLOT = PI_CODSOLOT
           AND TIPEQU IN (SELECT A.CODIGON
                  FROM OPEDD A, TIPOPEDD B
                   WHERE A.TIPOPEDD = B.TIPOPEDD
                   AND B.ABREV = 'TIPOEQU_TARJETA_DTH');

        IF V_NUM_TARJETA <= 3 THEN
            IF V_NUM_TARJETA = 0 THEN
            PO_MSG := 'ERROR: ERROR EN OBTENCIÓN DE NÚMERO DE TARJETAS';
            RAISE EX_ERROR;
            ELSIF V_NUM_TARJETA = 1 THEN
            V_TIPO := 'DTH-1';
            ELSIF V_NUM_TARJETA = 2 THEN
            V_TIPO := 'DTH-2';
            ELSIF V_NUM_TARJETA = 3 THEN
            V_TIPO := 'DTH-3';
            END IF;

        FOR REG_ACTIVIDAD_ALTA IN CUR_ACTIVIDAD(V_TIPO, 'ACTMASIVOALTA') LOOP
          V_CODETA := REG_ACTIVIDAD_ALTA.CODETA;

          SELECT COUNT(1)
            INTO V_CONT_ETAPA
            FROM SOLOTPTOETA
           WHERE CODSOLOT = PI_CODSOLOT
             AND CODETA = V_CODETA;

          IF V_CONT_ETAPA = 1 THEN
            SELECT ORDEN, PUNTO
            INTO V_ORDEN, V_PUNTO
            FROM SOLOTPTOETA
             WHERE CODSOLOT = PI_CODSOLOT
             AND CODETA = V_CODETA;
          ELSE
            SELECT NVL(MAX(ORDEN), 0) + 1
            INTO V_ORDEN
            FROM SOLOTPTOETA
             WHERE CODSOLOT = PI_CODSOLOT
             AND PUNTO = V_PUNTO;

            INSERT INTO SOLOTPTOETA
            (CODSOLOT,
             PUNTO,
             ORDEN,
             CODETA,
             PORCONTRATA,
             ESTETA,
             OBS,
             FECINI)
            VALUES
            (PI_CODSOLOT,
             V_PUNTO,
             V_ORDEN,
             V_CODETA,
             1,
             15,
             '',
             SYSDATE);
          END IF;

          --INSERTA LA ACTIVIDAD EN LA ETAPA
          INSERT INTO SOLOTPTOETAACT
            (CODSOLOT,
             PUNTO,
             ORDEN,
             CODACT,
             CANLIQ,
             COSLIQ,
             CANINS,
             CANDIS,
             COSDIS,
             MONEDA_ID,
             OBSERVACION,
             CODPRECDIS,
             CODPRECLIQ,
             FLG_PRELIQ,
             CONTRATA)
          VALUES
            (PI_CODSOLOT,
             V_PUNTO,
             V_ORDEN,
             REG_ACTIVIDAD_ALTA.CODACT,
             REG_ACTIVIDAD_ALTA.CANTIDAD,
             REG_ACTIVIDAD_ALTA.COSTO,
             REG_ACTIVIDAD_ALTA.CANTIDAD,
             REG_ACTIVIDAD_ALTA.CANTIDAD,
             REG_ACTIVIDAD_ALTA.COSTO,
             REG_ACTIVIDAD_ALTA.MONEDA_ID,
             '',
             REG_ACTIVIDAD_ALTA.CODPREC,
             REG_ACTIVIDAD_ALTA.CODPREC,
             1,
             1);
          END LOOP;
        END IF;
        GOTO BAJAS;
    END IF;

     --Recorremos las altas
     FOR I IN CUR_ACTIVIDAD_ALTA(C_ALTA) LOOP
        SELECT NVL(MAX(ORDEN), 0) + 1
          INTO V_ORDEN
          FROM SOLOTPTOEQU
         WHERE CODSOLOT = PI_CODSOLOT
           AND PUNTO = V_PUNTO;

        IF I.CODETA > 0 THEN
          IF I.EQUIPO > 0 THEN
            V_OBSERVACION := 'ITTELMEX-EQU-DTH';
            V_COSTO       := NVL(I.COSTO, 0);
            V_TIPPRP      := 0;
            V_CANTIDAD    := 1;
            V_FLGREQ      := 0;
            V_FLGINGRESO  := 1;
          ELSE
            V_OBSERVACION := 'ITTELMEX-MAT-DTH';
            V_COSTO       := NVL(I.PREPRM_USD, 0);
            V_TIPPRP      := 0;
            V_CANTIDAD    := I.CANTIDAD;
            V_FLGREQ      := 0;
            V_FLGINGRESO  := 2;
          END IF;
          INSERT INTO SOLOTPTOEQU
          (CODSOLOT,
           PUNTO,
           ORDEN,
           TIPEQU,
           CANTIDAD,
           TIPPRP,
           COSTO,
           FLGSOL,
           FLGREQ,
           CODETA,
           TRAN_SOLMAT,
           OBSERVACION,
           FECFDIS,
           INSTALADO,
           FLG_INGRESO,
           FLGINV,
           IDAGENDA,
           FECINS,
           RECUPERABLE,
           ESTADO,
           CODEQUCOM,
           IDDET)  --39.0
          VALUES
          (PI_CODSOLOT,
           V_PUNTO,
           V_ORDEN,
           I.TIPEQUOPE,
           V_CANTIDAD,
           V_TIPPRP,
           V_COSTO,
           1,
           V_FLGREQ,
           I.CODETA,
           NULL,
           V_OBSERVACION,
           SYSDATE,
           1,
           V_FLGINGRESO,
           1,
           NULL,
           SYSDATE,
           I.RECUPERABLE,
           4,
           I.CODEQUCOM,
           I.IDDET);  --39.0
        END IF;
        V_ORDEN := V_ORDEN + 1;
    END LOOP;


     <<BAJAS>>
    SELECT COUNT(1)
    INTO V_NUM_EQUIPOS
    FROM SOLOTPTOEQU
     WHERE CODSOLOT = PI_CODSOLOT
     AND ESTADO = 12;

    IF V_NUM_EQUIPOS > 0 THEN
          V_NUMREGISTRO := F_OBTENER_NUMREGISTRO(PI_CODSOLOT);
          IF V_NUMREGISTRO IS NULL THEN
            PO_MSG := 'ERROR: ERROR EN OBTENCIÓN DE REGISTRO DE INSTALACIÓN AL CARGAR EQUIPOS DE DTH';
            RAISE EX_ERROR;
          END IF;

        SELECT CODSOLOT
          INTO V_CODSOLOT_ORI
          FROM OPE_SRV_RECARGA_CAB
         WHERE NUMREGISTRO = V_NUMREGISTRO;

        SELECT COUNT(1)
          INTO V_NUM_TARJETA
          FROM SOLOTPTOEQU
         WHERE CODSOLOT = V_CODSOLOT_ORI
           AND TIPEQU IN (SELECT A.CODIGON
                  FROM OPEDD A, TIPOPEDD B
                   WHERE A.TIPOPEDD = B.TIPOPEDD
                   AND B.ABREV = 'TIPOEQU_TARJETA_DTH');
        IF V_NUM_TARJETA <= 3 THEN
          IF V_NUM_TARJETA = 0 THEN
            PO_MSG := 'ERROR: ERROR EN OBTENCIÓN DE NÚMERO DE TARJETAS';
            RAISE EX_ERROR;
            ELSIF V_NUM_TARJETA = 1 THEN
            V_TIPO := 'DTH-1';
            ELSIF V_NUM_TARJETA = 2 THEN
            V_TIPO := 'DTH-2';
            ELSIF V_NUM_TARJETA = 3 THEN
            V_TIPO := 'DTH-3';
          END IF;

          FOR REG_ACTIVIDAD_BAJA IN CUR_ACTIVIDAD(V_TIPO,'ACTMASIVOBAJA') LOOP
              V_CODETA := REG_ACTIVIDAD_BAJA.CODETA;
              SELECT COUNT(1)
                INTO V_CONT_ETAPA
                FROM SOLOTPTOETA
               WHERE CODSOLOT = PI_CODSOLOT
                 AND CODETA = V_CODETA;

              IF V_CONT_ETAPA = 1 THEN
                --EXISTE ETAPA
                SELECT ORDEN, PUNTO
                INTO V_ORDEN, V_PUNTO
                FROM SOLOTPTOETA
                 WHERE CODSOLOT = PI_CODSOLOT
                 AND CODETA = V_CODETA;
              ELSE
                --GENERA LA ETAPA EN ESTADO 15 : PRELIQUIDACION
                SELECT NVL(MAX(ORDEN), 0) + 1
                INTO V_ORDEN
                FROM SOLOTPTOETA
                 WHERE CODSOLOT = PI_CODSOLOT
                 AND PUNTO = V_PUNTO;

                INSERT INTO SOLOTPTOETA
                (CODSOLOT,
                 PUNTO,
                 ORDEN,
                 CODETA,
                 PORCONTRATA,
                 ESTETA,
                 OBS,
                 FECDIS,
                 CODCON,
                 FECINI)
                VALUES
                (PI_CODSOLOT,
                 V_PUNTO,
                 V_ORDEN,
                 V_CODETA,
                 1,
                 15,
                 '',
                 NULL,
                 NULL,
                 SYSDATE);
              END IF;

              --INSERTA LA ACTIVIDAD EN LA ETAPA
              INSERT INTO SOLOTPTOETAACT
                (CODSOLOT,
                 PUNTO,
                 ORDEN,
                 CODACT,
                 CANLIQ,
                 COSLIQ,
                 CANINS,
                 CANDIS,
                 COSDIS,
                 MONEDA_ID,
                 OBSERVACION,
                 CODPRECDIS,
                 CODPRECLIQ,
                 FLG_PRELIQ,
                 CONTRATA)
              VALUES
                (PI_CODSOLOT,
                 V_PUNTO,
                 V_ORDEN,
                 REG_ACTIVIDAD_BAJA.CODACT,
                 REG_ACTIVIDAD_BAJA.CANTIDAD,
                 REG_ACTIVIDAD_BAJA.COSTO,
                 REG_ACTIVIDAD_BAJA.CANTIDAD,
                 REG_ACTIVIDAD_BAJA.CANTIDAD,
                 REG_ACTIVIDAD_BAJA.COSTO,
                 REG_ACTIVIDAD_BAJA.MONEDA_ID,
                 '',
                 REG_ACTIVIDAD_BAJA.CODPREC,
                 REG_ACTIVIDAD_BAJA.CODPREC,
                 1,
                 1);
          END LOOP;
      END IF;
      GOTO FIN;
    END IF;

    --Recorremos las bajas
    FOR B IN CUR_ACTIVIDAD_BAJA(C_BAJA) LOOP
        IF V_COUNTER = 0 THEN
          SELECT MIN(PUNTO)
          INTO V_PUNTO
          FROM OPERACION.SOLOTPTO A, OPERACION.INSSRV B
           WHERE CODSOLOT = PI_CODSOLOT
           AND A.CODINSSRV = B.CODINSSRV
           AND A.TIPTRS = 5  --40.0
           AND B.TIPSRV = V_TIPSRVD;  --39.0

          IF V_PUNTO = 0 THEN
          PO_MSG := 'ERROR: ERROR EN OBTENCIÓN DE PUNTO DE DETALLE AL CARGAR EQUIPOS DE DTH';
          RAISE EX_ERROR;
          END IF;

          SELECT NVL(MAX(ORDEN), 0) + 1
          INTO V_ORDEN
          FROM SOLOTPTOEQU
           WHERE CODSOLOT = PI_CODSOLOT
           AND PUNTO = V_PUNTO;
        END IF;

        INSERT INTO SOLOTPTOEQU
          (CODSOLOT,
           PUNTO,
           ORDEN,
           TIPEQU,
           CANTIDAD,
           TIPPRP,
           COSTO,
           NUMSERIE,
           FLGSOL,
           FLGREQ,
           CODETA,
           TRAN_SOLMAT,
           OBSERVACION,
           FECFDIS,
           ESTADO,
           MAC,
           CODEQUCOM,
           INSTALADO)
        VALUES
          (PI_CODSOLOT,
           V_PUNTO,
           V_ORDEN,
           B.TIPEQUOPE,
           B.CANTIDAD,
           0,
           NVL(B.COSTO, 0),
           B.NUM_SERIE,
           1,
           0,
           B.CODETA,
           B.TRAN_SOLMAT,
           B.OBSERVACION,
           SYSDATE,
           4,  --39.0
           B.MAC,
           B.CODEQUCOM,
           1);

        V_ORDEN   := V_ORDEN + 1;
        V_COUNTER := V_COUNTER + 1;
    END LOOP;

    <<FIN>>
    NULL;
EXCEPTION
    WHEN EX_ERROR THEN
    PO_COD := -1;
END;
  --Fin 37.0
END;
/