import std.algorithm:map,sort,find;
import std.conv:to;
import std.stdio;
struct System {
	Row[] rows;
	char[] allIdentifiers;
	this(Row[] r) {
		rows=r;
		allIdentifiers = getAllIdentifiers(r);
	}
	string toString() {
		string str;
		foreach (row;rows) {
			str ~= row.toString ~ '\n';
		}
		return str;
	}
}

struct Row {
	 struct Pair {
      int val;
      char chr;
  }
  
  alias  map!("a.chr") chrmap;
  alias  map!("a.val") valmap;
	 
	char[] identfiers;
	Pair[] vars;
	int res;
	

	
	@disable this();
	this(Pair[] pa,int result) {
		writeln( map!("a.chr")(pa));
		sort!("a.chr<b.chr")(pa); 
		vars=pa;
		res = result;
	}
	
	string toString() {
		string str;
		foreach (var;vars) {
			if (var.val>0 && var !is vars[0]) str ~= '+';
			str ~= to!string(var.val) ~ var.chr;
		}
		str ~= '=' ~ to!string(res);   
		
		return str;
	}
	
}

private char[] getAllIdentifiers (Row[] parsedRows) {
	char[] vars;
		foreach (r;parsedRows) {
			auto ids = getIdentfiers(r);
			foreach (chr;ids)
			if(find(vars,chr)==[])
			vars~=chr;
		}
	return cast(char[])sort(cast(ubyte[])vars).release;
}

private char[] getIdentfiers(Row r) {
	char[] ids;
		foreach (pair;r.vars) {
				if(find(ids,pair.chr)==[])
				ids ~= pair.chr;
		}
	return ids;
}
