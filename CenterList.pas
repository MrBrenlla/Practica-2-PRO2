unit CenterList;

interface
uses SharedTypes,PartyList;
const
	MAXC=25;
	NULLC=0;

type
	tPosC=0..MAXC;
	tItemC=record
	    centername:tCenterName;
		totalvoters:tNumVotes;
		validvotes:tNumVotes;
		partylist:tList;
	END;
	tListC=record
	item:array[1..MAXC] of tItemC;
	fin:integer;
	END;

procedure createEmptyListC(VAR list:tListC);
function isEmptyListC(list:tListC):boolean;
function firstC(list:tListC):tPosC;
function lastC(list:tListC):tPosC;
function nextC(position:tPosC;list:tListC):tPosC;
function previousC(position:tPosC;list:tListC):tPosC;
function insertItemC(item:tItemC;VAR list:tlistC):boolean;
procedure deleteAtPositionC(position:tPosC;VAR list:tlistC);
function getItemC(position:tPosC;list:tListC):tItemC;
procedure updateListC(L:tList;position:tPosC;VAR list:tListC);
procedure updateValidVotesC(votes:tNumVotes;position:tPosC;VAR list:tListC);
function findItemC(center:tCenterName;list:tListC):tPosC;

implementation



procedure createEmptyListC(VAR list:tListC);

{
Obxectivo: Crea unha lista vacía
Entradas: list, a lista que se desexa inicializar       
Saidas: list, é a mesma lista que se ten como entrada inicializada 
Postcondicións: A lista  non conten elementos
}

	BEGIN
		list.fin:=0;
	END;




function isEmptyListC(list:tListC):boolean;

{
Obxectivo: Comproba se unha lista está vacía
Entradas: list, a lista que se desexa comprobar       
Saidas: Un boolean que é verdadeiro se a lista está vacía 
Precondicións: A lista ten que estar inicializada}


	BEGIN
		if list.fin=NULLC then isEmptyListC:=true
		else isEmptyListC:=false;
	END;




function firstC(list:tListC):tPosC;

{Obxectivo: Devolver a posicion do primeiro elemento
Entradas: list, a lista da que se quere atopar o primeiro elemento      
Saidas: un tPosC coa posición do primeiro elemento
Precondicións: A lista ten que estar inicializada e non ser vacia}


	BEGIN
		firstC:=1
	END;




function lastC(list:tListC):tPosC;

{Obxectivo: Devolver a posicion do primeiro elemento
Entradas: list, a lista da que se quere atopar o primeiro elemento      
Saidas: un tPosC coa posición do primeiro elemento
Precondicións: A lista ten que estar inicializada e non ser vacia}


	BEGIN
		lastC:=list.fin
	END;



function nextC(position:tPosC;list:tListC):tPosC;

{Obxectivo: Devolver a posicion seguinte
Entradas: list, a lista na que se quere atopar a seguinte posicion      
Saidas: un tPosC coa posición seguinte
Precondicións: A lista ten que estar inicializada
               a posicion ten que ser unha posición valida
Postcondicións: devolverase NULL se non hai seguinte}


	BEGIN
		if position<list.fin then nextC:=position+1
		else nextC:=NULLC;
	END;

function previousC(position:tPosC;list:tListC):tPosC;

{Obxectivo: Devolver a posicion anterior
Entradas: list, a lista na que se quere atopar a anterior posicion      
Saidas: un tPosC coa posición anterior
Precondicións: A lista ten que estar inicializada
               a posicion ten que ser unha posición valida
Postcondicións: devolverase NULL se non hai anterior}


	BEGIN
		if position>1 then previousC:=position-1
		else previousC:=NULLC;
	END;



function insertItemC(item:tItemC;VAR list:tlistC):boolean;

{Obxectivo: Engadir un item na lista
Entradas:item, o item a engadir
         position, a posicion da lista na que se desexa engadir o item
         list, a lista na que se quere engadir o item    
Saidas: list, a lista de entrada modificada co novo item xa engadido
        un boolean que será verdadeiro se o item se engade correctamente
Precondicións: A lista ten que estar inicializada
               a posicion ten que ser unha posición valida ou NULL
Postcondicións: Todos os elementos que estan despos da posicion na que se introduce poden VARiar de posición}


	VAR
		i,j,n:integer;
		a,b:boolean;
	BEGIN
		if (list.fin=MAXC) then insertItemC:=FALSE
		else if (list.fin=0) then BEGIN
		list.fin:=1;
		list.item[1]:=item;	
		END else
		BEGIN		
			list.fin:=list.fin+1;
			a:=FALSE;
			i:=0;
			while (not a) and (list.fin<>i) do BEGIN	
			    i:=i+1;
				j:=1;
				b:=FALSE;
				while not b do BEGIN	 
		             if (ord(list.item[i].centername[j])<ord(item.centername[j])) then
		             b:=true;
		             if (ord(list.item[i].centername[j])=ord(item.centername[j])) then
		             j:=j+1;
		             if (ord(list.item[i].centername[j])>ord(item.centername[j])) then BEGIN
		             a:=true;b:=true; END;
	            END;
	        END;
	        n:=i;
	        if list.fin=n then 
	        list.item[n]:=item
	        else BEGIN
				for i:=list.fin-1 downto n do
					list.item[i+1]:=list.item[i];
			list.item[n]:=item;
			END;	
		END;
		insertItemC:=TRUE;
	END;



procedure deleteAtPositionC(position:tPosC;VAR list:tlistC);

{Obxectivo: eliminar un item na lista
Entradas:position, a posicion da lista na que se desexa eliminar o item
         list, a lista na que se quere eliminar o item    
Saidas: list, a lista de entrada modificada co  item xa eliminado
Precondicións: A lista ten que estar inicializada
               a posicion ten que ser unha posición valida
Postcondicións: Todos os elementos que estan despos da posicion na que se elimina poden VARiar de posición}


	VAR
		i:integer;
	BEGIN
		for i:=position to list.fin do
			list.item[i]:=list.item[i+1];
		list.fin:=list.fin-1;
	END;



function getItemC(position:tPosC;list:tListC):tItemC;

{Obxectivo: devolver o item que está na posición indicada da lista
Entradas:position, a posicion da lista na que está o item
         list, a lista na que se quere atopar o item    
Saidas: tItemC que se atopa na posicion introducida 
Precondicións: A lista ten que estar inicializada
               a posicion ten que ser unha posición valida
Postcondicións: }


	BEGIN
		getItemC:=list.item[position];
	END;


procedure updateListC(L:tList;position:tPosC;VAR list:tListC);

{Obxectivo: modificar o número de votos de un partido sabENDo a posición na lista
Entradas:votes, o novo número de votos do partido que se atpa nesa posición
         position, a posicion da lista na que se desexa eliminar o item
         list, a lista na que se quere modifica o número de votos    
Saidas: list, a lista de entrada modificada co novo número de votos na posición indicada
Precondicións: A lista ten que estar inicializada
               a posicion ten que ser unha posición valida
Postcondicións:A orde da lista non se ve modificada }


	BEGIN
		list.item[position].partylist:=L;
	END;

procedure updateValidVotesC(votes:tNumVotes;position:tPosC;VAR list:tListC);

{Obxectivo: modificar o número de votos validos dun partido sabENDo a posición na lista
Entradas:votes, o novo número de votos do partido que se atopa nesa posición
         position, a posicion da lista na que se desexa cambiar o item
         list, a lista na que se quere modifica o número de votos    
Saidas: list, a lista de entrada modificada co novo número de votos na posición indicada
Precondicións: A lista ten que estar inicializada
               a posicion ten que ser unha posición valida
Postcondicións:A orde da lista non se ve modificada }


	BEGIN
		list.item[position].validvotes:=votes;
	END;
	
	
	

function findItemC(center:tCenterName;list:tListC):tPosC;

{Obxectivo: devolver a posición de un centro nunha lista
Entradas:center, o centro quese desexa buscar
         list, a lista na que se quere buscar o centro  
Saidas: un tPosC coa posición do centro que se busca na lista
Precondicións: A lista ten que estar inicializada
Postcondicións:Devolverase so a posición da primeira vez que apareza o centro
               Devolverase NULL se o centro non existe }
               
               
	VAR
		i,pos:tPosC;
	BEGIN
	if list.fin=0 then findItemC:=NULLC else BEGIN
		pos:=NULLC;
		i:=0;
		repeat
			i:=i+1;
			if list.item[i].centername=center then pos:=i;
		until (list.item[i].centername=center)or(i>list.fin);
		findItemC:=pos;
		END;
	END;



END.
