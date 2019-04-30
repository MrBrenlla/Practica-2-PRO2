{
TITLE:
AUTHOR 1: Brais García Brenlla        
AUTHOR 2: Javier González Rodríguez  
DATE:
}

unit Manager;

interface

uses SharedTypes,PartyList,CenterList;

type
	tManager=tListC;
	

procedure createEmptyManager(VAR manager:tManager);
function insertCenter(center:tCenterName;voters:tNumVotes; VAR manager:tManager):boolean;
function insertPartyInCenter(center:tCenterName;party:tPartyName;VAR manager:tManager):boolean;
function deleteCenters(VAR manager:tManager):integer;
procedure deletemanager(VAR manager:tManager);
procedure showStats( manager:tManager);
function voteInCenter(center:tCenterName; party:tPartyName; Var manager:tManager):boolean;

implementation


procedure createEmptyManager(VAR Manager:tManager);
{
Obxectivo: inicializa un tManager
Entradas: Manager, o tManager a inicializar    
Saidas: o tManager inicializado
Postcondicións: o tManager non contén elementos
}

BEGIN
	createEmptyListC(Manager);
END;



function insertCenter(center:tCenterName;voters:tNumVotes; VAR manager:tManager):boolean;
{
Obxectivo:Insertar un novo centro de forma ordenada no tManager 
Entradas: center, o nome do centro electoral a insertar
		  voters, o numero de votantes no censo electoral
		  manager, o tManager no que se quere incorporar o centro
Saidas: o manager co novo centro electoral insertado
		un boolean que indica se a inserción se produciu correctamente
Postcondicións: o campo validvotes do novo centro queda inicializado a 0
				os centros que se atopen despois do que se inserta poden modificar a sua posición
				o centro terá inicializados o partido NULLVOTE e BLANKVOTE
}

VAR
itemC:tItemC;
item:tItem;
list:tList;
tmp:boolean;

BEGIN
	itemC.centername:=center; {Creamos o tItemC do centro}
	itemC.totalvoters:=voters;
	itemC.validvotes:=0;
	createEmptyList(list); {Inicializamos a lista de partidos do centro e insertamos NULLVOTE e BLANKVOTE}
	item.partyname:=BLANKVOTE;
	item.numvotes:=0;
	insertItem(item,list);
	item.partyname:=NULLVOTE;
	insertItem(item,list);{Insertamos a lista de partidos no tItemC}
	itemC.partylist:=list;
	tmp:=insertItemC(itemC,manager);{insertamos itemC en manager}
	insertCenter:=tmp;
END;



function deleteCenters(VAR manager:tManager):integer;
{
Obxectivo:Eliminar os centros que teña 0 votos validos 
Entradas: manager, o tManager a modificar   
Saidas: o tManager modificado
		un integer co número de centros eliminados
Postcondicións: a lista de partidos do centro tamén será eliminada 
}

VAR
	position,tmp:tPosC;
	itemC:tItemC;
	cont:integer;
	comprobador:boolean;
	tmp2:tPosL;

BEGIN
	comprobador:=TRUE;
	cont:=0;
	if not isEmptyListC(manager) then BEGIN
		itemC:=getItemC(firstC(manager),manager);
		while (itemC.validvotes=0) and comprobador do BEGIN {cromprobase o primeiro elemento e eliminase ata que o primeiro teña un número de votos validos diferente de 0, ou no seu defecto ata vaciar a lista}
			writeln('* Remove: center ',itemC.centername);
			while not isEmptyList(itemC.partylist) do BEGIN{eliminase a lista de partidos do centro}
				tmp2:=first(itemC.partylist);
				deleteAtPosition(tmp2,itemC.partylist);
			END;
			deleteAtPositionC(firstC(manager),manager);
			if not isEmptyListC(manager) then itemC:=getItemC(firstC(manager),manager)
			else Comprobador:=FALSE;
			cont:=cont+1;
		END;
		if comprobador then BEGIN {Se non se vacía a lista segeuese recorrendo a lista en busca de elementos a eliminar}
			position:=firstC(manager);
			while position<>lastC(manager) do BEGIN
				tmp:=nextC(position,manager);
				itemC:=getItemC(tmp,manager);
				if (itemC.validvotes=0)  then BEGIN
					writeln('* Remove: center ',itemC.centername);
					while not isEmptyList(itemC.partylist) do BEGIN
						tmp2:=first(itemC.partylist);
						deleteAtPosition(tmp2,itemC.partylist);
					END;
					deleteAtPositionC(tmp,manager);
					cont:=cont+1;
					END
				else position:=tmp;
			END;
		END;
		deleteCenters:=cont;
	END;
END;
	


function insertPartyInCenter(center:tCenterName;party:tPartyName;VAR manager:tManager):boolean;
{
Obxectivo: Insertar un novo partido nun centro
Entradas: center, o centro no que se quere incluir o partido
		  party, o nome do partido a engadir
		  manager, o tManager onde se atopa o centro
Saidas: o tManager modificado
		un boolean que será TRUE se a inserción foi correcta
Postcondicións: o número de votos do partido será 0
}

VAR
	position:tPosC;
	itemC:tItemC;
	list:tList;
	item:tItem;
	tmp: boolean;

BEGIN
	position:=findItemC(center,manager);
	if isEmptyListC(manager) or (position=NULLC) then insertPartyInCenter:=FALSE
	else BEGIN
		itemC:=getItemC(position,manager);
		list:=itemC.partylist;
		item.partyname:=party;
		item.numvotes:=0;
		tmp:=insertItem(item,list);
		updateListC(list,position,manager);
		insertPartyInCenter:=tmp;
	END;
END;



procedure deletemanager(VAR manager:tManager);
{
Obxectivo:Eliminar todos os elementos do tManager
Entradas:manager, o tManager a vaciar      
Saidas: o tManager vacío
}

VAR
	itemC:tItemC;
	list:tList;
	tmp:tPosL;

BEGIN
	while not isEmptyListC(manager) do BEGIN
		itemC:=getItemC(firstC(manager),manager);
		list:=itemC.partylist;
		while not isEmptyList(list) do BEGIN
			tmp:=first(list);
			deleteAtPosition(tmp,list);
		END;
		deleteAtPositionC(firstC(manager),manager);
	END;
END;



function vote(VAR list:tList;party:string):boolean;

{
Función auxiliar
Obxectivo: Engadir un voto ao partido selecionado
Entradas: list, é a lista na que se atopa o partido ao que se quere engadir un voto
		  party, é o partido ao que se quere engadir un voto
Saidas: list, a lista introducida modificada co voto que se engadiu
		un boolean que será FALSE se o voto é para un partido inexistente
Postcondicións: se o partido no existe o voto contarase como NULLVOTE 
}


VAR
	position:tPosL;
	votes:integer;
	item:tItem;
	comprobador:boolean;

BEGIN
	comprobador:=TRUE;
	position:=findItem(party,list);
		if position=null then BEGIN
				 comprobador:=FALSE;
				 position:=findItem(NULLVOTE,list);
		END;
		item:=getItem(position,list);
		votes:=item.numvotes+1;
		updateVotes(votes,position,list);
		vote:=comprobador;
END;
	
	

function voteInCenter(center:tCenterName; party:tPartyName; Var manager:tManager):boolean;
{
Obxectivo: aumenta en un o número de votos de un partido en un centro electoral
Entradas: center, o centro no que se atopa o partido ao que se quere engadir un voto
		  party, é o partido ao que se quere engadir un voto
Saidas: list, a lista introducida modificada co voto que se engadiu
		un boolean que será FALSE se o voto é para un partido inexistente
Postcondicións: se o partido no existe o voto contarase como NULLVOTE
Precondicións: O centro ten que ser valido 
}

VAR
	itemC:tItemC;
	position:tPosC;
	list:tList;
	tmp:boolean;

BEGIN
	position:=findItemC(center,manager);
	itemC:=getItemC(position,manager);
	list:=itemC.partylist;
	tmp:=vote(list,party);
	updateListC(list,position,manager);
	if tmp then updateValidVotesC(itemC.validvotes+1,position,manager);
	voteInCenter:=tmp;
END;

	

procedure stat(list:tList;totalvoters:integer;center:string);

{Función auxiliar
Función 
Obxectivo: Mostrar por pantalla numero de votos e porcentaxe de votos por partido e en total da lista de partido de un centro
Entradas: list, é a lista da que se desexan ver os datos
		  totalvoters, o número total de votantes que hai no censo
}

VAR
	totalvotes,votes,nullvotes:integer;
	percent:real;
	position:tPosL;
	item:tItem;
	
BEGIN
	totalvotes:=0;
	votes:=0;
	writeln('Center ',center);
	
	{Facemos un reconto dos votos, separando os NULLVOTES do resto}
	position:=first(list);
	item:=getItem(position,list);
	if item.partyname<>NULLVOTE then totalvotes:=totalvotes+item.numvotes  
	else nullvotes:=item.numvotes;
	repeat
			position:=next(position,list);
			item:=getItem(position,list);
			if item.partyname<>NULLVOTE then totalvotes:=totalvotes+item.numvotes
			else nullvotes:=item.numvotes;
	until position=last(list);
	
	{Unha vez temos o reconto mostrase por pantalla o total e o porcentaxe(excepto NULLVOTES) de cada partido}
	position:=first(list);
	item:=getItem(position,list);
	votes:=item.numvotes;
	if totalvotes>0 then percent:=100*votes/totalvotes
	else percent:=0;
	if item.partyname<>NULLVOTE then writeln('Party ',item.partyname,' numvotes ',votes,' (',percent:0:2,'%)')
	else writeln('Party ',item.partyname,' numvotes ',votes);
	repeat
			position:=next(position,list);
			item:=getItem(position,list);
			votes:=item.numvotes;
			if totalvotes>0 then percent:=100*votes/totalvotes
			else percent:=0;
			if item.partyname<>NULLVOTE then writeln('Party ',item.partyname,' numvotes ',votes,' (',percent:0:2,'%)')
			else writeln('Party ',item.partyname,' numvotes ',votes);
	until position=last(list);
	
	{Finalmente mostramos o numero de votos o porcentaxe sobre os votantes totais}
	totalvotes:=totalvotes+nullvotes;
	if totalvoters>0 then percent:=100*totalvotes/totalvoters
	else percent:=0;
	writeln('Participation: ',totalvotes,' votes from ',totalvoters,' voters (',percent:0:2,'%)');
	writeln;
END;





procedure showStats( manager:tManager);
{
Obxectivo: Mostrar por pantalla numero de votos e porcentaxe de votos por partido e en total da lista de partido de cada centro
Entradas: Manager, o tManager do que se queren mostrar as estadisticas
}

VAR
	itemC:tItemC;
	position,lastest:tPosC;
	list:tList;

BEGIN
	if not isEmptyListC(manager) then BEGIN
		position:=firstC(manager);
		lastest:=lastC(manager);
		while position<>lastest do BEGIN
			itemC:=getItemC(position,manager);
			list:=itemC.partylist;
			stat(list,itemC.totalvoters,itemC.centername);
			position:=nextC(position,manager);
		END;
		itemC:=getItemC(position,manager);
		list:=itemC.partylist;
		stat(list,itemC.totalvoters,itemC.centername);
	END;
END;

	
END.
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
