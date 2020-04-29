declare 
begin
  delete operacion.tipopedd where ABREV='PROCESO_PROV_TLF_FTTH';
  delete operacion.opedd where ABREVIACION='ACT_NUM_FT';
  delete operacion.opedd where ABREVIACION='ACT_MODEL_ONT';
  delete operacion.opedd where ABREVIACION='OBT_PASS_PINDB';
  delete operacion.opedd where ABREVIACION='ACT_TLF';
  delete operacion.opedd where ABREVIACION='ACT_FT_PASS';
  delete operacion.opedd where ABREVIACION='Actualiza_Ficha_JSON_PASS';
  delete operacion.opedd where ABREVIACION='GEN_RES_BSCS';
  update ft_campo set valorcampo = null, tipo = 0 where iddocumento = 14 and idlista = 125;
  delete ft_campo where iddocumento=10 and etiqueta='TIPO_EQU_PROV' and idcomponente = 21;
  delete ft_campo where iddocumento=11 and etiqueta='TIPO_EQU_PROV' and idcomponente = 20;
  delete ft_campo where iddocumento=12 and etiqueta='TIPO_EQU_PROV' and idcomponente = 22;
  delete ft_campo where iddocumento=13 and etiqueta='ESTADO FICHA' and idcomponente = 24;
  delete ft_campo where iddocumento=13 and etiqueta='TIPO_EQU_PROV' and idcomponente = 24;
  delete ft_campo where iddocumento=14 and etiqueta='ESTADO FICHA' and idcomponente = 25;
  delete ft_campo where iddocumento=14 and etiqueta='TIPO_EQU_PROV' and idcomponente = 25;
  delete ft_componentexlista where etiqueta='TIPO_EQU_PROV' and idcomponente = 20;
  delete ft_componentexlista where etiqueta='TIPO_EQU_PROV' and idcomponente = 21;
  delete ft_componentexlista where etiqueta='TIPO_EQU_PROV' and idcomponente = 22;
  delete ft_componentexlista where etiqueta='ESTADO FICHA' and idcomponente = 24;
  delete ft_componentexlista where etiqueta='TIPO_EQU_PROV' and idcomponente = 24;
  delete ft_componentexlista where etiqueta='ESTADO FICHA' and idcomponente = 25;
  delete ft_componentexlista where etiqueta='TIPO_EQU_PROV' and idcomponente = 25;
  delete ft_lista where descripcion='TIPO_EQU_PROV';
  commit;
end;
/