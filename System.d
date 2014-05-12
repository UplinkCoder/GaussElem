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
	getRowsWith (char[] varIds) {
		Row[] res;
		foreach(r;rows) {
			if (var.Ids in r.getIdentifiers) {
				res ~= r;
			}
		}
	}
	
	string toString() {
		string str;
		foreach (row;rows) {
			str ~= row.toString ~ "\n";
		}
		return str;
	}
}

struct Row {
	struct Variable {
		char chr;
		double val;
		@property hasValue() {return (val != double.init);}
	}
	
	 struct Pair {
		double scalar;
		Variable var;
		deprecated alias val = scalar;
	}

	char[] identfiers;
	Pair[] vars;
	int res;
	

	@disable this();
	this(Pair[] pa,int result) {
		writeln( map!("a.var.chr")(pa));
		sort!("a.var.chr<b.var.chr")(pa); 
		vars=pa;
		res = result;
	}
	

	string toString() {
		string str;
		foreach (var;vars) {
			if (var.val>0 && var !is vars[0]) str ~= '+';
			str ~= to!string(var.val) ~ var.var.chr;
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
				if(find(ids,pair.var.chr)==[])
				ids ~= pair.var.chr;
		}
	return ids;
}
