MODULE CalibData
! Mesa obtenida con el robot real e identificada con la aplicación    
    PERS wobjdata mesainclinda:=[FALSE,TRUE,"",[[384.324,49.0758,39.084],[0.462863,0.0582275,-0.0888802,-0.880038]],[[0,0,0],[1,0,0,0]]];
    
! Herramientas y objetos obtenidos desde la gráfica
    TASK PERS tooldata Pinza_Neumatica:=[TRUE,[[0,0,40],[1,0,0,0]],[0.3,[0,0,1],[1,0,0,0],0,0,0]];
    TASK PERS tooldata Lapiz:=[TRUE,[[0.235,-0.372,210.177],[1,0,0,0]],[1,[0,0,1],[1,0,0,0],0,0,0]];
    PERS tooldata pinza:=[TRUE,[[0,0,206],[0.965926,0,0,0.258819]],[1.8,[2.7,0,84.4],[1,0,0,0],0.033,0.034,0.007]];
    PERS wobjdata mesa_inclinada_graf:=[FALSE,TRUE,"",[[382.89,51.6324,53.0735],[0.460273998,0.0624174,-0.113418999,-0.878286995]],[[0,0,0],[1,0,0,0]]];
    PERS wobjdata Mesa_Lapiz_graf:=[FALSE,TRUE,"",[[76,382,134],[0,0,0,1]],[[0,0,0],[1,0,0,0]]];
    PERS wobjdata mesablanca:=[FALSE,TRUE,"",[[382.066,57.0371,68.2967],[0.456518,0.0541315,-0.0998623,-0.882433]],[[0.000655651,-0.00110269,-0.000679167],[1,1.664E-06,-1.998E-06,7.345E-06]]];
	TASK PERS wobjdata W_Caja_Barras:=[FALSE,TRUE,"",[[150.426,650,0],[0,0,0,1]],[[0,0,0],[1,0,0,0]]];

! Posiciones en ejes de interes
    CONST jointtarget Punto_Base:= [[0,0,0,0,90,0],[1e9,1e9,1e9,1e9,1e9,1e9]];
    CONST jointtarget Punto_Sing:= [[0,0,0,0,0,0],[1e9,1e9,1e9,1e9,1e9,1e9]];
	CONST jointtarget jcentro_mesanegra:=[[0.28681,36.6677,27.5513,0.000396794,25.786,0.286404],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

    CONST jointtarget jinicial:=[[0,0,0,0,90,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST jointtarget J_Dado_Inicial:=[[-65.833379372,53.277647526,25.880923775,0.000137122,10.841410713,-65.833481825],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
	CONST jointtarget J_Dado_Mesa:=[[-25.538625429,23.676347031,47.659980858,-0.09636263,18.728455544,-25.447346781],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    
! Posiciones de los cubo y referencia de la mesa real
    
    CONST robtarget Inicial_Mesa:=[[68.177,-269.11, 33],[0,0,1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
	CONST robtarget Cubo_Rojo:=[[-31.168,150.009,-80],[0,0,1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
	CONST robtarget Cubo_Verde:=[[-80.054,-469.833,-70],[0,0,1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget Fin_Cubo_Rojo:=[[275,150.009,-80],[0,0,1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
	CONST robtarget Fin_Cubo_Verde:=[[275,-469.833,-70],[0,0,1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    
    ! Número aleaotorio, semilla
    Local PERS num seed:=27656;
 
    ! Genera un numero aleatorio
    FUNC num rand()
        seed:=(171*seed) MOD 30269;
        RETURN seed/30269;
    ENDFUNC
    
    ! Genera una posicion aleatoria en el tablero
    FUNC num random()
        
	VAR num alea;
	alea := rand();

        IF alea<0.33 THEN
            RETURN 1;
        ELSEIF alea<0.67 THEN
            RETURN 2;
        ELSE
            RETURN 3;
        ENDIF
        
    ENDFUNC
    
    
    ! Abre la pinza
    PROC AbrirPinza()
        Set do15; ! Abrir y desattacher
        WaitTime 2;
        Reset do15;
    ENDPROC
    
    
    ! Cerrar Pinza
    PROC CerrarPinza()
        Set do16;  ! Activar los sensores de attacher
        WaitTime 2;
        Reset do16;
    ENDPROC
    

ENDMODULE