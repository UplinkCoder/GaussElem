module forops;
/** 
 * is a way to generate sourcecode for runtime evaluated opBinary thingys :D
 * for Example :
 * ForOps!("v1 ","= v",v2 ",= vx]);
 * would generate : 
 * switch (op) {
 * 	case '+' :
 * 		v1 += v;
 * 		v2 += v;
 * 	break();
 * 	case '-" : 
 * 		v1 -= vx;
 * 		v2 -= vx;
 * 	break();
 * ...
 *   default : assert(0);
 * }
 */ 

static string ForOps(C...)(char[] OPS = ['+','-','*','/']) pure 
	// guard makes reasonalby sure that op Binary thingys are done :D
	if (is(typeof(C[0])==string) && C.length%2==0 && is(typeof(C[$-1])==string))
{
	import ctiota;
	import std.range;

	enum ar = Iota!(0,C.length,2);
	
	Appender!string res = cast(char[])"switch (op) {\n";
	
	foreach (char op;OPS) {
		res ~= "\tcase '"~op~"' : \n";
		foreach(i;ar) {
			res~="\t\t"~C[i]~op~C[i+1]~";\n";
		}
		res~="\tbreak;\n";
	}
	res ~= "\tdefault: \n";
	res ~= "\t\t assert(0,\"forops Error :\\n\\t operator \"~op~\" not Implemented\");";
	return res.data~"}";
}