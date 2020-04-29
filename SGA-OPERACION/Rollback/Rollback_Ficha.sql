--UPDATE PARA EL IDLISTA serviceType PAQUETE ADICIONAL TV
--antes se debe actualizar la configuración de la ficha de tv adicional atributo PAQUETE ADICIONAL TV-->serviceType
update sgacrm.ft_instdocumento set idlista=118 where idlista=93;
commit;