import java.util.*;


public class GrammarFunctions {
	static HashMap<String,ArrayList<Object>> lists= new HashMap<String,ArrayList<Object>>();
	
	public void initList(String ListID){
		lists.put(ListID,new ArrayList<Object>());
	}
	
	public void printList(String ListID){
		System.out.println(ListID + " is " +lists.get(ListID));
	}
	
	public void addToList(String listID,Object value){
		ArrayList<Object> l= lists.get(listID);
		l.add(value);
	}
	
	public void update(String listID,int index,Object value){
		ArrayList<Object> l= lists.get(listID);
		l.set(index,value);
	}
}