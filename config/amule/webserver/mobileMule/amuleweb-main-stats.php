<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1" />
	<title>Statistics - mobileMule</title>
	<link rel="stylesheet" href="http://code.jquery.com/mobile/1.0.1/jquery.mobile-1.0.1.min.css" />
	<link rel="stylesheet" href="mystyle.css" />
	<script src="http://code.jquery.com/jquery-1.6.4.min.js"></script>
	<script src="http://code.jquery.com/mobile/1.0.1/jquery.mobile-1.0.1.min.js"></script>
	<script src="myscript.js"></script>
</head>
<body>
	<div data-role="page" id="stats" class="type-interior">

		<div data-role="header" data-position="inline">
			<a href="#" data-rel="back" data-icon="arrow-l">Back</a>
			<h1>Statistics</h1>
			<a href="#" id="btMenu" class="hideOnDesktop" data-icon="home" onClick="showMenu();">Menu</a>
		</div><!-- /header -->

		<div data-role="content">
			<div class="content-primary">
				<div data-role="collapsible"  data-content-theme="c" data-collapsed="false">
					<h3>Statistics</h3>
					<?php	
					function print_item( $it )
					{
							//echo "<table><tr><th>".$it."</th></tr></table>";
							// must be re-inizialized because $node IS NOT local variabile?!!?! a sort of static or global
							$node = true;
							$node = split(': ', $it, 3);
							echo  "<table><tr><th>".$node[0].'</th><td>'.$node[1].$node[2]."</td></tr></table>";
					}
			
					function print_folder( $key, &$arr )
					{
						echo '<div data-role="collapsible"  data-content-theme="c">';
						echo "<h3>".$key."</h3>";
						
						// child of folder (first sub-level)
						foreach ( $arr as $k => $v )
						{
							if( count( &$v ) ) print_folder( $k, $v );
							else print_item( $k );
						}
						echo '</div>';
					}
					
					function recursiveViewOnStatsTree( &$tree , $nodeName)
					{
						foreach ($tree as $k => $v) {
							if ( count(&$v) ) print_folder($k, $v);
							else print_item($k);
						}
					}
			
					$statsTree = amule_load_vars("stats_tree");
					recursiveViewOnStatsTree($statsTree, $HTTP_GET_VARS['statsnode']);
					?>
				</div>
				<br/>
				<div style="text-align:center;">
					<div data-role="controlgroup" data-type="horizontal">
						<a href="amuleweb-main-stats.php" data-role="button" data-theme="a">collapsible</a>
						<a href="amuleweb-main-stats-list.php" data-role="button">listed</a>
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
						<li data-theme="a"><a href="amuleweb-main-stats.php">Statistics</a></li>
						<li><a href="amuleweb-main-graph.php">Graphs</a></li>
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
</body>
</html>
