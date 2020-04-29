declare
l_tipopedd number;
l_idopedd    number;
begin
select tipopedd into l_tipopedd from tipopedd where abrev like 'PAR_PLATAF_JANUS';
select nvl(max(idopedd),0) +1 into l_idopedd from opedd;

insert into opedd(idopedd,codigoc,descripcion,abreviacion,tipopedd) values(l_idopedd,'P','Prefijo del COD_CUENTA','P_COD_CUENTA',l_tipopedd);

commit;
end;
/