CREATE OR REPLACE PACKAGE BODY OPERACION.pq_ope_ins_equipo is
  /************************************************************
  NOMBRE:     pq_ope_ins_equipo
  PROPOSITO:  Manejo y control de asignación de lineas por equipo
  PROGRAMADO EN JOB:  No

  REVISIONES:
  Version      Fecha        Autor                   Descripcisn
  ---------  ----------  ---------------            ------------------------
  1.0        10/02/2011  Alexander Yong             Creación - REQ-155642: Requerimiento para Instalar más de 01 línea telefónica por equipo eMTA
  2.0        16/02/2011  Antonio Lagos              REQ-155642: Requerimiento para Instalar más de 01 línea telefónica por equipo eMTA
  3.0        05/05/2011  Antonio Lagos              REQ-159162: Eliminar equipo al cancelar WF
  4.0        22/11/2011  Samuel Inga                SD-355012: Registro del detalle en la asignacion de equipos.
  5.0        09/05/2015  José Ruiz                  IDEA-22294- Automatización TPE HFC
  6.0        26/06/2015  Freddy Gonzales/           SD 372800
                         Edilberto Astulle          SD-318468 No se puede realizar una atención postventa en SIAC porque el servicio esta en Reservado  
  7.0	     11/11/2015	 Jose Varillas				SD_533380
  8.0		 12/12/2019  Evelyn Cotillo				INICIATIVA-197 RCN				
  ***********************************************************/
  procedure p_gen_carga_inicial(p_codsolot   solot.codsolot%type,
                                ac_resultado out varchar2,
                                ac_mensaje   out varchar2) is
    ls_numslc        solot.numslc%type;
    ls_codcli        solot.codcli%type;
    ln_tipequ        tipequ.tipequ%type;
    ln_maxnumli      vtaequcom.Maxnumli%type;
    ls_codsuc        vtadetptoenl.codsuc%type;
    ln_idins_equipo  ope_ins_equipo_cab.idins_equipo%type;
    l_tipsrv         vtatabslcfac.tipsrv%type;
    l_idcampanha     vtatabslcfac.idcampanha%type;
    ln_numero_lineas number;
    ln_num_equipos   number;
  
    cursor c_lineas(p_numslc solot.numslc%type) is
      select codinssrv
        from inssrv i
       where tipsrv =
             (select valor from constante where constante = 'FAM_TELEF')
         and numslc = p_numslc
      union
      select codinssrv
        from inssrv i
       where tipsrv =
             (select valor from constante where constante = 'FAM_TELEF')
         and numslc in
             (select numslc_ori from regvtamentab where numslc = p_numslc);
  
    cursor c_lineas_tpe(p_numslc solot.numslc%type) is
      select codinssrv
        from inssrv i
       where tipsrv =
             (select valor from constante where constante = 'TELEF_TPE')
         and numslc = p_numslc
      union
      select codinssrv
        from inssrv i
       where tipsrv =
             (select valor from constante where constante = 'TELEF_TPE')
         and numslc in
             (select numslc_ori from regvtamentab where numslc = p_numslc);
             
    /* INI 8.0 */        
    cursor c_lineas_corp(p_numslc solot.numslc%type) is
      select codinssrv
        from inssrv i
       where tipsrv =
             (select valor from constante where constante = 'TELEF_REDCLARO')
         and numslc = p_numslc
      union
      select codinssrv
        from inssrv i
       where tipsrv =
             (select valor from constante where constante = 'TELEF_REDCLARO')
         and numslc in
             (select numslc_ori from regvtamentab where numslc = p_numslc);
    /* FIN 8.0 */     
  begin
    begin
      select count(1)
        into ln_num_equipos
        from ope_ins_equipo_cab
       where codsolot = p_codsolot
         and estado = 1;
    
      --si existen registros es por una reasignacion de workflow y no requiere volver a insertarlos
      if ln_num_equipos = 0 then
        select numslc, codcli
          into ls_numslc, ls_codcli
          from solot
         where codsolot = p_codsolot;
      
        l_tipsrv     := operacion.pkg_tpe.get_tipsrv(p_codsolot);
        l_idcampanha := operacion.pkg_tpe.get_idcampanha(p_codsolot);
      
        begin
          select distinct t.tipequ, v2.maxnumli, v1.codsuc
            into ln_tipequ, ln_maxnumli, ls_codsuc
            from tipequ t, equcomxope e, vtadetptoenl v1, vtaequcom v2
           where v1.codequcom = v2.codequcom
             and e.codequcom = v1.codequcom
             and t.tipequ = e.tipequ
             and v1.codequcom is not null
             and v2.maxnumli is not null
             and v2.maxnumli > 0
             and e.esparte = 0
             and v1.numslc = ls_numslc;
        
        exception
          when too_many_rows then
            select max(t.tipequ)
              into ln_tipequ
              from tipequ t, equcomxope e, vtadetptoenl v1, vtaequcom v2
             where v1.codequcom = v2.codequcom
               and e.codequcom = v1.codequcom
               and t.tipequ = e.tipequ
               and v1.codequcom is not null
               and v2.maxnumli is not null
               and v2.maxnumli > 0
               and e.esparte = 0
               and v1.numslc = ls_numslc;
          
            select v2.maxnumli, v1.codsuc
              into ln_maxnumli, ls_codsuc
              from tipequ t, equcomxope e, vtadetptoenl v1, vtaequcom v2
             where v1.codequcom = v2.codequcom
               and e.codequcom = v1.codequcom
               and t.tipequ = e.tipequ
               and v1.codequcom is not null
               and v2.maxnumli is not null
               and v2.maxnumli > 0
               and e.esparte = 0
               and t.tipequ = ln_tipequ
               and v1.numslc = ls_numslc;
          
          when no_data_found then
            /* INI 8.0 */  
            begin
              select distinct t.tipequ, 1, v1.codsuc
                into ln_tipequ, ln_maxnumli, ls_codsuc
                from tipequ t, equcomxope e, vtadetptoenl v1, vtaequcom v2
               where v1.codequcom = v2.codequcom
                 and e.codequcom = v1.codequcom
                 and t.tipequ = e.tipequ
                 and v1.codequcom is not null
                 and e.esparte = 0
                 and v1.numslc = ls_numslc;
        exception
             when too_many_rows then 
            select max(t.tipequ)
              into ln_tipequ
              from tipequ t, equcomxope e, vtadetptoenl v1, vtaequcom v2
             where v1.codequcom = v2.codequcom
               and e.codequcom = v1.codequcom
               and t.tipequ = e.tipequ
               and v1.codequcom is not null
               and e.esparte = 0
               and v1.numslc = ls_numslc;

            select 1, v1.codsuc
              into ln_maxnumli, ls_codsuc
              from tipequ t, equcomxope e, vtadetptoenl v1, vtaequcom v2
             where v1.codequcom = v2.codequcom
               and e.codequcom = v1.codequcom
               and t.tipequ = e.tipequ
               and v1.codequcom is not null
               and e.esparte = 0
               and t.tipequ = ln_tipequ
               and v1.numslc = ls_numslc;  
        
              when others then
                ln_maxnumli := 0;
            end;
            /* FIN 8.0 */ 
            -- ln_maxnumli := 0;
        end;
      
        if ln_maxnumli > 0 then
          insert into operacion.ope_ins_equipo_cab
            (tipequ,
             codsolot,
             codcli,
             codsuc,
             numslc,
             tot_lineas,
             num_lineas_libres,
             estado)
          values
            (ln_tipequ,
             p_codsolot,
             ls_codcli,
             ls_codsuc,
             ls_numslc,
             ln_maxnumli,
             ln_maxnumli,
             1);
        
          select max(idins_equipo)
            into ln_idins_equipo
            from ope_ins_equipo_cab;
        
          ln_numero_lineas := 0;
        
          if operacion.pkg_tpe.es_tpe(l_tipsrv) and
             operacion.pkg_tpe.es_campanha_tpe(l_idcampanha) then
            for lineas in c_lineas_tpe(ls_numslc) loop
              ln_numero_lineas := ln_numero_lineas + 1;
              insert into operacion.ope_ins_equipo_det
                (idins_equipo, tipo, codinssrv, codsolot, puerto, estado)
              values
                (ln_idins_equipo,
                 1,
                 lineas.codinssrv,
                 p_codsolot,
                 ln_numero_lineas,
                 1);
            end loop;
          else
            for lineas in c_lineas(ls_numslc) loop
              ln_numero_lineas := ln_numero_lineas + 1;
              insert into operacion.ope_ins_equipo_det
                (idins_equipo, tipo, codinssrv, codsolot, puerto, estado)
              values
                (ln_idins_equipo,
                 1,
                 lineas.codinssrv,
                 p_codsolot,
                 ln_numero_lineas,
                 1);
            end loop;
            /* INI 8.0 */ 
            ln_numero_lineas := 0;
            for lineas_corp in c_lineas_corp(ls_numslc) loop
              ln_numero_lineas := ln_numero_lineas + 1;
              insert into operacion.ope_ins_equipo_det
                (idins_equipo, tipo, codinssrv, codsolot, puerto, estado)
              values
                (ln_idins_equipo,
                 1,
                 lineas_corp.codinssrv,
                 p_codsolot,
                 ln_numero_lineas,
                 1);
            end loop;
            /* FIN 8.0 */  
          end if;
        end if;
      end if;
    
      ac_resultado := 'OK';
      ac_mensaje   := null;
    exception
      when others then
        ac_resultado := 'ERROR';
        ac_mensaje   := 'Error al realizar carga inicial';
    end;
  end;
  --------------------------------------------------------------------------------
  --ini 2.0
  procedure p_crea_ins_equipo_cab(an_tipequ tipequ.tipequ%type,
                                  ac_codcli vtatabcli.codcli%type,
                                  ac_codsuc vtasuccli.codsuc%type,
                                  an_tot_lineas number,
                                  an_codsolot solot.codsolot%type,
                                  ac_numslc vtatabslcfac.numslc%type,
                                  an_idins_equipo out ope_ins_equipo_cab.idins_equipo%type,
                                  ac_resultado out varchar2,
                                  ac_mensaje out varchar2) is

  ln_idins_equipo ope_ins_equipo_cab.idins_equipo%type;
  begin

    insert into ope_ins_equipo_cab(
      tipequ,
      codcli,
      codsuc,
      tot_lineas,
      num_lineas_libres,
      codsolot,
      numslc
      )
    values(
      an_tipequ,
      ac_codcli,
      ac_codsuc,
      an_tot_lineas,
      an_tot_lineas,
      an_codsolot,
      ac_numslc
      )returning idins_equipo into ln_idins_equipo;

    an_idins_equipo := ln_idins_equipo;
    ac_resultado := 'OK';
    ac_mensaje := null;
  exception
    when others then
      ac_resultado := 'ERROR';
      ac_mensaje := 'Error al crear cabecera de equipo';
  end;

  procedure p_mod_ins_equipo_cab(an_idins_equipo ope_ins_equipo_cab.idins_equipo%type,
                                  an_tipequ tipequ.tipequ%type,
                                  an_tot_lineas number,
                                  ac_codsuc vtasuccli.codsuc%type,
                                  an_codsolot solot.codsolot%type,
                                  ac_resultado out varchar2,
                                  ac_mensaje out varchar2) is

  lc_resultado varchar2(100);
  lc_mensaje varchar2(300);

  cursor cur_detalle is
    select * from ope_ins_equipo_det
    where idins_equipo =  an_idins_equipo;

  ln_tot_lineas ope_ins_equipo_cab.tot_lineas%type;
  begin

     if an_tipequ is not null and ac_codsuc is not null then
      update ope_ins_equipo_cab
      set tipequ = an_tipequ,
      codsuc = ac_codsuc,
      codsolot = an_codsolot
      where idins_equipo = an_idins_equipo;

    elsif an_tipequ is null and ac_codsuc is not null then
      update ope_ins_equipo_cab
      set codsuc = ac_codsuc,
      codsolot = an_codsolot
      where idins_equipo = an_idins_equipo;

    elsif an_tipequ is not null and ac_codsuc is null then
      update ope_ins_equipo_cab
      set tipequ = an_tipequ,
      codsolot = an_codsolot
      where idins_equipo = an_idins_equipo;
    end if;

    --si actualiza numero de lineas
    if an_tot_lineas is not null and an_tot_lineas > 0 then
      select tot_lineas into ln_tot_lineas
      from ope_ins_equipo_cab
      where idins_equipo = an_idins_equipo;

      --si es diferente del numero actual
      if ln_tot_lineas <> an_tot_lineas then
        update ope_ins_equipo_cab
        set tot_lineas = an_tot_lineas,
        num_lineas_libres = an_tot_lineas
        where idins_equipo = an_idins_equipo;

        --se cancelan los detalles existente
        for reg_detalle in cur_detalle loop
          p_cancela_ins_equipo_det(reg_detalle.idins_equipo_det,an_codsolot,lc_resultado,lc_mensaje);
        end loop;
      end if;

    end if;

    ac_resultado := 'OK';
    ac_mensaje := null;
  exception
    when others then
      ac_resultado := 'ERROR';
      ac_mensaje := 'Error al modificar cabecera de equipo';
  end;

  procedure p_cancela_ins_equipo_cab(an_idins_equipo ope_ins_equipo_cab.idins_equipo%type,
                                     an_codsolot solot.codsolot%type,
                                     ac_resultado out varchar2,
                                     ac_mensaje out varchar2) is
  --cursor de detalle de equipo
  cursor cur_equipo_det(an_idins_equipo number) is
    select idins_equipo_det
    from ope_ins_equipo_det
    where idins_equipo = an_idins_equipo
    and estado = 1;

  ls_resultado varchar2(100);
  ls_mensaje varchar2(300);

  begin
    update ope_ins_equipo_cab
    set estado = 0,
    codsolot = an_codsolot
    where idins_equipo = an_idins_equipo;

    for reg_equipo_det in cur_equipo_det(an_idins_equipo) loop
      p_cancela_ins_equipo_det(reg_equipo_det.idins_equipo_det,an_codsolot,ls_resultado,ls_mensaje);
    end loop;

    ac_resultado := 'OK';
    ac_mensaje := null;
  exception
    when others then
      ac_resultado := 'ERROR';
      ac_mensaje := 'Error al cancelar cabecera de equipo';
  end;

  procedure p_cancela_ins_equipo_solot(an_codsolot solot.codsolot%type,
                                     ac_resultado out varchar2,
                                     ac_mensaje out varchar2) is

  --cursor de cabecera de equipo
  cursor cur_equipo_cab is
    select distinct a.idins_equipo
    from ope_ins_equipo_cab a,ope_ins_equipo_det b,inssrv e,solotpto d,solot c, tipequ f, insprd g
    where a.tipequ = f.tipequ
    and a.codcli = c.codcli
    and d.codinssrv = e.codinssrv
    and c.codsolot = d.codsolot
    and a.codsolot = d.codsolot --7.0
    and c.codsolot = an_codsolot
    and a.idins_equipo = b.idins_equipo
    and b.codinssrv = d.codinssrv
    and d.pid = g.pid(+)
    and a.estado = 1
    and b.estado = 1
    and (d.pid is null or g.flgprinc = 1);

  ls_resultado varchar2(100);
  ls_mensaje varchar2(300);

  begin
    for reg_equipo_cab in cur_equipo_cab loop
      p_cancela_ins_equipo_cab(reg_equipo_cab.idins_equipo,an_codsolot,ls_resultado,ls_mensaje);
    end loop;

    ac_resultado := 'OK';
    ac_mensaje := null;
  exception
    when others then
      ac_resultado := 'ERROR';
      ac_mensaje := 'Error al cancelar equipos asociados a la solicitud';
  end;

  procedure p_crea_ins_equipo_det(an_idins_equipo ope_ins_equipo_det.idins_equipo%type,
                                  an_tipo ope_ins_equipo_det.tipo%type,
                                  ac_puerto ope_ins_equipo_det.puerto%type,
                                  an_codinssrv inssrv.codinssrv%type,
                                  an_codsolot solot.codsolot%type,
                                  an_idins_equipo_det out ope_ins_equipo_det.idins_equipo_det%type,
                                  ac_resultado out varchar2,
                                  ac_mensaje out varchar2) is

  ln_idins_equipo_det ope_ins_equipo_det.idins_equipo_det%type;
  begin
    insert into ope_ins_equipo_det(
      idins_equipo,
      tipo,
      puerto,
      codinssrv,
      codsolot
      )
    values(
      an_idins_equipo,
      an_tipo,
      ac_puerto,
      an_codinssrv,
      an_codsolot
      )returning idins_equipo_det into ln_idins_equipo_det;

    an_idins_equipo_det := ln_idins_equipo_det;

    ac_resultado := 'OK';
    ac_mensaje := null;
  exception
    when others then
      ac_resultado := 'ERROR';
      ac_mensaje := 'Error al crear detalle de equipo';
  end;

  procedure p_mod_ins_equipo_det(an_idins_equipo_det ope_ins_equipo_det.idins_equipo_det%type,
                                  ac_puerto ope_ins_equipo_det.puerto%type,
                                  an_codinssrv inssrv.codinssrv%type,
                                  an_codsolot solot.codsolot%type,
                                  ac_resultado out varchar2,
                                  ac_mensaje out varchar2) is

  begin
    if ac_puerto is not null and an_codinssrv is not null then
      update ope_ins_equipo_det
      set puerto = ac_puerto,
      codinssrv = an_codinssrv,
      codsolot = an_codsolot
      where idins_equipo_det = an_idins_equipo_det;

    elsif ac_puerto is null and an_codinssrv is not null then
      update ope_ins_equipo_det
      set codinssrv = an_codinssrv,
      codsolot = an_codsolot
      where idins_equipo_det = an_idins_equipo_det;

    elsif ac_puerto is not null and an_codinssrv is null then
      update ope_ins_equipo_det
      set puerto = ac_puerto,
      codsolot = an_codsolot
      where idins_equipo_det = an_idins_equipo_det;
    end if;

    ac_resultado := 'OK';
    ac_mensaje := null;
  exception
    when others then
      ac_resultado := 'ERROR';
      ac_mensaje := 'Error al modificar detalle de equipo';
  end;

  procedure p_cancela_ins_equipo_det(an_idins_equipo_det ope_ins_equipo_det.idins_equipo_det%type,
                                     an_codsolot solot.codsolot%type,
                                     ac_resultado out varchar2,
                                     ac_mensaje out varchar2) is
  begin
    update ope_ins_equipo_det
    set estado = 0,
    codsolot = an_codsolot
    where idins_equipo_det = an_idins_equipo_det;

    ac_resultado := 'OK';
    ac_mensaje := null;
  exception
    when others then
      ac_resultado := 'ERROR';
      ac_mensaje := 'Error al cancelar detalle de equipo';
  end;
  --fin 2.0
end;
/
