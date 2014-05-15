import std.algorithm;
import std.conv:to;
import std.stdio;
import forops;
struct AASystem {
	static struct Variable {
		char chr;
		double val;
		@property hasValue() {return (val != double.init);}
		
		void opAssign(char c) {
			this.chr = c;
		}

	}

	struct AARow {
		double[char] vals;
		double res;
		this (double[char] v,double r) {
			foreach(key,val;v) {
				vals[key]=val;
			}
			res=r;
		}

		
		@property bool singleVariable() {return vals.length == 1;}

		bool hasVariables(char[] vars) {
			foreach (v;vars)
				if (!hasVariables(v))
					return false;
			return true;
		}

		bool hasVariables(char var) {
			foreach(v;vals.byKey) {
				if (var == v) 
					return true;
			}
			return false;
		}
		
		AARow applyTo(char op,double val) {
			double res;
			double[char] vals;
			foreach (v;this.vals.byKey) {
				mixin(ForOps!("vals[v] = this.vals[v]",/*~op~*/"val"
				              ,
				              "res = this.res",/*~op~*/"val")
				      (['/','*'])
				      );
			}
			return AARow(vals,res);
		}

	}

	
	AARow rows[];
	Variable[char] vars; 
	
	char[] allIdentifiers;

	AARow[] getSingleVariableRows() {
		AARow[] res;
		foreach (r;rows) {
			if (r.singleVariable) {
				res ~= r;
			}
		}
		return res;
	}

	void addVars(char[] ids) {
		foreach (id;ids) {
			vars[id] = id;
		}
	}
	ref Variable getVar (char id) {
		return vars[id];
	}
	AASystem applyTo(char op,double val) {
		AARow[] aars;
		foreach (r;rows) {
			aars ~=   r.applyTo(op,val);
		}
		return AASystem(aars);
	}

	AARow[] getRowsWith(char[] vars) {
		AARow[] res;
		foreach (r;rows) {
			if (r.hasVariables(vars)) {
				res ~= r;
			}
		}
		return res;
	}

	this (AARow[] aars) {
		rows = aars;
	}

	string toString() {
		char[] vstring;
		foreach (r;rows) {
			foreach (i;0 .. r.vals.length) {
				if (r.vals[r.vals.keys[i]]>0 && i!=0) vstring ~= '+';
				vstring ~= to!string(r.vals[r.vals.keys[i]]) ~ r.vals.keys[i];
			}
			vstring ~= "=" ~ to!string(r.res) ~ "\n";
		}
		return cast(string)vstring;
	}

}
alias Variable = AASystem.Variable;


