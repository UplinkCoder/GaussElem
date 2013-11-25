import std.algorithm:map,sort,find;
import std.conv:to;
import std.stdio;

struct AASystem {
    AARow rows[];
    char[] allIdentifiers;

    this (AARow[] aars) {
        rows = aars;
    }
}


struct AARow {
    alias int[char] aaType;
    aaType val;
    int res;
    this (aaType v,int r) {
        val =v,res=r;
    }
}
