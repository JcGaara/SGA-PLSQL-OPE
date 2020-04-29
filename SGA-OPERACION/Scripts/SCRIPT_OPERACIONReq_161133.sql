update opewf.tareadef set pre_proc = 'OPERACION.PQ_CUSPE_PLATAFORMA.P_PRE_VAL_MSJ_INTW', chg_proc='OPERACION.PQ_CUSPE_PLATAFORMA.P_CHG_VAL_MSJ_INTW'
WHERE   tareadef = 723;
insert into operacion.constante(constante,descripcion,tipo,valor)
       values ('CANMINPIN','Cantidad minima de pines disponibles','N',100); 
--Configuración de Destinatarios PIN Minimo Disponible
declare
  ln_tipopedd number;

begin

  select max(tipopedd) + 1 into ln_tipopedd from operacion.tipopedd;

  insert into operacion.tipopedd(tipopedd,descripcion,abrev) values(ln_tipopedd,'Destinatarios PIN Minimo Dis.','PIN_MIN_DIS');
  
  insert into operacion.opedd(descripcion,tipopedd) values ('hector.huaman@claro.com.pe',ln_tipopedd);
  
  commit;
end; 
/
 