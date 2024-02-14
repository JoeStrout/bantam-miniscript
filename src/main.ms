import "importUtil"
ensureImport "lexer"
ensureImport "expressions"
ensureImport "bantamParser"

// test:
//	Parses the given chunk of code and verifies that it matches
//	the expected pretty-printed result.
test = function(source, expected)
	parser = (new BantamParser).init(source)
	result = parser.parseExpression
	if parser.error then
		globals.failed += 1
		print "[FAIL] Expected: " + expected
	else
		actual = result.str
		if expected == actual then
			globals.passed += 1
		else
			globals.failed += 1
			print "[FAIL] Expected: " + expected
			print "         Actual: " + actual
		end if
	end if
end function

runTests = function
    // Function call.
	test "a()", "a()"
	test "a(b)", "a(b)"
	test "a(b, c)", "a(b, c)"
	test "a(b)(c)", "a(b)(c)"
	test "a(b) + c(d)", "(a(b) + c(d))"
	test "a(b ? c : d, e + f)", "a((b ? c : d), (e + f))"
	// Unary precedence.
	test "~!-+a", "(~(!(-(+a))))"
	test "a!!!", "(((a!)!)!)"
	// Unary and binary predecence.
	test "-a * b", "((-a) * b)"
	test "!a + b", "((!a) + b)"
	test "~a ^ b", "((~a) ^ b)"
	test "-a!", "(-(a!))"
	test "!a!", "(!(a!))"
	// Binary precedence.
	test("a = b + c * d ^ e - f / g",
		 "(a = ((b + (c * (d ^ e))) - (f / g)))")
	// Binary associativity.
	test "a = b = c", "(a = (b = c))"
	test "a + b - c", "((a + b) - c)"
	test "a * b / c", "((a * b) / c)"
	test "a ^ b ^ c", "(a ^ (b ^ c))"
	// Conditional operator.
	test "a ? b : c ? d : e", "(a ? b : (c ? d : e))"
	test "a ? b ? c : d : e", "(a ? (b ? c : d) : e)"
	test "a + b ? c * d : e / f", "((a + b) ? (c * d) : (e / f))"
	// Grouping.
	test "a + (b + c) + d", "((a + (b + c)) + d)"
	test "a ^ (b + c)", "(a ^ (b + c))"
	test "(!a)!", "((!a)!)"
	
	// Show the results.
	if not failed then
		print "Passed all " + passed + " tests."
	else
		total = failed + passed
		print "----"
		print "Failed " + failed + " out of " + total + " tests."
	end if
end function

interact = function
	print "Enter an expression to parse, or `quit` to exit."
	while true
		inp = input("$")
		if inp == "quit" or inp == "exit" then break
		p = (new BantamParser).init(inp)
		print p.tokens
		e = p.parseExpression
		if e != null and not p.error then print e.str
	end while
end function

if locals == globals then
	failed = 0
	passed = 0
	runTests
end if
