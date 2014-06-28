import std.algorithm;
import std.array;
import std.conv:to;
import std.stdio;
import forops;
struct AASystem {

	struct AARow {
		struct Operation {
			char operator;
			union scalar_or_id {
				double scalar;
				uint id;
			};
		}
		double[char] scalars;
		alias scalars this;
		double res;
		this (double[char] v,double r) {
			foreach(key,val;v) {
				scalars[key]=val;
			}
			res=r;
		}

		string toString () {
			return to!string(scalars)~to!string(res);
		}

		@property bool singleVariable() {return scalars.length == 1;}

		@property char[] vars() {
			return scalars.keys;
		}

		AARow opBinary (string op)(double val) if (op=="*"||op=="/") {
			AARow ret;
			foreach (k,v;scalars) {
				mixin(q{ret[k] = v }~op~q{val;}
				q{ret.res = res}~op~q{val;}) ;
			}
			return ret;
		}

		AARow opBinary (string op)(AARow rhs) if ((op=="+"||op=="-")) {
			AARow ret = AARow(this.scalars,this.res);
			foreach (var;rhs.scalars.keys) {
				mixin (q{ret[var] }~op~q{= rhs[var];});  
			}
			mixin (q{ret.res }~op~q{= rhs.res;});
			return ret;
		}

		//		AARow applyTo (char op,AARow r) {
		//			enum OPS = ['+','-'];
		//			AARow ar = this;
		//			if (r!is this) {
		//				foreach(var;r.scalars.keys) {
		//					mixin(ForOps!("ar.scalars[var] ","= r.scalars[var]")(OPS));
		//				}
		//				mixin (ForOps!("ar.res ","= r.res")(OPS));
		//			}
		//			return ar;
		//		}

		//		void removeZeroScalars() {
		//			foreach (key;scalars.keys)
		//				if (scalars[key]==0) scalars.remove(key);
		//		}

	}
	
	AARow[] rows;

	@property char[] vars() {
		char[] vars;
		foreach (r;this.rows) {
			foreach (v;r.vars) {
				if (vars.find(v) ==[])
					vars~= v;
			}
		}
		return vars;
	}

		AARow[] getSingleVariableRows() {
			AARow[] res;
			foreach (ref r;rows) {
				if (r.singleVariable) {
					res ~= r;
				}
			}
			return res;
		}

		/*
		 AASystem opBinary(string op) (char op,double val) {
		 AARow[] aars;
		 foreach (r;rows) {
		 aars ~=   r.applyTo(op,val);
		 }
		 return AASystem(aars);
		 }*/

		

		this (AARow[] rs) {
			rows = rs;
		}

		string toString() {
			char[] vstring;
			foreach (r;rows) {
				foreach (i;0 .. r.scalars.length) {
					if (r.scalars.values[i]>0 && i!=0) vstring ~= '+';
					if (r.scalars.values[i]!=1) vstring ~= to!string(r.scalars.values[i]);
					vstring ~= r.scalars.keys[i];
				}
				vstring ~= "=" ~ to!string(r.res) ~ "\n";
			}
			return cast(string)vstring;
		}

	}