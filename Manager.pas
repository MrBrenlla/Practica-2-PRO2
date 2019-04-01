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
function insertPartyInCenter(center:tCenterName;party:tPartyName;manager:tManager):boolean;
function deleteCenters(VAR manager:tManager):integer;
procedure deletemanager(VAR manager:tManager);
procedure showStats(manager:tManager);
function voteInCenter(center:tCenterName; party:tPartyName; Var manager:tManager):boolean;

implementation


	procedure createEmptyManager(VAR Manager:tManager);
	
	BEGIN
		createEmptyListC(Manager);
	END;
	
	
	function insertCenter(center:tCenterName;voters:tNumVotes; VAR manager:tManager):boolean;
	
	VAR
	itemC:tItemC;
	
	BEGIN
		itemC.centername:=center;
		itemC.totalvoters:=voters;
		itemC.validvotes:=0;
		createEmptyList(itemC.partylist);
		insertCenter:=insertItemC(itemC,manager);
	END;
	
	
	function deleteCenters(VAR manager:tManager):integer;
	
	VAR
	position,tmp:tPosC;
	itemC:tItemC;
	cont:integer;
	comprobador:boolean;
	
	BEGIN
		comprobador:=TRUE;
		cont:=0;
		if not isEmptyListC(manager) then BEGIN
			itemC:=getItemC(firstC(manager),manager);
			while (itemC.validvotes=0) and isEmptyList(itemC.partylist) and comprobador do BEGIN
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
					if (itemC.validvotes=0) and isEmptyList(itemC.partylist) then BEGIN
						deleteAtPositionC(position,manager);
						cont:=cont+1;
						END
					else position:=tmp;
				END;
			END;
			deleteCenters:=cont;
		END;
	END;
		


	function insertPartyInCenter(center:tCenterName;party:tPartyName;manager:tManager):boolean;
	
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
			tmp:=first(list);
			while not isEmptyList(list) do deleteAtPosition(tmp,list);
			deleteAtPositionC(firstC(manager),manager);
		END;
	END;
