create or replace package body operacion.pq_solicitud_pedido is

  /********************************************************************************************
  NOMBRE:       PQ_SOLICITUD_PEDIDO
  PROPOSITO:    Gestión de la solitud de Pedidos para Materiales y Equipos.
  REVISIONES:
  Versión    Fecha       Autor         Solicitado por    Descripción
  -------  ----------  --------------  --------------  ---------------------------------------
           31/08/2011    Tommy Arakaki       Comienza con:
   2.0     13/06/2012    Edilberto Astulle   PROY-3884_Agendamiento PEXT
   3.0     20/03/2017     Servicio Fallas-HITSS  INC000000723013 - Módulo de requisiciones - Tipo Móvil
   4.0     22/06/2017    Lidia Quispe        PROY-29358 - Cambio de Estados   
   5.0     10/01/2019    Luigi Sipion PROY140119 IDEA140191 - Desarrollo del modulo requisicion
  *********************************************************************************************/
  procedure p_inserta_sol_ped_cab(ll_estado         number,ls_responsable    varchar2,
                                  ls_descripcion    varchar2,
                                  ls_complementario varchar2,
                                  o_idspcab     out number ) is
  n_area number; --2.0
  begin
    select f_get_area_usuario() into n_area from dual;--2.0
    insert into OPERACION.ope_sp_mat_equ_cab
      (ESTADO,responsable,
       descripcion,
       texto_complementario,
       area_solicitante)
    values
      (ll_estado,ls_responsable,
       ls_descripcion,
       ls_complementario,
       n_area)--2.0
    returning idspcab into o_idspcab;--2.0 
  end p_inserta_sol_ped_cab;

  procedure p_inserta_sol_ped_det(av_tipo varchar2, an_idspcab number,an_codsolot number,an_codef number,
  an_punto number, an_orden number, an_codeta number,an_ordencmp_idmat number, av_codmat varchar2 ) is
  v_cod_sap varchar2(30);
  v_desmat almtabmat.desmat%type;
  n_moneda_id almtabmat.moneda_id%type;
  v_codund almtabmat.codund%type;
  n_linea number;
  cursor cur_carga is --2.0
    select 'SOTMAT' tipo, 0 sel,s.codsolot codsolot, 0 ef, s.idmat idmat, e.codeta codeta , (select descripcion from ETAPA where codeta = e.codeta) deseta,s.punto,s.orden, 0 ordencmp, trim(s.codmat) equmat,a.cod_sap,a.desmat,  
    s.canins_ate cantidad,s.cosdis costo,a.moneda_id,a.codund codund,(select c.sblmon from CTBTABMON c where c.moneda_id = a.moneda_id) mon_des, 
    (select d.desund from ALMUNIMED d where d.codund = a.codund) und_des 
    from solotptoetamat s, almtabmat a, solotptoeta e where s.codmat = a.codmat 
    and e.codsolot = s.codsolot and e.punto = s.punto and e.orden = s.orden and (s.idspcab is null or s.idspcab = 0) 
    and s.codsolot = an_codsolot and 'SOTMAT' = av_tipo and s.idmat = an_ordencmp_idmat
    union 
    select 'SOTEQU', 0,s.codsolot codigo, 0 ef,0 idmat,s.codeta codeta,(select descripcion from ETAPA E where e.codeta = s.codeta) deseta,s.punto,s.orden,0 ordencmp,trim(t.codtipequ) equmat, 
    a.cod_sap,a.desmat,s.cantidad cantidad,s.costo costo,a.moneda_id,a.codund codund,(select c.sblmon from CTBTABMON c where c.moneda_id = a.moneda_id) mon_des, 
    (select d.desund from ALMUNIMED d where d.codund = a.codund) und_des 
    from solotptoequ s, solotpto p, tipequ t, almtabmat a where s.codsolot = p.codsolot 
    and s.tipequ = t.tipequ and s.punto = p.punto and t.codtipequ = a.codmat and (s.idspcab is null or s.idspcab = 0) 
    and s.codsolot = an_codsolot and 'SOTEQU' = av_tipo and s.punto= an_punto and s.orden = an_orden
    union
    select 'SOTCMP', 0 , s.codsolot codigo, 0 ef,0 idmat,0 codeta,(select descripcion from ETAPA E where e.codeta = s.codeta) deseta,s.punto,s.orden,s.ordencmp ordencmp,trim(t.codtipequ) equmat, 
    a.cod_sap,a.desmat,s.cantidad cantidad,s.costo costo,a.moneda_id,a.codund codund,(select c.sblmon from CTBTABMON c where c.moneda_id = a.moneda_id) mon_des, 
    (select d.desund from ALMUNIMED d where d.codund = a.codund) und_des 
    from solotptoequcmp s, solotpto p, tipequ t, almtabmat a where s.codsolot = p.codsolot 
    and s.tipequ = t.tipequ and s.punto = p.punto and t.codtipequ = a.codmat and (s.idspcab is null or s.idspcab = 0) 
    and s.codsolot =an_codsolot and 'SOTCMP' = av_tipo and s.punto = an_punto and s.orden = an_orden and s.ordencmp = an_ordencmp_idmat
    UNION
    select 'EFMAT', 0 sel,0 codsolot, s.codef ef,0 idmat,s.codeta codeta,(select descripcion from ETAPA E where e.codeta = s.codeta) deseta,s.punto,0 orden,0 ordencmp,s.codmat equmat, 
    a.cod_sap,a.desmat,s.cantidad cantidad,s.costo costo,a.moneda_id,a.codund codund,(select c.sblmon from CTBTABMON c where c.moneda_id = a.moneda_id) mon_des, 
    (select d.desund from ALMUNIMED d where d.codund = a.codund) und_des 
    from efptoetamat s, matope c, almtabmat a where s.codmat = c.codmat 
    and c.codmat = a.codmat(+) and (s.idspcab is null or s.idspcab = 0)  
    and s.codef=an_codef and 'EFMAT' = av_tipo and punto = an_punto and s.codeta = an_codeta and s.codmat= av_codmat
    union 
    select 'EFEQU', 0,0 codsolot, s.codef ef, 0 idmat,0 codeta,(select descripcion from ETAPA E where e.codeta = s.codeta) deseta, s.punto, s.orden,0 ordencmp, trim(s.codtipequ) equmat,  
    a.cod_sap cod_sap, a.desmat,s.cantidad cantidad,s.costo costo,a.moneda_id,a.codund codund,(select c.sblmon from CTBTABMON c 
    where c.moneda_id = a.moneda_id) mon_des,(select d.desund from ALMUNIMED d where d.codund = a.codund) und_des 
    from efptoequ s,tipequ t, almtabmat a 
    where s.tipequ = t.tipequ and t.codtipequ = a.codmat(+) and (s.idspcab is null or s.idspcab = 0)  
    and s.codef=an_codef and 'EFEQU' = av_tipo and punto = an_punto and orden = an_orden
    union
    select 'EFCMP', 0,0 codsolot, s.codef ef,0 idmat,0 codeta, (select descripcion from ETAPA E where e.codeta = s.codeta) deseta, s.punto, s.orden,s.ordencmp ordencmp, trim(s.codtipequ) equmat,  
    a.cod_sap cod_sap, a.desmat,s.cantidad cantidad,s.costo costo,a.moneda_id,a.codund codund,(select c.sblmon from CTBTABMON c 
    where c.moneda_id = a.moneda_id) mon_des,(select d.desund from ALMUNIMED d where d.codund = a.codund) und_des 
    from efptoequcmp s,tipequ t, almtabmat a 
    where s.tipequ = t.tipequ and t.codtipequ = a.codmat(+) and (s.idspcab is null or s.idspcab = 0)  
    and s.codef=an_codef and 'EFCMP' = av_tipo and punto = an_punto and orden = an_orden and ordencmp = an_ordencmp_idmat;

  begin
    --Inicio 2.0
    select cod_sap,desmat,moneda_id,codund into v_cod_sap , v_desmat,n_moneda_id,v_codund
    from almtabmat where trim(codmat) = trim(av_codmat);
    select nvl(max(linea),0) + 10 into n_linea from OPERACION.ope_sp_mat_equ_det
    where idspcab=an_idspcab;
    for c_c in cur_carga loop
      insert into OPERACION.ope_sp_mat_equ_det
      (IDSPCAB,SOT,EF, CODMAT, DESCRIPCION, CANTIDAD, PRECIO_UNI,MONEDA_ID,
      CODUND,linea,identifica_sp,cod_sap)
      values(an_idspcab,an_codsolot,an_codef, av_codmat, v_desmat, c_c.cantidad, 
      c_c.costo,n_moneda_id,v_codund,n_linea,1,v_cod_sap);
      if av_tipo = 'SOTMAT' then
        update solotptoetamat set idspcab = an_idspcab
        where idmat = c_c.idmat;
      elsif av_tipo = 'SOTEQU' then
        update solotptoequ set idspcab = an_idspcab
        where codsolot = c_c.codsolot and punto= c_c.punto and orden = c_c.orden;
      elsif av_tipo = 'SOTCMP' then
        update solotptoequcmp set idspcab = an_idspcab
        where CODSOLOT=  c_c.codsolot and punto= c_c.punto and orden = c_c.orden and ORDENCMP = c_c.ordencmp;
      elsif av_tipo = 'EFMAT' then
        update efptoetamat set idspcab = an_idspcab
        where CODEF = c_c.ef and PUNTO =c_c.punto and CODETA =c_c.codeta and CODMAT =c_c.equmat;
      elsif av_tipo = 'EFEQU' then
        update efptoequ set idspcab = an_idspcab
        where CODEF =c_c.ef and PUNTO =c_c.punto and ORDEN=c_c.orden;
      elsif av_tipo = 'EFCMP' then
        update efptoequcmp set idspcab = an_idspcab
        where CODEF =c_c.ef and PUNTO =c_c.punto and ORDEN=c_c.orden and ORDENCMP=c_c.ordencmp;
      end if;    
    end loop;
    --Fin 2.0

  end p_inserta_sol_ped_det;

  procedure p_inserta_sol_ped_det(
                                  L_IDSPCAB  NUMBER,
                                  L_SOT NUMBER,
                                  L_EF NUMBER,
                                  L_IDENTIFICA_SP  NUMBER,
                                  L_COD_SAP  CHAR,
                                  L_LINEA  NUMBER,
                                  L_PEDIDO  NUMBER,
                                  L_CONTRATA  VARCHAR2,
                                  L_CODMAT  CHAR,
                                  L_CANTIDAD  NUMBER,
                                  L_IMPUTACION  VARCHAR2,
                                  L_VALOR_INPUT  NUMBER,
                                  L_PRECIO_UNI  NUMBER,
                                  L_OBSERVACION1  VARCHAR2,
                                  L_OBSERVACION2  VARCHAR2,
                                  L_FEC_INGRESO  DATE,
                                  L_FEC_ENTREGA  DATE,
                                  L_FEC_GEN_SP  DATE,
                                  L_FEC_APR_SP  DATE,
                                  L_EST_APR_SP  NUMBER,
                                  L_NRO_SOLPED  NUMBER,
                                  L_NRO_PEDIDO  NUMBER,
                                  L_FEC_GEN_PC  DATE,
                                  L_FEC_APR_PC  DATE,
                                  L_EST_APR_PC  NUMBER,
                                  L_FEC_ENVIO  DATE,
                                  L_DESCRIPCION  VARCHAR2,
                                  L_MONEDA_ID  NUMBER,
                                  L_CODUND  string,
                                  o_mensaje2   OUT varchar2,
                                  o_resultado2 OUT number,
                                  l_tecnologia VARCHAR2,  -- 3.0
                                  l_cod_sitio VARCHAR2,   -- 3.0
                                  l_name_sitio VARCHAR2) is  -- 3.0
  begin
    insert into OPERACION.ope_sp_mat_equ_det
      (
IDSPCAB,
SOT,
EF,
IDENTIFICA_SP,
COD_SAP,
LINEA,
PEDIDO,
CONTRATA,
CODMAT,
CANTIDAD,
IMPUTACION,
PRECIO_UNI,
OBSERVACION1,
OBSERVACION2,
FEC_INGRESO,
FEC_ENTREGA,
FEC_GEN_SP,
FEC_APR_SP,
EST_APR_SP,
NRO_SOLPED,
NRO_PEDIDO,
FEC_GEN_PC,
FEC_APR_PC,
EST_APR_PC,
FEC_ENVIO,
DESCRIPCION,
MONEDA_ID,
CODUND,
id_tecnologia,   -- 3.0
id_cod_sitio,    -- 3.0 
name_sitio       -- 3.0
      )
    values
      (
L_IDSPCAB,
L_SOT,
L_EF,
L_IDENTIFICA_SP,
L_COD_SAP,
L_LINEA,
L_PEDIDO,
L_CONTRATA,
L_CODMAT,
L_CANTIDAD,
L_IMPUTACION,
L_PRECIO_UNI,
L_OBSERVACION1,
L_OBSERVACION2,
L_FEC_INGRESO,
L_FEC_ENTREGA,
L_FEC_GEN_SP,
L_FEC_APR_SP,
L_EST_APR_SP,
L_NRO_SOLPED,
L_NRO_PEDIDO,
L_FEC_GEN_PC,
L_FEC_APR_PC,
L_EST_APR_PC,
L_FEC_ENVIO,
L_DESCRIPCION,
L_MONEDA_ID,
L_CODUND,
l_tecnologia,   -- 3.0
l_cod_sitio,    -- 3.0
l_name_sitio    -- 3.0
      );
    o_mensaje2   := 'OK';
    o_resultado2 := 0;
  exception
    when others then
      o_mensaje2   := 'Error al insertar Detalle : ' || sqlerrm;
      o_resultado2 := -1;
  end p_inserta_sol_ped_det;

  procedure p_importar_sol_ped(ac_resultado out varchar2,
                                ac_mensaje out varchar2) is

  ln_moneda_id ctbtabmon.moneda_id%type;
  lc_codund almunimed.codund%type;
  ln_area areaope.area%type;
  ln_num_grupo number;
  ln_num_centro number;
  ln_num_almacen number;
  ln_num_usuario number;
  ln_num_area number;
  ln_nro_solped number;
  ln_num_codsap number;
  ln_num_codmat number;
  ln_preuni number;
  lc_codsap ope_sp_mat_equ_det.cod_sap%type;
  ln_linea ope_sp_mat_equ_det.linea%type;
  lc_grupo ope_sp_mat_equ_det.grupo%type;
  lc_centro ope_sp_mat_equ_det.centro%type;
  lc_almacen ope_sp_mat_equ_det.almacen%type;
  ld_fec_entrega date;
  ln_cantidad ope_sp_mat_equ_det.cantidad%type;
  lc_imputacion opedd.descripcion%type;
  ln_imputacion varchar2(2);
  error_validacion exception;
  lc_mensaje varchar2(500);
  lc_usuario usuarioope.usuario%type;
  lc_codmat almtabmat.codmat%type;
  ln_idspcab ope_sp_mat_equ_cab.idspcab%type;

  cursor cur_ped_cab is
    select distinct a.descripcion_cab,
           a.texto_complementario,
           a.area_solicitante,
           a.solicitante
     from operacion.ope_sp_mat_equ_tmp a
    where flg_procesado = 0
    order by a.descripcion_cab,a.texto_complementario;

  cursor cur_ped_det(ac_des_cab varchar2, ac_texto varchar2) is
    select a.idsptmp,
           a.nro_solped,
           a.linea,
           a.descripcion_det,
           a.cod_sap,
           a.imputacion,
           a.cantidad,
           a.abrund,
           a.fec_entrega,
           a.precio_uni,
           a.moneda,
           a.observacion1,
           grupo,
           centro,
           almacen
     from operacion.ope_sp_mat_equ_tmp a
    where flg_procesado = 0
    and a.descripcion_cab = ac_des_cab
    and a.texto_complementario = ac_texto;

  begin
    ac_resultado := 'OK';
    ac_mensaje := null;

    for reg_ped_cab in cur_ped_cab loop


      --validando usuario
      if reg_ped_cab.solicitante is not null then
        select count(1) into ln_num_usuario
        from usuarioope
        where usuario = upper(reg_ped_cab.solicitante);

        if ln_num_usuario = 1 then
          lc_usuario := upper(reg_ped_cab.solicitante);
        else
          lc_mensaje := 'El usuario: '||upper(reg_ped_cab.solicitante) || ' ,no existe en el sistema.';
          raise error_validacion;
        end if;
      else
        lc_usuario := null;
      end if;

      --validando el area
      begin
        if reg_ped_cab.area_solicitante is not null then
          ln_area := to_number(reg_ped_cab.area_solicitante);

          select count(1) into ln_num_area
          from areaope
          where area = ln_area;

          if ln_num_area = 0 then
            lc_mensaje := 'El area:' ||reg_ped_cab.area_solicitante ||', no existe en el sistema.';
            raise error_validacion;
          end if;
        else
          ln_area := null;
        end if;
      exception
        when others then
          lc_mensaje := 'El area:' ||reg_ped_cab.area_solicitante ||', no se pudo procesar, debe ser numérico.';
          raise error_validacion;
      end;

      insert into ope_sp_mat_equ_cab(
             descripcion,
             texto_complementario,
             solicitante,
             area_solicitante
      )values(reg_ped_cab.descripcion_cab,
             reg_ped_cab.texto_complementario,
             lc_usuario,
             ln_area --confirmar si es codigo o descripcion
      ) returning idspcab into ln_idspcab;

      for reg_ped_det in cur_ped_det(reg_ped_cab.descripcion_cab,
                                    reg_ped_cab.texto_complementario) loop
       --validando el grupo
      begin
        if reg_ped_det.grupo is not  null then
          select length(reg_ped_det.grupo) into ln_num_grupo from dummy_ope;
          if ln_num_grupo <= 10 then
            lc_grupo := upper(reg_ped_det.grupo);
          else
            lc_mensaje := 'La longitud del grupo debe ser menor o igual a 10';
            raise error_validacion;
          end if;
        else
          lc_grupo := null;
        end if;
      exception
        when others then
          lc_mensaje := 'El grupo:' ||reg_ped_det.grupo ||', no se pudo procesar.';
          raise error_validacion;
      end;

      --validando el centro
      begin
        if reg_ped_det.centro is not null then
          select length(reg_ped_det.centro) into ln_num_centro from dummy_ope;
          if ln_num_centro <= 4 then
            lc_centro := upper(reg_ped_det.centro);
          else
            lc_mensaje := 'La longitud del centro debe ser menor o igual a 4';
            raise error_validacion;
          end if;
        else
          lc_centro := null;
        end if;
      exception
        when others then
          lc_mensaje := 'El centro:' ||reg_ped_det.centro||', no se pudo procesar.';
          raise error_validacion;
      end;

      --validando el almacen
      begin
        if reg_ped_det.almacen is not null then
          select length(reg_ped_det.almacen) into ln_num_almacen from dummy_ope;
          if ln_num_almacen <= 4 then
            lc_almacen := upper(reg_ped_det.almacen);
          else
            lc_mensaje := 'La longitud del almacen debe ser menor o igual a 10';
            raise error_validacion;
          end if;
        else
          lc_almacen := null;
        end if;
      exception
        when others then
          lc_mensaje := 'El almacen:' ||reg_ped_det.almacen||', no se pudo procesar.';
          raise error_validacion;
      end;
        --validando la unidad
        begin
          select codund  into lc_codund
          from almunimed where upper(abrund) = upper(reg_ped_det.abrund);
        exception
          when others then
            lc_codund := null;
        end;
        --validando la moneda
        begin
          select moneda_id into ln_moneda_id
          from ctbtabmon where codmon = reg_ped_det.moneda;
        exception
          when others then
            ln_moneda_id := null;
        end;

        --validando nro sol ped
        begin
          ln_nro_solped := to_number(reg_ped_det.nro_solped);
        exception
          when others then
            lc_mensaje := 'El Nro.Sol.Ped.:' ||reg_ped_det.nro_solped ||', no se pudo procesar, debe ser numérico.';
            raise error_validacion;
        end;

        --validando linea
        begin
          if reg_ped_det.linea is not null then
             ln_linea := to_number(reg_ped_det.linea);
          else
             ln_linea := null;
          end if;
        exception
          when others then
            lc_mensaje := 'La linea:' ||reg_ped_det.linea ||', no se pudo procesar, debe ser numérico.';
            raise error_validacion;
        end;

        --validando codigo sap
        begin
          if reg_ped_det.cod_sap is not null then
            select length(reg_ped_det.cod_sap) into ln_num_codsap from dummy_ope;
            if ln_num_codsap <= 18 then
              lc_codsap := upper(reg_ped_det.cod_sap);

              select count(1) into ln_num_codmat
              from almtabmat
              where upper(trim(cod_sap)) = lc_codsap
              and estado = 'ACT';

              if ln_num_codmat = 0 then
                lc_mensaje := 'El material:' ||lc_codsap || ', no se encuentra en el maestro de materiales.';
                raise error_validacion;
              else
                select min(codmat) into lc_codmat
                from almtabmat
                where upper(trim(cod_sap)) = lc_codsap
                and estado = 'ACT';
              end if;
            else
              lc_mensaje := 'La longitud del codigo de material debe ser menor o igual a 18';
              raise error_validacion;
            end if;
          else
            lc_codmat := null;
            lc_codsap := null;
          end if;
        exception
          when others then
            lc_mensaje := 'El codigo de material:' ||reg_ped_det.cod_sap ||', no se pudo procesar.';
            raise error_validacion;
        end;

        --validando cantidad
        begin
          if reg_ped_det.cantidad is not null then
             ln_cantidad := to_number(reg_ped_det.cantidad);
          else
             ln_cantidad := null;
          end if;
        exception
          when others then
            lc_mensaje := 'La cantidad:' ||reg_ped_det.cantidad ||', no se pudo procesar, debe ser numérico.';
            raise error_validacion;
        end;

        --validando fecha de entrega
        begin
          if reg_ped_det.fec_entrega is not null then
             ld_fec_entrega := to_date(reg_ped_det.fec_entrega,'dd/mm/yyyy HH24:MI:SS');
          else
             ld_fec_entrega := null;
          end if;
        exception
          when others then
            lc_mensaje := 'La fecha de entrega:' ||reg_ped_det.fec_entrega ||', no se pudo procesar, el formato debe ser dd/mm/yyyy';
            raise error_validacion;
        end;

        --validando precio unitario
        begin
          if reg_ped_det.precio_uni is not null then
             ln_preuni := to_number(reg_ped_det.precio_uni);
          else
             ln_preuni := null;
          end if;
        exception
          when others then
            lc_mensaje := 'El precio unitario:' ||reg_ped_det.precio_uni ||', no se pudo procesar, debe ser numérico.';
            raise error_validacion;
        end;

        --validando imputacion
        begin
          if reg_ped_det.imputacion is not null then
             lc_imputacion := reg_ped_det.imputacion;
             select codigoc into ln_imputacion
             from opedd a, tipopedd b
             where a.tipopedd = b.tipopedd
             and b.abrev = 'SOL_PED_IMPUT'
             and upper(a.descripcion) = upper(lc_imputacion);
          else
             ln_imputacion := null;
          end if;
        exception
          when others then
            lc_mensaje := 'La imputación:' ||reg_ped_det.imputacion ||', no se pudo procesar.';
            raise error_validacion;
        end;

        insert into ope_sp_mat_equ_det(
               idspcab,
               nro_solped,
               linea,
               codmat,
               cod_sap,
               imputacion,
               cantidad,
               codund,
               fec_entrega,
               precio_uni,
               moneda_id,
               observacion1,
               observacion2,
               grupo,
               centro,
               almacen
        )values(ln_idspcab,
               ln_nro_solped,
               ln_linea,
               lc_codmat,
               lc_codsap,
               ln_imputacion,
               ln_cantidad,
               lc_codund,
               ld_fec_entrega,
               ln_preuni,
               ln_moneda_id,
               reg_ped_det.observacion1,
               reg_ped_det.descripcion_det,
               lc_grupo,
               lc_centro,
               lc_almacen
        );

        update operacion.ope_sp_mat_equ_tmp
        set flg_procesado = 1
        where idsptmp = reg_ped_det.idsptmp;

      end loop;
    end loop;

    delete from operacion.ope_sp_mat_equ_tmp;

  exception
    when error_validacion then
      rollback;
      delete from operacion.ope_sp_mat_equ_tmp;
      commit;
      ac_resultado := 'ERROR';
      ac_mensaje := lc_mensaje;
    when others then
      rollback;
      delete from operacion.ope_sp_mat_equ_tmp;
      commit;
      ac_resultado := 'ERROR';
      ac_mensaje := sqlerrm;
  end;

   procedure p_inserta_sol_ped_det_imp(l_IDSPDET in  NUMBER,
                                  l_IDSPCAB in NUMBER,
                                  v_ele_pep  in  VARCHAR2,
                                  v_cod_cen_costo in  VARCHAR2,
                                  v_nro_activo in  VARCHAR2,
                                  v_cuenta_mayor in  VARCHAR2,
                                  v_concepto_capex in  VARCHAR2,
                                  v_nro_orden in  VARCHAR2,
                                  v_cen_costo in  VARCHAR2,
                                  o_mensaje2   OUT varchar2,
                                  o_resultado2 OUT number) is
  begin
    insert into  OPERACION.OPE_SP_MAT_EQU_DET_IMP(IDSPDET,IDSPCAB,ele_pep,COD_CEN_COSTO,NRO_ACTIVO,CUENTA_MAYOR,CONCEPTO_CAPEX,NRO_ORDEN,CEN_COSTO)
    values
      (l_IDSPDET,l_IDSPCAB, v_ele_pep,v_cod_cen_costo,v_nro_activo,v_cuenta_mayor,v_concepto_capex,v_nro_orden,v_cen_costo);
    o_mensaje2   := 'OK';
    o_resultado2 := 0;
  exception
    when others then
      o_mensaje2   := 'Error al insertar el Valor input 2 : ' || sqlerrm;
      o_resultado2 := -1;
  end p_inserta_sol_ped_det_imp;

  procedure p_insertar_valor_input( l_IDSPDET in  NUMBER,
                                  l_IDSPCAB in NUMBER,
                                  v_imputacion in  VARCHAR2,
                                  v_ele_pep  in  VARCHAR2,
                                  v_cod_cen_costo in  VARCHAR2,
                                  v_nro_activo in  VARCHAR2,
                                  v_cuenta_mayor in  VARCHAR2,
                                  v_concepto_capex in  VARCHAR2,
                                  v_nro_orden in  VARCHAR2,
                                  v_cen_costo in  VARCHAR2,
                                    o_mensaje2   OUT varchar2,
                                  o_resultado2 OUT number) is
  ll_count int;

  begin

       if nvl(v_imputacion,'0') = '0' then -- Almacen
          select count(*) into ll_count
          from  OPERACION.OPE_SP_MAT_EQU_DET_IMP
          where idspdet = l_IDSPDET and idspcab = l_IDSPCAB;
          if ll_count > 0 then
             update OPERACION.OPE_SP_MAT_EQU_DET_IMP
             set ele_pep = '', cod_cen_costo = '', nro_activo = '',
                 cuenta_mayor = '', concepto_capex = '', nro_orden = '',
                 cen_costo = ''
             where idspdet = l_IDSPDET and idspcab = l_IDSPCAB;
          end if;
        elsif v_imputacion = 'P' then
          select count(*) into ll_count
          from  OPERACION.OPE_SP_MAT_EQU_DET_IMP
          where idspdet = l_IDSPDET and idspcab = l_IDSPCAB;
          if ll_count > 0 then
             update OPERACION.OPE_SP_MAT_EQU_DET_IMP
             set ele_pep = v_ele_pep , cod_cen_costo = '', nro_activo = '',
                 cuenta_mayor = '', concepto_capex = v_concepto_capex, nro_orden = '',
                 cen_costo = ''
             where idspdet = l_IDSPDET and idspcab = l_IDSPCAB;
          end if;
        elsif v_imputacion = 'K' then
          select count(*) into ll_count
          from  OPERACION.OPE_SP_MAT_EQU_DET_IMP
          where idspdet = l_IDSPDET and idspcab = l_IDSPCAB;
          if ll_count > 0 then
             update OPERACION.OPE_SP_MAT_EQU_DET_IMP
             set ele_pep = '' , cod_cen_costo = v_cod_cen_costo, nro_activo = '',
                 cuenta_mayor = v_cuenta_mayor, concepto_capex = '', nro_orden = '',
                 cen_costo = ''
             where idspdet = l_IDSPDET and idspcab = l_IDSPCAB;
          end if;
        elsif v_imputacion = 'A' then
          select count(*) into ll_count
          from  OPERACION.OPE_SP_MAT_EQU_DET_IMP
          where idspdet = l_IDSPDET and idspcab = l_IDSPCAB;
          if ll_count > 0 then
             update OPERACION.OPE_SP_MAT_EQU_DET_IMP
             set ele_pep = '' , cod_cen_costo = '', nro_activo = v_nro_activo,
                 cuenta_mayor = v_cuenta_mayor, concepto_capex = '', nro_orden = v_nro_orden,
                 cen_costo = v_cen_costo
             where idspdet = l_IDSPDET and idspcab = l_IDSPCAB;
          end if;
         end if;
  exception
    when others then
      o_mensaje2   := 'Error al insertar el Valor input 1 : ' || sqlerrm;
      o_resultado2 := -1;
  end p_insertar_valor_input;

  function f_retorna_permiso_ele_pep(vi_codigog in varchar2)
  return int is
  Result int;
  vv_codigog varchar2(2);
  begin

      vv_codigog:= nvl(vi_codigog,'T');

      Result := 0;
      IF vv_codigog = 'T' then
         Result := 1;
      elsif vv_codigog = 'P' then
         Result := 0;
      elsif vv_codigog = 'K' then
         Result := 1;
      elsif vv_codigog = 'A' then
         Result := 1;
      end if;

    return(Result);

  end f_retorna_permiso_ele_pep;

  function f_retorna_permiso_con_cap(vi_codigog in varchar2)
  return int is
  Result int;
  vv_codigog varchar2(2);
  begin
      vv_codigog:= nvl(vi_codigog,'T');
      Result := 0;
      IF vv_codigog = 'T' then
         Result := 1;
      elsif vv_codigog = 'P' then
         Result := 0;
      elsif vv_codigog = 'K' then
         Result := 1;
      elsif vv_codigog = 'A' then
         Result := 1;
      end if;

    return(Result);

  end f_retorna_permiso_con_cap;

  function f_retorna_permiso_CCC(vi_codigog in varchar2)
  return int is
  Result int;
  vv_codigog varchar2(2) ;
  begin
      vv_codigog:= nvl(vi_codigog,'T');
      Result := 0;
      IF vv_codigog = 'T' then
         Result := 1;
      elsif vv_codigog = 'P' then
         Result := 1;
      elsif vv_codigog = 'K' then
         Result := 0;
      elsif vv_codigog = 'A' then
         Result := 1;
      end if;

    return(Result);

  end f_retorna_permiso_CCC;

  function f_retorna_permiso_CM(vi_codigog in varchar2)
  return int is
  Result int;
  vv_codigog varchar2(2);
  begin
     vv_codigog:= nvl(vi_codigog,'T');
      Result := 0;
      IF vv_codigog = 'T' then
         Result := 1;
      elsif vv_codigog = 'P' then
         Result := 1;
      elsif vv_codigog = 'K' then
         Result := 0;
      elsif vv_codigog = 'A' then
         Result := 0;
      end if;

    return(Result);

  end f_retorna_permiso_CM;

    function f_retorna_permiso_NAC(vi_codigog in varchar2)
  return int is
  Result int;
  vv_codigog varchar2(2);
  begin
      Result := 0;

      vv_codigog:= nvl(vi_codigog,'T');
      IF vv_codigog = 'T' then
         Result := 1;
      elsif vv_codigog = 'P' then
         Result := 1;
      elsif vv_codigog = 'K' then
         Result := 1;
      elsif vv_codigog = 'A' then
         Result := 0;
      end if;

    return(Result);

  end f_retorna_permiso_NAC;

      function f_retorna_permiso_NOR(vi_codigog in varchar2)
  return int is
  Result int;
  vv_codigog varchar2(2);
  begin
      Result := 0;
      vv_codigog:= nvl(vi_codigog,'T');
      IF vv_codigog = 'T' then
         Result := 1;
      elsif vv_codigog = 'P' then
         Result := 1;
      elsif vv_codigog = 'K' then
         Result := 1;
      elsif vv_codigog = 'A' then
         Result := 0;
      end if;

    return(Result);

  end f_retorna_permiso_NOR;

  function f_retorna_permiso_CC(vi_codigog in varchar2)
  return int is
  Result int;
  vv_codigog varchar2(2);
  begin
      Result := 0;
      vv_codigog:= nvl(vi_codigog,'T');
      IF vv_codigog = 'T' then
         Result := 1;
      elsif vv_codigog = 'P' then
         Result := 1;
      elsif vv_codigog = 'K' then
         Result := 1;
      elsif vv_codigog = 'A' then
         Result := 0;
      end if;

    return(Result);

  end f_retorna_permiso_CC;
  -- Ini 4.0
  procedure sgasi_actualiza_estado_UBID (p_idrequisicion operacion.ope_sp_mat_equ_cab.idspcab%type,
                                         o_mensaje2   OUT varchar2,
                                         o_resultado2 OUT number) is   
   
    v_estados_final  varchar2(100);
    v_total_registros  number;
    v_estado_cab operacion.ope_sp_mat_equ_cab.estado%type;  
    n_obs number;
    error_validacion exception;
    n_tipo        number ;  -- 5.0  140119
	n_estado      number ;  -- 5.0  140119
    cursor cur_detalle is
       select ubitecnica, id_sitio
         from operacion.ope_sp_mat_equ_det
        where idspcab = p_idrequisicion
          and flg_sinergia = 'S';
    begin
      select count(1) into v_total_registros 
      from operacion.ope_sp_mat_equ_det
        where idspcab = p_idrequisicion
          and flg_sinergia = 'S'
          group by idspcab;
      if v_total_registros>0 then   
         select LPad('0', v_total_registros, '0') into v_estados_final from dual;
           for reg_ped_det in cur_detalle loop
             if reg_ped_det.Ubitecnica is null or length(reg_ped_det.Ubitecnica)=0 then
                select '2'||v_estados_final 
                into v_estados_final from dual;             
             else
               select count(1) into n_obs 
               from operacion.ubi_tecnica 
               where trim(abrev) = trim(reg_ped_det.Ubitecnica) 
               and ubitv_estado = '2';
               if n_obs>0 then  --- Existe UT Estado Observado
                 select '3'||v_estados_final
                  into v_estados_final from dual;
               else
                 if reg_ped_det.id_sitio is null or length(reg_ped_det.id_sitio)=0 then
                    select '1'||v_estados_final
                      into v_estados_final from dual;                               
                 end if;
               end if;
             end if;
           end loop;
      end if;
      
      --INI 5.0 140119 
      select tipo, estado
        into n_tipo, n_estado
        from operacion.ope_sp_mat_equ_cab c
       where c.idspcab = p_idrequisicion;
      --FIN 5.0 140119 
      if nvl(n_tipo,0) = 0 then   --140119      
        if Instrb(v_estados_final, '2', 1, 1)>0 then
              v_estado_cab := 1;
        else
          if Instrb(v_estados_final, '3', 1, 1)>0 then
            v_estado_cab :=9;
          else
            if Instrb(v_estados_final, '1', 1, 1)>0 then
              v_estado_cab :=8;
            else
              v_estado_cab :=1;
            end if;
          end if;
        end if;
      else --INI 5.0 140119
        -- Si es en movil mantiene su mismo estado 
          v_estado_cab:= n_estado;
      end if;--FIN 5.0 140119
      update operacion.ope_sp_mat_equ_cab cab set cab.estado = v_estado_cab 
       where cab.idspcab = p_idrequisicion;
       o_resultado2 :=1;
    exception
      when others then
        o_resultado2 := -1;
        o_mensaje2   := 'Error sgasi_actualiza_estado_UBID: ' || sqlerrm;
        raise error_validacion;        
  end sgasi_actualiza_estado_UBID;  
  -- fin 4.0
end pq_solicitud_pedido;
/
