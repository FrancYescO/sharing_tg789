<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1" />
	<title>Graphs - mobileMule</title>
	<link rel="stylesheet" href="http://code.jquery.com/mobile/1.0.1/jquery.mobile-1.0.1.min.css" />
	<link rel="stylesheet" href="mystyle.css" />
	<script src="http://code.jquery.com/jquery-1.6.4.min.js"></script>
	<script src="http://code.jquery.com/mobile/1.0.1/jquery.mobile-1.0.1.min.js"></script>
	<script src="myscript.js"></script>
</head>
	<?php amule_load_vars("stats_graph"); ?>
<body>
	<div data-role="page" id="graphs" class="type-interior">

		<div data-role="header" data-position="inline">
			<a href="#" data-rel="back" data-icon="arrow-l">Back</a>
			<h1>Graphs</h1>
			<a href="#" id="btMenu" class="hideOnDesktop" data-icon="home" onClick="showMenu();">Menu</a>
		</div><!-- /header -->

		<div data-role="content">
			<div class="content-primary">
				<div data-role="collapsible-set">
					<div data-role="collapsible"  data-content-theme="c" data-collapsed="false">
						<h3>Download-Speed</h3>
						<img src="amule_stats_download.png" width="100%" border="0" />
					</div>
					<div data-role="collapsible"  data-content-theme="c">
						<h3>Upload-Speed</h3>
			        	<img src="amule_stats_upload.png" width="100%" border="0" />
			        </div>
			        <div data-role="collapsible"  data-content-theme="c">
			      		<h3>Connections</h3>
			          	<img src="amule_stats_conncount.png" width="100%" border="0" />
			        </div>
		        </div>
			</div>
			<!--/content-primary -->

			<div class="content-secondary">
				<div class="menu" data-role="collapsible" data-collapsed="true" data-theme="b" data-content-theme="d">
					<h3>Menu</h3>
					<ul data-role="listview" data-theme="c" data-dividertheme="d" data-inset="true">
						<li><a href="amuleweb-main-status.php">Status</a></li>
						<li><a href="amuleweb-main-dload-real.php">Downloads</a></li>
						<li><a href="amuleweb-main-upload.php">Uploads</a></li>
						<li><a href="amuleweb-main-search.php">Search</a></li>
						<li><a href="amuleweb-main-prefs.php">Configurations</a></li>
						<li><a href="amuleweb-main-stats.php">Statistics</a></li>
						<li data-theme="a"><a href="amuleweb-main-graph.php">Graphs</a></li>
						<li><a href="amuleweb-main-log.php">Log</a></li>
						<li><a href="footer.php">Add ed2k</a></li>
						<li><a href="login.php">Logout</a></li>
					</ul>
				</div>
				<a href="#" id="btScrollUp" class="hideOnDesktop" data-role="button" data-icon="arrow-u" data-iconpos="right" onClick="scrollUp();">scroll up</a>
			</div>
		</div>
		<!-- /content -->

		<div data-role="footer" data-theme="c">
			<p>&nbsp;<a href="amuleweb-main-about.php" title="about" data-rel="dialog">mobileMule</a> &copy; 2011-12</p>
		</div>
		<!-- /footer -->
	</div>
	<!-- /page -->

	<script>
            //App custom javascript
        </script>
</body>
</html>