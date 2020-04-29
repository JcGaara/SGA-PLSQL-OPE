create or replace package body operacion.pkg_tpe is
  /****************************************************************************
   Nombre Package    : pkg_tpe
   Proposito         : Generar datos de Telefonía Publica de Exteriores
   REVISIONES:
   Ver  Fecha       Autor             Solicitado por    Descripcion
   ---  ----------  ----------------  ----------------  ----------------------
   1.0  06/05/2015  Jose Ruiz         Eustaquio Jibaja  
   2.0  2015-06-25  Freddy Gonzales   Eustaquio Jibaja  SD 372800
   3.0  2015-07-09  Freddy Gonzales   Hector Huaman     SD-335922
  ****************************************************************************/
  procedure generar_cod_externos(p_codinssrv  inssrv.codinssrv%type,
                                 p_tipsrv     solot.tipsrv%type,
                                 p_codsolot   solot.codsolot%type,
                                 p_codcli     solot.codcli%type,
                                 p_cuenta     number,
                                 p_opcion     number,
                                 p_pidorigen  number,
                                 p_enviar_itw number,
                                 p_resultado  in out varchar2,
                                 p_mensaje    in out varchar2,
                                 p_error      in out number) is
    l_pidorigen varchar2(20);
    l_cuenta    number;
  
    cursor servicios_ext is
      select a.pid,
             a.pid_old,
             a.codinssrv,
             operacion.pq_promo3play.f_promo3play_srvprom(p_codsolot,
                                                          p_codcli,
                                                          c.codsrv,
                                                          p_opcion) codigo_ext
        from solotpto a, tystabsrv c, insprd p
       where a.codsolot = p_codsolot
         and a.codsrvnue = c.codsrv
         and c.tipsrv = p_tipsrv
         and a.pid = p.pid
         and p.flgprinc = 0 -- No es Principal
         and c.codigo_ext in
             (select d.codigoc
                from tipopedd c, opedd d
               where c.abrev = 'tpe'
                 and c.tipopedd = d.tipopedd
                 and d.abreviacion = 'cod_externo_tpe')
         and a.codinssrv = p_codinssrv
         and c.codigo_ext is not null
         and p.estinsprd <> 3
      union
      select a.pid,
             a.pid_old,
             a.codinssrv,
             operacion.pq_promo3play.f_promo3play_srvprom(p_codsolot,
                                                          p_codcli,
                                                          c.codsrv,
                                                          p_opcion) codigo_ext
        from solotpto a, tystabsrv c, insprd p
       where a.codinssrv = p_codinssrv
         and p.estinsprd <> 3
         and a.codsrvnue = c.codsrv
         and c.tipsrv = p_tipsrv
         and a.pid = p.pid
         and p.flgprinc = 0 -- No es Principal
         and p.codequcom is null
         and c.codigo_ext is not null
         and p.fecini is not null
         and not exists (select 'y'
                from solotpto
               where pid_old = a.pid
                 and codinssrv = a.codinssrv);
  
  begin
    l_cuenta := p_cuenta;
    for servicio_ext in servicios_ext loop
      l_cuenta    := l_cuenta + 1;
      l_pidorigen := p_pidorigen || l_cuenta;
    
      intraway.pq_intraway.p_mta_fac_administracion(1, -- estado
                                                    p_codcli,
                                                    l_pidorigen,
                                                    servicio_ext.pid,
                                                    p_pidorigen,
                                                    servicio_ext.codigo_ext,
                                                    p_opcion,
                                                    p_codsolot,
                                                    p_codinssrv,
                                                    p_resultado,
                                                    p_mensaje,
                                                    p_error,
                                                    p_enviar_itw);
    
      if p_error <> 0 then
        raise_application_error(-20000,
                                'No se puede ejecutar el proceso: P_MTA_FAC_ADMINISTRACION ' ||
                                'Error:' || p_mensaje);
      end if;
    end loop;
  
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.generar_cod_externos(p_codinssrv => ' ||
                              p_codinssrv || ') ' || sqlerrm);
  end;
  ---------------------------------------------------------------------------
  function es_tpe(p_tipsrv tystipsrv.tipsrv%type) return boolean is
    l_count pls_integer;
  
  begin
    select count(*)
      into l_count
      from tipopedd c, opedd d
     where c.abrev = 'tpe'
       and c.tipopedd = d.tipopedd
       and d.abreviacion = 'servicio_tpe'
       and d.codigoc = p_tipsrv;
  
    return l_count > 0;
  
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.es_tpe(p_tipsrv => ' ||
                              p_tipsrv || ') ' || sqlerrm);
  end;
  ---------------------------------------------------------------------------
  function get_tpe return tystipsrv.tipsrv%type is
    l_tipsrv tystipsrv.tipsrv%type;
  
  begin
    select d.codigoc
      into l_tipsrv
      from tipopedd c, opedd d
     where c.abrev = 'tpe'
       and c.tipopedd = d.tipopedd
       and d.abreviacion = 'servicio_tpe';
  
    return l_tipsrv;
  
  exception
    when others then
      raise_application_error(-20000, $$plsql_unit || '.get_tpe() ' || sqlerrm);
  end;
  ---------------------------------------------------------------------------
  function get_tiptra return solot.tiptra%type is
    l_tiptra solot.tiptra%type;
  
  begin
    select d.codigon
      into l_tiptra
      from tipopedd c, opedd d
     where c.abrev = 'tpe'
       and c.tipopedd = d.tipopedd
       and d.abreviacion = 'tiptra_tpe';
  
    return l_tiptra;
  
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.get_tiptra() ' || sqlerrm);
  end;
  --------------------------------------------------------------------------------
  procedure set_vtadetptoenl(p_numslc      vtatabslcfac.numslc%type,
                             p_codsuc      vtasuccli.codsuc%type,
                             p_codequcomct vtadetptoenl.codequcom%type,
                             p_codequcome  vtadetptoenl.codequcom%type,
                             p_cant_lineas integer,
                             p_texto       varchar2) is
    l_nomsuc       vtasuccli.nomsuc%type;
    l_ubisuc       vtasuccli.ubisuc%type;
    l_dirsuc       vtasuccli.dirsuc%type;
    l_porcentaje   impuesto.porcentaje%type;
    l_idimpuesto   impuesto.idimpuesto%type;
    l_vtadetptoenl vtadetptoenl%rowtype;
  
  begin
    case p_texto
      when 'numero_telefonico' then
        l_vtadetptoenl.flgsrv_pri := 1;
        l_vtadetptoenl.codsrv     := get_valor('servicio_telefonico');
        l_vtadetptoenl.idproducto := to_number(get_valor('producto_telefonico'));
        l_vtadetptoenl.idprecio   := to_number(get_valor('precio_telefonico'));
        l_vtadetptoenl.codequcom  := null;
        l_vtadetptoenl.moneda_id  := 1;
        l_vtadetptoenl.banwid     := 0;
        l_vtadetptoenl.idpaq      := to_number(get_valor('idpaq_telefonico'));
      
      when 'cabina_telefonica' then
        l_vtadetptoenl.flgsrv_pri := 0;
        l_vtadetptoenl.codsrv     := get_valor('servicio_cabina');
        l_vtadetptoenl.idproducto := to_number(get_valor('producto_cabina'));
        l_vtadetptoenl.idprecio   := to_number(get_valor('precio_cabina'));
        l_vtadetptoenl.codequcom  := nvl(p_codequcomct, '1330');
        l_vtadetptoenl.moneda_id  := 2;
        l_vtadetptoenl.banwid     := null;
        l_vtadetptoenl.idpaq      := to_number(get_valor('idpaq_cabina'));
      
      when 'equipo_telefonico' then
        l_vtadetptoenl.flgsrv_pri := 0;
        l_vtadetptoenl.codsrv     := get_valor('servicio_equipo');
        l_vtadetptoenl.idproducto := to_number(get_valor('producto_equipo'));
        l_vtadetptoenl.idprecio   := to_number(get_valor('precio_equipo'));
        l_vtadetptoenl.codequcom  := nvl(p_codequcome, '1327');
        l_vtadetptoenl.moneda_id  := 2;
        l_vtadetptoenl.banwid     := 0;
        l_vtadetptoenl.idpaq      := to_number(get_valor('idpaq_equipo'));
      
      when 'comodato' then
        l_vtadetptoenl.flgsrv_pri := 0;
        l_vtadetptoenl.codsrv     := get_valor('servicio_comodato');
        l_vtadetptoenl.idproducto := to_number(get_valor('producto_comodato'));
        l_vtadetptoenl.idprecio   := to_number(get_valor('precio_comodato'));
        if p_cant_lineas <= 2 then
          l_vtadetptoenl.codequcom := get_valor('equipo_puertos2'); --2 puertos
        elsif p_cant_lineas >= 3 and p_cant_lineas <= 4 then
          l_vtadetptoenl.codequcom := get_valor('equipo_puertos4'); --4 puertos
        elsif p_cant_lineas >= 5 and p_cant_lineas <= 8 then
          l_vtadetptoenl.codequcom := get_valor('equipo_puertos8'); --8 puertos
        end if;
        l_vtadetptoenl.moneda_id := 2;
        l_vtadetptoenl.banwid    := 0;
        l_vtadetptoenl.idpaq     := to_number(get_valor('idpaq_comodato'));
      
      when 'intraway_1' then
        l_vtadetptoenl.flgsrv_pri := 0;
        l_vtadetptoenl.codsrv     := get_valor('servicio_intraway1');
        l_vtadetptoenl.idproducto := to_number(get_valor('producto_intraway1'));
        l_vtadetptoenl.idprecio   := to_number(get_valor('precio_intraway1'));
        l_vtadetptoenl.codequcom  := nvl(p_codequcome, '1327');
        l_vtadetptoenl.moneda_id  := 2;
        l_vtadetptoenl.banwid     := 0;
        l_vtadetptoenl.idpaq      := to_number(get_valor('idpaq_intraway1'));
      
      when 'intraway_2' then
        l_vtadetptoenl.flgsrv_pri := 0;
        l_vtadetptoenl.codsrv     := get_valor('servicio_intraway2');
        l_vtadetptoenl.idproducto := to_number(get_valor('producto_intraway2'));
        l_vtadetptoenl.idprecio   := to_number(get_valor('precio_intraway2'));
        l_vtadetptoenl.codequcom  := nvl(p_codequcome, '1327');
        l_vtadetptoenl.moneda_id  := 2;
        l_vtadetptoenl.banwid     := 0;
        l_vtadetptoenl.idpaq      := to_number(get_valor('idpaq_intraway2'));
      
      else
        raise_application_error(-20000,
                                'La validacion: ' || p_texto ||
                                ' no esta definida');
    end case;
  
    select nomsuc, ubisuc, dirsuc
      into l_nomsuc, l_ubisuc, l_dirsuc
      from vtasuccli
     where codsuc = p_codsuc;
  
    l_porcentaje := pq_impuesto.f_obt_porcentaje_impuesto(l_idimpuesto);
  
    l_vtadetptoenl.numslc        := p_numslc;
    l_vtadetptoenl.codsuc        := p_codsuc;
    l_vtadetptoenl.descpto       := l_nomsuc;
    l_vtadetptoenl.dirpto        := l_dirsuc;
    l_vtadetptoenl.ubipto        := l_ubisuc;
    l_vtadetptoenl.porcimp_srv   := l_porcentaje;
    l_vtadetptoenl.porcimp_ins   := l_porcentaje;
    l_vtadetptoenl.numpto_prin   := get_numpto(p_numslc);
    l_vtadetptoenl.paquete       := get_grupo(p_numslc);
    l_vtadetptoenl.grupo         := get_grupo(p_numslc);
    l_vtadetptoenl.crepto        := '1';
    l_vtadetptoenl.estcts        := '1';
    l_vtadetptoenl.estcse        := '1';
    l_vtadetptoenl.on_net        := 1;
    l_vtadetptoenl.cantidad      := 1;
    l_vtadetptoenl.preuni_srv    := 0;
    l_vtadetptoenl.prelis_srv    := 0;
    l_vtadetptoenl.prelis_ins    := 0;
    l_vtadetptoenl.monto_ins_imp := 0;
    l_vtadetptoenl.desc_srv      := 0;
    l_vtadetptoenl.desc_ins      := 0;
    l_vtadetptoenl.monto_srv     := 0;
    l_vtadetptoenl.monto_ins     := 0;
    l_vtadetptoenl.monto_srv_imp := 0;
    l_vtadetptoenl.multa         := 0;
    l_vtadetptoenl.tipo_vta      := 1;
    l_vtadetptoenl.preuni_ins    := 0;
  
    if p_texto = 'comodato' then
      if not existe_comodato(l_vtadetptoenl.numslc, l_vtadetptoenl.codequcom) then
        insert_vtadetptoenl(l_vtadetptoenl);
      end if;
      return;
    end if;
  
    insert_vtadetptoenl(l_vtadetptoenl);
  
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.set_vtadetptoenl(p_numslc => ' ||
                              p_numslc || ', p_codsuc => ' || p_codsuc ||
                              ', p_codequcomct => ' || p_codequcomct ||
                              ', p_codequcome => ' || p_codequcome ||
                              ', p_cant_lineas => ' || p_cant_lineas ||
                              ', p_texto => ' || p_texto || sqlerrm);
  end;
  ---------------------------------------------------------------------------
  function get_valor(p_abreviacion opedd.abreviacion%type)
    return opedd.codigoc%type is
    l_codigoc opedd.codigoc%type;
  
  begin
    select d.codigoc
      into l_codigoc
      from tipopedd c, opedd d
     where c.abrev = 'tpe'
       and c.tipopedd = d.tipopedd
       and d.abreviacion = p_abreviacion;
  
    return l_codigoc;
  
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.get_valor(p_abreviacion => ' ||
                              p_abreviacion || ') ' || sqlerrm);
  end;
  --------------------------------------------------------------------------------
  function get_numpto(p_numslc vtatabslcfac.numslc%type)
    return vtadetptoenl.numpto%type is
    l_numpto vtadetptoenl.numpto%type;
    
  begin
    select nvl(lpad(max(to_number(numpto)), 5, '0'), '00001')
      into l_numpto
      from vtadetptoenl
     where numslc = p_numslc;
  
    return l_numpto;
  
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.get_numpto(p_numslc => ' ||
                              p_numslc || ') ' || sqlerrm);
  end;
  --------------------------------------------------------------------------------
  function get_grupo(p_numslc vtatabslcfac.numslc%type)
    return vtadetptoenl.grupo%type is
    l_grupo vtadetptoenl.grupo%type;
  
  begin
    select nvl(max(grupo), 1)
      into l_grupo
      from vtadetptoenl
     where numslc = p_numslc;
  
    return l_grupo;
  
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.get_grupo(p_numslc => ' ||
                              p_numslc || ') ' || sqlerrm);
  end;
  --------------------------------------------------------------------------------
  function existe_comodato(p_numslc    vtadetptoenl.numslc%type,
                           p_codequcom vtadetptoenl.codequcom%type)
    return boolean is
    l_count pls_integer;
  
  begin
    select count(v.codequcom)
      into l_count
      from vtadetptoenl v
     where v.numslc = p_numslc
       and v.codequcom = p_codequcom;
  
    return l_count > 0;
  
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.existe_comodato(p_numslc => ' ||
                              p_numslc || ', p_codequcom => ' || p_codequcom ||
                              sqlerrm);
  end;
  --------------------------------------------------------------------------------  
  procedure insert_vtadetptoenl(p_vtadetptoenl vtadetptoenl%rowtype) is
  begin
    insert into vtadetptoenl
      (numslc,
       codsuc,
       flgsrv_pri,
       codsrv,
       idproducto,
       crepto,
       estcts,
       estcse,
       on_net,
       idprecio,
       porcimp_srv,
       porcimp_ins,
       cantidad,
       codequcom,
       grupo,
       tipo_vta,
       moneda_id,
       descpto,
       dirpto,
       ubipto,
       preuni_srv,
       banwid,
       prelis_srv,
       prelis_ins,
       desc_srv,
       desc_ins,
       monto_srv,
       monto_ins,
       monto_srv_imp,
       monto_ins_imp,
       numpto_prin,
       paquete,
       multa,
       preuni_ins,
       idpaq)
    values
      (p_vtadetptoenl.numslc,
       p_vtadetptoenl.codsuc,
       p_vtadetptoenl.flgsrv_pri,
       p_vtadetptoenl.codsrv,
       p_vtadetptoenl.idproducto,
       p_vtadetptoenl.crepto,
       p_vtadetptoenl.estcts,
       p_vtadetptoenl.estcse,
       p_vtadetptoenl.on_net,
       p_vtadetptoenl.idprecio,
       p_vtadetptoenl.porcimp_srv,
       p_vtadetptoenl.porcimp_ins,
       p_vtadetptoenl.cantidad,
       p_vtadetptoenl.codequcom,
       p_vtadetptoenl.grupo,
       p_vtadetptoenl.tipo_vta,
       p_vtadetptoenl.moneda_id,
       p_vtadetptoenl.descpto,
       p_vtadetptoenl.dirpto,
       p_vtadetptoenl.ubipto,
       p_vtadetptoenl.preuni_srv,
       p_vtadetptoenl.banwid,
       p_vtadetptoenl.prelis_srv,
       p_vtadetptoenl.prelis_ins,
       p_vtadetptoenl.desc_srv,
       p_vtadetptoenl.desc_ins,
       p_vtadetptoenl.monto_srv,
       p_vtadetptoenl.monto_ins,
       p_vtadetptoenl.monto_srv_imp,
       p_vtadetptoenl.monto_ins_imp,
       p_vtadetptoenl.numpto_prin,
       p_vtadetptoenl.paquete,
       p_vtadetptoenl.multa,
       p_vtadetptoenl.preuni_ins,
       p_vtadetptoenl.idpaq);
  
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.insert_vtadetptoenl(p_vtadetptoenl => rowtype) ' ||
                              sqlerrm);
  end;
  --------------------------------------------------------------------------------
  function aplicar_tpe(p_tipsrv   tystipsrv.tipsrv%type,
                       p_campanha campanha.idcampanha%type) return number is
  begin
    if not esta_habilitado() then
      return 0;
    end if;
  
    if not es_tpe(p_tipsrv) then
      return 0;
    end if;
  
    if not es_campanha_tpe(p_campanha) then
      return 0;
    end if;
  
    return 1;
  
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.aplicar_tpe(p_tipsrv => ' ||
                              p_tipsrv || ', p_campanha => ' || p_campanha ||
                              sqlerrm);
  end;
  --------------------------------------------------------------------------------
  function esta_habilitado return boolean is
    l_count pls_integer;
  
  begin
    select count(*)
      into l_count
      from tipopedd t, opedd p
     where t.abrev = 'tpe'
       and t.tipopedd = p.tipopedd
       and p.abreviacion = 'esta_habilitado'
       and p.codigon = 1;
  
    return l_count > 0;
  
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.aplica_validacion_tpe' ||
                              sqlerrm);
  end;
  --------------------------------------------------------------------------------
  function es_campanha_tpe(p_campanha campanha.idcampanha%type) return boolean is
    l_count pls_integer;
  
  begin
  
    select count(1)
      into l_count
      from tipopedd t, opedd p
     where t.abrev = 'tpe'
       and t.tipopedd = p.tipopedd
       and p.abreviacion = 'campanha_tpe'
       and p.codigon = p_campanha;
  
    return l_count > 0;
  
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.existe_campanha(p_campanha => ' ||
                              p_campanha || ') ' || sqlerrm);
  end;
  --------------------------------------------------------------------------------
  function get_idcampanha(p_codsolot solot.codsolot%type)
    return vtatabslcfac.idcampanha%type is
    l_idcampanha vtatabslcfac.idcampanha%type;
  
  begin
    select v.idcampanha
      into l_idcampanha
      from solot s, vtatabslcfac v
     where s.codsolot = p_codsolot
       and s.numslc = v.numslc;
  
    return l_idcampanha;
  
  exception
    when no_data_found then
      return 0;
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.get_idcampanha(p_codsolot => ' ||
                              p_codsolot || ') ' || sqlerrm);
  end;
  --------------------------------------------------------------------------------
  function get_tipsrv(p_codsolot solot.codsolot%type)
    return vtatabslcfac.tipsrv%type is
    l_tipsrv vtatabslcfac.tipsrv%type;
  
  begin
    select s.tipsrv into l_tipsrv from solot s where s.codsolot = p_codsolot;
  
    return l_tipsrv;
  
  exception
    when no_data_found then
      return null;
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.get_tipsrv(p_codsolot => ' ||
                              p_codsolot || ') ' || sqlerrm);
  end;
  --------------------------------------------------------------------------------
end;
/
