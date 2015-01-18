<!DOCTYPE html>
<html>
<head>
	<title>Forest to Farm</title>
	<link rel="stylesheet" type="text/css" href="/styles/forest.css" />
	<script src="scripts/library/require.js" data-main="scripts/bootstrap"></script>
</head>
<body>
<div id="templates">
	<li id="display-box-template" class="display-box" >
		<a class="box-link" href="/"></a>
		<div class="title-box">
			<a href="">
				<%- common_name %>
			</a>
			<span class="sub-title">
				<%- genus %> <%- species %>
			</span>
		</div>
		<div class="left">
			<p class="left-text"></p>
			<span class="left-description"></span>
		</div>
		<div class="center">
			<p class="center-text"><%- zones %></p>
			<span class="center-description"></span>
		</div>
		<div class="right">
			<p class="right-text"></p>
			<span class="right-description"></span>
		</div>
	</li>
</div>
<div id="header">
    <div id="logo"><a href="/">Forest to Farm</a></div>
	<div class="clear"></div>
</div>
<div id="main">
	<ul id="plants">

	</ul>
</div>
<div id="footer" >

</div>
</body>
</html>


