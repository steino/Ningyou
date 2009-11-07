local textile = require"helper.textile"

local input = {
	'*bold*',
	'(tm)',
	'(r)',
	'(c)',
	'--',

	"'test'",
	"It's",
	"I've",
	"'It's a it''",

	"3 x 3 = 3^x + 0",
	"3 x 3 = 3^2",
	"3 x 3 = 3^2^",

	'"Test"',
	'"Test',
	'"Test""',


	"3~3",
	"3~3~",
	"3~a not b",

	"@code@more@",

	'"Hi Thar":http://fake.url',
	'"he said "light":/light"'
}

local output = {
	'<strong>bold</strong>',
	'™',
	'®',
	'©',
	'—',

	'‘test’',
	"It’s",
	"I’ve",
	'‘It’s a it’’',

	"3 × 3 = 3<sup>x</sup> + 0",
	"3 × 3 = 3<sup>2</sup>",
	"3 × 3 = 3<sup>2</sup>",

	"“Test”",
	'"Test',
	'“Test"”',

	"3<sub>3</sub>",
	"3<sub>3</sub>",
	"3<sub>a</sub> not b",

	"<code>code@more</code>",

	'<a href="http://fake.url">Hi Thar</a>',
	'“he said <a href="/light">light</a>”'
}

local failed, passed = 0, 0
for test, data in ipairs(input) do
	local out = textile(data)[1].content
	local valid = out == output[test]
	if(valid) then
		passed = passed + 1

		io.write(string.format("Test #%02d: %s\n", test, '\27[1;32mPassed\27[00m'))
	else
		failed = failed + 1

		io.write(string.format("Test #%02d: %s", test, '\27[1;31mFailed\27[00m'), '\t', string.format('Got [%s] expected [%s]', out, output[test]), '\n')
	end
end
