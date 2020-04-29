update opedd
set codigon = 693
where idopedd in (
   select idopedd from opedd where tipopedd in (
    select tipopedd from tipopedd  where upper(abrev) = upper('TIPO_TRANS_SIAC'))
    and codigon = 412);
commit;

update opedd
set codigon = 694
where idopedd in (
   select idopedd from opedd where tipopedd in (
    select tipopedd from tipopedd  where upper(abrev) = upper('TIPO_TRANS_SIAC'))
    and codigon = 418);
commit;
          
update opedd
set codigon = 695
where idopedd in (
   select idopedd from opedd where tipopedd in (
    select tipopedd from tipopedd  where upper(abrev) = upper('TIPO_TRANS_SIAC'))
    and codigon = 427);
commit;