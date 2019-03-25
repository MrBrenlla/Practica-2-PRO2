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
	

procedure createEmptyManager(VAR tManager);
function insertCenter(tCenterName, tNumVotes, VAR tManager):boolean;
function insertPartyInCenter(tCenterName, tPartyName,VAR tManager):boolean
function deleteCenters(VAR tManager):integer;
procedure deletemanager(VAR tManager);
procedure showStats(tManager);
function voteInCenter(tCenterName, tPartyName, Var tManager):boolean;

implementation


	procedure createEmptyManager(Manager:tManager);
	
	BEGIN
		createEmptyListC(Manager);
	END;
	
	
	function insertCenter(center:tCenterName, votes:tNumVotes, VAR manager:tManager);
	
	VAR
	itemC:tItemC;
	tmp:tList;
	
	BEGIN
		itemC.centername:=center;
		itemC.totalvoters:=center;
		itemC.valisvotes:=center;
		createEmptyList(itemC.partylist);
		
