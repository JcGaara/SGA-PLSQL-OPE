declare
  v_tiptra operacion.tiptrabajo.tiptra%TYPE;
  v_tiptra_2 operacion.tiptrabajo.tiptra%TYPE;
begin

---BAJA TOTAL DEL SERVICIO

select tiptra into v_tiptra from operacion.tiptrabajo where DESCRIPCION = 'FTTH/SIAC - BAJA TOTAL DEL SERVICIO';

--Para consultar TIPTRA, envia 11 desde SIACU
insert into OPERACION.OPEDD (CODIGON, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (v_tiptra,
         'FTTH/SIAC - BAJA TOTAL DEL SERVICIO',
         (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPO_TRANS_SIAC'),
         11);

insert into operacion.opedd
  (IDOPEDD,
   CODIGOC,
   CODIGON,
   DESCRIPCION,
   ABREVIACION,
   TIPOPEDD,
   CODIGON_AUX)
values
  ((select max(IDOPEDD) + 1 from operacion.opedd),
   '1',
   29,
   null,
   null,
   (select TIPOPEDD from operacion.TIPOPEDD where descripcion = 'SGAREASONTIPMOTOT'),
   v_tiptra);
	 
insert into operacion.motot(CODMOTOT, DESCRIPCION, FLGCOM, TIPMOTOT)
values ((select MAX(CODMOTOT)+1 from operacion.motot), 'FTTH/SIAC - A SOLICITUD DEL CLIENTE', 0, 1);

insert into operacion.motot(CODMOTOT, DESCRIPCION, FLGCOM, TIPMOTOT)
values ((select MAX(CODMOTOT)+1 from operacion.motot), 'FTTH/SIAC - MIGRACION A CLARO EMPRESA', 0, 1);

insert into operacion.motot(CODMOTOT, DESCRIPCION, FLGCOM, TIPMOTOT)
values ((select MAX(CODMOTOT)+1 from operacion.motot), 'FTTH/SIAC - UNIFICACIÓN DE SERVICIOS POR MIGRACIÓN', 0, 1);

insert into operacion.motot(CODMOTOT, DESCRIPCION, FLGCOM, TIPMOTOT)
values ((select MAX(CODMOTOT)+1 from operacion.motot), 'FTTH/SIAC - MIGRACION A CLARO INALAMBRICO (LTE)', 0, 1);

insert into operacion.mototxtiptra (IDMOTXTIP, TIPTRA, CODMOTOT)
values ((select MAX(IDMOTXTIP)+1 from operacion.mototxtiptra), 
        v_tiptra,
        (select CODMOTOT from operacion.motot where DESCRIPCION = 'FTTH/SIAC - A SOLICITUD DEL CLIENTE'));

insert into operacion.mototxtiptra (IDMOTXTIP, TIPTRA, CODMOTOT)
values ((select MAX(IDMOTXTIP)+1 from operacion.mototxtiptra), 
        v_tiptra,
        (select CODMOTOT from operacion.motot where DESCRIPCION = 'FTTH/SIAC - MIGRACION A CLARO EMPRESA'));

insert into operacion.mototxtiptra (IDMOTXTIP, TIPTRA, CODMOTOT)
values ((select MAX(IDMOTXTIP)+1 from operacion.mototxtiptra), 
        v_tiptra,
        (select CODMOTOT from operacion.motot where DESCRIPCION = 'FTTH/SIAC - UNIFICACIÓN DE SERVICIOS POR MIGRACIÓN'));
		 
insert into operacion.mototxtiptra (IDMOTXTIP, TIPTRA, CODMOTOT)
values ((select MAX(IDMOTXTIP)+1 from operacion.mototxtiptra), 
        v_tiptra,
        (select CODMOTOT from operacion.motot where DESCRIPCION = 'FTTH/SIAC - MIGRACION A CLARO INALAMBRICO (LTE)'));
		  	
--- BAJA ADMINISTRATIVA ---
---------------------------
  insert into operacion.tiptrabajo
    (TIPTRA,
     TIPTRS,
     DESCRIPCION,
     FLGCOM,
     FLGPRYINT,
     SOTFACTURABLE,
     AGENDABLE,
     CORPORATIVO,
     SELPUNTOSSOT)
  values
    ((select max(tiptra) + 1 from tiptrabajo),
     5,
     'FTTH/SIAC - BAJA ADMINISTRATIVA',
     0,
     0,
     0,
     0,
     0,
     0)
  returning tiptra
    into v_tiptra_2;

insert into OPERACION.OPEDD (CODIGON, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (v_tiptra_2,
         'FTTH/SIAC - BAJA ADMINISTRATIVA',
         (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPO_TRANS_SIAC'),
         11);

insert into OPERACION.OPEDD (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  ((select max(IDOPEDD) + 1 from OPERACION.opedd ),
   null,
   v_tiptra_2,
   'FTTH/SIAC - BAJA ADMINISTRATIVA',
   null,
   (select tipopedd from operacion.tipopedd t where t.abrev = 'ASIGNARWFBSCS'),
   1);
   
insert into operacion.opedd
  (IDOPEDD,
   CODIGOC,
   CODIGON,
   DESCRIPCION,
   ABREVIACION,
   TIPOPEDD,
   CODIGON_AUX)
values
  ((select max(IDOPEDD) + 1 from operacion.opedd),
   '1',
   29,
   null,
   null,
   (select TIPOPEDD from operacion.TIPOPEDD where descripcion = 'SGAREASONTIPMOTOT'),
   v_tiptra_2);

  ------------------------------------------------------------------------------------------
  -- Motivos por Tipo de Trabajo
  ------------------------------------------------------------------------------------------
	 
insert into operacion.motot(CODMOTOT, DESCRIPCION, FLGCOM, TIPMOTOT)
values ((select MAX(CODMOTOT)+1 from operacion.motot), 'FTTH/SIAC - PORT OUT', 0, 1);

insert into operacion.motot(CODMOTOT, DESCRIPCION, FLGCOM, TIPMOTOT)
values ((select MAX(CODMOTOT)+1 from operacion.motot), 'FTTH/SIAC - FRAUDE', 0, 1);

insert into operacion.motot(CODMOTOT, DESCRIPCION, FLGCOM, TIPMOTOT)
values ((select MAX(CODMOTOT)+1 from operacion.motot), 'FTTH/SIAC - CAMBIO DE NUMERO', 0, 1);

insert into operacion.motot(CODMOTOT, DESCRIPCION, FLGCOM, TIPMOTOT)
values ((select MAX(CODMOTOT)+1 from operacion.motot), 'FTTH/SIAC - POR REGULARIZACION', 0, 1);
 
insert into operacion.motot(CODMOTOT, DESCRIPCION, FLGCOM)
values ((select MAX(CODMOTOT)+1 from operacion.motot), 'FTTH/SIAC - CAMBIO DE TITULARIDAD', 0);

insert into operacion.motot(CODMOTOT, DESCRIPCION, FLGCOM)
values ((select MAX(CODMOTOT)+1 from operacion.motot), 'FTTH/SIAC - CAMBIO DE PLAN', 0);

insert into operacion.motot(CODMOTOT, DESCRIPCION, FLGCOM, TIPMOTOT)
values ((select MAX(CODMOTOT)+1 from operacion.motot), 'FTTH/SIAC - TRASLADO A OTRA PROVINCIA', 1, 1);

 
insert into operacion.mototxtiptra (IDMOTXTIP, TIPTRA, CODMOTOT)
values ((select MAX(IDMOTXTIP)+1 from operacion.mototxtiptra), 
        v_tiptra_2,
        (select CODMOTOT from operacion.motot where DESCRIPCION = 'FTTH/SIAC - PORT OUT'));

insert into operacion.mototxtiptra (IDMOTXTIP, TIPTRA, CODMOTOT)
values ((select MAX(IDMOTXTIP)+1 from operacion.mototxtiptra), 
        v_tiptra_2,
        (select CODMOTOT from operacion.motot where DESCRIPCION = 'FTTH/SIAC - FRAUDE'));

insert into operacion.mototxtiptra (IDMOTXTIP, TIPTRA, CODMOTOT)
values ((select MAX(IDMOTXTIP)+1 from operacion.mototxtiptra), 
        v_tiptra_2,
        (select CODMOTOT from operacion.motot where DESCRIPCION = 'FTTH/SIAC - CAMBIO DE NUMERO'));
		 
insert into operacion.mototxtiptra (IDMOTXTIP, TIPTRA, CODMOTOT)
values ((select MAX(IDMOTXTIP)+1 from operacion.mototxtiptra), 
        v_tiptra_2,
        (select CODMOTOT from operacion.motot where DESCRIPCION = 'FTTH/SIAC - POR REGULARIZACION'));

insert into operacion.mototxtiptra (IDMOTXTIP, TIPTRA, CODMOTOT)
values ((select MAX(IDMOTXTIP)+1 from operacion.mototxtiptra), 
        v_tiptra_2,
        (select CODMOTOT from operacion.motot where DESCRIPCION = 'FTTH/SIAC - CAMBIO DE TITULARIDAD'));

insert into operacion.mototxtiptra (IDMOTXTIP, TIPTRA, CODMOTOT)
values ((select MAX(IDMOTXTIP)+1 from operacion.mototxtiptra), 
        v_tiptra_2,
        (select CODMOTOT from operacion.motot where DESCRIPCION = 'FTTH/SIAC - CAMBIO DE PLAN'));
		 
insert into operacion.mototxtiptra (IDMOTXTIP, TIPTRA, CODMOTOT)
values ((select MAX(IDMOTXTIP)+1 from operacion.mototxtiptra), 
        v_tiptra_2,
        (select CODMOTOT from operacion.motot where DESCRIPCION = 'FTTH/SIAC - TRASLADO A OTRA PROVINCIA'));

commit;
end;
/