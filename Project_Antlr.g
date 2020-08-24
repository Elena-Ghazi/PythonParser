grammar Project_Antlr;

@members{
	GrammarFunctions g = new GrammarFunctions();
	Stack<Boolean> compStacks [] = null;
	boolean variableCheck = true;
}


prog 	: (stmt)+ 
		;
	
stmt 	: assignment | element_assignment | list_addition | slicing | list_comprehension |
		print
	 	;

assignment 	: ID {g.initList($ID.text);} '=' '[' value_list[$ID.text] ']'
			;

element_assignment  : ID '[' INT ']' '=' value {int i = new Integer($INT.text).intValue(); g.update($ID.text,i,$value.v);}
					;

list_addition   : list0 = ID '=' list1 = ID {
	ArrayList<Object> AL = new ArrayList<Object>();
		for (Object o: g.lists.get($list1.text)){
			AL.add(o);
		}
	}
	('+' list2 = ID {
		for (Object o: g.lists.get($list2.text)){
			AL.add(o);
		}
	})* 

	{g.lists.put($list0.text,AL);}
	;

slicing : id1 = ID '=' id2 = ID '[' (start = INT)? ':' (end = INT)? ']' {
		int s = 0;
		int e = g.lists.get($id2.text).size();
		if ($start.text != null){
			s = Integer.parseInt($start.text);
		}
		if ($end.text != null){
			e = Integer.parseInt($end.text);
		}
		ArrayList<Object> al = new ArrayList<Object>();
		
		int i = s;
		while (i<e){
			al.add(g.lists.get($id2.text).get(i));
			i+=1;
		}	
		g.lists.put($id1.text,al);
	}
		;
list_comprehension 	: destinationList = ID '=' '[' 'for' variable = ID 'in' sourceList = ID {int n = g.lists.get($sourceList.text).size(); compStacks = new Stack[n]; for (int i = 0; i < n; i++) compStacks[i] = new Stack<>();}'if' logical_statement[$sourceList.text,$variable.text] ']' 
{
	ArrayList<Object> sourcelist = g.lists.get($sourceList.text);
	ArrayList<Object> a = new ArrayList<>();
	if(variableCheck){
		for (int i = 0; i<n;i++){
			if (compStacks[i].pop()){
				a.add(sourcelist.get(i));
			}
		}
	}
	g.lists.put($destinationList.text,a);
}
					;

value_list [String listID] : v1 = value {g.addToList($listID,$v1.v);} (',' v2 = value {g.addToList($listID,$v2.v);})*
			|
			;	

value returns [Object v]	: INT {$v = new Integer($INT.text);}
							| STRING {$v = new String($STRING.text);}
							| ID {$v = new String($ID.text);}
							;

print 	: 'print' '(' ID ')' {g.printList($ID.text);}
		;


logical_statement[String listname, String var]		:  logical_statement1[$listname,$var] ('or' logical_statement1[$listname,$var]{
													int n = compStacks.length;
													for (int i = 0;i<n; i++){
														boolean first = compStacks[i].pop();
														boolean second = compStacks[i].pop();
														boolean result = first || second;
														compStacks[i].push(result);
													}
												})* 
										;

logical_statement1[String listname, String var] 	: logical_statement2[$listname,$var] ('and' logical_statement2[$listname,$var]{
												int n = compStacks.length;
												for (int i = 0;i<n; i++){
													boolean first = compStacks[i].pop();
													boolean second = compStacks[i].pop();
													boolean result = first && second;
													compStacks[i].push(result);
												}
											})*
										;


logical_statement2[String listname, String var] 	: (notOperation = 'not')? term[$listname, $var] {
												if($notOperation.text!=null){
													int n = compStacks.length;
													for (int i = 0; i<n; i++){
														boolean temp = compStacks[i].pop();
														temp = !temp;
														compStacks[i].push(temp);
													}
												}
											}

										;



term[String listname, String var]	:'(' ID logical_operator INT ')' {
		if ($var.equals($ID.text)){
			ArrayList<Object> arr = g.lists.get($listname);
			int n = arr.size();
			int arg = Integer.parseInt($INT.text);
			if($logical_operator.str.equals("<")){
				for (int i = 0;i<n;i++){
					compStacks[i].push((int)(arr.get(i))<arg);
				}
			}
			else if($logical_operator.text.equals(">")){
				for (int i = 0;i<n;i++){
					compStacks[i].push((int)(arr.get(i))>arg);
				}
			}
			else if($logical_operator.text.equals(">=")){
				for (int i = 0;i<n;i++){
					compStacks[i].push((int)(arr.get(i))>=arg);
				}
			}
			else if($logical_operator.text.equals("<=")){
				for (int i = 0;i<n;i++){
					int cast = (int)(arr.get(i));
					boolean temp = cast<=arg;
					System.out.println("hello");
					compStacks[i].push(temp);

				}
			}
			else if($logical_operator.text.equals("==")){
				for (int i = 0;i<n;i++){
					compStacks[i].push((int)(arr.get(i))==arg);
				}
			}
			else if($logical_operator.text.equals("!=")){
				for (int i = 0;i<n;i++){
					compStacks[i].push((int)(arr.get(i))!=arg);
				}
			}
			variableCheck = true;
		}
		else{
			variableCheck = false;
			System.out.println("Unknown variable. Did you mean "+ $var + "?");
		}
}
		|'(' INT logical_operator ID ')' {
			if ($var.equals($ID.text)){
				ArrayList<Object> arr = g.lists.get($listname);
				int n = arr.size();
				int arg = Integer.parseInt($INT.text);
				if ($logical_operator.text.equals("<")){
					for (int i = 0;i<n;i++){
						compStacks[i].push((int)(arr.get(i))>arg);
					}
				}
				else if($logical_operator.text.equals(">")){
					for (int i = 0;i<n;i++){
						compStacks[i].push((int)(arr.get(i))<arg);
					}
				}
				else if($logical_operator.text.equals(">=")){
					for (int i = 0;i<n;i++){
						compStacks[i].push((int)(arr.get(i))<=arg);
					}
				}
				else if($logical_operator.text.equals("<=")){
					for (int i = 0;i<n;i++){
						compStacks[i].push((int)(arr.get(i))>=arg);
					}
				}
				else if($logical_operator.text.equals("==")){
					for (int i = 0;i<n;i++){
						compStacks[i].push((int)(arr.get(i))==arg);
					}
				}
				else if($logical_operator.text.equals("!=")){
					for (int i = 0;i<n;i++){
						compStacks[i].push((int)(arr.get(i))!=arg);
					}
				}
				variableCheck = true;
			}
			else{
				variableCheck = false;
				System.out.println("Unknown variable. Did you mean "+ $var + "?");
			}
		}
		|'(' id1 = ID logical_operator id2 = ID ')'{
			if (($var.equals($id1.text)) && ($var.equals($id2.text))){
				int n = compStacks.length;
				if ($logical_operator.text.equals("==") | $logical_operator.text.equals("<=") | $logical_operator.text.equals(">=")){
					for (int i = 0; i<n; i++){
						compStacks[i].push(true);
					}
				}
				else{
					for (int i = 0; i<n; i++){
						compStacks[i].push(false);
					}
				}
				variableCheck = true;
			}
			else{
				variableCheck = false;
				System.out.println("Unknown variable. Did you mean "+ $var + "?");
			}
		}
		|'(' int1 = INT logical_operator int2 = INT ')'{
			int n = compStacks.length;
			int first = Integer.parseInt($int1.text);
			int second = Integer.parseInt($int2.text);
			boolean answer = true;
			if ($logical_operator.text.equals("<")){
				answer = first<second;
			}
			else if($logical_operator.text.equals(">")){
				answer = first>second;
			}
			else if($logical_operator.text.equals(">=")){
				answer = first>=second;
			}
			else if($logical_operator.text.equals("<=")){
				answer = first<=second;
			}
			else if($logical_operator.text.equals("==")){
				answer = first == second;
			}
			else if($logical_operator.text.equals("!=")){
				answer = first!=second;
			}
			for (int i = 0; i<n; i++){
				compStacks[i].push(answer);
			}
		}
		|'('logical_statement[$listname,$var] ')'
		;

logical_operator returns [String str]	: '<' { $str = new String("<"); }
										| '>' { $str = new String(">"); }
										|'>=' { $str = new String(">="); }
										|'<=' { $str = new String("<="); }
										|'==' { $str = new String("=="); }
										|'!=' { $str = new String("!="); }
					;







INT:('-')?('0'..'9')+;
ID:('a'..'z'|'A'..'Z'|'\_')('a'..'z'|'A'..'Z'|'0'..'9'|'\_')*;
STRING:'\''('a'..'z'|'A'..'Z'|'0'..'9')* '\'';
WS:(' '|'\t'|'\n'|'\r')+{skip();};



