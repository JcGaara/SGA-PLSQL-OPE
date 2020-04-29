CREATE OR REPLACE PROCEDURE OPERACION.P_CONSULTA_BOUQUET_DTH (
a_tipo in char,
codsolot in number,--(8),
codinsrv in number,--(10),
cod_clie in varchar2,--(8),
nro_dni in varchar2,--(15),
nro_tarjeta in varchar2,--(30),
cursor_salida out OPERACION.PQ_REVISION_BOUQUETS_DTH.CUR_SEC
) IS
 /***********************************************************************
  REVISIONES:
   Versión     Fecha         Autor              Solicitado por             Descripcion
  ---------  -----------   ----------------     -----------------    ----------------------------------
     1.0      01/09/2014   Emma Guzman A.     Susana Ramos          PROY-6124-IDEA-5627 - Revisión Bouquets DTH
     2.0      22/07/2015   Emma Guzman A.     Susana Ramos
  ************************************************************************/
ls_query varchar2(20000);
TYPE cur_typ IS REF CURSOR;
cursor_sga    CUR_TYP;

BEGIN

if a_tipo = '1' then
 --pv.DESC_OPERATIVA paquete,

        ls_query := ' select distinct S.NUMSERIE   tarjeta,  decode(acceso.descripcion,null,t.dscsrv,acceso.descripcion),
         replace (t.CODIGO_EXT, '||''''||','||''''||','||''''||', '||''''||' ) bouquet,  replace (DET.COD_BOUQUET, '||''''||','||''''||','||''''||', '||''''||' ) bouquet_conax, es.DESCRIPCION estado,  DET.fecreg   fecha_reg, DET.fecmod   gecha_mod,   '||''''||'1'||''''
     || '  from ope_srv_recarga_cab cab
      join paquete_venta pv     on CAB.IDPAQ = PV.IDPAQ
      join solotptoequ s     on CAB.CODSOLOT = s.codsolot
      join inssrv i    on cab.NUMSLC = i.numslc
      join tystabsrv t    on i.CODSRV = t.codsrv
      JOIN VTATABCLI CL ON CAB.CODCLI = CL.CODCLI
      LEFT JOIN atccorp.atc_file_bouquet_dth_det DET    ON  s.NUMSERIE  = DET.COD_TARJETA
      LEFT JOIN ATCCORP.ATC_FILE_BOUQUET_DTH_CAB CB    ON CB.ID_FILE_BOUQUET_CAB = DET.ID_FILE_BOUQUET_CAB
      left join opedd es on es.CODIGON = CB.ESTADO_CAB  and es.TIPOPEDD in (SELECT tipopedd FROM tipopedd WHERE abrev = '||''''||'BOUQUET_DTH_ESTADO'||''''||')
      left join (select cid,producto,productocorp.descripcion
   from acceso, productocorp
   where acceso.codprd = productocorp.codprd) acceso on  I.CID = acceso.cid
      where  s.tipequ in (select codigon from opedd where TIPOPEDD in (SELECT tipopedd FROM tipopedd WHERE abrev =  '||''''||'BOUQUET_TIPEQU'||''''||')) and S.NUMSERIE is not null and cab.estado <> '||''''|| '04'||'''' ;
        if  codsolot is not null then
            ls_query := ls_query || ' and cab.codsolot =  ' || codsolot;
        end if;
         if  codinsrv is not null then
            ls_query := ls_query || ' and I.CODINSSRV =  ' || codinsrv;
        end if;
         if cod_clie <> ''  or cod_clie is not null then
            ls_query := ls_query || ' and CAB.CODCLI =  ' || ''''||cod_clie||'''';
        end if;
         if nro_dni <> '' or nro_dni is not null then
            ls_query := ls_query || ' and  CL.NTDIDE =  ' || ''''||nro_dni||'''';
        end if;
        if nro_tarjeta <> ''  or  nro_tarjeta is not null then
            ls_query := ls_query || ' and S.NUMSERIE =  ' ||  ''''||nro_tarjeta||'''';
        end if;
--        EXECUTE IMMEDIATE ls_query;-- USING nombre, codigo;

     dbms_output.put_line (ls_query);
      --using clie,cod_clie, tarjeta, nro_tarjeta;
else
          ls_query := ' select distinct tar.nro_tarjeta tarjeta , dt.descripcion paquete, replace ( dt.cod_buquet , '||''''||','||''''||','||''''||', '||''''||' ) bouquet,
        replace (DET.COD_BOUQUET , '||''''||','||''''||','||''''||', '||''''||' )   bouquet_conax, es.DESCRIPCION estado, DET.fecreg fecha_reg, DET.fecmod gecha_mod,   '||''''||'1'||''''  || '
        from tim.pp_dth_prov@DBL_BSCS_BF dp
        join profile_service@DBL_BSCS_BF ps on dp.co_id = ps.co_id
        join tim.pp_gmd_buquet@DBL_BSCS_BF dt on ps.sncode = dt.sncode
        join tim.pp_dth_tarjeta@DBL_BSCS_BF tar on dp.id_tarjeta = tar.id_tarjeta
        join tim.pp_datos_contrato@DBL_BSCS_BF dc on dp.co_id = dc.co_id
        join customer_all@DBL_BSCS_BF cl on dc.customer_id = cl.customer_id
        LEFT JOIN atccorp.atc_file_bouquet_dth_det DET ON tar.nro_tarjeta = DET.COD_TARJETA
        LEFT JOIN ATCCORP.ATC_FILE_BOUQUET_DTH_CAB CAB ON CAB.ID_FILE_BOUQUET_CAB = DET.ID_FILE_BOUQUET_CAB
      left join opedd es on es.CODIGON = CAB.ESTADO_CAB  and es.TIPOPEDD in (SELECT tipopedd FROM tipopedd WHERE abrev = '||''''||'BOUQUET_DTH_ESTADO'||''''||')
        where tar.nro_tarjeta is not null and   nvl(tim.tfun015_estado_servicio@DBL_BSCS_BF(ps.co_id,ps.sncode),'||''''|| 'D'||''''|| ') = '||''''|| 'A'||'''' ;
            if codinsrv is not null then
            ls_query := ls_query || ' and dp.co_id in (select distinct co_id from  tim.pp_dth_prov@DBL_BSCS_BF where msisdn = ' || codinsrv || ' )';
        end if;
         if cod_clie is not null then
            ls_query := ls_query || ' and cl.customer_id =  ' || ''''||cod_clie||'''';
        end if;
         if nro_dni is not null then
            ls_query := ls_query || ' and  cl.cscompregno =  ' || ''''||nro_dni||'''';
        end if;
         if nro_tarjeta is not null then
            ls_query := ls_query || ' and tar.nro_tarjeta=  ' ||  ''''||nro_tarjeta||'''';
        end if;
--         dbms_output.put_line (ls_query);
--          OPEN cursor_salida FOR ls_query ;--using clie,cod_clie, tarjeta, nro_tarjeta;
end if ;
  OPEN cursor_salida FOR ls_query ;
--

END;
/
