import std.stdio;
import std.string;
//import System;
import parseEquationSystem;

void main(string[] args) {
	string[] testInput = 
	["2x=10",
	"2y-c=-6",
	"4y-x+2c=81",
	"7d=7"];
	auto testSystem = getSystem(testInput);
	writeln(testSystem);
	writeln("all used Indentifiers are:",testSystem.allIdentifiers);
	}