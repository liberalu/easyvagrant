<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Easy vagrant</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css" integrity="sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r" crossorigin="anonymous">
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
    </head>
    <body>
        <div class="container theme-showcase" role="main">
            <div class="page-header">
                <h2>Links</h2>
            </div>
            <div class="row">
                <div class="col-md-4"><strong>Web page</strong></br /><a target="_blank" href="http://webpage.local.dev">http://webpage.local.dev</a></div>
                <div class="col-md-4"><strong>phpinfo()</strong></br /><a target="_blank" href="http://phpinfo.local.dev">http://phpinfo.local.dev</a></div>
                <div class="col-md-4"><strong>Git review</strong></br /><a target="_blank" href="http://git.local.dev">http://git.local.dev</a></div>
            </div>
            <div class="row">
                <div class="col-md-4"><strong>Webgrind</strong></br /><a target="_blank" href="http://webgrind.local.dev">http://webgrind.local.dev</a></div>
                <div class="col-md-4"><strong>phpMyAdmin</strong></br /><a target="_blank" href="http://phpmyadmin.local.dev">http://phpmyadmin.local.dev</a></div>
                <div class="col-md-4"><strong>Logs</strong></br /><a target="_blank" href="http://192.168.33.10:8080">http://192.168.33.10:8080</a></div>
            </div>
            <div class="page-header">
                <h2>Services</h2>
            </div>
            <div class="row">
                <div class="col-md-6">MySQL serivice status
                    <?php if (strpos(shell_exec("service mysql status 2>&1"), "running") === null) : ?>
                        STOP
                    <?php else : ?>
                        RUN
                    <?php endif; ?>
                </div>
            </div>
        </div>
    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>
  </body>
</html>
