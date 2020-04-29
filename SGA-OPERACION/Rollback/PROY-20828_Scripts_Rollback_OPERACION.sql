REVOKE SELECT, INSERT, UPDATE, DELETE ON operacion.shfct_det_tras_ext FROM r_prod;

DROP TABLE OPERACION.SHFCT_DET_TRAS_EXT;

update opedd
set codigon = 412
where idopedd in (
   select idopedd from opedd where tipopedd in (
    select tipopedd from tipopedd  where upper(abrev) = upper('TIPO_TRANS_SIAC'))
    and codigon = 693);
commit;

update opedd
set codigon = 418
where idopedd in (
   select idopedd from opedd where tipopedd in (
    select tipopedd from tipopedd  where upper(abrev) = upper('TIPO_TRANS_SIAC'))
    and codigon = 694);

commit;
          
update opedd
set codigon = 427
where idopedd in (
   select idopedd from opedd where tipopedd in (
    select tipopedd from tipopedd  where upper(abrev) = upper('TIPO_TRANS_SIAC'))
    and codigon = 695);
commit;