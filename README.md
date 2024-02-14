# bantam-miniscript
[MiniScript](https://miniscript.org) port of [Bantam](https://github.com/munificent/bantam), a [Pratt parser](https://journal.stuffwithstuff.com/2011/03/19/pratt-parsers-expression-parsing-made-easy/) demo by [Bob Nystrom](https://journal.stuffwithstuff.com)

## What's all this, then?

[Bantam](https://github.com/munificent/bantam) is a toy language created by [Bob Nystrom](https://journal.stuffwithstuff.com) to demonstrate [Pratt parsing](https://journal.stuffwithstuff.com/2011/03/19/pratt-parsers-expression-parsing-made-easy/) — an approach to parsing (computer) languages in which little mini-parsers (or "parselets" as he calls them) are each responsible for one type of statement or sub-expression.

Read more about it in my blog post, [Pratt Parsing in MiniScript](https://dev.to/joestrout/pratt-parsing-in-miniscript-1m6o).
And for more background and explanation, certainly read [Bob's blog post](https://journal.stuffwithstuff.com/2011/03/19/pratt-parsers-expression-parsing-made-easy/).

## Running the code

You can run the code in [Mini Micro](https://miniscript.org/).  

1. Clone or download the code from this repo to your local hard drive.
2. Download [Mini Micro](https://miniscript.org/), if you don't have it already.  Launch it.
3. Click the top disk slot (bottom-left corner of the window), choose "Mount Folder", and mount the "src" folder from this repo.
4. Type `run "main"` and press return/enter.

The code should show "Passed all 24 tests."  That means it worked!

If you like, you can now type `interact` to enter a sort of interactive REPL mode.  Type an expression at the `$` prompt, and it will show you how it is parsed.  For example, enter "a+b*c", and it will print `(a + (b * c))`. 

You can also get it to run in [command-line MiniScript](https://miniscript.org/cmdline/), but it will take a bit more work: (1) add [importUtil.ms](https://github.com/JoeStrout/minimicro-sysdisk/blob/master/sys/lib/importUtil.ms) to your `lib` folder, if you don't have it already; and (2) either ensure that `.` (the current directory) is in your `MS_IMPORT_PATH`, or move all the files except `main.ms` into a `lib` subfolder.
