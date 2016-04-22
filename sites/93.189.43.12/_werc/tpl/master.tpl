<!doctype html>
<html>
	<head>
		<title>%($pageTitle%)</title>
		<meta charset="UTF-8"> 
		<style type="text/css">
body {
	background-color: #202020;
	color: #bbbbbb;
	font-family: monospace;
	font-size: 12pt;
	padding: 0;
	margin: 0;
}

#header {
	clear: both;
	padding: 5px 10px 20px 10px;
}

#headertitle {
	color: #3465a4;
	font-size: 2em;
}

#headerinfo {
	color: #777777;
	font-size: 0.8em;
	float: right;
}

#content {
	clear: both;
	overflow: hidden;
}

.block {
	display: inline-block;
	float: left;
	margin: 0px 0px 20px 10px;
}

.block-header {
	color: #eeeeec;
	font-size: 1.1em;
	margin-bottom: 10px;
}
	</style> 
	</head> 
	<body>
		<div id="header">
			<span id="headertitle">%($"siteTitle%)</span>
			<span id="headerinfo">2015-2016 yumi development server | quark &amp; swerc powered</span>
		</div>
		<div id="content">
% run_handler $handler_body_main
		</div>
	</body>
</html>

