create or replace function operacion.F_GET_URL_TV(a_cid number)
/***********************************************************************************************
    PROPOSITO:  Validar funcionalidad para CID
    REVISIONES:
    Version      Fecha        Autor             Solicitado Por        Descripcion
    ---------  ----------  -----------------    --------------        ------------------------
    1.0        24/05/2015  Edilberto Astulle     SD-307352            Problema con el SGA    
  **********************************************************************************************/
return varchar is
n_cont number;--1.0
v_tipsrv varchar2(10);--1.0
ln_url varchar2(1000);
begin
select count(1) into n_cont
from
servxtrafixequipo se,
equipored er,
cidxide ci,
puertoxequipo pe,
(SELECT CODIGON,ABREVIACION FROM OPEDD WHERE TIPOPEDD = 179) V_SERVIDOR,
(SELECT CODIGON,ABREVIACION FROM OPEDD WHERE TIPOPEDD = 180) V_DIRECTORIO,
(SELECT CODIGON,ABREVIACION FROM OPEDD WHERE TIPOPEDD = 181) V_TIPEQU,
(SELECT CODIGON,DESCRIPCION FROM OPEDD WHERE TIPOPEDD = 182 AND CODIGON= 2) V_CADURL
where
ci.cid = a_cid and
ci.ide = pe.ide and
se.codequipo = pe.codequipo and
se.codequipo = er.codequipo and
se.tiporep = 1 and
se.servidor = V_SERVIDOR.CODIGON and
se.directorio = V_DIRECTORIO.CODIGON and
se.tipequrep = V_TIPEQU.CODIGON;
if n_cont=1 then
  select
  'http://'||V_SERVIDOR.ABREVIACION||'/'||V_CADURL.DESCRIPCION||V_DIRECTORIO.ABREVIACION||V_TIPEQU.ABREVIACION||'%2F'||lower(se.equipored)||'%2Fcid'||ci.cid||';view=TraficoTotal' url
  into ln_url
  from
  servxtrafixequipo se,
  equipored er,
  cidxide ci,
  puertoxequipo pe,
  (SELECT CODIGON,ABREVIACION FROM OPEDD WHERE TIPOPEDD = 179) V_SERVIDOR,
  (SELECT CODIGON,ABREVIACION FROM OPEDD WHERE TIPOPEDD = 180) V_DIRECTORIO,
  (SELECT CODIGON,ABREVIACION FROM OPEDD WHERE TIPOPEDD = 181) V_TIPEQU,
  (SELECT CODIGON,DESCRIPCION FROM OPEDD WHERE TIPOPEDD = 182 AND CODIGON= 2) V_CADURL
  where
  ci.cid = a_cid and
  ci.ide = pe.ide and
  se.codequipo = pe.codequipo and
  se.codequipo = er.codequipo and
  se.tiporep = 1 and
  se.servidor = V_SERVIDOR.CODIGON and
  se.directorio = V_DIRECTORIO.CODIGON and
  se.tipequrep = V_TIPEQU.CODIGON;
elsif n_cont>1 then
  select distinct b.tipsrv into v_tipsrv from acceso a, inssrv  b, tystipsrv c
  where a.cid=b.cid and b.tipsrv=c.tipsrv
  and a.cid =a_cid
  and b.tipsrv in ('0052','0006');
  if v_tipsrv='0052' then --RPV
    select
    'http://'||V_SERVIDOR.ABREVIACION||'/'||V_CADURL.DESCRIPCION||V_DIRECTORIO.ABREVIACION||V_TIPEQU.ABREVIACION||'%2F'||lower(se.equipored)||'%2Fcid'||ci.cid||';view=TraficoTotal' url
    into ln_url
    from
    servxtrafixequipo se,
    equipored er,tipequipored tr,
    cidxide ci,
    puertoxequipo pe,
    (SELECT CODIGON,ABREVIACION FROM OPEDD WHERE TIPOPEDD = 179) V_SERVIDOR,
    (SELECT CODIGON,ABREVIACION FROM OPEDD WHERE TIPOPEDD = 180) V_DIRECTORIO,
    (SELECT CODIGON,ABREVIACION FROM OPEDD WHERE TIPOPEDD = 181) V_TIPEQU,
    (SELECT CODIGON,DESCRIPCION FROM OPEDD WHERE TIPOPEDD = 182 AND CODIGON= 2) V_CADURL
    where
    ci.cid = a_cid and er.tipo=tr.codtipo and
    ci.ide = pe.ide and
    se.codequipo = pe.codequipo and
    se.codequipo = er.codequipo and
    se.tiporep = 1 and
    se.servidor = V_SERVIDOR.CODIGON and
    se.directorio = V_DIRECTORIO.CODIGON and
    se.tipequrep = V_TIPEQU.CODIGON
    and not tr.patron=10;
  elsif v_tipsrv='0006'  then --Internet
    select
    'http://'||V_SERVIDOR.ABREVIACION||'/'||V_CADURL.DESCRIPCION||V_DIRECTORIO.ABREVIACION||V_TIPEQU.ABREVIACION||'%2F'||lower(se.equipored)||'%2Fcid'||ci.cid||';view=TraficoTotal' url
    into ln_url
    from
    servxtrafixequipo se,
    equipored er,tipequipored tr,
    cidxide ci,
    puertoxequipo pe,
    (SELECT CODIGON,ABREVIACION FROM OPEDD WHERE TIPOPEDD = 179) V_SERVIDOR,
    (SELECT CODIGON,ABREVIACION FROM OPEDD WHERE TIPOPEDD = 180) V_DIRECTORIO,
    (SELECT CODIGON,ABREVIACION FROM OPEDD WHERE TIPOPEDD = 181) V_TIPEQU,
    (SELECT CODIGON,DESCRIPCION FROM OPEDD WHERE TIPOPEDD = 182 AND CODIGON= 2) V_CADURL
    where
    ci.cid = a_cid and er.tipo=tr.codtipo and
    ci.ide = pe.ide and
    se.codequipo = pe.codequipo and
    se.codequipo = er.codequipo and
    se.tiporep = 1 and
    se.servidor = V_SERVIDOR.CODIGON and
    se.directorio = V_DIRECTORIO.CODIGON and
    se.tipequrep = V_TIPEQU.CODIGON
    and tr.patron=10;
  end if;
end if;

return ln_url;
end ;
/


