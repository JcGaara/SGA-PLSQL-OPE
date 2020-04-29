CREATE OR REPLACE PROCEDURE OPERACION.P_CONSULTA_SOT_X_DNI (
a_tipo in char,
nro_dni in varchar2,--(15),
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


        ls_query := ' select DISTINCT cab.codsolot COD, es.DESCRIPCION estado  from ope_srv_recarga_cab cab
      join paquete_venta pv     on CAB.IDPAQ = PV.IDPAQ
      join solotptoequ s     on CAB.CODSOLOT = s.codsolot
      join inssrv i    on cab.NUMSLC = i.numslc
      join tystabsrv t    on i.CODSRV = t.codsrv
      JOIN VTATABCLI CL ON CAB.CODCLI = CL.CODCLI
      LEFT JOIN atccorp.atc_file_bouquet_dth_det DET    ON  s.NUMSERIE  = DET.COD_TARJETA
      LEFT JOIN ATCCORP.ATC_FILE_BOUQUET_DTH_CAB CB    ON CB.ID_FILE_BOUQUET_CAB = DET.ID_FILE_BOUQUET_CAB
      left join opedd es on es.CODIGON = CB.ESTADO_CAB  and es.TIPOPEDD in (SELECT tipopedd FROM tipopedd WHERE abrev = '||''''||'BOUQUET_DTH_ESTADO'||''''||')
      where S.NUMSERIE is not null and cab.estado <> '||''''|| '04'||'''' ;
         if nro_dni <> '' or nro_dni is not null then
            ls_query := ls_query || ' and  CL.NTDIDE =  ' || ''''||nro_dni||'''';
        end if;
else
          ls_query := ' select DISTINCT dp.msisdn COD,  es.DESCRIPCION estado from tim.pp_dth_prov@DBL_BSCS_BF dp
        join profile_service@DBL_BSCS_BF ps on dp.co_id = ps.co_id
        join tim.pp_gmd_buquet@DBL_BSCS_BF dt on ps.sncode = dt.sncode
        join tim.pp_dth_tarjeta@DBL_BSCS_BF tar on dp.id_tarjeta = tar.id_tarjeta
        join tim.pp_datos_contrato@DBL_BSCS_BF dc on dp.co_id = dc.co_id
        join customer_all@DBL_BSCS_BF cl on dc.customer_id = cl.customer_id
        LEFT JOIN atccorp.atc_file_bouquet_dth_det DET ON tar.nro_tarjeta = DET.COD_TARJETA
        LEFT JOIN ATCCORP.ATC_FILE_BOUQUET_DTH_CAB CAB ON CAB.ID_FILE_BOUQUET_CAB = DET.ID_FILE_BOUQUET_CAB
      left join opedd es on es.CODIGON = CAB.ESTADO_CAB  and es.TIPOPEDD in (SELECT tipopedd FROM tipopedd WHERE abrev = '||''''||'BOUQUET_DTH_ESTADO'||''''||')
        where tar.nro_tarjeta is not null and   nvl(tim.tfun015_estado_servicio@DBL_BSCS_BF(ps.co_id,ps.sncode),'||''''|| 'D'||''''|| ') = '||''''|| 'A'||'''' ;
         if nro_dni is not null then
            ls_query := ls_query || ' and  cl.cscompregno =  ' || ''''||nro_dni||'''';
        end if;
end if ;
  OPEN cursor_salida FOR ls_query ;
--

END;
/
