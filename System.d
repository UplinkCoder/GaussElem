import std.algorithm:map,sort,find;
import std.conv:to;
import std.stdio;

struct AASystem {
    AARow rows[];
    char[] allIdentifiers;

    this (AARow[] aars) {
        rows = aars;
    }
    string toString() {
       
        char[] vstring;
        foreach (row;rows) {
            alias row r;
            foreach (i;0 .. r.vl.length) {
                if (r.vl[r.vl.keys[i]]>0 && i!=0) vstring ~= '+';
                vstring ~= to!string(r.vl[r.vl.keys[i]]) ~ r.vl.keys[i];
            }
            vstring ~= "=" ~ to!string(r.res) ~ "\n";
        }
        return cast(string)vstring;
    }
    
    
}


struct AARow {
    alias int[char] aaType;
    aaType vals;
    alias vals vl;
    int res;
    this (aaType v,int r) {
        vals =v,res=r;
    }
}
