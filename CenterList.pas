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
	end;
	tListC=record
	item:array[1..MAXC] of tItemC;
	fin:integer;
	end;

procedure createEmptyListC(var list:tListC);
function isEmptyListC(list:tListC):boolean;
function firstC(list:tListC):tPosC;
function lastC(list:tListC):tPosC;
function nextC(position:tPosC;list:tListC):tPosC;
function previousC(position:tPosC;list:tListC):tPosC;
function insertItemC(item:tItemC;var list:tlistC):boolean;
procedure deleteAtPositionC(position:tPosC;var list:tlistC);
function getItemC(position:tPosC;list:tListC):tItemC;
procedure updateListC(L:tList;position:tPosC;var list:tListC);
procedure updateValidVotesC(votes:tNumVotes;position:tPosC;var list:tListC);
function findItemC(center:tCenterName;list:tListC):tPosC;

implementation



procedure createEmptyListC(var list:tListC);

{
Obxectivo: Crea unha lista vacía
Entradas: list, a lista que se desexa inicializar       
Saidas: list, é a mesma lista que se ten como entrada inicializada 
Postcondicións: A lista  non conten elementos
}

	begin
		list.fin:=0;
	end;




function isEmptyListC(list:tListC):boolean;

{
Obxectivo: Comproba se unha lista está vacía
Entradas: list, a lista que se desexa comprobar       
Saidas: Un boolean que é verdadeiro se a lista está vacía 
Precondicións: A lista ten que estar inicializada}

	begin
		if list.fin=NULLC then isEmptyListC:=true
		else isEmptyListC:=false;
	end;




function firstC(list:tListC):tPosC;

{Obxectivo: Devolver a posicion do primeiro elemento
Entradas: list, a lista da que se quere atopar o primeiro elemento      
Saidas: un tPosC coa posición do primeiro elemento
Precondicións: A lista ten que estar inicializada e non ser vacia}

	begin
		firstC:=1
	end;




function lastC(list:tListC):tPosC;

{Obxectivo: Devolver a posicion do primeiro elemento
Entradas: list, a lista da que se quere atopar o primeiro elemento      
Saidas: un tPosC coa posición do primeiro elemento
Precondicións: A lista ten que estar inicializada e non ser vacia}

	begin
		lastC:=list.fin
	end;



function nextC(position:tPosC;list:tListC):tPosC;

{Obxectivo: Devolver a posicion seguinte
Entradas: list, a lista na que se quere atopar a seguinte posicion      
Saidas: un tPosC coa posición seguinte
Precondicións: A lista ten que estar inicializada
               a posicion ten que ser unha posición valida
Postcondicións: devolverase NULL se non hai seguinte}

	begin
		if position<list.fin then nextC:=position+1
		else nextC:=NULLC;
	end;

function previousC(position:tPosC;list:tListC):tPosC;

{Obxectivo: Devolver a posicion anterior
Entradas: list, a lista na que se quere atopar a anterior posicion      
Saidas: un tPosC coa posición anterior
Precondicións: A lista ten que estar inicializada
               a posicion ten que ser unha posición valida
Postcondicións: devolverase NULL se non hai anterior}

	begin
		if position>1 then previousC:=position-1
		else previousC:=NULLC;
	end;



function insertItemC(item:tItemC;var list:tlistC):boolean;

{Obxectivo: Engadir un item na lista
Entradas:item, o item a engadir
         position, a posicion da lista na que se desexa engadir o item
         list, a lista na que se quere engadir o item    
Saidas: list, a lista de entrada modificada co novo item xa engadido
        un boolean que será verdadeiro se o item se engade correctamente
Precondicións: A lista ten que estar inicializada
               a posicion ten que ser unha posición valida ou NULL
Postcondicións: Todos os elementos que estan despos da posicion na que se introduce poden variar de posición}

	var
		i,j,n:integer;
		a,b:boolean;
	begin
		if (list.fin=MAXC) then insertItemC:=FALSE
		else if (list.fin=0) then begin
		list.fin:=1;
		list.item[1]:=item;	
		end else
		BEGIN		
			list.fin:=list.fin+1;
			a:=FALSE;
			i:=0;
			while (not a) and (list.fin<>i) do begin	
			    i:=i+1;
				j:=1;
				b:=FALSE;
				while not b do begin	 
		             if (ord(list.item[i].centername[j])<ord(item.centername[j])) then
		             b:=true;
		             if (ord(list.item[i].centername[j])=ord(item.centername[j])) then
		             j:=j+1;
		             if (ord(list.item[i].centername[j])>ord(item.centername[j])) then begin
		             a:=true;b:=true; end;
	            end;
	        end;
	        n:=i;
	        if list.fin=n then 
	        list.item[n]:=item
	        else begin
				for i:=list.fin-1 downto n do
					list.item[i+1]:=list.item[i];
			list.item[n]:=item;
			end;	
		end;
		insertItemC:=TRUE;
	end;



procedure deleteAtPositionC(position:tPosC;var list:tlistC);

{Obxectivo: eliminar un item na lista
Entradas:position, a posicion da lista na que se desexa eliminar o item
         list, a lista na que se quere eliminar o item    
Saidas: list, a lista de entrada modificada co  item xa eliminado
Precondicións: A lista ten que estar inicializada
               a posicion ten que ser unha posición valida
Postcondicións: Todos os elementos que estan despos da posicion na que se elimina poden variar de posición}

	var
		i:integer;
	begin
		for i:=position to list.fin do
			list.item[i]:=list.item[i+1];
		list.fin:=list.fin-1;
	end;



function getItemC(position:tPosC;list:tListC):tItemC;

{Obxectivo: devolver o item que está na posición indicada da lista
Entradas:position, a posicion da lista na que está o item
         list, a lista na que se quere atopar o item    
Saidas: tItemC que se atopa na posicion introducida 
Precondicións: A lista ten que estar inicializada
               a posicion ten que ser unha posición valida
Postcondicións: }
	begin
		getItemC:=list.item[position];
	end;


procedure updateListC(L:tList;position:tPosC;var list:tListC);

{Obxectivo: modificar o número de votos de un partido sabendo a posición na lista
Entradas:votes, o novo número de votos do partido que se atpa nesa posición
         position, a posicion da lista na que se desexa eliminar o item
         list, a lista na que se quere modifica o número de votos    
Saidas: list, a lista de entrada modificada co novo número de votos na posición indicada
Precondicións: A lista ten que estar inicializada
               a posicion ten que ser unha posición valida
Postcondicións:A orde da lista non se ve modificada }
	begin
		list.item[position].partylist:=L;
	end;

procedure updateValidVotesC(votes:tNumVotes;position:tPosC;var list:tListC);

{Obxectivo: modificar o número de votos validos dun partido sabendo a posición na lista
Entradas:votes, o novo número de votos do partido que se atopa nesa posición
         position, a posicion da lista na que se desexa cambiar o item
         list, a lista na que se quere modifica o número de votos    
Saidas: list, a lista de entrada modificada co novo número de votos na posición indicada
Precondicións: A lista ten que estar inicializada
               a posicion ten que ser unha posición valida
Postcondicións:A orde da lista non se ve modificada }
	begin
		list.item[position].validvotes:=votes;
	end;
	
	
	

ffunction findItemC(center:tCenterName;list:tListC):tPosC;

{Obxectivo: devolver a posición de un centro nunha lista
Entradas:center, o centro quese desexa buscar
         list, a lista na que se quere buscar o centro  
Saidas: un tPosC coa posición do centro que se busca na lista
Precondicións: A lista ten que estar inicializada
Postcondicións:Devolverase so a posición da primeira vez que apareza o centro
               Devolverase NULL se o centro non existe }
	var
		i,pos:tPosC;
	begin
	if list.fin=0 then findItemC:=NULLC else begin
		pos:=NULLC;
		i:=0;
		repeat
			i:=i+1;
			if list.item[i].centername=center then pos:=i;
		until (list.item[i].centername=center)or(i>list.fin);
		findItemC:=pos;
		end;
	end;



end.
