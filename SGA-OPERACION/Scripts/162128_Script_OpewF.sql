declare
  n_wfdef wfdef.wfdef%type;
Begin
  select max(wfdef) + 1 into n_wfdef from wfdef;
  -- 1 CDMA
  insert into wfdef
    (WFDEF,
     ESTADO,
     CLASEWF,
     DESCRIPCION,
     VERSION,
     TIPOPLAZO,
     FECREG,
     USUREG,
     FECMOD,
     USUMOD)
  values
    (n_wfdef,
     1,
     0,
     'CAMBIO RECAUDACION TPI - CDMA',
     1,
     0,
     sysdate,
     user,
     sysdate,
     user);

  insert into opedd
    (IDOPEDD,
     CODIGOC,
     CODIGON,
     DESCRIPCION,
     ABREVIACION,
     TIPOPEDD,
     CODIGON_AUX)
  values
    (5893, '', n_wfdef, 'CAMBIO RECAUDACION TPI - CDMA', '', 260, null);

  -- 2 Coaxial
  
  n_wfdef := n_wfdef + 1;

  insert into wfdef
    (WFDEF,
     ESTADO,
     CLASEWF,
     DESCRIPCION,
     VERSION,
     TIPOPLAZO,
     FECREG,
     USUREG,
     FECMOD,
     USUMOD)
  values
    (n_wfdef,
     1,
     0,
     'CAMBIO RECAUDACION TPI - COAXIAL',
     1,
     0,
     sysdate,
     user,
     sysdate,
     user);

  insert into opedd
    (IDOPEDD,
     CODIGOC,
     CODIGON,
     DESCRIPCION,
     ABREVIACION,
     TIPOPEDD,
     CODIGON_AUX)
  values
    (5895, '', n_wfdef, 'CAMBIO RECAUDACION TPI - COAXIAL', '', 260, null);

  -- 3.- WIMAX
  
  n_wfdef := n_wfdef + 1;
  
  insert into wfdef
    (WFDEF,
     ESTADO,
     CLASEWF,
     DESCRIPCION,
     VERSION,
     TIPOPLAZO,
     FECREG,
     USUREG,
     FECMOD,
     USUMOD)
  values
    (n_wfdef,
     1,
     0,
     'CAMBIO RECAUDACION TPI - WIMAX',
     1,
     0,
     sysdate,
     user,
     sysdate,
     user);

  insert into opedd
    (IDOPEDD,
     CODIGOC,
     CODIGON,
     DESCRIPCION,
     ABREVIACION,
     TIPOPEDD,
     CODIGON_AUX)
  values
    (5894, '', n_wfdef, 'CAMBIO RECAUDACION TPI - WIMAX', '', 260, null);

  commit;
END;

/