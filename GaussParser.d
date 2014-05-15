/++
This module was automatically generated from the following grammar:


    GaussGrammar:

    Formula  <  (:'+'? LeftSideElement)+ '=' RightSideElement
    
   
    LeftSideElement <- Number Letter /
                       ~(Minus? Letter) 
    RightSideElement <- Number
   
    Minus     <- '-'     
    
    Number <~ Minus? ~Digit+ 
    Digit   <- [0-9]
    Letter <- [a-z]


+/
module GaussParser;

public import pegged.peg;
import std.algorithm: startsWith;
import std.functional: toDelegate;

struct GenericGaussGrammar(TParseTree)
{
    import pegged.dynamic.grammar;
    struct GaussGrammar
    {
    enum name = "GaussGrammar";
    static ParseTree delegate(ParseTree)[string] before;
    static ParseTree delegate(ParseTree)[string] after;
    static ParseTree delegate(ParseTree)[string] rules;

    static this()
    {
        rules["Formula"] = toDelegate(&GaussGrammar.Formula);
        rules["LeftSideElement"] = toDelegate(&GaussGrammar.LeftSideElement);
        rules["RightSideElement"] = toDelegate(&GaussGrammar.RightSideElement);
        rules["Minus"] = toDelegate(&GaussGrammar.Minus);
        rules["Number"] = toDelegate(&GaussGrammar.Number);
        rules["Digit"] = toDelegate(&GaussGrammar.Digit);
        rules["Letter"] = toDelegate(&GaussGrammar.Letter);
        rules["Spacing"] = toDelegate(&GaussGrammar.Spacing);
   }

    template hooked(alias r, string name)
    {
        static ParseTree hooked(ParseTree p)
        {
            ParseTree result;

            if (name in before)
            {
                result = before[name](p);
                if (result.successful)
                    return result;
            }

            result = r(p);
            if (result.successful || name !in after)
                return result;

            result = after[name](p);
            return result;
        }

        static ParseTree hooked(string input)
        {
            return hooked!(r, name)(ParseTree("",false,[],input));
        }
    }

    static void addRuleBefore(string parentRule, string ruleSyntax)
    {
        // enum name is the current grammar name
        DynamicGrammar dg = pegged.dynamic.grammar.grammar(name ~ ": " ~ ruleSyntax, rules);
        foreach(ruleName,rule; dg.rules)
            if (ruleName != "Spacing") // Keep the local Spacing rule, do not overwrite it
                rules[ruleName] = rule;
        before[parentRule] = rules[dg.startingRule];
    }

    static void addRuleAfter(string parentRule, string ruleSyntax)
    {
        // enum name is the current grammar named
        DynamicGrammar dg = pegged.dynamic.grammar.grammar(name ~ ": " ~ ruleSyntax, rules);
        foreach(name,rule; dg.rules)
        {
            if (name != "Spacing")
                rules[name] = rule;
        }
        after[parentRule] = rules[dg.startingRule];
    }

    static bool isRule(string s)
    {
        return s.startsWith("GaussGrammar.");
    }
    import std.typecons:Tuple, tuple;
    static TParseTree[Tuple!(string, size_t)] memo;
    mixin decimateTree;
    alias spacing Spacing;

    static TParseTree Formula(TParseTree p)
    {
        if(__ctfe)
        {
            return         pegged.peg.named!(pegged.peg.and!(pegged.peg.oneOrMore!(pegged.peg.wrapAround!(Spacing, pegged.peg.and!(pegged.peg.discard!(pegged.peg.option!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("+"), Spacing))), pegged.peg.wrapAround!(Spacing, LeftSideElement, Spacing)), Spacing)), pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("="), Spacing), pegged.peg.wrapAround!(Spacing, RightSideElement, Spacing)), "GaussGrammar.Formula")(p);
        }
        else
        {
            if(auto m = tuple(`Formula`,p.end) in memo)
                return *m;
            else
            {
                TParseTree result = hooked!(pegged.peg.named!(pegged.peg.and!(pegged.peg.oneOrMore!(pegged.peg.wrapAround!(Spacing, pegged.peg.and!(pegged.peg.discard!(pegged.peg.option!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("+"), Spacing))), pegged.peg.wrapAround!(Spacing, LeftSideElement, Spacing)), Spacing)), pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("="), Spacing), pegged.peg.wrapAround!(Spacing, RightSideElement, Spacing)), "GaussGrammar.Formula"), "Formula")(p);
                memo[tuple(`Formula`,p.end)] = result;
                return result;
            }
        }
    }

    static TParseTree Formula(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.named!(pegged.peg.and!(pegged.peg.oneOrMore!(pegged.peg.wrapAround!(Spacing, pegged.peg.and!(pegged.peg.discard!(pegged.peg.option!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("+"), Spacing))), pegged.peg.wrapAround!(Spacing, LeftSideElement, Spacing)), Spacing)), pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("="), Spacing), pegged.peg.wrapAround!(Spacing, RightSideElement, Spacing)), "GaussGrammar.Formula")(TParseTree("", false,[], s));
        }
        else
        {
            memo = null;
            return hooked!(pegged.peg.named!(pegged.peg.and!(pegged.peg.oneOrMore!(pegged.peg.wrapAround!(Spacing, pegged.peg.and!(pegged.peg.discard!(pegged.peg.option!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("+"), Spacing))), pegged.peg.wrapAround!(Spacing, LeftSideElement, Spacing)), Spacing)), pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("="), Spacing), pegged.peg.wrapAround!(Spacing, RightSideElement, Spacing)), "GaussGrammar.Formula"), "Formula")(TParseTree("", false,[], s));
        }
    }
    static string Formula(GetName g)
    {
        return "GaussGrammar.Formula";
    }

    static TParseTree LeftSideElement(TParseTree p)
    {
        if(__ctfe)
        {
            return         pegged.peg.named!(pegged.peg.or!(pegged.peg.and!(Number, Letter), pegged.peg.fuse!(pegged.peg.and!(pegged.peg.option!(Minus), Letter))), "GaussGrammar.LeftSideElement")(p);
        }
        else
        {
            if(auto m = tuple(`LeftSideElement`,p.end) in memo)
                return *m;
            else
            {
                TParseTree result = hooked!(pegged.peg.named!(pegged.peg.or!(pegged.peg.and!(Number, Letter), pegged.peg.fuse!(pegged.peg.and!(pegged.peg.option!(Minus), Letter))), "GaussGrammar.LeftSideElement"), "LeftSideElement")(p);
                memo[tuple(`LeftSideElement`,p.end)] = result;
                return result;
            }
        }
    }

    static TParseTree LeftSideElement(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.named!(pegged.peg.or!(pegged.peg.and!(Number, Letter), pegged.peg.fuse!(pegged.peg.and!(pegged.peg.option!(Minus), Letter))), "GaussGrammar.LeftSideElement")(TParseTree("", false,[], s));
        }
        else
        {
            memo = null;
            return hooked!(pegged.peg.named!(pegged.peg.or!(pegged.peg.and!(Number, Letter), pegged.peg.fuse!(pegged.peg.and!(pegged.peg.option!(Minus), Letter))), "GaussGrammar.LeftSideElement"), "LeftSideElement")(TParseTree("", false,[], s));
        }
    }
    static string LeftSideElement(GetName g)
    {
        return "GaussGrammar.LeftSideElement";
    }

    static TParseTree RightSideElement(TParseTree p)
    {
        if(__ctfe)
        {
            return         pegged.peg.named!(Number, "GaussGrammar.RightSideElement")(p);
        }
        else
        {
            if(auto m = tuple(`RightSideElement`,p.end) in memo)
                return *m;
            else
            {
                TParseTree result = hooked!(pegged.peg.named!(Number, "GaussGrammar.RightSideElement"), "RightSideElement")(p);
                memo[tuple(`RightSideElement`,p.end)] = result;
                return result;
            }
        }
    }

    static TParseTree RightSideElement(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.named!(Number, "GaussGrammar.RightSideElement")(TParseTree("", false,[], s));
        }
        else
        {
            memo = null;
            return hooked!(pegged.peg.named!(Number, "GaussGrammar.RightSideElement"), "RightSideElement")(TParseTree("", false,[], s));
        }
    }
    static string RightSideElement(GetName g)
    {
        return "GaussGrammar.RightSideElement";
    }

    static TParseTree Minus(TParseTree p)
    {
        if(__ctfe)
        {
            return         pegged.peg.named!(pegged.peg.literal!("-"), "GaussGrammar.Minus")(p);
        }
        else
        {
            if(auto m = tuple(`Minus`,p.end) in memo)
                return *m;
            else
            {
                TParseTree result = hooked!(pegged.peg.named!(pegged.peg.literal!("-"), "GaussGrammar.Minus"), "Minus")(p);
                memo[tuple(`Minus`,p.end)] = result;
                return result;
            }
        }
    }

    static TParseTree Minus(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.named!(pegged.peg.literal!("-"), "GaussGrammar.Minus")(TParseTree("", false,[], s));
        }
        else
        {
            memo = null;
            return hooked!(pegged.peg.named!(pegged.peg.literal!("-"), "GaussGrammar.Minus"), "Minus")(TParseTree("", false,[], s));
        }
    }
    static string Minus(GetName g)
    {
        return "GaussGrammar.Minus";
    }

    static TParseTree Number(TParseTree p)
    {
        if(__ctfe)
        {
            return         pegged.peg.named!(pegged.peg.fuse!(pegged.peg.and!(pegged.peg.option!(Minus), pegged.peg.fuse!(pegged.peg.oneOrMore!(Digit)))), "GaussGrammar.Number")(p);
        }
        else
        {
            if(auto m = tuple(`Number`,p.end) in memo)
                return *m;
            else
            {
                TParseTree result = hooked!(pegged.peg.named!(pegged.peg.fuse!(pegged.peg.and!(pegged.peg.option!(Minus), pegged.peg.fuse!(pegged.peg.oneOrMore!(Digit)))), "GaussGrammar.Number"), "Number")(p);
                memo[tuple(`Number`,p.end)] = result;
                return result;
            }
        }
    }

    static TParseTree Number(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.named!(pegged.peg.fuse!(pegged.peg.and!(pegged.peg.option!(Minus), pegged.peg.fuse!(pegged.peg.oneOrMore!(Digit)))), "GaussGrammar.Number")(TParseTree("", false,[], s));
        }
        else
        {
            memo = null;
            return hooked!(pegged.peg.named!(pegged.peg.fuse!(pegged.peg.and!(pegged.peg.option!(Minus), pegged.peg.fuse!(pegged.peg.oneOrMore!(Digit)))), "GaussGrammar.Number"), "Number")(TParseTree("", false,[], s));
        }
    }
    static string Number(GetName g)
    {
        return "GaussGrammar.Number";
    }

    static TParseTree Digit(TParseTree p)
    {
        if(__ctfe)
        {
            return         pegged.peg.named!(pegged.peg.charRange!('0', '9'), "GaussGrammar.Digit")(p);
        }
        else
        {
            if(auto m = tuple(`Digit`,p.end) in memo)
                return *m;
            else
            {
                TParseTree result = hooked!(pegged.peg.named!(pegged.peg.charRange!('0', '9'), "GaussGrammar.Digit"), "Digit")(p);
                memo[tuple(`Digit`,p.end)] = result;
                return result;
            }
        }
    }

    static TParseTree Digit(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.named!(pegged.peg.charRange!('0', '9'), "GaussGrammar.Digit")(TParseTree("", false,[], s));
        }
        else
        {
            memo = null;
            return hooked!(pegged.peg.named!(pegged.peg.charRange!('0', '9'), "GaussGrammar.Digit"), "Digit")(TParseTree("", false,[], s));
        }
    }
    static string Digit(GetName g)
    {
        return "GaussGrammar.Digit";
    }

    static TParseTree Letter(TParseTree p)
    {
        if(__ctfe)
        {
            return         pegged.peg.named!(pegged.peg.charRange!('a', 'z'), "GaussGrammar.Letter")(p);
        }
        else
        {
            if(auto m = tuple(`Letter`,p.end) in memo)
                return *m;
            else
            {
                TParseTree result = hooked!(pegged.peg.named!(pegged.peg.charRange!('a', 'z'), "GaussGrammar.Letter"), "Letter")(p);
                memo[tuple(`Letter`,p.end)] = result;
                return result;
            }
        }
    }

    static TParseTree Letter(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.named!(pegged.peg.charRange!('a', 'z'), "GaussGrammar.Letter")(TParseTree("", false,[], s));
        }
        else
        {
            memo = null;
            return hooked!(pegged.peg.named!(pegged.peg.charRange!('a', 'z'), "GaussGrammar.Letter"), "Letter")(TParseTree("", false,[], s));
        }
    }
    static string Letter(GetName g)
    {
        return "GaussGrammar.Letter";
    }

    static TParseTree opCall(TParseTree p)
    {
        TParseTree result = decimateTree(Formula(p));
        result.children = [result];
        result.name = "GaussGrammar";
        return result;
    }

    static TParseTree opCall(string input)
    {
        if(__ctfe)
        {
            return GaussGrammar(TParseTree(``, false, [], input, 0, 0));
        }
        else
        {
            memo = null;
            return GaussGrammar(TParseTree(``, false, [], input, 0, 0));
        }
    }
    static string opCall(GetName g)
    {
        return "GaussGrammar";
    }

    }
}

alias GenericGaussGrammar!(ParseTree).GaussGrammar GaussGrammar;

