program gg(input,output);

	uses PartyList,CenterList,Manager,SharedTypes;
	
	VAR

	listC:tListC;
	list:tList;
	item,item2:tItem;
	itemC,itemC2:tItemC;	
	m:tManager;
	
	BEGIN
	createEmptyList(list);
	createEmptyListC(listC);
	createEmptyManager(m);


	
	item.partyname:='gg';
	item.numvotes:=0;
	insertItem(item,list);
	item2:=getItem(first(list),list);
	writeln(item2.partyname);
	writeln(item2.numvotes);
	item.partyname:='ag';
	item.numvotes:=0;
	insertItem(item,list);
	item2:=getItem(first(list),list);
	writeln(item2.partyname);
	writeln(item2.numvotes);
	
	insertItem(item2,itemC.partylist);
	itemC.validvotes:=0;
	itemC.totalvoters:=3;
	
	insertItemC(itemC,listC);
		writeln(item2.numvotes);
	itemC2:=getItemC(firstC(listC),listC);
	writeln(itemC2.validvotes);
		writeln(item2.numvotes);
	insertCenter('ff',2,m);
	insertCenter('aa',4,m);
	
	showStats(m);
		

END.
