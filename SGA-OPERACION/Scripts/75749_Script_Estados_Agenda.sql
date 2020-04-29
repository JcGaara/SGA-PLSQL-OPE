declare
cursor c_estageda is
select sea.estagendaini,
       sea.estagendafin,
       sea.aplica_contrata,
       sea.aplica_pext,
       sea.idseq,
       sea.estsol
  from operacion.secuencia_estados_agenda sea
 where sea.tiptra=485;
begin
  for c1 in c_estageda loop
    insert into operacion.secuencia_estados_agenda(estagendaini,estagendafin,aplica_contrata,aplica_pext,idseq,estsol,tiptra,usureg,fecreg,usumod,fecmod) values(c1.estagendaini,c1.estagendafin,c1.aplica_contrata,c1.aplica_pext,c1.idseq,c1.estsol,(select tiptra from operacion.tiptrabajo where descripcion='INSTALACION 3 PLAY INALAMBRICO'),user,sysdate,user,sysdate);
  end loop;
  commit;
end;
/