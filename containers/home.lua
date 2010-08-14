ningyou.template = "default"

tags.Register("menu", function() return [[
	<ul>
	<li><a href="#">Home</a></li>
	</ul>
	]] end)
tags.Register("header", function() return "<h1 id=\"title\">Ningyou</h1>" end)
tags.Register("title", function() return "Ningyou" end)
tags.Register("css", function() return "" end)
tags.Register("content", function() return "<a>Coming soon&#153;</a>" end)
