{
TITLE:
AUTHOR 1: Brais García Brenlla        
AUTHOR 2: Javier González Rodríguez  
DATE:
}

unit PartyList;

interface

const
	NULL=nil;

type
	tPosL=^tNodo;
	tItem=record
		partyname:tPartyName;
		numvotes:tNumVotes;
	end;
	tNodo=record
		item:tItem;
		next:^tNodo;
	end;
	tList=^tNodo;

procedure createEmptyList(var list:tList);
function isEmptyList(list:tList):boolean;
function first(list:tList):tPosL;
function last(list:tList):tPosL;
function next(position:tPosL;list:tList):tPosL;
function previous(position:tPosL;list:tList):tPosL;
function insertItem(item:tItem;VAR list:tlist):boolean;
procedure deleteAtPosition(VAR position:tPosL;VAR list:tlist);
function getItem(position:tPosL;list:tList):tItem;
procedure updateVotes(votes:tNumVotes;position:tPosL; list:tList);
function findItem(party:tPartyName;list:tList):tPosL;

implementation



procedure createEmptyList(var list:tList);

{
Obxectivo: Crea unha lista vacía
Entradas: list, a lista que se desexa inicializar       
Saidas: list, é a mesma lista que se ten como entrada inicializada 
Postcondicións: A lista  non conten elementos
}

	begin
		list:=NULL;
	end;




function isEmptyList(list:tList):boolean;

{
Obxectivo: Comproba se unha lista está vacía
Entradas: list, a lista que se desexa comprobar       
Saidas: Un boolean que é verdadeiro se a lista está vacía 
Precondicións: A lista ten que estar inicializada}

	begin
		if list=NULL then isEmptyList:=true
		else isEmptyList:=false;
	end;




function first(list:tList):tPosL;

{Obxectivo: Devolver a posicion do primeiro elemento
Entradas: list, a lista da que se quere atopar o primeiro elemento      
Saidas: un tPosL coa posición do primeiro elemento
Precondicións: A lista ten que estar inicializada e non ser vacia}

	begin
		first:=list
	end;




function last(list:tList):tPosL;

{Obxectivo: Devolver a posicion do primeiro elemento
Entradas: list, a lista da que se quere atopar o primeiro elemento      
Saidas: un tPosL coa posición do primeiro elemento
Precondicións: A lista ten que estar inicializada e non ser vacia}

VAR
position:tPosL;

	begin
		position:=list;
		while position^.next<>NULL do position:=position^.next;
		last:=position;
	end;



function next(position:tPosL;list:tList):tPosL;

{Obxectivo: Devolver a posicion seguinte
Entradas: list, a lista na que se quere atopar a seguinte posicion      
Saidas: un tPosL coa posición seguinte
Precondicións: A lista ten que estar inicializada
               a posicion ten que ser unha posición valida
Postcondicións: devolverase NULL se non hai seguinte}

	begin
		if position=last(list) then next:=NULL
		else next:=position^.next;
	end;

function previous(position:tPosL;list:tList):tPosL;

{Obxectivo: Devolver a posicion anterior
Entradas: list, a lista na que se quere atopar a anterior posicion      
Saidas: un tPosL coa posición anterior
Precondicións: A lista ten que estar inicializada
               a posicion ten que ser unha posición valida
Postcondicións: devolverase NULL se non hai anterior}

VAR
tmp:tPosL;

	begin
		if position=list then previous:=NULL {Se a posición é a primeira devolbese NULL}
		else BEGIN
			tmp:=list;
			while tmp^.next<>position do tmp:=tmp^.next; {recorrese a lista ata atopar a posición de inserción}
			previous:=tmp;
		end;
	end;



function insertItem(item:tItem;VAR list:tlist):boolean;

{Obxectivo: Engadir un item na lista
Entradas:item, o item a engadir
         list, a lista na que se quere engadir o item    
Saidas: list, a lista de entrada modificada co novo item xa engadido
        un boolean que será verdadeiro se o item se engade correctamente
Precondicións: A lista ten que estar inicializada
               a posicion ten que ser unha posición valida ou NULL
Postcondicións: Todos os elementos que estan despois da posicion na que se introduce poden variar de posición}

	var
	position,lastpos,tmp2:tPosL;
	tmp:tItem;
	begin

		{Insertar item se a lista está vacía}
		if isEmptyList(list) then BEGIN 
			new(list);
			list^.item:=item
		END
			
		{Insertar item se a lista non está vacía}
		else BEGIN
			position:=first(list);
			tmp:=getItem(position,list);
			if tmp.partyname>=item.partyname then BEGIN {Se o primeiro elemento xa é maior que o elemento a engadir}
				new(tmp2);
				tmp2^.next:=list;
				tmp2^.item:=item;
				list:=tmp2;
			END
			else BEGIN {Se o primeiro non é maior recorrese a lista ata atopar o primeiro que sexa maior que el}
				lastpos:=last(list);
				tmp:=getItem(next(position,list),list); 
				if lastpos^.item.partyname<=item.partyname then position:=lastpos {Se o ultimo elemento é menor engadese ao final da lista}
				else
					while (tmp.partyname<=item.partyname) and (position^.next<>lastpos) do BEGIN {Se o ultimo elemento non é menor buscase o ultimo que o sexa}
						position:=position^.next;
						tmp:=getItem(next(position,list),list); 
					END;
				new(tmp2);
				tmp2^.next:=position^.next;
				tmp2^.item:=item;
				position^.next:=tmp2;
			END;
		END;
		insertItem:=TRUE;
	end;



procedure deleteAtPosition(VAR position:tPosL;VAR list:tlist);

{Obxectivo: eliminar un item na lista
Entradas:position, a posicion da lista na que se desexa eliminar o item
         list, a lista na que se quere eliminar o item    
Saidas: list, a lista de entrada modificada co  item xa eliminado
Precondicións: A lista ten que estar inicializada
               a posicion ten que ser unha posición valida
Postcondicións: Todos os elementos que estan despos da posicion na que se elimina poden variar de posición}

	var
		tmp:tPosL;
	begin
		if position=first(list) then list:=position^.next {Se a posición a eliminar é a primeira variarase "list"}
		else BEGIN
			tmp:=previous(position,list);{No resto dos casos so variaran os nodos}
			tmp^.next:=position^.next;
		END;
		dispose(position);
	end;



function getItem(position:tPosL;list:tList):tItem;

{Obxectivo: devolver o item que está na posición indicada da lista
Entradas:position, a posicion da lista na que está o item
         list, a lista na que se quere atopar o item    
Saidas: tItem que se atopa na posicion introducida 
Precondicións: A lista ten que estar inicializada
               a posicion ten que ser unha posición valida }
	begin
		getItem:=position^.item;
	end;



procedure updateVotes(votes:tNumVotes;position:tPosL; list:tList);

{Obxectivo: modificar o número de votos de un partido sabendo a posición na lista
Entradas:votes, o novo número de votos do partido que se atpa nesa posición
         position, a posicion da lista na que se desexa eliminar o item
         list, a lista na que se quere modifica o número de votos    
Saidas: list, a lista de entrada modificada co novo número de votos na posición indicada
Precondicións: A lista ten que estar inicializada
               a posicion ten que ser unha posición valida
Postcondicións:A orde da lista non se ve modificada }
	begin
		position^.item.numvotes:=votes;
	end;
	
	
	

function findItem(party:tPartyName;list:tList):tPosL;

{Obxectivo: devolver a posición de un partido nunha lista
Entradas:party, o partido quese desexa buscar
         list, a lista na que se quere buscar o partido   
Saidas: un tPosL coa posición do partido que se busca na lista
Precondicións: A lista ten que estar inicializada
Postcondicións:Devolverase so a posición da primeira vez que apareza o partido
               Devolverase NULL se o partido non existe }
	VAR
	position,tmp:tPosL;
	begin
	if not(isEmptyList(list)) then BEGIN {comprobase que a lista non sexa vacía}
		tmp:=last(list);
		position:=first(list);
		while (party>position^.item.partyname) and (position<>tmp) do position:=next(position,list); {recorrese a lista ata atopar o elemento, ou no seu defecto ata atopar un elemento maior ou acabar a lista}
		if(position^.item.partyname=party) then findItem:=position
		else findItem:=NULL;
	END
	else findItem:=NULL;
	
	END;


end.
