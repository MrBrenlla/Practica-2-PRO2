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

BEGIN
	createEmptyListC(Manager);
END;


function insertCenter(center:tCenterName;voters:tNumVotes; VAR manager:tManager):boolean;

VAR
itemC:tItemC;
item:tItem;
list:tList;
tmp:boolean;

BEGIN
	itemC.centername:=center;
	itemC.totalvoters:=voters;
	itemC.validvotes:=0;
	createEmptyList(list);
	item.partyname:=BLANKVOTE;
	item.numvotes:=0;
	insertItem(item,list);
	item.partyname:=NULLVOTE;
	insertItem(item,list);
	itemC.partylist:=list;
	tmp:=insertItemC(itemC,manager);
	insertCenter:=tmp;
END;


function deleteCenters(VAR manager:tManager):integer;

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
		while (itemC.validvotes=0) and comprobador do BEGIN
			writeln('* Remove: center ',itemC.centername);
			while not isEmptyList(itemC.partylist) do BEGIN
				tmp2:=first(itemC.partylist);
				deleteAtPosition(tmp2,itemC.partylist);
			END;
			deleteAtPositionC(firstC(manager),manager);
			if not isEmptyListC(manager) then itemC:=getItemC(firstC(manager),manager)
			else Comprobador:=FALSE;
			cont:=cont+1;
		END;
		if comprobador then BEGIN
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

VAR
	position:tPosC;
	itemC:tItemC;
	list:tList;
	item:tItem;

BEGIN
	position:=findItemC(center,manager);
	if isEmptyListC(manager) or (position=NULLC) then insertPartyInCenter:=FALSE
	else BEGIN
		itemC:=getItemC(position,manager);
		list:=itemC.partylist;
		item.partyname:=party;
		item.numvotes:=0;
		insertItem(item,list);
		updateListC(list,position,manager);
		insertPartyInCenter:=TRUE;
	END;
END;



procedure deletemanager(VAR manager:tManager);

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
Obxectivo: Engadir un voto ao partido selecionado
Entradas: list, é a lista na que se atopa o partidos ao que se quere engadir un voto
		  party, é o partido ao que se quere engadir un voto
Saidas: list, a lista introducida modificada co voto que se engadiu
Postcondicións: se o partido no existe satara Error e o voto contarase como NULLVOTE 
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
		if party=NULLVOTE then comprobador:=FALSE;
		item:=getItem(position,list);
		votes:=item.numvotes+1;
		updateVotes(votes,position,list);
		vote:=comprobador;
END;
	
	

function voteInCenter(center:tCenterName; party:tPartyName; Var manager:tManager):boolean;

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

{
Obxectivo: Mostrar por pantalla numero de votos e porcentaxe de votos por partido e en total da lista de partido de un centro
Entradas: list, é a lista da que se desexan ver os datos
		  totalvoters, o número total de votantes que hai no censo 
Saidas: Mostraranse por pantalla as estadisticas
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
	
	{Unha vez temos o reconto mostrase por pantalla o total e o porcentaxe (excepto NULLVOTES) de cada partido}
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
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
