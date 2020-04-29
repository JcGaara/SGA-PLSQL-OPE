declare
 v_tiptra operacion.tiptrabajo.tiptra%TYPE;
begin

insert into operacion.tiptrabajo
    (tiptra,
     tiptrs,
     descripcion,
     flgcom,
     flgpryint,
     sotfacturable,
     agenda,
     corporativo,
     selpuntossot)
  values
    ((select max(tiptra) + 1 from tiptrabajo),
     1,
     'WLL/SIAC - CAMBIO DE EQUIPO',
     0,
     0,
     0,
     0,
     0,
     0)
	returning tiptra into v_tiptra; 
  
insert into operacion.opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (v_tiptra, 'WLL/SIAC - CAMBIO DE EQUIPO', 'WLL/SIAC - CAMBIO DE EQUIPO', (select tipopedd from operacion.tipopedd where abrev='TIPO_TRANS_SIAC_LTE'), 7);

insert into operacion.tiptrabajo (TIPTRA, TIPTRS, DESCRIPCION, FECUSU, CODUSU, CUENTA, CODDPT, FLGCOM, FLGPRYINT, CODMOTINSSRV, SOTFACTURABLE, BLOQUEO_DESBLOQUEO, HORAS, AGENDA, HORA_INI, HORA_FIN, AGENDABLE, NUM_REAGENDA, HORAS_ANTES, CORPORATIVO, SELPUNTOSSOT)
values ((select max(tiptra)+1 from operacion.tiptrabajo), 5, 'WLL/SIAC - DES. DECO ADICIONAL', sysdate, user, null, null, 0, 0, null, 0, null, null, null, null, null, 0, null, null, 0, 0);

insert into operacion.tiptrabajo (TIPTRA, TIPTRS, DESCRIPCION, FECUSU, CODUSU, CUENTA, CODDPT, FLGCOM, FLGPRYINT, CODMOTINSSRV, SOTFACTURABLE, BLOQUEO_DESBLOQUEO, HORAS, AGENDA, HORA_INI, HORA_FIN, AGENDABLE, NUM_REAGENDA, HORAS_ANTES, CORPORATIVO, SELPUNTOSSOT)
values ((select max(tiptra)+1 from operacion.tiptrabajo), 1, 'WLL/SIAC - ACT. DECO ADICIONAL', sysdate, user, null, null, 0, 0, null, 0, null, null, null, null, null, 0, null, null, 0, 0);

insert into operacion.opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select tiptra from operacion.tiptrabajo where descripcion='WLL/SIAC - DES. DECO ADICIONAL'), 'WLL/SIAC - DES. DECO ADICIONAL', 'WLL/SIAC - DES. DECO ADICIONAL', (select tipopedd from operacion.tipopedd where abrev='TIPO_TRANS_SIAC_LTE'), 8);

insert into operacion.opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select tiptra from operacion.tiptrabajo where descripcion='WLL/SIAC - ACT. DECO ADICIONAL'), 'WLL/SIAC - ACT. DECO ADICIONAL', 'WLL/SIAC - ACT. DECO ADICIONAL', (select tipopedd from operacion.tipopedd where abrev='TIPO_TRANS_SIAC_LTE'), 8);

insert into operacion.opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select tiptra from operacion.tiptrabajo where descripcion='WLL/SIAC - DECO ADICIONAL'), 'WLL/SIAC - DECO ADICIONAL', 'WLL/SIAC - DECO ADICIONAL', (select tipopedd from operacion.tipopedd where abrev='TIPO_TRANS_SIAC_LTE'), 8);
commit;

insert into operacion.motot
  (codmotot, descripcion, grupodesc, tipmotot)
values
  ((SELECT MAX(codmotot) + 1 from operacion.motot), 'EQUIPO AVERIADO', null, 3);
  
insert into operacion.motot
  (codmotot, descripcion, grupodesc, tipmotot)
values
  ((SELECT MAX(codmotot) + 1 from operacion.motot), 'REGULARIZACION', null, 3);
commit;
insert into operacion.mototxtiptra(tiptra,codmotot) values ((select tiptra from operacion.tiptrabajo where descripcion='WLL/SIAC - CAMBIO DE EQUIPO'),(select codmotot from operacion.motot where descripcion='EQUIPO AVERIADO'));
insert into operacion.mototxtiptra(tiptra,codmotot) values ((select tiptra from operacion.tiptrabajo where descripcion='WLL/SIAC - CAMBIO DE EQUIPO'),(select codmotot from operacion.motot where descripcion='REGULARIZACION'));
insert into operacion.tipopedd (DESCRIPCION, ABREV)
values ('WLL/SIAC DECO ADICIONAL', 'WLL_SIAC_DEC_ADICIONAL');

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('41.5254', null, 'MONTO OCC - WLL/SIAC DECO ADICIONAL', 'MONT_OCC_ALTA', (select tipopedd from operacion.tipopedd t where t.ABREV='WLL_SIAC_DEC_ADICIONAL'), null);
commit;
end;
/