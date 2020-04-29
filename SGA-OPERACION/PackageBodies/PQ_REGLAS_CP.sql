create or replace package body operacion.pq_reglas_cp is


  procedure sgass_devuelve_detcp(pi_codsolot     solot.codsolot%type,
                                 po_curdat       out sys_refcursor,
                                 po_codrespuesta out number,
                                 po_msgrespuesta out varchar2) as
  begin
    po_codrespuesta := 0;
    po_msgrespuesta := 'Exitoso';

    open po_curdat for
      select a.codsolot,
             a.iddet,
             a.observacion,
             a.tipo_equ_prov,
             a.cant_total,
             a.cant_efec,
             b.tipsrv,
             a.idestado,
             a.codaction
        from operacion.detcp a, operacion.actioncp b
       where a.codsolot = pi_codsolot
         and a.codaction = b.codaction
       order by iddet asc;
  exception
    when others then
      po_codrespuesta := sqlcode;
      po_msgrespuesta := sqlerrm;

  end;

procedure sgass_devuelve_detsot(pi_codsolot     solot.codsolot%type,
                                  po_curdat       out sys_refcursor,
                                  po_codrespuesta out number,
                                  po_msgrespuesta out varchar2) as

    ln_telefonia        number;
    ln_telefonia_actual number;
    lc_codcli           inssrv.codcli%type;
    lc_codsuc           vtasuccli.codsuc%type;

  begin
    po_codrespuesta := 0;
    po_msgrespuesta := 'Exitoso';

    select distinct codcli, codsuc
      into lc_codcli, lc_codsuc
      from inssrv
     where codinssrv in
           (select codinssrv from solotpto where codsolot = pi_codsolot);


    select count(*)
      into ln_telefonia
      from solotpto a, inssrv b, insprd c
     where b.codinssrv = a.codinssrv
       and c.pid = a.pid
       and b.tipsrv = cc_tipsrv_telefonia
       and a.codsolot = pi_codsolot;

    select count(*)
      into ln_telefonia_actual
      from inssrv b, insprd c
     where b.codcli = lc_codcli
       and b.codsuc = lc_codsuc
       and b.estinssrv in (1,2)
       and c.codinssrv = b.codinssrv
       and c.estinsprd in (1,2)
       and b.tipsrv = cc_tipsrv_telefonia;

    open po_curdat for

      select x.codsolot,
             case x.tipsrv
               when '0062' then
                'CABLE'
               when '0006' then
                'INTERNET'
               when '0004' then
                'TELEFONIA'
             end servicio,

             x.tipsrv,
             x.tipo,
             x.detalle
        from (

              select a.codsolot,
                      b.tipsrv as tipsrv,
                      c.flgprinc,
                      case c.flgprinc
                        when 1 then
                         'Servicio Principal'
                        when 0 then
                         'Paquete Adicional'
                      end tipo,
                      e.abrev as detalle
                from solotpto          a,
                      inssrv            b,
                      insprd            c,
                      tystabsrv         e
               where b.codinssrv = a.codinssrv
                 and c.pid = a.pid
                 and a.codsolot = pi_codsolot
                 and b.tipsrv = cc_tipsrv_cable
                 and e.codsrv = c.codsrv
                 and c.codequcom is null
              union all
              select a.codsolot,
                     b.tipsrv,
                     c.flgprinc,
                     'DECO',
                     sum(c.cantidad) || ' ' || d.tipo_equ_prov detalle
                from solotpto a, inssrv b, insprd c, vtaequcom d
               where b.codinssrv = a.codinssrv
                 and c.pid = a.pid
                 and a.codsolot = pi_codsolot
                 and b.tipsrv = cc_tipsrv_cable
                 and c.codequcom = d.codequcom
                 and c.codequcom is not null
               group by a.codsolot, b.tipsrv, c.flgprinc, d.tipo_equ_prov
              union all
              select a.codsolot,
                     b.tipsrv as servicio,
                     c.flgprinc,
                     case c.flgprinc
                       when 1 then
                        'Servicio Principal'
                       when 0 then
                        'Paquete Adicional'
                     end tipo,
                     e.abrev detalle
                from solotpto          a,
                     inssrv            b,
                     insprd            c,
                     tystabsrv         e
               where b.codinssrv = a.codinssrv
                 and c.pid = a.pid
                 and a.codsolot = pi_codsolot
                 and b.tipsrv = cc_tipsrv_internet
                 and e.codsrv = c.codsrv
                 and c.codequcom is null
              union all
              select a.codsolot,
                     b.tipsrv as servicio,
                     c.flgprinc,
                     'EQUIPO' tipo,
                     d.tipo_equ_prov detalle
                from solotpto a, inssrv b, insprd c, vtaequcom d
               where b.codinssrv = a.codinssrv
                 and c.pid = a.pid
                 and a.codsolot = pi_codsolot
                 and b.tipsrv = cc_tipsrv_internet
                 and d.codequcom = c.codequcom
                 and c.codequcom is not null
                 and ln_telefonia = 0
              union all
              select a.codsolot,
                     b.tipsrv as servicio,
                     c.flgprinc,
                     'EQUIPO' tipo,
                     d.tipo_equ_prov detalle
                from solotpto a, inssrv b, insprd c, vtaequcom d
               where b.codinssrv = a.codinssrv
                 and c.pid = a.pid
                 and a.codsolot = pi_codsolot
                 and b.tipsrv = cc_tipsrv_telefonia
                 and d.codequcom = c.codequcom
                 and c.codequcom is not null
                 and ln_telefonia > 0
              union all
              select a.codsolot,
                     b.tipsrv as servicio,
                     c.flgprinc,
                     'Servicio Principal' tipo,
                     e.abrev detalle
                from solotpto          a,
                     inssrv            b,
                     insprd            c,
                     tystabsrv         e
               where b.codinssrv = a.codinssrv
                 and c.pid = a.pid
                 and a.codsolot = pi_codsolot
                 and b.tipsrv = cc_tipsrv_telefonia
                 and e.codsrv = c.codsrv
                 and c.flgprinc = 1
              union all -- Aca toma la situacion actual
              select 0 codsolot,
                     b.tipsrv as tipsrv,
                     c.flgprinc,
                     case c.flgprinc
                       when 1 then
                        'Servicio Principal'
                       when 0 then
                        'Paquete Adicional'
                     end tipo,
                     e.abrev as detalle
                from inssrv b, insprd c, tystabsrv e
               where b.codcli = lc_codcli
                 and b.codsuc = lc_codsuc
                 and b.estinssrv in (1,2) -- debe cambiar a 1,2
                 and c.codinssrv = b.codinssrv
                 and c.estinsprd in (1,2) -- debe cambiar a 1,2
                 and b.tipsrv = cc_tipsrv_cable
                 and e.codsrv = c.codsrv
                 and c.codequcom is null
              union all
              select 0 codsolot,
                     b.tipsrv,
                     c.flgprinc,
                     'DECO',
                     sum(c.cantidad) || ' ' || d.tipo_equ_prov detalle
                from inssrv b, insprd c, vtaequcom d
               where b.codcli = lc_codcli
                 and b.codsuc = lc_codsuc
                 and b.estinssrv in (1,2) -- debe cambiar a 1,2
                 and c.codinssrv = b.codinssrv
                 and c.estinsprd in (1,2) -- debe cambiar a 1,2
                 and b.tipsrv = cc_tipsrv_cable
                 and c.codequcom = d.codequcom
                 and c.codequcom is not null
               group by 0, b.tipsrv, c.flgprinc, d.tipo_equ_prov
              union all
              select 0 codsolot,
                     b.tipsrv as servicio,
                     c.flgprinc,
                     case c.flgprinc
                       when 1 then
                        'Servicio Principal'
                       when 0 then
                        'Paquete Adicional'
                     end tipo,
                     e.abrev detalle
                from inssrv b, insprd c, tystabsrv e
               where b.codcli = lc_codcli
                 and b.codsuc = lc_codsuc
                 and b.estinssrv in (1,2) -- debe cambiar a 1,2
                 and c.codinssrv = b.codinssrv
                 and c.estinsprd in (1,2) -- debe cambiar a 1,2
                 and b.tipsrv = cc_tipsrv_internet
                 and e.codsrv = c.codsrv
                 and c.codequcom is null
              union all
              select 0 codsolot,
                     b.tipsrv as servicio,
                     c.flgprinc,
                     'EQUIPO' tipo,
                     d.tipo_equ_prov detalle
                from inssrv b, insprd c, vtaequcom d
               where b.codcli = lc_codcli
                 and b.codsuc = lc_codsuc
                 and b.estinssrv in (1,2) -- debe cambiar a 1,2
                 and c.codinssrv = b.codinssrv
                 and c.estinsprd in (1,2) -- debe cambiar a 1,2
                 and b.tipsrv = cc_tipsrv_internet
                 and d.codequcom = c.codequcom
                 and c.codequcom is not null
                 and ln_telefonia_actual = 0
              union all
              select 0 codsolot,
                     b.tipsrv as servicio,
                     c.flgprinc,
                     'EQUIPO' tipo,
                     d.tipo_equ_prov detalle
                from inssrv b, insprd c, vtaequcom d
               where b.codcli = lc_codcli
                 and b.codsuc = lc_codsuc
                 and b.estinssrv in (1,2) -- debe cambiar a 1,2
                 and c.codinssrv = b.codinssrv
                 and c.estinsprd in (1,2) -- debe cambiar a 1,2
                 and b.tipsrv = cc_tipsrv_telefonia
                 and d.codequcom = c.codequcom
                 and c.codequcom is not null
                 and ln_telefonia_actual >0
              union all
              select 0 codsolot,
                     b.tipsrv as servicio,
                     c.flgprinc,
                     'Servicio Principal' tipo,
                     e.abrev detalle
                from inssrv b, insprd c, tystabsrv e
               where b.codcli = lc_codcli
                 and b.codsuc = lc_codsuc
                 and b.estinssrv in (1,2) -- debe cambiar a 1,2
                 and c.codinssrv = b.codinssrv
                 and c.estinsprd in (1,2) -- debe cambiar a 1,2
                 and b.tipsrv = cc_tipsrv_telefonia
                 and e.codsrv = c.codsrv
                 and c.flgprinc = 1
               order by 1, 2 desc, 3 desc, 4 desc) x;

  exception
    when others then
      po_codrespuesta := sqlcode;
      po_msgrespuesta := sqlerrm;

  end;

procedure crearDetCP(an_codsolot     number,
                       an_codaction    number,
                       an_vt           number,
                       ac_codcli       char,
                       ac_codsuc       char,
                       an_idpaq        number,
                       av_etiqueta     varchar2,
                       av_valortxt     varchar2,
                       av_observacion  varchar2,
                       av_tipo_equ     varchar2 default null,
                       an_cantidad     number default null,
                       an_codrespuesta out number,
                       av_msgrespuesta out varchar2) as

    lv_idcab       operacion.cabcp.idcab%type;
    ln_cantidad    number;
    lv_iddet       operacion.detcp.iddet%type;
    lv_cabcp_count number;
    lv_vt          operacion.detcp.vt%type;
    lv_orden       operacion.detcp.orden%type;
    ln_count number;
    ln_observacion varchar2(100);
  begin
    an_codrespuesta := 0;
    av_msgrespuesta := 'Exitoso';
    -- insertar nueva cabecera
    select count(*)
      into lv_cabcp_count
      from operacion.cabcp
     where codsolot = an_codsolot
       and idestado <> 4; -- Cancelado

    if lv_cabcp_count = 0 then
      -- nuevo correlativo de cabecera
      select OPERACION.SQ_IDCAB.nextval into lv_idcab from dummy_sgacrm;
      -- insertar nueva cabecera
      insert into operacion.cabcp
        (idcab, codcliori, codsucori, idpaqori, idestado, codsolot)
      values
        (lv_idcab, ac_codcli, ac_codsuc, an_idpaq, 1, an_codsolot);
    elsif lv_cabcp_count > 0 then
      select idcab
        into lv_idcab
        from operacion.cabcp
       where codsolot = an_codsolot
         and idestado <> 4; -- Cancelado
    end if;

    -- nuevo correlativo del detalle
    select OPERACION.SQ_IDDET.nextval into lv_iddet from dummy_sgacrm;
    -- Obtienes vt de la accion
    select vt
      into lv_vt
      from operacion.actioncp
     where codaction = an_codaction;
    if lv_vt = 2 then
      lv_vt := an_vt;
    end if;

    -- nuevo valor correlativo de orden para el detalle
    select count(*) + 1
      into lv_orden
      from operacion.detcp
     where idcab = lv_idcab;

     if an_codaction=12 or an_codaction=13 then

     select count(*) into ln_count from operacion.detcp where codsolot=an_codsolot
     and codaction=an_codaction and tipo_equ_prov=av_tipo_equ;

         if ln_count=0 then

            insert into operacion.detcp
                (iddet,
                 codclides,
                 codsucdes,
                 idpaqdes,
                 idestado,
                 codaction,
                 orden,
                 vt,
                 codsolot,
                 etiqueta,
                 valortxt,
                 idcab,
                 observacion,
                 tipo_equ_prov,
                 cant_total,
                 cant_efec
                 )
              values
                (lv_iddet,
                 ac_codcli,
                 ac_codsuc,
                 an_idpaq,
                 4,
                 an_codaction,
                 lv_orden,
                 lv_vt,
                 an_codsolot,
                 av_etiqueta,
                 av_valortxt,
                 lv_idcab,
                 av_observacion,
                 av_tipo_equ,
                 1,
                 0
                );


                if an_codaction = 12 then


                   select 'Se agregara '||'1'|| ' ' ||av_tipo_equ
                       into ln_observacion  from dual;

                   select iddet into lv_iddet  from operacion.detcp where codsolot=an_codsolot
                   and codaction=an_codaction  and tipo_equ_prov=av_tipo_equ;

                   update operacion.detcp set observacion=ln_observacion where codsolot=an_codsolot
                   and codaction=an_codaction and iddet=lv_iddet;

                  else

                   select 'Se quitara '||'1'|| ' ' ||av_tipo_equ
                       into ln_observacion  from dual;

                   select iddet into lv_iddet  from operacion.detcp where codsolot=an_codsolot
                   and codaction=an_codaction  and tipo_equ_prov=av_tipo_equ;

                   update operacion.detcp set observacion=ln_observacion where codsolot=an_codsolot
                   and codaction=an_codaction and iddet=lv_iddet;

                 end if;



         else

                 select cant_total+1 into ln_cantidad from operacion.detcp where codsolot=an_codsolot
                 and codaction=an_codaction and tipo_equ_prov=av_tipo_equ;

                 update operacion.detcp set CANT_TOTAL=ln_cantidad where codsolot=an_codsolot
                 and codaction=an_codaction and tipo_equ_prov=av_tipo_equ;


                 if an_codaction = 12 then


                     select iddet into lv_iddet from operacion.detcp where codsolot=an_codsolot
                   and codaction=an_codaction  and tipo_equ_prov=av_tipo_equ ;

                   select 'Se agregara '||ln_cantidad|| ' ' ||av_tipo_equ
                       into ln_observacion  from dual;

                   update operacion.detcp set observacion=ln_observacion where codsolot=an_codsolot
                   and codaction=an_codaction and iddet=lv_iddet ;

                  else
                  select iddet into lv_iddet from operacion.detcp where codsolot=an_codsolot
                   and codaction=an_codaction and tipo_equ_prov=av_tipo_equ;

                   select 'Se quitara '||ln_cantidad|| ' ' ||av_tipo_equ
                       into ln_observacion  from dual;

                   update operacion.detcp set observacion=ln_observacion where codsolot=an_codsolot
                   and codaction=an_codaction and iddet=lv_iddet ;

                 end if;
         end if;

    else
    -- insertar nuevo detalle
    insert into operacion.detcp
      (iddet,
       codclides,
       codsucdes,
       idpaqdes,
       idestado,
       codaction,
       orden,
       vt,
       codsolot,
       etiqueta,
       valortxt,
       idcab,
       observacion,
       tipo_equ_prov,
       cant_total,
       cant_efec
       )
    values
      (lv_iddet,
       ac_codcli,
       ac_codsuc,
       an_idpaq,
       4,
       an_codaction,
       lv_orden,
       lv_vt,
       an_codsolot,
       av_etiqueta,
       av_valortxt,
       lv_idcab,
       av_observacion,
       av_tipo_equ,
       an_cantidad,
       0
       );

     end if;
  exception
    when others then
      an_codrespuesta := sqlcode;
      av_msgrespuesta := sqlerrm;
  end;


  procedure crear_detprovcp(an_iddet     number,
                       an_customerid     number,
                       an_ficha_old   number,
                       an_ficha_new   number,
                       ac_SERVICE_ID_OLD varchar2,
                       ac_SERVICE_ID_NEW varchar2,
                       an_SERVICE_TYPE_OLD  varchar2,
                       av_SERVICE_TYPE_NEW  varchar2,
                       an_sp_consumir    varchar2,
                       an_estado  number,
                       an_codequcom varchar2,
                       an_codsolot_old number,
                       an_codsolot_new number,
                       an_codrespuesta out number,
                       av_msgrespuesta out varchar2) as

    ln_codaction number;
    ln_count     number;
    ln_cantidad  number;
    lv_idseq number;
  begin
    an_codrespuesta := 0;
    av_msgrespuesta := 'Exitoso';

    select codaction into ln_codaction from OPERACION.DETcp where iddet= an_iddet;
    select OPERACION.SQ_IDSEQ.nextval into lv_idseq from dummy_sgacrm;
    insert into OPERACION.DETPROVCP
      (idseq,
      iddet,
       codaction,
       customer_id,
       ficha_origen,
       ficha_destino,
       service_id_old,
       service_id_new,
       service_type_old,
       service_type_new,
       sp_a_consumir,
       estado,
       codequcom,
       codsolot_old,
       codsolot_new
       )
    values
       (lv_idseq,
      an_iddet,
       ln_codaction,
       an_customerid,
       an_ficha_old,
       an_ficha_new,
       ac_SERVICE_ID_OLD,
       ac_SERVICE_ID_NEW,
       an_SERVICE_TYPE_OLD,
       av_SERVICE_TYPE_NEW,
       an_sp_consumir,
       an_estado,
       an_codequcom,
       an_codsolot_old,
       an_codsolot_new
       );

      select count(*) into ln_count from OPERACION.DETPROVCP where iddet=an_iddet;

      if ln_count>1 then

            if ln_codaction=14 or ln_codaction=15 then

               select cant_total+1 into ln_cantidad from operacion.detcp where iddet=an_iddet;

               update operacion.detcp set cant_total=ln_cantidad where iddet=an_iddet;

            end if;

      end if;

  exception
    when others then
      an_codrespuesta := sqlcode;
      av_msgrespuesta := sqlerrm;
  end;


procedure agregarServicioCable(an_codinssrv insprd.codinssrv%type,
                                 an_customer varchar2) as

  begin
    for lr_pid in (select b.pid
                     from insprd b, equcomxope a, tipequ c
                    where b.codinssrv = an_codinssrv
                      and a.codequcom = b.codequcom
                      and c.codtipequ = a.codtipequ
                      and c.tipo = cn_tipo_deco) loop

      sgacrm.pq_fichatecnica.p_crear_instdoc('INSPRD_EQU',
                                             lr_pid.pid,
                                             an_codinssrv,
                                             to_char(an_customer));

    end loop lr_pid;
  end;



procedure actualiza_cable(ln_codinssrv_old     insprd.codinssrv%type,
                          ln_codinssrv_new     insprd.codinssrv%type,
                          an_codsolot          solot.codsolot%type,
                                   an_codrespuesta out number,
                                   av_msgrespuesta out varchar2) as

ln_insidcom_new                    ft_instdocumento.insidcom%type;
   ln_insidcom_old                  ft_instdocumento.insidcom%type;
   ln_servicetype_old               ft_instdocumento.valortxt%type;
  ln_sec number;

begin

an_codrespuesta:=0;
av_msgrespuesta:='Exito';

for lr_solotpto in (
  select idficha, rownum as contador from (select distinct idficha
          from ft_instdocumento where codigo2=ln_codinssrv_old order by 1)x

  ) loop

ln_sec := lr_solotpto.contador;


    for actualiza in (select idficha, rownum as contador2 from (select distinct idficha
                      from ft_instdocumento where codigo2=ln_codinssrv_new
                      and idficha not in (select ficha_destino from operacion.detprovcp
                                         where codsolot_new= an_codsolot and codaction=12)
                     order by 1)x
              )loop

          if ln_sec = actualiza.contador2 then

            for ln_actualizador in (select * from sgacrm.ft_instdocumento
                               where idlista in
                               (
                               cn_idlista_servicetype,
                               cn_idlista_paquete_tv_adic
                               )

                            and idficha=lr_solotpto.idficha order by idficha,orden) loop


            begin
             select insidcom
             into ln_insidcom_old
             from ft_instdocumento where idficha=lr_solotpto.idficha and valortxt=ln_actualizador.valortxt ;

              select valortxt
              into ln_servicetype_old
              from ft_instdocumento where idficha=lr_solotpto.idficha and insidcom=ln_insidcom_old
              and idlista=cn_idlista_serviceid;

              select insidcom
              into ln_insidcom_new
              from ft_instdocumento where idficha=actualiza.idficha and valortxt=ln_actualizador.valortxt ;

              update sgacrm.ft_instdocumento set valortxt=null
                      where
                      idlista=cn_idlista_serviceid
                      and idficha=actualiza.idficha
                      and insidcom=ln_insidcom_new;


            exception
              when others then
                   ln_insidcom_old := 0;
            end;
         end loop ln_actualizador;

           --Actualizamos los serviceID para adicionales
      for ln_actualizador in (select * from sgacrm.ft_instdocumento
                               where idlista in
                               (
                               cn_idlista_servicetype,
                               cn_idlista_paquete_tv_adic
                               )

                             and idficha=lr_solotpto.idficha order by idficha,orden) loop
        begin
            select insidcom
            into ln_insidcom_old
            from ft_instdocumento where idficha=lr_solotpto.idficha and valortxt=ln_actualizador.valortxt ;

            select valortxt
            into ln_servicetype_old
            from ft_instdocumento where idficha=lr_solotpto.idficha and insidcom=ln_insidcom_old
            and idlista=cn_idlista_serviceid;


            select insidcom
            into ln_insidcom_new
            from ft_instdocumento where idficha=actualiza.idficha and valortxt=ln_actualizador.valortxt ;

            update sgacrm.ft_instdocumento set valortxt=ln_servicetype_old
                    where
                    idlista=cn_idlista_serviceid

                    and idficha=actualiza.idficha
                    and insidcom=ln_insidcom_new
                    and rownum=1
                    and valortxt is null;

        exception
              when others then
                   ln_insidcom_old := 0;
        end;

       end loop ln_actualizador;


          end if;

    end loop actualiza;


end loop lr_solotpto;


for actualiza_datos in (
                     select * from ft_instdocumento where idlista=cn_idlista_serviceid
                     and idcomponente=cn_idcomponente_cable_bas
                     and codigo2=ln_codinssrv_old
                        )loop

    for  actualiza_equipo in (
                     select * from ft_instdocumento where idlista=cn_idlista_serviceid
                     and idcomponente=cn_idcomponente_cable_bas
                     and codigo2=ln_codinssrv_new
                             )loop



             if actualiza_datos.valortxt = actualiza_equipo.valortxt then

                  update ft_instdocumento
                   set valortxt =
                       (select valortxt
                        from ft_instdocumento
                       where idficha=actualiza_datos.idficha
                         and idlista = cn_idlista_serialnumber
                         and idcomponente = cn_idcomponente_cable_bas)
                 where idficha=actualiza_equipo.idficha
                   and idlista = cn_idlista_serialnumber
                   and idcomponente = cn_idcomponente_cable_bas;

                  update ft_instdocumento
                   set valortxt =
                       (select valortxt
                        from ft_instdocumento
                       where idficha=actualiza_datos.idficha
                         and idlista = cn_idlista_ht_address
                         and idcomponente = cn_idcomponente_cable_bas)
                 where idficha=actualiza_equipo.idficha
                   and idlista = cn_idlista_ht_address
                   and idcomponente = cn_idcomponente_cable_bas;


                  update ft_instdocumento
                   set valortxt =
                       (select valortxt
                        from ft_instdocumento
                       where idficha=actualiza_datos.idficha
                         and idlista = cn_idlista_model_stb
                         and idcomponente = cn_idcomponente_cable_bas)
                 where idficha=actualiza_equipo.idficha
                   and idlista = cn_idlista_model_stb
                   and idcomponente = cn_idcomponente_cable_bas;


				    update ft_instdocumento
                   set valortxt =
                       (select valortxt
                        from ft_instdocumento
                       where idficha=actualiza_datos.idficha
                         and idlista = cn_idlista_tipo_equ_prov
                         )
                 where idficha=actualiza_equipo.idficha
                   and idlista = cn_idlista_tipo_equ_prov;

                 update ft_instdocumento
                   set valortxt = '1'
                 where idficha=actualiza_equipo.idficha
                   and idlista = cn_idlista_estadoficha;

               end if;

      end loop actualiza_equipo;

end loop actualiza_datos;

exception
    when others then
      an_codrespuesta := '1';
      av_msgrespuesta := 'Procedimiento erroneo';

end;


procedure SGASU_ACTUALIZA_FICHA_CABLE(an_codsolot solot.codsolot%type,
                                   an_codrespuesta out number,
                                   av_msgrespuesta out varchar2) as

ln_codinssrv_old     insprd.codinssrv%type;
ln_codinssrv_new     insprd.codinssrv%type;
ln_pid_princ_new     insprd.pid%type;
lr_inssrv_new        inssrv%rowtype;
ln_count             number;
ln_serviceid_new     ft_instdocumento.valortxt%type;
ln_insidcom_new                    ft_instdocumento.insidcom%type;
   ln_insidcom_old                  ft_instdocumento.insidcom%type;
   ln_servicetype_old               ft_instdocumento.valortxt%type;
  ln_sec number;

begin

an_codrespuesta:=0;
av_msgrespuesta:='Exito';

select c.pid, b.codinssrv
        into ln_pid_princ_new, ln_codinssrv_new
        from solotpto a, inssrv b, insprd c
       where b.codinssrv = a.codinssrv
         and c.pid = a.pid
         and b.codinssrv = c.codinssrv
         and a.codsolot = an_codsolot
         and b.tipsrv = cc_tipsrv_cable
         and c.flgprinc = 1;

    select *
        into lr_inssrv_new
        from inssrv
       where codinssrv = ln_codinssrv_new;


    --se busca si hay un inssrv de internet anterior activo o suspendido
    select nvl(max(codinssrv), 0)
      into ln_codinssrv_old
      from inssrv
     where codinssrv < lr_inssrv_new.codinssrv
       and estinssrv = 1
       and codcli = lr_inssrv_new.codcli
       and codsuc = lr_inssrv_new.codsuc
       and tipsrv = cc_tipsrv_cable;



for lr_solotpto in (

      select idficha, rownum as contador from (select distinct idficha
          from ft_instdocumento where codigo2=ln_codinssrv_old
          and idficha not in (select ficha_origen from operacion.detprovcp where codsolot_new= an_codsolot and codaction=13)
          order by 1)x

  ) loop

ln_sec := lr_solotpto.contador;


    for actualiza in (select idficha, rownum as contador2 from (select distinct idficha
          from ft_instdocumento where codigo2=ln_codinssrv_new
          and idficha not in (select ficha_destino from operacion.detprovcp where codsolot_new= an_codsolot and codaction=12)

          order by 1)x
              )loop

          if ln_sec = actualiza.contador2 then

            for ln_actualizador in (select * from sgacrm.ft_instdocumento
                               where idlista in
                               (
                               cn_idlista_servicetype,
                               cn_idlista_paquete_tv_adic
                               )

                            and idficha=lr_solotpto.idficha order by idficha,orden) loop


            begin
             select insidcom
             into ln_insidcom_old
             from ft_instdocumento where idficha=lr_solotpto.idficha and valortxt=ln_actualizador.valortxt ;

              select valortxt
              into ln_servicetype_old
              from ft_instdocumento where idficha=lr_solotpto.idficha and insidcom=ln_insidcom_old
              and idlista=cn_idlista_serviceid;

              select insidcom
              into ln_insidcom_new
              from ft_instdocumento where idficha=actualiza.idficha and valortxt=ln_actualizador.valortxt ;

              update sgacrm.ft_instdocumento set valortxt=null
                      where
                      idlista=cn_idlista_serviceid
                      and idficha=actualiza.idficha
                      and insidcom=ln_insidcom_new;


            exception
              when others then
                   ln_insidcom_old := 0;
            end;
         end loop ln_actualizador;

           --Actualizamos los serviceID para adicionales
      for ln_actualizador in (select * from sgacrm.ft_instdocumento
                               where idlista in
                               (
                               cn_idlista_servicetype,
                               cn_idlista_paquete_tv_adic
                               )

                             and idficha=lr_solotpto.idficha order by idficha,orden) loop
        begin
            select insidcom
            into ln_insidcom_old
            from ft_instdocumento where idficha=lr_solotpto.idficha and valortxt=ln_actualizador.valortxt ;

            select valortxt
            into ln_servicetype_old
            from ft_instdocumento where idficha=lr_solotpto.idficha and insidcom=ln_insidcom_old
            and idlista=cn_idlista_serviceid;


            select insidcom
            into ln_insidcom_new
            from ft_instdocumento where idficha=actualiza.idficha and valortxt=ln_actualizador.valortxt ;

            update sgacrm.ft_instdocumento set valortxt=ln_servicetype_old
                    where
                    idlista=cn_idlista_serviceid

                    and idficha=actualiza.idficha
                    and insidcom=ln_insidcom_new
                    and rownum=1
                    and valortxt is null;

        exception
              when others then
                   ln_insidcom_old := 0;
        end;

       end loop ln_actualizador;


          end if;

    end loop actualiza;


end loop lr_solotpto;


for actualiza_datos in (
                     select * from ft_instdocumento where idlista=cn_idlista_serviceid
                     and idcomponente=cn_idcomponente_cable_bas
                     and codigo2=ln_codinssrv_old
                        )loop

    for  actualiza_equipo in (
                     select * from ft_instdocumento where idlista=cn_idlista_serviceid
                     and idcomponente=cn_idcomponente_cable_bas
                     and codigo2=ln_codinssrv_new
                             )loop



             if actualiza_datos.valortxt = actualiza_equipo.valortxt then

                  update ft_instdocumento
                   set valortxt =
                       (select valortxt
                        from ft_instdocumento
                       where idficha=actualiza_datos.idficha
                         and idlista = cn_idlista_serialnumber
                         and idcomponente = cn_idcomponente_cable_bas)
                 where idficha=actualiza_equipo.idficha
                   and idlista = cn_idlista_serialnumber
                   and idcomponente = cn_idcomponente_cable_bas;

                  update ft_instdocumento
                   set valortxt =
                       (select valortxt
                        from ft_instdocumento
                       where idficha=actualiza_datos.idficha
                         and idlista = cn_idlista_ht_address
                         and idcomponente = cn_idcomponente_cable_bas)
                 where idficha=actualiza_equipo.idficha
                   and idlista = cn_idlista_ht_address
                   and idcomponente = cn_idcomponente_cable_bas;


                  update ft_instdocumento
                   set valortxt =
                       (select valortxt
                        from ft_instdocumento
                       where idficha=actualiza_datos.idficha
                         and idlista = cn_idlista_model_stb
                         and idcomponente = cn_idcomponente_cable_bas)
                 where idficha=actualiza_equipo.idficha
                   and idlista = cn_idlista_model_stb
                   and idcomponente = cn_idcomponente_cable_bas;

				  update ft_instdocumento
                   set valortxt =
                       (select valortxt
                        from ft_instdocumento
                       where idficha=actualiza_datos.idficha
                         and idlista = cn_idlista_tipo_equ_prov
                         )
                 where idficha=actualiza_equipo.idficha
                   and idlista = cn_idlista_tipo_equ_prov;


                    update ft_instdocumento
                   set valortxt = '1'
                 where idficha=actualiza_equipo.idficha
                   and idlista = cn_idlista_estadoficha;


               end if;

      end loop actualiza_equipo;

end loop actualiza_datos;

 --Actualizacion de detprov

 select count(*) into ln_count from operacion.detprovcp where codsolot_new=an_codsolot and codaction=11;

 if ln_count > 0 then

            for lr_ficha in (select idficha, rownum as contador2 from (select distinct idficha
                      from ft_instdocumento where codigo2=ln_codinssrv_new order by 1)x
                      )loop


                          select valortxt into ln_serviceid_new from ft_instdocumento
                           where idficha= lr_ficha.idficha and idlista=cn_idlista_serviceid
                           and idcomponente=cn_idcomponente_cable_bas;


                           update operacion.detprovcp set service_id_new=ln_serviceid_new
                           where ficha_destino=lr_ficha.idficha and codaction=11 and
                           codsolot_new=an_codsolot;


            end loop lr_ficha;

end if;


exception
    when others then
      an_codrespuesta := '1';
      av_msgrespuesta := 'Procedimiento erroneo';


end;



function f_obtener_codigo_ext_x_codsrv(ac_codsrv sales.tystabsrv.codsrv%type)
  return string is
  lc_codigo_ext intraway.configuracion_itw.codigo_ext%type;
  ln_count      number;
begin

  lc_codigo_ext := null;

  select count(*)
    into ln_count
    from configuracion_itw
   where idconfigitw =
         (select codigo_ext from tystabsrv where codsrv = ac_codsrv);

  if ln_count > 0 then
    select codigo_ext
      into lc_codigo_ext
      from configuracion_itw
     where idconfigitw =
           (select codigo_ext from tystabsrv where codsrv = ac_codsrv);
  end if;

  return lc_codigo_ext;

end;


procedure identificar_Accion(an_codsolot     number,
                                   an_codrespuesta out number,
                                   av_msgrespuesta out varchar2) as

    ln_flg_chg_equipo           number;
    ln_pid_princ_new            insprd.pid%type;
    lr_inssrv_new               inssrv%rowtype;
    ln_codinssrv_new            inssrv.codinssrv%type;
    ln_codinssrv_old            inssrv.codinssrv%type;
    ln_pid_princ_old            insprd.pid%type;
    lv_velocidad_old            configuracion_itw.codigo_ext%type;
    lv_velocidad_new            configuracion_itw.codigo_ext%type;
    ln_insidcom_old             ft_instdocumento.insidcom%type;
    ln_servicetype_old          ft_instdocumento.valortxt%type;
    ln_insidcom_new             ft_instdocumento.insidcom%type;
    lv_servicetype_new          configuracion_itw.codigo_ext%type;
    ln_codsrv_count             number;
    ln_count_adic               number;
    lv_minutos_old              configuracion_itw.codigo_ext%type;
    lv_minutos_new              configuracion_itw.codigo_ext%type;
    lv_plan_old                 configuracion_itw.codigo_ext%type;
    lv_plan_new                 configuracion_itw.codigo_ext%type;
    ln_count_tipsrv             number;
    lv_dscsrv_new               tystabsrv.dscsrv%type;
  lv_dscsrv_old                 tystabsrv.dscsrv%type;
    ln_sum_new                  number;
    ln_sum_old                  number;
    ln_count_new                number;
    ln_count_old                number;
    ln_tipequ_telf_count        number;
    ln_tipequ_telf              number;
    ln_tipequ_modem             number;
    ln_observacion              varchar2(100);
    ln_codcli                   inssrv.codcli%type;
    ln_codsuc                   inssrv.codsuc%type;
    ln_count                    number;
    ln_idpaq                    inssrv.idpaq%type;
    ln_codequcom_old            insprd.codequcom%type;
    ln_count_ab                 number;
    ln_count_a                  number;
    ln_count_q                  number;
    ln_count_qa                 number;
    ln_tipoqueprov_old          vtaequcom.tip_eq%type;
    ln_iddet                    number;
    ln_customer                 solot.customer_id%type;
    ln_idficha_new              ft_instdocumento.idficha%type;
    ln_serviceid_new            ft_instdocumento.valortxt%type;
    ln_count_deco               number;
    ln_pid_old                  insprd.pid%type;
    ln_idficha_old              ft_instdocumento.idficha%type;
    ln_service_id               ft_instdocumento.valortxt%type;
    ln_service_type             ft_instdocumento.valortxt%type;
    ln_cantidad                 number;
    lv_bucle                    number;
    lv_bucle_2                  number;
    ln_sec                      number;
    ln_tipoqueprov_telf         vtaequcom.tip_eq%type;
    ln_codequcom_telf           insprd.codequcom%type;
    ln_cantidad_new             number;
    ln_deco_actu                number;
    lv_des_minutos_new          tystabsrv.abrev%type;
    lv_des_minutos_old          tystabsrv.abrev%type;
    lv_des_cable_old            tystabsrv.abrev%type;
    lv_des_cable_new            tystabsrv.abrev%type;

    ln_count_tipsrv_TELEFONIA   number;
    n_orden number;
    n_idficha                   ft_instdocumento.idficha%type;
   n_insidcom                   ft_instdocumento.insidcom%type;
   n_iddocumento_pid               number;
   v_valortxt_pid ft_instdocumento.valortxt%type;
   lc_codcli      inssrv.codcli%type;
   lc_codsuc      inssrv.codsuc%type;
   ln_codinssrv_old_telf  inssrv.codinssrv%type;
   ln_tiptra  solot.tiptra%type;
   
  cursor cur_campo_pid IS
  select a.idlista,a.cantidadpid,a.cantidad,a.etiqueta,a.flgnecesario,
  a.idcomponente,b.idtipoobjeto,a.tipo,a.valorcampo,a.idcampo,a.orden,a.flgvisible
  from ft_campo a,ft_lista b
  where a.idlista=b.idlista
  and a.iddocumento =n_iddocumento_pid
  and a.estado = 1;
  
   
  begin
    -------------------------------------------------------------------------------------------------------------
    -- TELEFONIA INICIO
    ----------------------------------------------------------------------------------------------
    an_codrespuesta :=0;
    av_msgrespuesta := 'Exito';
    ln_flg_chg_equipo := 0;
    ln_codinssrv_old := 0;
    ln_tipequ_telf := 0;
    ln_tipequ_modem := 0;
    ln_observacion:= '';
    ln_count_a := 0;
    ln_count_ab:=0;
    ln_count_q := 0;


    select customer_id,tiptra into ln_customer,ln_tiptra from solot where codsolot=an_codsolot;

    select
       distinct b.codcli, b.codsuc, b.idpaq into ln_codcli, ln_codsuc, ln_idpaq
       from solotpto a, inssrv b, insprd c
       where b.codinssrv = a.codinssrv
       and c.pid = a.pid
       and a.codsolot = an_codsolot;
  
  --Identificacion de Traslado Externo e Interno------------------------------
  ----------------------------------------------------------------------------   
  if ln_tiptra = 693 or ln_tiptra=694 then   
     
     select
       distinct b.codcli, b.codsuc, b.idpaq into ln_codcli, ln_codsuc, ln_idpaq
       from solotpto a, inssrv b, insprd c
       where b.codinssrv = a.codinssrv
       and c.pid = a.pid
       and a.codsolot = an_codsolot;
       
       
      ---Telefonia
		select count(*)
        into ln_count_tipsrv
        from solotpto a, inssrv b, insprd c
       where b.codinssrv = a.codinssrv
         and c.pid = a.pid
         and b.codinssrv = c.codinssrv
         and a.codsolot = an_codsolot
         and b.tipsrv = cc_tipsrv_telefonia;
		 
		 if ln_count_tipsrv >0 then
			
			 begin
					  select c.pid, b.codinssrv
						into ln_pid_princ_new, ln_codinssrv_new
						from solotpto a, inssrv b, insprd c
					   where b.codinssrv = a.codinssrv
						 and c.pid = a.pid
						 and b.codinssrv = c.codinssrv
						 and a.codsolot = an_codsolot
						 and b.tipsrv = cc_tipsrv_telefonia
						 and c.flgprinc = 1;

					select *
						into lr_inssrv_new
						from inssrv
					   where codinssrv = ln_codinssrv_new;

					 select a.codigo_ext
						  into lv_minutos_new
						  from configuracion_itw a, tystabsrv b, insprd c
						 where a.idconfigitw = b.codigo_ext
						   and c.pid = ln_pid_princ_new
						   and b.codsrv = c.codsrv;

					exception
					  when others then
						ln_pid_princ_new := 0;
			end;
		 
			if ln_pid_princ_new <> 0 then


				  -- Se crea nueva ficha al tocar el servicio principal
				  sgacrm.pq_fichatecnica.p_crear_instdoc('INSPRD_EQU',
														 ln_pid_princ_new,
														 ln_codinssrv_new,
														 to_char(ln_customer));

				  select distinct idficha into ln_idficha_new from ft_instdocumento where codigo1= ln_pid_princ_new;


				--se busca si hay un inssrv de internet anterior activo o suspendido
				select nvl(max(codinssrv), 0)
				  into ln_codinssrv_old_telf
				  from inssrv
				 where codinssrv < lr_inssrv_new.codinssrv
				   and estinssrv = 1
				   and codcli = lr_inssrv_new.codcli
				   and tipsrv = cc_tipsrv_telefonia;
				   
								 -- Calcular pid Principal old
					  select pid
						into ln_pid_princ_old
						from insprd
					   where codinssrv = ln_codinssrv_old_telf
						 and flgprinc = 1
						 and estinsprd = 1;

					   --Actualiza el Estado en la nueva ficha

					   update ft_instdocumento
						   set valortxt = '1'
						 where codigo1 = ln_pid_princ_new
						   and idlista = cn_idlista_estadoficha;

						-- Actualiza el SERVICE_ID Principal en la nueva ficha
						update ft_instdocumento
						   set valortxt =
							   (select valortxt
								  from ft_instdocumento
								 where codigo1 = ln_pid_princ_old
								   and idlista = cn_idlista_serviceid
								   and idcomponente = cn_idcomponente_telefonia)
						 where codigo1 = ln_pid_princ_new
						   and idlista = cn_idlista_serviceid
						   and idcomponente = cn_idcomponente_telefonia;


						-- Actualiza los CALL_FEATURES en la nueva ficha

					   update sgacrm.ft_instdocumento
						 set valortxt =
							 (select valortxt
								from sgacrm.ft_instdocumento
							   where codigo1 = ln_pid_princ_old
								 and idlista = cn_idlista_call_features)
					   where codigo1 = ln_pid_princ_new
						 and idlista = cn_idlista_call_features;

						-- Actualiza los datos del equipo en la nueva ficha

					   update sgacrm.ft_instdocumento
						 set valortxt =
							 (select valortxt
								from sgacrm.ft_instdocumento
							   where codigo1 = ln_pid_princ_old
								 and idlista = cn_idlista_macad_cm)
					   where codigo1 = ln_pid_princ_new
						 and idlista = cn_idlista_macad_cm;

					  update sgacrm.ft_instdocumento
						 set valortxt =
							 (select valortxt
								from sgacrm.ft_instdocumento
							   where codigo1 = ln_pid_princ_old
								 and idlista = cn_idlista_model_cm)
					   where codigo1 = ln_pid_princ_new
						 and idlista = cn_idlista_model_cm;

					  update sgacrm.ft_instdocumento
						 set valortxt =
							 (select valortxt
								from sgacrm.ft_instdocumento
							   where codigo1 = ln_pid_princ_old
								 and idlista = cn_idlista_macaddress_mta)
					   where codigo1 = ln_pid_princ_new
						 and idlista = cn_idlista_macaddress_mta;

					  update sgacrm.ft_instdocumento
						 set valortxt =
							 (select valortxt
								from sgacrm.ft_instdocumento
							   where codigo1 = ln_pid_princ_old
								 and idlista = cn_idlista_model_mta)
					   where codigo1 = ln_pid_princ_new
						 and idlista = cn_idlista_model_mta;

			end if;
		 
		 
		 end if; 
       
  --Internet
	
		select count(*)
        into ln_count_tipsrv
        from solotpto a, inssrv b, insprd c
       where b.codinssrv = a.codinssrv
         and c.pid = a.pid
         and b.codinssrv = c.codinssrv
         and a.codsolot = an_codsolot
         and b.tipsrv = cc_tipsrv_internet;
		 
		if ln_count_tipsrv > 0 then

			begin
			  select c.pid, b.codinssrv
				into ln_pid_princ_new, ln_codinssrv_new
				from solotpto a, inssrv b, insprd c
			   where b.codinssrv = a.codinssrv
				 and c.pid = a.pid
				 and b.codinssrv = c.codinssrv
				 and a.codsolot = an_codsolot
				 and b.tipsrv = cc_tipsrv_internet
				 and c.flgprinc = 1;

			  select *
				into lr_inssrv_new
				from inssrv
			   where codinssrv = ln_codinssrv_new;


			   select a.codigo_ext
				  into lv_velocidad_new
				  from configuracion_itw a, tystabsrv b, insprd c
				 where a.idconfigitw = b.codigo_ext
				   and c.pid = ln_pid_princ_new
				   and b.codsrv = c.codsrv;

			exception
			  when others then
				ln_pid_princ_new := 0;

			end;
			
		if ln_pid_princ_new <> 0 then

			-- Se crea nueva ficha al tocar el servicio principal
			sgacrm.pq_fichatecnica.p_crear_instdoc('INSPRD_EQU',
                                             ln_pid_princ_new,
                                             ln_codinssrv_new,
                                             to_char(ln_customer)
                                             );

			select distinct idficha into ln_idficha_new from ft_instdocumento where codigo1= ln_pid_princ_new;


			--se busca si hay un inssrv de internet anterior activo o suspendido

			select nvl(max(codinssrv), 0)
			  into ln_codinssrv_old
			  from inssrv
			 where codinssrv < lr_inssrv_new.codinssrv
			   and estinssrv = 1
			   and codcli = lr_inssrv_new.codcli
			   and tipsrv = cc_tipsrv_internet;
			   
			   
			    -- Calcular pid Principal old
      select pid
        into ln_pid_princ_old
        from insprd
       where codinssrv = ln_codinssrv_old
         and flgprinc = 1
         and estinsprd = 1;

-- Actualiza el Estado en la nueva ficha

           update ft_instdocumento
           set valortxt = '1'
         where codigo1 = ln_pid_princ_new
           and idlista = cn_idlista_estadoficha;

        -- Actualiza el SERVICE_ID Principal en la nueva ficha
        update ft_instdocumento
           set valortxt =
               (select valortxt
                  from ft_instdocumento
                 where codigo1 = ln_pid_princ_old
                   and idlista = cn_idlista_serviceid
                   and idcomponente = cn_idcomponente_internet)
         where codigo1 = ln_pid_princ_new
           and idlista = cn_idlista_serviceid
           and idcomponente = cn_idcomponente_internet;

        -- Actualiza MAC y MODEL de equipo en la nueva ficha
        update ft_instdocumento
           set valortxt =
               (select valortxt
                  from ft_instdocumento
                 where codigo1 = ln_pid_princ_old
                   and idlista = cn_idlista_macad_cm)
         where codigo1 = ln_pid_princ_new
           and idlista = cn_idlista_macad_cm;

        update ft_instdocumento
           set valortxt =
               (select valortxt
                  from ft_instdocumento
                 where codigo1 = ln_pid_princ_old
                   and idlista = cn_idlista_model_cm)
         where codigo1 = ln_pid_princ_new
           and idlista = cn_idlista_model_cm;
  
			  
			end if;
		
		end if; 
  
  --Cable
	
	select count(*)
        into ln_count_tipsrv
        from solotpto a, inssrv b, insprd c
       where b.codinssrv = a.codinssrv
         and c.pid = a.pid
         and b.codinssrv = c.codinssrv
         and a.codsolot = an_codsolot
         and b.tipsrv = cc_tipsrv_cable;
	
		if ln_count_tipsrv > 0 then
		
			begin
				  select c.pid, b.codinssrv
					into ln_pid_princ_new, ln_codinssrv_new
					from solotpto a, inssrv b, insprd c
				   where b.codinssrv = a.codinssrv
					 and c.pid = a.pid
					 and b.codinssrv = c.codinssrv
					 and a.codsolot = an_codsolot
					 and b.tipsrv = cc_tipsrv_cable
					 and c.flgprinc = 1;

				select *
					into lr_inssrv_new
					from inssrv
				   where codinssrv = ln_codinssrv_new;

				   select a.codigo_ext
					  into lv_plan_new
					  from configuracion_itw a, tystabsrv b, insprd c
					 where a.idconfigitw = b.codigo_ext
					   and c.pid = ln_pid_princ_new
					   and b.codsrv = c.codsrv;

				exception
				  when others then
					ln_pid_princ_new := 0;
			end;
		
		if ln_pid_princ_new <> 0 then
				  -- Se crea nueva ficha al tocar el servicio principal

				  agregarServicioCable(ln_codinssrv_new,ln_customer);

				--se busca si hay un inssrv de internet anterior activo o suspendido
				select nvl(max(codinssrv), 0)
				  into ln_codinssrv_old
				  from inssrv
				 where codinssrv < lr_inssrv_new.codinssrv
				   and estinssrv = 1
				   and codcli = lr_inssrv_new.codcli
				   and tipsrv = cc_tipsrv_cable;
				   
				  actualiza_cable(ln_codinssrv_old,
                                   ln_codinssrv_new,
                                   an_codsolot,
                                   an_codrespuesta,
                                   av_msgrespuesta);

		end if;
		
		
		end if;
    
    
  --SOT que no son de traslado------------------------------------------------------------
  ------------------------------------------------------------------------------------------ 
  else
    
   select count(*)
        into ln_count_tipsrv
        from solotpto a, inssrv b, insprd c
       where b.codinssrv = a.codinssrv
         and c.pid = a.pid
         and b.codinssrv = c.codinssrv
         and a.codsolot = an_codsolot
         and b.tipsrv = cc_tipsrv_telefonia;

         if ln_count_tipsrv = 0 then

             select count(*) into ln_count from inssrv where codcli=ln_codcli and codsuc=ln_codsuc
             and tipsrv=cc_tipsrv_telefonia and estinssrv=1;

           if ln_count > 0 then

                select 'Quitar servicio de Telefonia'
                into ln_observacion  from dual;
               --Quitar servicio de Telefonia
               crearDetCP(an_codsolot,
                                     5,
                                     ln_flg_chg_equipo,
                                     ln_codcli,
                                     ln_codsuc,
                                     ln_idpaq,
                                     '',
                                     '',
                                     ln_observacion,
                                     'Telefonia',
                                     1,
                                     an_codrespuesta,
                                     av_msgrespuesta);

         select max(iddet) into ln_iddet from operacion.detcp where codsolot= an_codsolot and codaction=5;

           select distinct a.codinssrv, b.pid,c.idficha
           into ln_codinssrv_old,ln_pid_old,ln_idficha_old
           from inssrv a, insprd b, ft_instdocumento c where a.codcli=ln_codcli and a.codsuc=ln_codsuc
           and a.codinssrv=b.codinssrv and b.flgprinc=1 and c.codigo1=b.pid
            and c.codigo2=a.codinssrv  and tipsrv=cc_tipsrv_telefonia and a.estinssrv=1;

           select valortxt into ln_service_id from ft_instdocumento where codigo1=ln_pid_old
           and idlista=cn_idlista_serviceid and idcomponente=cn_idcomponente_telefonia;
           select valortxt into ln_service_type from ft_instdocumento where codigo1=ln_pid_old
           and idlista=cn_idlista_servicetype and idcomponente=cn_idcomponente_telefonia;

            crear_detprovcp(ln_iddet,
                           ln_customer,
                           ln_idficha_old,
                           '',
                           ln_service_id,
                           '',
                           ln_service_type,
                           '',
                           '',
                           4,
                           '',
                           '',
                           an_codsolot,
                           an_codrespuesta,
                           av_msgrespuesta);

           GOTO Avanza_Internet;
           end if;
         end if;

     --Validamos si hay cambio de equipo:

   for lr_solotpto in (select a.codsolot,
                               a.codinssrv,
                              a.pid,
                               c.flgprinc,
                               a.codsrvnue,
                               b.codcli,
                               b.codsuc,
                               b.idpaq,
                               b.tipsrv,
                               c.codequcom
                          from solotpto a, inssrv b, insprd c
                         where b.codinssrv = a.codinssrv
                           and c.pid = a.pid
                           and a.codsolot = an_codsolot
                           and b.tipsrv = cc_tipsrv_telefonia
                           and c.codequcom is not null
                         ) loop

        --se busca si hay un inssrv anterior activo o suspendido
        select nvl(max(codinssrv), 0)
          into ln_codinssrv_old
          from inssrv
         where codinssrv < lr_solotpto.codinssrv
           and estinssrv in (1)
           and codcli = lr_solotpto.codcli
           and codsuc = lr_solotpto.codsuc
           and idpaq = lr_solotpto.idpaq
           and tipsrv = lr_solotpto.tipsrv;

    if ln_codinssrv_old > 0 then

     select count(*)
              into ln_tipequ_telf_count
              from insprd a, equcomxope b, tipequ c
              where a.codinssrv = lr_solotpto.codinssrv
              and a.codequcom is not null
              and b.codequcom = a.codequcom
              and c.codtipequ = b.codtipequ
              and c.tipo = 'TELEFONO'
              and a.pid = lr_solotpto.pid;

              if ln_tipequ_telf_count = 1 then

                  -- Valida si cambio telefonos nuevos contra viejos
                  select nvl(sum(a.cantidad), 0)
                    into ln_sum_new
                    from insprd a, equcomxope b, tipequ c
                   where a.codinssrv = lr_solotpto.codinssrv
                    and a.codequcom is not null
                     and b.codequcom = a.codequcom
                     and c.codtipequ = b.codtipequ
                     and c.tipo = 'TELEFONO'
                     and a.codequcom not in
                         (select codequcom
                            from insprd
                           where codinssrv = ln_codinssrv_old
                             and codequcom is not null);

                  -- Valida si cambio telefonos viejos contra nuevos
                  select nvl(sum(a.cantidad), 0)
                    into ln_sum_old
                    from insprd a, equcomxope b, tipequ c
                   where a.codinssrv = ln_codinssrv_old
                     and a.codequcom is not null
                     and b.codequcom = a.codequcom
                     and c.codtipequ = b.codtipequ
                     and c.tipo = 'TELEFONO'
                     and a.codequcom not in
                         (select codequcom
                            from insprd
                           where codinssrv = lr_solotpto.codinssrv
                             and codequcom is not null);

                      if ln_sum_new + ln_sum_old > 0 then
                          ln_tipequ_telf := 1;
                       end if;


              elsif ln_tipequ_telf_count = 0 then

                    -- Valida si cambio MTA viejo contra nuevo
                    select nvl(sum(a.cantidad), 0)
                      into ln_count_new
                      from insprd a, equcomxope b, tipequ c
                     where a.codinssrv = lr_solotpto.codinssrv
                       and a.codequcom is not null
                       and b.codequcom = a.codequcom
                       and c.codtipequ = b.codtipequ
                       and c.tipo <> 'TELEFONO'
                       and a.codequcom not in
                           (select codequcom
                              from insprd
                             where codinssrv = ln_codinssrv_old
                               and codequcom is not null);

                    -- Valida si cambio MTA Nuevo contra viejo
                    select nvl(sum(a.cantidad), 0)
                      into ln_count_old
                      from insprd a, equcomxope b, tipequ c
                     where a.codinssrv = ln_codinssrv_old
                       and a.codequcom is not null
                       and b.codequcom = a.codequcom
                       and c.codtipequ = b.codtipequ
                       and c.tipo <> 'TELEFONO'
                       and a.codequcom not in
                           (select codequcom
                              from insprd
                             where codinssrv = lr_solotpto.codinssrv
                               and codequcom is not null);


                      if ln_count_new + ln_count_old > 0 then
                         ln_tipequ_modem := 1;
                      end if;


              end if;
    end if;

   end loop lr_solotpto;

   if ln_tipequ_telf = 1 or ln_tipequ_modem = 1 then
    ln_flg_chg_equipo := 1;

     if ln_tipequ_modem = 1 then


       select b.tipo_equ_prov,a.codequcom into ln_tipoqueprov_old, ln_codequcom_old
                     from insprd a,vtaequcom b , equcomxope c, tipequ d
                    where a.codinssrv= ln_codinssrv_old
                    and a.codequcom is not null
                    and a.codequcom=c.codequcom
                    and c.codtipequ = d.codtipequ
                    and d.tipo <> 'TELEFONO'
                    and a.codequcom=b.codequcom;

       select 'Cambiar equipo '||ln_tipoqueprov_old
                       into ln_observacion
                       from dual;



        crearDetCP(   an_codsolot,
                                     16,
                                     ln_flg_chg_equipo,
                                     ln_codcli,
                                     ln_codsuc,
                                     ln_idpaq,
                                     '',
                                     '',
                                     ln_observacion,
                                     ln_tipoqueprov_old,
                                     1,
                                     an_codrespuesta,
                                     av_msgrespuesta);



    end if;



    if ln_tipequ_telf = 1 then

       select b.tipo_equ_prov,a.codequcom into ln_tipoqueprov_telf, ln_codequcom_telf
                     from insprd a,vtaequcom b , equcomxope c, tipequ d
                    where a.codinssrv= ln_codinssrv_old
                    and a.codequcom is not null
                    and a.codequcom=c.codequcom
                    and c.codtipequ = d.codtipequ
                    and d.tipo = 'TELEFONO'
                    and a.codequcom=b.codequcom;

       select 'Cambiar equipo '||ln_tipoqueprov_telf
                       into ln_observacion
                       from dual;


                      crearDetCP(   an_codsolot,
                                     16,
                                     ln_flg_chg_equipo,
                                     ln_codcli,
                                     ln_codsuc,
                                     ln_idpaq,
                                     '',
                                     '',
                                     ln_observacion,
                                     ln_tipoqueprov_telf,
                                     1,
                                     an_codrespuesta,
                                     av_msgrespuesta);


    end if;


 else
    ln_flg_chg_equipo := 0;
 end if;

  -- Validamos si modifica servicio principal, se captura pid y INSSRV
    begin
      select c.pid, b.codinssrv
        into ln_pid_princ_new, ln_codinssrv_new
        from solotpto a, inssrv b, insprd c
       where b.codinssrv = a.codinssrv
         and c.pid = a.pid
         and b.codinssrv = c.codinssrv
         and a.codsolot = an_codsolot
         and b.tipsrv = cc_tipsrv_telefonia
         and c.flgprinc = 1;

    select *
        into lr_inssrv_new
        from inssrv
       where codinssrv = ln_codinssrv_new;

     select a.codigo_ext
          into lv_minutos_new
          from configuracion_itw a, tystabsrv b, insprd c
         where a.idconfigitw = b.codigo_ext
           and c.pid = ln_pid_princ_new
           and b.codsrv = c.codsrv;

    exception
      when others then
        ln_pid_princ_new := 0;
    end;

    -- Si no tiene servicio proncipal anterior es OBVIO que tiene servicio principal nuevo en la SOT
    if ln_pid_princ_new <> 0 then


      -- Se crea nueva ficha al tocar el servicio principal
      sgacrm.pq_fichatecnica.p_crear_instdoc('INSPRD_EQU',
                                             ln_pid_princ_new,
                                             ln_codinssrv_new,
                                             to_char(ln_customer));

      select distinct idficha into ln_idficha_new from ft_instdocumento where codigo1= ln_pid_princ_new;


    --se busca si hay un inssrv de internet anterior activo o suspendido
    select nvl(max(codinssrv), 0)
      into ln_codinssrv_old_telf
      from inssrv
     where codinssrv < lr_inssrv_new.codinssrv
       and estinssrv = 1
       and codcli = lr_inssrv_new.codcli
       and codsuc = lr_inssrv_new.codsuc
       and tipsrv = cc_tipsrv_telefonia;

    end if;

    --Se valida que la sot modifica el servicio principal, pero no tiene codigo de servicio anterior.

  if ln_pid_princ_new > 0 and ln_codinssrv_old_telf = 0 then

     select b.abrev
          into lv_minutos_new
          from  tystabsrv b, insprd c
         where c.pid = ln_pid_princ_new
           and b.codsrv = c.codsrv;

      select 'Agregar nuevo servicio ' ||lv_minutos_new
         into ln_observacion from dual;


      -- Action 1 Agregar Servicio Telefonia
      crearDetCP(an_codsolot,
                 2,
                 1,
                 lr_inssrv_new.codcli,
                 lr_inssrv_new.codsuc,
                 lr_inssrv_new.idpaq,
                 '',
                 '',
                 ln_observacion,
                 lv_minutos_new,
                 1,
                 an_codrespuesta,
                 av_msgrespuesta);


      select max(iddet) into ln_iddet from operacion.detcp where codsolot= an_codsolot and codaction=2;

       select valortxt into ln_serviceid_new from ft_instdocumento
         where codigo1=ln_pid_princ_new and idlista=cn_idlista_serviceid
         and idcomponente=cn_idcomponente_telefonia;

         select valortxt into lv_minutos_new from ft_instdocumento
         where codigo1=ln_pid_princ_new and idlista=cn_idlista_servicetype
         and idcomponente=cn_idcomponente_telefonia;

          crear_detprovcp(ln_iddet,
                           ln_customer,
                           '',
                           ln_idficha_new,
                           '',
                           ln_serviceid_new,
                           '',
                           lv_minutos_new,
                           '',
                           4,
                           '',
                           '',
                           an_codsolot,
                           an_codrespuesta,
                           av_msgrespuesta);



      GOTO Avanza_Internet;

    --Se valida que la sot modifica el servicio principal, pero tiene codigo de servicio anterior.

  elsif ln_pid_princ_new > 0 and ln_codinssrv_old_telf > 0 then

      -- Calcular pid Principal old
      select pid
        into ln_pid_princ_old
        from insprd
       where codinssrv = ln_codinssrv_old_telf
         and flgprinc = 1
         and estinsprd = 1;

       --Actualiza el Estado en la nueva ficha

       update ft_instdocumento
           set valortxt = '1'
         where codigo1 = ln_pid_princ_new
           and idlista = cn_idlista_estadoficha;

        -- Actualiza el SERVICE_ID Principal en la nueva ficha
        update ft_instdocumento
           set valortxt =
               (select valortxt
                  from ft_instdocumento
                 where codigo1 = ln_pid_princ_old
                   and idlista = cn_idlista_serviceid
                   and idcomponente = cn_idcomponente_telefonia)
         where codigo1 = ln_pid_princ_new
           and idlista = cn_idlista_serviceid
           and idcomponente = cn_idcomponente_telefonia;

        
        -- Actualiza los CALL_FEATURES en la nueva ficha

       update sgacrm.ft_instdocumento
         set valortxt =
             (select valortxt
                from sgacrm.ft_instdocumento
               where codigo1 = ln_pid_princ_old
                 and idlista = cn_idlista_call_features)
       where codigo1 = ln_pid_princ_new
         and idlista = cn_idlista_call_features;

        -- Actualiza los datos del equipo en la nueva ficha

       update sgacrm.ft_instdocumento
         set valortxt =
             (select valortxt
                from sgacrm.ft_instdocumento
               where codigo1 = ln_pid_princ_old
                 and idlista = cn_idlista_macad_cm)
       where codigo1 = ln_pid_princ_new
         and idlista = cn_idlista_macad_cm;

      update sgacrm.ft_instdocumento
         set valortxt =
             (select valortxt
                from sgacrm.ft_instdocumento
               where codigo1 = ln_pid_princ_old
                 and idlista = cn_idlista_model_cm)
       where codigo1 = ln_pid_princ_new
         and idlista = cn_idlista_model_cm;

      update sgacrm.ft_instdocumento
         set valortxt =
             (select valortxt
                from sgacrm.ft_instdocumento
               where codigo1 = ln_pid_princ_old
                 and idlista = cn_idlista_macaddress_mta)
       where codigo1 = ln_pid_princ_new
         and idlista = cn_idlista_macaddress_mta;

      update sgacrm.ft_instdocumento
         set valortxt =
             (select valortxt
                from sgacrm.ft_instdocumento
               where codigo1 = ln_pid_princ_old
                 and idlista = cn_idlista_model_mta)
       where codigo1 = ln_pid_princ_new
         and idlista = cn_idlista_model_mta;


        -- Validar si hay cambio de servicio
        select a.codigo_ext,b.abrev
          into lv_minutos_old, lv_des_minutos_old
          from configuracion_itw a, tystabsrv b, insprd c
         where a.idconfigitw = b.codigo_ext
           and c.pid = ln_pid_princ_old
           and b.codsrv = c.codsrv;

        select a.codigo_ext,b.abrev
          into lv_minutos_new , lv_des_minutos_new
          from configuracion_itw a, tystabsrv b, insprd c
         where a.idconfigitw = b.codigo_ext
           and c.pid = ln_pid_princ_new
           and b.codsrv = c.codsrv;

         select valortxt into ln_serviceid_new from ft_instdocumento
         where codigo1=ln_pid_princ_new and idlista=cn_idlista_serviceid
         and idcomponente=cn_idcomponente_telefonia;

         select distinct d.idficha into ln_idficha_old
         from solotpto a, solot b, insprd c , ft_instdocumento d
         where a.codinssrv= ln_codinssrv_old_telf and a.codinssrv=c.codinssrv and a.pid=c.pid
         and c.flgprinc=1 and a.codsolot=b.codsolot and c.codinssrv=d.codigo2 and d.codigo3=to_char(ln_customer);

       select valortxt into ln_service_id from ft_instdocumento where idficha=ln_idficha_old
       and idlista=cn_idlista_serviceid and idcomponente=cn_idcomponente_telefonia;

        if lv_minutos_old <> lv_minutos_new then

         select 'Cambiar Minutos de ' ||lv_des_minutos_old|| ' a ' || lv_des_minutos_new
         into ln_observacion
         from dual;

          --Action 8 Cambiar Minutos Telefonia(Con y sin cambio de equipo)
          crearDetCP(an_codsolot,
                     8,
                     ln_flg_chg_equipo,
                     lr_inssrv_new.codcli,
                     lr_inssrv_new.codsuc,
                     lr_inssrv_new.idpaq,
                     '',
                     '',
                     ln_observacion,
                     lv_des_minutos_new,
                      1,
                     an_codrespuesta,
                     av_msgrespuesta);



        select max(iddet) into ln_iddet from operacion.detcp where codsolot= an_codsolot and codaction=8;

          crear_detprovcp(ln_iddet,
                           ln_customer,
                           ln_idficha_old,
                           ln_idficha_new,
                           ln_service_id,
                           ln_serviceid_new,
                           lv_minutos_old,
                           lv_minutos_new,
                           '',
                           4,
                           '',
                           '',
                           an_codsolot,
                           an_codrespuesta,
                           av_msgrespuesta);


        end if;

        if ln_flg_chg_equipo = 1 then

          for lr_equipo in(
                            select iddet,tipo_equ_prov from operacion.detcp
                            where codsolot= an_codsolot and codaction=16
                            )loop

            if lr_equipo.tipo_equ_prov = ln_tipoqueprov_old then

                     crear_detprovcp(lr_equipo.iddet,
                           ln_customer,
                           ln_idficha_old,
                           ln_idficha_new,
                           ln_service_id,
                           ln_serviceid_new,
                           lv_minutos_old,
                           lv_minutos_new,
                           '',
                           4,
                           ln_codequcom_old,
                           '',
                           an_codsolot,
                           an_codrespuesta,
                           av_msgrespuesta);

            elsif lr_equipo.tipo_equ_prov = ln_tipoqueprov_telf  then

                      crear_detprovcp(lr_equipo.iddet,
                           ln_customer,
                           ln_idficha_old,
                           ln_idficha_new,
                           ln_service_id,
                           ln_serviceid_new,
                           lv_minutos_old,
                           lv_minutos_new,
                           '',
                           4,
                           ln_codequcom_telf,
                           '',
                           an_codsolot,
                           an_codrespuesta,
                           av_msgrespuesta);

            end if;

          end loop lr_equipo;

        end if;

 end if;



   -------------------------------------------------------------------------------------------------------------
    -- INTERNET INICIO
    ----------------------------------------------------------------------------------------------
<<Avanza_Internet>>
ln_flg_chg_equipo := 0;
    ln_codinssrv_old := 0;


 select count(*)
 into ln_count_tipsrv_TELEFONIA
        from solotpto a, inssrv b, insprd c
       where b.codinssrv = a.codinssrv
         and c.pid = a.pid
         and b.codinssrv = c.codinssrv
         and a.codsolot = an_codsolot
         and b.tipsrv = cc_tipsrv_telefonia;

         
select count(*)
        into ln_count_tipsrv
        from solotpto a, inssrv b, insprd c
       where b.codinssrv = a.codinssrv
         and c.pid = a.pid
         and b.codinssrv = c.codinssrv
         and a.codsolot = an_codsolot
         and b.tipsrv = cc_tipsrv_internet;

         if ln_count_tipsrv_TELEFONIA > 0 and ln_count_tipsrv = 0 then
   
                n_orden := 0;
   
              SELECT CODIGON
               INTO n_iddocumento_pid--documento con velocidad 0
               FROM tipopedd a,opedd  b
               WHERE a.TIPOPEDD=b.Tipopedd
               AND a.abrev='ALTA_PROV'
               AND b.ABREVIACION = 'INTERNET_0';
   
              select operacion.seq_idficha.nextval into n_idficha from dummy_sgacrm;
              select OPERACION.SQ_INSIDCOM.nextval into n_insidcom from dummy_sgacrm;
            
              for cur_c_pid in cur_campo_pid loop
                   n_orden := n_orden + 1;
                  
                     if cur_c_pid.tipo =1 then--Constante
                       v_valortxt_pid := cur_c_pid.valorcampo;
                     elsif cur_c_pid.tipo =2 then--Execute
                       v_valortxt_pid := sgacrm.pq_fichatecnica.f_obt_valor(cur_c_pid.idcampo,ln_pid_princ_new);
                     elsif cur_c_pid.tipo =3 then--Execute argumento numerico 1
                       v_valortxt_pid := sgacrm.pq_fichatecnica.f_obt_valor(cur_c_pid.idcampo,ln_pid_princ_new);
                     elsif cur_c_pid.tipo =4 then--Execute argumento numerico 2
                       v_valortxt_pid := sgacrm.pq_fichatecnica.f_obt_valor(cur_c_pid.idcampo,ln_pid_princ_new);
                       null;
                     end if;
                     insert into ft_instdocumento (idficha, orden, iddocumento, idtabla, codigo1, codigo2, codigo3, codigo4,
                     idlista, etiqueta, flgnecesario, valortxt, idcomponente, ordencomponente,insidcom,flgvisible)
                     values(n_idficha, n_orden,n_iddocumento_pid, 40, ln_pid_princ_new, ln_codinssrv_new,ln_customer,'',
                     cur_c_pid.idlista, cur_c_pid.etiqueta,cur_c_pid.flgnecesario,v_valortxt_pid, cur_c_pid.idcomponente,
                     1,n_insidcom,cur_c_pid.flgvisible);
                   
                 end loop;

                 --Obtenemos el pid principal del servicio actual de Internet.  
                 select distinct codcli, codsuc
                  into lc_codcli, lc_codsuc
                  from inssrv
                 where codinssrv in
                       (select codinssrv from solotpto where codsolot = an_codsolot);

                  select c.pid
                    into ln_pid_princ_old
                    from inssrv b, insprd c
                   where b.codcli = lc_codcli
                     and b.codsuc = lc_codsuc
                     and b.estinssrv in (1,2)
                     and c.codinssrv = b.codinssrv
                     and c.estinsprd in (1,2)
                     and c.flgprinc = 1
                     and b.tipsrv = cc_tipsrv_internet;
                    
                  --Actualiza estado de estado de ficha
                    update ft_instdocumento
                     set valortxt = '1'
                   where codigo1 = ln_pid_princ_new
                     and idlista = cn_idlista_estadoficha
                     and idcomponente = cn_idcomponente_internet;

                -- Actualiza el SERVICE_ID Principal en la nueva ficha
                update ft_instdocumento
                   set valortxt =
                       (select valortxt
                          from ft_instdocumento
                         where codigo1 = ln_pid_princ_old
                           and idlista = cn_idlista_serviceid
                           and idcomponente = cn_idcomponente_internet)
                 where codigo1 = ln_pid_princ_new
                   and idlista = cn_idlista_serviceid
                   and idcomponente = cn_idcomponente_internet;
                   
                   
                   --Actualizamos los datos de equipo de la ficha de Internet
                   update ft_instdocumento
                     set valortxt =
                         (select valortxt
                            from ft_instdocumento
                           where codigo1 = ln_pid_princ_old
                             and idlista = cn_idlista_macad_cm)
                   where codigo1 = ln_pid_princ_new
                     and idlista = cn_idlista_macad_cm
                     and idcomponente = cn_idcomponente_internet;

                  update ft_instdocumento
                     set valortxt =
                         (select valortxt
                            from ft_instdocumento
                           where codigo1 = ln_pid_princ_old
                             and idlista = cn_idlista_model_cm)
                   where codigo1 = ln_pid_princ_new
                     and idlista = cn_idlista_model_cm
                     and idcomponente = cn_idcomponente_internet;
            
                select a.codigo_ext,b.abrev
                into lv_velocidad_old,lv_dscsrv_old
                from configuracion_itw a, tystabsrv b, insprd c
               where a.idconfigitw = b.codigo_ext
                 and c.pid = ln_pid_princ_old
                 and b.codsrv = c.codsrv;
            
                 select idficha,valortxt into ln_idficha_old, ln_service_id from ft_instdocumento 
                 where codigo1=ln_pid_princ_old
                 and idlista=cn_idlista_serviceid
                 and idcomponente = cn_idcomponente_internet;
                 
                 select idficha,valortxt into ln_idficha_new, ln_serviceid_new from ft_instdocumento 
                 where codigo1=ln_pid_princ_new
                 and idlista=cn_idlista_serviceid
                 and idcomponente = cn_idcomponente_internet;
         
                  select 'Cambiar velocidad de ' ||lv_dscsrv_old|| ' a ' || 'InfinitumVoz'
                  into ln_observacion
                  from dual;
                  
                  crearDetCP(an_codsolot,
                     7,
                     0,
                     lr_inssrv_new.codcli,
                     lr_inssrv_new.codsuc,
                     lr_inssrv_new.idpaq,
                     '',
                     '',
                     ln_observacion,
                     'InfinitumVoz',
                     1,
                     an_codrespuesta,
                     av_msgrespuesta);
            
                     select max(iddet) into ln_iddet from operacion.detcp where codsolot= an_codsolot and codaction=7;
                     
                     crear_detprovcp(ln_iddet,
                           ln_customer,
                           ln_idficha_old,
                           ln_idficha_new,
                           ln_service_id,
                           ln_serviceid_new,
                           lv_velocidad_old,
                           'InfinitumVoz',
                           '',
                           4,
                           '',
                           '',
                           an_codsolot,
                           an_codrespuesta,
                           av_msgrespuesta);
         
            GOTO avanzar_a_cable;    
            end if;


    select
       distinct b.codcli, b.codsuc, b.idpaq into ln_codcli, ln_codsuc, ln_idpaq
       from solotpto a, inssrv b, insprd c
       where b.codinssrv = a.codinssrv
       and c.pid = a.pid
       and a.codsolot = an_codsolot;

    if ln_count_tipsrv = 0 then

       select count(*) into ln_count from inssrv where codcli=ln_codcli and codsuc=ln_codsuc
       and tipsrv=cc_tipsrv_internet and estinssrv=1;

       if ln_count > 0 then


           select 'Se quitara servicio de Internet'
           into ln_observacion  from dual;
           --Quitar servicio de Internet
           crearDetCP(an_codsolot,
                                 4,
                                 ln_flg_chg_equipo,
                                 ln_codcli,
                                 ln_codsuc,
                                 ln_idpaq,
                                 '',
                                 '',
                                 ln_observacion,
                                 'Internet',
                                 1,
                                 an_codrespuesta,
                                 av_msgrespuesta);

           select max(iddet) into ln_iddet from operacion.detcp where codsolot= an_codsolot and codaction=4;

           select distinct a.codinssrv, b.pid,c.idficha
           into ln_codinssrv_old,ln_pid_old,ln_idficha_old
           from inssrv a, insprd b, ft_instdocumento c where a.codcli=ln_codcli and a.codsuc=ln_codsuc
           and a.codinssrv=b.codinssrv and b.flgprinc=1 and c.codigo1=b.pid
            and c.codigo2=a.codinssrv  and tipsrv=cc_tipsrv_internet and a.estinssrv=1;

           select valortxt into ln_service_id from ft_instdocumento where codigo1=ln_pid_old
           and idlista=cn_idlista_serviceid and idcomponente=cn_idcomponente_internet;
           select valortxt into ln_service_type from ft_instdocumento where codigo1=ln_pid_old
           and idlista=cn_idlista_servicetype and idcomponente=cn_idcomponente_internet;

            crear_detprovcp(ln_iddet,
                           ln_customer,
                           ln_idficha_old,
                           '',
                           ln_service_id,
                           '',
                           ln_service_type,
                           '',
                           '',
                           4,
                           '',
                           '',
                           an_codsolot,
                           an_codrespuesta,
                           av_msgrespuesta);


    GOTO avanzar_a_cable;
       end if;
    end if;

    --VALIDACION EQUIPO:

    select count(*)
        into ln_count_tipsrv
        from solotpto a, inssrv b, insprd c
       where b.codinssrv = a.codinssrv
         and c.pid = a.pid
         and b.codinssrv = c.codinssrv
         and a.codsolot = an_codsolot
         and b.tipsrv = cc_tipsrv_telefonia;


    if ln_count_tipsrv = 0 then

    for lr_solotpto in (select a.codsolot,
                               a.codinssrv,
                              a.pid,
                               c.flgprinc,
                               a.codsrvnue,
                               b.codcli,
                               b.codsuc,
                               b.idpaq,
                               b.tipsrv,
                               c.codequcom
                          from solotpto a, inssrv b, insprd c
                         where b.codinssrv = a.codinssrv
                           and c.pid = a.pid
                           and a.codsolot = an_codsolot
                           and b.tipsrv = cc_tipsrv_internet
                           and c.codequcom is not null
                         ) loop

    --se busca si hay un inssrv anterior activo o suspendido
        select nvl(max(codinssrv), 0)
          into ln_codinssrv_old
          from inssrv
         where codinssrv < lr_solotpto.codinssrv
           and estinssrv in (1)
           and codcli = lr_solotpto.codcli
           and codsuc = lr_solotpto.codsuc
           and idpaq = lr_solotpto.idpaq
           and tipsrv = lr_solotpto.tipsrv;


     if ln_codinssrv_old > 0 then

      --Suma de equipos nuevos
          select nvl(sum(cantidad), 0)
            into ln_sum_new
            from insprd
           where codinssrv = lr_solotpto.codinssrv
             and codequcom is not null;

      --Suma de equipos viejos
          select nvl(sum(cantidad), 0)
            into ln_sum_old
            from insprd
           where codinssrv = ln_codinssrv_old
             and codequcom is not null;

      --Valida si hay diferencia de equipos entre los nuevos contra los viejos
          select nvl(sum(cantidad), 0)
            into ln_count_new
            from insprd
           where codinssrv = lr_solotpto.codinssrv
             and codequcom is not null
             and codequcom not in
                 (select codequcom
                    from insprd
                   where codinssrv = ln_codinssrv_old
                     and codequcom is not null);

      --Valida si hay diferencia de equipos entre los viejos contra los nuevos
          select nvl(sum(cantidad), 0)
            into ln_count_old
            from insprd
           where codinssrv = ln_codinssrv_old
             and codequcom is not null
             and codequcom not in
                 (select codequcom
                    from insprd
                   where codinssrv = lr_solotpto.codinssrv
                     and codequcom is not null);

           if ln_sum_new = ln_sum_old and ln_count_new = ln_count_old and ln_count_old = 0 then

               ln_flg_chg_equipo := 0;

           else

               ln_flg_chg_equipo := 1;

           end if;


            if ln_flg_chg_equipo = 1 then



                    select b.tipo_equ_prov,a.codequcom into ln_tipoqueprov_old, ln_codequcom_old
                     from insprd a,vtaequcom b
                    where a.codinssrv= ln_codinssrv_old
                    and a.codequcom is not null and a.codequcom=b.codequcom;

                    select 'Cambio de Equipo ' ||ln_tipoqueprov_old
                     into ln_observacion  from dual;



                      crearDetCP(an_codsolot,
                                 19,
                                 ln_flg_chg_equipo,
                                 lr_solotpto.codcli,
                                 lr_solotpto.codsuc,
                                 lr_solotpto.idpaq,
                                 '',
                                 '',
                                 ln_observacion,
                                 ln_tipoqueprov_old,
                                 1,
                                 an_codrespuesta,
                                 av_msgrespuesta);

             end if;

      end if;

     end loop lr_solotpto;

    else

         if ln_tipequ_modem = 1 then
           ln_flg_chg_equipo:=1;
         end if;

    end if;

     -- Validamos si modifica servicio principal, se captura pid y INSSRV
    begin
      select c.pid, b.codinssrv
        into ln_pid_princ_new, ln_codinssrv_new
        from solotpto a, inssrv b, insprd c
       where b.codinssrv = a.codinssrv
         and c.pid = a.pid
         and b.codinssrv = c.codinssrv
         and a.codsolot = an_codsolot
         and b.tipsrv = cc_tipsrv_internet
         and c.flgprinc = 1;

      select *
        into lr_inssrv_new
        from inssrv
       where codinssrv = ln_codinssrv_new;


       select a.codigo_ext
          into lv_velocidad_new
          from configuracion_itw a, tystabsrv b, insprd c
         where a.idconfigitw = b.codigo_ext
           and c.pid = ln_pid_princ_new
           and b.codsrv = c.codsrv;

    exception
      when others then
        ln_pid_princ_new := 0;

    end;

      --Validamos si existe solo adicionales en la solot
      select count(*) into ln_count_adic
             from solotpto a, inssrv b, insprd c
       where b.codinssrv = a.codinssrv
         and c.pid = a.pid
         and a.codsolot = an_codsolot
         and b.tipsrv = cc_tipsrv_internet
         and c.codequcom is null
         and c.flgprinc = 0;


    -- Si no tiene servicio proncipal anterior es OBVIO que tiene servicio principal nuevo en la SOT
    if ln_pid_princ_new <> 0 then

      -- Se crea nueva ficha al tocar el servicio principal
      sgacrm.pq_fichatecnica.p_crear_instdoc('INSPRD_EQU',
                                             ln_pid_princ_new,
                                             ln_codinssrv_new,
                                             to_char(ln_customer)
                                             );

      select distinct idficha into ln_idficha_new from ft_instdocumento where codigo1= ln_pid_princ_new;


    --se busca si hay un inssrv de internet anterior activo o suspendido

    select nvl(max(codinssrv), 0)
      into ln_codinssrv_old
      from inssrv
     where codinssrv < lr_inssrv_new.codinssrv
       and estinssrv = 1
       and codcli = lr_inssrv_new.codcli
       and codsuc = lr_inssrv_new.codsuc
       and tipsrv = cc_tipsrv_internet;

    end if;


 --Se valida que la sot modifica el servicio principal, pero no tiene codigo de servicio anterior.

 if ln_pid_princ_new > 0 and ln_codinssrv_old = 0 then

      select count(*)
                    into ln_count
                    from inssrv b, insprd c
                   where b.codcli = lc_codcli
                     and b.codsuc = lc_codsuc
                     and b.estinssrv in (1,2)
                     and c.codinssrv = b.codinssrv
                     and c.estinsprd in (1,2)
                     and c.flgprinc = 1
                     and b.tipsrv = cc_tipsrv_telefonia;
      
      if ln_count > 0 then
         ln_pid_princ_old := 0;
         
         select c.pid
                    into ln_pid_princ_old
                    from inssrv b, insprd c
                   where b.codcli = lc_codcli
                     and b.codsuc = lc_codsuc
                     and b.estinssrv in (1,2)
                     and c.codinssrv = b.codinssrv
                     and c.estinsprd in (1,2)
                     and c.flgprinc = 1
                     and b.tipsrv = cc_tipsrv_telefonia;
      
            update ft_instdocumento
           set valortxt = '1'
         where codigo1 = ln_pid_princ_new
           and idlista = cn_idlista_estadoficha;
      
         -- Actualiza el SERVICE_ID Principal en la nueva ficha
            update ft_instdocumento
               set valortxt =
                   (select valortxt
                      from ft_instdocumento
                     where codigo1 = ln_pid_princ_old
                       and idlista = cn_idlista_serviceid
                       and idcomponente = cn_idcomponente_internet)
             where codigo1 = ln_pid_princ_new
               and idlista = cn_idlista_serviceid
               and idcomponente = cn_idcomponente_internet;
               
               -- Actualiza MAC y MODEL de equipo en la nueva ficha
              update ft_instdocumento
                 set valortxt =
                     (select valortxt
                        from ft_instdocumento
                       where codigo1 = ln_pid_princ_old
                         and idlista = cn_idlista_macad_cm
                         and idcomponente = cn_idcomponente_internet)
               where codigo1 = ln_pid_princ_new
                 and idlista = cn_idlista_macad_cm;

              update ft_instdocumento
                 set valortxt =
                     (select valortxt
                        from ft_instdocumento
                       where codigo1 = ln_pid_princ_old
                         and idlista = cn_idlista_model_cm
                         and idcomponente = cn_idcomponente_internet)
               where codigo1 = ln_pid_princ_new
                 and idlista = cn_idlista_model_cm;
               
                 
                select a.codigo_ext,b.abrev
                  into lv_velocidad_new,lv_dscsrv_new
                  from configuracion_itw a, tystabsrv b, insprd c
                 where a.idconfigitw = b.codigo_ext
                   and c.pid = ln_pid_princ_new
                   and b.codsrv = c.codsrv;
            
                 select idficha,valortxt into ln_idficha_old, ln_service_id from ft_instdocumento 
                 where codigo1=ln_pid_princ_old
                 and idlista=cn_idlista_serviceid
                 and idcomponente = cn_idcomponente_internet;
                 
                 select idficha,valortxt into ln_idficha_new, ln_serviceid_new from ft_instdocumento 
                 where codigo1=ln_pid_princ_new
                 and idlista=cn_idlista_serviceid
                 and idcomponente = cn_idcomponente_internet;
         
                  select 'Cambiar velocidad de ' ||'InfinitumVoz'|| ' a ' ||lv_dscsrv_new
                  into ln_observacion
                  from dual;
                  
                  crearDetCP(an_codsolot,
                     7,
                     0,
                     lr_inssrv_new.codcli,
                     lr_inssrv_new.codsuc,
                     lr_inssrv_new.idpaq,
                     '',
                     '',
                     ln_observacion,
                     lv_dscsrv_new,
                     1,
                     an_codrespuesta,
                     av_msgrespuesta);
            
                     select max(iddet) into ln_iddet from operacion.detcp where codsolot= an_codsolot and codaction=7;
                     
                     crear_detprovcp(ln_iddet,
                           ln_customer,
                           ln_idficha_old,
                           ln_idficha_new,
                           ln_service_id,
                           ln_serviceid_new,
                           'InfinitumVoz',
                           lv_velocidad_new,
                           '',
                           4,
                           '',
                           '',
                           an_codsolot,
                           an_codrespuesta,
                           av_msgrespuesta);
                 
                   GOTO avanzar_a_cable;
      
      else            
      
         select b.abrev
          into lv_velocidad_new
          from tystabsrv b, insprd c
         where c.pid = ln_pid_princ_new
           and b.codsrv = c.codsrv;

      select 'Agregar nuevo servicio de ' ||lv_velocidad_new
         into ln_observacion from dual;

      -- Action 1 Agregar Servicio Internet
      crearDetCP(an_codsolot,
                 1,
                 1,
                 lr_inssrv_new.codcli,
                 lr_inssrv_new.codsuc,
                 lr_inssrv_new.idpaq,
                 '',
                 '',
                 ln_observacion,
                 lv_velocidad_new,
                 1,
                 an_codrespuesta,
                 av_msgrespuesta);

       select max(iddet) into ln_iddet from operacion.detcp where codsolot= an_codsolot and codaction=1;

       select valortxt into ln_serviceid_new from ft_instdocumento
         where codigo1=ln_pid_princ_new and idlista=cn_idlista_serviceid
         and idcomponente=cn_idcomponente_internet;

         select valortxt into lv_velocidad_new from ft_instdocumento
         where codigo1=ln_pid_princ_new and idlista=cn_idlista_servicetype
         and idcomponente=cn_idcomponente_internet;

          crear_detprovcp(ln_iddet,
                           ln_customer,
                           '',
                           ln_idficha_new,
                           '',
                           ln_serviceid_new,
                           '',
                           lv_velocidad_new,
                           '',
                           4,
                           '',
                           '',
                           an_codsolot,
                           an_codrespuesta,
                           av_msgrespuesta);

        GOTO avanzar_a_cable;
      
      
      
      end if;
      
       

--Se valida que la sot modifica el servicio principal, pero tiene codigo de servicio anterior.

 elsif ln_pid_princ_new > 0 and ln_codinssrv_old > 0 then

        -- Calcular pid Principal old
      select pid
        into ln_pid_princ_old
        from insprd
       where codinssrv = ln_codinssrv_old
         and flgprinc = 1
         and estinsprd = 1;

-- Actualiza el Estado en la nueva ficha

           update ft_instdocumento
           set valortxt = '1'
         where codigo1 = ln_pid_princ_new
           and idlista = cn_idlista_estadoficha;

        -- Actualiza el SERVICE_ID Principal en la nueva ficha
        update ft_instdocumento
           set valortxt =
               (select valortxt
                  from ft_instdocumento
                 where codigo1 = ln_pid_princ_old
                   and idlista = cn_idlista_serviceid
                   and idcomponente = cn_idcomponente_internet)
         where codigo1 = ln_pid_princ_new
           and idlista = cn_idlista_serviceid
           and idcomponente = cn_idcomponente_internet;

        -- Actualiza MAC y MODEL de equipo en la nueva ficha
        update ft_instdocumento
           set valortxt =
               (select valortxt
                  from ft_instdocumento
                 where codigo1 = ln_pid_princ_old
                   and idlista = cn_idlista_macad_cm)
         where codigo1 = ln_pid_princ_new
           and idlista = cn_idlista_macad_cm;

        update ft_instdocumento
           set valortxt =
               (select valortxt
                  from ft_instdocumento
                 where codigo1 = ln_pid_princ_old
                   and idlista = cn_idlista_model_cm)
         where codigo1 = ln_pid_princ_new
           and idlista = cn_idlista_model_cm;



        -- Validar si hay cambio de Velocidad
        select a.codigo_ext,b.abrev
          into lv_velocidad_old,lv_dscsrv_old
          from configuracion_itw a, tystabsrv b, insprd c
         where a.idconfigitw = b.codigo_ext
           and c.pid = ln_pid_princ_old
           and b.codsrv = c.codsrv;

        select a.codigo_ext,b.abrev
          into lv_velocidad_new,lv_dscsrv_new
          from configuracion_itw a, tystabsrv b, insprd c
         where a.idconfigitw = b.codigo_ext
           and c.pid = ln_pid_princ_new
           and b.codsrv = c.codsrv;


         select valortxt into ln_serviceid_new from ft_instdocumento
         where codigo1=ln_pid_princ_new and idlista=cn_idlista_serviceid
         and idcomponente=cn_idcomponente_internet;

         select distinct d.idficha into ln_idficha_old
         from solotpto a, solot b, insprd c , ft_instdocumento d ,inssrv e
         where a.codinssrv= ln_codinssrv_old and a.codinssrv=c.codinssrv and a.pid=c.pid
         and c.flgprinc=1 and a.codsolot=b.codsolot and c.codinssrv=d.codigo2
         and e.estinssrv in (1,2) and d.codigo3=to_char(ln_customer) and e.codinssrv=c.codinssrv;

       select valortxt into ln_service_id from ft_instdocumento where idficha=ln_idficha_old
       and idlista=cn_idlista_serviceid and idcomponente=cn_idcomponente_internet;



        if lv_velocidad_old <> lv_velocidad_new then


          select 'Cambiar velocidad de ' ||lv_dscsrv_old|| ' a ' || lv_dscsrv_new
          into ln_observacion
          from dual;


          --Action 7 Cambiar Velocidad Internet (Con y sin cambio de equipo)
          crearDetCP(an_codsolot,
                     7,
                     ln_flg_chg_equipo,
                     lr_inssrv_new.codcli,
                     lr_inssrv_new.codsuc,
                     lr_inssrv_new.idpaq,
                     '',
                     '',
                     ln_observacion,
                     lv_dscsrv_new,
                     1,
                     an_codrespuesta,
                     av_msgrespuesta);


       select max(iddet) into ln_iddet from operacion.detcp where codsolot= an_codsolot and codaction=7;

          crear_detprovcp(ln_iddet,
                           ln_customer,
                           ln_idficha_old,
                           ln_idficha_new,
                           ln_service_id,
                           ln_serviceid_new,
                           lv_velocidad_old,
                           lv_velocidad_new,
                           '',
                           4,
                           '',
                           '',
                           an_codsolot,
                           an_codrespuesta,
                           av_msgrespuesta);

        end if;

        if ln_count_tipsrv = 0 and ln_flg_chg_equipo = 1 then

          select iddet into ln_iddet from operacion.detcp
          where codsolot= an_codsolot and codaction=19;

            crear_detprovcp(ln_iddet,
                           ln_customer,
                           ln_idficha_old,
                           ln_idficha_new,
                           ln_service_id,
                           ln_serviceid_new,
                           lv_velocidad_old,
                           lv_velocidad_new,
                           '',
                           4,
                           ln_codequcom_old,
                           '',
                           an_codsolot,
                           an_codrespuesta,
                           av_msgrespuesta);

          end if;


        --Se actualiza el valortxt del serviceid a null de los adicionales que esten en ambas fichas.

        if ln_count_adic > 0 then

        for ln_actualizador in (select * from sgacrm.ft_instdocumento
                               where idlista in
                               (
                               cn_idlista_servicetype
                               )
                              and idcomponente in (cn_idcomponente_inter_adic)
                              and codigo2=ln_codinssrv_old order by idficha,orden) loop


            begin
             select insidcom
             into ln_insidcom_old
             from ft_instdocumento where codigo2=ln_codinssrv_old and valortxt=ln_actualizador.valortxt ;

              select valortxt
              into ln_servicetype_old
              from ft_instdocumento where codigo2=ln_codinssrv_old and insidcom=ln_insidcom_old
              and idlista=cn_idlista_serviceid;

              select insidcom
              into ln_insidcom_new
              from ft_instdocumento where codigo2=ln_codinssrv_new and valortxt=ln_actualizador.valortxt ;

              update sgacrm.ft_instdocumento set valortxt=null
                      where idlista=cn_idlista_serviceid
                      and idcomponente=cn_idcomponente_inter_adic
                      and codigo2=ln_codinssrv_new
                      and insidcom=ln_insidcom_new;


            exception
              when others then
                   ln_insidcom_old := 0;
            end;
         end loop ln_actualizador;

      --Actualizamos los serviceID para adicionales
      for ln_actualizador in (select * from sgacrm.ft_instdocumento
                               where idlista in
                               (
                               cn_idlista_servicetype
                               )
                              and idcomponente in (cn_idcomponente_inter_adic)
                              and codigo2=ln_codinssrv_old order by idficha,orden) loop
        begin
            select insidcom
            into ln_insidcom_old
            from ft_instdocumento where codigo2=ln_codinssrv_old and valortxt=ln_actualizador.valortxt ;

            select valortxt
            into ln_servicetype_old
            from ft_instdocumento where codigo2=ln_codinssrv_old and insidcom=ln_insidcom_old
            and idlista=cn_idlista_serviceid;

            select insidcom
            into ln_insidcom_new
            from ft_instdocumento where codigo2=ln_codinssrv_new and valortxt=ln_actualizador.valortxt ;

            update sgacrm.ft_instdocumento set valortxt=ln_servicetype_old
                    where idlista=cn_idlista_serviceid
                    and idcomponente=cn_idcomponente_inter_adic
                    and codigo2=ln_codinssrv_new
                    and insidcom=ln_insidcom_new
                    and rownum=1
                    and valortxt is null;

        exception
              when others then
                   ln_insidcom_old := 0;
        end;

       end loop ln_actualizador;


       --Adicionales (Agregar)

       for lr_solotpto in (select a.codsolot,
                             a.codinssrv,
                             a.pid,
                             c.flgprinc,
                             a.codsrvnue,
                             b.codcli,
                             b.codsuc,
                             b.idpaq,
                             b.tipsrv,
                             c.codsrv,
                             b.customer_id,
                             c.codequcom
                        from solotpto a, inssrv b, insprd c
                       where b.codinssrv = a.codinssrv
                         and c.pid = a.pid
                         and a.codsolot = an_codsolot
                         and b.tipsrv = cc_tipsrv_internet
                          and c.flgprinc=0) loop


      if lr_solotpto.codequcom is null  then

       lv_servicetype_new := f_obtener_codigo_ext_x_codsrv(lr_solotpto.codsrvnue);

       if lv_servicetype_new is not null then

       select count(*) into ln_codsrv_count
                                    from configuracion_itw
                                    where idconfigitw in
                                    (select distinct codigo_ext from tystabsrv where codsrv
                                    in (select codsrv from insprd where codinssrv = ln_codinssrv_old)
                                    and codigo_ext is not null) and codigo_ext=lv_servicetype_new;

           if ln_codsrv_count = 0 then


            -- Action 17 : Agregar Servicio Adicional Internet

            select 'Agregar servicio adicional ' ||lv_servicetype_new
            into ln_observacion
            from dual;

            crearDetCP(an_codsolot,
                       17,
                       ln_flg_chg_equipo,
                       lr_solotpto.codcli,
                       lr_solotpto.codsuc,
                       lr_solotpto.idpaq,
                       '',
                       '',
                       ln_observacion,
                       '',
                       '',
                       an_codrespuesta,
                       av_msgrespuesta);


            select max(iddet) into ln_iddet from operacion.detcp where codsolot= an_codsolot and codaction=1;

       select valortxt into ln_serviceid_new from ft_instdocumento
         where codigo1=ln_pid_princ_new and idlista=cn_idlista_serviceid
         and insidcom=(select insidcom from ft_instdocumento where idlista=cn_idlista_servicetype
         and valortxt=lv_servicetype_new and codigo1=ln_pid_princ_new);


         select distinct d.idficha into ln_idficha_old
         from solotpto a, solot b, insprd c , ft_instdocumento d
         where a.codinssrv= ln_codinssrv_old and a.codinssrv=c.codinssrv and a.pid=c.pid
         and c.flgprinc=1 and a.codsolot=b.codsolot and c.codinssrv=d.codigo2 and d.codigo3=to_char(ln_customer);

            crear_detprovcp(ln_iddet,
                           ln_customer,
                           ln_idficha_old,
                           ln_idficha_new,
                           '',
                           ln_serviceid_new,
                           '',
                           lv_servicetype_new,
                           '',
                           4,
                           '',
                           '',
                           an_codsolot,
                           an_codrespuesta,
                           av_msgrespuesta);


            end if;
        end if;

       end if;
     end loop lr_solotpto;

     --Adicionales Quitar
     for quitar_adicional in (
                             select codigo_ext
                                    from configuracion_itw
                                    where idconfigitw in
                                    (select distinct codigo_ext from tystabsrv where codsrv
                                    in (select codsrv from insprd where codinssrv = ln_codinssrv_old)
                                    and codigo_ext is not null)and codigo_ext not in(lv_velocidad_old)
                             )loop

     select count(*) into ln_codsrv_count
                                    from configuracion_itw
                                    where idconfigitw in
                                    (select distinct codigo_ext from tystabsrv where codsrv
                                    in (select codsrv from insprd where codinssrv = ln_codinssrv_new)
                                    and codigo_ext is not null) and codigo_ext=quitar_adicional.codigo_ext;

      if ln_codsrv_count = 0 then



         select 'Quitar servicio adicional de ' ||quitar_adicional.codigo_ext
         into ln_observacion
         from dual;


        -- Action 18 : Quitar Servicio Adicional Internet

        crearDetCP(an_codsolot,
                   18,
                   ln_flg_chg_equipo, -- 0
                   lr_inssrv_new.codcli,
                   lr_inssrv_new.codsuc,
                   lr_inssrv_new.idpaq,
                   '',
                   '',
                   ln_observacion,
                   '',
                   '',
                   an_codrespuesta,
                   av_msgrespuesta);

      select max(iddet) into ln_iddet from operacion.detcp where codsolot= an_codsolot and codaction=18;


         select distinct d.idficha into ln_idficha_old
         from solotpto a, solot b, insprd c , ft_instdocumento d
         where a.codinssrv= ln_codinssrv_old and a.codinssrv=c.codinssrv and a.pid=c.pid
         and c.flgprinc=1 and a.codsolot=b.codsolot and c.codinssrv=d.codigo2 and d.codigo3=to_char(ln_customer);


      select valortxt into ln_service_id from ft_instdocumento
         where codigo1=ln_idficha_old and idlista=cn_idlista_serviceid
         and insidcom=(select insidcom from ft_instdocumento where idlista=cn_idlista_servicetype
         and valortxt=quitar_adicional.codigo_ext and codigo1=ln_idficha_old);

         crear_detprovcp(ln_iddet,
                           ln_customer,
                           ln_idficha_old,
                           ln_idficha_new,
                           ln_service_id,
                           '',
                           quitar_adicional.codigo_ext,
                           '',
                           '',
                           4,
                           '',
                           '',
                           an_codsolot,
                           an_codrespuesta,
                           av_msgrespuesta);


        end if;


     end loop quitar_adicional;

     end if;
    end if;

 -------------------------------------------------------------------------------------------------
 --FIN INTERNET
 -------------------------------------------------------------------------------------------------
 -----------------------------------------------------------------------------------------------
--INICIA CABLE
-----------------------------------------------------------------------------------------------

  <<avanzar_a_cable>>
ln_flg_chg_equipo := 0;
ln_codinssrv_old := 0;
ln_count_qa:=0;

select count(*)
        into ln_count_tipsrv
        from solotpto a, inssrv b, insprd c
       where b.codinssrv = a.codinssrv
         and c.pid = a.pid
         and b.codinssrv = c.codinssrv
         and a.codsolot = an_codsolot
         and b.tipsrv = cc_tipsrv_cable;

      if ln_count_tipsrv = 0 then

         select count(*) into ln_count from inssrv where codcli=ln_codcli and codsuc=ln_codsuc
         and tipsrv=cc_tipsrv_cable and estinssrv=1;

           if ln_count > 0 then

                select 'Quitar servicio de Cable'
                into ln_observacion  from dual;

               --Quitar servicio de Cable
               crearDetCP(an_codsolot,
                                     6,
                                     ln_flg_chg_equipo,
                                     ln_codcli,
                                     ln_codsuc,
                                     ln_idpaq,
                                     '',
                                     '',
                                     ln_observacion,
                                     'Cable',
                                     1,
                                     an_codrespuesta,
                                     av_msgrespuesta);


          select max(iddet) into ln_iddet from operacion.detcp where codsolot= an_codsolot and codaction=6;
          ln_count:=0;
          for lr_desactivar in (

           select distinct a.codinssrv, b.pid,c.idficha
           from inssrv a, insprd b, ft_instdocumento c where a.codcli=ln_codcli and a.codsuc=ln_codsuc
           and a.codinssrv=b.codinssrv and c.codigo1=b.pid and c.codigo3=to_char(ln_customer)
            and c.codigo2=a.codinssrv  and tipsrv=cc_tipsrv_cable and a.estinssrv=1) loop

            ln_count:= ln_count +1;

           select valortxt into ln_service_id from ft_instdocumento
           where codigo1=lr_desactivar.pid and idficha=lr_desactivar.idficha
           and idlista=cn_idlista_serviceid and idcomponente=cn_idcomponente_cable_bas;

           select valortxt into ln_service_type from ft_instdocumento
           where codigo1=lr_desactivar.pid and idficha=lr_desactivar.idficha
           and idlista=cn_idlista_servicetype and idcomponente=cn_idcomponente_cable_bas;

            crear_detprovcp(ln_iddet,
                           ln_customer,
                           lr_desactivar.idficha,
                           '',
                           ln_service_id,
                           '',
                           ln_service_type,
                           '',
                           '',
                           4,
                           '',
                           '',
                           an_codsolot,
                           an_codrespuesta,
                           av_msgrespuesta);


            end loop lr_desactivar;

            update operacion.detcp set cant_total=ln_count where iddet=ln_iddet and codsolot= an_codsolot
            and codaction=6;

           end if;

            GOTO finaliza_sp;

      end if;

begin
      select c.pid, b.codinssrv
        into ln_pid_princ_new, ln_codinssrv_new
        from solotpto a, inssrv b, insprd c
       where b.codinssrv = a.codinssrv
         and c.pid = a.pid
         and b.codinssrv = c.codinssrv
         and a.codsolot = an_codsolot
         and b.tipsrv = cc_tipsrv_cable
         and c.flgprinc = 1;

    select *
        into lr_inssrv_new
        from inssrv
       where codinssrv = ln_codinssrv_new;

       select a.codigo_ext
          into lv_plan_new
          from configuracion_itw a, tystabsrv b, insprd c
         where a.idconfigitw = b.codigo_ext
           and c.pid = ln_pid_princ_new
           and b.codsrv = c.codsrv;

    exception
      when others then
        ln_pid_princ_new := 0;
end;

if ln_pid_princ_new <> 0 then
      -- Se crea nueva ficha al tocar el servicio principal

      agregarServicioCable(ln_codinssrv_new,ln_customer);

    --se busca si hay un inssrv de internet anterior activo o suspendido
    select nvl(max(codinssrv), 0)
      into ln_codinssrv_old
      from inssrv
     where codinssrv < lr_inssrv_new.codinssrv
       and estinssrv = 1
       and codcli = lr_inssrv_new.codcli
       and codsuc = lr_inssrv_new.codsuc
       and tipsrv = cc_tipsrv_cable;

end if;

if ln_pid_princ_new > 0 and ln_codinssrv_old = 0 then

   select b.abrev
          into lv_plan_new
          from tystabsrv b, insprd c
         where c.pid = ln_pid_princ_new
           and b.codsrv = c.codsrv;

 select 'Agregar nuevo servicio ' ||lv_plan_new
         into ln_observacion from dual;

  select count(distinct idficha) into ln_cantidad from ft_instdocumento where codigo2=ln_codinssrv_new;

      -- Action 3 Agregar Servicio Cable
      crearDetCP(an_codsolot,
                 3,
                 1,
                 lr_inssrv_new.codcli,
                 lr_inssrv_new.codsuc,
                 lr_inssrv_new.idpaq,
                 '',
                 '',
                 ln_observacion,
                 lv_plan_new,
                 ln_cantidad,
                 an_codrespuesta,
                 av_msgrespuesta);


        select max(iddet) into ln_iddet from operacion.detcp where codsolot= an_codsolot and codaction=3;

         for lr_activar in (

           select distinct a.codinssrv, b.pid,c.idficha
           from inssrv a, insprd b, ft_instdocumento c where a.codinssrv=ln_codinssrv_new
           and a.codinssrv=b.codinssrv and c.codigo1=b.pid
            and c.codigo2=a.codinssrv  and tipsrv=cc_tipsrv_cable) loop


           select valortxt into ln_serviceid_new from ft_instdocumento
           where codigo1=lr_activar.pid and idficha=lr_activar.idficha
           and idlista=cn_idlista_serviceid and idcomponente=cn_idcomponente_cable_bas;

           select valortxt into lv_plan_new from ft_instdocumento
           where codigo1=lr_activar.pid and idficha=lr_activar.idficha
           and idlista=cn_idlista_servicetype and idcomponente=cn_idcomponente_cable_bas;

           crear_detprovcp(ln_iddet,
                           ln_customer,
                           '',
                           lr_activar.idficha,
                           '',
                           ln_serviceid_new,
                           '',
                           lv_plan_new,
                           '',
                           4,
                           '',
                           '',
                           an_codsolot,
                           an_codrespuesta,
                           av_msgrespuesta);


            end loop lr_activar;



      GOTO finaliza_sp;

elsif ln_pid_princ_new > 0 and ln_codinssrv_old > 0 then


--Identificacion de Agregar y quitar Decos

---1: Agregar Decos.

for lr_solotpto in (

                  select * from (
                  select
                  x.codequcom||x.fila||x.cantidad concatenado, x.pid,x.codinssrv,
                  x.tipo_equ_prov,x.codequcom,x.cantidad

                   from (

                  select
                         c.codequcom,
                         row_number() over (partition by c.codequcom order by c.pid asc) fila,
                        c.pid,
                        c.codinssrv,
                        d.tipo_equ_prov,
                        c.cantidad
                    from solotpto a, inssrv b, insprd c , vtaequcom d
                  where b.codinssrv = a.codinssrv
                     and c.pid = a.pid
                     and a.codsolot =an_codsolot
                     and c.codequcom=d.codequcom
                     and b.tipsrv = cc_tipsrv_cable
                     and c.codequcom is not null
                  )x
                  )x
                  where x.concatenado not in (

                           select * from (
                            select y.codequcom||y.fila||y.cantidad concatenado from (
                            select
                                   c.codequcom,
                                   row_number() over (partition by c.codequcom order by c.pid asc) fila,
                                   c.cantidad
                              from  inssrv b, insprd c
                            where b.codinssrv = c.codinssrv
                               and c.codinssrv=ln_codinssrv_old
                               and b.tipsrv = cc_tipsrv_cable
                               and c.codequcom is not null
                            )  y)y

                           )
                 ) loop



      select nvl(sum(cantidad),0) into ln_cantidad from insprd where codinssrv=ln_codinssrv_old
          and codequcom=lr_solotpto.codequcom;

      select nvl(sum(cantidad),0) into ln_cantidad_new from insprd where codinssrv=ln_codinssrv_new
          and codequcom=lr_solotpto.codequcom;


      if lr_solotpto.cantidad > 1 then

          select nvl(sum(cantidad),0) into ln_cantidad from insprd where codinssrv=ln_codinssrv_old
          and codequcom=lr_solotpto.codequcom;

          if lr_solotpto.cantidad > ln_cantidad then

             lv_bucle:= lr_solotpto.cantidad - ln_cantidad;
             lv_bucle_2:=lv_bucle;

             for i in 1..lv_bucle loop

                ln_count_a:= ln_count_a + 1;

              select y.idficha into ln_idficha_new from
               (select x.idficha, rownum as fila from
               (select distinct idficha from ft_instdocumento where codigo1 in
               (select pid from insprd where codinssrv=ln_codinssrv_new and codequcom= lr_solotpto.codequcom)
               order by 1 asc)x)y where y.fila=lv_bucle_2;

               select valortxt into ln_serviceid_new from ft_instdocumento where idficha=ln_idficha_new
               and idlista=cn_idlista_serviceid and idcomponente=cn_idcomponente_cable_bas;

               select valortxt into ln_service_type from ft_instdocumento where idficha=ln_idficha_new
               and idlista=cn_idlista_servicetype and idcomponente=cn_idcomponente_cable_bas;

               lv_bucle_2:=lv_bucle_2+1;

               select 'Agregar '||ln_count_a|| ' ' ||lr_solotpto.tipo_equ_prov
                     into ln_observacion  from dual;

               --Agregar el detcp y detprov

               crearDetCP(an_codsolot,
                       12,
                       1,
                       lr_inssrv_new.codcli,
                       lr_inssrv_new.codsuc,
                       lr_inssrv_new.idpaq,
                       '',
                       '',
                       ln_observacion,
                       lr_solotpto.tipo_equ_prov,
                       ln_count_a,
                       an_codrespuesta,
                       av_msgrespuesta);

            select max(iddet) into ln_iddet from operacion.detcp where codsolot= an_codsolot and codaction=12;


                crear_detprovcp(ln_iddet,
                           ln_customer,
                           0,
                           ln_idficha_new,
                           '',
                           ln_serviceid_new,
                           '',
                           ln_service_type,
                           '',
                           4,
                           '',
                           '',
                           an_codsolot,
                           an_codrespuesta,
                           av_msgrespuesta);

             end loop;

          end if;

      elsif ln_cantidad_new > ln_cantidad and lr_solotpto.cantidad < 2  then
      ln_count_ab:= ln_count_ab + 1;

      select 'Agregar '||ln_count_ab|| ' ' ||lr_solotpto.tipo_equ_prov
                     into ln_observacion  from dual;

       crearDetCP(an_codsolot,
                       12,
                       1,
                       lr_inssrv_new.codcli,
                       lr_inssrv_new.codsuc,
                       lr_inssrv_new.idpaq,
                       '',
                       '',
                       ln_observacion,
                       lr_solotpto.tipo_equ_prov,
                       ln_count_ab,
                       an_codrespuesta,
                       av_msgrespuesta);

        select max(iddet) into ln_iddet from operacion.detcp where codsolot= an_codsolot and codaction=12;

         select distinct idficha into ln_idficha_new from ft_instdocumento
         where codigo1=lr_solotpto.pid and codigo2=lr_solotpto.codinssrv;

            select valortxt into ln_serviceid_new from ft_instdocumento
         where codigo1=lr_solotpto.pid and idficha=ln_idficha_new and idlista=cn_idlista_serviceid
         and idcomponente=cn_idcomponente_cable_bas;

         select valortxt into ln_service_type from ft_instdocumento
         where codigo1=lr_solotpto.pid and idficha=ln_idficha_new and idlista=cn_idlista_servicetype
         and idcomponente=cn_idcomponente_cable_bas;

           crear_detprovcp(ln_iddet,
                           ln_customer,
                           0,
                           ln_idficha_new,
                           '',
                           ln_serviceid_new,
                           '',
                           ln_service_type,
                           '',
                           4,
                           '',
                           '',
                           an_codsolot,
                           an_codrespuesta,
                           av_msgrespuesta);
          end if;

end loop lr_solotpto;

--2: Quitar Decos.

for lr_solotpto in (

              select * from (
              select
              x.codequcom||x.fila||x.cantidad concatenado, x.pid,x.codinssrv,x.tipo_equ_prov,x.codequcom,x.cantidad

               from (

              select
                     c.codequcom,
                     row_number() over (partition by c.codequcom order by c.pid asc) fila,
                    c.pid,
                    c.codinssrv,
                    d.tipo_equ_prov,
                    c.cantidad
                from inssrv b, insprd c , vtaequcom d
              where b.codinssrv = c.codinssrv
                 and c.codinssrv=ln_codinssrv_old
                 and c.codequcom=d.codequcom
                 and b.tipsrv = cc_tipsrv_cable
                 and c.codequcom is not null
              )x
              )x
              where x.concatenado not in (

                                         select * from (
                                          select y.codequcom||y.fila||y.cantidad concatenado from (
                                          select
                                                 c.codequcom,
                                                 row_number() over (partition by c.codequcom order by c.pid asc) fila,
                                                 c.cantidad
                                            from  inssrv b, insprd c
                                          where b.codinssrv = c.codinssrv
                                             and c.codinssrv=ln_codinssrv_new
                                             and b.tipsrv = cc_tipsrv_cable
                                             and c.codequcom is not null
                                          )  y)y

                                         )
                 ) loop


      select nvl(sum(cantidad),0) into ln_cantidad from insprd where codinssrv=ln_codinssrv_old
          and codequcom=lr_solotpto.codequcom;

      select nvl(sum(cantidad),0) into ln_cantidad_new from insprd where codinssrv=ln_codinssrv_new
          and codequcom=lr_solotpto.codequcom;

       if lr_solotpto.cantidad > 1 then

          select nvl(sum(cantidad),0) into ln_cantidad_new from insprd where codinssrv=ln_codinssrv_new
          and codequcom=lr_solotpto.codequcom;

          if lr_solotpto.cantidad > ln_cantidad_new then

             lv_bucle:= lr_solotpto.cantidad - ln_cantidad_new;
             lv_bucle_2:=lv_bucle;

             for i in 1..lv_bucle loop

                 ln_count_q:= ln_count_q + 1;

               select 'Retirar '||ln_count_q|| ' ' ||lr_solotpto.tipo_equ_prov
                     into ln_observacion  from dual;

               lv_bucle_2:=lv_bucle_2+1;

               crearDetCP(an_codsolot,
                       13,
                       1,
                       lr_inssrv_new.codcli,
                       lr_inssrv_new.codsuc,
                       lr_inssrv_new.idpaq,
                       '',
                       '',
                       ln_observacion,
                       lr_solotpto.tipo_equ_prov,
                       ln_count_q,
                       an_codrespuesta,
                       av_msgrespuesta);


              select max(iddet) into ln_iddet from operacion.detcp where codsolot= an_codsolot and codaction=13;


              crear_detprovcp(ln_iddet,
                           ln_customer,
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           4,
                           '',
                           '',
                           an_codsolot,
                           an_codrespuesta,
                           av_msgrespuesta);

             end loop;

          end if;


       elsif ln_cantidad > ln_cantidad_new and lr_solotpto.cantidad < 2  then

       ln_count_qa:= ln_count_qa + 1;


       select 'Retirar '||ln_count_qa|| ' ' ||lr_solotpto.tipo_equ_prov
                     into ln_observacion  from dual;

       crearDetCP(an_codsolot,
                       13,
                       1,
                       lr_inssrv_new.codcli,
                       lr_inssrv_new.codsuc,
                       lr_inssrv_new.idpaq,
                       '',
                       '',
                       ln_observacion,
                       lr_solotpto.tipo_equ_prov,
                       ln_count_qa,
                       an_codrespuesta,
                       av_msgrespuesta);

         select max(iddet) into ln_iddet from operacion.detcp where codsolot= an_codsolot and codaction=13;


        crear_detprovcp(ln_iddet,
                           ln_customer,
                           0,
                           '',
                           '',
                           '',
                           '',
                           '',
                           '',
                           4,
                           '',
                           '',
                           an_codsolot,
                           an_codrespuesta,
                           av_msgrespuesta);

         end if;

end loop lr_solotpto;

--Actualizacion de fichas, solo en el caso que sea Agregar Decos

select count(*) into ln_count_deco from operacion.detprovcp where codsolot_new=an_codsolot and codaction=13;

select count(distinct idficha) into ln_deco_actu from ft_instdocumento where codigo2=ln_codinssrv_old;

select count(*) into ln_count_adic from operacion.detcp where codsolot=an_codsolot and codaction=12;

      --Actualizo registros de quitar decos, cuando cantidad actual = cantidad quitada

      if ln_count_deco = ln_deco_actu then

      ln_sec:= 0;
         for deco_actual in (

             select idficha, rownum as contador from (select distinct idficha
              from ft_instdocumento where codigo2=ln_codinssrv_old and codigo3=to_char(ln_customer)
                order by 1)x
                            )loop


         ln_sec := deco_actual.contador;


                  for actualiza in (
                                    select x.idseq,x.contador as contador2 from (select rownum as contador,a.*
                                    from operacion.detprovcp a
                                    where codsolot_new= an_codsolot  and codaction=13)x
                            )loop

                      if ln_sec = actualiza.contador2 then

                        select valortxt into ln_service_id from ft_instdocumento where idficha=deco_actual.idficha and idlista=cn_idlista_serviceid
                        and idcomponente=cn_idcomponente_cable_bas;

                        select valortxt into ln_servicetype_old from ft_instdocumento where idficha=deco_actual.idficha and idlista=cn_idlista_servicetype
                        and idcomponente=cn_idcomponente_cable_bas;

                        update operacion.detprovcp set ficha_origen=deco_actual.idficha, service_id_old=ln_service_id, service_type_old=ln_servicetype_old
                        where idseq=actualiza.idseq;


                      end if;


                   end loop actualiza;

         end loop deco_actual;

      end if;

      -- Actualiza fichas de decos cuando, no hay acciones de quitar decos

      if ln_count_deco = 0 and ln_count_deco<ln_deco_actu then

            actualiza_cable(ln_codinssrv_old,
                                   ln_codinssrv_new,
                                   an_codsolot,
                                   an_codrespuesta,
                                   av_msgrespuesta);

      end if;

      if ln_count_adic > 0 or ln_count_deco > 0 then

         ln_flg_chg_equipo:=1;

      end if;


      -- Calcular pid Principal old
      select pid
        into ln_pid_princ_old
        from insprd
       where codinssrv = ln_codinssrv_old
         and flgprinc = 1
         and estinsprd = 1;

        -- Validar si hay cambio de servicio
        select a.codigo_ext,b.abrev
          into lv_plan_old,lv_des_cable_old
          from configuracion_itw a, tystabsrv b, insprd c
         where a.idconfigitw = b.codigo_ext
           and c.pid = ln_pid_princ_old
           and b.codsrv = c.codsrv;

        select a.codigo_ext,b.abrev
          into lv_plan_new, lv_des_cable_new
          from configuracion_itw a, tystabsrv b, insprd c
         where a.idconfigitw = b.codigo_ext
           and c.pid = ln_pid_princ_new
           and b.codsrv = c.codsrv;

        if lv_plan_old <> lv_plan_new then

          select 'Cambiar Plan de Canales de  ' ||lv_des_cable_old|| ' a ' || lv_des_cable_new
          into ln_observacion
          from dual;

          --Action 11 Cambiar Plan de Canales Cable
          crearDetCP(an_codsolot,
                     11,
                     ln_flg_chg_equipo,
                     lr_inssrv_new.codcli,
                     lr_inssrv_new.codsuc,
                     lr_inssrv_new.idpaq,
                     '',
                     '',
                     ln_observacion,
                     lv_des_cable_new,
                     1,
                     an_codrespuesta,
                     av_msgrespuesta);


         select max(iddet) into ln_iddet from operacion.detcp where codsolot= an_codsolot and codaction=11;


          --Hubo quitar decos
          if ln_count_deco = 0 then


            for lr_solotpto in (
              select idficha, rownum as contador from (select distinct idficha
                      from ft_instdocumento where codigo2=ln_codinssrv_old and codigo3=to_char(ln_customer)
                      order by 1)x

              ) loop

            ln_sec := lr_solotpto.contador;


                for actualiza in (select idficha, rownum as contador2 from (select distinct idficha
                      from ft_instdocumento where codigo2=ln_codinssrv_new and codigo3=to_char(ln_customer)
                      order by 1)x
                          )loop

                      if ln_sec = actualiza.contador2 then



                          select valortxt into ln_serviceid_new from ft_instdocumento
                           where idficha= actualiza.idficha and idlista=cn_idlista_serviceid
                           and idcomponente=cn_idcomponente_cable_bas;

                         crear_detprovcp(ln_iddet,
                           ln_customer,
                           lr_solotpto.idficha,
                           actualiza.idficha,
                           ln_serviceid_new,
                           ln_serviceid_new,
                           lv_plan_old,
                           lv_plan_new,
                           '',
                           4,
                           '',
                           '',
                           an_codsolot,
                           an_codrespuesta,
                           av_msgrespuesta);

                      end if;

                end loop actualiza;


            end loop lr_solotpto;


          else

            for lr_ficha in (select idficha, rownum as contador2 from (select distinct idficha
                      from ft_instdocumento where codigo2=ln_codinssrv_new and codigo3=to_char(ln_customer)
                      order by 1)x
                      )loop

                      crear_detprovcp(ln_iddet,
                           ln_customer,
                           '',
                           lr_ficha.idficha,
                           '',
                           '',
                           lv_plan_old,
                           lv_plan_new,
                           '',
                           4,
                           '',
                           '',
                           an_codsolot,
                           an_codrespuesta,
                           av_msgrespuesta);

            end loop lr_ficha;

          end if;

        end if;


--Agregar Adicionales :

      for lr_agregar in (select codigo_ext
                                    from configuracion_itw
                                    where idconfigitw in
                                    (select distinct codigo_ext from tystabsrv where codsrv
                                    in (select codsrv from insprd where codinssrv = ln_codinssrv_new)
                                    and codigo_ext is not null)and codigo_ext not in(lv_plan_new)
                         )loop


     select count(*) into ln_codsrv_count
                                    from configuracion_itw
                                    where idconfigitw in
                                    (select distinct codigo_ext from tystabsrv where codsrv
                                    in (select codsrv from insprd where codinssrv = ln_codinssrv_old)
                                    and codigo_ext is not null) and codigo_ext=lr_agregar.codigo_ext;


           if ln_codsrv_count = 0 then

            select 'Agregar paquete adicional ' ||lr_agregar.codigo_ext
            into ln_observacion
            from dual;
            -- Action 14 : Agregar Paquete Cable

            crearDetCP(an_codsolot,
                       14,
                       ln_flg_chg_equipo, -- 0
                       lr_inssrv_new.codcli,
                       lr_inssrv_new.codsuc,
                       lr_inssrv_new.idpaq,
                       '',
                       '',
                       ln_observacion,
                       lr_agregar.codigo_ext,
                       1,
                       an_codrespuesta,
                       av_msgrespuesta);


         select max(iddet) into ln_iddet from operacion.detcp where codsolot= an_codsolot and codaction=14;

         if ln_count_deco <> ln_deco_actu then


         for lr_activar in (

           select distinct a.codinssrv, b.pid,c.idficha
           from inssrv a, insprd b, ft_instdocumento c where a.codinssrv=ln_codinssrv_new
           and a.codinssrv=b.codinssrv and c.codigo1=b.pid and c.codigo3=to_char(ln_customer)
            and c.codigo2=a.codinssrv  and tipsrv=cc_tipsrv_cable) loop

            select valortxt into ln_serviceid_new from ft_instdocumento
         where codigo1=lr_activar.pid and idficha=lr_activar.idficha and idlista=cn_idlista_serviceid
         and insidcom=(select insidcom from ft_instdocumento where valortxt=lr_agregar.codigo_ext and codigo1=lr_activar.pid and idficha=lr_activar.idficha);

           select count(distinct idficha) into ln_count from ft_instdocumento where idficha=lr_activar.idficha
           and idficha not in (select ficha_destino from operacion.detprovcp
           where codaction=12 and codsolot_new=an_codsolot);

           if ln_count=1 then

           crear_detprovcp(ln_iddet,
                           ln_customer,
                           0,
                           lr_activar.idficha,
                           '',
                           ln_serviceid_new,
                           '',
                           lr_agregar.codigo_ext,
                           '',
                           4,
                           '',
                           '',
                           an_codsolot,
                           an_codrespuesta,
                           av_msgrespuesta);
            end if;

            end loop lr_activar;

         end if;

            end if;

      end loop lr_agregar;

      --Quitar adicional


      for lr_quitar in (
                       select codigo_ext
                                    from configuracion_itw
                                    where idconfigitw in
                                    (select distinct codigo_ext from tystabsrv where codsrv
                                    in (select codsrv from insprd where codinssrv = ln_codinssrv_old)
                                    and codigo_ext is not null)and codigo_ext not in(lv_plan_old)

                       )loop

        select count(*) into ln_codsrv_count
                                    from configuracion_itw
                                    where idconfigitw in
                                    (select distinct codigo_ext from tystabsrv where codsrv
                                    in (select codsrv from insprd where codinssrv = ln_codinssrv_new)
                                    and codigo_ext is not null) and codigo_ext=lr_quitar.codigo_ext;


            if ln_codsrv_count = 0 then

            select 'Quitar paquete adicional ' ||lr_quitar.codigo_ext
             into ln_observacion
             from dual;
            -- Action 15 : Quitar Paquete Cable

            crearDetCP(an_codsolot,
                       15,
                       ln_flg_chg_equipo,
                       lr_inssrv_new.codcli,
                       lr_inssrv_new.codsuc,
                       lr_inssrv_new.idpaq,
                       '',
                       '',
                       ln_observacion,
                       lr_quitar.codigo_ext,
                       1,
                       an_codrespuesta,
                       av_msgrespuesta);


         select max(iddet) into ln_iddet from operacion.detcp where codsolot= an_codsolot and codaction=15;

         ln_cantidad := 0;

                if ln_count_deco <> ln_deco_actu and ln_count_deco>0 then

                 ln_cantidad:=ln_deco_actu - ln_count_deco;

                 for i in 1..ln_cantidad loop

                     crear_detprovcp(ln_iddet,
                                   ln_customer,
                                   '',
                                   '',
                                   '',
                                   '',
                                   lr_quitar.codigo_ext,
                                   '',
                                   '',
                                   4,
                                   '',
                                   '',
                                   an_codsolot,
                                   an_codrespuesta,
                                   av_msgrespuesta);

                 end loop;

                elsif ln_count_deco=0 or ln_count_deco = ln_deco_actu then

                 for lr_desactivar in (

                   select distinct a.codinssrv, b.pid,c.idficha
                   from inssrv a, insprd b, ft_instdocumento c where a.codinssrv=ln_codinssrv_old
                   and a.codinssrv=b.codinssrv and c.codigo1=b.pid and c.codigo3=to_char(ln_customer)
                    and c.codigo2=a.codinssrv  and tipsrv=cc_tipsrv_cable) loop

                    select valortxt into ln_service_id from ft_instdocumento
                 where codigo1=lr_desactivar.pid and idficha=lr_desactivar.idficha and idlista=cn_idlista_serviceid
                 and insidcom=(select insidcom from ft_instdocumento where valortxt=lr_quitar.codigo_ext and codigo1=lr_desactivar.pid and idficha=lr_desactivar.idficha);

                   crear_detprovcp(ln_iddet,
                                   ln_customer,
                                   lr_desactivar.idficha,
                                   '',
                                   ln_service_id,
                                   '',
                                   lr_quitar.codigo_ext,
                                   '',
                                   '',
                                   4,
                                   '',
                                   '',
                                   an_codsolot,
                                   an_codrespuesta,
                                   av_msgrespuesta);

                    end loop lr_desactivar;


                end if;

            end if;

      end loop lr_quitar;

end if;


  <<finaliza_sp>>
  ln_count:= 0;
  select count(*) into ln_count from operacion.detcp where codsolot=an_codsolot and vt=1;
  IF ln_count > 0 THEN

     UPDATE operacion.detcp SET VT=1 WHERE CODSOLOT=an_codsolot;

  END IF;
     
  end if;
  
   
   exception
    when others then
      an_codrespuesta := '1';
      av_msgrespuesta := SQLERRM;

end;


procedure SGASI_IDENTIFICAR_ACCION_CP(a_idtareawf     number,
                                   a_idwf number,
                                   a_tarea number,
                                   a_tareadef number
                                   ) as

    an_codsolot solot.codsolot%type;

    an_codrespuesta              number;
    av_msgrespuesta             varchar2(100);

  begin

   an_codrespuesta:= 1;
   av_msgrespuesta:= 'Exitoso';

   select codsolot into an_codsolot from wf where idwf = a_idwf;

          identificar_Accion(an_codsolot,
                              an_codrespuesta,
                              av_msgrespuesta);

 end;


end pq_reglas_cp;
/