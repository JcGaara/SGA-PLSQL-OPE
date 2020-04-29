create or replace package body operacion.pq_sinergia as
  /************************************************************
  NOMBRE:     OPERACION.PQ_SINERGIA
  PROPOSITO:  Creacion de definicion de proyectos en SAP
  Ver        Fecha        Autor             Descripción
  ---------  ----------  ---------------    ------------------------
  1.0        19.10.2014  Edilberto Astulle    Versión Inicial
  2.0        12.10.2015  Edilberto Astulle    SD-479472 INTERFASE SGA SAP
  3.0        05.11.2015  Edilberto Astulle    SD_480010 PROBLEMAS PARA CARGAR SERIES EN SGA
  4.0        25.11.2015  Edilberto Astulle    SD-556907
  5.0        07.12.2015  Edilberto Astulle    SD-568127
  6.0        13.01.2016  Miriam Mandujano     SD_633408 SINERGIA
  7.0        21.01.2016  Edilberto Astulle    SD_647240 SINERGIA
  8.0        17.02.2016  Edilberto Astulle    SD_642482 Incidencia Materiales
  9.0        29.02.2016  Edilberto Astulle    SD_652049 SINERGIA
  10.0       05.04.2016  Edilberto Astulle    SD_868970
  11.0       01.12.2016  Elias Figueroa M     SD_1011844
  12.0       20.12.2016  Aldo Salazar        SD_1046828
  13.0       21.02.2017  Servicio Fallas      HITSS INC000000664117
  14.0       06.02.2017  Victor Cordero        PROY-18167 Descarga Automática SAP
  15.0       19.04.2017  Servicio Fallas      HITSS INC000000763861 Problemas con la generacion de PEPs
  16.0       12.06.2017  Felipe Maguiña       PROY-29358 Módulo de Requisiciones Red Móvil
  17.0       18.09.2017  Jorge Rivas          FALLA.PROY-29358.INC000000918920
  20.00      14/12/2018  Cesar Rengifo        PROY140119 IDEA140191-Desarrollo del modulo de requisiciones del SGA
  21.0       24.01.2019  Steve Panduro        FTTH
  22.0       01.02.2019  Gino Gutierrez       PROY-40032 Adaptaciones Legados TI para Procesos para obtención del PEP
  23.0       20.02.2019  LQ                   Adaptacion de Proceso para INT-43
  24.0       24.01.2019  Steve Panduro        FTTH - FUS - HUS
  25.0       15.04.2019  Alvaro Peña          FTTH - validación tipo proyecto
  26.0       31.08.2019  Edilberto Astulle    Descarga de Materiales
  27.0       31.08.2019  Edilberto Astulle    Descarga de Materiales
  28.0       06.10.2019  Edilberto Astulle    Descarga de Materiales
  29.0       06.10.2019  Edilberto Astulle    Descarga de Materiales
  30.0       18.10.2019  Edilberto Astulle    Descarga de Materiales
  31.0       04.11.2019  Edilberto Astulle    Descarga de Materiales
  32.0       12.11.2019  Edilberto Astulle    Descarga de Materiales
  33.0       12.11.2019  Edilberto Astulle    Descarga de Materiales
  34.0       28.11.2019  Edilberto Astulle    Descarga de Materiales  
  ***********************************************************/
procedure p_crea_ubi_tecnica(an_codsolot in number,an_id_ubitecnica out number)
IS
n_location_id number;
v_soc_fi char(4);
v_ubitec varchar2(50);
v_error varchar2(400);
v_tiproy operacion.tiproy_sinergia.tiproy%type;
v_pais operacion.tiproy_sinergia.pais%type;
v_tipoubitec operacion.tiproy_sinergia.tipoubitec%type;
n_error number;
err EXCEPTION;
v_nivel2 vtatabdst.region_sap%type;
v_nivel3 vtatabdst.nivel3%type;
v_claseproy operacion.tiproy_sinergia.claseproy%type;
n_pop number;
v_desc_pop ubired.descripcion%type;
n_cid number;
v_agrupador varchar2(3) default '001';
v_agrup1 varchar2(30);
v_tipo operacion.ubi_tecnica.tipo%type default 'I';
v_descripcion operacion.ubi_tecnica.descripcion%type default 'I';
v_id_hub_sap varchar2(10);
v_nivel6 varchar2(10);
v_ubitec_hub varchar2(20);--2.0
--3.0 Inicio
v_ubitec6 varchar2(50);
v_rpta_niv6 varchar2(50);
v_flag_instal_auto varchar2(50) default 'X';
v_distrito vtatabdst.nomdst%type;
n_err number;
v_err varchar2(400);
v_ubitec_corp operacion.ubi_tecnica.abrev%type;
--3.0 Fin

n_tipo_sga operacion.ubi_tecnica.tipo_sga%type;
cursor c_ubitec is--POPs y Planos
  select distinct nvl(b.codubi,a.codubi) codubi,c.codsuc,0 cid,d.nomsuc,nvl(d.dirsuc,b.direccion) direccion, --Clientes
  a.numslc,a.codcli,0 sid,'' numero, 'C' ubicacion, nvl(f.tiproy, 'AFO') tiproy,'' idplano, '' hub,0 idhub, null pop,g.nomcli
  from solot a,solotpto b ,inssrv c,vtasuccli d, vtatabslcfac e, tystipsrv f,vtatabcli g
  where a.codsolot=b.codsolot and b.codinssrv=c.codinssrv and c.codsuc=d.codsuc(+) and e.tipsrv=f.tipsrv
  and a.numslc=e.numslc and e.tipo<>5 and a.codsolot=an_codsolot and a.codcli=g.codcli
  union
  select nvl(b.codubi,a.codubi) codubi,'' codsuc,0 cid,a.descripcion,b.direccion,
  b.numslc,b.codcli,0 codinssrv,'' numero, 'I' ubicacion, tiproy, replace(replace(a.idplano,'Ñ','N'),'-','_') idplano, d.abrevhub hub,
  c.idhub,  null pop,e.nomcli--Planos
  from vtatabgeoref a, solot b, VTATABSLCFAC C, OPE_HUB d,vtatabcli e
  where B.NUMSLC=C.NUMSLC AND C.IDPLANO=A.IDPLANO(+) and a.idhub=d.idhub(+)
  and c.tipo=5 and b.codsolot=an_codsolot and b.codcli=e.codcli;
Begin
  an_id_ubitecnica:=0;
  Begin
    n_location_id :=0;
    for r_ubitec in c_ubitec loop

      v_tiproy:=r_ubitec.tiproy;
      begin
        select region_sap,nivel3,nomdst into v_nivel2,v_nivel3,v_distrito
        from vtatabdst where codubi=r_ubitec.codubi;
      Exception
        when no_data_found then
          v_error:='No se tiene asociado nivel2 y nivel 3 para el Ubigeo : ' || r_ubitec.codubi;
      end;
      if v_tiproy is null then
        v_error := 'Crear Ubicación_Tecnica: El tipo de Proyecto SAP es Nulo.';
        RAISE err;
      end if;
      select a.pais,a.tipoubitec,a.claseproy,a.soc_fi into v_pais,v_tipoubitec,v_claseproy,v_soc_fi
      from operacion.tiproy_sinergia a
      where a.tiproy= v_tiproy;

      if v_claseproy ='F' then--Infraestructura Red Fija NO APLICA todo se hace por carga masiva
        null;
      end if;

      if v_claseproy='K' then--Corporativo
        n_tipo_sga:=4;
        v_flag_instal_auto:='';
        v_descripcion:=substr(r_ubitec.nomsuc ||'-'||r_ubitec.nomcli,1,40) ;
        select count(1) into n_location_id from operacion.ubi_tecnica
        where codsuc = r_ubitec.codsuc and procesado='S';--validar si la sucursal ya esta registrado
        if n_location_id=0 then --no exite la ubicacion tecnica para la sucursal
          if r_ubitec.codsuc is null then
            v_error:='El Codigo de Sucursal es Nulo.';
            raise err;
          end if;
          if r_ubitec.cid is null then
            v_error:='La SOT no tiene asociado un CID Valido : ' || to_char(n_cid);
            raise err;
          end if;
          begin--Seleccionar el POP asociado
            n_pop:=r_ubitec.pop;
            if n_pop is null then
              select distinct e.abrev,e.descripcion into v_ubitec_corp,v_desc_pop
              from solotpto a, solot b,inssrv c, vtatabdst d,operacion.ubi_tecnica e
              where a.codsolot=b.codsolot and a.codinssrv=c.codinssrv and c.codubi=d.codubi
              and 'PE-'||d.region_sap||'-'||d.nivel3||'-CLI-EM'=e.abrev
              and b.codsolot=an_codsolot and rownum=1;
            end if;
          Exception
            when no_data_found then
              v_error:='La SOT no tiene asociado una UT Valida para el distrito : ' || to_char(an_codsolot);
          end;
          select f_Convertbase26(r_ubitec.codcli, 5) into v_nivel6 from dual;
          if v_ubitec_corp is null then
            begin
              null;
            Exception
              when no_data_found then
                v_error:='La Sucursal no tiene asociado una UT Corporativo : ' || v_desc_pop;
                raise err;
            end;
          else
            v_ubitec:= v_ubitec_corp  ||'-'|| v_nivel6 ||'-'|| substr(r_ubitec.codsuc,2,9);--ubicacion tecnica de corporativo
          end if;
        else
          select id_ubitecnica,abrev into an_id_ubitecnica,v_ubitec from operacion.ubi_tecnica
          where codsuc = r_ubitec.codsuc and procesado='S' and rownum=1;
        end if;
      end if;

      if v_tiproy ='HUS' or v_tiproy ='FUS' then--HFC HUBs --24.0
        n_tipo_sga:=1;
        select count(1) into n_location_id from operacion.ubi_tecnica
        where idhub = r_ubitec.idhub and procesado='S';--validar si el hub ya esta registrado
        if n_location_id=0 then--no existe el hub registrado
          v_agrup1:=v_pais ||'-'|| v_nivel2 ||'-'|| v_nivel3;
          select nvl(lpad(max(to_number(substr(abrev,9,3)))+1,3,'0'),'001') into v_agrupador
          from operacion.ubi_tecnica
          where substr(abrev,1,7)=v_agrup1 and idhub is not null
          and is_number(substr(abrev,9,3))=1;

          select 'RF '|| replace(c.abrevhub,'Ñ','N'),
                   substr(v_tiproy, 0, 1) || '_' || -- 25.0
                    substr(c.abrevhub, 1, 3)
          into v_descripcion,v_id_hub_sap
          from  ope_hub c where c.idhub=r_ubitec.idhub;

          v_ubitec:= v_agrup1 ||'-'|| v_agrupador ||'-'||v_tipoubitec||'-'|| v_id_hub_sap;
        else
          select id_ubitecnica,abrev into an_id_ubitecnica,v_ubitec from operacion.ubi_tecnica
          where idhub = r_ubitec.idhub and procesado='S';
        end if;
      end if;

      if v_tiproy ='PEH' OR v_tiproy ='HFC' OR v_tiproy ='FTN' then--HFC Planos --21.0
        n_tipo_sga:=2;
        v_flag_instal_auto:='';
        select count(1) into n_location_id from operacion.ubi_tecnica
        where idplano = r_ubitec.Idplano and procesado='S';--validar si el plano ya esta registrado
        if n_location_id=0 then--no existe el plano registrado
          if v_tiproy='PEH' OR v_tiproy ='FTN' then --Proyecto de tipo Crear Ubicacion Tecnica Implementar NODO--21.0
            if r_ubitec.hub is null then
              v_error :=  'Crear Ubicación_Tecnica: el Plano : ' || r_ubitec.Idplano || ' No tiene asignado Hub';
              RAISE err;
            end if;
            begin--2.0
              select 'RF '|| B.NOMDEPA || '/'|| B.NOMDST || ' - '|| replace(A.IDPLANO,'Ñ','N'),'H_'|| substr(c.abrevhub,1,3),d.abrev
              into v_descripcion,v_id_hub_sap,v_ubitec_hub
              from  vtatabgeoref A, VTATABDST B,ope_hub c,operacion.ubi_tecnica d
              where replace(replace(a.idplano,'Ñ','N'),'-','_')=r_ubitec.Idplano--7.0
              AND A.CODUBI=B.CODUBI and a.idhub=c.idhub(+) and c.idhub=d.idhub
              and procesado='S';--26.0
            exception
              when others then
                v_descripcion:=null;
            end;
            --Se crear una ubicacion tecnica
            v_agrup1:=v_pais ||'-'|| v_nivel2 ||'-'|| v_nivel3;
            select nvl(lpad(max(to_number(substr(abrev,9,3)))+1,3,'0'),'001') into v_agrupador
            from operacion.ubi_tecnica
            where substr(abrev,1,7)=v_agrup1 and idplano is not null
            and is_number(substr(abrev,9,3))=1;
            v_ubitec:= v_ubitec_hub ||'-'|| r_ubitec.idplano; --2.0
          else --se tiene que identificar la ubicacion tecnica existente
            v_error:= 'No esta registrado el Plano como Ubicación Tecnica.';
            raise err;
          end if;
        else
          if v_tiproy = 'HFC' then --Identificar la ubicacion tecnica
            select 0 into an_id_ubitecnica from operacion.ubi_tecnica
            where idplano = r_ubitec.Idplano and procesado='S';
            v_error:= 'La Ubicación Tecnica para este plano ya existe.';
            raise err;
          elsif v_tiproy ='CHF' then--Proyecto Masivos se identifica la UbiTecnica
            select id_ubitecnica,abrev into an_id_ubitecnica,v_ubitec from operacion.ubi_tecnica
            where idplano = r_ubitec.Idplano and procesado='S';
          else --se generan Proyectos, PEPs pero no se genera ubicacion tecnica
            select id_ubitecnica,abrev into an_id_ubitecnica,v_ubitec from operacion.ubi_tecnica
            where idplano = r_ubitec.Idplano and procesado='S';
          end if;
        end if;
      end if;

      if n_location_id = 0 then
        if v_claseproy='K' then--Validar Corporativo Ubicaciones tecnicas nivel 5 y 6 3.0
          select v_ubitec_corp ||'-'|| v_nivel6  into v_ubitec6 from dual;
          webservice.pq_ws_sinergia.P_CONSULTA_UBITECNICA(v_ubitec6,v_rpta_niv6,n_err,v_err);
          if v_rpta_niv6='N' then
            operacion.pq_sinergia.p_crea_ubitec(v_ubitec6,r_ubitec.nomcli||'-'||v_distrito,null,null,null,11);
          end if;
        end if;

        Select OPERACION.SQ_UBITECNICA.nextval into an_id_ubitecnica From DUMMY_ope;
        insert into OPERACION.UBI_TECNICA(ID_UBITECNICA,tipo,sociedad,Codsolot,Numslc,Abrev,Cid,
        descripcion,GRUPOAUTORIZACIONES,FLAGUBICACIONTECNICA,FLAG_INSTAL_AUTO,MONTAJEEQUIPOS,IDPLANO,CODSUC,CLASEPROY,
        ID_HUB_SAP,tipo_sga,IDHUB)
        values(an_id_ubitecnica,v_tipo,v_soc_fi,an_codsolot,r_ubitec.numslc,substr(v_ubitec,1,30),r_ubitec.cid,
        upper(nvl(v_descripcion,r_ubitec.direccion)),'FJPE','IEUNI',v_flag_instal_auto,'X',r_ubitec.Idplano,
        r_ubitec.Codsuc,v_claseproy,v_id_hub_sap,n_tipo_sga,r_ubitec.idhub);
        if v_tiproy ='HUS' OR v_tiproy ='FUS'then--HUBs --24.0
          update ope_hub set id_ubitecnica=an_id_ubitecnica where idhub=r_ubitec.idhub;
        end if;
        if v_tiproy ='PEH' OR v_tiproy ='FTN' then--Planos --21.0
          update vtatabgeoref set id_ubitecnica=an_id_ubitecnica where idplano=r_ubitec.Idplano;
        end if;

        commit;
        WEBSERVICE.PQ_WS_SINERGIA.P_CREA_UBI_TEC(an_id_ubitecnica,n_error,v_error);
        IF n_error < 0 THEN
          v_error := 'Crear Ubicación_Tecnica: ' || v_error;
          RAISE err;
        else
          p_reg_log('Crear Ubicación_Tecnica:',0,'Se generó UT: ' || v_ubitec,r_ubitec.numslc,an_codsolot,an_id_ubitecnica,null,null);
        END IF;
        --Crear ID SITIO
        p_crea_id_sitio(an_codsolot,an_id_ubitecnica);
      else
        v_error := 'La ubicación Tecnica ya Existe : ' || v_ubitec;
        p_reg_log('Crear Ubicación Tecnica',n_error,v_error,r_ubitec.numslc,an_codsolot,an_id_ubitecnica,null,null);
        if n_tipo_sga in(4,1) then--Se valida si ID_SITIO no existe y se crea uno nuevo  26.0
          p_crea_id_sitio(an_codsolot,an_id_ubitecnica);
        end if;
      end if;
    end loop;

  exception
    WHEN err THEN
      p_reg_log('Crear Ubicación Tecnica',n_error,v_error,null,an_codsolot,an_id_ubitecnica,null,null);
    when others then
      v_error:='Ubicación Tecnica:'|| v_ubitec || '-' || v_error ||'-'||sqlerrm;
      p_reg_log('Crear Ubicación Tecnica.',sqlcode,v_error,null,an_codsolot,an_id_ubitecnica,null,null);
  end;
END;

procedure p_crea_ubitec(av_ubitec varchar2,av_descripcion varchar2,av_id_hub_sap varchar2,an_idhub number,an_codubired number,an_tipo_sga number,
                        --INI 16.0
                        av_ubitv_nombre         operacion.ubi_tecnica.ubitv_nombre%type default null,
                        av_ubitv_direccion      operacion.ubi_tecnica.ubitv_direccion%type default null,
                        av_ubitv_codigo_site    operacion.ubi_tecnica.ubitv_codigo_site%type default null,
                        av_ubitv_tipo_site      operacion.ubi_tecnica.ubitv_tipo_site%type default null,
                        av_claseproy            operacion.ubi_tecnica.claseproy%type default null,
                        av_ubitv_x              operacion.ubi_tecnica.ubitv_x%type default null,
                        av_ubitv_y              operacion.ubi_tecnica.ubitv_y%type default null,
                        av_ubitv_observacion    operacion.ubi_tecnica.ubitv_observacion%type default null,
                        av_ubitv_estado         operacion.ubi_tecnica.ubitv_estado%type default null,
                        av_ubitv_ubigeo         operacion.ubi_tecnica.ubitv_ubigeo%type default null,
                        av_ubitv_flag_nvl4      operacion.ubi_tecnica.ubitv_flag_nvl4%type default null,
                        --FIN 16.0
                        --INI 17.0
                        av_ubitv_direccion_nro  operacion.ubi_tecnica.ubitv_direccion_nro%type default null,
                        av_ubitv_codigo_postal  operacion.ubi_tecnica.ubitv_codigo_postal%type default null,
                        av_ubitv_poblacion      operacion.ubi_tecnica.ubitv_poblacion%type default null,
                        --FIN 17.0
                        -- INI 20.0
                        av_area_empresa     operacion.ubi_tecnica.area_empresa%type default null
                        -- FIN 20.0
                       )
IS
v_error varchar2(400);
n_error number;
err EXCEPTION;
v_Codsuc varchar2(20);
v_idplano varchar2(20);
n_cid number;
v_claseproy varchar2(1) default 'H';
n_id_sitio number;
v_desc_sitio varchar2(200);
v_pieza_fab varchar2(100);
v_flag_instal_auto varchar2(100) default 'X';
v_montajeequipos varchar2(100) default 'X';
n_id_ubitecnica number;
n_val_codubired number;
n_val_ut number;
v_equicategoria varchar2(20);
v_complemento varchar2(20);
--INI 16.0
v_tipo                operacion.ubi_tecnica.tipo%type;
v_grupoautorizaciones operacion.ubi_tecnica.grupoautorizaciones%type;
--FIN 16.0
--INI 17.0
n_nivel               number := 3;
v_nivel4              varchar2(50);
v_nivel5              varchar2(50);
v_nivel6              varchar2(50);
v_descripcion         operacion.ubi_tecnica.descripcion%type;
v_ubitv_nombre        operacion.ubi_tecnica.ubitv_nombre%type := '';
v_ubitv_direccion     operacion.ubi_tecnica.ubitv_direccion%type := '';
v_ubitv_distrito      operacion.ubi_tecnica.ubitv_distrito%type := '';
v_ubitv_provincia     operacion.ubi_tecnica.ubitv_provincia%type := '';
v_ubitv_departamento  operacion.ubi_tecnica.ubitv_departamento%type := '';
v_ubitv_direccion_nro operacion.ubi_tecnica.ubitv_direccion_nro%type := '';
v_ubitv_pais          operacion.ubi_tecnica.ubitv_pais%type := '';
v_ubitv_zona_horaria  operacion.ubi_tecnica.ubitv_zona_horaria%type := '';
v_ubitv_ubigeo        operacion.ubi_tecnica.ubitv_ubigeo%type := '';
v_ubitv_nom_distrito  operacion.ubi_tecnica.ubitv_nom_distrito%type := '';
v_ubitv_nom_provincia operacion.ubi_tecnica.ubitv_nom_provincia%type := '';
v_ubitv_nom_departamento  operacion.ubi_tecnica.ubitv_nom_departamento%type := '';
v_ubitv_codigo_postal  operacion.ubi_tecnica.ubitv_codigo_postal%type := '';
v_ubitv_poblacion      operacion.ubi_tecnica.ubitv_poblacion%type := '';
--FIN 17.0
-- ini 20.0
v_area_empresa         operacion.ubi_tecnica.area_empresa%type := '';
v_region varchar2(3);
v_codest varchar2(3);
v_cod_sap varchar2(3);
-- fin 20.0
Begin
  --INI 16.0
  v_tipo:='I';
  v_grupoautorizaciones := 'FJPE';
  --FIN 16.0
  v_descripcion := av_ubitv_nombre; -- 20.0
  Begin
    if an_tipo_sga=1 then --HUB
      if an_idhub is null then
        n_error:=-2001;
        v_error := 'Registrar el HUB: ';
        raise_application_error(-20500,v_error);
      end if;
    end if;
    if an_tipo_sga=3 then --SITE
      v_flag_instal_auto:=null;
      v_claseproy:='F';
      v_equicategoria:='F';
      if an_codubired is null then
        raise_application_error(-20001,'Registrar el SITE.');
      end if;
    end if;
    if an_tipo_sga=11 then --Corporativos 5 y 6
      v_claseproy:='F';
      v_montajeequipos:='';
    end if;
    --INI 16.0
    if an_tipo_sga=13 then --MOVIL
       v_claseproy:=av_claseproy;
       --INI 17.0
       BEGIN
          SELECT reg.codsapreg, pai.abrev, dst.nomdst, ubi.nompvc, ubi.nomest, ubi.codest
            INTO v_ubitv_departamento, v_ubitv_pais, v_ubitv_nom_distrito, v_ubitv_nom_provincia, v_ubitv_nom_departamento, v_codest
            FROM marketing.vtatabpai pai, marketing.vtatabest reg, v_ubicaciones ubi, marketing.vtatabdst dst
           WHERE pai.codpai = reg.codpai
             AND reg.codpai = ubi.codpai
             AND ubi.codest = TRIM(reg.codest)
             AND ubi.codubi = dst.codubi
             AND dst.ubigeo = av_ubitv_ubigeo;
       EXCEPTION
         WHEN no_data_found THEN
             v_error := 'UBI_TECNICA: ' || 'El valor para la REGION no existe.';
             raise_application_error(-20001,v_error);
       END;

       v_ubitv_ubigeo       := av_ubitv_ubigeo;
       v_ubitv_nombre       := av_ubitv_nombre;
       v_ubitv_direccion    := av_ubitv_direccion;
       v_ubitv_direccion_nro:= av_ubitv_direccion_nro;
       v_ubitv_codigo_postal:= av_ubitv_codigo_postal;
       v_ubitv_poblacion    := av_ubitv_poblacion;
       v_area_empresa       := av_area_empresa;

      -- ini 20.0
      BEGIN
          SELECT O.CODIGON_AUX
            INTO v_cod_sap
            FROM operacion.opedd o, operacion.tipopedd t
           WHERE (T.TIPOPEDD = O.TIPOPEDD)
             and (O.ABREVIACION = 'SGA_SAP_DEP')
             and (O.CODIGOC = v_codest);
      EXCEPTION
         WHEN no_data_found THEN
             v_error := 'UBI_TECNICA: ' || 'El valor para la REGION SAP no existe.';
             raise_application_error(-20001,v_error);
      END;
      IF LENGTH(TRIM(v_cod_sap))= 1 THEN
        v_region := trim( '0' || v_cod_sap);
      ELSE
        v_region := v_cod_sap;
      END IF;
      -- fin 20.0

       BEGIN
         SELECT o.codigoc
           INTO v_ubitv_zona_horaria
           FROM operacion.opedd o, operacion.tipopedd p
          WHERE o.abreviacion = 'ZONA_HORARIA'
            AND o.tipopedd = p.tipopedd
            AND p.abrev = 'REQ_RED_MOVIL';
       EXCEPTION
         WHEN no_data_found THEN
             v_error := 'UBI_TECNICA: ' || 'El valor para la ZONA HORARIA no existe.';
             raise_application_error(-20001,v_error);
       END;

       SELECT operacion.pq_sinergia.f_cadena(av_ubitec, '-', 4) INTO v_nivel4 FROM dual;
       SELECT operacion.pq_sinergia.f_cadena(av_ubitec, '-', 5) INTO v_nivel5 FROM dual;
       SELECT operacion.pq_sinergia.f_cadena(av_ubitec, '-', 6) INTO v_nivel6 FROM dual;
       IF v_nivel4 IS NOT NULL THEN
         n_nivel := n_nivel + 1;
       END IF;
       IF v_nivel5 IS NOT NULL THEN
         n_nivel := n_nivel + 1;
       END IF;
       IF v_nivel6 IS NOT NULL THEN
         n_nivel := n_nivel + 1;
       END IF;
       IF n_nivel = 4 THEN
         IF v_descripcion IS NULL THEN
            v_descripcion := av_ubitv_nombre;
         else
          v_descripcion := av_ubitv_nombre;
         end if;
       END IF;
       IF n_nivel = 5 THEN
          IF v_descripcion IS NULL THEN
             v_descripcion := av_ubitv_tipo_site;
          ELSE
             v_descripcion := av_ubitv_nombre || '-' || av_ubitv_tipo_site;
          END IF;
       END IF;
       IF n_nivel = 6 THEN
          IF v_descripcion IS NULL THEN
             v_descripcion := av_ubitv_codigo_site;
          ELSE
             v_descripcion := av_ubitv_codigo_site || ' ' || av_ubitv_nombre;
          END IF;
       END IF;

       IF n_nivel = 4 OR n_nivel = 5 THEN
          v_montajeequipos     := '';
          v_ubitv_nombre       := '';
          v_ubitv_direccion    := '';
          v_ubitv_direccion_nro:= '';
          v_ubitv_departamento := '';
          v_ubitv_provincia    := '';
          v_ubitv_distrito     := '';
          v_ubitv_pais         := '';
          v_ubitv_zona_horaria := '';
          v_ubitv_ubigeo       := '';
          v_ubitv_nom_distrito := '';
          v_ubitv_nom_provincia:= '';
          v_ubitv_nom_departamento:= '';
          v_ubitv_codigo_postal:= '';
          v_ubitv_poblacion    := '';
          v_area_empresa       := '';
          v_region             := '';
       END IF;
       --FIN 17.0

       BEGIN
         SELECT o.codigoc
           INTO v_grupoautorizaciones
           FROM operacion.opedd o, operacion.tipopedd p
          WHERE o.abreviacion = 'GRUPO_AUTORIZACIONES'
            AND o.tipopedd = p.tipopedd
            AND p.abrev = 'REQ_RED_MOVIL';
       EXCEPTION
         WHEN no_data_found THEN
             v_error := 'UBI_TECNICA: ' || 'El valor para el GRUPO DE AUTORIZACIONES no existe.';
             raise_application_error(-20001,v_error); -- 17.0
       END;

       BEGIN
         SELECT o.codigoc
           INTO v_tipo
           FROM operacion.opedd o, operacion.tipopedd p
          WHERE o.abreviacion = 'TIPO'
            AND o.tipopedd = p.tipopedd
            AND p.abrev = 'REQ_RED_MOVIL';
       EXCEPTION
         WHEN no_data_found THEN
             v_error := 'UBI_TECNICA: ' || 'El valor para el TIPO no existe.';
             raise_application_error(-20001,v_error); -- 17.0
       END;
    end if;
    --FIN 16.0
    select count(1) into n_val_ut from operacion.ubi_tecnica where abrev=av_ubitec and procesado='S';
    if n_val_ut>0 then--Ya existe ubicacion tecnica
      raise_application_error(-20001,'La Ubicación Tecnica ya existe.');
    end if;

    Select OPERACION.SQ_UBITECNICA.nextval into n_id_ubitecnica From dual;
    insert into OPERACION.UBI_TECNICA(ID_UBITECNICA,tipo,sociedad,Abrev,Cid,
    descripcion,GRUPOAUTORIZACIONES,FLAGUBICACIONTECNICA,FLAG_INSTAL_AUTO,MONTAJEEQUIPOS,IDPLANO,CODSUC,CLASEPROY,
    ID_HUB_SAP,tipo_sga,IDHUB,codubired,
    --INI 16.0
    ubitv_nombre,
    ubitv_direccion,
    ubitv_codigo_site,
    ubitv_tipo_site,
    ubitv_x,
    ubitv_y,
    ubitv_observacion,
    ubitv_estado,
    ubitv_ubigeo,
    ubitv_flag_nvl4,
    --FIN 16.0
    --INI 17.0
    ubitv_distrito,
    ubitv_provincia,
    ubitv_departamento,
    ubitv_direccion_nro,
    ubitv_pais,
    ubitv_zona_horaria,
    ubitv_nom_distrito,
    ubitv_nom_provincia,
    ubitv_nom_departamento,
    ubitv_codigo_postal,
    ubitv_poblacion,
    --FIN 17.0
    --ini 20.00
    area_empresa,
    region
    -- fin 20.0
    )
    values(n_id_ubitecnica,v_tipo,'PE02',av_ubitec,n_cid,
    v_descripcion,v_grupoautorizaciones,'IEUNI',v_flag_instal_auto,v_montajeequipos,v_idplano,v_Codsuc,v_claseproy, --16.0
    av_id_hub_sap,an_tipo_sga,an_idhub,an_codubired,
    --INI 16.0
    v_ubitv_nombre, -- 17.0
    v_ubitv_direccion, -- 17.0
    av_ubitv_codigo_site,
    av_ubitv_tipo_site,
    av_ubitv_x,
    av_ubitv_y,
    av_ubitv_observacion,
    av_ubitv_estado,
    v_ubitv_ubigeo, --17.0
    av_ubitv_flag_nvl4,
    --FIN 16.0
    --INI 17.0
    v_ubitv_distrito,
    v_ubitv_provincia,
    v_ubitv_departamento,
    v_ubitv_direccion_nro,
    v_ubitv_pais,
    v_ubitv_zona_horaria,
    v_ubitv_nom_distrito,
    v_ubitv_nom_provincia,
    v_ubitv_nom_departamento,
    v_ubitv_codigo_postal,
    v_ubitv_poblacion,
    --FIN 17.0
    -- ini 20.0
    v_area_empresa,
    v_region
    -- fin 20.0
    );

    if an_tipo_sga=1 then --HUB
      v_desc_sitio:=av_id_hub_sap||'-HUB';
      v_pieza_fab:=av_id_hub_sap;
      update ope_hub set id_ubitecnica=n_id_ubitecnica where idhub=an_idhub;
    end if;
    if an_tipo_sga=3 then --SITE
      select substr(codigo,1,2)||v_claseproy||substr(codigo,3),descripcion
      into v_pieza_fab,v_desc_sitio from ubired where codubired=an_codubired;
      update ubired set id_ubitecnica=n_id_ubitecnica where codubired=an_codubired;
      select count(1) into n_val_codubired from operacion.ubi_tecnica where codubired=an_codubired;
      if n_val_codubired>0 then
        update operacion.ubi_tecnica set codubired=null where codubired=an_codubired and not id_ubitecnica=n_id_ubitecnica;
      end if;
    end if;
    --INI 16.0
    if an_tipo_sga <> 13 then
       webservice.PQ_WS_SINERGIA.P_CREA_UBITEC_SITIO(n_id_ubitecnica,n_error,v_error);

      IF n_error < 0 THEN
        v_error := 'Ubicación_Tecnica: ' || v_error;
        RAISE err;
      else
        p_reg_log('Crear Ubicación_Tecnica :',0,'Se generó UT: ' || av_ubitec,null,null,n_id_ubitecnica,null,null);
      end if;
    end if;
    --FIN 16.0
    if not an_tipo_sga=11 then --el UT Corp Nivel 6 no tienen ID_SITIO solo crean IDSITIO los HUBs y SITEs
      if  an_tipo_sga=3 then --Radio Base
        v_complemento:='FIBRA';
      else
        v_complemento:='';
      end if;
      if an_tipo_sga <> 13 then --16.0
        Select OPERACION.SQ_ID_SITIO.nextval into n_id_sitio From DUMMY_OPE;
    insert into OPERACION.ID_SITIO(ID_SITIO,ID_UBITECNICA,DESCRIPT,manfacture,
    MANPARNO,VALID_DATE,COMP_CODE,OBJECTTYPE,EQUICATGRY)
    values(n_id_sitio,n_id_ubitecnica,v_desc_sitio || v_complemento ,DECODE(v_claseproy,'H','OTRO','F','NODO TX','OTRO'),
    v_pieza_fab,sysdate,'PE02',v_claseproy,v_equicategoria);
    webservice.PQ_WS_SINERGIA.P_CREA_ID_SITIO(n_id_sitio,n_error,v_error);
    IF n_error < 0 THEN
          v_error := 'ID_SITIO: ' || v_error;
          RAISE err;
    END IF;
      end if; --16.0
      if an_tipo_sga=3 then --Se crea adicionalmente SITIO para WIMAX adicional
        select substr(codigo,1,2)||'W'||substr(codigo,3) into v_pieza_fab from ubired where codubired=an_codubired;
        Select OPERACION.SQ_ID_SITIO.nextval into n_id_sitio From DUMMY_OPE;
        insert into OPERACION.ID_SITIO(ID_SITIO,ID_UBITECNICA,DESCRIPT,manfacture,
        MANPARNO,VALID_DATE,COMP_CODE,OBJECTTYPE,EQUICATGRY)
        values(n_id_sitio,n_id_ubitecnica,v_desc_sitio || ' WIMAX','RBS',
        v_pieza_fab,sysdate,'PE02',v_claseproy,'W');
        webservice.PQ_WS_SINERGIA.P_CREA_ID_SITIO(n_id_sitio,n_error,v_error);
        IF n_error < 0 THEN
          v_error := 'ID_SITIO: ' || v_error;
          RAISE err;
        END IF;
      end if;
      update OPERACION.Id_Sitio set procesado='S' where id_sitio=n_id_sitio;
      --INI 16.0
      if an_tipo_sga = 13 and nvl(av_ubitv_estado,'X') in ('4', '5') then
          webservice.pq_ws_sinergia.p_crea_ubi_tec(n_id_ubitecnica, n_error, v_error);
          if n_error < 0 then
             v_error := 'UBI_TECNICA: ' || v_error;
             raise_application_error(-20001,v_error);
          end if;
      end if;
      --FIN 16.0
    end if;
  end;
END;

procedure p_act_ubi_tecnica(an_id_ubitecnica in number)
IS
v_abrev varchar2(50);
v_error varchar2(400);
n_error number;
err EXCEPTION;
cursor c_ubitec is
  select * from OPERACION.UBI_TECNICA where id_ubitecnica=an_id_ubitecnica;
Begin
  Begin
    for r_ubitec in c_ubitec loop
      webservice.PQ_WS_SINERGIA.P_ACT_UBI_TEC(an_id_ubitecnica,n_error,v_error);
    end loop;
  exception
    WHEN err THEN
      p_reg_log('Actualizar Ubicación Tecnica',n_error,v_error,null,null,an_id_ubitecnica,null,null);
    when others then
      v_error:='Ubicación Tecnica:'|| v_abrev ||'-'||sqlerrm;
      p_reg_log('Actualizar Ubicación Tecnica.',sqlcode,v_error,null,null,an_id_ubitecnica,null,null);
  end;
END;


procedure p_crea_id_sitio(an_codsolot in number,an_id_ubitecnica in number)
IS
v_error varchar2(400);
n_error number;
n_id_sitio number;
err EXCEPTION;
n_sitio_id number;
v_manparno operacion.id_sitio.manparno%type;
v_descript operacion.id_sitio.descript%type;
v_claseproy operacion.ubi_tecnica.claseproy%type;--26.0
n_tipo_sga number;
n_cont_manparno number;--10.0
t_tiproy operacion.tiproy_sinergia%rowtype;--27.0
cursor c_ubitec is
  select a.id_hub_sap,a.idplano,a.numslc,a.codsolot,a.claseproy,DECODE(a.claseproy,'H','NODO','OTRO') FABRICANTE,IDHUB,tipo_sga,cid
  from OPERACION.UBI_TECNICA a where a.id_ubitecnica=an_id_ubitecnica;
cursor c_id_sitio is
  select distinct b.cid, nvl(c.numero,substr(b.descripcion,1,40)) numero,b.codinssrv,b.descripcion
  from solot a,solotpto b ,inssrv c,vtasuccli d
  where a.codsolot=b.codsolot and b.codinssrv=c.codinssrv and c.codsuc=d.codsuc(+)
  and a.codsolot=an_codsolot and ((n_tipo_sga = 4 and b.cid = (select min(cid)
                                                               from solotpto x
                                                               where x.codsolot = b.codsolot
                                                               and x.cid is not null
                                                               and n_tipo_sga = 4 )) or (n_tipo_sga <> 4 )); --15.0
Begin
  Begin
    for r_ubitec in c_ubitec loop
      n_tipo_sga:=r_ubitec.tipo_sga;
      v_claseproy:=r_ubitec.claseproy;--26.0
      for r_id_sitio in c_id_sitio loop
        if n_tipo_sga<>4 then
          Begin --Validacion de que se genere el id sitio sin repetir
            Select count(1) into n_sitio_id
            from OPERACION.Id_Sitio
            where DESCRIPT= r_id_sitio.numero and id_ubitecnica=an_id_ubitecnica;
          Exception when others then
            n_sitio_id := 0;
          End;
        else
          Begin --Validacion de que se genere el id sitio sin repetir 9.0
            select count(1) into n_sitio_id from operacion.id_sitio a2
            where a2.cid=r_id_sitio.cid and a2.procesado='S';
          Exception when others then
            n_sitio_id := 0;
          End;
        end if;

        if n_sitio_id = 0 then
          if r_ubitec.tipo_sga =2 then--PLANOS
            v_manparno:=r_ubitec.idplano;
            v_descript:=r_ubitec.id_hub_sap||'-'||r_ubitec.idplano;
          END IF;
          IF r_ubitec.tipo_sga =1 then--HUBs
            select * into t_tiproy  from operacion.tiproy_sinergia where tiproy=f_get_tiproy(an_codsolot);--27.0
            select decode(t_tiproy.claseproy,'J','F','H')|| substr(r_ubitec.id_hub_sap,2) into v_manparno from dual;--27.0
            v_claseproy:=t_tiproy.claseproy;
            v_descript:=r_ubitec.id_hub_sap||'-HUB';
          end if;
          if r_ubitec.tipo_sga =4 then--Corporativo
            v_manparno:=to_char(r_id_sitio.cid);
            v_descript:=r_id_sitio.numero;
          end if;
          --10.0
          select count(1) into n_cont_manparno from operacion.id_sitio
          where manparno=v_manparno and procesado='S';
          if n_cont_manparno>0 then
            v_error := 'El nro de pieza de fabricante ya existe como ID_SITIO.';
            p_reg_log('Crear ID SITIO.',n_error,v_error,r_ubitec.numslc,an_codsolot,an_id_ubitecnica,null,null);
          end if;
          if v_manparno is not null and n_cont_manparno=0 then
            Select OPERACION.SQ_ID_SITIO.nextval into n_id_sitio From DUMMY_OPE;
            insert into OPERACION.ID_SITIO(ID_SITIO,ID_UBITECNICA,DESCRIPT,manfacture,
            MANPARNO,VALID_DATE,COMP_CODE,OBJECTTYPE,cid)
            values(n_id_sitio,an_id_ubitecnica,v_descript,r_ubitec.FABRICANTE,
            v_manparno,sysdate,'PE02',v_claseproy,r_id_sitio.cid);
            commit;
            webservice.PQ_WS_SINERGIA.P_CREA_ID_SITIO(n_id_sitio,n_error,v_error);
            IF n_error < 0 THEN
              v_error := 'Crear ID_SITIO: ' || v_error;
              RAISE err;
            else
              p_reg_log('Crear ID SITIO:',0,'Se generó ID_SITIO: ' || v_manparno,r_ubitec.numslc,an_codsolot,an_id_ubitecnica,null,null);
            END IF;
            update OPERACION.Id_Sitio set procesado='S' where id_sitio=n_id_sitio;
          else--10.0
            if v_manparno is null then
              v_error := 'El nro de pieza de fabricante no puede ser nulo.';
              RAISE err;
            end if;
            if n_cont_manparno=1 then
              v_error := 'El nro de pieza de fabricante ya existe.';
              RAISE err;
            end if;
          end if;
        else
          v_error := 'El ID Sitio ya Existe : ' || r_id_sitio.numero;
          p_reg_log('Crear ID SITIO',n_error,v_error,r_ubitec.numslc,an_codsolot,an_id_ubitecnica,null,null);
        end if;
    end loop;
  end loop;
  exception
    WHEN err THEN
      p_reg_log('Crear ID SITIO.',n_error,v_error,null,an_codsolot,an_id_ubitecnica,null,null);
      null;
    when others then
      v_error:='ID SITIO :'|| to_char(n_id_sitio) ||'-'||sqlerrm;
      p_reg_log('Crear ID SITIO.',sqlcode,v_error,null,an_codsolot,an_id_ubitecnica,null,null);
  end;
END;

procedure p_act_id_sitio(an_id_sitio in number,av_estado in varchar2)
IS
v_abrev varchar2(50);
v_error varchar2(400);
n_error number;
err EXCEPTION;
cursor c_ubitec is
  select * from OPERACION.Id_Sitio where id_sitio=an_id_sitio;
Begin
/*an estado 1 CREA
            2 OPER
            3 NOPP */
  Begin
    for r_ubitec in c_ubitec loop
      webservice.PQ_WS_SINERGIA.P_MOD_EST_SITIO(an_id_sitio,av_estado,n_error,v_error);
    end loop;
  exception
    WHEN err THEN
      p_reg_log('Cambio Estado Sitio',n_error,v_error,null,null,null,null,null);
    when others then
      v_error:='Cambio Estado Sitio :'|| v_abrev ||'-'||sqlerrm;
      p_reg_log('Cambio Estado Sitio.',sqlcode,v_error,null,null,null,null,null);
  end;
END;


procedure p_crea_grafo(an_codsolot in number,an_idgrafo out varchar2)
IS
v_error varchar2(400);
n_error number;
t_tiproy operacion.tiproy_sinergia%rowtype;
n_idwf opewf.wf.idwf%type;
n_idactividad number;
v_numerografo operacion.grafo.numerografo%type;
v_pos_tarea opewf.tareawfcpy.pos_tareas%type;
v_numerooperacion_pos operacion.actividad_sap.numerooperacion%type;
n_idrelacion number;
n_numeroreferencia number;
err EXCEPTION;
cursor c_pep_grafo is--PEPs para asignar grafo
  select b.tiproy,a.proyecto,a.pep,a.cebe from operacion.pep a, operacion.proyecto_sap b
  where a.codsolot=an_codsolot and a.proyecto=b.proyecto and b.procesado='S'
  and a.nivel=3 and a.crea_grafo=1;
cursor c_wf is--Identificar datos del WF
  select a.idwf, substr(b.descripcion,1,40) descripcion,a.codsolot,b.wfdef from wf a, wfdef b
  where a.wfdef=b.wfdef and a.codsolot=an_codsolot  and valido=1;
cursor c_tar is--Identificar tareas para replicar actividades
  SELECT WFDEF,idtareawf,lpad(rownum*10,4,'0') numerooperacion,substr(descripcion,1,40) descripcion,
  lpad(rownum,6,'0') numeroreferencia,1 tipo,'NETWORKACTIVITY' tipoobjeto, 'CREATE' METODO
  FROM tareawfcpy WHERE idwf= n_idwf
  union
  select 0, 0,lpad(0,4,'0'), NULL, lpad(0,6,'0'),2, null, 'SAVE'
  from dummy_opwf;
cursor c_rel is
  select a.idwf,d.pos_tareas,c.numerooperacion
  from wf a, operacion.grafo b,operacion.actividad_sap c,tareawfcpy d
  where a.idwf=b.idwf and b.idgrafo=an_idgrafo and a.valido=1 and b.idgrafo=c.idgrafo and a.idwf=d.idwf
  and c.idtareawf=d.idtareawf and d.pos_tareas is not null;
cursor c_pos_tar is
  select COLUMN_VALUE pos_tarea ,1 tipo,'NETWORKRELATION' tipoobjeto, 'CREATE' METODO
  from table(f_split(v_pos_tarea,';'));

Begin
  Begin
    for r_pep in c_pep_Grafo loop
      select * into t_tiproy from operacion.tiproy_sinergia a
      where a.tiproy= r_pep.tiproy;
      for r_wf in c_wf loop
        Select OPERACION.SQ_IDGRAFO.nextval into an_idgrafo From DUMMY_OPE;
        insert into OPERACION.GRAFO(IDGRAFO,CODSOLOT,IDWF,CLASE,PERFIL,PLANIFICADOR,DESCRIPCION,FECINI,
        PROYECTO,PEP,POSPEDIDO,DIVISION,CEBE,CENTRO)
        values(an_idgrafo,r_wf.codsolot,r_wf.idwf,t_tiproy.clasegrafo,t_tiproy.perfilgrafo,t_tiproy.planif_nec,
        r_wf.descripcion,sysdate,r_pep.proyecto,r_pep.pep,'000000','0',r_pep.cebe,t_tiproy.centrografo);
        commit;
        webservice.PQ_WS_SINERGIA.P_CREA_GRAFO(an_idgrafo,v_numerografo,n_error,v_error);
        IF n_error < 0 THEN
          v_error := 'Crear Grafo: ' || v_error;
          RAISE err;
        END IF;
        n_idwf:=r_wf.idwf;
        for c_t in c_tar loop
          Select OPERACION.SQ_IDactividad.nextval into n_idactividad From DUMMY_OPE;
          insert into operacion.actividad_sap(IDACTIVIDAD,IDTAREAWF,NUMEROGRAFO,NUMEROOPERACION,CLAVECONTROL,
          CENTRO,DESCRIPCION,PEP,CLAVECALCULO,CLAVEMODELO,PRIORIDAD,idgrafo,numeroreferencia,tipo,tipoobjeto,metodo)
          values(n_idactividad,c_t.idtareawf,v_numerografo,c_t.numerooperacion,t_tiproy.clavecontrol,t_tiproy.centrografo,
          c_t.descripcion,r_pep.pep,0,null,3,an_idgrafo,c_t.numeroreferencia,c_t.tipo,c_t.tipoobjeto,c_t.metodo);
        end loop;
        commit;
        webservice.PQ_WS_SINERGIA.P_CREA_ACTIVIDAD(an_idgrafo,n_error,v_error);--Generar Actividades de forma masiva
        commit;
        if n_error < 0 then
          v_error := 'Crear Actividad: ' || v_error;
          RAISE err;
        end if;
        --Relaciones de Orden
        n_numeroreferencia:=1;
        for c_r in c_rel loop
          v_pos_tarea:=c_r.pos_tareas;
          for c_pos in c_pos_tar loop
            select operacion.sq_idrelacion.nextval into n_idrelacion from dummy_ope;
            select a.numerooperacion into v_numerooperacion_pos from operacion.actividad_sap a, tareawfcpy b
            where a.idtareawf=b.idtareawf and b.tarea = c_pos.pos_tarea and b.idwf=c_r.idwf and a.idgrafo=an_idgrafo;
            insert into operacion.rel_orden(idrelacion,numerografo_pre,numerografo_pos,numerooperacion_pre,
            numerooperacion_pos,tipo_relacion,tipo,tipoobjeto,metodo,numeroreferencia,idgrafo)
            values(n_idrelacion,v_numerografo,v_numerografo,c_r.numerooperacion,
            v_numerooperacion_pos,'FI',c_pos.tipo,c_pos.tipoobjeto,c_pos.metodo,lpad(n_numeroreferencia,6,'0'),an_idgrafo);
            n_numeroreferencia:=n_numeroreferencia+1;
          end loop;
        end loop;
        select operacion.sq_idrelacion.nextval into n_idrelacion from dummy_ope;--Insertar registro para el metodo
        insert into operacion.rel_orden(idrelacion,tipo_relacion,tipo,tipoobjeto,metodo,numeroreferencia,IDGRAFO)
        values(n_idrelacion,null,2,null,'SAVE','000000',an_idgrafo);
        webservice.PQ_WS_SINERGIA.P_CREA_RELACION_ORDEN(an_idgrafo,n_error,v_error);--Generar Relaciones de Orden
        if n_error < 0 then
          v_error := 'Generar Relación de Orden: ' || v_error;
          RAISE err;
        end if;
        --Liberar el grafo : Cambiar el estado
        p_act_est_grafo(an_idgrafo,null,1,1);--Se genera el grafo en estado Liberado: REL
      end loop;
    end loop;
  exception
    WHEN err THEN
      p_reg_log('Crear Grafo.',n_error,v_error,null,null,null,null,null);
    when others then
      v_error:='Grafo:'|| to_char(an_idgrafo) ||'-'||sqlerrm;
      p_reg_log('Crear_Grafo.',sqlcode,v_error,null,null,null,null,null);
  end;
END;

procedure p_act_est_grafo(an_idgrafo in number,av_actividades in varchar2,an_idestado in number,an_tipo in number)
IS
/* an_tipo 1 : GRAFO 2: ACTIVIDAD*/
v_estado operacion.tipopedd.abrev%type;
v_error varchar2(400);
n_error number;
n_codsolot NUMBER;
err EXCEPTION;
t_grafo operacion.grafo%rowtype;
n_idtrsgrafoact number;
n_idproceso number;
cursor c_act is
  select a.idgrafo,b.numerooperacion,b.idactividad from OPERACION.grafo a, operacion.actividad_sap b
  where a.idgrafo=b.idgrafo and b.idactividad in (
  select COLUMN_VALUE actividades from table(f_split(av_actividades,';')));
Begin
  select * into t_grafo from operacion.grafo where idgrafo=an_idgrafo;
  SELECT OPERACION.SQ_PROC_TRSGRAFO.NEXTVAL into n_idproceso from dummy_ope;
  begin
    select b.codigoc into v_estado from tipopedd a,opedd b
    where a.tipopedd=b.tipopedd and a.abrev='SINESTACTGRASGA'
    and b.codigon_aux=an_tipo and b.codigon=an_idestado;
  exception
    when no_data_found then
      v_error := 'No se tiene configurado el estado para el Grafo o Actividad';
      n_error:= sqlcode;
      RAISE err;
  end;
  if an_tipo=1 then--Grafo
    SELECT OPERACION.SQ_IDTRSGRAFOACT.NEXTVAL into n_idtrsgrafoact from dummy_ope;
    insert into OPERACION.TRS_GRAFO_ACT(IDTRSGRAFOACT,numerografo,TIPO,ESTADO,IDGRAFO,IDPROCESO)
    values(n_idtrsgrafoact,t_grafo.numerografo,an_tipo,v_estado,an_idgrafo,n_idproceso);
  elsif an_tipo=2 then--Actividad
    for r_act in c_act loop
      SELECT OPERACION.SQ_IDTRSGRAFOACT.NEXTVAL into n_idtrsgrafoact from dummy_ope;
      insert into OPERACION.TRS_GRAFO_ACT(numerografo,IDTRSGRAFOACT,NUMEROOPERACION,TIPO,estado,idgrafo,IDPROCESO)
      values(t_grafo.numerografo,n_idtrsgrafoact,r_act.numerooperacion,an_tipo,v_estado,an_idgrafo,n_idproceso);
      update operacion.actividad_sap set estactividad=an_idestado
      where idactividad=r_Act.idactividad;
    end loop;
  end if;
  commit;
  webservice.PQ_WS_SINERGIA.P_ACT_EST_GRAFO(n_idproceso,n_error,v_error);
  commit;
  if n_error < 0 then
    v_error := 'Actualizar Estado Grafo Actividad: ' || v_error;
    RAISE err;
  end if;

exception
  WHEN err THEN
    p_reg_log('Actualiza_Estado_Grafo',n_error,v_error,null,n_codsolot,null,null,null);
  when others then
    v_error:='Actualizar Estado Grafo_Actividad :' || sqlerrm;
    p_reg_log('Actualiza_Estado_Grafo',n_error,v_error,null,n_codsolot,null,null,null);
END;



procedure p_crea_prys_sap
IS
v_error varchar2(400);
n_error number;
err EXCEPTION;
n_idgrafo number;
v_act varchar2(4000);
v_numslc varchar2(20);
n_val_pry number;
n_val_wf number;
n_val_grafo number;
n_val_ppto  number;
n_val_sitio number;

--Crea Proyectos SAP
cursor cur_sot is
  select a1.codsolot from solot a1, vtatabslcfac b1
  where not exists (select 1 from operacion.proyecto_sap a where a.codsolot=a1.codsolot)
  and operacion.Pq_Sinergia.f_val_pry_sinergia(a1.codsolot)='S'
  and a1.numslc=b1.numslc  and a1.estsol=17 and b1.tiproy is not null;

--Asigna Grafos a los proyectos o SOTs en ejecucion
cursor cur_wf is
  select pry.codsolot from OPERACION.Proyecto_Sap PRY where
  NOT exists (select 1 from OPERACION.grafo A, WF B, WFDEF C
    where  PRY.CODSOLOT= A.CODSOLOT AND A.IDWF=B.IDWF AND B.VALIDO=1 AND B.WFDEF=C.WFDEF AND C.FLAG_GRAFO=1)
  and exists (select 1 from OPERACION.pep
    where CODSOLOT= pry.CODSOLOT and nivel=3 and CREA_GRAFO=1) and procesado='S';

--Identificar Grafos que tienen actividades y tareas que no estan sincronizadas
cursor cur_idgrafo is
  select a.idgrafo from operacion.grafo a, wf b, operacion.actividad_sap c,tareawf d
  where a.idwf=b.idwf and b.valido=1 and a.idgrafo=c.idgrafo and  c.idtareawf=d.idtareawf and a.estado is null
  and not d.tipesttar=c.estactividad group by a.idgrafo;
--Actividades por cada grafo no sincronizado
cursor cur_actividad is
  select c.idactividad
  from operacion.grafo a, wf b, operacion.actividad_sap c,tareawf d
  where a.idwf=b.idwf and b.valido=1 and a.idgrafo=c.idgrafo and  c.idtareawf=d.idtareawf
  and not d.tipesttar=c.estactividad and a.idgrafo=n_idgrafo;


--Actualizar estado del Id Sitio en base al estado de la SOT para PLanos
cursor c_id_sitio is--Identificar SITIOs en estado CREA y con estado de SOT Atendido
select a.id_sitio,a.estado,c.proyecto,c.codsolot,d.estsol,c.tiproy,b.abrev
from operacion.id_sitio a, operacion.ubi_tecnica b,operacion.proyecto_sap c, solot d, vtatabgeoref e
where a.id_ubitecnica=b.id_ubitecnica and b.id_ubitecnica=c.id_ubitecnica and c.codsolot=d.codsolot
and c.clase_proy in('H','K') and c.procesado='S'  and b.procesado='S' and a.estado='E0001' and d.estsol=29
and b.idplano=e.idplano and e.estado=1;

--Identificar los WFs que han sido cancelados o cerrados en SGA y que no estan los grafos cerrados
cursor c_grafo_cierre is
select a.idgrafo,a.codsolot,a.numerografo,b.estwf from operacion.grafo a, wf b
where a.codsolot=b.codsolot  and a.idwf=b.idwf  and
a.estado is null and b.estwf in (4,5);


--Actualizar estado del Id Sitio en base al estado de la SOT para HUBS
cursor c_id_sitio_hub is--Identificar SITIOs en estado CREA y con estado de SOT Atendido
select a.id_sitio,a.estado,c.proyecto,c.codsolot,d.estsol,c.tiproy,b.abrev
from operacion.id_sitio a, operacion.ubi_tecnica b,operacion.proyecto_sap c, solot d, ope_hub e
where a.id_ubitecnica=b.id_ubitecnica and b.id_ubitecnica=c.id_ubitecnica and c.codsolot=d.codsolot
and c.clase_proy in('H','K') and c.procesado='S'  and b.procesado='S' and a.estado='E0001' and d.estsol=29
and b.idhub =e.idhub and e.estado=1;


--Actualizar estado del Id Sitio en base al estado de la SOT para CLIENTES CORPORATIVOs
cursor c_id_sitio_cli is--Identificar SITIOs en estado CREA y con estado de SOT Atendido
select a.id_sitio,a.estado,c.proyecto,c.codsolot,d.estsol,c.tiproy,b.abrev, b.tipo
from operacion.id_sitio a, operacion.ubi_tecnica b,operacion.proyecto_sap c, solot d
where a.id_ubitecnica=b.id_ubitecnica and b.id_ubitecnica=c.id_ubitecnica and c.codsolot=d.codsolot
and c.procesado='S'  and b.procesado='S'
and a.estado='E0001' and b.tipo_sga=4 and d.estsol=29;


--10.0
n_err number;
ln_id_control number;
v_err varchar2(3000);
n_val_ppto1 number;
cursor c_ppto is
select IDLOTEPPTO, CODSOLOT
from operacion.trs_ppto
where tipo=3 and fecusu>sysdate-1 and respuesta_sap='E';


Begin
  select count(1) into n_val_pry from tipopedd where abrev='SINERGIA_VAL_PRY';
  select count(1) into n_val_wf from tipopedd where abrev='SINERGIA_VAL_WF';
  select count(1) into n_val_grafo from tipopedd where abrev='SINERGIA_VAL_GRAFO';
  select count(1) into n_val_ppto from tipopedd where abrev='SINERGIA_VAL_PPTO';
  select count(1) into n_val_sitio from tipopedd where abrev='SINERGIA_VAL_SITIO';
  select count(1) into n_val_ppto1 from tipopedd where abrev='SINERGIA_VAL_PPTO1';--10.0

  if n_val_pry = 1 then
    select financial.sq_control_seriesstock.nextval into ln_id_control from dual; --10.0
    insert into financial.z_mm_control_seriesstock (id_control, fecha_inicio, estado)
    values(ln_id_control,sysdate, '1');
    commit;
    --Cursor para identificar SOTs sin grafos
    for c_s in cur_sot loop
      p_crea_pry_sap(c_s.codsolot);
    end loop;
    update financial.z_mm_control_seriesstock--10.0
    set fecha_fin = sysdate where id_control = ln_id_control;
    commit;
  end if;
  if n_val_wf=1 then
    select financial.sq_control_seriesstock.nextval into ln_id_control from dual; --10.0
    insert into financial.z_mm_control_seriesstock (id_control, fecha_inicio, estado)
    values(ln_id_control,sysdate, '2');
    commit;
    --Cursor para identificar SOTs sin grafos
    for c_wf in cur_wf loop
      p_crea_grafo(c_wf.codsolot,n_idgrafo);
    end loop;
    update financial.z_mm_control_seriesstock--10.0
    set fecha_fin = sysdate where id_control = ln_id_control;
    commit;
  end if;
  if n_val_grafo=1 then
    select financial.sq_control_seriesstock.nextval into ln_id_control from dual; --10.0
    insert into financial.z_mm_control_seriesstock (id_control, fecha_inicio, estado)
    values(ln_id_control,sysdate, '3');
    commit;
    --Cursor para alinear tareas de SGA a Actividades de SAP
    for c_idgrafo in cur_idgrafo loop
      n_idgrafo:= c_idgrafo.idgrafo;
      for c_act in cur_actividad loop
        v_act:= to_char(c_act.idactividad)||';'||v_act;
      end loop;
      p_act_est_grafo(n_idgrafo,substr(v_act,1,length(v_act)-1),4,2);
    end loop;
    --Cursor para identificar los WFs que tienen grafos y han sido cerrados/cancelados en SGA y no estan cerrados en SAP
    for c_gc in c_grafo_cierre loop
      --Cerrar estado del grafo
      p_act_est_Grafo(c_gc.idgrafo,null,4,1);
      update operacion.grafo set estado='CLSD' where idgrafo=c_gc.idgrafo;
    end loop;
    update financial.z_mm_control_seriesstock--10.0
    set fecha_fin = sysdate where id_control = ln_id_control;
    commit;
 end if;

  if n_val_ppto=1 then
    select financial.sq_control_seriesstock.nextval into ln_id_control from dual; --10.0
    insert into financial.z_mm_control_seriesstock (id_control, fecha_inicio, estado)
    values(ln_id_control,sysdate, '4');
    commit;
    --Procedimiento para ejecutar el presupuesto
    p_ppto_sap(null,2);--Corp 8.0
    p_ppto_sap(null,1);--Mas 8.0
    update financial.z_mm_control_seriesstock--10.0
    set fecha_fin = sysdate where id_control = ln_id_control;
    commit;
  end if;
  if n_val_sitio=1 then
    select financial.sq_control_seriesstock.nextval into ln_id_control from dual; --10.0
    insert into financial.z_mm_control_seriesstock (id_control, fecha_inicio, estado)
    values(ln_id_control,sysdate, '5');
    commit;
    --Cursor para atender SITIOS en estado Atendido de Planos
    for c_sit in c_id_sitio loop--SOT atendida en estado E0001
      p_act_id_sitio( c_sit.id_sitio , 'E0002');
      update operacion.id_sitio set estado= 'E0002' where id_sitio=c_sit.id_sitio ;
      if c_sit.tiproy='PEH' then--Se poner a operar el plano
        p_crea_pry_mas(c_sit.abrev ,2,v_numslc);
      end if;
    end loop;
    commit;
    --Cursor para atender SITIOS en estado Atendido de HUBS
    for c_sit in c_id_sitio_hub loop--SOT atendida en estado E0001
      p_act_id_sitio( c_sit.id_sitio , 'E0002');
      update operacion.id_sitio set estado= 'E0002' where id_sitio=c_sit.id_sitio ;
      if c_sit.tiproy='HUS' OR c_sit.tiproy='FUS' then--Se poner a operar el HUS --24.0
        p_crea_pry_mas(c_sit.abrev ,2,v_numslc);
      end if;
    end loop;
    commit;
    --Cursor para atender SITIOS en estado Atendido de Clientes Corporativos
    for c_cli in c_id_sitio_cli loop--SOT atendida en estado E0001
      p_act_id_sitio( c_cli.id_sitio , 'E0002');
      update operacion.id_sitio set estado= 'E0002' where id_sitio=c_cli.id_sitio ;
    end loop;
    commit;
    update financial.z_mm_control_seriesstock--10.0
    set fecha_fin = sysdate where id_control = ln_id_control;
    commit;
  end if;

  if n_val_ppto1=1 then--10.0
    select financial.sq_control_seriesstock.nextval into ln_id_control from dual; --10.0
    insert into financial.z_mm_control_seriesstock (id_control, fecha_inicio, estado)
    values(ln_id_control,sysdate, '6');
    commit;
    for c_p in c_ppto loop
      WEBSERVICE.PQ_WS_SINERGIA.P_PPTO_SGA(c_p.idloteppto,n_err,v_err);
    end loop;
    update financial.z_mm_control_seriesstock--10.0
    set fecha_fin = sysdate where id_control = ln_id_control;
    commit;
  end if;

exception
  WHEN err THEN
    p_reg_log('AsignaGrafo.',n_error,v_error,null,null,null,null,null);
  when others then
    v_error:='AsignaGrafo:'|| '-'||sqlerrm;
    p_reg_log('AsignaGrafo',sqlcode,v_error,null,null,null,null,null);
END;

PROCEDURE p_crea_pry_sap(an_codsolot in number,an_idubitecnica in number default 0)
IS
v_numslc sales.vtatabslcfac.numslc%type;
n_val_pry_anio number;
CURSOR cur_prys IS --cursor proyectos
select a.tiproy, a.tiproy_sap,'10' negocio
from operacion.tiproy_sinergia a
where a.tiproy = f_get_tiproy(an_codsolot)
and ((a.crea_proyecto=1) or
     (n_val_pry_anio=0 and (f_get_tiproy(an_codsolot)=TIPROY_NO1
                       or f_get_tiproy(an_codsolot)=TIPROY_NO2
                       or f_get_tiproy(an_codsolot)=TIPROY_FT4 --26.0
                       or f_get_tiproy(an_codsolot)=TIPROY_FT5 --30.0
                       or f_get_tiproy(an_codsolot)=TIPROY_HFC)))
union
SELECT a.tiproy, a.tiproy_sap,'10' negocio
from operacion.tiproy_sinergia a
where  f_get_tiproy(an_codsolot)=TIPROY_CVE AND a.tiproy=TIPROY_CVC ;

err EXCEPTION;
v_descripcion varchar2(40);
v_Fecha date;
v_ceco_sol  varchar2(10);
v_proyecto operacion.proyecto_sap.proyecto%type;
v_fecha_fin   varchar2(8);
v_fecha_ini   varchar2(8);
v_region VARCHAR2(1);
v_periodo VARCHAR2(2);
n_idseqsap number;
v_grupopry VARCHAR2(30);
n_error number;
v_error varchar2(400);
v_solicitante varchar2(100);
v_responsable varchar2(100);
v_cebe operacion.proyecto_sap.cebe%type;
v_desubitec operacion.ubi_tecnica.descripcion%type;
n_cont_pry number;
v_ubitecnica operacion.proyecto_sap.ubitecnica%type;
n_id_sitio operacion.proyecto_sap.id_sitio%type;
v_codcli operacion.proyecto_sap.codcli%type;
v_id_sitio_sap operacion.Id_Sitio.id_sitio_sap%type;
n_idproyecto number;
n_id_ubitecnica number;
t_tiproy operacion.tiproy_sinergia%rowtype;
v_val_pry varchar2(1);
v_idplano vtatabgeoref.idplano%type;
v_ubitec operacion.ubi_tecnica.abrev%type;
v_manparno operacion.proyecto_sap.manparno%type;
v_cid operacion.proyecto_sap.manparno%type;
n_cont_val_cid number;
n_tipo_sga number;--6.0
n_val_nuevo_seq number;--26.0
n_tipo_ut number;--26.0
n_val_peh number;--29.0
n_gen_proy_plano number;--29.0
begin
  select f_val_pry_sinergia(an_codsolot) into v_val_pry from dual;

  select a.numslc,substr(f_get_anio,3,2) into v_numslc,v_periodo from solot a, vtatabslcfac b
  where a.numslc=b.numslc and a.codsolot= an_codsolot;
  select count(1) into n_cont_pry from OPERACION.PROYECTO_SAP where codsolot = an_codsolot and procesado='S' and anio= f_get_anio;--6.0
  --29.0
  if f_get_tiproy(an_codsolot) IN (TIPROY_PEH) then
    select count(1) into n_gen_proy_plano from tipopedd where abrev='SINERGIAGENERAPLANOPEH';
    if n_gen_proy_plano=1 then
      select  count(1) into n_val_peh from vtatabslcfac a,operacion.Ubi_Tecnica b,operacion.proyecto_sap c
      where replace(replace(trim(a.idplano),'Ñ','N'),'-','_')=b.idplano and a.numslc=v_numslc and b.abrev=c.ubitecnica and c.procesado='S' and c.anio=f_get_anio
      and b.procesado='S' and b.tipo_sga=2;
      if n_val_peh>0 then
        v_error := 'No es valido generar Proyectos PEH para planos implementados.';
        RAISE err;
      end if;
    end if;
  end if;

  -- INI 7.0
  if f_get_tiproy(an_codsolot) IN (TIPROY_PEH, TIPROY_FTN) then --21.0
    BEGIN
        SELECT u.abrev, u.id_ubitecnica into v_ubitec, n_id_ubitecnica
        FROM  vtatabslcfac d, solot s, operacion.ubi_tecnica u
        WHERE d.numslc = s.numslc and
              d.idplano = u.idplano and
              d.numslc = v_numslc and
              u.procesado = 'S' and
              rownum = 1;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
         p_crea_ubi_tecnica(an_codsolot,n_id_ubitecnica);
         SELECT abrev into v_ubitec
         FROM operacion.ubi_tecnica
         WHERE id_ubitecnica = n_id_ubitecnica;
    END;
    select count(1) into n_cont_pry
    from operacion.proyecto_sap
    where ubitecnica=v_ubitec and tiproy in (TIPROY_PEH, TIPROY_FTN) and procesado='S' and anio= f_get_anio;--21.0

  end if;
  -- FIN 7.0

  if f_get_tiproy(an_codsolot) = TIPROY_AFO  then--Validar si se tienen PRYs de Corp en el año
    select count(distinct b.cid) into n_cont_val_cid from solot a,solotpto b
    where a.codsolot=b.codsolot and a.codsolot=an_codsolot and b.cid is not null;
    if n_cont_val_cid = 0 then
      n_error:=-1;
      v_error:= 'La SOT no tiene CIDs Validos para generar Proyecto en SAP.';
      RAISE err;
    end if;
    if n_cont_val_cid >1 then
      n_error:=-1;
      v_error:= 'La SOT tiene varios CIDs asignados a la SOT.';
     end if;

    --Validar si existe proyecto anual para el CID
    select count(1),count(1) into n_val_pry_anio ,n_cont_pry
    from solot a,solotpto b , operacion.id_sitio c,operacion.proyecto_sap d
    where a.codsolot=b.codsolot and a.codsolot=an_codsolot and rownum =1 and d.procesado='S'
    and b.cid is not null and b.cid=c.cid and c.manparno=d.manparno and anio=f_get_anio;
    if n_val_pry_anio=1 then
      select d.ubitecnica,c.id_ubitecnica,c.cid into v_ubitec,n_id_ubitecnica,v_cid
      from solot a,solotpto b , operacion.id_sitio c,operacion.proyecto_sap d
      where a.codsolot=b.codsolot and a.codsolot=an_codsolot and rownum =1 and d.procesado='S'
      and b.cid is not null and b.cid=c.cid and c.manparno=d.manparno and anio=f_get_anio;
    elsif n_val_pry_anio=0 then
      select min(b.cid) into v_cid from solot a,solotpto b
      where a.codsolot=b.codsolot and a.codsolot=an_codsolot and rownum =1
      and b.cid is not null;
    end if;
  end if;

  if f_get_tiproy(an_codsolot) in (TIPROY_NO1,TIPROY_NO2,TIPROY_FT4,TIPROY_FT5) then--Validar si se tienen PRYs de HUBs en el año  26.0

    select b.abrev,b.id_ubitecnica,d.id_sitio_sap into v_ubitec,n_id_ubitecnica,v_id_sitio_sap
    from vtatabslcfac a, operacion.ubi_tecnica b,solot c,operacion.Id_Sitio d
    where a.idhub=b.idhub and a.numslc=c.numslc and c.codsolot=an_codsolot and b.id_ubitecnica=d.id_ubitecnica
    and d.objecttype=(select claseproy from operacion.tiproy_sinergia where tiproy=f_get_tiproy(an_Codsolot))
    AND d.procesado='S' and b.procesado='S'; --31.0

    select count(1) into n_val_pry_anio
    from operacion.proyecto_sap --validar si existe pry HUS,FUS de ubitec en sap
    where id_sitio_sap=v_id_sitio_sap
    and tiproy in (TIPROY_NO1,TIPROY_NO2,TIPROY_HUS,TIPROY_FUS,TIPROY_FT4,TIPROY_FT5) and procesado='S' and anio= f_get_anio; --24.0 --32.0
  end if;

  if f_get_tiproy(an_codsolot) IN (TIPROY_ORA,TIPROY_OR1) then--Validar si se tienen PRYs de SITES en el año
    select b.abrev,b.id_ubitecnica into v_ubitec,n_id_ubitecnica from vtatabslcfac a, operacion.ubi_tecnica b,solot c
    where a.codubired=b.codubired and a.numslc=c.numslc and c.codsolot=an_codsolot;
    select count(1) into n_val_pry_anio
    from operacion.proyecto_sap --validar si existe pry SITES de ubitec en sap
    where ubitecnica=v_ubitec and tiproy in (TIPROY_ORA) and procesado='S' and anio= f_get_anio;
  end if;
  if f_get_tiproy(an_codsolot) IN (TIPROY_WM1,TIPROY_WM2) then--Validar si se tienen PRYs de SITES en el año
    select b.abrev,b.id_ubitecnica into v_ubitec,n_id_ubitecnica from vtatabslcfac a, operacion.ubi_tecnica b,solot c
    where a.codubired=b.codubired and a.numslc=c.numslc and c.codsolot=an_codsolot;
    select count(1) into n_val_pry_anio
    from operacion.proyecto_sap --validar si existe pry SITES de ubitec en sap
    where ubitecnica=v_ubitec and tiproy in (TIPROY_WM1) and procesado='S' and anio= f_get_anio;
  end if;

  if f_get_tiproy(an_codsolot) IN (TIPROY_HFC) then--Validar si se tienen PRYs de HEADEND en el año 5.0
    --INI 6.0
    select a.codigon
    into   n_tipo_sga
    from   OPERACION.OPEDD A, OPERACION.TIPOPEDD B
    WHERE  A.TIPOPEDD=B.TIPOPEDD AND B.ABREV='SINTIPUBITEC' AND A.DESCRIPCION='HEADEND';
    --7.0
    select b.abrev,b.id_ubitecnica into v_ubitec,n_id_ubitecnica
    from operacion.ubi_tecnica b, solot c, vtatabslcfac d
    where  b.tipo_sga=n_tipo_sga and c.numslc= d.numslc and d.ubitecnica=b.abrev
    and c.codsolot=an_codsolot;

    --FIN 6.0
    select count(1) into n_val_pry_anio
    from operacion.proyecto_sap --validar si existe pry SITES de ubitec en sap
    where ubitecnica=v_ubitec and tiproy in (TIPROY_HFC) and procesado='S' and anio= f_get_anio;
  end if;

  if (v_val_pry='S' and n_cont_pry=0) or (n_val_pry_anio=0) then --HFCs or NOP nuevos en el año
    if an_idubitecnica =0 then--Si no se envia la UBITEC se intenta generar o identificar
      if n_id_ubitecnica is null then--puedes venir el idubitec de NOP hubs
        p_crea_ubi_tecnica(an_codsolot,n_id_ubitecnica); --Generar o identificar UT
      end if;
    else--Si se envia el id UBITEC se genera directo el proyecto
      n_id_ubitecnica:=an_idubitecnica;
    end if;
    if n_id_ubitecnica>0 then--Si se genera o existe una UT valida
      for r_pry in cur_prys loop--Listado para Generar Proyectos
        begin
          --Identificar informacion de parametros de tipo de proyecto
          select * into t_tiproy from operacion.tiproy_sinergia a where a.tiproy= r_pry.tiproy;
          begin --27.0
            select tipo_sga into n_tipo_ut from operacion.Ubi_Tecnica where id_ubitecnica=n_id_ubitecnica;
            if n_tipo_ut=1 then--UT HUBS FTTH Y HFC
              select a.abrev,b.id_sitio_sap,f_cadena(a.abrev,'-',2),a.idplano,a.descripcion,b.id_sitio,b.manparno
              into v_ubitecnica,v_id_sitio_sap,v_region,v_idplano,v_desubitec,n_id_sitio,v_manparno
              from operacion.ubi_tecnica a, operacion.id_sitio b
              where a.id_ubitecnica=b.id_ubitecnica and a.id_ubitecnica=n_id_ubitecnica
              and DECODE(t_tiproy.claseproy,'J','F','H')|| substr(a.id_hub_sap,2)= b.manparno;
            else
              select a.abrev,b.id_sitio_sap,f_cadena(a.abrev,'-',2),a.idplano,a.descripcion,b.id_sitio,b.manparno
              into v_ubitecnica,v_id_sitio_sap,v_region,v_idplano,v_desubitec,n_id_sitio,v_manparno
              from operacion.ubi_tecnica a, operacion.id_sitio b
              where a.id_ubitecnica=b.id_ubitecnica and a.id_ubitecnica=n_id_ubitecnica
              and ((b.equicatgry is null and rownum=1) or
                   (b.equicatgry is not null
                   and b.equicatgry= decode(f_get_tiproy(an_codsolot),TIPROY_ORA,'F',TIPROY_OR1,'F',TIPROY_WM1,'W',TIPROY_WMX,'W' ) ) );
             end if;


          exception
            when no_data_found then
              select a.abrev,null id_sitio_sap,f_cadena(a.abrev,'-',2),a.idplano,a.descripcion,null id_sitio,null manparno
              into v_ubitecnica,v_id_sitio_sap,v_region,v_idplano,v_desubitec,n_id_sitio,v_manparno
              from operacion.ubi_tecnica a
              where a.id_ubitecnica=n_id_ubitecnica and f_get_tiproy(an_codsolot) = TIPROY_AFO;
          end;


          if t_tiproy.flag_masivo=0 then
            begin
              select substr(a.nomcli,1,40),a.codcli,c.nombre,e.descripcion
              into v_descripcion,v_codcli,v_responsable,v_solicitante
              from vtatabcli a,customer_atention b,usuarioope c, vtatabslcfac d,areaope e
              where a.codcli=b.customercode(+)  and b.codccareuser=c.usuario(+) and a.codcli=d.codcli
              and d.area=e.area and d.numslc =v_numslc;
            exception
              when others then
                n_error := sqlcode;
                v_error:='Datos Invalidos Proyecto:'||v_numslc||'-'||sqlerrm;
            end;
          else
              if t_tiproy.claseproy = 'H' or
                 t_tiproy.claseproy = C_CLASE_PROY_FUS then--25.0
                --HFC se agrega el id_sitio o plano
              v_descripcion:=Substr(t_tiproy.destiproy|| ' ' ||v_idplano,1,40); -- 7.0
            else
              v_descripcion:=substr(v_desubitec||' -REGION- '|| v_region,1,40); -- 7.0
            end if;
          end if;
          if f_get_tiproy(an_codsolot) = TIPROY_AFO  then--Asignar ID_SITIO_SAP Correcto
            select c.id_sitio_sap,c.id_sitio,c.manparno--10.0
            into v_id_sitio_sap,n_id_sitio,v_manparno
            from solot a,solotpto b , operacion.id_sitio c
            where a.codsolot=b.codsolot and a.codsolot=an_codsolot and rownum =1
            and b.cid is not null and b.cid=c.cid ;
          end if;
          if f_get_tiproy(an_codsolot) IN( TIPROY_PEH,TIPROY_FTN)  then--Si es proyecto de COnstruccion de Planos --21.0
            v_descripcion:=substr('CONSTRUCCION-INSTAL NODO : '||v_idplano,1,40); -- 7.0
          end if;

          v_grupopry:= t_tiproy.tipored||'-'||t_tiproy.soc_fi||v_region||t_tiproy.claseproy||v_periodo;--'RFPE02AK140001';
          begin --26.0
            select nvl(MAX(to_number(substr(proyecto,12,4))),0)+1 into n_idseqsap
            from operacion.proyecto_sap
            where substr(proyecto,1,11)= v_grupopry ;
          exception
            when no_data_found then
              n_idseqsap:=1;
            when others then
              n_idseqsap:=1;
          end;
          --26.0
          select count(1) into n_val_nuevo_seq from tipopedd where abrev='SINERGIANUEVOSEQPRY';
          if n_val_nuevo_seq =0 then
            v_proyecto:=v_grupopry||lpad( n_idseqsap,4,'0');
          else
            select count(1)+1 into n_idseqsap
            from operacion.proyecto_sap
            where substr(proyecto,1,11)= v_grupopry ;
            select v_grupopry||operacion.pq_sinergia.F_Convertbase26(n_idseqsap,4) into v_proyecto from dual;
          end if;

          v_ceco_sol:=replace(t_tiproy.ceco_sol,'@',substr(v_ubitecnica,4,1));
          v_cebe:= substr(v_ceco_sol,3);
          v_fecha :=  to_date('0101'||to_char(to_number(to_char(sysdate,'yyyy')) - 1),'ddmmyyyy') ;
          Select OPERACION.sq_idproyecto.nextval into n_idproyecto From DUMMY_OPE;

          v_fecha_ini := to_char(v_fecha,'yyyymmdd');
          v_fecha_fin := to_char(v_fecha+180,'yyyymmdd');

          insert into operacion.proyecto_sap(idproyecto,proyecto,perfil,descripcion,fecini,cebe,proyecto_1,descripcion_1,
          clase_proy,prioridad,ceco_pep,ubitecnica,
          ceco_solic,ceco_resp,id_sitio,tipo_red,
          rubroinv,tiproy,tiproy_sap,anio,codcli,numslc,codsolot,id_ubitecnica,
          id_sitio_sap,soc_fi,soc_co,clase_activo,manparno)
          values(n_idproyecto,v_proyecto,t_tiproy.perfilproy,nvl(v_descripcion,t_tiproy.destiproy),v_fecha_ini,v_cebe,v_proyecto,nvl(v_descripcion,t_tiproy.destiproy),
         t_tiproy.claseproy,3,null,v_ubitecnica,
          v_ceco_sol ,t_tiproy.ceco_res,n_id_sitio,t_tiproy.tipored,
          null,t_tiproy.Tiproy,t_tiproy.Tiproy_Sap,f_get_anio,v_codcli,v_numslc,an_codsolot,n_id_ubitecnica,
          v_id_sitio_sap,t_tiproy.soc_fi,t_tiproy.soc_co,t_tiproy.clase_activo,nvl(v_cid,v_manparno));
          commit;
          WEBSERVICE.PQ_WS_SINERGIA.P_CREA_PROYECTO(n_idproyecto,n_error,v_error);
          IF n_error < 0 THEN
            v_error := 'Crear Proyecto: ' || v_error;
            RAISE err;
          else
            p_reg_log('Genera_Proyecto.',0,'Se generó Proyecto SAP : ' || t_tiproy.Tiproy || ' - ' || v_proyecto,v_numslc,an_codsolot,n_id_ubitecnica,null,null);
          END IF;
        exception
          WHEN err THEN
            p_reg_log('Genera_Proyecto.',n_error,v_error,v_numslc,an_codsolot,n_id_ubitecnica,null,null);
          when others then
            n_error := sqlcode;
            v_error:='Proyecto_:'||v_numslc||'-'||sqlerrm;
            p_reg_log('Genera_Proyecto',sqlcode,v_error,v_numslc,an_codsolot,n_id_ubitecnica,null,null);
        end;
      end loop;
    else
      v_error := 'No se generó ubicación Tecnica valida.';
      RAISE err;
    end if;
  end if;

  p_crea_pep2(an_codsolot);

exception
  WHEN err THEN
    p_reg_log('Genera_Proyecto',n_error,v_error,null,an_codsolot,n_id_ubitecnica,null,null);
  when others then
    v_error:='Generar Proyecto :' || sqlerrm;
    p_reg_log('Genera_Proyecto .',sqlcode,v_error,null,an_codsolot,n_id_ubitecnica,null,null);
END;

procedure p_crea_pep2(an_codsolot in number)
IS
v_error varchar2(400);
n_error number;
n_idpep number;
v_pep2 operacion.pep.pep%type;
v_rubroinv operacion.tiproy_sinergia_pep.rubroinv%type;
err EXCEPTION;
t_tiproy operacion.tiproy_sinergia%rowtype;
v_proyecto operacion.pep.proyecto%type;
v_idplano vtatabgeoref.idplano%type;
n_val_pep2 number;
n_existe_pep2_nophub number;
n_idhub vtatabgeoref.idhub%type;
n_codubired number;
n_tipo_sga number; --7.0
l_ubitecnica vtatabslcfac.ubitecnica%type; -- 7.0
cursor c_pep2 is --PEPs2 a crearse por Proyecto
  select distinct b.rubroinv rubro_inv,a.codsolot,a.proyecto,a.perfil,a.ubitecnica,a.anio,b.id_seq,b.id_seq_pad,
  b.clase_activo,a.id_sitio_sap,a.tipo_red,a.clase_proy,a.descripcion, nvl(b.ceco_res,a.ceco_resp)  ceco_resp ,
  a.ceco_solic,a.cebe,b.crea_pepn2,
  B.DESCRIPCION DESCPEP2,a.manparno
  from operacion.proyecto_sap a, operacion.tiproy_sinergia_pep b
  where ((a.codsolot=an_codsolot) or a.proyecto=v_proyecto) and a.procesado='S' and b.nivel=2 and b.estado=1
  and ( DECODE(operacion.pq_sinergia.f_get_tiproy(an_codsolot),TIPROY_CVE,A.TIPROY,operacion.pq_sinergia.f_get_tiproy(an_codsolot)) =b.tiproy)
  order by b.id_seq desc;
Begin
  select * into t_tiproy from operacion.tiproy_sinergia where tiproy= f_get_tiproy(an_codsolot);
  if f_get_tiproy(an_codsolot)=TIPROY_AFO then
    select distinct d.proyecto into v_proyecto
    from solot a,solotpto b , operacion.id_sitio c,operacion.proyecto_sap d
    where a.codsolot=b.codsolot and a.codsolot=an_codsolot and rownum =1 and d.procesado='S'
    and b.cid is not null and b.cid=c.cid and c.manparno=d.manparno and anio=f_get_anio;
  end if;
  if t_tiproy.crea_proyecto =0 then--no se ha generado proyecto se busca proyecto padre SAP
    if t_tiproy.tiproy IN (TIPROY_NOP,TIPROY_NO3, TIPROY_FTO /*TIPROY_NO4 , TIPROY_FT4*/  ) then--Necesidad Operacional Plano --26.0
      select replace(replace(trim(idplano),'Ñ','N'),'-','_') into v_idplano from vtatabslcfac a, solot b--8.0
      where a.numslc=b.numslc and b.codsolot=an_codsolot;
      begin--Identificar si existe un proyecto para esta ubicacion tecnica
        select a.proyecto into v_proyecto from operacion.proyecto_sap a, operacion.ubi_tecnica b
        where a.ubitecnica=b.abrev and b.idplano=v_idplano
        and a.tiproy in (TIPROY_PEH,TIPROY_CHF, TIPROY_FTN) --21.0
        and b.procesado='S' and a.procesado='S' and a.anio=f_get_anio and
            rownum = 1; -- 7.0;
      Exception
        when no_data_found then
          v_error:='No existe ningun proyecto implementado en este plano este año, solicitar la generacion de proyecto.';
          RAISE err;
      end;
    elsif t_tiproy.tiproy in (TIPROY_NO1,TIPROY_NO2,TIPROY_NO4,TIPROY_FT4,TIPROY_FT5) then--Necesidad Operacional HUBs   26.0 30.0
      select idhub into n_idhub from vtatabslcfac a, solot b
      where a.numslc=b.numslc and b.codsolot=an_codsolot;
      begin--Identificar si existe un proyecto de HUB para esta ubicacion tecnica
        select a.proyecto into v_proyecto from operacion.proyecto_sap a, operacion.ubi_tecnica b
        where a.ubitecnica=b.abrev and b.idhub=n_idhub
        and a.tiproy_sap in (TIPROY_HUS,TIPROY_NOP,TIPROY_NO3,TIPROY_NO4, TIPROY_FTO, TIPROY_PIG , TIPROY_FUS)
        and a.clase_proy=t_tiproy.claseproy
        and b.procesado='S' and a.procesado='S' and a.anio=f_get_anio;
      Exception
        when no_data_found then
          v_error:='No existe ningun proyecto implementado en este HUB este año, solicitar la generacion de proyecto.';
          RAISE err;
      end;
    elsif t_tiproy.tiproy=TIPROY_HFC then--Necesidad Operacional HEADEND 5.0
      begin--Identificar si existe un proyecto de HUB para esta ubicacion tecnica
        --INI 7.0
        select a.codigon
        into   n_tipo_sga
        from   OPERACION.OPEDD A, OPERACION.TIPOPEDD B
        WHERE  A.TIPOPEDD=B.TIPOPEDD AND B.ABREV='SINTIPUBITEC' AND A.DESCRIPCION='HEADEND';

        SELECT v.ubitecnica
        INTO l_ubitecnica
        FROM vtatabslcfac v, solot s
        WHERE v.numslc = s.numslc and
              s.codsolot = an_codsolot and
              rownum = 1;

        select a.proyecto into v_proyecto from operacion.proyecto_sap a, operacion.ubi_tecnica b
        where a.ubitecnica=b.abrev
        and a.tiproy_sap =TIPROY_HFC and b.tipo_sga=n_tipo_sga
        and b.procesado='S' and a.procesado='S' and a.anio=f_get_anio
        and a.ubitecnica = l_ubitecnica;
        -- FIN 7.0
        Exception
        when no_data_found then
          v_error:='No existe ningun proyecto implementado el HEADEND este año, solicitar la generacion de proyecto.';
          RAISE err;
      end;
    elsif t_tiproy.tiproy=TIPROY_OR1 or t_tiproy.tiproy=TIPROY_WM2 then--Necesidad Operacional Sites
      select codubired into n_codubired from vtatabslcfac a, solot b
      where a.numslc=b.numslc and b.codsolot=an_codsolot;
      begin--Identificar si existe un proyecto de HUB para esta ubicacion tecnica
        if t_tiproy.tiproy=TIPROY_OR1 then
          select a.proyecto into v_proyecto from operacion.proyecto_sap a, operacion.ubi_tecnica b
          where a.ubitecnica=b.abrev and b.codubired=n_codubired
          and a.tiproy in (TIPROY_ORA)
          and b.procesado='S' and a.procesado='S' and a.anio=f_get_anio;
        end if;
        if t_tiproy.tiproy=TIPROY_WM2 then
          select a.proyecto into v_proyecto from operacion.proyecto_sap a, operacion.ubi_tecnica b
          where a.ubitecnica=b.abrev and b.codubired=n_codubired
          and a.tiproy in (TIPROY_WM1)
          and b.procesado='S' and a.procesado='S' and a.anio=f_get_anio;
        end if;
      Exception
        when no_data_found then
          v_error:='No existe ningun proyecto implementado en este HUB este año, solicitar la generacion de proyecto.';
          RAISE err;
      end;
    end if;
  end if;

  for c_p in c_pep2 loop
    select count(1) into n_existe_pep2_nophub from operacion.tiproy_sinergia_pep a, operacion.pep b
    where a.nivel=2 and a.rubroinv=c_p.rubro_inv
    and a.id_seq=b.id_seq and b.proyecto=v_proyecto
    AND a.tiproy in (TIPROY_HUS,TIPROY_NO1,TIPROY_NO2,TIPROY_PEH,TIPROY_NOP,TIPROY_NO3,TIPROY_NO4,
    TIPROY_CHF,TIPROY_ORA,TIPROY_WM1,TIPROY_AFO, TIPROY_FTO, TIPROY_FTN, TIPROY_FT4 , TIPROY_FUS);--6.0 --21.0 --24.0

    if c_p.crea_pepn2=0 and n_existe_pep2_nophub=1 then--Existe Pry este año se genera solo pepn3
      if  t_tiproy.tiproy IN (TIPROY_NOP,TIPROY_NO3, TIPROY_FTO/*, TIPROY_FT4*/) then--Necesidad Operacional Plano --26.0
       select b.idpep into n_idpep from operacion.tiproy_sinergia_pep a, operacion.pep b
        where  a.nivel=2 and a.rubroinv=c_p.rubro_inv and a.id_seq=b.id_seq
        and b.proyecto=v_proyecto and a.tiproy  in (TIPROY_PEH,TIPROY_CHF, TIPROY_FTN) ;--21.0
      elsif t_tiproy.tiproy in(TIPROY_NO1,TIPROY_NO2,TIPROY_NO4,TIPROY_FT4,TIPROY_FT5) then--Necesidad Operacional HUBs  26.0  30.0
        select b.idpep into n_idpep from operacion.tiproy_sinergia_pep a, operacion.pep b
        where a.nivel=2 and a.rubroinv=c_p.rubro_inv and a.id_seq=b.id_seq
        and b.proyecto=v_proyecto AND a.tiproy  in (TIPROY_HUS,TIPROY_NO1,TIPROY_NO2,TIPROY_NO4, TIPROY_FUS, TIPROY_FT4, TIPROY_FT5); --24.0 26.0 30.0
      elsif t_tiproy.tiproy=TIPROY_HFC then--Necesidad Operacional HEADEND 5.0
        select b.idpep into n_idpep from operacion.tiproy_sinergia_pep a, operacion.pep b
        where a.nivel=2 and a.rubroinv=c_p.rubro_inv and a.id_seq=b.id_seq
        and b.proyecto=v_proyecto AND a.tiproy  =TIPROY_HFC;
      elsif t_tiproy.tiproy in (TIPROY_OR1,TIPROY_WM2) then--Necesidad Operacional SITEs
        select b.idpep into n_idpep from operacion.tiproy_sinergia_pep a, operacion.pep b
        where a.nivel=2 and a.rubroinv=c_p.rubro_inv and a.id_seq=b.id_seq
        and b.proyecto=v_proyecto AND a.tiproy  in (TIPROY_ORA,TIPROY_WM1);
      elsif t_tiproy.tiproy in (TIPROY_AFO) then--Necesidad Operacional Corporativo
        select b.idpep into n_idpep from operacion.tiproy_sinergia_pep a, operacion.pep b
        where a.nivel=2 and a.rubroinv=c_p.rubro_inv and a.id_seq=b.id_seq
        and b.proyecto=v_proyecto AND a.tiproy  in (TIPROY_AFO) and b.procesado='S';--10.0
      end if;
    else --Si crea PEPN2
      select count(1) into n_val_pep2 from operacion.pep
      where proyecto=v_proyecto and id_seq=c_p.id_seq;-- and procesado='S';
      if n_val_pep2=0 then
        v_rubroinv:=c_p.rubro_inv;
        v_pep2:=c_p.proyecto||'-'||v_rubroinv;
        Select OPERACION.SQ_IDPEP.nextval into n_idpep FROM DUMMY_OPE;
        insert into operacion.pep(IDPEP,proyecto,ceco_solic,anio,ceco_resp,pep,descripcion,claseproy,prioridad,rubroinv,nivel,tipo_red,
        ubitecnica,id_sitio_sap,codsolot,clase_activo,ID_SEQ,id_seq_PAD,tiproy,manparno)
        values(n_idpep,c_p.proyecto,c_p.ceco_solic,c_p.anio,c_p.ceco_resp,v_pep2,c_p.DESCPEP2,c_p.clase_proy,3,
        c_p.tipo_red||'-'||c_p.rubro_inv,2,c_p.tipo_red,
        c_p.ubitecnica,c_p.Id_Sitio_Sap,an_codsolot,c_p.clase_activo,C_P.ID_SEQ,C_P.ID_SEQ_PAD,t_tiproy.tiproy,c_p.manparno);
        commit;
        WEBSERVICE.PQ_WS_SINERGIA.P_CREA_PEP2(n_idpep,n_error,v_error);
        IF n_error < 0 THEN
          v_error := 'PEP2: ' || v_error || ' Error WS';
          RAISE err;
        else
          p_reg_log('Genera_PEP2.',0,'Se generó PEP2 SAP : ' || v_pep2,null,an_codsolot,null,null,null);
        END IF;
        commit;
      else
        select idpep into n_idpep from operacion.pep
        where proyecto=v_proyecto and id_seq=c_p.id_seq;
      end if;
    end if;
    p_crea_pep3(an_codsolot,n_idpep);
  end loop;

exception
  WHEN err THEN
    p_reg_log('Crear PEP2.',n_error,v_error,null,an_codsolot,null,null,null);
  when others then
    v_error:='PEP2:'|| '-' || sqlerrm || '(Base Datos)';
    p_reg_log('Crear PEP2',sqlcode,v_error,null,an_codsolot,null,null,null);
END;

procedure p_crea_pep3(an_codsolot in number,an_idpep in number)
IS
v_error varchar2(400);
n_error number;
n_idpep number;
v_pep2 operacion.pep.pep%type;
v_pep3 operacion.pep.pep%type;
v_rubroinv operacion.tiproy_sinergia_pep.rubroinv%type;
v_seq_pep3 varchar2(2);
n_idseqpep number;
n_id_seq number;
t_tiproy operacion.tiproy_sinergia%rowtype;
n_id_seq_nop number;
n_valida_pep3 number;
err EXCEPTION;
cursor c_pep2 is
  select a.tiproy,a.pep,a.id_seq,a.idpep,a.cebe,a.proyecto,a.id_sitio_sap,a.ubitecnica,a.tipo_red,a.anio,a.claseproy,
  b.ceco_resp,b.ceco_solic,b.numslc pry,b.id_ubitecnica,a.manparno
  from operacion.pep a,operacion.proyecto_sap b
  where a.proyecto=b.proyecto and a.idpep=an_idpep;
cursor c_pep3 is
  select id_seq,rubroinv,consecutivo,tiproy,asigna_sot_pepn3,id_Seq_pad,crea_grafo,tipoproyecto,
  area,clasif_obra,clase_Activo,Naturaleza_Pep,descripcion,ceco_res,ceco_sol,genera_reserva
  from operacion.tiproy_sinergia_pep
  where  id_seq_pad = n_id_seq
  and nivel=3 and estado=1 order by 1 desc;
v_tiproy varchar2(30);
Begin
  for c_p in c_pep2 loop
    v_tiproy:=c_p.tiproy;
    select * into t_tiproy from operacion.tiproy_sinergia where tiproy=c_p.tiproy;
    v_pep2:=c_p.pep;

    if f_get_tiproy(an_codsolot) IN (TIPROY_NOP,TIPROY_NO3, TIPROY_FTO) then--Si es NOP Plano tomar el de NOP--21.0 26.0
      select id_seq_hijo_nop into n_id_seq_nop from operacion.tiproy_sinergia_pep where id_seq=c_p.id_seq;
      n_id_seq:=nvl(n_id_seq_nop,c_p.id_seq);
    elsif f_get_tiproy(an_codsolot) in (TIPROY_NO1,TIPROY_NO2,TIPROY_NO4,TIPROY_FT4,TIPROY_FT5) then--Si es NOP HUBs 26.0 30.0
      select a.id_seq into n_id_seq from operacion.tiproy_sinergia_pep a
      where a.tiproy=OPERACION.PQ_SINERGIA.f_get_tiproy(an_codsolot) and a.nivel=2;
    elsif f_get_tiproy(an_codsolot) in (TIPROY_HFC) then--Si es NOP HEADEND
      select a.id_seq into n_id_seq from operacion.tiproy_sinergia_pep a
      where a.tiproy=OPERACION.PQ_SINERGIA.f_get_tiproy(an_codsolot) and a.nivel=2;
    elsif f_get_tiproy(an_codsolot) in (TIPROY_OR1,TIPROY_WM2)  then--Si es NOP Site
      select a.id_seq into n_id_seq from operacion.tiproy_sinergia_pep a
      where a.tiproy=f_get_tiproy(an_codsolot) and a.nivel=2;
    else
      n_id_seq:=c_p.id_seq;
    end if;
    for c_p3 in c_pep3 loop
      select count(1) into n_valida_pep3 from operacion.pep
      where codsolot=an_codsolot and nivel=3 and id_seq=c_p3.id_seq and procesado='S' and proyecto = c_p.proyecto; -- 5.0
      if n_valida_pep3=0 then--Valida si existe el PEP3 de la plantilla por el proyecto
        v_rubroinv:=c_p3.rubroinv;
        Select OPERACION.SQ_IDPEP.nextval into n_idpep FROM DUMMY_OPE;
        if c_p3.consecutivo is null then
          begin
            select nvl(MAX(to_number(substr(pep,23,2))),0)+1 INTO n_idseqpep
            from operacion.pep
            where idpep_pad=c_p.idpep and substr(pep,1,22)= c_p.pep ||'-'||c_p3.tiproy
            and isnumber(substr(pep,23,2)) =1 and nivel=3 and procesado='S';
          exception
            when no_data_found then
              n_idseqpep:=1;
            when others then
              n_idseqpep:=1;
          end;
          SELECT  lpad(n_idseqpep,2,'0') into v_seq_pep3 from dual;
        else
         v_seq_pep3:=c_p3.consecutivo;
        end if;
        v_pep3:=v_pep2||'-'||c_p3.tiproy||v_seq_pep3;
        insert into operacion.pep(IDPEP,ceco_solic,ceco_resp,pep,descripcion,claseproy,prioridad,elem_plan,elem_imputacion,
        rubroinv,naturaleza_pep,anio,nivel,tipo_red,ubitecnica,codsolot,clase_activo,clasif_obra,
        id_sitio_sap,proyecto,area,TIPOPROYECTO,crea_grafo,cebe,id_seq,id_seq_pad,idpep_pad,asigna_sot_pepn3,genera_reserva,manparno)
        values(n_idpep,c_p.ceco_solic,
        c_p3.ceco_res,v_pep3,c_p3.descripcion,
        c_p.claseproy,3,'X','X',c_p3.rubroinv,c_p3.Naturaleza_Pep,c_p.anio,3,c_p.tipo_red,
        c_p.ubitecnica,an_codsolot,c_p3.clase_Activo,
        c_p3.clasif_obra,c_p.id_sitio_sap,c_p.proyecto,c_p3.area,c_p3.tipoproyecto,c_p3.crea_grafo,
        c_p.cebe,c_p3.id_seq,c_p3.id_Seq_pad,an_idpep,c_p3.asigna_sot_pepn3,c_p3.genera_reserva,c_p.manparno);
        commit;
        WEBSERVICE.PQ_WS_SINERGIA.P_CREA_PEP3(n_idpep,n_error,v_error);
        if n_error < 0 then
          v_error := 'PEP3: ' || v_error;
          RAISE err;
        else
          p_reg_log('Genera_PEP3.',0,'Se generó PEP3 SAP : ' || v_pep3,c_p.pry,an_codsolot,c_p.id_ubitecnica,null,null);
        end if;
      end if;
    end loop;
  end loop;

exception
  WHEN err THEN
    p_reg_log('Crear PEP3.',n_error,v_error,null,an_codsolot,null,null,null);
  when others then
    v_error:='PEP3-:'|| '-' || sqlerrm || '-' || to_char(an_idpep);
    p_reg_log('Crear PEP3',sqlcode,v_error,null,an_codsolot,null,null,null);
END;

procedure p_ppto_sap(an_codsolot in number,an_tipo number default 0)
IS
v_error varchar2(400);
n_error number;
err EXCEPTION;
cursor c_ut is
select a.id_sitio from operacion.id_Sitio a, operacion.ubi_tecnica  b
where a.id_ubitecnica=b.id_ubitecnica and b.tipo_sga=2 and a.estado='E0001'
and a.procesado='S' and b.procesado='S';
begin
  insert into OPERACION.CONTROL_DESCARGA(tipo) values('DES_INI');
  commit;
  for c in c_ut loop
    update OPERACION.ID_SITIO set estado='E0002' where   id_Sitio=c.id_Sitio;
    operacion.pq_sinergia.p_act_id_sitio(c.id_Sitio,'E0002');     
  end loop;
  insert into OPERACION.CONTROL_DESCARGA(tipo) values('DES_FIN');
  
exception
  WHEN err THEN
    p_reg_log('Presupuesto .',n_error,v_error,null,null,null,null,null);
  when others then
    v_error:='Presupuesto:'|| to_char(1) ||'-'||sqlerrm;
    p_reg_log('Presupuesto_',sqlcode,v_error,null,null,null,null,null);
END;

procedure p_ppto_reserva(an_codsolot number,an_tran_solmat number)
IS
v_error varchar2(400);
n_error number;
err EXCEPTION;
n_idppto number;
n_codsolot number;
n_idloteppto number;
v_proveedor_sap contrata.proveedor_sap%type;
n_id_res number;
--Reservas de Clientes


cursor c_reserva is
select distinct a.id_res,a.numreserva,a.pep,b.centro,b.almacen
from operacion.reserva_cab a, operacion.reserva_det b
where tran_solmat=an_tran_solmat and codsolot=an_codsolot and a.id_res=b.id_res;
cursor c_reserva_ppto is
select sum(a.cantidad*(nvl(b.preprm,(b.preprm_usd*operacion.pq_Sinergia.f_get_ratio_tc('USD', 'PEN'))))) monto
from operacion.reserva_det a ,almtabmat b
where a.id_res=n_id_res and a.clase_val='VALORADO' and trim(a.material)=trim(b.cod_sap);

Begin

  for c_r in c_reserva loop
    n_id_res:=c_r.id_res;
    for c_d in c_reserva_ppto loop
      if c_d.monto>0 then
        select OPERACION.SQ_IDPPTO.NEXTVAL into n_idppto from dual;
        select operacion.SQ_IDLOTEPPTO.nextval into n_idloteppto from dummy_ope;
        insert into operacion.Trs_Ppto(idppto, TIPO,total_pep,idloteppto,codsolot,proveedor_sap,pep,
        centro,almacen,numreserva)
        VALUES(n_idppto,3,c_d.monto,n_idloteppto,an_codsolot,v_proveedor_sap,c_r.pep,
        c_r.centro,c_r.almacen,c_r.numreserva);
        update solotptoequ set idppto=n_idppto where codsolot=an_codsolot
        and idppto is null and nro_res =c_r.numreserva;
        WEBSERVICE.PQ_WS_SINERGIA.P_PPTO_SGA(n_idloteppto,n_error,v_error);
        IF n_error < 0 THEN
          v_error := 'Presupuesto:' || v_error;
          RAISE err;
        else
          p_reg_log('PresupuestoRes',0, 'Se envia a Presupuesto ' || to_char(n_codsolot),null,n_codsolot,null,null,null);
        END IF;
      else
        p_reg_log('PresupuestoRes',0, 'No se envia a presupuesto, el Costo de reserva es 0.' ,null,n_codsolot,null,null,null);
      end if;
    end loop;
  end loop;

exception
  WHEN err THEN
    p_reg_log('Presupuesto .',n_error,v_error,null,null,null,null,null);
  when others then
    v_error:='Presupuesto:'|| to_char(1) ||'-'||sqlerrm;
    p_reg_log('Presupuesto_',sqlcode,v_error,null,null,null,null,null);
END;


procedure p_act_ppto_sga(av_agrupador_ppto in varchar2,
  av_idppto in varchar2,av_reserva in varchar2,av_proveedor in varchar2, av_pep in varchar2,
  av_sot in varchar2,av_documento in varchar2,av_ppto_error in varchar2,av_respuesta out varchar2)
IS
v_error varchar2(400);
n_error number;
err EXCEPTION;
t_trs_ppto operacion.trs_ppto%rowtype;
v_subcadena VARCHAR2(4000);
n_cont number;
n_idppto number;
n_idseq number;
/** 23.0 Para Liquidaciones **/
P_VALOR char(1); -- 23.0
n_numero_lote number;
ERROR_VALOR EXCEPTION; -- 23.0
resp_temp varchar2(10); --23.0

Begin
  SELECT SUBSTR(av_agrupador_ppto,1,1) INTO P_VALOR FROM DUAL; -- 23.0
  IF P_VALOR='L' THEN  -- 23.0
      /*Inicia Nuevo Proceso*/
      select count(1) into n_numero_lote from AGENLIQ.SGAT_ACT_PEPSAP
        WHERE APEPV_AGRUPADOR = AV_AGRUPADOR_PPTO;
      if n_numero_lote > 0 then
          Update AGENLIQ.SGAT_LOTE_MATEQU
             set LOMCN_FLG_INI_LOG = 1
           where LOMCN_IDLOTE = ( select LOMCN_IDLOTE --INTO NRO_LORTE
                                    from AGENLIQ.SGAT_ACT_PEPSAP
                                   WHERE APEPV_AGRUPADOR = AV_AGRUPADOR_PPTO and rownum = 1 );

          INSERT INTO AGENLIQ.SGAT_LOGMATEQU
             (LOGPN_IDLOG, LOGPV_AGRUPADOR_PPTO, LOGPV_RESERVA, LOGPV_PROVEEDOR, LOGPV_PEP, LOGPN_CODSOLOT,LOGPV_DOCUMENTO,LOGPV_MSJ_SAP)
             VALUES
             (AGENLIQ.SGASEQ_LOGMATEQU.NEXTVAL ,AV_AGRUPADOR_PPTO, AV_RESERVA, AV_PROVEEDOR ,AV_PEP,AV_SOT,AV_DOCUMENTO,AV_PPTO_ERROR);
             -- AV_IDPPTO,
          Update AGENLIQ.SGAT_LOTE_MATEQU
             set LOMCN_FLG_FIN_LOG = 1
           where LOMCN_IDLOTE = ( select LOMCN_IDLOTE --INTO NRO_LORTE
                                    from AGENLIQ.SGAT_ACT_PEPSAP
                                   WHERE APEPV_AGRUPADOR = AV_AGRUPADOR_PPTO and rownum = 1 );

           resp_temp := 'S';
      else
        resp_temp := 'NO DATA'  ;
      end if;

      commit;
      av_respuesta :=resp_temp;
      /* 23.0 Fin Nuevo Proceso*/
  ELSE /* Logica anterior */
  Select OPERACION.SQ_TRS_PPTO_LOG.nextval into n_idseq From DUMMY_ope;
  insert into  OPERACION.TRS_PPTO_LOG(IDSEQ,AGRUPADOR_PPTO,IDPPTO,RESERVA,PROVEEDOR,PEP,
  CODSOLOT,DOCUMENTO,PPTO)
  values(n_idseq,av_agrupador_ppto,av_idppto,av_reserva,av_proveedor,av_pep,av_sot,av_documento,av_ppto_error);
  if av_reserva is not null then
    update operacion.trs_ppto set RESPUESTA_SAP =av_agrupador_ppto ,documento=av_documento,
    mensaje_sap=av_ppto_error  where to_number(numreserva)= av_reserva;
  else
    n_cont:= 1;
    v_subcadena := f_cadena(av_idppto, '|', n_cont);
    while (v_subcadena IS NOT NULL) loop
      if  av_reserva is null then --Materiales o Equipo
        n_idppto:=substr(f_cadena(av_idppto, '|', n_cont),2);
      else--Reserva
        if f_cadena(av_reserva, '|', n_cont) is null then
          n_idppto:=substr(f_cadena(av_idppto, '|', n_cont),2);
        else
          select idppto into n_idppto from operacion.trs_ppto where numreserva=substr(f_cadena(av_reserva, '|', n_cont),2);
        end if;
      end if;
      update operacion.trs_ppto set RESPUESTA_SAP =av_agrupador_ppto ,documento=f_cadena(nvl(av_documento,' '), '|', n_cont),
      mensaje_sap= f_cadena(nvl(av_ppto_error,' '), '|', n_cont)  where idppto=n_idppto;

      select * into t_trs_ppto from operacion.trs_ppto where idppto= n_idppto;
      --TIPO= 1= Servicios, 2= Consumo, 3= Reserv
      if t_trs_ppto.tipo=1 then --Mano de Obra
        null;
      end if;
      if t_trs_ppto.tipo=2 then --Equipo
        null;
      end if;

      n_cont:= n_cont + 1;
      v_subcadena:= f_cadena(av_idppto, '|', n_cont);
    end loop;
  end if;
  commit;
  av_respuesta:='S';
  END IF; --23.0
exception
  WHEN err THEN
    p_reg_log('Presupuesto.',n_error,v_error,null,null,null,null,null);
  when others then
    v_error:='Presupuesto:'|| to_char(1) ||'-'||sqlerrm;
    p_reg_log('Presupuesto.',sqlcode,v_error,null,null,null,null,null);
END;


procedure p_reenviar_ppto(an_idloteppto in number)
IS
v_error varchar2(400);
n_error number;
err EXCEPTION;
t_trs_ppto operacion.trs_ppto%rowtype;
n_tipo number;
cursor c_ppto is
select * from operacion.trs_ppto where idloteppto=an_idloteppto;
Begin
  select tipo into n_tipo from operacion.trs_ppto where idloteppto=an_idloteppto and rownum=1;
  if n_tipo=3 then --Reserva
    WEBSERVICE.PQ_WS_SINERGIA.P_PPTO_SGA(an_idloteppto,n_error,v_error);
  else --MO EQU
    WEBSERVICE.PQ_WS_SINERGIA.P_PPTO_SGA(an_idloteppto,n_error,v_error);
  end if;
  IF n_error < 0 THEN
    v_error := 'Reenviar Presupuesto:' || v_error;
    RAISE err;
  else
    p_reg_log('Reenviar ',0, 'Se envia a Presupuesto ',null,null,null,null,null);
  END IF;

exception
  WHEN err THEN
    p_reg_log('Presupuesto.',n_error,v_error,null,null,null,null,null);
  when others then
    v_error:='Presupuesto:'|| to_char(1) ||'-'||sqlerrm;
    p_reg_log('Presupuesto.',sqlcode,v_error,null,null,null,null,null);
END;



  procedure p_asigna_pep3(pn_codsolot in solotptoequ.codsolot%type,
                          pn_tran_solmat solotptoequ.tran_solmat%type) is
    lv_pep pep.pep%type;
    ln_cant number;
v_pep_infra pep.pep%type;--28.0
n_id_seq number;--28.0
n_gen_res_infra number;--28.0
v_pep_cv pep.pep%type;--29.0
  begin

    select sum(cant)
      into ln_cant
      from (select count(1) cant
              from solotptoequ a
             where a.tran_solmat = pn_tran_solmat
               and a.codsolot = pn_codsolot
               and a.pep is null
            union all
            select count(1)
              from solotptoequcmp b
             where b.tran_solmat = pn_tran_solmat
               and b.codsolot = pn_codsolot
               and b.pep is null);
    if ln_cant > 0 then
      select min(a.pep) into lv_pep
      from operacion.pep a, operacion.tiproy_sinergia_pep b
      where a.id_seq=b.Id_Seq and b.genera_reserva=1 and a.nivel=3 and
      a.rubroinv != 'CV' and a.codsolot=pn_codsolot  and anio=f_get_anio and procesado='S';--8.0

      if lv_pep is null then
        pq_sinergia.p_crea_pry_sap(pn_codsolot);
        select min(pep) into lv_pep from operacion.pep --9.0
        where nivel = 3 and codsolot = pn_codsolot
        and rubroinv != 'CV' and anio=f_get_anio and procesado='S';--8.0
      end if;
      --28.0
      select count(1) into n_gen_res_infra from tipopedd where abrev='GENRESINFRASB';
      if n_gen_res_infra=1 then
        if f_get_tiproy(pn_codsolot)=TIPROY_AFO then--29.0
          select nvl(min(a.id_seq),0) into n_id_seq from solotptoequ a where a.codsolot=pn_codsolot and a.tran_solmat =pn_tran_solmat;
          if n_id_seq=0 then
            select min(pep) into v_pep_cv from operacion.pep where codsolot= pn_codsolot
            and id_seq =41 and procesado='S';
            if v_pep_infra is not null then
              lv_pep:=v_pep_cv;
            end if;
          end if;
          if n_id_seq>0 then
            select min(pep) into v_pep_infra from operacion.pep where codsolot= pn_codsolot
            and id_seq =n_id_seq and procesado='S';
            if v_pep_infra is not null then
              lv_pep:=v_pep_infra;
            end if;
          end if;
        end if;
      end if;


      if lv_pep is null then
          p_reg_log('Asigna PEP3',0,'No se pudo crear PEP3',null,pn_codsolot,null,null,pn_tran_solmat);
      else
        update solotptoequ a
           set pep = lv_pep
         where a.tran_solmat = pn_tran_solmat
           and a.codsolot = pn_codsolot
           and a.pep is null;
        update solotptoequcmp a
           set pep = lv_pep
         where a.tran_solmat = pn_tran_solmat
           and a.codsolot = pn_codsolot
           and a.pep is null;
        commit;
      end if;
    end if;
  end;


procedure p_genera_pry_venta(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number)
IS
v_abrev varchar2(50);
v_error varchar2(400);
n_error number;
n_codsolot number;
n_idubitecnica number;
err EXCEPTION;
cursor c_srv is
  select n_codsolot from solot where codsolot=n_codsolot;
Begin
  select a.codsolot into n_codsolot
  from wf a, solot b   where a.idwf = a_idwf  and a.codsolot = b.codsolot;
  Begin
    n_idubitecnica:=0;
    for r_srv in c_srv loop
      p_crea_pry_sap(n_codsolot,n_idubitecnica);
    end loop;
  exception
    WHEN err THEN
      p_reg_log('Genera Proyecto Venta Equipos',n_error,v_error,null,null,null,null,null);
    when others then
      v_error:='Genera Proyecto Venta Equipos:'|| v_abrev ||'-'||sqlerrm;
      p_reg_log('Genera Proyecto Venta Equipos.',sqlcode,v_error,null,null,null,null,null);
  end;
END;


  procedure p_valida_gen_reserva(an_codsolot    in solotptoequ.codsolot%type,
                                 an_tran_solmat in solotptoequ.tran_solmat%type,
                                 av_error      out varchar2,
                                 av_mensaje out varchar2) is
    lv_cod_sap   varchar2(20);
    lv_desc_eta  varchar2(100);
    lv_tipo_eta  varchar2(10);
    lv_punto     varchar2(100);
    lv_error     varchar2(100);
    ln_flg_mo    number;
    ln_cont      number;
    lv_codtipequ varchar2(15);
  begin
    av_error      := 'N';
    /**************************************************************************************/
    /* Validaciones - Equipos y Accesorios                                                */
    /**************************************************************************************/
    for r_solot in (select *
                      from solotptoequ
                     where codsolot = an_codsolot
                       and tran_solmat = an_tran_solmat
                       and flgsol = 1) loop
      begin
        lv_punto := 'punto :' || to_char(r_solot.punto) || ',orden:' ||to_char(r_solot.orden);
        -- No se manejan cantidades Cero
        if r_solot.cantidad is null or r_solot.cantidad = 0 then
          av_mensaje := lv_punto || ' el Campo [cantidad] es cero(0) o nula.';

          p_reg_log('Valida PRE Reserva',0,av_mensaje,null,an_codsolot,null,null,an_tran_solmat);
          av_error      := 'S';
          return;
        end if;

        if r_solot.fecfdis is null then
          av_mensaje := lv_punto ||' el campo [fecha fin de diseño] esta vacio.';
          p_reg_log('Valida PRE Reserva',0,av_mensaje,null,an_codsolot,null,null,an_tran_solmat);
          av_error      := 'S';
          return;
        end if;

        if r_solot.clase_val is null then
          av_mensaje := lv_punto ||' el campo [clase valoracion] esta vacio.';
          p_reg_log('Valida PRE Reserva',0,av_mensaje,null,an_codsolot,null,null,an_tran_solmat);
          av_error      := 'S';
          return;
        end if;

        if r_solot.centrosap is null then
          av_mensaje := lv_punto ||' el campo [centro] esta vacio.';
          p_reg_log('Valida PRE Reserva',0,av_mensaje,null,an_codsolot,null,null,an_tran_solmat);
          av_error      := 'S';
          return;
        end if;

        if r_solot.almacensap is null then
          av_mensaje := lv_punto ||' el campo [almacen] esta vacio.';
          p_reg_log('Valida PRE Reserva',0,av_mensaje,null,an_codsolot,null,null,an_tran_solmat);
          av_error      := 'S';
        end if;

        --Verificamos que el equipo en el maestro de equipos (TIPEQU) tenga registrado el
        --código general de material (Campo CODMAT en ALMTABMAT) asociado.
        begin
          select codtipequ
           into lv_codtipequ
            from tipequ
           where tipequ = r_solot.tipequ;
        exception
          when no_data_found then
            av_mensaje := lv_punto || ' equipo ' ||
                          to_char(r_solot.tipequ) ||
                          ' no tiene registrado el código general de material en el maestro de equipos.';
            p_reg_log('Valida PRE Reserva',0,av_mensaje,null,an_codsolot,null,null,an_tran_solmat);
            lv_codtipequ   := null;
            av_error      := 'S';
            return;
        end;

        -- Solo materiales con codigo Sap.
        begin
          select trim(cod_sap)into lv_cod_sap from almtabmat
          where trim(codmat) = trim(lv_codtipequ);
        exception
          when no_data_found then
            av_mensaje := lv_punto || ' equipo ' ||
                          to_char(r_solot.tipequ) ||
                          ' no está registrado el maestro general de materiales (ALMTABMAT).';
            p_reg_log('Valida PRE Reserva',0,av_mensaje,null,an_codsolot,null,null,an_tran_solmat);
            lv_cod_sap     := null;
            av_error      := 'S';
          return;
        end;

        if lv_cod_sap is null or trim(lv_cod_sap) = '' then
          av_mensaje := lv_punto || ' equipo ' || to_char(r_solot.tipequ) ||
                        ' no tiene codigo sap.';
          p_reg_log('Valida PRE Reserva',0,av_mensaje,null,an_codsolot,null,null,an_tran_solmat);
          av_error      := 'S';
        end if;

        select count(*)
          into ln_cont
          from sgaweb_material_sap_m
         where material = lv_cod_sap;

        if ln_cont = 0 then
          av_mensaje := lv_punto || ' equipo ' || r_solot.tipequ ||
                        ' con codigo sap ' || lv_cod_sap ||
                        ' no ha sido transferido hacia el SGA.';
          p_reg_log('Valida PRE Reserva',0,av_mensaje,null,an_codsolot,null,null,an_tran_solmat);
          av_error      := 'S';
          return;
        end if;

        -- revisamos que no hayan equipos asociados a mano de obra.
        begin
          select descripcion, tipo, flg_mano_obra
            into lv_desc_eta, lv_tipo_eta, ln_flg_mo
            from etapa
           where codeta = r_solot.codeta;
          if ln_flg_mo = 1 then
            av_mensaje := lv_punto || ' es de mano de obra, por favor verificar los datos ingresados.' ||  r_solot.codeta;
            p_reg_log('Valida PRE Reserva',0,av_mensaje,null,an_codsolot,null,null,an_tran_solmat);
            av_error      := 'S';
            return;
          end if;

          if lv_tipo_eta is null or trim(lv_tipo_eta) = '' then
            av_mensaje := lv_punto + ' no es una etapa valida.';
            p_reg_log('Valida PRE Reserva',0,av_mensaje,null,an_codsolot,null,null,an_tran_solmat);
            av_error      := 'S';
            return;
          end if;
        exception
          when no_data_found then
            av_mensaje := lv_punto || 'etapa ingresada no existe, o es erronea, cambiar de etapa.';
            p_reg_log('Valida PRE Reserva',0,av_mensaje,null,an_codsolot,null,null,an_tran_solmat);
            av_error      := 'S';
            return;
        end;

      exception
        when others then
          lv_error := substr(sqlerrm, 1, 100);
          av_mensaje := lv_punto || lv_error;
          p_reg_log('Valida PRE Reserva',0,av_mensaje,null,an_codsolot,null,null,an_tran_solmat);
          av_error      := 'S';
          return;
      end;
    end loop;

    -- Accesorios
    for r_solot in (select a.fecfdis, a.centrosap, b.*
                      from solotptoequ a, solotptoequcmp b
                     where a.codsolot = b.codsolot
                       and a.punto = b.punto
                       and a.orden = b.orden
                       and b.tran_solmat = an_tran_solmat
                       and b.codsolot = an_codsolot
                       and a.flgsol = 1) loop

      begin
        lv_punto := 'Solot:[Componentes de Equipos]:' ||
                    to_char(an_codsolot) || ', punto :' ||
                    to_char(r_solot.punto) || ',orden:' ||
                    to_char(r_solot.orden) || ',orden (cmp):' ||
                    to_char(r_solot.ordencmp);
        -- No se manejan cantidades Cero
        if r_solot.cantidad is null or r_solot.cantidad = 0 then
          av_mensaje := lv_punto || ' [cantidad] es cero(0).';
          p_reg_log('Valida PRE Reserva',0,av_mensaje,null,an_codsolot,null,null,an_tran_solmat);
          av_error      := 'S';
          return;
        end if;

        begin
          select codtipequ
            into lv_codtipequ
            from tipequ
           where tipequ = r_solot.tipequ;
        exception
          when no_data_found then
            av_mensaje := lv_punto || ' equipo ' ||
                          to_char(r_solot.tipequ) ||
                          ' no tiene registrado el código general de material en el maestro de equipos.';
            p_reg_log('Valida PRE Reserva',0,av_mensaje,null,an_codsolot,null,null,an_tran_solmat);
            lv_codtipequ   := null;
            av_error      := 'S';
          return;
        end;

        -- Solo materiales con codigo Sap.
        begin
          select trim(cod_sap)
            into lv_cod_sap
            from almtabmat
           where trim(codmat) = trim(lv_codtipequ);
        exception
          when no_data_found then
            av_mensaje := lv_punto || ' equipo ' ||
                          to_char(r_solot.tipequ) ||
                          ' no está registrado el maestro general de materiales (ALMTABMAT).';
            p_reg_log('Valida PRE Reserva',0,av_mensaje,null,an_codsolot,null,null,an_tran_solmat);
            lv_cod_sap     := null;
            av_error      := 'S';
          return;
        end;
        if lv_cod_sap is null or trim(lv_cod_sap) = '' then
          av_mensaje := lv_punto || ' accesorio ' ||
                        to_char(r_solot.tipequ) ||
                        ' no tiene codigo sap.';
          p_reg_log('Valida PRE Reserva',0,av_mensaje,null,an_codsolot,null,null,an_tran_solmat);
          av_error      := 'S';
        end if;

        select count(*)
          into ln_cont
          from sgaweb_material_sap_m
         where material = lv_cod_sap;
        if ln_cont = 0 then
          av_mensaje := lv_punto || ' equipo ' || r_solot.tipequ ||
                        ' con codigo sap ' || lv_cod_sap ||
                        ' no ha sido transferido hacia el SGA.';
          p_reg_log('Valida PRE Reserva',0,av_mensaje,null,an_codsolot,null,null,an_tran_solmat);
          av_error      := 'S';
          return;
        end if;

        -- revisamos que no hayan equipos asociados a mano de obra.
        begin
          select descripcion, tipo, flg_mano_obra
            into lv_desc_eta, lv_tipo_eta, ln_flg_mo
            from etapa
           where codeta = r_solot.codeta;
          if ln_flg_mo = 1 then
            av_mensaje := lv_punto || ' es de mano de obra, por favor verificar los datos ingresados.';
            p_reg_log('Valida PRE Reserva',0,av_mensaje,null,an_codsolot,null,null,an_tran_solmat);
            av_error      := 'S';
            return;
          end if;
          if lv_tipo_eta is null or lv_tipo_eta = ' ' then
            av_mensaje := lv_punto || ' no es una etapa valida.';
            p_reg_log('Valida PRE Reserva',0,av_mensaje,null,an_codsolot,null,null,an_tran_solmat);
            av_error      := 'S';
            return;
          end if;
        exception
          when no_data_found then
            av_mensaje := lv_punto ||' etapa ingresada no existe, o es erronea, cambiar de etapa.';
            p_reg_log('Valida PRE Reserva',0,av_mensaje,null,an_codsolot,null,null,an_tran_solmat);
            av_error      := 'S';
            return;
        end;

      exception
        when others then
          lv_error := substr(sqlerrm, 1, 100);
          av_mensaje := lv_punto || lv_error;
          p_reg_log('Valida PRE Reserva',0,av_mensaje,null,an_codsolot,null,null,an_tran_solmat);
          av_error      := 'S';
          return;
      end;
    end loop;
  exception
    when others then
      lv_error := 'Otros: ' || substr(sqlerrm, 1, 100);
      p_reg_log('Valida PRE Reserva',0,lv_error,null,an_codsolot,null,null,an_tran_solmat);
      av_error      := 'S';
      return;
  end p_valida_gen_reserva;

procedure p_procesa_reserva(an_codsolot in number,an_codcon number default null,
  pn_tran_solmat out solotptoequ.tran_solmat%type,pv_errors out varchar2,pv_gen_res_sol out varchar2) is

  ln_codcon number;
  n_val_equ number;
  n_val_equ_cmp number;
  v_mensaje varchar2(500);
  ln_contador_val number;--8.0
    cursor c_equ(an_tran_solmat solotptoequ.tran_solmat%type,
                 an_codsolot    solotptoequ.codsolot%type) is
      select distinct centrosap, almacensap, pep, clase_val
        from solotptoequ
       where tran_solmat = an_tran_solmat
         and codsolot = an_codsolot
         and costo > 0
         and flgsol = 1
         and nvl(flgreq, 0) = 0
         and fecfdis is not null
      union
      select distinct b.centrosap, b.almacensap, a.pep, clase_val
        from solotptoequcmp a, solotptoequ b
       where b.codsolot = a.codsolot
         and b.punto = a.punto
         and b.orden = a.orden
         and a.tran_solmat = an_tran_solmat
         and a.codsolot = an_codsolot
         and a.costo > 0
         and b.costo > 0
         and a.flgsol = 1
         and nvl(a.flgreq, 0) = 0;

  begin
    if an_codcon is null or an_codcon=0 then
      begin
        select  nvl(s.codcon, -1)
        into ln_codcon
        from solotpto_id s, contrata c
        where s.codcon = c.codcon and s.codcon is not null
        and s.codsolot = an_codsolot and rownum = 1;
      exception
        when no_data_found then
          raise_application_error(-20001,'No tiene asignado contratista. Asignar contratista.');
      end;
     else
       ln_codcon:=an_codcon;
     end if;

     --ini 8.0
     SELECT COUNT(1)
     INTO   ln_contador_val
     FROM   OPERACION.SOLOTPTOEQU
     WHERE  codsolot = an_codsolot
     AND    flgsol   = 1
     AND    (NVL(CENTROSAP,'X')='X' OR NVL(ALMACENSAP,'X')='X') ;

     if ln_contador_val>0 then
         raise_application_error(-20001,'No tiene Almacen o Centro de Costo. Completar los datos.');
     end if;
     -- fin 8.0

    select financial.SQ_TRANSOLMAT.NEXTVAL into pn_tran_solmat from dual;
    update solotptoequ a
       set a.tran_solmat = pn_tran_solmat-- pn_tran_solmat
     where a.codsolot = an_codsolot
       and a.flgsol = 1
       and a.flgreq = 0
       and a.costo > 0;

    update solotptoequcmp a
       set a.tran_solmat = pn_tran_solmat-- pn_tran_solmat
     where a.codsolot = an_codsolot
       and a.flgsol = 1
       and a.flgreq = 0
       and a.costo > 0
       and a.orden in (select orden
                         from solotptoequ
                        where codsolot = a.codsolot
                         and punto = a.punto
                          and orden = a.orden
                          and fecfdis is not null);


      select count(1) into n_val_equ
        from solotptoequ
       where tran_solmat = pn_tran_solmat
         and codsolot = an_codsolot
         and costo > 0
         and flgsol = 1
         and nvl(flgreq, 0) = 0
         and fecfdis is not null;
      select count(1) into n_val_equ_cmp
        from solotptoequcmp a, solotptoequ b
       where b.codsolot = a.codsolot
         and b.punto = a.punto
         and b.orden = a.orden
         and a.tran_solmat = pn_tran_solmat
         and a.codsolot = an_codsolot
         and a.costo > 0
         and b.costo > 0
         and a.flgsol = 1
         and nvl(a.flgreq, 0) = 0;
    if n_val_equ+n_val_equ_cmp = 0 then
      raise_application_error(-20001,'No tiene equipos para reservar.');
    end if;


    -- Validaciones previas
    p_valida_gen_reserva(an_codsolot,
                         pn_tran_solmat,
                         pv_errors,v_mensaje);

    if pv_errors = 'S' then
      raise_application_error(-20001,v_mensaje);
    end if;
    -- Asignacion de Elemento PEP
    p_asigna_pep3(an_codsolot,pn_tran_solmat);

    if pv_errors = 'N' then
      for r_equ in c_equ(pn_tran_solmat, an_codsolot) loop
        -- Creacion de reserva
        p_crea_reserva(an_codsolot,pn_tran_solmat,user,r_equ.centrosap,
          r_equ.almacensap,r_equ.pep,r_equ.clase_val,ln_codcon,pv_errors);
        commit;
      end loop;
    end if;
    if pv_errors = 'N' then
       p_ppto_reserva(an_codsolot,pn_tran_solmat);
       pv_gen_res_sol := 'Se generó reserva y se envio el presupuesto';
    else
       pv_gen_res_sol := 'No se ha podido realizar la reserva. Revisar log de errores';
    end if;
  end p_procesa_reserva;

procedure p_crea_reserva(pn_codsolot in solotptoequ.codsolot%type,pn_tran_solmat in solotptoequ.tran_solmat%type,
  av_usuario in solotptoequ.codusu%type,pv_centrosap in solotptoequ.centrosap%type,pv_almacensap in solotptoequ.almacensap%type,
  pv_pep in solotptoequ.pep%type,pv_clase_val in solotptoequ.clase_val%type,an_codcon in number,
  pv_errors out varchar2) is

  cursor c_equ(an_codsolot    solotptoequ.codsolot%type,
               an_tran_solmat solotptoequ.tran_solmat%type,
               av_centrosap   solotptoequ.centrosap%type,
               av_almacensap  solotptoequ.almacensap%type,
               av_pep         solotptoequ.pep%type,
               av_clase_val   solotptoequ.clase_val%type) is
    select m.cod_sap, m.codundsap, sum(eq.cantidad) cantidad
      from (select c.codtipequ, a.cantidad
              from solotptoequ a, tipequ c
             where a.tipequ = c.tipequ
               and a.tran_solmat = an_tran_solmat
               and a.codsolot = an_codsolot
               and a.centrosap = av_centrosap
               and a.almacensap = av_almacensap
               and a.pep = av_pep
               and a.clase_val = av_clase_val
               and a.costo > 0
               and a.flgsol = 1
               and nvl(a.flgreq, 0) = 0
               and a.fecfdis is not null
            union all
            select c.codtipequ, a.cantidad * b.cantidad cantidad
              from solotptoequ a, solotptoequcmp b, tipequ c
             where a.codsolot = b.codsolot
               and a.punto = b.punto
               and a.orden = b.orden
               and b.tipequ = c.tipequ
               and b.tran_solmat = an_tran_solmat
               and b.codsolot = an_codsolot
               and a.centrosap = av_centrosap
               and a.almacensap = av_almacensap
               and b.pep = av_pep
               and a.clase_val = av_clase_val
               and b.costo > 0
               and a.costo > 0
               and b.flgsol = 1
               and nvl(b.flgreq, 0) = 0) eq,
           almtabmat m
     where eq.codtipequ = m.codmat
       and m.cod_sap is not null
     group by m.cod_sap, m.codundsap;

  ln_id_verif       number;
  ln_id_res         number;
  ln_cantdisp       number;
  ln_error          number;
  lv_error          varchar2(100);
  ln_cant_registros number;
  ln_cant_reserva   number;
  lv_numreserva     varchar2(100);
  ln_numreserva     number;
  lv_mensaje        varchar2(2000);
begin
  select operacion.sq_id_res.nextval
    into ln_id_res
    from operacion.dummy_ope;

  for r_equ in c_equ(pn_codsolot,
                     pn_tran_solmat,
                     pv_centrosap,
                     pv_almacensap,
                     pv_pep,
                     pv_clase_val) loop

    select operacion.sq_id_verif.nextval
      into ln_id_verif
      from operacion.dummy_ope;

    insert into operacion.verifmaterial(id_verif,centro,almacen,clase_val,unidad,
    material,cantnecesaria,tran_solmat,id_res,codsolot)
    values(ln_id_verif,pv_centrosap,pv_almacensap,pv_clase_val,r_equ.codundsap,
    r_equ.cod_sap,r_equ.cantidad,pn_tran_solmat,ln_id_res,pn_codsolot);

    webservice.pq_ws_sinergia.P_VERIFICA_DISP(ln_id_verif,pn_codsolot,ln_cantdisp,ln_error,lv_error);

    if ln_cantdisp >= r_equ.cantidad then
      update operacion.verifmaterial
         set flg_reserva = 1
       where id_verif = ln_id_verif;
    else
      update operacion.verifmaterial
         set flg_reserva = 0
       where id_verif = ln_id_verif;
      lv_mensaje := 'Material:'||r_equ.cod_sap||
                    ' Centro:'||pv_centrosap||
                    ' Almacen:'||pv_almacensap||
                    ' no hay stock disponible, se tiene stock: '||ln_cantdisp;
      p_reg_log('Verifica Stock',0,lv_mensaje,null,pn_codsolot,null,null,pn_tran_solmat);
    end if;
  end loop;

  select sum(flg_reserva), count(1)
    into ln_cant_reserva, ln_cant_registros
    from operacion.verifmaterial
   where id_res = ln_id_res;

  if ln_cant_reserva >= ln_cant_registros then
    insert into operacion.reserva_cab(id_res, fecha, usuario, clasemov, pep, tran_solmat, codsolot,codcon)
    values(ln_id_res,sysdate,av_usuario,221,pv_pep,pn_tran_solmat,pn_codsolot,an_codcon);
    insert into operacion.reserva_det(id_res,id_res_det,material,centro,almacen,clase_val,
    cantidad,unidad,fechanecesidad)
    select id_res,rownum,material,centro,almacen,clase_val,cantnecesaria,unidad,sysdate
    from operacion.verifmaterial
    where id_res = ln_id_res
    and flg_reserva = 1;

    webservice.pq_ws_sinergia.P_GENERA_RESERVA(ln_id_res,
                                               lv_numreserva,
                                               ln_error,
                                               lv_error);
    if lv_numreserva is not null then
      ln_numreserva := to_number(lv_numreserva);
      update solotptoequ
         set nro_res = ln_numreserva, flgreq = 1,
             FECGENRESERVA=sysdate,USUGENRESERVA=av_usuario
       where tran_solmat = pn_tran_solmat
         and codsolot = pn_codsolot
         and centrosap = pv_centrosap
         and almacensap = pv_almacensap
         and pep = pv_pep
         and clase_val = pv_clase_val
         and costo > 0
         and flgsol = 1
         and nvl(flgreq, 0) = 0
         and fecfdis is not null;

      update solotptoequcmp a
         set a.nro_res = ln_numreserva, a.flgreq = 1,
         FECGENRESERVA=sysdate,USUGENRESERVA=av_usuario
       where a.tran_solmat = pn_tran_solmat
         and a.codsolot = pn_codsolot
         and a.costo > 0
         and a.flgsol = 1
         and nvl(a.flgreq, 0) = 0
         and pep = pv_pep
         and exists (select 1
                from solotptoequ b
               where b.codsolot = a.codsolot
                 and b.punto = a.punto
                 and b.orden = a.orden
                 and b.centrosap = pv_centrosap
                 and b.almacensap = pv_almacensap
                 and b.clase_val = pv_clase_val
                 and b.costo > 0);
      pv_errors      := 'N';
      lv_mensaje := 'Se generó reserva nro: ' || lv_numreserva ||
                        ' para centro: ' || pv_centrosap ||
                        ' y almacen: ' || pv_almacensap;
      p_reg_log('Crea Reserva',0,lv_mensaje,null,pn_codsolot,null,null,pn_tran_solmat);
    else
      pv_errors      := 'S';
      lv_mensaje := 'Error al generar la reserva para centro: ' ||pv_centrosap || ' y almacen: ' || pv_almacensap ||' - ' || lv_error;
      p_reg_log('Crea Reserva',0,lv_mensaje,null,pn_codsolot,null,null,pn_tran_solmat);
    end if;

  else
    pv_errors      := 'S';
    lv_mensaje := 'No hay stock disponible: ' || pv_centrosap ||
                  ' y almacen: ' || pv_almacensap || ' - ' ||
                  lv_error;
    p_reg_log('Crea Reserva',0,lv_mensaje,null,pn_codsolot,null,null,pn_tran_solmat);
  end if;
end p_crea_reserva;


procedure p_verif_disponibilidad(an_codsolot in solotptoequ.codsolot%type,an_punto in solotptoequ.punto%type,
  an_orden in solotptoequ.orden%type,an_tran_solmat out number) is

cursor c_equ is
  select c.cod_sap,c.codundsap,a.cantidad,a.centrosap,a.almacensap,a.clase_val
  from solotptoequ a, tipequ b,almtabmat c
  where a.tipequ=b.tipequ and b.codtipequ=c.codmat
  and a.codsolot=an_codsolot and a.punto=an_punto and a.orden=an_orden;
  ln_id_verif       number;
  ln_cantdisp       number;
  ln_error          number;
  lv_error          varchar2(100);
  lv_mensaje        varchar2(2000);

begin
  select financial.SQ_TRANSOLMAT.NEXTVAL into an_tran_solmat from dual;
  for r_equ in c_equ loop
    select operacion.sq_id_verif.nextval into ln_id_verif from operacion.dummy_ope;

    insert into operacion.verifmaterial(id_verif,centro,almacen,clase_val,unidad,
    material,cantnecesaria,tran_solmat,codsolot)
    values(ln_id_verif,r_equ.centrosap,r_equ.almacensap,r_equ.clase_val,r_equ.codundsap,
    r_equ.cod_sap,r_equ.cantidad,an_tran_solmat,an_codsolot);

    webservice.pq_ws_sinergia.P_VERIFICA_DISP(ln_id_verif,an_codsolot,ln_cantdisp,ln_error,lv_error);

    if ln_cantdisp >= r_equ.cantidad then
      update operacion.verifmaterial
         set flg_reserva = 1
       where id_verif = ln_id_verif;
    else
      update operacion.verifmaterial
         set flg_reserva = 0
       where id_verif = ln_id_verif;
      lv_mensaje := 'Material:'||r_equ.cod_sap||
                    ' Centro:'||'pv_centrosap'||
                    ' Almacen:'||'pv_almacensap'||
                    ' no hay stock disponible, se tiene stock: '||ln_cantdisp;
      p_reg_log('Verifica Stock',0,lv_mensaje,null,an_codsolot,null,null,an_tran_solmat);
    end if;
  end loop;

end p_verif_disponibilidad;

procedure p_crea_pry_mas(av_ubitecnica in varchar,an_tipo in number default 0, av_numslc out varchar2)
IS
v_error varchar2(400);
n_error number;
n_val_ubitec number;
n_val_pry number;
v_numslc sales.vtatabslcfac.numslc%type;
v_codcli sales.vtatabslcfac.codcli%type;
v_idplano sales.vtatabslcfac.idplano%type;
v_des_ubitec operacion.ubi_tecnica.descripcion%type;
v_codubi vtatabgeoref.codubi%type;
t_ubitec operacion.ubi_tecnica%rowtype;

err EXCEPTION;
err_per EXCEPTION;
n_codef number;
n_area number;
n_id_ubitecnica number;
n_codsolot number;
n_val_usuario number;
v_chf varchar2(3);
cursor c_hfc is
select * from operacion.tiproy_sinergia where tiproy IN (TIPROY_CHF,TIPROY_CH1,TIPROY_CH2)
and not tiproy = NVL(v_chf,TIPROY_CHF);

Begin
  if an_tipo=1 then --se valida por usuario ya que se envia el rayo por sga
    select count(1) into n_val_usuario from opedd a,tipopedd b
    where a.tipopedd=b.tipopedd and b.abrev='SINERGIAUSUPERRAYO' and a.codigoc=user;
    if n_val_usuario=0 then
      v_error := 'El usuario no tiene permiso para generar Proyectos en SAP.';
      p_reg_log('Crear PEP Masivo.',sqlcode,v_error,v_numslc,null,n_id_ubitecnica,null,null);
      raise_application_error(-20001,v_error);
    end if;
  end if;
  if an_tipo=2 then--Si es un proyecto PEH no considerar generar el proyecto de Clientes
    v_chf:=null;
  else
    v_chf:='XX';
  end if;
  --validar que el la ubitecnica esta implemantado y el ano de implementacion
  select count(1) into n_val_ubitec from operacion.ubi_tecnica
  where abrev=av_ubitecnica and procesado='S';
  if n_val_ubitec=0 then
    v_error := 'No existe la ubicacion tecnica creada en SAP desde SGA';
    RAISE err;
  elsif n_val_ubitec=1 then--Esta correctamente creado la ubicacion tecnica
    select * into t_ubitec from operacion.ubi_tecnica where abrev=av_ubitecnica and procesado='S';
  else
    v_error := 'Existe mas de ubicacion tecnica valida para el identificador.';
    RAISE err;
  end if;

  for c_h in c_hfc loop
    begin
      select count(1) into n_val_pry
      from operacion.proyecto_sap --validar si existe pry HFC de ubitec en sap
      where ubitecnica=av_ubitecnica and tiproy=c_h.tiproy and procesado='S' and anio= f_get_anio;
      if n_val_pry =1 then
        select id_ubitecnica into n_id_ubitecnica from operacion.proyecto_sap
        where ubitecnica=av_ubitecnica and tiproy=c_h.tiproy and procesado='S' and anio= f_get_anio;
        v_error := 'Ya existe la estructura Anual de Proyectos para esta Ubicacion Tecnica :'|| av_ubitecnica;
        RAISE err;
      end if;

      --Generar Proyecto y SOT en SGA HFC
      --K Corp  H HFC F Nodo Nulo Masivos
      if t_ubitec.claseproy = 'H' or
           t_ubitec.claseproy = C_CLASE_PROY_FUS then--25.0
          --HFC
        select a.idplano,a.descripcion,nvl(b.codubi,'0000000000'),a.id_ubitecnica into v_idplano,v_des_ubitec,v_codubi,n_id_ubitecnica
        from operacion.ubi_tecnica a,vtatabgeoref b
        where a.abrev=av_ubitecnica and a.procesado='S' and a.idplano=b.idplano(+) and rownum=1;
        select LPAD(sq_vtatabslcfac.nextval,10,'0'),pq_constantes.f_get_cliatt,f_get_area_usuario
        into v_numslc,v_codcli,n_area from operacion.tiproy_sinergia--Clientes Masivos
        where tiproy=c_h.tiproy;
      elsif t_ubitec.claseproy='K' then--Corporativos No Aplica
        null;
      elsif t_ubitec.claseproy='F' then--Nodo
        null;
      elsif t_ubitec.claseproy is null then
        null;
      end if;

      INSERT INTO VTATABSLCFAC(NUMSLC,FECPEDSOL,ESTSOLFAC,SRVPRI,CODCLI,CODSOL,CODDPT,
      CODSRV,TIPSRV,TIPSOLEF,PLAZO_SRV,TIPROY,MONEDA_ID,CLIINT,TIPO,IDPLANO)
      VALUES(v_numslc,sysdate,'03','PEPs Masivos',v_codcli,'00000000','200',
      '5500','0067',11,23,c_h.tiproy,1,'PRF',5,v_idplano);

      INSERT INTO VTADETPTOENL(NUMSLC,DESCPTO,DIRPTO,UBIPTO,CREPTO,CODSRV,CODSUC,NUMPTO,
      TIPTRAEF,NUMPTO_PRIN,PAQUETE,GRUPO,CANTIDAD)
      VALUES(v_numslc,v_idplano,v_des_ubitec,v_codubi,'1','5500',
      '0001041963','00001',81,'00001',1,1,1);
      commit;
      n_codef:=to_number(v_numslc);
      INSERT INTO SOLEFXAREA ( NUMSLC, ESTSOLEF, CODEF, ESRESPONSABLE, AREA)
      VALUES (v_numslc, 2,n_codef, 1, nvl(n_area,200) );
      update ef set req_ar=1,estef=2 where codef=n_codef;
      insert into ar ( codef, estar,RENTABLE) VALUES (n_codef, 3,1 );
      OPERACION.pq_int_pryope.p_exe_int_pryope(v_numslc , null , null , 11 , 'C' );
      select codsolot,numslc into n_codsolot,av_numslc from solot where numslc=v_numslc and rownum=1;
      p_reg_log('Crear PEP Masivo.',0,'Generación SOT y Proyecto SGA.',v_numslc,n_codsolot,n_id_ubitecnica,null,null);
      commit;
      --Generar Proyectos SAP y PEPs :
      p_crea_pry_sap(n_codsolot,n_id_ubitecnica);

    exception
      WHEN err THEN
        p_reg_log('Crear PEP Masivo.',n_error,v_error,v_numslc,null,n_id_ubitecnica,null,null);
      when err_per then
        p_reg_log('Crear PEP Masivo.',sqlcode,v_error,v_numslc,null,n_id_ubitecnica,null,null);
        raise_application_error(-20001,v_error);
      when others then
        v_error:='Crear PEP Masivo:'|| '-' || sqlerrm;
        p_reg_log('Crear PEP Masivo.',sqlcode,v_error,v_numslc,null,n_id_ubitecnica,null,null);
    end;
  end loop;
END;




procedure p_crea_pry_masxubitec(an_id_ubitecnica in number,an_tipo in number default 0)
IS
v_error varchar2(400);
n_error number;
n_val_pry number;
v_numslc sales.vtatabslcfac.numslc%type;
v_codcli sales.vtatabslcfac.codcli%type;
n_id_ubitecnica number;
err EXCEPTION;
n_codef number;
n_area number;
n_codsolot number;
n_val_usuario number;
--0058  Paquetes Pymes e Inmobiliario     CLIENTES WMAX  10
--0059  Telefonía Pública de Interior     TLP CDMA      7
--0059  Telefonía Pública de Interior     TLP GSM        8
--0059  Telefonía Pública de Interior     TLP WMAX      9
--0077  Paquetes inalambricos             DTH            6
cursor c_ubitec is
select id_ubitecnica,abrev,tiproy_mas,tipo_sga from operacion.ubi_tecnica
where procesado='S' and tipo_sga in (7,8,9,10) and id_ubitecnica=nvl(an_id_ubitecnica,id_ubitecnica)
union
select a.id_ubitecnica,a.abrev,b.tiproy,tipo_sga from operacion.ubi_tecnica a, operacion.ubitecxproy b --DTH
where procesado='S' and tipo_sga in (6) and a.id_ubitecnica=b.id_ubitecnica
and a.id_ubitecnica=nvl(an_id_ubitecnica,a.id_ubitecnica);

Begin
  if an_tipo=1 then --se valida por usuario ya que se envia el rayo por sga
    select count(1) into n_val_usuario from opedd a,tipopedd b
    where a.tipopedd=b.tipopedd and b.abrev='SINERGIAUSUPERRAYO' and a.codigoc=UPPER(user);
    if n_val_usuario=0 then
      v_error := 'El usuario no tiene permiso para generar Proyectos en SAP.';
      p_reg_log('Crear PEP Masivo.',sqlcode,v_error,v_numslc,null,an_id_ubitecnica,null,null);
      raise_application_error(-20001,v_error);
    end if;
  end if;
  --Listar Ubicaciones Tecnicas y Generar proyecto anual
  for c_u in c_ubitec loop
    --Identificar Ubicacion Tecnica por Region
    begin
      select count(1) into n_val_pry from operacion.proyecto_sap --validar si existe pry de ubitec en sap
      where id_ubitecnica=c_u.id_ubitecnica and procesado='S' and anio= f_get_anio;
      if (n_val_pry =1 and not c_u.tipo_sga=6) or (n_val_pry =2 and c_u.tipo_sga=6) then--DTH puede tener mas de un proyecto por UBITEC
        select id_ubitecnica,numslc into n_id_ubitecnica, v_numslc from operacion.proyecto_sap--6.0
        where ubitecnica=c_u.abrev and procesado='S' and anio= f_get_anio;
        v_error := 'Ya existe la estructura Anual de Proyectos para esta Ubicacion Tecnica ' ||c_u.abrev;
        RAISE err;
      end if;
      select LPAD(sq_vtatabslcfac.nextval,10,'0'),pq_constantes.f_get_cliatt,nvl(f_get_area_usuario,200)
      into v_numslc,v_codcli,n_area from operacion.tiproy_sinergia--Clientes Masivos
      where tiproy=c_u.tiproy_mas;

      INSERT INTO VTATABSLCFAC(NUMSLC,FECPEDSOL,ESTSOLFAC,SRVPRI,CODCLI,CODSOL,CODDPT,
      CODSRV,TIPSRV,TIPSOLEF,PLAZO_SRV,TIPROY,MONEDA_ID,TIPO)
      VALUES(v_numslc,sysdate,'03','PEPs Masivos',v_codcli,'00000000','200',
      '5500','0067',11,23,c_u.tiproy_mas,1,5);
      INSERT INTO VTADETPTOENL(NUMSLC,DESCPTO,DIRPTO,UBIPTO,CREPTO,CODSRV,CODSUC,NUMPTO,
      TIPTRAEF,NUMPTO_PRIN,PAQUETE,GRUPO,CANTIDAD)
      VALUES(v_numslc,'Descripcion','Direccion','0000000002','1','5500',
      '0001041963','00001',81,'00001',1,1,1);
      commit;
      n_codef:=to_number(v_numslc);
      INSERT INTO SOLEFXAREA( NUMSLC, ESTSOLEF, CODEF, ESRESPONSABLE, AREA)
      VALUES (v_numslc, 2,n_codef, 1, nvl(n_area,200) );
      update ef set req_ar=1,estef=2 where codef=n_codef;
      insert into ar ( codef, estar,RENTABLE) VALUES (n_codef, 3,1 );
      OPERACION.pq_int_pryope.p_exe_int_pryope(v_numslc , null , null , 11 , 'C' );
      select codsolot into n_codsolot from solot where numslc=v_numslc and rownum=1;
      p_reg_log('Crear PEP Masivo.',0,'Generación SOT y Proyecto SGA.',v_numslc,n_codsolot,n_id_ubitecnica,null,null);
      --Generar Proyectos SAP y PEPs :
      p_crea_pry_sap(n_codsolot,c_u.id_ubitecnica);
    exception
      WHEN err THEN
       --ini 6.0
       select codsolot into   n_codsolot from solot where numslc= v_numslc and rownum=1;
        p_reg_log('Reproceso Pep2.',0,'Generacion Pep2 y Pep3',v_numslc,n_codsolot,n_id_ubitecnica,null,null);
        if n_codsolot>0 then
          p_crea_pep2(n_codsolot);
        end if;
       --fin 6.0
        p_reg_log('Crear PEP Masivo',n_error,v_error,v_numslc,null,n_id_ubitecnica,null,null);
      when others then
        v_error:='Crear PEP Masivo '||'-'||sqlerrm;
        p_reg_log('Crear PEP Masivo',sqlcode,v_error,v_numslc,null,n_id_ubitecnica,null,null);
    end;
  end loop;
END;


procedure p_reg_log(av_proceso varchar2,an_error number, av_texto varchar2,av_numslc varchar2,an_codsolot number,
  an_id_ubitecnica number,an_id_grafo number,an_idreq number) is
    pragma autonomous_transaction;
begin
  insert into operacion.LOG_ERROR_SGASAP(numslc,codsolot,id_ubitecnica,id_requisicion,error,TEXTO,PROCESO,id_grafo)
  values(av_numslc,an_codsolot,an_id_ubitecnica,an_idreq,an_error,av_texto,av_proceso,an_id_grafo);
  commit;
end;

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

function f_convertbase26(nNumero IN NUMBER,nLenRet IN number) RETURN VARCHAR2 IS
nBase NUMBER(3) := 26 ;
nLen NUMBER(10)   ;
vRetorno VARCHAR(10)   ;
nNumber  NUMBER       ;
nDigito NUMBER(4)   ;
BEGIN
  nLen := nLenRet - 1;
  nNumber:=  nNumero ;
  WHILE nLen >=  0  LOOP
    nDigito  := TRUNC(nNumber / POWER (nBase, nLen)) ;
    vREtorno  := vRetorno || CHR(nDigito + 65) ;
    nNumber  := MOD(nNumber, POWER (nBase, nLen));
    nLen := nLen - 1;
  END LOOP ;
  RETURN vREtorno;
end;

function f_get_tiproy(an_codsolot number) return varchar2
is
v_tiproy operacion.tiproy_sinergia.tiproy%type;
n_val_site number;
begin
  begin
    select distinct decode(c.tipsrv, '0043','TLP',decode(tiptra,114,'CVE','AFO')) into v_tiproy
    from vtatabslcfac c, operacion.tiproy_sinergia b1,solot
    where c.tipo<>5 and c.numslc= solot.numslc and solot.codsolot=an_codsolot
    UNION ALL
    SELECT  c.tiproy
    FROM vtatabslcfac c , solot
    WHERE C.tipo=5 and C.numslc=solot.numslc and solot.codsolot=an_codsolot;
    if v_tiproy in (TIPROY_WM1) then --Si es proyecto de Red Fija
      select count(1) into n_val_site from vtatabslcfac a, solot b,operacion.ubi_tecnica ubitec, operacion.proyecto_sap pry
      where a.numslc=b.numslc and pry.tiproy_sap in (TIPROY_WMX)
      and a.codubired=ubitec.codubired and ubitec.abrev=pry.ubitecnica and pry.procesado='S' and pry.anio= f_get_anio
      and b.codsolot=an_codsolot and not pry.codsolot=an_codsolot;
      if n_val_site>0 then--Existe proyecto para eño en curso
        return TIPROY_WM2;
      end if;
    end if;
    if v_tiproy in (TIPROY_ORA) then --Si es proyecto de Red Fija
      select count(1) into n_val_site from vtatabslcfac a, solot b,operacion.ubi_tecnica ubitec, operacion.proyecto_sap pry
      where a.numslc=b.numslc and pry.tiproy_sap in (TIPROY_ORA)
      and a.codubired=ubitec.codubired and ubitec.abrev=pry.ubitecnica and pry.procesado='S' and pry.anio= f_get_anio
      and b.codsolot=an_codsolot and not pry.codsolot=an_codsolot;
      if n_val_site>0 then--Existe proyecto para eño en curso
        return TIPROY_OR1;
      end if;
    end if;

    return  v_tiproy;
  exception when others then
     return 'X';
  end;
end;

function f_get_pep_mo_mas(an_codsolot number) return varchar2
is
--0058  Paquetes Pymes e Inmobiliario     CLIENTES WMAX  10
--0059  Telefonía Pública de Interior     TLP CDMA      7
--0059  Telefonía Pública de Interior     TLP GSM        8
--0059  Telefonía Pública de Interior     TLP WMAX      9
--0077  Paquetes inalambricos             DTH            6
--0064  Paquetes CDMA

v_pep_mo operacion.pep.pep%type;
v_tipsrv operacion.solot.tipsrv%type;
n_idcampana number;
n_tipo_sga number;
n_cant number; --22.0
n_onex number; --22.0

begin
  select tipsrv into v_tipsrv from solot where codsolot=an_codsolot;
  select count(1) into n_cant from AGENLIQ.SGAT_AGENDA where codsolot=an_codsolot; --22.0
  begin
    if v_tipsrv in ('0061','0073') then --HFC
    -- 22.0 Ini
     if n_cant> 0 then
      select distinct d1.pep    into v_pep_mo
          from AGENLIQ.SGAT_AGENDA a1, operacion.ubi_tecnica b1, operacion.proyecto_sap c1,operacion.pep d1,operacion.tiproy_sinergia_pep e1,
          solot f1/*,solotptoeta g1*/, solotpto h1,inssrv i1,vtatabslcfac j1
        --Ini 12.0
          --where a1.idplano=b1.idplano and b1.abrev=c1.ubitecnica and c1.proyecto=d1.proyecto and c1.anio=f_get_anio
          where replace(LTRIM(trim(a1.AGENC_IDPLANO),'0'), 'Ñ', 'N')=b1.idplano and b1.abrev=c1.ubitecnica and c1.proyecto=d1.proyecto and c1.anio=f_get_anio
        --Fin 12.0
          and a1.codsolot=an_codsolot and d1.id_seq=e1.id_seq and e1.tipsrv=j1.tipsrv
          and a1.codsolot=f1.codsolot /*and a1.AGENN_IDAGENDA=g1.idagenda and f1.codsolot=g1.codsolot*/
                and c1.procesado='S' and e1.naturaleza_pep='INST' and d1.clasif_obra='MO'
          and f1.codsolot=h1.codsolot and h1.codinssrv=i1.codinssrv and i1.numslc=j1.numslc;
      else
        --22.0 Fin
      select distinct d1.pep    into v_pep_mo
      from agendamiento a1, operacion.ubi_tecnica b1, operacion.proyecto_sap c1,operacion.pep d1,operacion.tiproy_sinergia_pep e1,
      solot f1,solotptoeta g1, solotpto h1,inssrv i1,vtatabslcfac j1
    --Ini 12.0
      --where a1.idplano=b1.idplano and b1.abrev=c1.ubitecnica and c1.proyecto=d1.proyecto and c1.anio=f_get_anio
      where replace(a1.idplano, 'Ñ', 'N')=b1.idplano and b1.abrev=c1.ubitecnica and c1.proyecto=d1.proyecto and c1.anio=f_get_anio
    --Fin 12.0
      and a1.codsolot=an_codsolot and d1.id_seq=e1.id_seq and e1.tipsrv=j1.tipsrv
      and a1.codsolot=f1.codsolot and a1.idagenda=g1.idagenda and f1.codsolot=g1.codsolot
            and c1.procesado='S' and e1.naturaleza_pep='INST' and d1.clasif_obra='MO'
      and f1.codsolot=h1.codsolot and h1.codinssrv=i1.codinssrv and i1.numslc=j1.numslc;
     end if; --22.0
    end if;
    if v_tipsrv in ('0077') then--Ubicaciones tecnicas por Departamento para DTH y Solucion de Venta
    -- 22.0 Ini
     if n_cant> 0 then
          select distinct e1.pep  into v_pep_mo
          from solot a1, vtatabdst b1,operacion.ubi_tecnica c1,operacion.proyecto_sap d1,operacion.pep e1,
          vtatabslcfac f1,operacion.solucionxtipopep g1
          where a1.codubi=b1.codubi and b1.region_sap=c1.region_sap and c1.tipo_sga=6 and c1.abrev=d1.ubitecnica and d1.anio=f_get_anio
          and d1.proyecto=e1.proyecto and e1.clasif_obra='MO' and d1.procesado='S' and e1.naturaleza_pep='INST' and a1.numslc=f1.numslc
          and e1.id_seq=g1.id_seq and f1.idsolucion=g1.idsolucion
          and a1.codsolot=an_codsolot;
      else
        --22.0 Fin
      select distinct e1.pep  into v_pep_mo
      from agendamiento a1, vtatabdst b1,operacion.ubi_tecnica c1,operacion.proyecto_sap d1,operacion.pep e1,
      vtatabslcfac f1,operacion.solucionxtipopep g1
      where a1.codubi=b1.codubi and b1.region_sap=c1.region_sap and c1.tipo_sga=6 and c1.abrev=d1.ubitecnica and d1.anio=f_get_anio
      and d1.proyecto=e1.proyecto and e1.clasif_obra='MO' and d1.procesado='S' and e1.naturaleza_pep='INST' and a1.numslc=f1.numslc
      and e1.id_seq=g1.id_seq and f1.idsolucion=g1.idsolucion
      and a1.codsolot=an_codsolot;
      end if; --22.0
    end if;
    if v_tipsrv in ('0058') then--Ubicaciones tecnicas por Departamento para Wimax
   -- 22.0 Ini
      if n_cant> 0 then
          select distinct e1.pep  into v_pep_mo
          from solot a1, vtatabdst b1,operacion.ubi_tecnica c1,operacion.proyecto_sap d1,operacion.pep e1,vtatabslcfac f1
          where a1.codubi=b1.codubi and b1.region_sap=c1.region_sap and c1.tipo_sga=10 and c1.abrev=d1.ubitecnica and d1.anio=f_get_anio
          and d1.proyecto=e1.proyecto and e1.clasif_obra='MO' and d1.procesado='S' and e1.naturaleza_pep='INST' and a1.numslc=f1.numslc
          and a1.codsolot=an_codsolot;
      else
        -- 22.0 Fin
   select distinct e1.pep  into v_pep_mo
      from agendamiento a1, vtatabdst b1,operacion.ubi_tecnica c1,operacion.proyecto_sap d1,operacion.pep e1,vtatabslcfac f1
      where a1.codubi=b1.codubi and b1.region_sap=c1.region_sap and c1.tipo_sga=10 and c1.abrev=d1.ubitecnica and d1.anio=f_get_anio
      and d1.proyecto=e1.proyecto and e1.clasif_obra='MO' and d1.procesado='S' and e1.naturaleza_pep='INST' and a1.numslc=f1.numslc
      and a1.codsolot=an_codsolot;
      end if; --22.0
    end if;
    if v_tipsrv in ('0059') then--Ubicaciones tecnicas por Departamento para TPIs
--0059  Telefonía Pública de Interior     TLP CDMA      7
--0059  Telefonía Pública de Interior     TLP GSM        8
--0059  Telefonía Pública de Interior     TLP WMAX      9
      select c.idcampanha into n_idcampana
      from solotpto a, inssrv b, vtatabslcfac c
      where a.codsolot=an_codsolot and a.codinssrv=b.codinssrv
      and b.numslc=c.numslc;
      if n_idcampana=0 then
        n_tipo_sga:=7;
      end if;
      if n_idcampana=0 then
        n_tipo_sga:=8;
      end if;
      if n_idcampana=0 then
        n_tipo_sga:=9;
      end if;
     -- 22.0 Ini
      if n_cant> 0 then
        select e1.pep  into v_pep_mo
        from solot a1, vtatabdst b1,operacion.ubi_tecnica c1,operacion.proyecto_sap d1,operacion.pep e1,vtatabslcfac f1
        where a1.codubi=b1.codubi and b1.region_sap=c1.region_sap and c1.tipo_sga=n_tipo_sga and c1.abrev=d1.ubitecnica and d1.anio=f_get_anio
        and d1.proyecto=e1.proyecto and e1.clasif_obra='EM' and d1.procesado='S' and e1.naturaleza_pep='INST' and a1.numslc=f1.numslc
        and a1.codsolot=an_codsolot;
      else
        -- 22.0 Fin
    select e1.pep  into v_pep_mo
      from agendamiento a1, vtatabdst b1,operacion.ubi_tecnica c1,operacion.proyecto_sap d1,operacion.pep e1,vtatabslcfac f1
      where a1.codubi=b1.codubi and b1.region_sap=c1.region_sap and c1.tipo_sga=n_tipo_sga and c1.abrev=d1.ubitecnica and d1.anio=f_get_anio
      and d1.proyecto=e1.proyecto and e1.clasif_obra='EM' and d1.procesado='S' and e1.naturaleza_pep='INST' and a1.numslc=f1.numslc
      and a1.codsolot=an_codsolot;
     end if; --22.0
    end if;
    if v_tipsrv in ('0064') then--No es valido proyectos de clientes para CDMA
      v_pep_mo:=null;
    end if;

    return v_pep_mo;
  exception when others then
     return null;
  end;
end;

function f_get_pep_mo_corp(an_codsolot number,an_punto number,an_orden number) return varchar2
is
v_pep_mo operacion.pep.pep%type;
n_asigna_pep operacion.tiproy_sinergia.asigna_pep%type;
begin
  select  asigna_pep into n_asigna_pep from operacion.tiproy_sinergia where tiproy=f_get_tiproy(an_codsolot);
  if n_asigna_pep=1 then--HFC Construccion de Nodo por Etapa
    begin
      select c.pep into v_pep_mo
      from solotptoeta a, solot b, operacion.pep c , operacion.ETAPAXTIPOPEP d
      where a.codsolot=b.codsolot and b.codsolot=c.codsolot and c.id_seq=d.id_seq and a.codeta=d.codeta and
      a.codsolot=an_codsolot and a.punto=an_punto and a.orden=an_orden
      and c.anio=f_get_anio--8.0
      and c.procesado='S';
      return nvl(v_pep_mo,'NO_EXISTE_PEP');--9.0
    exception
      when no_data_found then
        begin
          select min(c.pep) into v_pep_mo--9.0
          from solotptoeta a, solot b, operacion.pep c  , operacion.tiproy_sinergia_pep d
          where a.codsolot=b.codsolot and b.codsolot=c.codsolot and
          a.codsolot=an_codsolot and a.punto=an_punto and a.orden=an_orden and c.id_seq=d.id_seq and d.pep_etapa=1
          and c.anio=f_get_anio--8.0
          and c.procesado='S';
          return nvl(v_pep_mo,'NO_EXISTE_PEP');--9.0
        exception
          when no_data_found then
            p_reg_log('Identificar PEP PPTO.',0,'NO_EXISTE_PEP',null,an_codsolot,null,null,null);
            return 'NO_EXISTE_PEP';
        end;
      when TOO_MANY_ROWS then
        p_reg_log('Identificar PEP PPTO.',0,'VARIOS_PEP',null,an_codsolot,null,null,null);
        return 'VARIOS_PEP';
    end;
  end if;
  if n_asigna_pep=2 then--Fibra Optica
    begin
      select c.pep into v_pep_mo
      from solotptoeta a, solot b, operacion.pep c , operacion.ETAPAXTIPOPEP d
      where a.codsolot=b.codsolot and b.codsolot=c.codsolot and c.id_seq=d.id_seq and a.codeta=d.codeta and
      a.codsolot=an_codsolot and a.punto=an_punto and a.orden=an_orden
      and c.anio=f_get_anio--8.0
      and c.procesado='S';
      return v_pep_mo;
    exception
      when no_data_found then
        return 'NO_EXISTE_PEP';
      when TOO_MANY_ROWS then
        return 'VARIOS_PEP';
    end;
  end if;

end;

function f_get_pep_equ_mas(an_codsolot number) return varchar2
is
--0058  Paquetes Pymes e Inmobiliario     CLIENTES WMAX  10
--0059  Telefonía Pública de Interior     TLP CDMA      7
--0059  Telefonía Pública de Interior     TLP GSM        8
--0059  Telefonía Pública de Interior     TLP WMAX      9
--0077  Paquetes inalambricos             DTH            6
--0064  Paquetes CDMA
v_pep_equ operacion.pep.pep%type;
v_tipsrv operacion.solot.tipsrv%type;
n_cant number; --22.0
begin
  select tipsrv into v_tipsrv from solot where codsolot=an_codsolot;
  select count(1) into n_cant from AGENLIQ.SGAT_AGENDA where codsolot=an_codsolot; --22.0
  begin
    if v_tipsrv in ('0061','0073') then --HFC
    -- 22.0 Ini
      if n_cant> 0 then
          select distinct d1.pep  into v_pep_equ
          from AGENLIQ.SGAT_AGENDA a1, operacion.ubi_tecnica b1, operacion.proyecto_sap c1,operacion.pep d1,operacion.tiproy_sinergia_pep e1, solot f1
          --Ini 12.0
        --where a1.idplano=b1.idplano and b1.abrev=c1.ubitecnica and c1.proyecto=d1.proyecto and c1.anio=f_get_anio and d1.clasif_obra='EM'
        where replace(LTRIM(trim(a1.AGENC_IDPLANO),'0'), 'Ñ', 'N')=b1.idplano and b1.abrev=c1.ubitecnica and c1.proyecto=d1.proyecto and c1.anio=f_get_anio and d1.clasif_obra='EM'
        --Fin 12.0
          and a1.codsolot=an_codsolot and d1.id_seq=e1.id_seq and e1.tipsrv=f1.tipsrv and c1.procesado='S' and e1.naturaleza_pep='INST'
          and a1.codsolot=f1.codsolot;
      else
         -- 22.0 fin
      select distinct d1.pep  into v_pep_equ
      from agendamiento a1, operacion.ubi_tecnica b1, operacion.proyecto_sap c1,operacion.pep d1,operacion.tiproy_sinergia_pep e1, solot f1
      --Ini 12.0
    --where a1.idplano=b1.idplano and b1.abrev=c1.ubitecnica and c1.proyecto=d1.proyecto and c1.anio=f_get_anio and d1.clasif_obra='EM'
    where replace(a1.idplano, 'Ñ', 'N')=b1.idplano and b1.abrev=c1.ubitecnica and c1.proyecto=d1.proyecto and c1.anio=f_get_anio and d1.clasif_obra='EM'
    --Fin 12.0
      and a1.codsolot=an_codsolot and d1.id_seq=e1.id_seq and e1.tipsrv=f1.tipsrv and c1.procesado='S' and e1.naturaleza_pep='INST'
      and a1.codsolot=f1.codsolot;
      end if; -- 22.0
    end if;
    if v_tipsrv in ('0077') then--Ubicaciones tecnicas por Departamento para DTH y Solucion de Venta
      -- 22.0 Ini
     if n_cant> 0 then
          select distinct e1.pep  into v_pep_equ
          from solot a1, vtatabdst b1,operacion.ubi_tecnica c1,operacion.proyecto_sap d1,operacion.pep e1,
          vtatabslcfac f1,operacion.solucionxtipopep g1
          where a1.codubi=b1.codubi and b1.region_sap=c1.region_sap and c1.tipo_sga=6 and c1.abrev=d1.ubitecnica and d1.anio=f_get_anio
          and d1.proyecto=e1.proyecto and e1.clasif_obra='EM' and d1.procesado='S' and e1.naturaleza_pep='INST' and a1.numslc=f1.numslc
          and e1.id_seq=g1.id_seq and f1.idsolucion=g1.idsolucion
          and a1.codsolot=an_codsolot;
      else
        -- 22.0 fin
      select distinct e1.pep  into v_pep_equ
      from agendamiento a1, vtatabdst b1,operacion.ubi_tecnica c1,operacion.proyecto_sap d1,operacion.pep e1,
      vtatabslcfac f1,operacion.solucionxtipopep g1
      where a1.codubi=b1.codubi and b1.region_sap=c1.region_sap and c1.tipo_sga=6 and c1.abrev=d1.ubitecnica and d1.anio=f_get_anio
      and d1.proyecto=e1.proyecto and e1.clasif_obra='EM' and d1.procesado='S' and e1.naturaleza_pep='INST' and a1.numslc=f1.numslc
      and e1.id_seq=g1.id_seq and f1.idsolucion=g1.idsolucion
      and a1.codsolot=an_codsolot;
      end if; -- 22.0
    end if;
    if v_tipsrv in ('0058') then--Ubicaciones tecnicas por Departamento para Wimax
   -- 22.0 Ini
      if n_cant> 0 then
        select e1.pep  into v_pep_equ
        from solot a1, vtatabdst b1,operacion.ubi_tecnica c1,operacion.proyecto_sap d1,operacion.pep e1,vtatabslcfac f1
        where a1.codubi=b1.codubi and b1.region_sap=c1.region_sap and c1.tipo_sga=10 and c1.abrev=d1.ubitecnica and d1.anio=f_get_anio
        and d1.proyecto=e1.proyecto and e1.clasif_obra='EM' and d1.procesado='S' and e1.naturaleza_pep='INST' and a1.numslc=f1.numslc
        and a1.codsolot=an_codsolot;
      else
        -- 22.0 fin
    select e1.pep  into v_pep_equ
      from agendamiento a1, vtatabdst b1,operacion.ubi_tecnica c1,operacion.proyecto_sap d1,operacion.pep e1,vtatabslcfac f1
      where a1.codubi=b1.codubi and b1.region_sap=c1.region_sap and c1.tipo_sga=10 and c1.abrev=d1.ubitecnica and d1.anio=f_get_anio
      and d1.proyecto=e1.proyecto and e1.clasif_obra='EM' and d1.procesado='S' and e1.naturaleza_pep='INST' and a1.numslc=f1.numslc
      and a1.codsolot=an_codsolot;
    end if; -- 22.0
    end if;
    if v_tipsrv in ('0059') then--Ubicaciones tecnicas por Departamento para TPIs
--0059  Telefonía Pública de Interior     TLP CDMA      7
--0059  Telefonía Pública de Interior     TLP GSM        8
--0059  Telefonía Pública de Interior     TLP WMAX      9
 -- 22.0 Ini
      if n_cant> 0 then
        select e1.pep  into v_pep_equ
        from solot a1, vtatabdst b1,operacion.ubi_tecnica c1,operacion.proyecto_sap d1,operacion.pep e1,vtatabslcfac f1
        where a1.codubi=b1.codubi and b1.region_sap=c1.region_sap and c1.tipo_sga=10 and c1.abrev=d1.ubitecnica and d1.anio=f_get_anio
        and d1.proyecto=e1.proyecto and e1.clasif_obra='EM' and d1.procesado='S' and e1.naturaleza_pep='INST' and a1.numslc=f1.numslc
        and a1.codsolot=an_codsolot;
      else
        --22.0 Fin
      select e1.pep  into v_pep_equ
      from agendamiento a1, vtatabdst b1,operacion.ubi_tecnica c1,operacion.proyecto_sap d1,operacion.pep e1,vtatabslcfac f1
      where a1.codubi=b1.codubi and b1.region_sap=c1.region_sap and c1.tipo_sga=10 and c1.abrev=d1.ubitecnica and d1.anio=f_get_anio
      and d1.proyecto=e1.proyecto and e1.clasif_obra='EM' and d1.procesado='S' and e1.naturaleza_pep='INST' and a1.numslc=f1.numslc
      and a1.codsolot=an_codsolot;
        end if; --22.00
    end if;
    if v_tipsrv in ('0064') then--No es valido proyectos de clientes para CDMA
      v_pep_equ:=null;
    end if;
    return v_pep_equ;
  exception when others then
     return null;
  end;
end;

function f_get_pep_equ_corp(an_codsolot number,an_punto number,an_orden number) return varchar2
is
v_pep_equ operacion.pep.pep%type;
v_tipsrv varchar2(6);
begin
  select tipsrv into v_tipsrv from solot where codsolot=an_codsolot;
  begin
    select c.pep into v_pep_equ
    from solotptoeta a, solot b, operacion.pep c , operacion.ETAPAXTIPOPEP d
    where a.codsolot=b.codsolot and b.codsolot=c.codsolot and c.id_seq=d.id_seq and a.codeta=d.codeta and
    a.codsolot=an_codsolot and a.punto=an_punto and a.orden=an_orden and c.procesado='S'
    and c.anio=f_get_anio;--8.0
    return v_pep_equ;
  exception when others then
     return null;
  end;
end;

function f_get_anio return varchar2
is
v_anio varchar2(4);
begin
  begin
    select valor into v_anio from constante where constante='ANIOSAPSINERGIA';
    return  v_anio;
  exception when others then
    return '2015';
  end;
end;

function f_val_pry_sinergia(an_codsolot number) return varchar2
is
n_valida number;
begin
  begin
    --Valida Proyecto Interno
    select count(1) into n_valida from solot s, vtatabslcfac b
    where s.numslc=b.numslc and s.codsolot=an_codsolot
    and b.tipo=5 and f_get_tiproy(an_codsolot) in (select tiproy from operacion.tiproy_sinergia where crea_proyecto=1);
    if n_valida>0 then
      return 'S';
    end if;
    --Valida Proyecto Ventas
    select count(1) into n_valida from opedd a, tipopedd b,solot c, vtatabslcfac d
    where a.tipopedd=b.tipopedd and b.abrev='SINERGIAPRYVENTAS' and c.tiptra=a.codigon
    and c.tipsrv=a.codigoc and c.codsolot=an_codsolot and c.numslc=d.numslc and d.tipo<>5;
    if n_valida>0 then
      return 'S';
    end if;
    return 'N';
  exception when others then
     return 'N';
  end;
end;


PROCEDURE p_importtaxrate(an_error out varchar2) is
lv_error   varchar2(3);
lv_code    varchar2(4);
lv_fecha   varchar(10);
lv_ult_dat varchar(1);

  begin
    lv_error := -1;
    select 'PE02' CO_CODE,to_char(sysdate, 'yyyy-mm-dd') FECHA,'X' ULTIMA_FECHA
    into lv_code, lv_fecha, lv_ult_dat from dual;

    WEBSERVICE.PQ_WS_SINERGIA.p_importtaxrate(lv_code,
                                                lv_fecha,
                                                lv_ult_dat,
                                                lv_error);
    an_error :=lv_error;
  end;

function f_get_ratio_tc(pmonde varchar2,pmonpara varchar2) return number
is
v_date date;
v_rate number;
begin
  if pmonde = pmonpara then
     v_rate := 1;
  end if;
  if pmonde <> pmonpara then
    Begin
      select distinct max(valid_date) into v_date from sgasap.sgasap_rates
      where from_currency=pmonde
      and to_currency =pmonpara;

      Select max(rate) into v_rate from sgasap.sgasap_rates
      where from_currency =pmonde
      and to_currency = pmonpara
      and valid_date = v_date;
    exception when others then
      if (pmonde = 'USD' and  pmonpara = 'PEN') then
        select max(r.ventca) into v_rate  from  PRODUCCION.CTBTIPCAM r where r.moneda_id = 2;
      else
        v_rate := 3.2;
      end if;
    end;
  end if;
  return v_rate;
end;

function f_split(ac_list varchar2, ac_del varchar2)
  return OPERACION.TAREA_ACT
  PIPELINED is
  l_idx  PLS_INTEGER;
  l_list varchar2(4000) := trim(ac_list);
begin
  if l_list is null or length(l_list) = 0 then
    return;
  end if;
  loop
    l_idx := INSTR(l_list, ac_del);
    if l_idx > 0 then
      pipe row(SUBSTR(l_list, 1, l_idx - 1));
      l_list := SUBSTR(l_list, l_idx + LENGTH(ac_del));
    else
      pipe row(l_list);
      exit;
    end if;
  end loop;
  return;
end;


procedure p_envia_correo_res(an_tran_solmat in number)
is
  f_doc     utl_file.file_type;
  v_correo  varchar2(200);
  v_ruta    varchar2(200);
  v_cuerpo  varchar2(4000);
  vnomarch  varchar2(400);
  v_subject varchar2(400);
  v_numreserva varchar2(40);

cursor c_res_cab is
select numreserva,to_char(sysdate, 'dd/mm/yyyy hh:mm:ss')  fec_usu,
a.codsolot , b.nombre contrata,d.nomcli,c.numslc, a.codusu,
(select min(cid)  from solotpto s1 where s1.codsolot=a.codsolot) cid
from operacion.reserva_cab a, contrata b, solot c, vtatabcli d
where tran_solmat=an_tran_solmat
and a.codsolot=c.codsolot and c.codcli=d.codcli and a.codcon=b.codcon;

cursor c_res_det is
select a.id_res,a.numreserva numreserva,a.fecha fecgenreserva,b.material cod_sap,f.desmat descripcion, b.cantidad,b.centro,b.almacen,
b.codusu solicitante,a.codsolot sot,  a.pep,d.nomcli cliente,e.nombre,0  transaccion,
(select observacion from solotptoequ where codsolot= a.codsolot and nro_res=a.numreserva and observacion is not null and rownum=1) observacion,'' tipo,'' ruc, null fec_atencion,
'' b_fecini, '' estado_res,'Reserva' sol_res
from operacion.reserva_cab a, operacion.reserva_det b,solot c,vtatabcli d,contrata e,almtabmat f
where a.id_res=b.id_res and a.codsolot=c.codsolot and c.codcli=d.codcli and a.codcon=e.codcon and b.material=f.cod_sap
and      a.numreserva is not null
and a.numreserva=v_numreserva;

begin
  v_cuerpo := '';
  v_cuerpo := v_cuerpo || '' || chr(13);
  v_cuerpo := v_cuerpo || 'Envio de Correo Automático' || chr(13);
  v_cuerpo := v_cuerpo || '' || chr(13);
  vnomarch := 'Tran_Sol_Mat - ' || to_char(an_tran_solmat) || '.txt';
  v_ruta := '/u03/oracle/PESGAPRD/UTL_FILE'; -- para produccion
  f_doc := utl_file.fopen(v_ruta, vnomarch, 'w');

  for c_c in c_res_cab loop
    v_numreserva:=c_c.numreserva;
    v_subject := 'Reserva - SOT ' || to_char(c_c.codsolot) || ' - ' ||
                 substr(c_c.nomcli, 1, 40); --<7.0>
    utl_file.put_line(f_doc, v_subject || chr(13));
    utl_file.put_line(f_doc,
                      'Transacción        : ' || an_tran_solmat ||
                      chr(13));
    utl_file.put_line(f_doc,
                      'Fecha de reserva   : ' || c_c.fec_usu || chr(13));
    utl_file.put_line(f_doc,
                      'Usuario de reserva : ' || c_c.codusu || chr(13));
    utl_file.put_line(f_doc,
                      'SOT                : ' || c_c.codsolot || chr(13));
    utl_file.put_line(f_doc,
                      'Contrata           : ' || c_c.contrata || chr(13));
    utl_file.put_line(f_doc,
                      'Cliente            : ' || c_c.nomcli || chr(13));
    utl_file.put_line(f_doc,
                      'Proyecto           : ' || c_c.numslc || chr(13));
    utl_file.put_line(f_doc,
                      'CID                : ' || c_c.cid || chr(13));
  end loop;

  for c_e in c_res_det loop
    utl_file.put_line(f_doc,
                      '---------------------------------------' ||
                      chr(13));
    utl_file.put_line(f_doc,
                      '*  R/S                : ' || c_e.sol_res ||
                      chr(13));
    utl_file.put_line(f_doc,
                      '*  Codigo SAP         : ' || c_e.cod_sap ||
                      chr(13));
    utl_file.put_line(f_doc,
                      '*  Reserva            : ' || c_e.numreserva ||
                      chr(13));
    utl_file.put_line(f_doc,
                      '*  Descripción        : ' || c_e.descripcion ||
                      chr(13));
    utl_file.put_line(f_doc,
                      '*  Cantidad           : ' || c_e.cantidad ||
                      chr(13));
    utl_file.put_line(f_doc,
                      '*  Observaciones      : ' || c_e.observacion ||
                      chr(13));
    utl_file.put_line(f_doc,
                      '*  Centro             : ' || c_e.centro ||
                      chr(13));
    utl_file.put_line(f_doc,
                      '*  Almacén            : ' || c_e.almacen ||
                      chr(13));
  end loop;

  utl_file.fclose(f_doc);
  p_envia_correo_c_attach(v_subject,'dl-pe-almacenes',
                          v_cuerpo,
                          sendmailjpkg.attachments_list(v_ruta || '/' ||
                                                        vnomarch),
                          'SGA'); -- para produccion

  select email into v_correo from usuarioope where usuario = user; -- para produccion
  if v_correo is not null then
    p_envia_correo_c_attach(v_subject,
                            v_correo,
                            v_cuerpo,
                            sendmailjpkg.attachments_list(v_ruta || '/' ||
                                                          vnomarch),
                            'SGA');
  end if;
end;

procedure p_ppto_masivo is
  v_error varchar2(400);
  v_pep operacion.solotptoetaact.pep%type;
  n_error number;
  err EXCEPTION;
  n_codsolot number;
  n_idloteppto number;
  v_proveedor_sap contrata.proveedor_sap%type;
  n_costo operacion.trs_ppto_det.total%type;
  n_costo_eq operacion.trs_ppto_det.total%type;
  n_costo_mo operacion.trs_ppto_det.total%type;
  n_idppto_det number;
  n_idppto number;
  n_tipo number;
  n_tipo_cambio number;
  n_idproceso number;
  --Identificar SOTs
  cursor c_sot is
   --11.0
   select a.codsolot, b.idplano, e.pep,e.clasif_obra  , g.proveedor_sap,
          decode(f.naturaleza_pep,'MANT',6, decode(e.clasif_obra,'EM',2,1)) tipo
    from operacion.OPE_SINERGIA_FILTROS_TMP a,agendamiento b,operacion.ubi_tecnica c,operacion.proyecto_sap d,operacion.pep e,
         operacion.tiproy_sinergia_pep f,contrata g, tipopedd h,opedd i, solot w
    where a.codsolot=b.codsolot and replace(b.idplano,'-','_') =c.idplano(+)  and c.abrev=d.ubitecnica and d.proyecto=e.proyecto and d.anio=f_get_anio
    and e.id_seq=f.Id_Seq and b.codcon=g.codcon and f.tipsrv=decode(a.tipo,'HFC','0061','0073') and a.codsolot=w.codsolot
    and h.abrev='SINERGIATIPTRASRVPPT' and h.tipopedd=i.tipopedd and f.naturaleza_pep=i.codigoc and w.tiptra=i.codigon
    and a.tipo in ('HFC','CEH')
    and  not exists (select 1 from operacion.trs_ppto_det det where det.codsolot=a.codsolot
                        and det.tipo=decode(f.naturaleza_pep,'MANT',6, decode(e.clasif_obra,'EM',2,1)));
  --11.0
  --Agrupar SOTs
  cursor c_agrup is
  select pep,proveedor_sap,tipo,sum(total)  total
  from operacion.TRS_PPTO_DET
  where procesado is null and idproceso=n_idproceso
  group by pep,proveedor_sap,tipo
  order by proveedor_sap;
  --Actualizar SOTs
  cursor c_act_sot is
  select CODSOLOT,idseq from  operacion.TRS_PPTO_DET
  where PEP=v_pep AND PROVEEDOR_sap=v_proveedor_sap
  AND TIPO=n_tipo  and idproceso=n_idproceso ;

Begin
  select OPERACION.SQ_PPTO_PROCESO.nextval,operacion.pq_Sinergia.f_get_ratio_tc('USD', 'PEN')
  into n_idproceso,n_tipo_cambio from dual;

  for c_s in c_sot loop
    if c_s.tipo=1 then --MO
      SELECT SUM(canliq*cosliq) into n_costo FROM SOLOTPTOETAACT where CODSOLOT=c_s.codsolot;
    end if;
    if c_s.tipo=2 then --EQ
      SELECT SUM(A1.CANTIDAD*(C1.preprm_usd*n_tipo_cambio)) into n_costo
      FROM SOLOTPTOEQU A1 ,TIPEQU B1, ALMTABMAT C1
      where A1.TIPEQU=B1.TIPEQU AND B1.CODTIPEQU=C1.CODMAT AND A1.codsolot=c_s.codsolot;
    end if;
    if c_s.tipo=6 then --MANTO tiene que actualizar la informacion de MO y EQ
      SELECT SUM(A1.CANTIDAD*(C1.preprm_usd*n_tipo_cambio)) into n_costo_eq
      FROM SOLOTPTOEQU A1 ,TIPEQU B1, ALMTABMAT C1
      where A1.TIPEQU=B1.TIPEQU AND B1.CODTIPEQU=C1.CODMAT AND A1.codsolot=c_s.codsolot;
      SELECT SUM(canliq*cosliq) into n_costo_mo FROM SOLOTPTOETAACT where CODSOLOT=c_s.codsolot;
      n_costo:=nvl(n_costo_mo,0)+nvl(n_costo_eq,0);
    end if;
    if n_costo >0 then
      select OPERACION.SQ_IDPPTO_DET.nextval into n_idppto_det from dual;
      insert into OPERACION.TRS_PPTO_DET(idseq,tipo,total,MANPARNO,pep,PROVEEDOR_SAP,codsolot,IDPROCESO)
      values(n_idppto_det,c_s.tipo,n_costo,C_S.IDPLANO,c_s.pep,c_s.proveedor_sap,c_s.codsolot,n_idproceso);
    end if;
    commit;--10.0
  end loop;
  commit;
  for c_a in c_agrup loop
    select operacion.SQ_IDLOTEPPTO.nextval into n_idloteppto from dummy_ope;
    select OPERACION.SQ_IDPPTO.NEXTVAL into n_idppto from dual;
    insert into operacion.Trs_Ppto(idppto, TIPO,total_pep,idloteppto,proveedor_sap,pep,contrato,idproceso,servicio)
    VALUES(n_idppto,c_a.tipo,c_a.total,n_idloteppto,c_a.proveedor_sap,c_a.pep,'SGA1',n_idproceso,'HFC');
    WEBSERVICE.PQ_WS_SINERGIA.P_PPTO_SGA(n_idloteppto,n_error,v_error);
    IF n_error < 0 THEN
      v_error := 'Presupuesto:' || v_error;
      RAISE err;
    else--Exito en el envio
      v_pep:=c_a.pep;
      v_proveedor_sap:=c_a.proveedor_sap;
      n_tipo:=c_a.tipo;
      for c_sot in c_act_sot loop
        if c_a.tipo=1 then --MO
          update solotptoetaact set pep=v_pep,idppto=n_idppto
          where codsolot=c_sot.codsolot and pep is null;
        end if;
        if c_a.tipo=2 then --EQ
          update solotptoequ set pep=v_pep,idppto=n_idppto
          where codsolot=c_sot.codsolot and pep is null;
        end if;
        if c_a.tipo=6 then --MANTO tiene que actualizar la informacion de MO y EQ
          update solotptoetaact set pep=v_pep,idppto=n_idppto
          where codsolot=c_sot.codsolot and pep is null;
          update solotptoequ set pep=v_pep,idppto=n_idppto
          where codsolot=c_sot.codsolot and pep is null;
        end if;
        update  operacion.TRS_PPTO_DET  set procesado='S',idloteppto=n_idloteppto,idppto=n_idppto
        where idseq=c_sot.idseq ;
        operacion.Pq_Sinergia.p_reg_log('PresupuestoMas',0, 'Se envia a Presupuesto ' || to_char(n_codsolot),null,n_codsolot,null,null,null);
        commit;--10.0
      end loop;
    END IF;
    COMMIT;
  end loop;

exception
  WHEN err THEN
    operacion.pq_sinergia.p_reg_log('Presupuesto .',n_error,v_error,null,null,null,null,null);
  when others then
    v_error:='Presupuesto:'|| to_char(1) ||'-'||sqlerrm;
    operacion.pq_sinergia.p_reg_log('Presupuesto_',sqlcode,v_error,null,null,null,null,null);
END;

procedure p_ppto_masivo_dth is
  v_error varchar2(400);
  v_pep operacion.solotptoetaact.pep%type;
  n_error number;
  err EXCEPTION;
  n_codsolot number;
  n_idloteppto number;
  v_proveedor_sap contrata.proveedor_sap%type;
  n_costo operacion.trs_ppto_det.total%type;
  n_costo_eq operacion.trs_ppto_det.total%type;
  n_costo_mo operacion.trs_ppto_det.total%type;
  n_idppto_det number;
  n_idppto number;
  n_tipo number;
  n_tipo_cambio number;
  n_idproceso number;
  n_tipo_contrata number;
  n_cant_decos number;
  --Identificar SOTs
  cursor c_sot is
  select a.codsolot ,B.IDPLANO, e.pep,e.clasif_obra  ,g.proveedor_sap, i.codigon_aux flag,
  decode(e.naturaleza_pep,'MANT',6, decode(e.clasif_obra,'EM',2,1)) tipo
  from solot a, agendamiento b, vtatabdst b1,operacion.Ubi_Tecnica c,operacion.proyecto_sap d,operacion.pep e,
  operacion.solucionxtipopep k,tipopedd h,opedd i,contrata g
  where a.codsolot=b.codsolot and b.codubi=b1.codubi and b1.region_sap=c.region_sap and c.tipo_sga=6
  and c.abrev=d.ubitecnica and d.proyecto=e.proyecto
  and (select c1.idsolucion from solotpto a1,inssrv b1,vtatabslcfac c1
  where a1.codinssrv=b1.codinssrv and b1.numslc=c1.numslc and a1.codsolot=a.codsolot and rownum=1) = k.idsolucion and e.Id_Seq=k.id_seq
  and h.abrev='SINERGIATIPTRASRVPPT' and h.tipopedd=i.tipopedd and e.naturaleza_pep=i.codigoc and a.tiptra=i.codigon
  and b.codcon=g.codcon and g.proveedor_sap is not null
  and  not exists (select 1 from operacion.trs_ppto_det det where det.codsolot=a.codsolot
  and det.tipo=decode(e.naturaleza_pep,'MANT',6, decode(e.clasif_obra,'EM',2,1)))
  and a.codsolot in (select codsolot from operacion.OPE_SINERGIA_FILTROS_TMP where tipo='DTH' ); -- 7.0

  --Agrupar SOTs
  cursor c_agrup is
  select pep,proveedor_sap,tipo,sum(total)  total
  from operacion.TRS_PPTO_DET
  where procesado is null and idproceso=n_idproceso
  group by pep,proveedor_sap,tipo
  order by proveedor_sap;
  --Actualizar SOTs
  cursor c_act_sot is
  select CODSOLOT,idseq from  operacion.TRS_PPTO_DET
  where PEP=v_pep AND PROVEEDOR_sap=v_proveedor_sap
  AND TIPO=n_tipo  and idproceso=n_idproceso ;

Begin
  select OPERACION.SQ_PPTO_PROCESO.nextval,operacion.pq_Sinergia.f_get_ratio_tc('USD', 'PEN')
  into n_idproceso,n_tipo_cambio from dual;

  for c_s in c_sot loop
    if c_s.tipo=1 then --MO
      if c_s.flag is null then
        n_costo:=175;
      else
        begin--Identificamos el tipo de contrata
          select c.tipo_contrata into n_tipo_contrata from solot a, agendamiento b, contrata c
          where a.codsolot=b.codsolot and b.codcon=c.codcon and a.codsolot=c_s.codsolot;
        Exception
          when no_data_found then
            n_tipo_contrata:=4;
        end;
        begin--Identificar la cantidad de decos
          select count(1) into n_cant_decos from solot a, solotptoequ b
          where a.codsolot=b.codsolot and a.codsolot=c_s.codsolot and b.numserie is not null and b.mac is not null;
        Exception
          when no_data_found then
            n_cant_decos:=4;
        end;
        begin--Identificar el costo total de mo incluido comisiones
          select a.codigon into n_costo from opedd a,tipopedd b
          where a.tipopedd=b.tipopedd and  b.abrev='SINERGIAPROVDTH'
          and a.codigoc=n_tipo_contrata and a.codigon_aux=n_cant_decos;
        Exception
          when no_data_found then
          n_costo:=175;
        end;
      end if;
    end if;
    if c_s.tipo=2 then --EQ
      SELECT SUM(A1.CANTIDAD*(C1.preprm_usd*n_tipo_cambio)) into n_costo
      FROM SOLOTPTOEQU A1 ,TIPEQU B1, ALMTABMAT C1
      where A1.TIPEQU=B1.TIPEQU AND B1.CODTIPEQU=C1.CODMAT AND A1.codsolot=c_s.codsolot;
    end if;
    if c_s.tipo=6 then --MANTO tiene que actualizar la informacion de MO y EQ
      SELECT SUM(A1.CANTIDAD*(C1.preprm_usd*n_tipo_cambio)) into n_costo_eq
      FROM SOLOTPTOEQU A1 ,TIPEQU B1, ALMTABMAT C1
      where A1.TIPEQU=B1.TIPEQU AND B1.CODTIPEQU=C1.CODMAT AND A1.codsolot=c_s.codsolot;
      SELECT SUM(canliq*cosliq) into n_costo_mo FROM SOLOTPTOETAACT where CODSOLOT=c_s.codsolot;
      n_costo:=nvl(n_costo_mo,0)+nvl(n_costo_eq,0);
    end if;
    if n_costo >0 then
      select OPERACION.SQ_IDPPTO_DET.nextval into n_idppto_det from dual;
      insert into OPERACION.TRS_PPTO_DET(idseq,tipo,total,MANPARNO,pep,PROVEEDOR_SAP,codsolot,IDPROCESO)
      values(n_idppto_det,c_s.tipo,n_costo,C_S.IDPLANO,c_s.pep,c_s.proveedor_sap,c_s.codsolot,n_idproceso);
    end if;
  end loop;
  commit;
  for c_a in c_agrup loop
    select operacion.SQ_IDLOTEPPTO.nextval into n_idloteppto from dummy_ope;
    select OPERACION.SQ_IDPPTO.NEXTVAL into n_idppto from dual;
    insert into operacion.Trs_Ppto(idppto, TIPO,total_pep,idloteppto,proveedor_sap,pep,contrato,idproceso,servicio)
    VALUES(n_idppto,c_a.tipo,c_a.total,n_idloteppto,c_a.proveedor_sap,c_a.pep,'SGA5',n_idproceso,'DTH');
      WEBSERVICE.PQ_WS_SINERGIA.P_PPTO_SGA(n_idloteppto,n_error,v_error);
      IF n_error < 0 THEN
        v_error := 'Presupuesto:' || v_error;
        RAISE err;
      else--Exito en el envio
        v_pep:=c_a.pep;
        v_proveedor_sap:=c_a.proveedor_sap;
        n_tipo:=c_a.tipo;
        for c_sot in c_act_sot loop
          if c_a.tipo=1 then --MO
            update solotptoetaact set pep=v_pep,idppto=n_idppto
            where codsolot=c_sot.codsolot and pep is null;
          end if;
          if c_a.tipo=2 then --EQ
            update solotptoequ set pep=v_pep,idppto=n_idppto
            where codsolot=c_sot.codsolot and pep is null;
          end if;
          if c_a.tipo=6 then --MANTO tiene que actualizar la informacion de MO y EQ
            update solotptoetaact set pep=v_pep,idppto=n_idppto
            where codsolot=c_sot.codsolot and pep is null;
            update solotptoequ set pep=v_pep,idppto=n_idppto
            where codsolot=c_sot.codsolot and pep is null;
          end if;
          update  operacion.TRS_PPTO_DET  set procesado='S',idloteppto=n_idloteppto,idppto=n_idppto
          where idseq=c_sot.idseq ;
          operacion.Pq_Sinergia.p_reg_log('PresupuestoMas',0, 'Se envia a Presupuesto ' || to_char(n_codsolot),null,n_codsolot,null,null,null);
        end loop;
      END IF;
    COMMIT;
  end loop;

exception
  WHEN err THEN
    operacion.pq_sinergia.p_reg_log('Presupuesto .',n_error,v_error,null,null,null,null,null);
  when others then
    v_error:='Presupuesto:'|| to_char(1) ||'-'||sqlerrm;
    operacion.pq_sinergia.p_reg_log('Presupuesto_',sqlcode,v_error,null,null,null,null,null);
END;



procedure p_ppto_masivo_tpi is
  v_error varchar2(400);
  v_pep operacion.solotptoetaact.pep%type;
  n_error number;
  err EXCEPTION;
  n_codsolot number;
  n_idloteppto number;
  v_proveedor_sap contrata.proveedor_sap%type;
  n_idppto_det number;
  n_idppto number;
  n_tipo number;
  n_tipo_cambio number;
  n_idproceso number;
  --Identificar SOTs
  cursor c_sot is
  select A1.codsolot,e1.manparno idplano,e1.pep,e1.clasif_obra  ,g1.proveedor_sap,decode(e1.clasif_obra,'EM',2,1) tipo,
  decode(e1.clasif_obra,'EM',(SELECT SUM(equ1.CANTIDAD*(alm.preprm_usd*2.7)) FROM SOLOTPTOEQU equ1 ,TIPEQU t1, ALMTABMAT alm
  where equ1.TIPEQU=t1.TIPEQU AND t1.CODTIPEQU=alm.CODMAT
  AND equ1.codsolot =A1.CODSOLOT),(SELECT SUM(canliq*cosliq) FROM SOLOTPTOETAACT where CODSOLOT=A1.CODSOLOT)) costo
  from agendamiento a1, vtatabdst b1,operacion.ubi_tecnica c1,operacion.proyecto_sap d1,operacion.pep e1,
  vtatabslcfac f1,contrata g1
  where a1.codubi=b1.codubi and b1.region_sap=c1.region_sap and c1.tipo_sga=decode(f1.idcampanha,74,8,48,7,38,9) and
  c1.abrev=d1.ubitecnica  and a1.codcon=g1.codcon
  and d1.proyecto=e1.proyecto and d1.procesado='S' and e1.naturaleza_pep='INST' and d1.anio=f_get_anio
  and a1.numslc=f1.numslc
  and g1.proveedor_sap is not null
  and  not exists (select 1 from operacion.trs_ppto_det det where det.codsolot=a1.codsolot and det.tipo=decode(e1.clasif_obra,'EM',2,1))
  and a1.codsolot in (select codsolot from operacion.OPE_SINERGIA_FILTROS_TMP where tipo='TPI' ); -- 7.0

--Agrupar SOTs
cursor c_agrup is
  select pep,proveedor_sap,tipo,sum(total)  total
  from operacion.TRS_PPTO_DET
  where procesado is null and idproceso=n_idproceso
  group by pep,proveedor_sap,tipo
  order by proveedor_sap;
  --Actualizar SOTs
  cursor c_act_sot is
  select CODSOLOT,idseq from  operacion.TRS_PPTO_DET
  where PEP=v_pep AND PROVEEDOR_sap=v_proveedor_sap AND TIPO=n_tipo
  and procesado is null and idproceso=n_idproceso;

Begin
  SELECT operacion.pq_Sinergia.f_get_ratio_tc('USD', 'PEN') into n_tipo_cambio FROM DUAL;
  select OPERACION.SQ_PPTO_PROCESO.nextval into n_idproceso from dual;
  for c_s in c_sot loop
    if c_s.costo is not null or c_s.costo=0 then
      select OPERACION.SQ_IDPPTO_DET.nextval into n_idppto_det from dual;
      insert into OPERACION.TRS_PPTO_DET(idseq,tipo,total,MANPARNO,pep,PROVEEDOR_SAP,codsolot,idproceso)
      values(n_idppto_det,c_s.tipo,c_s.costo,C_S.IDPLANO,c_s.pep,c_s.proveedor_sap,c_s.codsolot,n_idproceso);
    end if;
  end loop;
  commit;
  for c_a in c_agrup loop
    select operacion.SQ_IDLOTEPPTO.nextval into n_idloteppto from dummy_ope;
    select OPERACION.SQ_IDPPTO.NEXTVAL into n_idppto from dual;
    insert into operacion.Trs_Ppto(idppto, TIPO,total_pep,idloteppto,proveedor_sap,pep,contrato,SERVICIO,idproceso)
    VALUES(n_idppto,c_a.tipo,c_a.total,n_idloteppto,c_a.proveedor_sap,c_a.pep,'SGA4','TPI',n_idproceso);
    v_pep:=c_a.pep;
    v_proveedor_sap:=c_a.proveedor_sap;
    n_tipo:=c_a.tipo;
    WEBSERVICE.PQ_WS_SINERGIA.P_PPTO_SGA(n_idloteppto,n_error,v_error);
    n_error:=0;
    IF n_error < 0 THEN
      v_error := 'Presupuesto:' || v_error;
      RAISE err;
    else--Exito en el envio
      for c_s in c_act_sot loop
        if n_tipo=1 then --MO
          update solotptoetaact set pep=v_pep,idppto=n_idppto
          where codsolot=c_s.codsolot and pep is null;
        end if;
        if n_tipo=2 then --EQ
          update solotptoequ set pep=v_pep,idppto=n_idppto
          where codsolot=c_s.codsolot and pep is null;
        end if;
        update  operacion.TRS_PPTO_DET  set procesado='S',idloteppto=n_idloteppto,idppto=n_idppto
        where idseq=c_s.idseq ;
        operacion.Pq_Sinergia.p_reg_log('PresupuestoMas',0, 'Se envia a Presupuesto ' || to_char(n_codsolot),null,n_codsolot,null,null,null);
      end loop;
    end if;
  end loop;

exception
  WHEN err THEN
    operacion.pq_sinergia.p_reg_log('Presupuesto .',n_error,v_error,null,null,null,null,null);
  when others then
    v_error:='Presupuesto:'|| to_char(1) ||'-'||sqlerrm;
    operacion.pq_sinergia.p_reg_log('Presupuesto_',sqlcode,v_error,null,null,null,null,null);
END;
-- Ini 5.0
procedure p_ppto_masivo_wmx is
  v_error varchar2(400);
  v_pep operacion.solotptoetaact.pep%type;
  n_error number;
  err EXCEPTION;
  n_codsolot number;
  n_idloteppto number;
  v_proveedor_sap contrata.proveedor_sap%type;
  n_costo operacion.trs_ppto_det.total%type;
  n_costo_eq operacion.trs_ppto_det.total%type;
  n_costo_mo operacion.trs_ppto_det.total%type;
  n_idppto_det number;
  n_idppto number;
  n_tipo number;
  n_tipo_cambio number;
  n_idproceso number;
  --Identificar SOTs
  cursor c_sot is
  select a.codsolot ,B.IDPLANO, e.pep,e.clasif_obra  ,g.proveedor_sap, i.codigon_aux flag,
  decode(e.naturaleza_pep,'MANT',6, decode(e.clasif_obra,'EM',2,1)) tipo
  from solot a, agendamiento b, vtatabdst b1,operacion.Ubi_Tecnica c,operacion.proyecto_sap d,operacion.pep e,
  tipopedd h,opedd i,contrata g
  where a.codsolot=b.codsolot and b.codubi=b1.codubi and b1.region_sap=c.region_sap
  and c.abrev=d.ubitecnica and d.proyecto=e.proyecto   and c.tipo_sga=10 and d.anio=f_get_anio
  and h.abrev='SINERGIATIPTRASRVPPT' and h.tipopedd=i.tipopedd and e.naturaleza_pep=i.codigoc and a.tiptra=i.codigon
  and b.codcon=g.codcon(+)
  and a.codsolot in (select codsolot from operacion.OPE_SINERGIA_FILTROS_TMP where tipo='WMX'); -- 7.0

  --Agrupar SOTs
  cursor c_agrup is
  select pep,proveedor_sap,tipo,sum(total)  total
  from operacion.TRS_PPTO_DET
  where procesado is null and idproceso=n_idproceso
  group by pep,proveedor_sap,tipo
  order by proveedor_sap;
  --Actualizar SOTs
  cursor c_act_sot is
  select CODSOLOT,idseq from  operacion.TRS_PPTO_DET
  where PEP=v_pep AND PROVEEDOR_sap=v_proveedor_sap
  AND TIPO=n_tipo  and idproceso=n_idproceso ;

Begin
  select OPERACION.SQ_PPTO_PROCESO.nextval,operacion.pq_Sinergia.f_get_ratio_tc('USD', 'PEN')
  into n_idproceso,n_tipo_cambio from dual;

  for c_s in c_sot loop
    if c_s.tipo=1 then --MO
      SELECT SUM(canliq*cosliq) into n_costo FROM SOLOTPTOETAACT where CODSOLOT=c_s.codsolot;
    end if;
    if c_s.tipo=2 then --EQ
      SELECT SUM(A1.CANTIDAD*(C1.preprm_usd*n_tipo_cambio)) into n_costo
      FROM SOLOTPTOEQU A1 ,TIPEQU B1, ALMTABMAT C1
      where A1.TIPEQU=B1.TIPEQU AND B1.CODTIPEQU=C1.CODMAT AND A1.codsolot=c_s.codsolot;
    end if;
    if c_s.tipo=6 then --MANTO tiene que actualizar la informacion de MO y EQ
      SELECT SUM(A1.CANTIDAD*(C1.preprm_usd*n_tipo_cambio)) into n_costo_eq
      FROM SOLOTPTOEQU A1 ,TIPEQU B1, ALMTABMAT C1
      where A1.TIPEQU=B1.TIPEQU AND B1.CODTIPEQU=C1.CODMAT AND A1.codsolot=c_s.codsolot;
      SELECT SUM(canliq*cosliq) into n_costo_mo FROM SOLOTPTOETAACT where CODSOLOT=c_s.codsolot;
      n_costo:=nvl(n_costo_mo,0)+nvl(n_costo_eq,0);
    end if;
    if n_costo >0 then
      select OPERACION.SQ_IDPPTO_DET.nextval into n_idppto_det from dual;
      insert into OPERACION.TRS_PPTO_DET(idseq,tipo,total,MANPARNO,pep,PROVEEDOR_SAP,codsolot,IDPROCESO)
      values(n_idppto_det,c_s.tipo,n_costo,C_S.IDPLANO,c_s.pep,c_s.proveedor_sap,c_s.codsolot,n_idproceso);
    end if;
  end loop;
  commit;
  for c_a in c_agrup loop
    select operacion.SQ_IDLOTEPPTO.nextval into n_idloteppto from dummy_ope;
    select OPERACION.SQ_IDPPTO.NEXTVAL into n_idppto from dual;
    insert into operacion.Trs_Ppto(idppto, TIPO,total_pep,idloteppto,proveedor_sap,pep,contrato,idproceso,servicio)
    VALUES(n_idppto,c_a.tipo,c_a.total,n_idloteppto,c_a.proveedor_sap,c_a.pep,'SGA6',n_idproceso,'WMX');
      WEBSERVICE.PQ_WS_SINERGIA.P_PPTO_SGA(n_idloteppto,n_error,v_error);
      IF n_error < 0 THEN
        v_error := 'Presupuesto:' || v_error;
        RAISE err;
      else--Exito en el envio
        v_pep:=c_a.pep;
        v_proveedor_sap:=c_a.proveedor_sap;
        n_tipo:=c_a.tipo;
        for c_sot in c_act_sot loop
          if c_a.tipo=1 then --MO
            update solotptoetaact set pep=v_pep,idppto=n_idppto
            where codsolot=c_sot.codsolot and pep is null;
          end if;
          if c_a.tipo=2 then --EQ
            update solotptoequ set pep=v_pep,idppto=n_idppto
            where codsolot=c_sot.codsolot and pep is null;
          end if;
          if c_a.tipo=6 then --MANTO tiene que actualizar la informacion de MO y EQ
            update solotptoetaact set pep=v_pep,idppto=n_idppto
            where codsolot=c_sot.codsolot and pep is null;
            update solotptoequ set pep=v_pep,idppto=n_idppto
            where codsolot=c_sot.codsolot and pep is null;
          end if;
          update  operacion.TRS_PPTO_DET  set procesado='S',idloteppto=n_idloteppto,idppto=n_idppto
          where idseq=c_sot.idseq ;
          operacion.Pq_Sinergia.p_reg_log('PresupuestoMas',0, 'Se envia a Presupuesto ' || to_char(n_codsolot),null,n_codsolot,null,null,null);
        end loop;
      END IF;
    COMMIT;
  end loop;

exception
  WHEN err THEN
    operacion.pq_sinergia.p_reg_log('Presupuesto .',n_error,v_error,null,null,null,null,null);
  when others then
    v_error:='Presupuesto:'|| to_char(1) ||'-'||sqlerrm;
    operacion.pq_sinergia.p_reg_log('Presupuesto_',sqlcode,v_error,null,null,null,null,null);
END;
-- Fin 5.0

procedure p_ppto_corp is
--Procedimiento para enviar presupuesto Corporativo
v_error varchar2(400);
n_error number;
err EXCEPTION;
n_codsolot number;
n_idloteppto number;
n_idppto number;
n_monto number;
n_tipo_cambio number;
cursor c_agrup is
select A.CODSOLOT,B.PUNTO, B.ORDEN,D.PROVEEDOR_SAP ,B.ESTETA ,PEP.PEP ,
(select sum(d1.canliq*d1.cosliq)  from solotptoetaact d1
where d1.codsolot=b.codsolot and d1.punto=b.punto and d1.orden=b.orden) monto
from SOLOT A, SOLOTPTOETA B, OPERACION.PEP,CONTRATA D
where PEP.CODSOLOT=A.CODSOLOT AND A.CODSOLOT=B.CODSOLOT AND B.CODCON=D.CODCON
AND A.CODSOLOT in (select codsolot from operacion.OPE_SINERGIA_FILTROS_TMP where tipo='COR') -- 7.0
and b.esteta in (select codigon from opedd where tipopedd=1453)
and not exists (select 1 from operacion.trs_ppto trs where trs.codsolot=b.codsolot
    and trs.punto=b.punto and trs.orden=b.orden and tipo=4)
and pep.nivel=3;

Begin
  SELECT operacion.pq_Sinergia.f_get_ratio_tc('USD', 'PEN') into n_tipo_cambio FROM DUAL;

  for c_a in c_agrup loop
    if c_a.monto is not null or c_a.monto>0 and c_a.pep is not null then
      select sum(d1.canliq*d1.cosliq) into n_monto from solotptoetaact d1
      where d1.codsolot=c_a.codsolot and d1.punto=c_a.punto and d1.orden=c_a.orden;
      select operacion.SQ_IDLOTEPPTO.nextval into n_idloteppto from dummy_ope;
      select OPERACION.SQ_IDPPTO.NEXTVAL into n_idppto from dual;
      insert into operacion.Trs_Ppto(idppto, TIPO,total_pep,idloteppto,proveedor_sap,pep,contrato,punto,orden,codsolot)
      VALUES(n_idppto,4,n_monto,n_idloteppto,c_a.proveedor_sap,c_a.pep,null,c_a.punto,c_a.orden,c_a.codsolot);
      WEBSERVICE.PQ_WS_SINERGIA.P_PPTO_SGA(n_idloteppto,n_error,v_error);
      IF n_error < 0 THEN
        v_error := 'Presupuesto:' || v_error;
        RAISE err;
      else--Exito en el envio
        update solotptoetaact set pep=c_a.pep,idppto=n_idppto
        where codsolot=c_a.codsolot and punto=c_a.punto and orden=c_a.orden and (pep is null or pep like '41%');
        operacion.Pq_Sinergia.p_reg_log('PresupuestoMas',0, 'Se envia a Presupuesto ' || to_char(n_codsolot),null,n_codsolot,null,null,null);
      END IF;
      COMMIT;
    END IF;
  end loop;


exception
  WHEN err THEN
    operacion.pq_sinergia.p_reg_log('Presupuesto .',n_error,v_error,null,null,null,null,null);
  when others then
    v_error:='Presupuesto:'|| to_char(1) ||'-'||sqlerrm;
    operacion.pq_sinergia.p_reg_log('Presupuesto_',sqlcode,v_error,null,null,null,null,null);
END;

procedure p_ppto_mo_ef(an_codsolot in number) is
--Procedimiento para enviar presupuesto Corporativo
v_error varchar2(400);
n_error number;
err EXCEPTION;
n_codsolot number;
n_idloteppto number;
n_idppto number;
v_pep  varchar2(400);
n_tipo_cambio number;
cursor c_agrup is
select a.codsolot,d.punto,e.codeta,f.proveedor_sap, (e.cosmo*n_tipo_cambio) + (e.cosmo_s) monto
from SOLOT a,vtatabslcfac b , ef c, efpto d, efptoeta e,contrata f
where a.numslc=b.numslc and to_number(b.numslc) =c.codef and c.codef=d.codef
and d.codef=e.codef and d.punto=e.punto and d.codcon=f.codcon(+)
and a.CODSOLOT=an_codsolot
and not exists (select 1 from operacion.trs_ppto trs where trs.codsolot=a.codsolot
    and trs.punto=d.punto and trs.codeta=e.codeta and tipo=5);

Begin
  SELECT operacion.pq_Sinergia.f_get_ratio_tc('USD', 'PEN') into n_tipo_cambio FROM DUAL;

  for c_a in c_agrup loop
    select pep into v_pep from operacion.pep where  CODSOLOT=c_a.codsolot and nivel=3 and rownum=1 and procesado='S';
    if c_a.monto>0 and v_pep is not null then
      select operacion.SQ_IDLOTEPPTO.nextval into n_idloteppto from dummy_ope;
      select OPERACION.SQ_IDPPTO.NEXTVAL into n_idppto from dual;
      insert into operacion.Trs_Ppto(idppto, TIPO,total_pep,idloteppto,proveedor_sap,pep,punto,codsolot,CODETA)
      VALUES(n_idppto,5,c_a.monto,n_idloteppto,c_a.proveedor_sap,v_pep,c_a.punto,c_a.codsolot,c_a.codeta);
      WEBSERVICE.PQ_WS_SINERGIA.P_PPTO_SGA(n_idloteppto,n_error,v_error);
      IF n_error < 0 THEN
        v_error := 'Presupuesto:' || v_error;
        RAISE err;
      else--Exito en el envio
        operacion.Pq_Sinergia.p_reg_log('PresupuestoEFMO',0, 'Se envia a Presupuesto ' || to_char(n_codsolot),null,n_codsolot,null,null,null);
      END IF;
      COMMIT;
    END IF;
  end loop;


exception
  WHEN err THEN
    operacion.pq_sinergia.p_reg_log('PresupuestoMOEF .',n_error,v_error,null,null,null,null,null);
  when others then
   v_error:='PresupuestoMOEF:'|| to_char(1) ||'-'||sqlerrm;
    operacion.pq_sinergia.p_reg_log('PresupuestoMOEF',sqlcode,v_error,null,null,null,null,null);
END;


procedure p_reenvia_ppto is

    /*
    ****************************************************************
    * Nombre SP         : p_reenvia_ppto
    * Propósito         : Reenviar presupuesto
    * Input             :
    * Output            :
    * Creado por        :
    * Fec Creación      :
    * Actualizado por   : José Ruiz
    * Fec Actualización : 26/01/2017
    ****************************************************************
    */

n_err number;
v_err number;
l_cant_reint number; -- 14.0

  cursor C_ERR(l_cant_reint number) is
    select idloteppto, IDPPTO
      from OPERACION.TRS_PPTO
     where ((RECIBIDO = 'N' and RESPUESTA_SAP is null) or (RESPUESTA_SAP = 'E'))
       and N_REINTENTOS_PPTO < l_cant_reint;

  pragma autonomous_transaction;

  --Cursor para identificar tareas que realizan el PPTO 26.0
n_proceso number;
n_tarea number;
n_cont_equ number;
n_cont_equ_ok number;
  cursor c_tarea is
  select a.codigon
  from tipopedd b,opedd a
  where a.tipopedd=b.tipopedd and b.abrev='TAREADESCMATERIALES'
  and a.codigon_aux=n_proceso;
  --Cursor para identificar transacciones PPTO para Descargar Materiales 29.0
  cursor c_ppto is
  select a.idppto,a.codsolot,d.tarea,d.idtareawf
  from operacion.trs_ppto a , solot b, wf c, tareawf d
  where a.tipo=2 and a.codsolot=b.codsolot and a.respuesta_sap='S'
  and b.codsolot=c.codsolot and c.idwf=d.idwf and c.valido=1 and tarea=n_tarea and d.esttarea=1;

BEGIN

  select d.codigon
    into l_cant_reint
    from tipopedd c, opedd d
   where c.abrev = 'REINTENTOS_DESPACHO'
     and c.tipopedd = d.tipopedd
     and d.abreviacion = 'PRESUPUESTO';

  for C_E in C_ERR(l_cant_reint) loop
    dbms_lock.sleep(1);
    webservice.pq_ws_sinergia.P_PPTO_SGA (c_e.idloteppto,n_err,v_err);
    IF n_err < 0 THEN
      operacion.Pq_Sinergia.p_reg_log('Presupuesto_',0, 'ReenvioPresupuesto' || v_err,null,null,null,null,null);
    else--Exito en el envio
      operacion.Pq_Sinergia.p_reg_log('Presupuesto_',0, 'Reenvio Presupuesto' ,null,null,null,null,null);
    END IF;
     -- inicio 14.0
      update OPERACION.TRS_PPTO
         set N_REINTENTOS_PPTO = N_REINTENTOS_PPTO + 1
       where idloteppto = c_e.idloteppto
         and IDPPTO = c_e.idppto;
      commit;
      operacion.Pq_Sinergia.p_reg_log('Presupuesto',0,'ReenvioPresupuesto' || v_err,null,
                                    null,null,null,null);
     -- fin 14.0

  end loop;


  --29.0 Se identifican las SOTs y se cierra la tarea de PPTO para descargar materiales
  n_proceso:=1; --Solicitar Presupuesto
  for t in c_tarea loop
    n_tarea:=t.codigon;
    for c in c_ppto loop
      opewf.pq_wf.P_CHG_STATUS_TAREAWF(c.idtareawf,4,4,0,sysdate,sysdate);
    end loop;
  end loop;
  n_proceso:=2; --Descarga de Materiales SAP
  for t in c_tarea loop
    n_tarea:=t.codigon;
    for c in c_ppto loop
      select count(1) into n_cont_equ from solotptoequ where codsolot=c.codsolot and numserie is not null;
      select count(1) into n_cont_equ_ok from solotptoequ where codsolot=c.codsolot and fec_val_desp is not null and numserie is not null;
      if n_cont_equ_ok=n_cont_equ and n_cont_equ>0 then
        opewf.pq_wf.P_CHG_STATUS_TAREAWF(c.idtareawf,4,4,0,sysdate,sysdate);
      end if;
    end loop;
  end loop;
  commit;



end;

-- Ini 14.0

procedure p_proceso_descarga_auto  is
  v_error varchar2(400);
begin

      p_ppto_equ_mas;
      p_val_equ_mas(null);
      p_despacho_sap;

exception
    when others then
      v_error:='Descarga Automatica-'||sqlerrm;
      operacion.pq_sinergia.p_reg_log('Descarga Automatica',sqlcode,v_error,null,null,null,null,null);

end;

procedure p_ppto_equ_mas is

    /*
    ****************************************************************
    * Nombre SP         : p_ppto_equ_mas
    * Propósito         : Presupuesto masivo
    * Input             :
    * Output            :
    * Creado por        : Victor Cordero
    * Fec Creación      : 06/02/2017
    * Fec Actualización : N/A
    ****************************************************************
    */
v_tipo OPERACION.OPE_SINERGIA_FILTROS_TMP.tipo%type;
v_querybd varchar2(32767);
err EXCEPTION;
v_error varchar2(400);
n_error number;
TYPE SOTCurTipo IS REF CURSOR;
type PEPCurTipo is ref cursor;
SOT_Cursor SOTCurTipo;
PEP_Cursor PEPCurTipo;
n_tipo_cambio number;
n_idproceso number;
n_codsolot solot.codsolot%type;
v_idplano agendamiento.idplano%type;
v_pep solotptoequ.pep%type;
v_clasif_obra operacion.pep.clasif_obra%type;
v_proveedor varchar2(300);
n_tipo number;
n_idppto number;
n_idloteppto number;
n_idsolucion number;
n_idppto_det number;
n_idcampanha number;
n_costo operacion.trs_ppto_det.total%type;
n_costo_eq operacion.trs_ppto_det.total%type;
n_costo_mo operacion.trs_ppto_det.total%type;
n_val_cto number;
n_val_codsap number;
cursor c_pep is
select fase,query from operacion.CFG_ENV_CORREO_CONTRATA where TABLA='PEPMASIVOPPTO' and fase='HFC' ;
--Agrupar SOTs
cursor c_agrup is
select pep,proveedor_sap,tipo,sum(total)  total
from operacion.TRS_PPTO_DET
where procesado is null and idproceso=n_idproceso
group by pep,proveedor_sap,tipo
order by proveedor_sap;
--Actualizar SOTs
cursor c_act_sot is
select CODSOLOT,idseq from  operacion.TRS_PPTO_DET
where PEP=v_pep AND PROVEEDOR_sap=v_proveedor
AND tipo=n_tipo  and idproceso=n_idproceso ;

begin
  delete  OPERACION.OPE_SINERGIA_FILTROS_TMP;
  commit;
  select query into v_querybd from operacion.CFG_ENV_CORREO_CONTRATA where fase = PRESUPUESTO_MASIVO;
  open SOT_Cursor for v_querybd;
  loop
    fetch SOT_Cursor into n_codsolot;
    exit when SOT_Cursor%notfound;
      select min(d1.tipsrv) into v_tipo
      from solot a1,solotpto b1,inssrv c1,vtatabslcfac d1
      where a1.codsolot=b1.codsolot and b1.codinssrv=c1.codinssrv and c1.numslc=d1.numslc
      and a1.codsolot=n_codsolot;

      if v_tipo='0077' then--DTH validar si es masivo o CE
        select min(c1.idsolucion) into n_idsolucion from solotpto a1,inssrv b1,paquete_Venta c1
        where a1.codinssrv=b1.codinssrv and b1.idpaq=c1.idpaq
        and a1.codsolot=n_codsolot;
        if n_idsolucion=119 then
          v_tipo:='CDE';
        elsif n_idsolucion=217 then
          v_tipo:='LTE';
        else
          v_tipo:='CDT';
        end if;
      end if;
      if v_tipo='0059' then--TPI por Solucion
        select min(c1.idcampanha) into n_idcampanha from solotpto a1,inssrv b1,vtatabslcfac c1
        where a1.codinssrv=b1.codinssrv and b1.numslc=c1.numslc
        and a1.codsolot=n_codsolot;
        if n_idcampanha =38 then--Inalambrico
          v_tipo:='TLW';
        elsif n_idcampanha =48 then--CDMA
          v_tipo:='TLC';
        elsif n_idcampanha =74 then--GSM
          v_tipo:='TLG';
        else --HFC
          v_tipo:='CH1';
        end if;
      end if;
      insert into OPERACION.OPE_SINERGIA_FILTROS_TMP(tipo,codsolot)
      values(v_tipo,n_codsolot);
      commit;
  end loop;

  --Depurar PEPs
  for c_p in c_pep loop
    select operacion.SQ_PPTO_PROCESO.nextval,operacion.pq_Sinergia.f_get_ratio_tc('USD', 'PEN')
    into n_idproceso,n_tipo_cambio from dual;
    v_querybd:=c_p.query;
    open PEP_Cursor for v_querybd;
    loop
      fetch PEP_Cursor into n_codsolot,v_idplano,v_pep,v_clasif_obra,v_proveedor,n_tipo;
      exit when PEP_Cursor%notfound;

      if n_tipo=2 then --EQ
        SELECT SUM(A1.CANTIDAD*(C1.preprm_usd*n_tipo_cambio)) into n_costo
        FROM SOLOTPTOEQU A1 ,TIPEQU B1, ALMTABMAT C1
        where A1.TIPEQU=B1.TIPEQU AND B1.CODTIPEQU=C1.CODMAT AND A1.codsolot=n_codsolot;
      end if;
      if n_tipo=6 then --MANTO tiene que actualizar la informacion de MO y EQ
        SELECT SUM(A1.CANTIDAD*(C1.preprm_usd*n_tipo_cambio)) into n_costo_eq
        FROM SOLOTPTOEQU A1 ,TIPEQU B1, ALMTABMAT C1
        where A1.TIPEQU=B1.TIPEQU AND B1.CODTIPEQU=C1.CODMAT AND A1.codsolot=n_codsolot;
        SELECT SUM(canliq*cosliq) into n_costo_mo FROM SOLOTPTOETAACT where CODSOLOT=n_codsolot;
        n_costo:=nvl(n_costo_mo,0)+nvl(n_costo_eq,0);
      end if;
      if n_costo >0 then
        select count(1) into n_val_cto from solotptoequ A1 ,tipequ B1,almtabmat C1
        where A1.tipequ=B1.tipequ AND B1.codtipequ=C1.codmat AND A1.codsolot=n_codsolot and c1.preprm_usd=0;
        select count(1) into n_val_codsap from solotptoequ A1 ,tipequ B1,almtabmat C1
        where A1.tipequ=B1.tipequ AND B1.codtipequ=C1.codmat AND A1.codsolot=n_codsolot and c1.cod_sap is null;
        if n_val_cto+n_val_codsap=0 then
          select OPERACION.SQ_IDPPTO_DET.nextval into n_idppto_det from dual;
          insert into OPERACION.TRS_PPTO_DET(idseq,tipo,total,MANPARNO,pep,PROVEEDOR_SAP,codsolot,IDPROCESO)
          values(n_idppto_det,n_tipo,n_costo,v_idplano,v_pep,v_proveedor,n_codsolot,n_idproceso);
        else
          operacion.pq_sinergia.p_reg_log('Presupuesto_Error',0,'SOT equipos 0 o CODSAP Invalido',null,n_codsolot,null,null,null);
        end if;
      else--Costo 0
        operacion.pq_sinergia.p_reg_log('Presupuesto_Error',0,'SOT costo 0',null,n_codsolot,null,null,null);
      end if;
    end loop;

    for c_a in c_agrup loop
      select operacion.SQ_IDLOTEPPTO.nextval into n_idloteppto from dummy_ope;
      select OPERACION.SQ_IDPPTO.NEXTVAL into n_idppto from dual;
      insert into operacion.Trs_Ppto(idppto, TIPO,total_pep,idloteppto,proveedor_sap,pep,contrato,idproceso,servicio)
      VALUES(n_idppto,c_a.tipo,c_a.total,n_idloteppto,c_a.proveedor_sap,c_a.pep,'SGA1',n_idproceso,c_p.fase);
      WEBSERVICE.PQ_WS_SINERGIA.P_PPTO_SGA(n_idloteppto,n_error,v_error);
      if n_error < 0 THEN
        v_error := 'Presupuestos:' || v_error;
        RAISE err;
    else--Exito en el envio
        v_pep:=c_a.pep;
        v_proveedor:=c_a.proveedor_sap;
        n_tipo:=c_a.tipo;
        for c_sot in c_act_sot loop
          if c_a.tipo=2 then --EQ
            update solotptoequ set pep=v_pep,idppto=n_idppto
            where codsolot=c_sot.codsolot and pep is null;
          end if;
          if c_a.tipo=6 then --MANTO tiene que actualizar la informacion de MO y EQ
            update solotptoetaact set pep=v_pep,idppto=n_idppto
            where codsolot=c_sot.codsolot and pep is null;
            update solotptoequ set pep=v_pep,idppto=n_idppto
            where codsolot=c_sot.codsolot and pep is null;
          end if;
          update  operacion.TRS_PPTO_DET  set procesado='S',idloteppto=n_idloteppto,idppto=n_idppto
          where idseq=c_sot.idseq ;
          operacion.Pq_Sinergia.p_reg_log('PresupuestoMas',0, 'Se envia a Presupuesto idlote ' || to_char(n_idloteppto),null,n_codsolot,null,null,null);
          commit;
        end loop;
      end if;
      commit;
    end loop;
  end loop;
  exception
    WHEN err THEN
      operacion.pq_sinergia.p_reg_log('Presupuesto .',n_error,v_error,null,null,null,null,null);
    when others then
      v_error:='Presupuesto:-'||sqlerrm;
      operacion.pq_sinergia.p_reg_log('Presupuesto_',sqlcode,v_error,null,null,null,null,null);
end;

procedure p_val_equ_mas(k_codsolot operacion.solot.codsolot%type) is

    /*
    ****************************************************************
    * Nombre SP         : p_val_equ_mas
    * Propósito         : Actualizar campo Almacen, Centro y Clase Valoración en SOLOTPTOEQU
    * Input             :
    * Output            :
    * Creado por        : Victor Cordero
    * Fec Creación      : 25/01/2017
    * Fec Actualización : N/A
    ****************************************************************
    */
v_centro  varchar2(100);
err EXCEPTION;
v_almacen varchar2(100);
n_error number;
v_error varchar2(400);
v_querybd varchar2(32767);
v_centro1 solotptoequ.centrosap%type;
v_almacen1 solotptoequ.almacensap%type;
v_clase_val1 solotptoequ.clase_val%type;
v_clase_val varchar2(30);
n_codsolot number;
v_resp1 varchar2(32767);
n_err1 number;
v_err1 varchar2(32767);
cursor c_equ is
SELECT a.numserie,a.punto,a.orden,c.cod_sap FROM solotptoequ a,tipequ b, almtabmat c
WHERE a.codsolot = n_codsolot and a.tipequ=b.tipequ and b.codtipequ=c.codmat
and a.numserie is not null order by a.numserie;

TYPE PptoCurTipo IS REF CURSOR;
PPTO_Cursor PptoCurTipo;

begin

  if (k_codsolot is not null) then
       -- Solot Individual
       v_querybd := 'select ' || to_char(k_codsolot) || ' from dual';

  else
      -- Universo de SOT
      select query
        into v_querybd
        from operacion.CFG_ENV_CORREO_CONTRATA
      where fase = VALIDA_DESPACHO;
  end if;


  open PPTO_Cursor for v_querybd;
  loop
    fetch PPTO_Cursor into n_codsolot;
    exit when PPTO_Cursor%notfound;

      v_centro:= null;
      v_almacen:= null;
      v_clase_val:=null;

    -- Equipos de la SOT
    for c_e in c_equ loop

      v_clase_val1 := null;
      v_almacen1 := null;
      v_centro1 := null;

      if c_e.numserie is not null then--Validar en SAP

        WEBSERVICE.PQ_WS_SINERGIA.p_consulta_serie(c_e.cod_sap,c_e.numserie,v_resp1,n_err1,v_err1);

        if n_err1=0 then
          select centro,almacen,clase_val into v_centro1,v_almacen1,v_clase_val1
          from maestro_series_equ where nroserie=c_e.numserie and cod_sap=c_e.cod_sap;
        end if;

        if v_centro1 is null then
          update solotptoequ set
          FEC_VAL_DESP = SYSDATE, COD_RPTA_VAL_DESP = '2', MSG_RPTA_VAL_DESP = 'Serie no existe en SAP'
          where codsolot=n_codsolot and punto=c_e.punto and orden=c_e.orden;
        else
          v_centro:=v_centro1;
          v_almacen:=v_almacen1;
          v_clase_val:=v_clase_val1;
          update solotptoequ set centrosap=v_centro,almacensap=v_almacen1,clase_val=v_clase_val,pccodtarea=v_err1,fecfdis=sysdate,
          FEC_VAL_DESP = SYSDATE, COD_RPTA_VAL_DESP = '0', MSG_RPTA_VAL_DESP = 'Validacion OK'
          where codsolot=n_codsolot and punto=c_e.punto and orden=c_e.orden;
        end if;
      end if;
    end loop;

    if v_centro is not null then--Con series validas

      update solotptoequ set
      centrosap=v_centro,
      almacensap=v_almacen,
      clase_val=v_clase_val,
      FEC_VAL_DESP = SYSDATE,
      COD_RPTA_VAL_DESP = '0',
      MSG_RPTA_VAL_DESP = 'Validacion OK'
      where codsolot=n_codsolot and numserie is null;

    else

      v_clase_val1 := null;
      v_almacen1 := null;
      v_centro1 := null;

      begin
        select almacen, centro into v_almacen1, v_centro1 from
        (select ALMACEN, CENTRO
        from DEPTXCONTRATA d
        inner join z_mm_configuracion z
        on d.idsucxcontrata = z.operador and flag_val = 'S'
        where estado = 1  and rownum = 1 and idsucxcontrata in
        (select idsucxcontrata
        from SUCURSALXCONTRATA s
        inner join agendamiento a
        on s.codcon = a.codcon
        where codsolot = n_codsolot));

       Exception  when no_data_found then

        v_almacen1 := null;
        v_centro1 := null;

      end;

      if (v_almacen1 is null and v_centro1 is null) then
        update solotptoequ set
        FEC_VAL_DESP = SYSDATE, COD_RPTA_VAL_DESP = '1', MSG_RPTA_VAL_DESP = 'Centro/Almacen no encontrados'
        where codsolot=n_codsolot and numserie is null;
      else
        update solotptoequ set centrosap=v_centro1,almacensap=v_almacen1,clase_val='VALORADO',
        FEC_VAL_DESP = SYSDATE, COD_RPTA_VAL_DESP = '0', MSG_RPTA_VAL_DESP = 'Validacion OK'
        where codsolot=n_codsolot and numserie is null;
      end if;

    end if;

    commit;

  end loop;

exception
    WHEN err THEN
      operacion.pq_sinergia.p_reg_log('Validacion SAP',n_error,v_error,null,null,null,null,null);
    when others then
      v_error:='Validacion-'||sqlerrm;
      operacion.pq_sinergia.p_reg_log('Validacion SAP',sqlcode,v_error,null,null,null,null,null);
end;

procedure p_despacho_sap is

    /*
    ****************************************************************
    * Nombre SP         : p_despacho_sap
    * Propósito         : Realizar el despacho automatico del material ó equipo asociado a una SOT atendida.
    * Input             :
    * Output            :
    * Creado por        : Victor Cordero
    * Fec Creación      : 25/01/2017
    * Fec Actualización : N/A
    ****************************************************************
    */


n_id_lote_despacho number;

n_idcab number;
v_target_url operacion.OPE_CAB_XML.target_url%type;
n_idtrs number;
v_xml  nclob;
v_xmlaux  nclob;
n_reintentos number;

n_idcab_item number;
v_xml_item nclob;
v_xml_itemaux nclob;

n_item number;

lc_respuestaxml varchar2(32767);
n_error number;
n_docmaterial number;
v_mensaje varchar2(4000);

v_almacen operacion.pivot_sot_despacho.almacen%type;
v_centro operacion.pivot_sot_despacho.centro%type;
v_clase_val operacion.pivot_sot_despacho.clase_val%type;

v_almacen_aux operacion.pivot_sot_despacho.almacen%type;
v_centro_aux operacion.pivot_sot_despacho.centro%type;
v_clase_val_aux operacion.pivot_sot_despacho.clase_val%type;

v_error varchar2(32767);

begin

  -- IdLote
  select operacion.sec_pivot_sot_despacho.nextval
  into n_id_lote_despacho
  from dual;

  insert into operacion.pivot_sot_despacho (id_lote, id_item, fec_reg, usu_reg, fec_mod, usu_mod,
  nro_guia_rem, nro_material, nro_serie, fec_contabilizacion, fec_documento,
  cabecera_documento, cant_necesaria, centro, almacen, lote, clase_val,
  nro_reserva, nro_pos_reserva, elemento_pep, estado, cod_rpta, msg_rpta, nro_reintentos)

  select n_id_lote_despacho, ROWNUM, SYSDATE, USER, SYSDATE, USER,
  lpad(trim(c.codsolot), 8, '0') || '-' || to_char(ROWNUM)  nro_guia_rem,
  e.cod_sap nro_material,
  c.numserie num_serie, SYSDATE, SYSDATE, ' ' cabecera,
  c.cantidad cantidad,
  nvl(c.centrosap, ' ') centrosap,
  nvl(c.almacensap, ' ') almacensap, ' ' lote,
  nvl(c.clase_val, ' ') clase_val, NULL nro_reserva, NULL nro_pos_reserva,
  nvl(c.pep , ' ') pep, 1 estado, COD_RPTA_VAL_DESP, MSG_RPTA_VAL_DESP, 0 nro_reintento
  from solotptoequ c
  inner join agendamiento b on b.idagenda=c.idagenda
  inner join tipequ d on c.tipequ=d.tipequ
  inner join almtabmat e on d.codtipequ=e.codmat
  where (to_date(c.fec_val_desp) = to_date(sysdate));

  for solot in (  select distinct(SUBSTR(nro_guia_rem, 0,8)) as cod
                  from operacion.pivot_sot_despacho
                  where estado = 4 )
  loop

    v_almacen_aux := null;
    v_centro_aux := null;
    v_clase_val_aux := null;

    p_val_equ_mas(solot.cod);

    for equ in (select nro_serie as serie
                from operacion.pivot_sot_despacho
                where estado = 4 and (SUBSTR(nro_guia_rem, 0,8)) = solot.cod and nro_serie is not null)
    loop

        v_almacen := null;
        v_centro := null;
        v_clase_val := null;

      begin

        select almacensap almacen, centrosap centro, clase_val clase_val into v_almacen, v_centro, v_clase_val
        from operacion.solotptoequ
        where codsolot = solot.cod and numserie = equ.serie
        and almacensap != ' ' and centrosap != ' ' and clase_val != ' ' and rownum = 1;

      Exception  when no_data_found then
           v_almacen := null;

      end;

        if (v_almacen is not null and v_centro is not null and v_clase_val is not null) then

            v_almacen_aux := v_almacen;
            v_centro_aux := v_centro;
            v_clase_val_aux := v_clase_val;

           update operacion.pivot_sot_despacho
              set almacen   = v_almacen, centro    = v_centro, clase_val = v_clase_val
           where estado = 4
              and SUBSTR(nro_guia_rem, 0, 8) = solot.cod
              and nro_serie = equ.serie;
        end if;

  end loop;

     -- materiales
     IF (v_almacen_aux is not null and v_centro_aux is not null and v_clase_val_aux is not null) THEN

       update operacion.pivot_sot_despacho
          set almacen   = v_almacen_aux, centro = v_centro_aux, clase_val = v_clase_val_aux
       where SUBSTR(nro_guia_rem, 0, 8) = solot.cod
          and estado = 4 and nro_serie is null;

     end if;

  end loop;

  select d.codigon into n_reintentos
    from tipopedd c, opedd d
   where c.abrev = 'REINTENTOS_DESPACHO' and c.tipopedd = d.tipopedd and d.abreviacion = 'DESPACHO';

  select idcab, target_url, xmlclob into n_idcab, v_target_url, v_xmlaux
  from operacion.ope_cab_xml where titulo = 'DESPACHO';

  select n_idcab_item, xmlclob into n_idcab_item, v_xml_itemaux
  from operacion.ope_cab_xml where titulo = 'ITEM_DESPACHO';

  n_item := 1;

  FOR psd IN (select psd.* ,
              SUBSTR(nro_guia_rem, 0,8) codsolot,
              to_char(psd.fec_contabilizacion,'YYYYMMDD') fecha_contabilizacion,
              to_char(psd.fec_documento ,'YYYYMMDD') fecha_documento
              from operacion.pivot_sot_despacho psd)
    LOOP

    -- Validar datos completos
    IF ( psd.nro_material = ' '
      or psd.almacen = ' '
      or psd.centro = ' '
      or psd.clase_val = ' ') then

        UPDATE OPERACION.PIVOT_SOT_DESPACHO
        SET FEC_MOD = SYSDATE,
            USU_MOD = USER,
            ESTADO = 4, -- Procesado con Error
            NRO_REINTENTOS = NVL(NRO_REINTENTOS,0) + 1
        WHERE id_lote = psd.id_lote
        AND   id_item = psd.id_item;


        INSERT INTO OPERACION.PIVOT_SOT_DESPACHO_HIST_ERROR
          (ID_LOTE, ID_ITEM, FEC_REG,USU_REG, FEC_MOD, USU_MOD,NRO_GUIA_REM, NRO_MATERIAL, NRO_SERIE,FEC_CONTABILIZACION, FEC_DOCUMENTO, CABECERA_DOCUMENTO,CANT_NECESARIA, CENTRO, ALMACEN,LOTE, CLASE_VAL, NRO_RESERVA,
           NRO_POS_RESERVA, ELEMENTO_PEP, FLG_CORRECCION,ESTADO, COD_RPTA, MSG_RPTA)
          SELECT ID_LOTE, ID_ITEM,SYSDATE,USER, SYSDATE, USER,NRO_GUIA_REM, NRO_MATERIAL, NRO_SERIE,FEC_CONTABILIZACION, FEC_DOCUMENTO, CABECERA_DOCUMENTO,CANT_NECESARIA, CENTRO, ALMACEN,LOTE, CLASE_VAL, NRO_RESERVA, NRO_POS_RESERVA, ELEMENTO_PEP, 0,ESTADO, COD_RPTA, MSG_RPTA
            FROM OPERACION.PIVOT_SOT_DESPACHO
           WHERE ID_LOTE = psd.id_lote
             AND ID_ITEM = psd.id_item;

    ELSE

        SELECT OPERACION.SQ_OPE_WS_SGASAP.NEXTVAL INTO n_idtrs FROM dual;

        v_xml := v_xmlaux;
        v_xml_item := v_xml_itemaux;

        WEBSERVICE.PQ_WS_SINERGIA.p_reg_xml(v_xml_item, 'f_sot', psd.nro_guia_rem, 1, v_xml_item);
        WEBSERVICE.PQ_WS_SINERGIA.p_reg_xml(v_xml_item, 'f_nroMaterial', psd.nro_material , 1, v_xml_item);
        WEBSERVICE.PQ_WS_SINERGIA.p_reg_xml(v_xml_item, 'f_fechaContabilizacionDocumento',  psd.fecha_contabilizacion , 1, v_xml_item);
        WEBSERVICE.PQ_WS_SINERGIA.p_reg_xml(v_xml_item, 'f_fechaDocumento', psd.fecha_documento , 1, v_xml_item);
        WEBSERVICE.PQ_WS_SINERGIA.p_reg_xml(v_xml_item, 'f_textoCabeceraDocumento', psd.cabecera_documento , 1, v_xml_item);
        WEBSERVICE.PQ_WS_SINERGIA.p_reg_xml(v_xml_item, 'f_cantidadNecesaria', psd.cant_necesaria , 1, v_xml_item);
        WEBSERVICE.PQ_WS_SINERGIA.p_reg_xml(v_xml_item, 'f_claseMovimiento', '221', 1, v_xml_item);
        WEBSERVICE.PQ_WS_SINERGIA.p_reg_xml(v_xml_item, 'f_centro', psd.centro , 1, v_xml_item);
        WEBSERVICE.PQ_WS_SINERGIA.p_reg_xml(v_xml_item, 'f_almacen', psd.almacen , 1, v_xml_item);
        WEBSERVICE.PQ_WS_SINERGIA.p_reg_xml(v_xml_item, 'f_numeroLote', psd.clase_val, 1, v_xml_item);
        WEBSERVICE.PQ_WS_SINERGIA.p_reg_xml(v_xml_item, 'f_nroReserva', psd.nro_reserva, 1, v_xml_item);
        WEBSERVICE.PQ_WS_SINERGIA.p_reg_xml(v_xml_item, 'f_numeroPosicionReservas', psd.nro_pos_reserva, 1, v_xml_item);
        WEBSERVICE.PQ_WS_SINERGIA.p_reg_xml(v_xml_item, 'f_elementoPEP', psd.elemento_pep , 1, v_xml_item);
        WEBSERVICE.PQ_WS_SINERGIA.p_reg_xml(v_xml_item, 'f_numeroSerie', psd.nro_serie , 1, v_xml_item);

        FOR c_s in (  select idcab, idseq, campo, nombrecampo, tipo
                      from OPERACION.OPE_DET_XML
                      where idcab = n_idcab and estado=1)

        LOOP
          WEBSERVICE.PQ_WS_SINERGIA.p_reg_xml(v_xml, c_s.campo, c_s.nombrecampo, c_s.tipo,v_xml, 1);
        END LOOP;
        WEBSERVICE.PQ_WS_SINERGIA.p_reg_xml(v_xml, 'f_idTransaccion', n_idtrs, 1, v_xml);
        WEBSERVICE.PQ_WS_SINERGIA.p_reg_xml(v_xml, 'f_despachoItems', v_xml_item, 1, v_xml);


        INSERT INTO OPERACION.OPE_WS_SGASAP(IDTRS,ESQUEMAXML,TIPO, ID_UBITECNICA, NUMSLC, CODSOLOT)
        VALUES(n_idtrs, v_xml,'DESPACHO',null,null, psd.codsolot);

        lc_RESPUESTAXML := WEBSERVICE.PQ_WS_SINERGIA.F_CALL_WEBSERVICE(v_xml, v_target_url);
        n_error:= WEBSERVICE.PQ_WS_SINERGIA.f_get_atributo(lc_RESPUESTAXML, 'codigoRespuesta');
        n_docmaterial:= WEBSERVICE.PQ_WS_SINERGIA.f_get_atributo(lc_RESPUESTAXML, 'numeroDocumentoMaterial');
        v_mensaje:= WEBSERVICE.PQ_WS_SINERGIA.f_get_atributo(lc_RESPUESTAXML, 'MENSAJE');

        UPDATE OPERACION.OPE_WS_SGASAP
        SET RESPUESTAXML = lc_RESPUESTAXML,
            ERROR = n_error
        WHERE IDTRS = n_idtrs;


        IF (n_error != 0) THEN
           UPDATE OPERACION.PIVOT_SOT_DESPACHO
            SET FEC_MOD = SYSDATE, USU_MOD = USER,
                ESTADO = 4, -- Procesado con Error
                COD_RPTA = 6, -- Error
                MSG_RPTA = 'Error con la conexion o errores no controlados de SAP',
                NRO_REINTENTOS = NVL(NRO_REINTENTOS,0) + 1
            WHERE id_lote = psd.id_lote
            AND   id_item = psd.id_item;

            INSERT INTO OPERACION.PIVOT_SOT_DESPACHO_HIST_ERROR
              (ID_LOTE, ID_ITEM, FEC_REG, USU_REG, FEC_MOD, USU_MOD,NRO_GUIA_REM, NRO_MATERIAL, NRO_SERIE, FEC_CONTABILIZACION, FEC_DOCUMENTO, CABECERA_DOCUMENTO,CANT_NECESARIA, CENTRO, ALMACEN, LOTE, CLASE_VAL, NRO_RESERVA,NRO_POS_RESERVA, ELEMENTO_PEP, FLG_CORRECCION,ESTADO, COD_RPTA, MSG_RPTA)
            SELECT ID_LOTE, ID_ITEM, SYSDATE,USER, SYSDATE, USER,NRO_GUIA_REM, NRO_MATERIAL, NRO_SERIE,FEC_CONTABILIZACION, FEC_DOCUMENTO, CABECERA_DOCUMENTO,CANT_NECESARIA, CENTRO, ALMACEN, LOTE, CLASE_VAL, NRO_RESERVA,NRO_POS_RESERVA, ELEMENTO_PEP, 0,ESTADO, COD_RPTA, MSG_RPTA
              FROM OPERACION.PIVOT_SOT_DESPACHO
             WHERE ID_LOTE = psd.id_lote
               AND ID_ITEM = psd.id_item;
        ELSE
            IF (n_docmaterial != -1) THEN

              INSERT INTO OPERACION.PIVOT_SOT_DESPACHO_HIST
              (ID_LOTE, ID_ITEM, FEC_REG,USU_REG, FEC_MOD, USU_MOD,NRO_GUIA_REM, NRO_MATERIAL, NRO_SERIE, FEC_CONTABILIZACION, FEC_DOCUMENTO, CABECERA_DOCUMENTO,CANT_NECESARIA, CENTRO, ALMACEN,LOTE, CLASE_VAL, NRO_RESERVA,NRO_POS_RESERVA, ELEMENTO_PEP, ESTADO, COD_RPTA, MSG_RPTA)
              SELECT ID_LOTE, ID_ITEM,SYSDATE,USER, SYSDATE, USER,NRO_GUIA_REM, NRO_MATERIAL, NRO_SERIE, FEC_CONTABILIZACION, FEC_DOCUMENTO, CABECERA_DOCUMENTO, CANT_NECESARIA, CENTRO, ALMACEN, LOTE, CLASE_VAL, NRO_RESERVA, NRO_POS_RESERVA, ELEMENTO_PEP,3, 0, 'Item despachado correctamente'
                FROM OPERACION.PIVOT_SOT_DESPACHO
               WHERE ID_LOTE = psd.id_lote AND ID_ITEM = psd.id_item;

               UPDATE OPERACION.PIVOT_SOT_DESPACHO_HIST_ERROR
               SET FLG_CORRECCION = 1
               WHERE ID_LOTE = psd.id_lote AND ID_ITEM = psd.id_item;

               DELETE FROM OPERACION.PIVOT_SOT_DESPACHO
               WHERE ID_LOTE = psd.id_lote AND ID_ITEM = psd.id_item;

             ELSE

               UPDATE OPERACION.PIVOT_SOT_DESPACHO
                SET FEC_MOD = SYSDATE,
                    USU_MOD = USER,
                    ESTADO = 4, -- Procesado con Error
                    COD_RPTA = 2, -- Error
                    MSG_RPTA = v_mensaje,
                    NRO_REINTENTOS = NVL(NRO_REINTENTOS,0) + 1
                WHERE id_lote = psd.id_lote AND id_item = psd.id_item;

                INSERT INTO OPERACION.PIVOT_SOT_DESPACHO_HIST_ERROR
                  (ID_LOTE, ID_ITEM, FEC_REG,USU_REG, FEC_MOD, USU_MOD,NRO_GUIA_REM, NRO_MATERIAL, NRO_SERIE, FEC_CONTABILIZACION, FEC_DOCUMENTO, CABECERA_DOCUMENTO,CANT_NECESARIA, CENTRO, ALMACEN, LOTE, CLASE_VAL, NRO_RESERVA,NRO_POS_RESERVA, ELEMENTO_PEP, FLG_CORRECCION, ESTADO, COD_RPTA, MSG_RPTA)
                SELECT ID_LOTE, ID_ITEM,SYSDATE, USER, SYSDATE, USER, NRO_GUIA_REM, NRO_MATERIAL, NRO_SERIE,FEC_CONTABILIZACION, FEC_DOCUMENTO, CABECERA_DOCUMENTO, CANT_NECESARIA, CENTRO, ALMACEN, LOTE, CLASE_VAL, NRO_RESERVA,NRO_POS_RESERVA, ELEMENTO_PEP, 0,ESTADO, COD_RPTA, MSG_RPTA
                  FROM OPERACION.PIVOT_SOT_DESPACHO
                 WHERE ID_LOTE = psd.id_lote
                   AND ID_ITEM = psd.id_item
                   AND NRO_REINTENTOS < n_reintentos;


             END IF;

        END IF;

        n_item := n_item + 1;

    END IF;

  END LOOP;


    -- INSERTAR EN ERRORES SI SUPERA EL NUMERO MAXIMO DE REINTENTOS
    INSERT INTO OPERACION.PIVOT_SOT_DESPACHO_HIST_ERROR
      (ID_LOTE, ID_ITEM, FEC_REG,USU_REG, FEC_MOD, USU_MOD,NRO_GUIA_REM, NRO_MATERIAL, NRO_SERIE,FEC_CONTABILIZACION, FEC_DOCUMENTO, CABECERA_DOCUMENTO, CANT_NECESARIA, CENTRO, ALMACEN, LOTE, CLASE_VAL, NRO_RESERVA, NRO_POS_RESERVA, ELEMENTO_PEP, FLG_CORRECCION,ESTADO, COD_RPTA, MSG_RPTA)
      SELECT ID_LOTE, ID_ITEM, SYSDATE, USER, SYSDATE, USER,NRO_GUIA_REM, NRO_MATERIAL, NRO_SERIE, FEC_CONTABILIZACION, FEC_DOCUMENTO, CABECERA_DOCUMENTO,  CANT_NECESARIA, CENTRO, ALMACEN, LOTE, CLASE_VAL, NRO_RESERVA, NRO_POS_RESERVA, ELEMENTO_PEP, 0,ESTADO, 7, 'Superó el número máximo de reintentos'
        FROM OPERACION.PIVOT_SOT_DESPACHO
       WHERE NRO_REINTENTOS >= n_reintentos;

    DELETE FROM OPERACION.PIVOT_SOT_DESPACHO
    WHERE NRO_REINTENTOS >= n_reintentos;

  COMMIT;

  EXCEPTION
    WHEN OTHERS THEN
      v_error:='Despacho-SAP:-'||sqlerrm;
      operacion.pq_sinergia.p_reg_log('Despacho-SAP',sqlcode,v_error,null,null,null,null,null);

end;

PROCEDURE p_genera_rep_des_error (k_fecha in date, po_cursor OUT SYS_REFCURSOR) IS

    /*
    ****************************************************************
    * Nombre SP         : p_genera_reporte_descarga
    * Propósito         : Consulta para obtener reporte de errores en la descarga automática
    * Input             : k_fecha - Fecha del reporte
    * Output            : po_cursor - Cursor con los registros obtenidos de la tabla pivot
    * Creado por        : Freddy Gonzales
    * Fec Creación      : 26/01/2017
    * Fec Actualización : N/A
    ****************************************************************
    */

  v_error varchar2(32767);

  begin

  open po_cursor for
   select max(to_char(h.fec_reg,'dd/mm/yyyy')) Fecha_Reporte,
           max(h.cod_rpta) Cod_Error,
           max(h.msg_rpta) Descripcion_Error,
           count(1) Numero_ReIntentos,
           substr(h.nro_guia_rem,1,8) Numero_Sot,
           h.nro_serie Serie,
           h.nro_material Material,
           max(h.almacen) Almacen,
           max(h.centro) Centro,
           max(h.lote) Lote,
           max(h.elemento_pep) PEP
    from  operacion.pivot_sot_despacho_hist_error h  inner join
          operacion.pivot_sot_despacho_hist_error hs on h.id_lote=hs.id_lote and h.id_item = hs.id_item
          where to_date(h.fec_reg) = K_FECHA
          and h.flg_correccion = 0
    group by  substr(h.nro_guia_rem,1,8), h.nro_serie, h.nro_material;

     EXCEPTION
    WHEN OTHERS THEN
      v_error:='Reporte despacho:-'||sqlerrm;
      operacion.pq_sinergia.p_reg_log('Presupuesto_',sqlcode,v_error,null,null,null,null,null);

END;
-- Fin 14.0

-- INI 16.0
PROCEDURE sgass_generar_nvl4(K_CODUBI    operacion.ubi_tecnica.ubitv_ubigeo%TYPE,
                             K_FLAG      operacion.ubi_tecnica.ubitv_flag_nvl4%TYPE,
                             K_NIVEL4    VARCHAR2,
                             K_IDUBITEC  OUT operacion.ubi_tecnica.abrev%TYPE,
                             K_RESULTADO OUT NUMBER,
                             K_MENSAJE   OUT VARCHAR2) IS

  v_ubitec_nvl3 operacion.ubi_tecnica.abrev%TYPE;
  v_ubitec_nvl4 operacion.ubi_tecnica.abrev%TYPE;
  v_secuencial  VARCHAR(5);
  v_coddst      marketing.vtatabdst.coddst%TYPE;
  v_codpvc      marketing.vtatabdst.codpvc%TYPE;
  v_codest      marketing.vtatabdst.codest%TYPE;
  v_existe_nvl4 NUMBER;
  v_count       number;
BEGIN
  K_RESULTADO := 0;
  K_MENSAJE   := 'OK';
  SELECT substr((SELECT abrev FROM vtatabpai WHERE codpai = a.codpai) || '-' ||
                TRIM(a.region_sap) || '-' || TRIM(a.nivel3),
                1,
                7),
         TRIM(a.coddst),
         TRIM(a.codpvc),
         TRIM(a.codest)
    INTO v_ubitec_nvl3, v_coddst, v_codpvc, v_codest
    FROM vtatabdst a
   WHERE a.ubigeo = K_CODUBI;

  IF K_FLAG = 1 THEN
    SELECT nvl(lpad(MAX(to_number(substr(abrev, 9, 3))) + 1, 3, '0'), '001')
      INTO v_secuencial
      FROM operacion.ubi_tecnica
     WHERE substr(abrev, 1, 7) = v_ubitec_nvl3
       AND LENGTH(TRIM(TRANSLATE(substr(abrev, 9, 3), ' +-.0123456789', ' '))) IS NULL;

  ELSIF K_FLAG = 2 THEN
    --Validar si Nivel 4 es existente
    v_ubitec_nvl4 := v_ubitec_nvl3 || '-' || K_NIVEL4;
    --v_existe_nvl4 := operacion.pq_sinergia.sgafun_ubitec(v_ubitec_nvl4);

    SELECT COUNT(1)
      INTO v_existe_nvl4
      FROM operacion.ubi_tecnica
     WHERE abrev LIKE v_ubitec_nvl4 || '%';

    IF v_existe_nvl4 = 0 THEN
      K_MENSAJE   := $$PLSQL_UNIT ||
                     'sgass_generar_nvl4; Error: El codigo de Ubicacion Tecnica: ' ||
                     v_ubitec_nvl4 || ' no existe. ' || SQLERRM;
      K_RESULTADO := -1;
      RETURN;
    ELSE
      v_secuencial := K_NIVEL4;
    END IF;
  END IF;

  K_IDUBITEC := v_ubitec_nvl3 || '-' || v_secuencial;

END sgass_generar_nvl4;

PROCEDURE sgasi_crea_idsitio_mov(an_id_ubitecnica operacion.ubi_tecnica.id_ubitecnica%TYPE,
                                 av_manfacture    operacion.id_sitio.manfacture%TYPE,
                                 av_manparno      operacion.id_sitio.manparno%TYPE,
                                 av_descript      operacion.id_sitio.descript%TYPE,
                                 av_clasproy      operacion.id_sitio.objecttype%TYPE,
                                 an_id_sitio      OUT operacion.id_sitio.id_sitio%TYPE,
                                 an_error         OUT NUMBER,
                                 av_error         OUT VARCHAR2
                                 )
IS
  n_id_sitio        number;
  err               EXCEPTION;
  n_sitio_id        number;
  v_manparno        operacion.id_sitio.manparno%type;
  v_descript        operacion.id_sitio.descript%type;
  n_tipo_sga        number;
  n_cont_manparno   number;
  v_numero          varchar2(100);
  v_comp_code       operacion.id_sitio.comp_code%TYPE;

  CURSOR c_ubitec is
    SELECT a.id_hub_sap,
           a.idplano,
           a.numslc,
           a.codsolot,
          -- a.claseproy,
           DECODE(a.claseproy, 'H', 'NODO', 'OTRO') FABRICANTE,
           IDHUB,
           tipo_sga,
           cid
      FROM operacion.ubi_tecnica a
     WHERE a.id_ubitecnica = an_id_ubitecnica;

BEGIN
  v_comp_code := 'PE02';
  BEGIN
    FOR r_ubitec IN c_ubitec LOOP
      n_tipo_sga := nvl(r_ubitec.tipo_sga,0);

      IF av_descript is null THEN
        av_error := 'El nombre de equipo no puede ser nulo.';
        RAISE err;
      END IF;

      BEGIN --Validacion de que se genere el id sitio sin repetir
        SELECT COUNT(1)
          INTO n_sitio_id
          FROM operacion.id_sitio
         WHERE descript = av_descript
           AND id_ubitecnica = an_id_ubitecnica;

        v_numero := substr(av_descript,1,100);
      EXCEPTION WHEN OTHERS THEN
        n_sitio_id := 0;
      END;

      IF n_sitio_id = 0 THEN
         v_manparno := av_manparno;

        SELECT COUNT(1)
          INTO n_cont_manparno
          FROM operacion.id_sitio
         WHERE manparno = v_manparno
           AND procesado = 'S';

        IF n_cont_manparno > 0 THEN
          an_error := -1;
          av_error := 'El nro de pieza de fabricante ya existe como ID_SITIO.';
          p_reg_log('Crear ID SITIO.',an_error,av_error,r_ubitec.numslc,r_ubitec.codsolot,an_id_ubitecnica,null,null);
          RAISE err;
        END IF;

        IF v_manparno IS NOT NULL AND n_cont_manparno=0 THEN
          SELECT operacion.sq_id_sitio.nextval
            INTO n_id_sitio
            FROM dummy_ope;

          an_id_sitio := n_id_sitio;

          INSERT INTO operacion.id_sitio
            (id_sitio,
             id_ubitecnica,
             descript,
             manfacture,
             manparno,
             valid_date,
             comp_code,
             objecttype)
          VALUES
            (n_id_sitio,
             an_id_ubitecnica,
             av_descript,
             av_manfacture, --r_ubitec.fabricante,
             av_manparno,
             SYSDATE,
             v_comp_code, --'PE02',
             av_clasproy);
             --r_ubitec.claseproy);

          COMMIT;

          webservice.pq_ws_sinergia.p_crea_id_sitio(n_id_sitio,an_error,av_error);

          IF an_error < 0 THEN
            an_error := -1;
            av_error := 'Crear ID_SITIO WS: ' || av_error;
            RAISE err;
          ELSE
            p_reg_log('Crear ID SITIO:',0,'Se generó ID_SITIO: ' || v_manparno,r_ubitec.numslc,r_ubitec.codsolot,an_id_ubitecnica,null,null);
          END IF;

          UPDATE operacion.Id_Sitio
             SET procesado = 'S'
           WHERE id_sitio = n_id_sitio;

          --La Ubicacion Tecnica cambia de estado a Creado
          UPDATE operacion.ubi_tecnica
             SET ubitv_estado = '4'
           WHERE id_ubitecnica = an_id_ubitecnica;
        ELSE
          IF av_manparno is null THEN
            av_error := 'El nro de pieza de fabricante no puede ser nulo.';
            RAISE err;
          END IF;
          IF n_cont_manparno=1 THEN
            av_error := 'El nro de pieza de fabricante ya existe.';
            RAISE err;
          END IF;
        END IF;
      ELSE
        av_error := 'El ID Sitio ya Existe : ' || v_numero;
        RAISE err;
      END IF;
  END LOOP;
  EXCEPTION
    WHEN err THEN
      an_error := -1;
      p_reg_log('Crear ID SITIO.',an_error,av_error,null,0,an_id_ubitecnica,null,null);

    WHEN OTHERS THEN
      an_error := -1;
      av_error:='ID SITIO :'|| to_char(n_id_sitio) ||'-'||sqlerrm;
      p_reg_log('Crear ID SITIO.',sqlcode,av_error,null,0,an_id_ubitecnica,null,null);
  END;
END sgasi_crea_idsitio_mov;
--FIN 16.0

   /*
    ****************************************************************
    * Nombre SP         : p_sgasi_creaut
    * Propósito         : crea la ubicacion
    * Input             :
    * Output            : k_iderror                --> codigo de error
                          k_mensaje_error          --> mensaje de error
    * Creado por        : Luigi Sipion
    * Fec Creación      : 04/12/2017
    * Fec Actualización : N/A
    ****************************************************************
    */
  PROCEDURE sgasi_creaut (
                          k_id_ubitecnica           in operacion.ubi_tecnica.id_ubitecnica%type,
                          k_abrev                   in operacion.ubi_tecnica.abrev%type,
                          k_tipo_sga                in operacion.ubi_tecnica.tipo_sga%type,
                          k_grupoautorizaciones     in operacion.ubi_tecnica.grupoautorizaciones%type,
                          k_flagubicaciontecnica    in operacion.ubi_tecnica.flagubicaciontecnica%type,
                          k_montajeequipos          in operacion.ubi_tecnica.montajeequipos%type,
                          k_flag_instal_auto        in operacion.ubi_tecnica.flag_instal_auto%type,
                          k_ubitv_nombre            in operacion.ubi_tecnica.ubitv_nombre%type,
                          k_ubitv_direccion         in operacion.ubi_tecnica.ubitv_direccion%type,
                          k_ubitv_distrito          in operacion.ubi_tecnica.ubitv_distrito%type,
                          k_ubitv_estado            in operacion.ubi_tecnica.ubitv_estado%type,
                          k_ubitv_tipo_site         in operacion.ubi_tecnica.ubitv_tipo_site%type,
                          k_ubitv_codigo_site       in operacion.ubi_tecnica.ubitv_codigo_site%type,
                          k_ubitv_tipo_proyecto     in operacion.ubi_tecnica.ubitv_tipo_proyecto%type,
                          k_claseproy               in operacion.ubi_tecnica.claseproy%type,
                          k_ubitv_x                 in operacion.ubi_tecnica.ubitv_x%type,
                          k_ubitv_y                 in operacion.ubi_tecnica.ubitv_y%type,
                          k_tipo                    in operacion.ubi_tecnica.tipo%type,
                          k_descripcion             in operacion.ubi_tecnica.descripcion%type,
                          k_ubitv_observacion       in operacion.ubi_tecnica.ubitv_observacion%type,
                          k_ubitv_flag_nvl4         in operacion.ubi_tecnica.ubitv_flag_nvl4%type,
                          k_ubitv_ubigeo            in operacion.ubi_tecnica.ubitv_ubigeo%type,
                          k_ubitv_idreqcab          in operacion.ubi_tecnica.ubitv_idreqcab%type,
                          k_sociedad                in operacion.ubi_tecnica.sociedad%type,
                          k_ubitv_departamento      in operacion.ubi_tecnica.ubitv_departamento%type,
                          k_ubitv_provincia         in operacion.ubi_tecnica.ubitv_provincia%type,
                          k_ubitv_direccion_nro     in operacion.ubi_tecnica.ubitv_direccion_nro%type,
                          k_ubitv_nom_distrito      in operacion.ubi_tecnica.ubitv_nom_distrito%type,
                          k_ubitv_nom_departamento  in operacion.ubi_tecnica.ubitv_nom_departamento%type,
                          k_ubitv_nom_provincia     in operacion.ubi_tecnica.ubitv_nom_provincia%type,
                          k_ubitv_codigo_postal     in operacion.ubi_tecnica.ubitv_codigo_postal%type,
                          k_ubitv_poblacion         in operacion.ubi_tecnica.ubitv_poblacion%type,
                          k_area_empresa            in operacion.ubi_tecnica.area_empresa%type,
                          k_iderror                 out numeric,
                          k_mensaje_error           out varchar2
                          ) is
  begin

  k_iderror       :=0;
  k_mensaje_error :='';

    insert into operacion.ubi_tecnica
                 (id_ubitecnica           ,
                  abrev                    ,
                  tipo_sga                 ,
                  grupoautorizaciones     ,
                  flagubicaciontecnica    ,
                  montajeequipos           ,
                  flag_instal_auto         ,
                  ubitv_nombre             ,
                  ubitv_direccion          ,
                  ubitv_distrito           ,
                  ubitv_estado             ,
                  ubitv_tipo_site          ,
                  ubitv_codigo_site        ,
                  ubitv_tipo_proyecto     ,
                  claseproy                  ,
                  ubitv_x                  ,
                  ubitv_y                  ,
                  tipo                     ,
                  descripcion             ,
                  ubitv_observacion        ,
                  ubitv_flag_nvl4          ,
                  ubitv_ubigeo             ,
                  ubitv_idreqcab           ,
                  sociedad                ,
                  ubitv_departamento      ,
                  ubitv_provincia          ,
                  ubitv_direccion_nro      ,
                  ubitv_nom_distrito      ,
                  ubitv_nom_departamento  ,
                  ubitv_nom_provincia     ,
                  ubitv_codigo_postal      ,
                  ubitv_poblacion         ,
                  area_empresa            )
    values(                 k_id_ubitecnica           ,
                  k_abrev           ,
                  k_tipo_sga          ,
                  k_grupoautorizaciones     ,
                  k_flagubicaciontecnica    ,
                  k_montajeequipos           ,
                  'X',--k_flag_instal_auto         ,
                  k_ubitv_nombre             ,
                  k_ubitv_direccion          ,
                  k_ubitv_distrito           ,
                  k_ubitv_estado             ,
                  k_ubitv_tipo_site          ,
                  k_ubitv_codigo_site        ,
                  k_ubitv_tipo_proyecto     ,
                  k_claseproy                  ,
                  k_ubitv_x                  ,
                  k_ubitv_y                  ,
                  k_tipo                     ,
                  k_ubitv_nombre            ,
                  k_ubitv_observacion        ,
                  k_ubitv_flag_nvl4          ,
                  k_ubitv_ubigeo             ,
                  k_ubitv_idreqcab           ,
                  k_sociedad                ,
                  k_ubitv_departamento      ,
                  k_ubitv_provincia          ,
                  k_ubitv_direccion_nro      ,
                  k_ubitv_nom_distrito      ,
                  k_ubitv_nom_departamento  ,
                  k_ubitv_nom_provincia     ,
                  k_ubitv_codigo_postal      ,
                  k_ubitv_poblacion         ,
                  k_area_empresa            );
                  commit;
    EXCEPTION
    WHEN OTHERS THEN
      k_iderror        := -1;
      k_mensaje_error   :='[operacion.pq_sinergia.p_sgasi_creaut], Error en registrar';

END;
--29.0
PROCEDURE p_ejecuta_sql(a_idwf IN NUMBER,a_tarea IN NUMBER, a_idtareawf IN NUMBER) IS
  t_tareawfdef tareawfdef%ROWTYPE;
  v_error      VARCHAR2(2500);
  n_idlog      NUMBER;
  V_SQL_CLOB clob;
  v_sql varchar2(32767);
  v_sql_1 varchar2(4000);
  v_sql_2 varchar2(4000);
  v_sql_3 varchar2(4000);
  v_sql_4 varchar2(4000);
  v_sql_5 varchar2(4000);
  v_sql_6 varchar2(4000);
  v_sql_7 varchar2(4000);
  v_sql_8 varchar2(4000);
BEGIN
  select * into t_tareawfdef from tareawfdef where tarea=a_tarea;
  IF t_tareawfdef.Flg_Opc = 1 AND t_tareawfdef.Sql_Condicion_Tarea IS NOT NULL THEN
    BEGIN
      begin
        select RTRIM(sql_condicion_tarea)into V_SQL_CLOB from tareawfdef
        where tarea = a_tarea;
      exception
        when no_data_found then
          V_SQL_CLOB := '';
      end;
      v_sql_1:=substr(V_SQL_CLOB,1,4000);
      v_sql_2:=substr(V_SQL_CLOB,4001,4000);
      v_sql_3:=substr(V_SQL_CLOB,8001,4000);
      v_sql_4:=substr(V_SQL_CLOB,12001,4000);
      v_sql_5:=substr(V_SQL_CLOB,16001,4000);
      v_sql_6:=substr(V_SQL_CLOB,20001,4000);
      v_sql_7:=substr(V_SQL_CLOB,24001,4000);
      v_sql_8:=substr(V_SQL_CLOB,28001,4000);
      v_sql := v_sql_1 || v_sql_2||v_sql_3 || v_sql_4||v_sql_5 || v_sql_6||v_sql_7 || v_sql_8;
      v_sql := replace(replace(v_sql, CHR(10), ' '), CHR(13), ' ');
      EXECUTE IMMEDIATE v_sql
      USING a_idwf,a_idtareawf;
    EXCEPTION
      WHEN OTHERS THEN
        v_error := SQLERRM;
        SELECT opewf.sq_log_ejecuta_proc_wf.nextval into n_idlog FROM dual;
        insert into opewf.log_ejecuta_proc_wf(idlog, nomproc, idtareawf, idwf, tarea, tareadef,query_string)
        values(n_idlog, 'pq_sinergia.p_ejecuta_sql', a_idtareawf, a_idwf,a_tarea, null, v_error);
    END;
 END IF;
END;

procedure p_descarga_equipo_sap(a_idwf IN NUMBER,a_tarea IN NUMBER, a_idtareawf IN NUMBER) is--33.0
n_codsolot number;
v_error VARCHAR2(2000);
v_numeroDocumentoMaterial VARCHAR2(1000);
v_mensajeRespuesta VARCHAR2(400);
v_MENSAJE VARCHAR2(200);
v_xml_ori VARCHAR2(4000);
v_xml  varchar2(4000);
v_target_url operacion.OPE_CAB_XML.target_url%type;
lc_RESPUESTAXML varchar2(32767);
n_codigoRespuesta number;
n_idtrs number;
n_equ_serie_ok number;
n_equ_serie number;
n_tipesttar number;
n_equ_total number;
n_error number;
cursor c_equ is
select a.codsolot, a.numserie,c.cod_sap,trim(to_char(a.cantidad,'9990.00')) cantidad,d.pep,d.idppto,a.centrosap,a.almacensap,a.clase_val,a.punto,a.orden
from solotptoequ a,tipequ b, almtabmat c,operacion.trs_ppto d
where a.codsolot=n_codsolot and a.codsolot=d.codsolot and d.respuesta_sap='S' and d.tipo=2
and a.tipequ=b.tipequ and b.codtipequ=c.codmat and a.Fec_Val_Desp is null;
begin
  select codsolot into n_codsolot from wf where idwf=a_idwf;
  SELECT target_url,xml into v_target_url,v_xml_ori from OPERACION.OPE_CAB_XML where TITULO= 'DESPACHO';
  for c in c_equ loop
    SELECT OPERACION.SQ_OPE_WS_SGASAP.NEXTVAL INTO n_idtrs FROM dual;
    v_xml:=v_xml_ori;
    select replace(v_xml, '@f_idTransaccion', to_char(n_idtrs)) into v_xml from dual;
    select replace(v_xml, '@f_usuarioAplicacion', user) into v_xml from dual;
    select replace(v_xml, '@f_ipApplicacion', sys_context('USERENV', 'IP_ADDRESS')) into v_xml from dual;
    select replace(v_xml, '@f_nombreAplicacion', 'SGA') into v_xml from dual;
    select replace(v_xml, '@f_sot', to_char(n_codsolot)) into v_xml from dual;
    select replace(v_xml, '@f_nroMaterial', c.cod_sap) into v_xml from dual;
    select replace(v_xml, '@f_fechaContabilizacionDocumento', to_char(sysdate,'yyyymmdd')) into v_xml from dual;
    select replace(v_xml, '@f_fechaDocumento', to_char(sysdate,'yyyymmdd')) into v_xml from dual;
    select replace(v_xml, '@f_textoCabeceraDocumento', 'LIQ_HFC '|| to_char(sysdate,'MON yyyy')) into v_xml from dual;
    select replace(v_xml, '@f_cantidadNecesaria', c.cantidad) into v_xml from dual;
    select replace(v_xml, '@f_claseMovimiento', '221') into v_xml from dual;
    select replace(v_xml, '@f_centro', c.centrosap ) into v_xml from dual;
    select replace(v_xml, '@f_almacen', c.almacensap) into v_xml from dual;
    select replace(v_xml, '@f_numeroLote', c.clase_val) into v_xml from dual;
    select replace(v_xml, '@f_nroReserva', '') into v_xml from dual;
    select replace(v_xml, '@f_numeroPosicionReservas', '') into v_xml from dual;
    select replace(v_xml, '@f_elementoPEP', c.pep) into v_xml from dual;
    select replace(v_xml, '@f_numeroSerie', c.numserie) into v_xml from dual;
    insert into OPERACION.OPE_WS_SGASAP(IDTRS,ESQUEMAXML,TIPO,CODSOLOT)
    values(n_idtrs,v_xml,'DESPACHO',n_codsolot);
    commit;
    lc_RESPUESTAXML:=WEBSERVICE.PQ_WS_SINERGIA.F_CALL_WEBSERVICE(v_xml,v_target_url);
    update operacion.OPE_WS_SGASAP set respuestaxml =lc_RESPUESTAXML where idtrs=n_idtrs;
    commit;
    n_codigoRespuesta:=WEBSERVICE.PQ_WS_SINERGIA.f_get_atributo(lc_RESPUESTAXML, 'codigoRespuesta');
    v_mensajeRespuesta:=WEBSERVICE.PQ_WS_SINERGIA.f_get_atributo(lc_RESPUESTAXML, 'mensajeRespuesta');
    v_numeroDocumentoMaterial:=WEBSERVICE.PQ_WS_SINERGIA.f_get_atributo(lc_RESPUESTAXML, 'numeroDocumentoMaterial');
    v_MENSAJE:=WEBSERVICE.PQ_WS_SINERGIA.f_get_atributo(lc_RESPUESTAXML, 'MENSAJE');
    update operacion.OPE_WS_SGASAP set respuestaxml = lc_RESPUESTAXML,error=v_mensajeRespuesta,resultado=n_codigoRespuesta
    where idtrs=n_idtrs;
    if n_codigoRespuesta=0 then
      if v_numeroDocumentoMaterial='-1' then
        update solotptoequ set MSG_RPTA_VAL_DESP=v_MENSAJE
        where codsolot= n_codsolot and punto=c.punto and orden=c.orden;
        update operacion.OPE_WS_SGASAP set error=error||v_MENSAJE
        where idtrs=n_idtrs;
      else
        update solotptoequ set IDPPTO=c.idppto, MSG_RPTA_VAL_DESP=v_MENSAJE,pep=c.pep, fec_val_desp=sysdate,pep_pe05=v_numeroDocumentoMaterial
        where codsolot= n_codsolot and punto=c.punto and orden=c.orden;
      end if;
    end if;
    if n_codigoRespuesta=-2 then
      update solotptoequ set MSG_RPTA_VAL_DESP=v_mensajeRespuesta
      where codsolot= n_codsolot and punto=c.punto and orden=c.orden;
    end if; 
    commit;   
  end loop;
  select count(1) into n_equ_total from solotptoequ where codsolot=n_codsolot;
  select count(1) into n_equ_serie from solotptoequ where codsolot=n_codsolot and numserie is not null;
  select count(1) into n_equ_serie_ok from solotptoequ where codsolot=n_codsolot and numserie is not null and msg_rpta_val_desp='OK';
  if n_equ_total=0 then
    select tipesttar into n_tipesttar from tareawf where idtareawf=a_idtareawf;
    if not n_tipesttar=4 then
      pq_wf.P_CHG_STATUS_TAREAWF(a_idtareawf,4,8,null,sysdate,sysdate);
    end if;
  else
    if n_equ_serie_ok=n_equ_serie then
      select tipesttar into n_tipesttar from tareawf where idtareawf=a_idtareawf;
      if not n_tipesttar=4 then
        pq_wf.P_CHG_STATUS_TAREAWF(a_idtareawf,4,4,null,sysdate,sysdate);
      end if;
    end if;
  end if;
  exception
    when others then
      v_error:= 'DESCARGA: ' || SQLERRM   || ' - ' || v_mensaje;
      n_error:=sqlcode;
      OPERACION.PQ_SINERGIA.p_reg_log('DESCARGA_MAT',n_error,v_error,null,n_codsolot,null,null,null);
      raise_application_error(-20001, v_error);
end;

--INI 34.0
PROCEDURE p_descarga_material(a_idwf IN NUMBER, a_idtareawf IN NUMBER) is

  n_codsolot                number;
  an_error                  NUMBER;
  v_error                   VARCHAR2(2000);
  v_numeroDocumentoMaterial VARCHAR2(1000);
  v_mensajeRespuesta        VARCHAR2(400);
  v_MENSAJE                 VARCHAR2(200);
  v_xml_ori                 VARCHAR2(4000);
  v_xml                     varchar2(4000);
  v_target_url              operacion.OPE_CAB_XML.target_url%type;
  lc_RESPUESTAXML           varchar2(32767);
  n_codigoRespuesta         number;
  n_idtrs                   number;
  n_equ_serie_ok            number;
  n_equ_serie               number;
  n_tipesttar               number;
  n_equ_total               number;
  n_error                   number;
  v_msg_rpta                varchar2(1000);
  v_doc_sap_despacho        varchar2(100);
  cursor c_equ is
    select a.codsolot,
           a.numserie,
           c.cod_sap,
           trim(to_char(a.cantidad, '9990.00')) cantidad,
           d.pep,
           d.idppto,
           a.centrosap,
           a.almacensap,
           a.clase_val,
           a.punto,
           a.orden
      from solotptoequ a, tipequ b, almtabmat c, operacion.trs_ppto d
     where a.codsolot = n_codsolot
       and a.codsolot = d.codsolot
       and d.respuesta_sap = 'S'
       and d.tipo = 2
       and a.tipequ = b.tipequ
       and b.codtipequ = c.codmat
       and a.Fec_Val_Desp is null;

begin
  select codsolot into n_codsolot from wf where idwf = a_idwf;
  SELECT target_url, xml
    into v_target_url, v_xml_ori
    from OPERACION.OPE_CAB_XML
   where TITULO = 'DESPACHO';
  for c in c_equ loop
    SELECT OPERACION.SQ_OPE_WS_SGASAP.NEXTVAL INTO n_idtrs FROM dual;
    v_xml := v_xml_ori;
    select replace(v_xml, '@f_idTransaccion', to_char(n_idtrs))
      into v_xml
      from dual;
    select replace(v_xml, '@f_usuarioAplicacion', user)
      into v_xml
      from dual;
    select replace(v_xml,
                   '@f_ipApplicacion',
                   sys_context('USERENV', 'IP_ADDRESS'))
      into v_xml
      from dual;
    select replace(v_xml, '@f_nombreAplicacion', 'SGA')
      into v_xml
      from dual;
    select replace(v_xml, '@f_sot', to_char(n_codsolot))
      into v_xml
      from dual;
    select replace(v_xml, '@f_nroMaterial', c.cod_sap)
      into v_xml
      from dual;
    select replace(v_xml,
                   '@f_fechaContabilizacionDocumento',
                   to_char(sysdate, 'yyyymmdd'))
      into v_xml
      from dual;
    select replace(v_xml, '@f_fechaDocumento', to_char(sysdate, 'yyyymmdd'))
      into v_xml
      from dual;
    select replace(v_xml,
                   '@f_textoCabeceraDocumento',
                   'LIQ_HFC ' || to_char(sysdate, 'MON yyyy'))
      into v_xml
      from dual;
    select replace(v_xml, '@f_cantidadNecesaria', c.cantidad)
      into v_xml
      from dual;
    select replace(v_xml, '@f_claseMovimiento', '221')
      into v_xml
      from dual;
    select replace(v_xml, '@f_centro', c.centrosap) into v_xml from dual;
    select replace(v_xml, '@f_almacen', c.almacensap) into v_xml from dual;
    select replace(v_xml, '@f_numeroLote', c.clase_val)
      into v_xml
      from dual;
    select replace(v_xml, '@f_nroReserva', '') into v_xml from dual;
    select replace(v_xml, '@f_numeroPosicionReservas', '')
      into v_xml
      from dual;
    select replace(v_xml, '@f_elementoPEP', c.pep) into v_xml from dual;
    select replace(v_xml, '@f_numeroSerie', c.numserie)
      into v_xml
      from dual;
    insert into OPERACION.OPE_WS_SGASAP
      (IDTRS, ESQUEMAXML, TIPO, CODSOLOT)
    values
      (n_idtrs, v_xml, 'DESPACHO', n_codsolot);
    commit;
    lc_RESPUESTAXML := WEBSERVICE.PQ_WS_SINERGIA.F_CALL_WEBSERVICE(v_xml,
                                                                   v_target_url);
    update operacion.OPE_WS_SGASAP
       set respuestaxml = lc_RESPUESTAXML
     where idtrs = n_idtrs;
    commit;
    n_codigoRespuesta         := WEBSERVICE.PQ_WS_SINERGIA.f_get_atributo(lc_RESPUESTAXML,
                                                                          'codigoRespuesta');
    v_mensajeRespuesta        := WEBSERVICE.PQ_WS_SINERGIA.f_get_atributo(lc_RESPUESTAXML,
                                                                          'mensajeRespuesta');
    v_numeroDocumentoMaterial := WEBSERVICE.PQ_WS_SINERGIA.f_get_atributo(lc_RESPUESTAXML,
                                                                          'numeroDocumentoMaterial');
    v_MENSAJE                 := WEBSERVICE.PQ_WS_SINERGIA.f_get_atributo(lc_RESPUESTAXML,
                                                                          'MENSAJE');
    update operacion.OPE_WS_SGASAP
       set respuestaxml = lc_RESPUESTAXML,
           error        = v_mensajeRespuesta,
           resultado    = n_codigoRespuesta
     where idtrs = n_idtrs;
    if n_codigoRespuesta = 0 then
      if v_numeroDocumentoMaterial = '-1' then
        update solotptoequ
           set MSG_RPTA_VAL_DESP = v_MENSAJE
         where codsolot = n_codsolot
           and punto = c.punto
           and orden = c.orden;
        update operacion.OPE_WS_SGASAP
           set error = error || v_MENSAJE
         where idtrs = n_idtrs;
      else
        update solotptoequ
           set IDPPTO            = c.idppto,
               MSG_RPTA_VAL_DESP = v_MENSAJE,
               pep               = c.pep,
               fec_val_desp      = sysdate,
               pep_pe05          = v_numeroDocumentoMaterial
         where codsolot = n_codsolot
           and punto = c.punto
           and orden = c.orden;
      end if;
    end if;
    if n_codigoRespuesta = -2 then
      update solotptoequ
         set MSG_RPTA_VAL_DESP = v_mensajeRespuesta
       where codsolot = n_codsolot
         and punto = c.punto
         and orden = c.orden;
    end if;
    commit;
  end loop;
  select count(1)
    into n_equ_total
    from solotptoequ
   where codsolot = n_codsolot;
  select count(1)
    into n_equ_serie
    from solotptoequ
   where codsolot = n_codsolot
     and numserie is not null;
  select count(1)
    into n_equ_serie_ok
    from solotptoequ
   where codsolot = n_codsolot
     and numserie is not null
     and msg_rpta_val_desp = 'OK';
  if n_equ_total = 0 then
    select tipesttar
      into n_tipesttar
      from tareawf
     where idtareawf = a_idtareawf;
    if not n_tipesttar = 4 then
      pq_wf.P_CHG_STATUS_TAREAWF(a_idtareawf, 4, 8, null, sysdate, sysdate);
    end if;
  else
    if n_equ_serie_ok = n_equ_serie then
      select tipesttar
        into n_tipesttar
        from tareawf
       where idtareawf = a_idtareawf;
      if not n_tipesttar = 4 then
        pq_wf.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                   4,
                                   4,
                                   null,
                                   sysdate,
                                   sysdate);
      end if;
    end if;
  end if;
exception
  when others then
    v_error := 'DESCARGA: ' || SQLERRM || ' - ' || v_mensaje;
    n_error := sqlcode;
    OPERACION.PQ_SINERGIA.p_reg_log('DESCARGA_MAT',
                                    n_error,
                                    v_error,
                                    null,
                                    n_codsolot,
                                    null,
                                    null,
                                    null);
    raise_application_error(-20001, v_error);
end;
--FIN 34.0

END PQ_SINERGIA;
/
